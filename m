From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2 RESEND 16/23] mpt3sas: Use pci_enable_msix_exact()
 instead of pci_enable_msix()
Date: Mon, 11 Aug 2014 15:07:39 +0200
Message-ID: <53E8C01B.4060607@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com> <76ec123596e05dcbcd8957f00ad5f8d4627a32d0.1405533479.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <76ec123596e05dcbcd8957f00ad5f8d4627a32d0.1405533479.git.agordeev@redhat.com>
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/16/2014 08:05 PM, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.
>
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
> Cc: support@lsi.com
> Cc: DL-MPTFusionLinux@lsi.com
> Cc: linux-scsi@vger.kernel.org
> Cc: linux-pci@vger.kernel.org

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 0cf4f70..7b65ec2 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1747,10 +1747,10 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>  	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
>  		a->entry = i;
>  
> -	r = pci_enable_msix(ioc->pdev, entries, ioc->reply_queue_count);
> +	r = pci_enable_msix_exact(ioc->pdev, entries, ioc->reply_queue_count);
>  	if (r) {
>  		dfailprintk(ioc, pr_info(MPT3SAS_FMT
> -			"pci_enable_msix failed (r=%d) !!!\n",
> +			"pci_enable_msix_exact failed (r=%d) !!!\n",
>  			ioc->name, r));
>  		kfree(entries);
>  		goto try_ioapic;
