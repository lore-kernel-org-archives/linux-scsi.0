From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: fix a few missing return value checks in scsi
Date: Wed, 31 Dec 2003 09:35:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FF2DEAE.1040009@pobox.com>
References: <1072879141.4292.5.camel@laptop.fenrus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:20186 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265066AbTLaOfq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 09:35:46 -0500
In-Reply-To: <1072879141.4292.5.camel@laptop.fenrus.com>
List-Id: linux-scsi@vger.kernel.org
To: arjanv@redhat.com
Cc: linux-scsi@vger.kernel.org

Arjan van de Ven wrote:
> Hi,
> 
> The attached patch adds a few error checks for the pci dma_mask setting
> routines, which after all can fail and thus need their return code
> checked.
> 
> Greetings,
>    Arjan van de Ven
> 
> 
> ------------------------------------------------------------------------
> 
> --- linux-2.6.0-test11/drivers/scsi/aic7xxx/aic7xxx_osm.c.OLD	2003-12-19 16:26:15.000000000 -0500
> +++ linux-2.6.0-test11/drivers/scsi/aic7xxx/aic7xxx_osm.c	2003-12-19 16:29:17.000000000 -0500
> @@ -1408,12 +1408,18 @@
>  	 * our dma mask when doing allocations.
>  	 */
>  	if (ahc->dev_softc != NULL)
> -		ahc_pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF);
> +		if (ahc_pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
> +			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
> +			return (ENODEV);
> +		}
>  	*vaddr = pci_alloc_consistent(ahc->dev_softc,
>  				      dmat->maxsize, &map->bus_addr);
>  	if (ahc->dev_softc != NULL)
> -		ahc_pci_set_dma_mask(ahc->dev_softc,
> -				     ahc->platform_data->hw_dma_mask);
> +		if (ahc_pci_set_dma_mask(ahc->dev_softc,
> +				     ahc->platform_data->hw_dma_mask)) {
> +			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
> +			return (ENODEV);
> +		}
>  #else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
>  	/*
>  	 * At least in 2.2.14, malloc is a slab allocator so all
> --- linux-2.6.0-test11/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c.OLD	2003-12-19 16:30:32.000000000 -0500
> +++ linux-2.6.0-test11/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2003-12-19 16:31:43.000000000 -0500
> @@ -168,7 +168,10 @@
>  		ahc->flags |= AHC_39BIT_ADDRESSING;
>  		ahc->platform_data->hw_dma_mask = mask_39bit;
>  	} else {
> -		ahc_pci_set_dma_mask(pdev, 0xFFFFFFFF);
> +		if (ahc_pci_set_dma_mask(pdev, 0xFFFFFFFF)) {
> +			printk(KERN_WARNING "aic7xxx: No suitable DMA available.\n");
> +                	return (-ENODEV);
> +		}
>  		ahc->platform_data->hw_dma_mask = 0xFFFFFFFF;
>  	}
>  #endif
> --- linux-2.6.0-test11/drivers/scsi/aic7xxx/aic79xx_osm.c.OLD	2003-12-19 16:34:01.000000000 -0500
> +++ linux-2.6.0-test11/drivers/scsi/aic7xxx/aic79xx_osm.c	2003-12-19 16:35:11.000000000 -0500
> @@ -1776,12 +1776,18 @@
>  	 * our dma mask when doing allocations.
>  	 */
>  	if (ahd->dev_softc != NULL)
> -		ahd_pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF);
> +		if (ahd_pci_set_dma_mask(ahd->dev_softc, 0xFFFFFFFF)) {
> +			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
> +			return (ENODEV);
> +		}
>  	*vaddr = pci_alloc_consistent(ahd->dev_softc,
>  				      dmat->maxsize, &map->bus_addr);
>  	if (ahd->dev_softc != NULL)
> -		ahd_pci_set_dma_mask(ahd->dev_softc,
> -				     ahd->platform_data->hw_dma_mask);
> +		if (ahd_pci_set_dma_mask(ahd->dev_softc,
> +				     ahd->platform_data->hw_dma_mask)) {
> +			printk(KERN_WARNING "aic79xx: No suitable DMA available.\n");
> +			return (ENODEV);
> +		}
>  #else /* LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0) */
>  	/*
>  	 * At least in 2.2.14, malloc is a slab allocator so all


No offense to you personally, but this is a bunch of crap.  aic7xxx 
needs to use the standard kernel APIs for pci_set_dma_mask and 
pci_set_consistent_dma_mask...

We don't need a wrapper for every kernel API function :(

	Jeff



