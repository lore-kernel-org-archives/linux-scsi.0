From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Mon, 20 Sep 2004 23:46:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921054626.GF19511@colo.lackof.org>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409201540.02297.jbarnes@engr.sgi.com> <20040920232716.GD19511@colo.lackof.org> <200409201709.45008.jbarnes@engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:54241 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S267330AbUIUFqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 01:46:30 -0400
Content-Disposition: inline
In-Reply-To: <200409201709.45008.jbarnes@engr.sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jesse Barnes <jbarnes@engr.sgi.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Mon, Sep 20, 2004 at 05:09:44PM -0700, Jesse Barnes wrote:
> > Secondly, I don't recall hearing about problems like this
> > on Intel or HP ia64 machines. I've only run into PCI posted write
> > and DMA syncronization problems where the drivers aren't following
> > all the rules quite right (missing mb() and readl()'s mostly).
> 
> Problems like what?

I've never heard of multiple writes from different CPUs going out of order
to the PCI device.

> If mmio writes are posted, then the driver has to deal 
> with it with reads like you said.

No it doesn't. Only if it depends on *when* the write hits the device.
The classic example is:
	writel(x, CMD_RESET);
	udelay(10);
	readl(x+STATUS);	/* parisc will crash if not ready */

>   If the example code was fixed to lose the 
> read() in the second spinlock protected region, I think it would describe 
> mmio write posting accurately, no?

No.  Can you add something to the example that shows they expected
the writes to hit the device at a certain time?

The CPU would continue doing other work before the writes reach
the device but they would reach the device in order.
I'm pretty sure of that on most IA32, parisc, and IA64 platforms.

The only exceptions I'm aware of are some broken ia32 chipsets which
have issues with write ordering - see TG3_FLAG_MBOX_WRITE_REORDER usage
in drivers/net/tg3.*.
Comment says:
        /* If we have an AMD 762 or Intel ICH/ICH0/ICH2 chipset, write
         * reordering to the mailbox registers done by the host
         * controller can cause major troubles.  We read back from
         * every mailbox register write to force the writes to be
         * posted to the chip in order.
         */

I haven't seen any evidence of this happening yet on ia64.
If it is, then I'd really like to know about it and we should fix
tg3 since both HP and SGI ship product that depends on tg3 driver.

> > So far, I still think this document is misnamed and should
> > be called something like "SGI Altix porting issues" and moved
> > under the Documentation/ia64 directory.
> 
> But it has nothing to do with Altix at all...

Ok.
Can you be explicit on which platforms and which drivers
anyone at SGI has seen the ordering problem?
Why did you write this document in the first place?

The first sentence on the new version (below) still introduces
this as an ordering problem and not a write posting problem.

> > You mean none that are surprising to you?
> > ie writes can pass read_relaxed() transactions or vice versa?
> > DMA read returns can bypass MMIO writes? (parisc chipsets allow this)
> 
> No, as far as mmio ordering goes, read_relaxed is exactly the same as read,
> so in the example code, a read_relaxed would be sufficient for write ordering.

Ok - that's surprising to me and should be clearly stated.
I do not expect read_relaxed() to enforce ordering in either direction
of the data path - not for MMIO writes nor DMA writes.

> > IIRC, IO port space writes are NOT posted.
> > So the rules for ordering must be impacted or different somehow.
> > ie Are IO Port space writes strongly ordered WRT MMIO space writes?
> 
> Right, they're supposed to be strongly ordered, I think arches are
> supposed to guarantee that in their in/out routines.

Yes. Again, stating it in this document makes it clear what you
expect from the platform support code.

> Here's a new version that should be clearer.
> 
> Thanks,
> Jesse

> Dealing with posted writes
> --------------------------
> 
> On some platforms platforms, driver writers are responsible for
> ensuring that I/O writes to memory-mapped addresses on their device
> arrive in the order intended.

The writes will arrive in order according to PCI ordering rules.
Wasn't this supposed to be about write posting?

Documentation/DocBook/deviceiobook.tmpl has a paragraph on write posting.
I think a patch to deviceiobook.tmpl would be better than having
write posting discussed in a seperate file if you think it needs
an example.

> This is typically done by reading a
> 'safe' device or bridge register, causing the I/O chipset to flush
> pending writes to the device before any reads are posted.  A driver
> would usually use this technique immediately prior to the exit of a
> critical section of code protected by spinlocks.  This would ensure
> that subsequent writes to I/O space arrived only after all prior
> writes (much like a memory barrier op, mb(), only with respect to
> I/O).
> 
> Some pseudocode to illustrate the problem:
> 
>         ...
> CPU A:  spin_lock_irqsave(&dev_lock, flags)
> CPU A:  ...
> CPU A:  writel(newval, ring_ptr);
> CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
>         ...
> CPU B:  spin_lock_irqsave(&dev_lock, flags)
> CPU B:  ...
> CPU B:  writel(newval2, ring_ptr);
> CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
>         ...

I'm pretty sure spinlocks are supposed to provide memory barriers.
Maybe that's only to gcc so it doesn't re-order loads/stores around
a spinlock. But I thought the ia64 implemention used the same "release"
and "acquire" semantics as readX() and writeX() do.

The alph implementation explicitly enforces it:
(arch/alpha/lib/io.c)

	void _writel(u32 b, unsigned long addr)
	{
		__writel(b, addr);
		mb();
	}


> In the case above, the device may receive newval2 before it receives newval,
> which could cause problems.  Fixing it is easy enough though:
> 
>         ...
> CPU A:  spin_lock_irqsave(&dev_lock, flags)
> CPU A:  ...
> CPU A:  writel(newval, ring_ptr);
> CPU A:  (void)readl(safe_register); /* maybe a config register? */
> CPU A:  spin_unlock_irqrestore(&dev_lock, flags)
>         ...
> CPU B:  spin_lock_irqsave(&dev_lock, flags)
> CPU B:  ...
> CPU B:  writel(newval2, ring_ptr);
> CPU B:  (void)readl(safe_register); /* or read_relaxed() */
> CPU B:  spin_unlock_irqrestore(&dev_lock, flags)
> 
> Here, the reads from safe_register will cause the I/O chipset to flush any
> pending writes before actually posting the read to the chipset, preventing
> possible data corruption.

That should probably be
	 "...flush any posted writes before posting the read return...".


> This sort of synchronization is only necessary for read/write calls,
> not in/out calls, since they're by definition strongly ordered.

Similarly:
	inX and outX calls are strongly ordered and non-postable.
	They do not need special handling. But this is something to watch out
	for when converting drivers to use MMIO space from IO Port space.

> We should probably add a writeflush call or something to deal with the
> above in an easier to read way.  Some platforms could even implement
> such a routine more efficiently than a regular read.

thanks,
grant
