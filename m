From: gl@dsa-ac.de
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Thu, 17 Mar 2005 10:41:31 +0100 (CET)
Message-ID: <Pine.LNX.4.56.0503171011410.20956@pcgl.dsa-ac.de>
References: <20050317074013.GJ7842@suse.de> <22734.1111050528@www13.gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from mail.dsa-ac.de ([62.112.80.99]:62729 "EHLO mail.dsa-ac.de")
	by vger.kernel.org with ESMTP id S263028AbVCQJoU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 04:44:20 -0500
In-Reply-To: <22734.1111050528@www13.gmx.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Hi

On Thu, 17 Mar 2005, Jens Axboe wrote:

> On Wed, Mar 16 2005, Guennadi Liakhovetski wrote:
> >
> > On Wed, 16 Mar 2005, Jens Axboe wrote:
> > > The kmap() isn't just inefficient, it's a problem to iterate over the sg
> > > list and kmap all the pages. That is illegal.
> >
> > Hm, what do you mean "illegal"? Could you explain why?
>
> You risk deadlocking.

Emn, I am curious, would be nice to know details:-)

> > One more fragment in the driver I wasn't sure about is this:
> >
> >  		unsigned long mask =
> >  		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
> >  		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
> >
> > Is sg->length guaranteed to be something like a power of 2 or smaller
> > than page? I thought about replacing the above with
>
> No, it's not guaranteed to be a power-of-2.
>
> > +		if (sg_dma_address(sg) <= psge->address && sg_dma_address(sg) + psge->length > psge->address) {
>
> What is it trying to accomplish?

So, I was not sure if the old check was correct, was it? The test is
supposed to find the current sg-element.

>
> > @@ -1020,11 +1022,11 @@
> >  			reqlen, cmd->request_buffer, cmd->use_sg,
> >  			srb->sg_count);
> >
> > -		srb->virt_addr = page_address(sl->page);
> > +		srb->page = sl->page;
> > +		srb->offset = sl->offset;
> >  		for (i = 0; i < srb->sg_count; i++) {
> > -			u32 busaddr = (u32)sg_dma_address(&sl[i]);
> > -			u32 seglen = (u32)sl[i].length;
> > -			sgp[i].address = busaddr;
> > +			u32 seglen = (u32)sg_dma_len(sl + i);
> > +			sgp[i].address = cpu_to_le32(0xffffffff & sg_dma_address(sl +i));
> >  			sgp[i].length = seglen;
> >  			srb->total_xfer_length += seglen;
> >  		}
>
> I don't understand this change, why the cpu_to_le32?

Well, I copied it from tmscsim:

pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));

I am somewhat confused. In both cases these are bus addresses, right? and
sg_dma_address() gives already the bus address, so, both are wrong?

BTW, looking at tmscsim again, isn't this

	if( residual )
	{
		bval = DC390_read8 (ScsiFifo);      /* get one residual byte */
		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
		*ptr = bval;
		pSRB->SGBusAddr++; xferCnt++;
		pSRB->TotalXferredLen++;
		pSRB->SGToBeXferLen--;
	}

also a case for dma_map_atomic?

> > +			local_irq_save(flags);
> > +			page_addr = kmap_atomic(srb->page, KM_USER0);
> > +			virt_addr = page_addr + srb->offset;
> > +
>
> You can't use KM_USER0 here, use one of the bio assigned kmap types (you
> can use KM_BIO_SRC_IRQ, for instance - the reason there are two is for
> the bouncing that needs to kmap both source and destination at the same
> time).

Ok, will change that.

> > +			kunmap_atomic(page_addr, KM_IRQ0);
> > +			local_irq_restore(flags);
>
> Here you kunmap_atomic() with a different kmap type than you mapped
> with? Must be the same.

Auch, manual patch-editing error:-)

> Same applies to the matchin section further down.

Yep, will fix.

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany
