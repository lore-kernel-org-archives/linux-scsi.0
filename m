From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 13:06:25 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921190625.GB11708@colo.lackof.org>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409211346.58267.jbarnes@engr.sgi.com> <1095789421.2467.414.camel@mulgrave> <200409211409.11095.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:7043 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S267978AbUIUTG1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 15:06:27 -0400
Content-Disposition: inline
In-Reply-To: <200409211409.11095.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@debian.org>, Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tue, Sep 21, 2004 at 02:09:10PM -0400, Jesse Barnes wrote:
> Grant, you say that I/O writes can't possibly arrive out of order if issued 
> from different CPUs on any machines you're aware of?

Well, that's what I believe right now based on my experience.
Re-reading different parts of the PCI local bus spec doesn't give
me the warm fuzzies - especially in regard to retries.

The qla example Jeremy gave earlier wasn't clear on where the
mmio write reordering was taking place.  Based on my understanding
(and I've been wrong before) of ia64 .rel/.acq semantics the reordering
didn't happen in the CPU coherency - ie writes are ordered WRT
to each other out to the Mckinley bus. That really only leaves
the chipset suspect - ie anything between Mckinley bus and PCI bus.

And this chipset is already known to violate DMA writes and
MMIO read return ordering rules...which led to read_relaxed().
We've agreed DMA reads bypassing MMIO writes violates the spec
but is "mostly harmless" (I haven't seen a case in real life where
it matters). HP parisc and ia64 platforms also implement
this "optimization" (bug) and I've not seen a problem with it yet.

> If not, it may be that the API will only benefit SGI machines.

Or hurt them.
We haven't talked about the flip side of this workaround much.

Normally, I expect the chipset is responsible for maintaining
order of MMIO writes - though that sounds near impossible on
a large fabric where the spinlock transactions may take a different
path than the IO transactions. But allowing out of order MMIO
write transactions is a big deal if we want high performance
devices that can operate correctly by only consuming MMIO
writes and doing DMA for everything else. Adding the MMIO
reads to enforcing MMIO write ordering will set us all back
a few years in terms of performance.

This behavior (bug?) essentially means drivers that only do MMIO
writes during normal operation (and MMIO reads during set up) will
not operate correctly on Altix (or similar if they exist) boxes.

hth,
grant
