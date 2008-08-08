From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Scatter-gather segment merges by IOMMU?
Date: Sat, 9 Aug 2008 07:17:30 +0900
Message-ID: <20080809071744I.fujita.tomonori@lab.ntt.co.jp>
References: <489CB8D8.60908@s5r6.in-berlin.de>
	<20080809063159F.fujita.tomonori@lab.ntt.co.jp>
	<489CC17F.7000208@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:41739 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185AbYHHWSA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 18:18:00 -0400
In-Reply-To: <489CC17F.7000208@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, grundler@google.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 08 Aug 2008 23:58:23 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> FUJITA Tomonori wrote:
> > On Fri, 08 Aug 2008 23:21:28 +0200
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> Here is what PPC does:
> >> http://lxr.linux.no/linux+v2.6.26/arch/powerpc/kernel/iommu.c#L270
> >>
> >> It looks at dma_get_max_seg_size(dev); and then merges according to it.
> > 
> > Yes, IOMMUs were not able to handle this issue but they should now.
> > 
> > 
> >> That's all nice and well, but in my case (FireWire storage protocol 
> >> a.k.a. SBP-2, which is basically remote DMA), the max_segment_size of 
> >> the PCI device is different from the size limit of the protocol.  We 
> >> currently have to deconstruct such merges in the sbp2 drivers again:
> >> http://lxr.linux.no/linux+v2.6.26/drivers/firewire/fw-sbp2.c#L1384
> >>
> >> Either I keep it that way, or I let the protocol driver manipulate the 
> >> FireWire controller's dev->dma_parms->max_segment_size (via 
> >> dma_set_max_seg_size() of course), which is not entirely correct.
> > 
> > Why is it not correct? Device drivers can set
> > dma_set_max_seg_size(). SCSI does that (see __scsi_alloc_queue).
> 
> FireWire is a multi-protocol bus.  SBP-2 is just one of many quite 
> different protocols.  SBP-2 targets read or write the initiators memory 
> buffers via remote DMA.  These buffer may be exposed as s/g lists to the 
> target.  The protocol limits these s/g lists to up to 65535 elements of 
> up to 65535 bytes size each.
> 
> FireWire controllers on the other hand get their maximum segment size 
> set to 65536 by the PCI subsystem.  (All FireWire controllers supported 
> by mainline Linux are PCI or PCIe devices.)
> 
> In case of the drivers/firewire/ stack, the SBP-2 driver is currently 
> the only one which uses dma_map_sg.  In case of the drivers/ieee1394/ 
> stack, also the drivers for isochronous protocols, including userspace 
> drivers via raw1394, use dma_map_sg.

Thanks for the explanation.


> So if the SBP-2 driver manipulated the controller device's 
> max_segment_size, it would influence the DMA mappings of the other 
> protocols.  It wouldn't be a big deal; the isochronous mappings could 

IMHO, setting the safest value to max_segment_size is fine. After all,
the maximum is only 65536 bytes.


> only be collapsed to chunks of at most 15 pages instead of 16 pages. 
> However, the mapping deconstructing code in the SBP-2 drivers is not a 
> big deal either.
