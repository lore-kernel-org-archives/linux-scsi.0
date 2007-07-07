From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v2] add bidi support for block pc requests
Date: Sat, 07 Jul 2007 12:59:16 -0400
Message-ID: <468FC664.5050209@garzik.org>
References: <464C1721.8030009@panasas.com>	 <1179408422.3785.5.camel@mulgrave.il.steeleye.com>	 <464C5FF5.6000705@panasas.com>	 <20070517231127T.fujita.tomonori@lab.ntt.co.jp>	 <464C799D.7080405@panasas.com> <46607FB0.4040103@garzik.org>	 <4662717C.9040400@panasas.com>	 <1180876623.3876.50.camel@mulgrave.il.steeleye.com>	 <468FB0CF.9000500@garzik.org> <1183822933.3408.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35867 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbXGGQ71 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Jul 2007 12:59:27 -0400
In-Reply-To: <1183822933.3408.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

James Bottomley wrote:
> On Sat, 2007-07-07 at 11:27 -0400, Jeff Garzik wrote:
>> LIBATA_MAX_PRD is the maximum number of DMA scatter/gather elements 
>> permitted by the HBA's DMA engine, for a single ATA command.

> Then it's the wrong parameter you're setting:  phys_segments is what you
> have going into a dma_map_sg() but hw_segments is what you end up after
> it (mathemtaically, the mapping never splits segments, so hw_segments <=
> phys_segments always, but it's still the wrong way to bound this); so if
> you want to limit the SG elements in the HBA, you should set hw_segments
> not phys_segments (which is what the sg_tablesize parameter of the host
> structure corresponds to).

Honestly I'm betting the code is a result of paranoia^H^H^Hconservatism 
on my part:  setting every DMA and segment limit I can find, in the 
hopes that somehow, somewhere, that information will get filtered down 
to the IOMMU and whatnot.  :)

Given what you say above, and the fact that I set sg_tablesize, 
presumably Boaz's patch to remove phys_segment limiting in libata-scsi 
is the right thing to do.  Your knowledge in this area is most likely 
stronger than mine.


> However, I suspect this has to do with our iommu problem, doesn't it?
> The IOMMU may merge the segments beyond your 64k DMA boundary, so you
> need to split them again ... in that case you need phys_segments
> bounded, not hw_segments?

This is why I set every segment limitation I could find :)  And then Ben 
tells me IOMMU may ignore all of that anyway, and so I have code to 
split inside libata as well :)

I just know what IDE needs:  S/G ent shouldn't cross 64k boundary, nor 
exceed 64k in size.  The maximum number of S/G ents is actually a guess. 
  Hard data is tough to come by.  Some DMA engines will cycle through 
all of memory until they hit a stop bit.  Others have limits yet to be 
discovered.  :)

	Jeff


