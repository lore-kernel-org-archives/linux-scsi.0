From: gl@dsa-ac.de
Subject: Re: [PATCH] dc395x: Fix support for highmem
Date: Thu, 17 Mar 2005 11:56:40 +0100 (CET)
Message-ID: <Pine.LNX.4.56.0503171113160.20956@pcgl.dsa-ac.de>
References: <20050317074013.GJ7842@suse.de> <22734.1111050528@www13.gmx.net>
 <Pine.LNX.4.56.0503171011410.20956@pcgl.dsa-ac.de> <20050317100854.GA1860@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Received: from mail.dsa-ac.de ([62.112.80.99]:36106 "EHLO mail.dsa-ac.de")
	by vger.kernel.org with ESMTP id S263060AbVCQK7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Mar 2005 05:59:25 -0500
In-Reply-To: <20050317100854.GA1860@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>

On Thu, 17 Mar 2005, Jens Axboe wrote:

> See the kmap implementation, mm/highmem.c:map_new_virtual() to be
> precise. If you run out of entries while processing your sglist, you
> will end up waiting on a free kmap entry for an sg entry that will not
> become available before your previous kmaps are released => deadlock.

Right, thanks for the explanation!

> > > > +		if (sg_dma_address(sg) <= psge->address && sg_dma_address(sg) + psge->length > psge->address) {
> > >
> > > What is it trying to accomplish?
> >
> > So, I was not sure if the old check was correct, was it? The test is
> > supposed to find the current sg-element.
>
> When this happens, do you know how many bytes of io already completed?
> Most sane drives do, so I would use that to find the current sg entry.

Yeah, it is known at this point. I guess, I'll leave this change out for
now - for this patch at least.

> > > > +			sgp[i].address = cpu_to_le32(0xffffffff & sg_dma_address(sl +i));
> > > >  			sgp[i].length = seglen;
> > > >  			srb->total_xfer_length += seglen;
> > > >  		}
> > >
> > > I don't understand this change, why the cpu_to_le32?
> >
> > Well, I copied it from tmscsim:
> >
> > pSRB->SGBusAddr = cpu_to_le32(pci_dma_lo32(sg_dma_address(psgl)));
> >
> > I am somewhat confused. In both cases these are bus addresses, right? and
> > sg_dma_address() gives already the bus address, so, both are wrong?
>
> The only reason that would make sense is if ->SGBusAddr is passed to the
> hardware and it requires LE encoding. If it is just driver internal use,
> it doesn't make any sense.

Yes, it is passed to the controller. I think, it is also the case with the
dc395x, although, it is smarter than am53c974 in sg-list processing. Will,
probably, leave it out too.

> > 		ptr = (u8 *) bus_to_virt( pSRB->SGBusAddr );
...
> > also a case for dma_map_atomic?
>
> It breaks for iommu, for sure.

Ok, expect a patch soon.

So, do we want this kmap_atomic() patch for dc395x or we wait for
helper-functions?

BTW, can one test highmem correctness by booting with, e.g., highmem=xxx
even if no physical highmem is available?

Thanks
Guennadi
---------------------------------
Guennadi Liakhovetski, Ph.D.
DSA Daten- und Systemtechnik GmbH
Pascalstr. 28
D-52076 Aachen
Germany
