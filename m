From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] aic79xx: use dma_get_required_mask()
Date: Thu, 8 Feb 2007 19:40:24 +0000
Message-ID: <20070208194024.GB2354@infradead.org>
References: <45C99230.5020309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:41114 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423278AbXBHTka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Feb 2007 14:40:30 -0500
Content-Disposition: inline
In-Reply-To: <45C99230.5020309@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>

>  ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
>  	char		 buf[80];
> +	const uint64_t	 mask_39bit = 0x7FFFFFFFFFULL;
>  	struct		 ahd_softc *ahd;
>  	ahd_dev_softc_t	 pci;
>  	struct		 ahd_pci_identity *entry;
>  	char		*name;
>  	int		 error;
> +	struct device	*dev = &pdev->dev;
>  
>  	pci = pdev;
>  	entry = ahd_find_pci_device(pci);
> @@ -161,20 +163,17 @@ ahd_linux_pci_dev_probe(struct pci_dev *
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
> +		if (dma_set_mask(dev, DMA_64BIT_MASK)
> +		    && dma_get_required_mask(dev) > mask_39bit)
>  			ahd->flags |= AHD_64BIT_ADDRESSING;
> -		} else if (memsize > 0x80000000
> -			&& pci_set_dma_mask(pdev, mask_39bit) == 0) {
> +		else if (dma_set_mask(dev, mask_39bit) == 0
> +			 && dma_get_required_mask(dev) > DMA_32BIT_MASK)
>  			ahd->flags |= AHD_39BIT_ADDRESSING;
> -		}
> +		else
> +			dma_set_mask(dev, DMA_32BIT_MASK);
> +			
>  	} else {
> -		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
> +		dma_set_mask(dev, DMA_32BIT_MASK);

The logic here seems odd to me.  Shouldn't we first check
dma_get_required_mask and the do dma_set_mask?

