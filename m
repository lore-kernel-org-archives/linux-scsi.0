From: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3] [SCSI] mpt2sas, mpt3sas: Abort initialization if no
 memory I/O resources detected
Date: Wed, 15 Jul 2015 15:59:44 -0500
Message-ID: <20150715205944.GB25591@google.com>
References: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1436935796-28995-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: tpearson@raptorengineeringinc.com, jejb@kernel.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 15, 2015 at 10:19:56AM +0530, Sreekanth Reddy wrote:
> Driver crashes if the BIOS do not set up at least one
> memory I/O resource. This failure can happen if the device is too
> slow to respond during POST and is missed by the BIOS, but Linux
> then detects the device later in the boot process.
> 
> Changes in v3:
>    Rearranged the code to remove the code redundancy
> 
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_base.c | 16 +++++++++-------
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 16 +++++++++-------
>  2 files changed, 18 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index 11248de..6dec7cf 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1557,7 +1557,8 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
>  		goto out_fail;
>  	}
>  
> -	for (i = 0, memap_sz = 0, pio_sz = 0 ; i < DEVICE_COUNT_RESOURCE; i++) {
> +	for (i = 0, memap_sz = 0, pio_sz = 0; (i < DEVICE_COUNT_RESOURCE) &&
> +	     (!memap_sz || !pio_sz); i++) {
>  		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
>  			if (pio_sz)
>  				continue;
> @@ -1572,16 +1573,17 @@ mpt2sas_base_map_resources(struct MPT2SAS_ADAPTER *ioc)
>  				chip_phys = (u64)ioc->chip_phys;
>  				memap_sz = pci_resource_len(pdev, i);
>  				ioc->chip = ioremap(ioc->chip_phys, memap_sz);
> -				if (ioc->chip == NULL) {
> -					printk(MPT2SAS_ERR_FMT "unable to map "
> -					    "adapter memory!\n", ioc->name);
> -					r = -EINVAL;
> -					goto out_fail;
> -				}
>  			}
>  		}
>  	}
>  
> +	if (ioc->chip == NULL) {
> +		printk(MPT2SAS_ERR_FMT "unable to map adapter memory! "
> +		       "or resource not found\n", ioc->name);
> +		r = -EINVAL;
> +		goto out_fail;
> +	}

  - Before this patch, the driver probe succeeds even if it can't find an
    MMIO resource.  That means we would eventually dereference ioc->chip,
    which is zero.  This patch definitely fixes that bug.

  - I raise my eyebrows a little at the "let's use the first MMIO resource
    we find" idea.  A driver should know exactly which BAR it needs, so it
    seems sloppy to search this way.  And it's possible that BIOS or the
    PCI core set up *one* MMIO BAR, but not the one the driver needs.  Then
    the search will find the wrong BAR and the driver won't work.

  - These drivers both do:

      ioc->chip_phys = pci_resource_start(pdev, i);
      ioc->chip = ioremap(ioc->chip_phys, memap_sz);

    Saving ioc->chip_phys is pointless because it's only used to guard
    iounmap(ioc->chip), and the driver probe should fail if it can't find
    an MMIO resource, so the places that do the iounmap can assume
    ioc->chip is always valid.

  - These drivers also search for an I/O resource, but they don't actually
    use it, except to print it out.  I guess that's harmless, but it seems
    sloppy and will print junk on machines where there's no I/O space
    available.  They do use pci_enable_device_mem(), so at least the device
    should work even if no I/O space is available.

  - It'd be nice if they used dev_printk() and %pR instead of their ad hoc
    formatting.

>  	_base_mask_interrupts(ioc);
>  
>  	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 14a781b..43f87e9 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1843,7 +1843,8 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>  		goto out_fail;
>  	}
>  
> -	for (i = 0, memap_sz = 0, pio_sz = 0 ; i < DEVICE_COUNT_RESOURCE; i++) {
> +	for (i = 0, memap_sz = 0, pio_sz = 0; (i < DEVICE_COUNT_RESOURCE) &&
> +	     (!memap_sz || !pio_sz); i++) {
>  		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
>  			if (pio_sz)
>  				continue;
> @@ -1856,15 +1857,16 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>  			chip_phys = (u64)ioc->chip_phys;
>  			memap_sz = pci_resource_len(pdev, i);
>  			ioc->chip = ioremap(ioc->chip_phys, memap_sz);
> -			if (ioc->chip == NULL) {
> -				pr_err(MPT3SAS_FMT "unable to map adapter memory!\n",
> -					ioc->name);
> -				r = -EINVAL;
> -				goto out_fail;
> -			}
>  		}
>  	}
>  
> +	if (ioc->chip == NULL) {
> +		pr_err(MPT3SAS_FMT "unable to map adapter memory! "
> +			" or resource not found\n", ioc->name);
> +		r = -EINVAL;
> +		goto out_fail;
> +	}
> +
>  	_base_mask_interrupts(ioc);
>  
>  	r = _base_get_ioc_facts(ioc, CAN_SLEEP);
> -- 
> 2.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
