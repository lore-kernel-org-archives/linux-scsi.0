From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Sat, 18 Sep 2004 00:10:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040918061001.GC21456@colo.lackof.org>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:50060 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S269139AbUIRGKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Sep 2004 02:10:04 -0400
Content-Disposition: inline
In-Reply-To: <200409171021.20263.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>


Jesse Barnes wrote:
...
> Btw Andrew (Vasquez), there's a small doc I put together that should describe 
> when you have to worry about PCI posting.  It's in the tree:  
> Documentation/io_ordering.txt.  If it's incomplete or confusing, just let me 
> know and I'll update it.

Jesse,
Both. incomplete and confusing.
"concrete example of a hypothetical driver" wasn't my first warning
this document needed work. :^)

I've hacked up the 2.6.9 version and even what I did still needs more work.
Have time to correct my mistakes and answer the questions I ask?

I'd be happy to review it again after you've done another round on it.

[]'s should all go away - used those to mark editorial notes.

hth,
grant


--------------------- cut here ------------------

Weakly Ordered Memory Mapped IO
-------------------------------

SGI Altix chipset implements weakly ordered Memory-Mapped I/O writes.
On this platform, driver writers are responsible for ensuring I/O writes
to memory-mapped addresses arrive in the order intended.

Like for PCI write posting problems, this is done by reading
a 'safe' device or bridge register, causing the I/O chipset to
flush pending writes to the device before any reads are issued.
A driver would issue the "safe" read immediately prior to the exit
of a critical section of code protected by spinlocks.  This would
ensure subsequent writes to I/O space arrived only after all prior
writes (much like a memory barrier op, mb(), only with respect to I/O).

Note: MMIO reads are expensive! Don't add MMIO reads after *every* MMIO
      write unless the device programming model absolutely requires it.


An example from a hypothetical device driver might help:

        ...
CPU A:  spin_lock_irqsave(&dev_lock, flags)
CPU A:  val = readl(my_status);
CPU A:  ...
CPU A:  writel(newval, ring_ptr);
CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
        ...
CPU B:  spin_lock_irqsave(&dev_lock, flags)
CPU B:  val = readl(my_status);
CPU B:  ...
CPU B:  writel(newval2, ring_ptr);
CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
        ...

In the case above, the device may receive newval2 before it receives newval,
which could cause problems.

[ Is this example broken or am I just staying up too late?
  The example is doing a readl() in the second critical section.
  Shouldn't that enforce the write ordering?
]

Fixing it is easy enough though:

        ...
CPU A:  spin_lock_irqsave(&dev_lock, flags)
CPU A:  val = readl(my_status);
CPU A:  ...
CPU A:  writel(newval, ring_ptr);
CPU A:  (void)readl(safe_register); /* maybe a config register? */
CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
        ...
CPU B:  spin_lock_irqsave(&dev_lock, flags)
CPU B:  val = readl(my_status);
CPU B:  ...
CPU B:  writel(newval2, ring_ptr);
CPU B:  (void)readl(safe_register); /* maybe a config register? */
CPU B:  spin_unlock_irqrestore(&dev_lock, flags)

The reads from safe_register will cause the I/O chipset to flush any
pending writes before actually posting the read to the chipset, preventing
possible data corruption.

[ How about interactions with:
  o read_relaxed()?
  o DMA?
  o IO Port space reads?
  o IO Port space writes?
]

