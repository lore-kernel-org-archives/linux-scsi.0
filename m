From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Scatter-gather segment merges by IOMMU?
Date: Sat, 9 Aug 2008 06:31:45 +0900
Message-ID: <20080809063159F.fujita.tomonori@lab.ntt.co.jp>
References: <489CA21F.1030604@s5r6.in-berlin.de>
	<da824cf30808081325n416ec436y94eebe494d789207@mail.gmail.com>
	<489CB8D8.60908@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33601 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbYHHVcD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 17:32:03 -0400
In-Reply-To: <489CB8D8.60908@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: grundler@google.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 23:21:28 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Grant Grundler wrote:
> > On Fri, Aug 8, 2008 at 12:44 PM, Stefan Richter
> > <stefanr@s5r6.in-berlin.de> wrote:
> >> Hi all,
> >>
> >> the block layer usually tries to merge s/g segments if consecutive segments
> >> combined fit into the queue's max_segment_size.  When such a scatter gather
> >> list is DMA-mapped, can it happen that an IOMMU collapses the elements even
> >> further, so that sg_dma_len() of a DMA-mapped s/g segment exceeds
> >> max_segment_size?
> > 
> > I don't see how. The IOMMU code only collapses the "physical" mappings and
> > does not add new elements to the SG list. ergo sg_dma_len() shouldn't change.
> > 
> > grant
> > 
> >> As I understood some discussions in the past, this could indeed happen,
> >> which is a nuisance.  But I may have misunderstood something, or something
> >> may have changed in the meantime...
> 
> Well, I'm just doing my homework and am tracking down the various 
> dma_map_sg implementations.
> 
> Here is what PPC does:
> http://lxr.linux.no/linux+v2.6.26/arch/powerpc/kernel/iommu.c#L270
> 
> It looks at dma_get_max_seg_size(dev); and then merges according to it.

Yes, IOMMUs were not able to handle this issue but they should now.


> That's all nice and well, but in my case (FireWire storage protocol 
> a.k.a. SBP-2, which is basically remote DMA), the max_segment_size of 
> the PCI device is different from the size limit of the protocol.  We 
> currently have to deconstruct such merges in the sbp2 drivers again:
> http://lxr.linux.no/linux+v2.6.26/drivers/firewire/fw-sbp2.c#L1384
> 
> Either I keep it that way, or I let the protocol driver manipulate the 
> FireWire controller's dev->dma_parms->max_segment_size (via 
> dma_set_max_seg_size() of course), which is not entirely correct.

Why is it not correct? Device drivers can set
dma_set_max_seg_size(). SCSI does that (see __scsi_alloc_queue).


> I first wanted to use blk_queue_max_segment_size(), but that falls short 
> with dma_map_sg implementations like the above are at work.

Yeah, we store the same value at two places (request_queue and device)
though it's not nice.
