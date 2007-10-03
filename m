From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 3/5] add sg segment limitation info to device structure
Date: Wed, 3 Oct 2007 14:50:19 -0700
Message-ID: <20071003215019.GF17863@suse.de>
References: <3ae72650710020823j17219ab5u6c2aefe491884ca6@mail.gmail.com> <20071002152534.GT12049@parisc-linux.org> <20071002164413.GA12571@suse.de> <20071003231034P.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53973 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbXJCVuo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 17:50:44 -0400
Content-Disposition: inline
In-Reply-To: <20071003231034P.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: matthew@wil.cx, kay.sievers@vrfy.org, James.Bottomley@steeleye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, Oct 03, 2007 at 11:19:22PM +0900, FUJITA Tomonori wrote:
> On Tue, 2 Oct 2007 09:44:13 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Tue, Oct 02, 2007 at 09:25:34AM -0600, Matthew Wilcox wrote:
> > > On Tue, Oct 02, 2007 at 05:23:39PM +0200, Kay Sievers wrote:
> > > > Just looking at the number of devices, it seems that allocating it
> > > > dynamically would be the better deal. We allocate the name of every
> > > > kobject dynamically today, so I guess it's fine to do that with the
> > > > DMA data too.
> > > 
> > > But we don't need to allocate it dynamically.  We can embed it in the
> > > pci_dev, eisa_dev, zorro_dev, mca_dev and parisc_device.
> > 
> > But then you run into the issue that James pointed out originally.
> > 
> > Anyway, I don't care which, let's see some patches :)
> 
> How about this (based on James' proposal)?
> 
> - Currently, there are only max_segment_size and segment_boundary_mask
> in struct device_dma_parameters (I'll add segment_boundary_mask
> support later after I finish the iommu part). We'll move more dma
> stuff in struct device (like dma_mask) to struct device_dma_parameters
> later (needs some cleanups before that).
> 
> - New accessors for the dma parameters are added. So we can easily
> change where to place struct device_dma_parameters in the future.
> 
> - the default max_segment_size is set to 64K, same to the block
> layer's default value.
> 
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 37c00f6..c93ebe8 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1392,6 +1392,13 @@ pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
>  }
>  #endif
>  
> +#ifndef HAVE_ARCH_PCI_SET_DMA_MAX_SEGMENT_SIZE
> +int pci_set_dma_max_seg_size(struct pci_dev *dev, unsigned int size)
> +{
> +	return dma_set_max_seg_size(&dev->dev, size);
> +}
> +#endif
> +
>  /**
>   * pcix_get_max_mmrbc - get PCI-X maximum designed memory read byte count
>   * @dev: PCI device to query
> @@ -1624,6 +1631,7 @@ EXPORT_SYMBOL(pci_clear_mwi);
>  EXPORT_SYMBOL_GPL(pci_intx);
>  EXPORT_SYMBOL(pci_set_dma_mask);
>  EXPORT_SYMBOL(pci_set_consistent_dma_mask);
> +EXPORT_SYMBOL(pci_set_dma_max_seg_size);
>  EXPORT_SYMBOL(pci_assign_resource);
>  EXPORT_SYMBOL(pci_find_parent_resource);
>  EXPORT_SYMBOL(pci_select_bars);

Export the symbol right next to the function, that way the #ifdef
doesn't have to be duplicated.

other than that minor problem, this looks good to me.  James, any
objection to this?

thanks,

greg k-h
