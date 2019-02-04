$files = Get-ChildItem *.dll

function getAssemblyBindingRedirect([string] $target)
{
    $fullname = [System.Reflection.AssemblyName]::GetAssemblyName($target).FullName

    $parts = $fullname -split ',' | % { $_.Trim() } | % { $_ -replace 'PublicKeyToken=','' } | % { $_ -replace 'Culture=', '' } | % { $_ -replace 'Version=','' }

    return @"
<dependentAssembly>
    <assemblyIdentity name="$($parts[0])" publicKeyToken="$($parts[3])" culture="$($parts[2])" />
    <bindingRedirect oldVersion="0.0.0.0-65535.65535.65535.65535" newVersion="$($parts[1])" />
</dependentAssembly>
"@
}

$content = $files | Sort-Object | % { getAssemblyBindingRedirect($_) } 

$content -join [System.Environment]::NewLine