From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Thu, 17 Mar 2005 11:08:54 +0100
Message-ID: <20050317100854.GA1860@suse.de>
References: <20050317074013.GJ7842@suse.de> <22734.1111050528@www13.gmx.net> <Pine.LNX.4.56.0503171011410.20956@pcgl.dsa-ac.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:44951 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263035AbVCQKI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 05:08:59 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.56.0503171011410.20956@pcgl.dsa-ac.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gl@dsa-ac.de
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On Thu, Mar 17 2005, gl@dsa-ac.de wrote:
> Hi
> 
> On Thu, 17 Mar 2005, Jens Axboe wrote:
> 
> > On Wed, Mar 16 2005, Guennadi Liakhovetski wrote:
> > >
> > > On Wed, 16 Mar 2005, Jens Axboe wrote:
> > > > The kmap() isn't just inefficient, it's a problem to iterate over the sg
> > > > list and kmap all the pages. That is illegal.
> > >
> > > Hm, what do you mean "illegal"? Could you explain why?
> >
> > You risk deadlocking.
> 
> Emn, I am curious, would be nice to know details:-)

See the kmap implementation, mm/highmem.c:map_new_virtual() to be
precise. If you run out of entries while processing your sglist, you
will end up waiting on a free kmap entry for an sg entry that will not
become available before your previous kmaps are released => deadlock.

> > > One more fragment in the driver I wasn't sure about is this:
> > >
> > >  		unsigned long mask =
> > >  		    ~((unsigned long)sg->length - 1) & PAGE_MASK;
> > >  		if ((sg_dma_address(sg) & mask) == (psge->address & mask)) {
> > >
> > > Is sg->length guaranteed to be something like a power of 2 or smaller
> > > than page? I thought about replacing the above with
> >
> > No, it's not guaranteed to be a power-of-2.
> >
> > > +		if (sg_dma_address(sg) <= psge->address && sg_dma_address(sg) + psge->length > psge->address) {
> >
> > What is it trying to accomplish?
> 
> So, I was not sure if the old check was correct, was it? The test is
> supposed to find the current sg-element.

When this happens, do you know how many bytes of io already completed?
Most sane drives do, so I would use that to find the current sg entry.

> >
> > > @@ -1020,11 +1022,11 @@
> > >  			reqlen, cmd->request_buffer, cmd->use_sg,
> > >  			srb->sg_count);
> > >
> > > -		srb->virt_addr = page_address(sl->page);
> > > +		srb->page = sl->page;
> > > +		srb->offset = sl->offset;
> > >  		for (i = 0; i < srb->sg_count; i++) {
> > > -			u32 busaddr = (u32)sg_dma_address(&sl[i]);
> > > -			u32 seglen = (u32)sl[i].length;
> > > -			sgp[i].address = busaddr;
> > > +			u32 seglen = (u32)sg_dma_len(sl + i);
> > > +			sgp[i].address = cpu_to_le32(0xffffffff & sg_dma_address(sl +i));
> > >  			sgp[i].length = seglen;
> > >  			srb->total_xfer_length += seglen;
> > >  		}
> >
> > I don't understand this change, why the cpu_to_le32?
> 
> Well, I copied it from tmscsim:
> 
> pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
> 
> I am somewhat confused. In both cases these are bus addresses, right? and
> sg_dma_address() gives already the bus address, so, both are wrong?

The only reason that would make sense is if ->SGBusAddr is passed to the
hardware and it requires LE encoding. If it is just driver internal use,
it doesn't make any sense.

> BTW, looking at tmscsim again, isn't this
> 
> 	if( residual )
> 	{
> 		bval = DC390_read8 (ScsiFifo);      /* get one residual byte */
> 		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
> 		*ptr = bval;
> 		pSRB->SGBusAddr++; xferCnt++;
> 		pSRB->TotalXferredLen++;
> 		pSRB->SGToBeXferLen--;
> 	}
> 
> also a case for dma_map_atomic?

It breaks for iommu, for sure.

-- 
Jens Axboe

