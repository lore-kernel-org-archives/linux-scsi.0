From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aic79xx: use dma_get_required_mask()
Date: Fri, 9 Feb 2007 16:10:11 +0000
Message-ID: <20070209161011.GA8908@infradead.org>
References: <45C99230.5020309@suse.de> <20070208194024.GB2354@infradead.org> <1171036539.3627.15.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42622 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946581AbXBIQKT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 11:10:19 -0500
Content-Disposition: inline
In-Reply-To: <1171036539.3627.15.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>

On Fri, Feb 09, 2007 at 10:55:39AM -0500, James Bottomley wrote:
> On Thu, 2007-02-08 at 19:40 +0000, Christoph Hellwig wrote:
> > The logic here seems odd to me.  Shouldn't we first check
> > dma_get_required_mask and the do dma_set_mask?
> 
> Yes ... I picked up the mask problem, but not that.  And actually
> there's a missing zero check on one of the dma_set_mask()s.
> 
> Does this look like the right patch then?

This looks functionally correct to me, but there's some cosmetic issues
left:

> Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
> ===================================================================
> --- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2007-02-09 09:12:55.000000000 -0500
> +++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2007-02-09 09:21:32.000000000 -0500
> @@ -132,6 +132,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *
>  	struct		 ahd_pci_identity *entry;
>  	char		*name;
>  	int		 error;
> +	struct device	*dev = &pdev->dev;
>  
>  	pci = pdev;
>  	entry = ahd_find_pci_device(pci);
> @@ -161,20 +162,16 @@ ahd_linux_pci_dev_probe(struct pci_dev *
>  	pci_set_master(pdev);
>  
>  	if (sizeof(dma_addr_t) > 4) {
> -		uint64_t   memsize;
> -		const uint64_t mask_39bit = 0x7FFFFFFFFFULL;
> -
> -		memsize = ahd_linux_get_memsize();
> -
> -		if (memsize >= 0x8000000000ULL
> -	 	 && pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0) {
> +		if (dma_get_required_mask(dev) > DMA_39BIT_MASK
> +		    && dma_set_mask(dev, DMA_64BIT_MASK) == 0)
>  			ahd->flags |= AHD_64BIT_ADDRESSING;
> -		} else if (memsize > 0x80000000
> -			&& pci_set_dma_mask(pdev, mask_39bit) == 0) {
> +		else if (dma_get_required_mask(dev) > DMA_32BIT_MASK
> +			 && dma_set_mask(dev, DMA_39BIT_MASK) == 0)
>  			ahd->flags |= AHD_39BIT_ADDRESSING;
> -		}
> +		else
> +			dma_set_mask(dev, DMA_32BIT_MASK);
>  	} else {

I'd rather do the dma_get_required_mask only once, and we we want
&& at the end of the first instead of at the beginning of the second
line.  So this block should look like:

		u64 required_mask = dma_get_required_mask(dev);

		if (required_mask > DMA_39BIT_MASK &&
		    dma_set_mask(dev, DMA_64BIT_MASK) == 0)
 			ahd->flags |= AHD_64BIT_ADDRESSING;
		else if (required_mask > DMA_32BIT_MASK &&
		         dma_set_mask(dev, DMA_39BIT_MASK) == 0)
			ahd->flags |= AHD_39BIT_ADDRESSING;
		else
			dma_set_mask(dev, DMA_32BIT_MASK);
