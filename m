From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Fri, 12 Jun 2009 16:43:26 +0000
Message-ID: <1244825006.4184.37.camel@mulgrave.site>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
	 <4A31319C.605@linux.vnet.ibm.com>
	 <da824cf30906120808o7857034an32640102d64ca106@mail.gmail.com>
	 <4A3272E3.3010000@linux.vnet.ibm.com>
	 <da824cf30906120920r59d4bf79veacdcf6c3637a25d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57212 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765734AbZFLQn1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jun 2009 12:43:27 -0400
In-Reply-To: <da824cf30906120920r59d4bf79veacdcf6c3637a25d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, gregkh@suse.de

On Fri, 2009-06-12 at 09:20 -0700, Grant Grundler wrote:
> On Fri, Jun 12, 2009 at 8:23 AM, Brian King<brking@linux.vnet.ibm.com> wrote:
> ...
> > SCSI allows 8 byte LUNs these days. The reference you make here refers
> > to bits in CDB which are now reserved.
> 
> 
> OK - thanks (also say jejb's follow up - thanks too)
> 
> >
> >>>> +     spin_unlock_irqrestore(&pinstance->pending_pool_lock, lock_flags);
> >>>> +
> >>>> +     /* Mulitple paths (IO path, control path) may be submitting IOARCBs,
> >>>> +      * hence it is necessary to protect writes to IOA's ioarrin register.
> >>>> +      * All writes to IOA ioarrin are synchronized with host_lock
> >>>> +      */
> >>>> +     if (lock)
> >>>> +             spin_lock_irqsave(pinstance->host->host_lock,
> >>>> +                               pinstance->host_lock_flags);
> >>>> +
> >>>> +     /* apply memory barrier */
> >>>> +     mb();
> >>>> +     /* driver writes lower 32-bit value of IOARCB address only */
> >>>> +     write64(cmd->ioa_cb->ioarcb.ioarcb_bus_addr, pinstance->ioarrin);
> >>>> +
> >>>> +     if (lock)
> >>>> +             spin_unlock_irqrestore(pinstance->host->host_lock,
> >>>> +                                    pinstance->host_lock_flags);
> >>> Any way to get rid of this lock flag getting passed in?
> >>
> >> And I believe due to spinlock/unlock, the mb() is not needed.
> >> Spin locks imply memory barriers.
> >
> > Incorrect.
> 
> It's generally correct. Spin unlock implies a memory write barrier.
> OS's would be utterly broken if that were not true.

Spin locks usually imply a barrier on *exit* from the critical section,
not necessarily a barrier on entry ... CPU speculation usually takes
care of any interlocks pending in the pipe.  In this case, I believe the
purpose of the lock is to make the CPU emit two 32 bit writes if it has
to split the 64 bit one, without getting any interleaving from any other
pending writes to the device.  For that case, you do also need the mb()
on entry to ensure all other pending writes that might be visible to the
device are flushed.

This because cards often do strange things unless 64 bit registers are
updated atomically if you use 32 bit writes.

> See IA64-linux kernel by David Mosberger and Stephane Eranian.
> (Part of section 7.2.1 "Memory Mapped IO", page 303, "Ordering Memory
> Accesses on IA-64").
> 
> (And while some parts of the book describe APIs that are obsolete,
> still a good reference on OS internals/design).
> 
> > The memory barrier here ensures that the command being
> > constructed for the adapter is in a consistent state and that all
> > the writes to the command buffer are flushed to memory before
> > the write64 happens, which will trigger the adapter to DMA the
> > command buffer and start executing the command.
> 
> I understand the application. The mb() is NOT needed.
> The spin lock already guarantees cache coherency of
> the Memory write (not MMIO writes!).

Right, but it doesn't necessarily guarantee issue order from the CPU on
entry into the critical section ... and that can be a problem if there's
a pending write to another address in this PCI device because it might
interleave with the two 32 bit writes ... the speculation pipeline won't
necessarily see them as dependent.

> If anything, mmiowb() is needed.  Off hand, I believe
> mmiowb() should be *after* the write64() since we want
> to make sure the write64() is delivered to PCI subsystem
> (where ordering is enforced) before the CPU releases
> the next lock or other semaphore.

No, this is nothing to do with interlocking the I/O domain with the CPU
memory domain ... the writes will likely get posted anyway.  This lock
is about ensuring issue order of the writes from the CPU.

> And AFAIK, mmiowb() is only required to run on SGI Altix machines
> due to the fact that releasing a spinlock does not guarantee ordering
> of MMIO transactions on their HW.
> 
> (credit to jejb and willy for reminding me of the mmiowb() case).

mmiowb() is all about trying to make the I/O domain and the memory
domain coherent, which isn't what's being done here.

James


