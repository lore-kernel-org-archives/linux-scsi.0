From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v3 08/13] be2iscsi: Use pci_enable_msix_range()
Date: Thu, 21 Aug 2014 13:10:15 +0200
Message-ID: <53F5D397.2020508@redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com> <1cf2c3d3243067edac8d170cda0450c82bbfc025.1408335523.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1cf2c3d3243067edac8d170cda0450c82bbfc025.1408335523.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/18/2014 08:01 AM, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

Patch looks good to me.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/scsi/be2iscsi/be_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 915c26b..b422659 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5276,9 +5276,9 @@ static void beiscsi_msix_enable(struct beiscsi_hba *phba)
>  	for (i = 0; i <= phba->num_cpus; i++)
>  		phba->msix_entries[i].entry = i;
>  
> -	status = pci_enable_msix(phba->pcidev, phba->msix_entries,
> -				 (phba->num_cpus + 1));
> -	if (!status)
> +	status = pci_enable_msix_range(phba->pcidev, phba->msix_entries,
> +				       phba->num_cpus + 1, phba->num_cpus + 1);
> +	if (status > 0)
>  		phba->msix_enabled = true;
>  
>  	return;
