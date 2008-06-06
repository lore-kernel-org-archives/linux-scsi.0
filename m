From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Fri, 6 Jun 2008 13:44:29 +0900
Message-ID: <20080606133955B.fujita.tomonori@lab.ntt.co.jp>
References: <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
	<da824cf30806051134u4fb8d419p2ba2dafcb1ba33a7@mail.gmail.com>
	<1212692488.4241.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:52777 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbYFFEop (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Jun 2008 00:44:45 -0400
In-Reply-To: <1212692488.4241.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: grundler@google.com, fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Thu, 05 Jun 2008 14:01:28 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Thu, 2008-06-05 at 11:34 -0700, Grant Grundler wrote:
> > On Thu, Jun 5, 2008 at 7:49 AM, FUJITA Tomonori
> > <fujita.tomonori@lab.ntt.co.jp> wrote:
> > ...
> > >> You can easily emulate SSD drives by doing sequential 4K reads
> > >> from a normal SATA HD. That should result in ~7-8K IOPS since the disk
> > >> will recognize the sequential stream and read ahead. SAS/SCSI/FC will
> > >> probably work the same way with different IOP rates.
> > >
> > > Yeah, probabaly right. I thought that 10GbE give the IOMMU more
> > > workloads than SSD does and tried to emulate something like that.
> > 
> > 10GbE might exercise a different code path. NICs typically use map_single
> 
> map_page, actually, but effectively the same thing.  However, all
> they're really doing is their own implementation of sg list mapping.

Yeah, they are nearly same. map_single allocates only one DMA address
while sg_map does allocates a DMA address again and again.


> > and storage devices typically use map_sg.  But they both exercise the same
> > underlying resource management code since it's the same IOMMU they poke at.
> > 
> > ...
> > >> Sorry, I didn't see a replacement for the deferred_flush_tables.
> > >> Mark Gross and I agree this substantially helps with unmap performance.
> > >> See http://lkml.org/lkml/2008/3/3/373
> > >
> > > Yeah, I can add a nice trick in parisc sba_iommu uses. I'll try next
> > > time.
> > >
> > > But it probably gives the bitmap method less gain than the RB tree
> > > since clear the bitmap takes less time than changing the tree.
> > >
> > > The deferred_flush_tables also batches flushing TLB. The patch flushes
> > > TLB only when it reaches the end of the bitmap (it's a trick that some
> > > IOMMUs like SPARC does).
> > 
> > The batching of the TLB flushes is the key thing. I was being paranoid
> > by not marking the resource free until after the TLB was flushed. If we
> > know the allocation is going to be circular through the bitmap, flushing
> > the TLB once per iteration through the bitmap should be sufficient since
> > we can guarantee the IO Pdir resource won't get re-used until a full
> > cycle through the bitmap has been completed.
> 
> Not necessarily ... there's a safety vs performance issue here.  As long
> as the iotlb mapping persists, the device can use it to write to the
> memory.  If you fail to flush, you lose the ability to detect device dma
> after free (because the iotlb may still be valid).  On standard systems,
> this happens so infrequently as to be worth the tradeoff.  However, in
> virtualised systems, which is what the intel iommu is aimed at, stale
> iotlb entries can be used by malicious VMs to gain access to memory
> outside of their VM, so the intel people at least need to say whether
> they're willing to accept this speed for safety tradeoff.

Agreed.

The current Intel IOMMU scheme is a bit unbalanced. It invalidates the
translation table every time dma_unmap_* is called, but it does the
batching of the TLB flushes. But it's what the most of Linux's IOMMU
code does.

I think that only PARISC (and IA64, of course) IOMMUs do the batching
of invalidating the translation table entries.
