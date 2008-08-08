From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Scatter-gather segment merges by IOMMU?
Date: Fri, 08 Aug 2008 23:58:23 +0200
Message-ID: <489CC17F.7000208@s5r6.in-berlin.de>
References: <489CA21F.1030604@s5r6.in-berlin.de>	<da824cf30808081325n416ec436y94eebe494d789207@mail.gmail.com>	<489CB8D8.60908@s5r6.in-berlin.de> <20080809063159F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:51500 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763012AbYHHV6o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 17:58:44 -0400
In-Reply-To: <20080809063159F.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: grundler@google.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Fri, 08 Aug 2008 23:21:28 +0200
> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> Here is what PPC does:
>> http://lxr.linux.no/linux+v2.6.26/arch/powerpc/kernel/iommu.c#L270
>>
>> It looks at dma_get_max_seg_size(dev); and then merges according to it.
> 
> Yes, IOMMUs were not able to handle this issue but they should now.
> 
> 
>> That's all nice and well, but in my case (FireWire storage protocol 
>> a.k.a. SBP-2, which is basically remote DMA), the max_segment_size of 
>> the PCI device is different from the size limit of the protocol.  We 
>> currently have to deconstruct such merges in the sbp2 drivers again:
>> http://lxr.linux.no/linux+v2.6.26/drivers/firewire/fw-sbp2.c#L1384
>>
>> Either I keep it that way, or I let the protocol driver manipulate the 
>> FireWire controller's dev->dma_parms->max_segment_size (via 
>> dma_set_max_seg_size() of course), which is not entirely correct.
> 
> Why is it not correct? Device drivers can set
> dma_set_max_seg_size(). SCSI does that (see __scsi_alloc_queue).

FireWire is a multi-protocol bus.  SBP-2 is just one of many quite 
different protocols.  SBP-2 targets read or write the initiators memory 
buffers via remote DMA.  These buffer may be exposed as s/g lists to the 
target.  The protocol limits these s/g lists to up to 65535 elements of 
up to 65535 bytes size each.

FireWire controllers on the other hand get their maximum segment size 
set to 65536 by the PCI subsystem.  (All FireWire controllers supported 
by mainline Linux are PCI or PCIe devices.)

In case of the drivers/firewire/ stack, the SBP-2 driver is currently 
the only one which uses dma_map_sg.  In case of the drivers/ieee1394/ 
stack, also the drivers for isochronous protocols, including userspace 
drivers via raw1394, use dma_map_sg.

So if the SBP-2 driver manipulated the controller device's 
max_segment_size, it would influence the DMA mappings of the other 
protocols.  It wouldn't be a big deal; the isochronous mappings could 
only be collapsed to chunks of at most 15 pages instead of 16 pages. 
However, the mapping deconstructing code in the SBP-2 drivers is not a 
big deal either.
-- 
Stefan Richter
-=====-==--- =--- -=---
http://arcgraph.de/sr/
