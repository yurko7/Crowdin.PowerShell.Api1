function Update-File
{
    [CmdletBinding(DefaultParameterSetName = 'AccountKey')]
    param (
        [Parameter(Mandatory)]
        [string]$ProjectId,

        [Parameter(Mandatory, ParameterSetName = 'ProjectKey')]
        [Alias('key')]
        [string]$ProjectKey,

        [Parameter(Mandatory, ParameterSetName = 'AccountKey')]
        [Alias('login')]
        [string]$LoginName,

        [Parameter(Mandatory, ParameterSetName = 'AccountKey')]
        [Alias('account-key')]
        [string]$AccountKey,

        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        $File,

        [Parameter()]
        [string]$Title,

        [Parameter()]
        [string]$ExportPattern,

        [Parameter()]
        [string]$NewName,

        [Parameter()]
        [Alias('first_line_contains_header')]
        [switch]$FirstLineContainsHeader,

        [Parameter()]
        [string]$Scheme,

        [Parameter()]
        [Alias('update_option')]
        [ValidateSet('update_as_unapproved', 'update_without_changes')]
        [string]$UpdateOption,

        [Parameter()]
        [string]$Branch,

        [Parameter()]
        [Alias('escape_quotes')]
        [ValidateRange(0, 3)]
        [int]$EscapeQuotes
    )

    $ProjectId = [Uri]::EscapeDataString($ProjectId)
    $body = [pscustomobject]@{
        "files[$Name]" = $File
    }
    if ($PSBoundParameters.ContainsKey('Title'))
    {
        $body | Add-Member "titles[$Name]" $Title
    }
    if ($PSBoundParameters.ContainsKey('ExportPattern'))
    {
        $body | Add-Member "export_patterns[$Name]" $ExportPattern
    }
    if ($PSBoundParameters.ContainsKey('NewName'))
    {
        $body | Add-Member "new_names[$Name]" $NewName
    }
    $body = $PSCmdlet |
        ConvertFrom-PSCmdlet -TargetObject $body -ExcludeParameter ProjectId,Name,File,Title,ExportPattern,NewName |
        Resolve-File -FileProperty "files[$Name]"
    Invoke-ApiRequest -Url "project/$ProjectId/update-file?json" -Body $body
}