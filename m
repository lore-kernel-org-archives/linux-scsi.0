From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Mon, 20 Sep 2004 17:09:44 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409201709.45008.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409201540.02297.jbarnes@engr.sgi.com> <20040920232716.GD19511@colo.lackof.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_IF3TBVShv8BhQGa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:63119 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S266790AbUIUAKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Sep 2004 20:10:07 -0400
In-Reply-To: <20040920232716.GD19511@colo.lackof.org>
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

--Boundary-00=_IF3TBVShv8BhQGa
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday, September 20, 2004 4:27 pm, Grant Grundler wrote:
> "write posting" is orthogonal to PCI ordering rules.
> AFAIK, Write posting is not specific to PCI - but any memory mapped IO.

Right.

> I understand "write posting" as when the CPU posts the write
> to the chipset and the chipset says the write is done even though
> it hasn't reached the PCI device. It just means the write has reached
> the PCI "domain" (which is supposed to be strongly ordered).

That's my understanding too.

> Secondly, I don't recall hearing about problems like this
> on Intel or HP ia64 machines. I've only run into PCI posted write
> and DMA syncronization problems where the drivers aren't following
> all the rules quite right (missing mb() and readl()'s mostly).

Problems like what?  If mmio writes are posted, then the driver has to deal 
with it with reads like you said.  If the example code was fixed to lose the 
read() in the second spinlock protected region, I think it would describe 
mmio write posting accurately, no?

> So far, I still think this document is misnamed and should
> be called something like "SGI Altix porting issues" and moved
> under the Documentation/ia64 directory.

But it has nothing to do with Altix at all...

>
> > > [ Is this example broken or am I just staying up too late?
> > >   The example is doing a readl() in the second critical section.
> > >   Shouldn't that enforce the write ordering?
> > > ]
> >
> > Yep, that's a bug.  It should just be writes.
>
> ok. Can you fix that up and post a new version where I can see it?
>
> > > The reads from safe_register will cause the I/O chipset to flush any
> > > pending writes before actually posting the read to the chipset,
> > > preventing possible data corruption.
> > >
> > > [ How about interactions with:
> > >   o read_relaxed()?
> > >   o DMA?
> > >   o IO Port space reads?
> > >   o IO Port space writes?
> > > ]
> >
> > None that I know of.
>
> You mean none that are surprising to you?
> ie writes can pass read_relaxed() transactions or vice versa?
> DMA read returns can bypass MMIO writes? (parisc chipsets allow this)

No, as far as mmio ordering goes, read_relaxed is exactly the same as read, so 
in the example code, a read_relaxed would be sufficient for write ordering.

> IIRC, IO port space writes are NOT posted.
> So the rules for ordering must be impacted or different somehow.
> ie Are IO Port space writes strongly ordered WRT MMIO space writes?

Right, they're supposed to be strongly ordered, I think arches are supposed to 
guarantee that in their in/out routines.

Here's a new version that should be clearer.

Thanks,
Jesse

--Boundary-00=_IF3TBVShv8BhQGa
Content-Type: text/plain;
  charset="iso-8859-1";
  name="io_ordering.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="io_ordering.txt"

Dealing with posted writes
--------------------------

On some platforms platforms, driver writers are responsible for
ensuring that I/O writes to memory-mapped addresses on their device
arrive in the order intended.  This is typically done by reading a
'safe' device or bridge register, causing the I/O chipset to flush
pending writes to the device before any reads are posted.  A driver
would usually use this technique immediately prior to the exit of a
critical section of code protected by spinlocks.  This would ensure
that subsequent writes to I/O space arrived only after all prior
writes (much like a memory barrier op, mb(), only with respect to
I/O).

Some pseudocode to illustrate the problem:

        ...
CPU A:  spin_lock_irqsave(&dev_lock, flags)
CPU A:  ...
CPU A:  writel(newval, ring_ptr);
CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
        ...
CPU B:  spin_lock_irqsave(&dev_lock, flags)
CPU B:  ...
CPU B:  writel(newval2, ring_ptr);
CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
        ...

In the case above, the device may receive newval2 before it receives newval,
which could cause problems.  Fixing it is easy enough though:

        ...
CPU A:  spin_lock_irqsave(&dev_lock, flags)
CPU A:  ...
CPU A:  writel(newval, ring_ptr);
CPU A:  (void)readl(safe_register); /* maybe a config register? */
CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
        ...
CPU B:  spin_lock_irqsave(&dev_lock, flags)
CPU B:  ...
CPU B:  writel(newval2, ring_ptr);
CPU B:  (void)readl(safe_register); /* or read_relaxed() */
CPU B:  spin_unlock_irqrestore(&dev_lock, flags)

Here, the reads from safe_register will cause the I/O chipset to flush any
pending writes before actually posting the read to the chipset, preventing
possible data corruption.

This sort of synchronization is only necessary for read/write calls,
not in/out calls, since they're by definition strongly ordered.

We should probably add a writeflush call or something to deal with the
above in an easier to read way.  Some platforms could even implement
such a routine more efficiently than a regular read.

--Boundary-00=_IF3TBVShv8BhQGa--
