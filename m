From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 09:25:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409210925.50639.jbarnes@engr.sgi.com>
References: <20040917183029.GW642@parcelfarce.linux.theplanet.co.uk> <200409201709.45008.jbarnes@engr.sgi.com> <20040921054626.GF19511@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:49304 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267690AbUIUN0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 09:26:24 -0400
In-Reply-To: <20040921054626.GF19511@colo.lackof.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, pj@sgi.com, linux-scsi@vger.kernel.org, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 1:46 am, Grant Grundler wrote:
> I've never heard of multiple writes from different CPUs going out of order
> to the PCI device.

Are you sure?  Isn't that the definition of write posting?  At any rate, sn2 
has the write posting issue (which seems to call for a pioflush routine), but 
also a *potential* for out of order writes, which is what's described in this 
document.  There was a big discussion on lkml about this awhile back when I 
tried to push in an mmiob() (pioflush) API.  It was lacking arguments, 
however, and so was not really usable on many platforms.

> > If mmio writes are posted, then the driver has to deal
> > with it with reads like you said.
>
> No it doesn't. Only if it depends on *when* the write hits the device.
> The classic example is:
>  writel(x, CMD_RESET);
>  udelay(10);
>  readl(x+STATUS); /* parisc will crash if not ready */
>
> >   If the example code was fixed to lose the
> > read() in the second spinlock protected region, I think it would describe
> > mmio write posting accurately, no?
>
> No.  Can you add something to the example that shows they expected
> the writes to hit the device at a certain time?

Yeah, the qla2xxx driver is a perfect example of this.  But we don't have an 
alternative to udelay at this point, maybe we need pioflush(device *, 
unsigned long addr)?  That would allow arch code to read from the device's 
bridge config space, or at the very least do a delay (a maximal value, 
guaranteed to not be exceeded) and read addr?

> The CPU would continue doing other work before the writes reach
> the device but they would reach the device in order.
> I'm pretty sure of that on most IA32, parisc, and IA64 platforms.

Not on sn2.  The local chipset could receive the write, the process could be 
rescheduled to another cpu closer to the target device, and its write (the 
second one) could get there first.  So on sn2 we need a read following writes 
prior to spinlock release.

> The only exceptions I'm aware of are some broken ia32 chipsets which
> have issues with write ordering - see TG3_FLAG_MBOX_WRITE_REORDER usage
> in drivers/net/tg3.*.
> Comment says:
>         /* If we have an AMD 762 or Intel ICH/ICH0/ICH2 chipset, write
>          * reordering to the mailbox registers done by the host
>          * controller can cause major troubles.  We read back from
>          * every mailbox register write to force the writes to be
>          * posted to the chip in order.
>          */
>
> I haven't seen any evidence of this happening yet on ia64.
> If it is, then I'd really like to know about it and we should fix
> tg3 since both HP and SGI ship product that depends on tg3 driver.

This will only happen if the writes come from different CPUs.  A stream of 
program order writes under a spinlock will *not* be reordered (that's a big 
hw bug IMO).

> > > So far, I still think this document is misnamed and should
> > > be called something like "SGI Altix porting issues" and moved
> > > under the Documentation/ia64 directory.
> >
> > But it has nothing to do with Altix at all...
>
> Ok.
> Can you be explicit on which platforms and which drivers
> anyone at SGI has seen the ordering problem?
> Why did you write this document in the first place?

To help people understand that they need to deal with the issue.

> The first sentence on the new version (below) still introduces
> this as an ordering problem and not a write posting problem.
>
> > > You mean none that are surprising to you?
> > > ie writes can pass read_relaxed() transactions or vice versa?
> > > DMA read returns can bypass MMIO writes? (parisc chipsets allow this)
> >
> > No, as far as mmio ordering goes, read_relaxed is exactly the same as
> > read, so in the example code, a read_relaxed would be sufficient for
> > write ordering.
>
> Ok - that's surprising to me and should be clearly stated.
> I do not expect read_relaxed() to enforce ordering in either direction
> of the data path - not for MMIO writes nor DMA writes.

But it *has* to for mmio writes.  Not only do those transactions occur on the 
same 'channel', but the read may depend on the side effects of prior writes.

> Yes. Again, stating it in this document makes it clear what you
> expect from the platform support code.

Ok.

> The writes will arrive in order according to PCI ordering rules.
> Wasn't this supposed to be about write posting?

More confusion.  It's about write posting with a small, added wrinkle.  The 
issues are related enough that it probably makes sense to include them in the 
same doc (though I had neglected to describe the fact that writes won't get 
to the device right away).

> Documentation/DocBook/deviceiobook.tmpl has a paragraph on write posting.
> I think a patch to deviceiobook.tmpl would be better than having
> write posting discussed in a seperate file if you think it needs
> an example.

Ok, that sounds good.

> I'm pretty sure spinlocks are supposed to provide memory barriers.
> Maybe that's only to gcc so it doesn't re-order loads/stores around
> a spinlock. But I thought the ia64 implemention used the same "release"
> and "acquire" semantics as readX() and writeX() do.

This has nothing to do with weak ordering (I was wrong to state it that way, 
and ended up just making for a confusing analogy).  It has to do with writes 
coming from different nodes on the NUMA fabric.

> > Here, the reads from safe_register will cause the I/O chipset to flush
> > any pending writes before actually posting the read to the chipset,
> > preventing possible data corruption.
>
> That should probably be
>   "...flush any posted writes before posting the read return...".

Ok.

>
> > This sort of synchronization is only necessary for read/write calls,
> > not in/out calls, since they're by definition strongly ordered.
>
> Similarly:
>  inX and outX calls are strongly ordered and non-postable.
>  They do not need special handling. But this is something to watch out
>  for when converting drivers to use MMIO space from IO Port space.

Sounds good.

Thanks again,
Jesse
