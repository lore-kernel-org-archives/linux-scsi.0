From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Mon, 20 Sep 2004 15:40:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409201540.02297.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <20040918061001.GC21456@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:24463 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S265487AbUITWkW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 18:40:22 -0400
In-Reply-To: <20040918061001.GC21456@colo.lackof.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Friday, September 17, 2004 11:10 pm, Grant Grundler wrote:
> Jesse Barnes wrote:
> ...
>
> > Btw Andrew (Vasquez), there's a small doc I put together that should
> > describe when you have to worry about PCI posting.  It's in the tree:
> > Documentation/io_ordering.txt.  If it's incomplete or confusing, just let
> > me know and I'll update it.
>
> Jesse,
> Both. incomplete and confusing.
> "concrete example of a hypothetical driver" wasn't my first warning
> this document needed work. :^)

Heh, yeah I noticed that on re-reading too :)

> I've hacked up the 2.6.9 version and even what I did still needs more work.
> Have time to correct my mistakes and answer the questions I ask?
>
> I'd be happy to review it again after you've done another round on it.
>
> []'s should all go away - used those to mark editorial notes.

Sure, thanks for reading it.

> Weakly Ordered Memory Mapped IO
> -------------------------------
>
> SGI Altix chipset implements weakly ordered Memory-Mapped I/O writes.
> On this platform, driver writers are responsible for ensuring I/O writes
> to memory-mapped addresses arrive in the order intended.

This is incorrect.  I wrote this before I understood that 'pci write posting' 
was the common term for describing the fact that writes from different CPUs 
could arrive out of order.  A s/weakly ordered/write posting would make the 
existing document much more accurate.

> Like for PCI write posting problems, this is done by reading
> a 'safe' device or bridge register, causing the I/O chipset to
> flush pending writes to the device before any reads are issued.
> A driver would issue the "safe" read immediately prior to the exit
> of a critical section of code protected by spinlocks.  This would
> ensure subsequent writes to I/O space arrived only after all prior
> writes (much like a memory barrier op, mb(), only with respect to I/O).
>
> Note: MMIO reads are expensive! Don't add MMIO reads after *every* MMIO
>       write unless the device programming model absolutely requires it.

Yes!

>
>
> An example from a hypothetical device driver might help:
>
>         ...
> CPU A:  spin_lock_irqsave(&dev_lock, flags)
> CPU A:  val = readl(my_status);
> CPU A:  ...
> CPU A:  writel(newval, ring_ptr);
> CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
>         ...
> CPU B:  spin_lock_irqsave(&dev_lock, flags)
> CPU B:  val = readl(my_status);
> CPU B:  ...
> CPU B:  writel(newval2, ring_ptr);
> CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
>         ...
>
> In the case above, the device may receive newval2 before it receives
> newval, which could cause problems.
>
> [ Is this example broken or am I just staying up too late?
>   The example is doing a readl() in the second critical section.
>   Shouldn't that enforce the write ordering?
> ]

Yep, that's a bug.  It should just be writes.

> The reads from safe_register will cause the I/O chipset to flush any
> pending writes before actually posting the read to the chipset, preventing
> possible data corruption.
>
> [ How about interactions with:
>   o read_relaxed()?
>   o DMA?
>   o IO Port space reads?
>   o IO Port space writes?
> ]

None that I know of.

Jesse
