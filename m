From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Wed, 16 Mar 2005 17:53:39 +0100
Message-ID: <20050316165338.GX7842@suse.de>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de> <20050316164806.GO21986@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:61353 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262682AbVCPQxp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 11:53:45 -0500
Content-Disposition: inline
In-Reply-To: <20050316164806.GO21986@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, g.liakhovetski@gmx.de

On Wed, Mar 16 2005, Matthew Wilcox wrote:
> On Wed, Mar 16, 2005 at 05:04:47PM +0100, Jens Axboe wrote:
> > The kmap() isn't just inefficient, it's a problem to iterate over the sg
> > list and kmap all the pages. That is illegal.
> > 
> > But it's not so tricky to get right, if the punting just happens in the
> > isr. Basically just iterate over every sg entry left ala:
> > 
> >         for (i = start; i < sg_entries; i++) {
> >                 unsigned long flags;
> >                 char *ptr;
> > 
> >                 local_irq_save(flags);
> >                 ptr = kmap_atomic(sg->page, KM_BIO_SRC_IRQ);
> > 
> >                 /* transfer to/from ptr + sg->offset, sg->length bytes */
> > 
> >                 kunmap_atomic(ptr, KM_BIO_SRC_IRQ);
> >                 local_irq_restore(flags);
> >         }
> > 
> > I _think_ the sg->length field is universally called so, you should not
> > use sg->dma_length/sg_dma_len() or sg_dma_address(), as we are outside
> > the work of the iommu at this point.
> 
> Documentation/DMA-mapping.txt agrees with you:
> 
>                         Platform Issues
> 
> 1) Struct scatterlist requirements.
> 
>    Struct scatterlist must contain, at a minimum, the following
>    members:
> 
>         struct page *page;
>         unsigned int offset;
>         unsigned int length;

Ah excellent, thanks!

> Would you mind writing up a change to DMA-mapping.txt that explains why
> one would need to do the kmap solution you outline above?  If it needs
> to be done for IDE and one SCSI driver, I bet it needs to be done for
> more devices, and it'd be a handy place to refer to.

But it isn't really DMA mapping, quite the opposite :)

It's hard to document generically. For IDE, it doesn't have special
'ide' command, it just uses the request structure. So it can use the bio
mapping helpers (see bio.h, bvec_kmap_irq()/bvec_kunmap_irq()). For this
SCSI driver, it needs to walk the sglist and do the same thing,
basically.

> I'm a bit confused why the approach outlined in DMA-mapping.txt doesn't
> work for this driver.  Is it because you don't find out until you're
> in the interrupt handler that you need to map the sg-list and you can't
> call pci_map_sg() from interrupt context?

The list doesn't really need dma mapping at that point, the problem here
is that the driver needs to punt to pio mode because of foo. So calling
pci/dma_map_* is pointless, since the CPU will have to do the transfer
anyways. What the driver is really looking for at this point, is a way
to map the pages in the sglist to a virtual address.

-- 
Jens Axboe

