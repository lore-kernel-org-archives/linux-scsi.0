From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] aic7xxx: move to dma_get_required_mask() and correct 39 bit assumptions
Date: Tue, 30 Aug 2005 15:13:15 -0700 (PDT)
Message-ID: <20050830221316.98368.qmail@web51608.mail.yahoo.com>
References: <1125420487.5037.27.camel@mulgrave>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web51608.mail.yahoo.com ([206.190.38.213]:32644 "HELO
	web51608.mail.yahoo.com") by vger.kernel.org with SMTP
	id S932449AbVH3WNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Aug 2005 18:13:20 -0400
In-Reply-To: <1125420487.5037.27.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Dave Jones <davej@redhat.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, luben_tuikov@adaptec.com

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:

> This patch moves aic7xxx over to the dma_get_required_mask() API and
> dumps its open coded memory check.
> 
> It also appears from this bug:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=167049
> 
> That 39 bit addressing doesn't work on older cards.  I surmise that the
> AHC_LARGE_SCBS flag is the one that marks cards capable of using 39 bit
> addressing, so I also folded that check into the code.
> 
> Luben, since you have access to the docs, could you confirm this guess.

AHC_LARGE_SCBS means that the card can take 64 byte hardware SCBs.
Normally HSCBs are 32 bytes for older controllers.  Latter aic78xx and
all aic79xx chips support 64 byte HSCBs.  So this isn't related.

To fix this bug, you should only have to substitute
           ahc_linux_get_memsize() > 0x80000000
with
           dma_get_required_mask(dev) > DMA_32BIT_MASK,
to fix this issue (unless of course the kernel is confused too ;-) ).

All that the controller cares is if it will have to use 39 bits
to do DMA.  You want to set the DMA mask accordingly to how much
memory will have to be addressed _and_ where it will have to be
addressed.

You may also want to use Intel's PAE (64 MB) for doing that kind of
memory remap.

      Luben

> 
> Dave, could you see if this fixes the problem for the bug reporter.
> 
> James
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1036,15 +1036,6 @@ ahc_linux_register_host(struct ahc_softc
>  	return (0);
>  }
>  
> -uint64_t
> -ahc_linux_get_memsize(void)
> -{
> -	struct sysinfo si;
> -
> -	si_meminfo(&si);
> -	return ((uint64_t)si.totalram << PAGE_SHIFT);
> -}
> -
>  /*
>   * Place the SCSI bus into a known state by either resetting it,
>   * or forcing transfer negotiations on the next command to any
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.h
> b/drivers/scsi/aic7xxx/aic7xxx_osm.h
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.h
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.h
> @@ -494,8 +494,6 @@ ahc_insb(struct ahc_softc * ahc, long po
>  int		ahc_linux_register_host(struct ahc_softc *,
>  					struct scsi_host_template *);
>  
> -uint64_t	ahc_linux_get_memsize(void);
> -
>  /*************************** Pretty Printing
> **********************************/
>  struct info_str {
>  	char *buffer;
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
> @@ -180,6 +180,7 @@ ahc_linux_pci_dev_probe(struct pci_dev *
>  	struct		 ahc_pci_identity *entry;
>  	char		*name;
>  	int		 error;
> +	struct device	*dev = &pdev->dev;
>  
>  	pci = pdev;
>  	entry = ahc_find_pci_device(pci);
> @@ -209,11 +210,12 @@ ahc_linux_pci_dev_probe(struct pci_dev *
>  	pci_set_master(pdev);
>  
>  	if (sizeof(dma_addr_t) > 4
> -	 && ahc_linux_get_memsize() > 0x80000000
> -	 && pci_set_dma_mask(pdev, mask_39bit) == 0) {
> +	    && ahc->features & AHC_LARGE_SCBS
> +	    && dma_set_mask(dev, mask_39bit) == 0
> +	    && dma_get_required_mask(dev) > DMA_32BIT_MASK) {
>  		ahc->flags |= AHC_39BIT_ADDRESSING;
>  	} else {
> -		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK)) {
> +		if (dma_set_mask(dev, DMA_32BIT_MASK)) {
>  			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
>                  	return (-ENODEV);
>  		}
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

