From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Mon, 20 Sep 2004 17:27:16 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040920232716.GD19511@colo.lackof.org>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <20040918061001.GC21456@colo.lackof.org> <200409201540.02297.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:62425 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S266910AbUITX1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 19:27:18 -0400
Content-Disposition: inline
In-Reply-To: <200409201540.02297.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Mon, Sep 20, 2004 at 03:40:02PM -0700, Jesse Barnes wrote:
> > Weakly Ordered Memory Mapped IO
> > -------------------------------
> >
> > SGI Altix chipset implements weakly ordered Memory-Mapped I/O writes.
> > On this platform, driver writers are responsible for ensuring I/O writes
> > to memory-mapped addresses arrive in the order intended.
> 
> This is incorrect.  I wrote this before I understood that 'pci write posting' 
> was the common term for describing the fact that writes from different CPUs 
> could arrive out of order.  A s/weakly ordered/write posting would make the 
> existing document much more accurate.

"write posting" is orthogonal to PCI ordering rules.
AFAIK, Write posting is not specific to PCI - but any memory mapped IO.

I understand "write posting" as when the CPU posts the write
to the chipset and the chipset says the write is done even though
it hasn't reached the PCI device. It just means the write has reached
the PCI "domain" (which is supposed to be strongly ordered).

Page 304 of "ia-64 linux kernel" book decsribes how writel ordering
(within a CPU) is enforced with "release semantics" (ie .rel in asm ).
IA64 spinlocks also use .rel and thus I'm pretty sure from the CPU
PoV, writel()s will be posted by the releasing the lock.
I think willy pointed at the docs describing this in general terms.

Secondly, I don't recall hearing about problems like this
on Intel or HP ia64 machines. I've only run into PCI posted write
and DMA syncronization problems where the drivers aren't following
all the rules quite right (missing mb() and readl()'s mostly).

So far, I still think this document is misnamed and should
be called something like "SGI Altix porting issues" and moved
under the Documentation/ia64 directory.


> > [ Is this example broken or am I just staying up too late?
> >   The example is doing a readl() in the second critical section.
> >   Shouldn't that enforce the write ordering?
> > ]
> 
> Yep, that's a bug.  It should just be writes.

ok. Can you fix that up and post a new version where I can see it?

> > The reads from safe_register will cause the I/O chipset to flush any
> > pending writes before actually posting the read to the chipset, preventing
> > possible data corruption.
> >
> > [ How about interactions with:
> >   o read_relaxed()?
> >   o DMA?
> >   o IO Port space reads?
> >   o IO Port space writes?
> > ]
> 
> None that I know of.

You mean none that are surprising to you?
ie writes can pass read_relaxed() transactions or vice versa?
DMA read returns can bypass MMIO writes? (parisc chipsets allow this)

IIRC, IO port space writes are NOT posted.
So the rules for ordering must be impacted or different somehow.
ie Are IO Port space writes strongly ordered WRT MMIO space writes?

thanks,
grant
