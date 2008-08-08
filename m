From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Scatter-gather segment merges by IOMMU?
Date: Fri, 08 Aug 2008 23:21:28 +0200
Message-ID: <489CB8D8.60908@s5r6.in-berlin.de>
References: <489CA21F.1030604@s5r6.in-berlin.de> <da824cf30808081325n416ec436y94eebe494d789207@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51321 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbYHHVVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 17:21:35 -0400
In-Reply-To: <da824cf30808081325n416ec436y94eebe494d789207@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Fri, Aug 8, 2008 at 12:44 PM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Hi all,
>>
>> the block layer usually tries to merge s/g segments if consecutive segments
>> combined fit into the queue's max_segment_size.  When such a scatter gather
>> list is DMA-mapped, can it happen that an IOMMU collapses the elements even
>> further, so that sg_dma_len() of a DMA-mapped s/g segment exceeds
>> max_segment_size?
> 
> I don't see how. The IOMMU code only collapses the "physical" mappings and
> does not add new elements to the SG list. ergo sg_dma_len() shouldn't change.
> 
> grant
> 
>> As I understood some discussions in the past, this could indeed happen,
>> which is a nuisance.  But I may have misunderstood something, or something
>> may have changed in the meantime...

Well, I'm just doing my homework and am tracking down the various 
dma_map_sg implementations.

Here is what PPC does:
http://lxr.linux.no/linux+v2.6.26/arch/powerpc/kernel/iommu.c#L270

It looks at dma_get_max_seg_size(dev); and then merges according to it.

That's all nice and well, but in my case (FireWire storage protocol 
a.k.a. SBP-2, which is basically remote DMA), the max_segment_size of 
the PCI device is different from the size limit of the protocol.  We 
currently have to deconstruct such merges in the sbp2 drivers again:
http://lxr.linux.no/linux+v2.6.26/drivers/firewire/fw-sbp2.c#L1384

Either I keep it that way, or I let the protocol driver manipulate the 
FireWire controller's dev->dma_parms->max_segment_size (via 
dma_set_max_seg_size() of course), which is not entirely correct.

I first wanted to use blk_queue_max_segment_size(), but that falls short 
with dma_map_sg implementations like the above are at work.
-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/
