From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 14:03:42 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921210341.GC146363@sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com> <20040921190625.GB11708@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus.kernel.org ([204.152.189.113]:42992 "EHLO zeus.kernel.org")
	by vger.kernel.org with ESMTP id S268082AbUIUVEd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 17:04:33 -0400
Received: from omx3.sgi.com (omx3-ext.sgi.com [192.48.171.20])
	by zeus.kernel.org (8.12.11/8.11.6) with ESMTP id i8LL4VfA000811
	for <linux-scsi@vger.kernel.org>; Tue, 21 Sep 2004 14:04:32 -0700
Content-Disposition: inline
In-Reply-To: <20040921190625.GB11708@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Jesse Barnes <jbarnes@engr.sgi.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 01:06:25PM -0600, Grant Grundler wrote:
> On Tue, Sep 21, 2004 at 02:09:10PM -0400, Jesse Barnes wrote:
> > Grant, you say that I/O writes can't possibly arrive out of order if issued 
> > from different CPUs on any machines you're aware of?
> 
> Well, that's what I believe right now based on my experience.
> Re-reading different parts of the PCI local bus spec doesn't give
> me the warm fuzzies - especially in regard to retries.
> 
> The qla example Jeremy gave earlier wasn't clear on where the
> mmio write reordering was taking place.  Based on my understanding
> (and I've been wrong before) of ia64 .rel/.acq semantics the reordering
> didn't happen in the CPU coherency - ie writes are ordered WRT
> to each other out to the Mckinley bus. That really only leaves
> the chipset suspect - ie anything between Mckinley bus and PCI bus.

Do IO space writes follow the memory coherency rules?

> And this chipset is already known to violate DMA writes and
> MMIO read return ordering rules...which led to read_relaxed().
> We've agreed DMA reads bypassing MMIO writes violates the spec
> but is "mostly harmless" (I haven't seen a case in real life where
> it matters). HP parisc and ia64 platforms also implement
> this "optimization" (bug) and I've not seen a problem with it yet.
> 
> > If not, it may be that the API will only benefit SGI machines.
> 
> Or hurt them.
> We haven't talked about the flip side of this workaround much.
> 
> Normally, I expect the chipset is responsible for maintaining
> order of MMIO writes - though that sounds near impossible on
> a large fabric where the spinlock transactions may take a different
> path than the IO transactions. But allowing out of order MMIO
> write transactions is a big deal if we want high performance
> devices that can operate correctly by only consuming MMIO
> writes and doing DMA for everything else. Adding the MMIO
> reads to enforcing MMIO write ordering will set us all back
> a few years in terms of performance.

On Altix, we do have the sn_mmiob() option.  I don't think that
we want to Linux API to require that

CPUA:	writel(value_X, common_register)
	spin_unlock(common_lock)

CPUB:	spin_lock(common_lock)
	writel(value_Y, common_register)

be strongly ordered, because it places a performance penalty
on all writes.  On Altix, we have the "sn_mmiob()" function to do
that.  I.e.

CPUA:	writel(value_X, common_register)
	sn_mmiob()
	spin_unlock(common_lock)

CPUB:	spin_lock(common_lock)
	writel(value_Y, common_register)

would strongly order the writes.

I think the flush that Jesse was talking about was an architecture
independent abstraction of the sn_mmiob().

Note that the sn_mmiob() does not guarantee that the preceding writel is
completed -- just that there will be no other writeX issued from other
CPUs ahead of it.

However, if we lose this argument, the simple answer is to add an
sn_mmiob to the Altix platform's writeX functions.  See ___sn_outb(),
by the way.

jeremy
