From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Thu, 17 Mar 2005 08:40:17 +0100
Message-ID: <20050317074013.GJ7842@suse.de>
References: <200503160209.j2G29cAf010870@hera.kernel.org> <20050316075839.GC7842@suse.de> <1110986016.5771.3.camel@mulgrave> <20050316160447.GU7842@suse.de> <Pine.LNX.4.60.0503162028590.11165@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:34240 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261704AbVCQHkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 02:40:21 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0503162028590.11165@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Mar 16 2005, Guennadi Liakhovetski wrote:
> Hi
> 
> Thanks for reviewing this patch!
> 
> On Wed, 16 Mar 2005, Jens Axboe wrote:
> 
> > On Wed, Mar 16 2005, James Bottomley wrote:
> ...
> > > I agree the kmap is inefficient.  The efficient alternative is to do
> > > dma_map_sg() and use kmap_atomic() in the interrupt routine where we do
> > > the PIO cleanup---I'm afraid I just passed on explaining how to do
> > > this ... unless you care to do the honours ?
> 
> In fact, the first version of my patch (attached below) did exactly this - 
> only when the driver recognises, that it needs to do PIO in the interrupt, 
> I would call kmap_atomic(), do PIO, then kunmap_atomic(). The main reason, 
> why I didn't submit that patch, was that I got confused about various KM_ 
> macros, and I thought, since it is a valuable limited resource, only very 
> "special" drivers are allowed to use them / are allocated one of them. 
> But, I guess now, you can just do
> 
> 	local_irq_save(flags);
> 	kmap_atomic();
> 	...
> 	kunmap_atomic();
> 	local_irq_restore(flags);
> 
> Please, have a look. Or should we indeed go the "generic helper functions" 
> way?

In generel it looks ok, comments below.

> > The kmap() isn't just inefficient, it's a problem to iterate over the sg
> > list and kmap all the pages. That is illegal.
> 
> Hm, what do you mean "illegal"? Could you explain why?

You risk deadlocking.

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
> One more fragment in the driver I wasn't sure about is this:
> 
>  		unsigned long mask =
>  		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
>  		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
> 
> Is sg->length guaranteed to be something like a power of 2 or smaller 
> than page? I thought about replacing the above with

No, it's not guaranteed to be a power-of-2.

> +		if (sg_dma_address(sg) <= psge->address && sg_dma_address(sg) + psge->length > psge->address) {

What is it trying to accomplish?

> @@ -1020,11 +1022,11 @@
>  			reqlen, cmd->request_buffer, cmd->use_sg,
>  			srb->sg_count);
>  
> -		srb->virt_addr = page_address(sl->page);
> +		srb->page = sl->page;
> +		srb->offset = sl->offset;
>  		for (i = 0; i < srb->sg_count; i++) {
> -			u32 busaddr = (u32)sg_dma_address(&sl[i]);
> -			u32 seglen = (u32)sl[i].length;
> -			sgp[i].address = busaddr;
> +			u32 seglen = (u32)sg_dma_len(sl + i);
> +			sgp[i].address = cpu_to_le32(0xffffffff & sg_dma_address(sl +i));
>  			sgp[i].length = seglen;
>  			srb->total_xfer_length += seglen;
>  		}

I don't understand this change, why the cpu_to_le32?

> @@ -2297,19 +2287,18 @@
>  		    && srb->total_xfer_length <= DC395x_LASTPIO) {
>  			/*u32 addr = (srb->segment_x[srb->sg_index].address); */
>  			/*sg_update_list (srb, d_left_counter); */
> -			dprintkdbg(DBG_PIO, "data_in_phase0: PIO (%i %s) to "
> -				"%p for remaining %i bytes:",
> -				DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) & 0x1f,
> -				(srb->dcb->sync_period & WIDE_SYNC) ?
> -				    "words" : "bytes",
> -				srb->virt_addr,
> -				srb->total_xfer_length);
> +			char *page_addr, *virt_addr;
> +			unsigned long flags;
>  			if (srb->dcb->sync_period & WIDE_SYNC)
>  				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2,
>  					      CFG2_WIDEFIFO);
> +			local_irq_save(flags);
> +			page_addr = kmap_atomic(srb->page, KM_USER0);
> +			virt_addr = page_addr + srb->offset;
> +

You can't use KM_USER0 here, use one of the bio assigned kmap types (you
can use KM_BIO_SRC_IRQ, for instance - the reason there are two is for
the bouncing that needs to kmap both source and destination at the same
time).

>  			while (DC395x_read8(acb, TRM_S1040_SCSI_FIFOCNT) != 0x40) {
>  				u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
> -				*(srb->virt_addr)++ = byte;
> +				*(virt_addr)++ = byte;
>  				if (debug_enabled(DBG_PIO))
>  					printk(" %02x", byte);
>  				d_left_counter--;
> @@ -2320,7 +2309,7 @@
>                  /* Read the last byte ... */
>  				if (srb->total_xfer_length > 0) {
>  					u8 byte = DC395x_read8(acb, TRM_S1040_SCSI_FIFO);
> -					*(srb->virt_addr)++ = byte;
> +					*(virt_addr)++ = byte;
>  					srb->total_xfer_length--;
>  					if (debug_enabled(DBG_PIO))
>  						printk(" %02x", byte);
> @@ -2328,6 +2317,8 @@
>  #endif
>  				DC395x_write8(acb, TRM_S1040_SCSI_CONFIG2, 0);
>  			}
> +			kunmap_atomic(page_addr, KM_IRQ0);
> +			local_irq_restore(flags);

Here you kunmap_atomic() with a different kmap type than you mapped
with? Must be the same.

Same applies to the matchin section further down.


-- 
Jens Axboe

