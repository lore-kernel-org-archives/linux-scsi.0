From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH, RFC] scsi: use host wide tags by default
Date: Mon, 20 Apr 2015 11:07:42 -0700
Message-ID: <1429553262.2222.57.camel@HansenPartnership.com>
References: <1429301471-5666-1-git-send-email-hch@lst.de>
	 <1429306960.1079.25.camel@HansenPartnership.com> <55317EAE.10201@kernel.dk>
	 <1429307160.1079.27.camel@HansenPartnership.com>
	 <55317F86.7030509@kernel.dk>
	 <1429307850.1079.35.camel@HansenPartnership.com>
	 <5531843B.4070608@kernel.dk>
	 <1429309247.1079.56.camel@HansenPartnership.com>
	 <55318BC7.7060204@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35598 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751223AbbDTSHn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 14:07:43 -0400
In-Reply-To: <55318BC7.7060204@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Fri, 2015-04-17 at 16:40 -0600, Jens Axboe wrote:
> On 04/17/2015 04:20 PM, James Bottomley wrote:
> > On Fri, 2015-04-17 at 16:07 -0600, Jens Axboe wrote:
> >> On 04/17/2015 03:57 PM, James Bottomley wrote:
> >>> On Fri, 2015-04-17 at 15:47 -0600, Jens Axboe wrote:
> >>>> On 04/17/2015 03:46 PM, James Bottomley wrote:
> >>> In this case, it is a problem because in theory the language ('C') makes
> >>> no such atomicity guarantees (which is why most people think you need a
> >>> lock here).  The atomicity guarantees are extrapolated from the platform
> >>> it's running on.
> >>>
> >>>>    The write itself might be atomic, but you still need to
> >>>> guarantee visibility.
> >>>
> >>> The function barrier guarantees mean it's visible by the time the
> >>> function returns.  However, I wouldn't object to a wmb here if you think
> >>> it's necessary ... it certainly serves as a marker for "something clever
> >>> is going on".
> >>
> >> The sequence point means it's not reordered across it, it does not give
> >> you any guarantees on visibility. And we're getting into semantics of C
> >> here, but I believe or that even to be valid, you'd need to make
> >> ->queue_depth volatile. And honestly, I'd hate to rely on that. Which
> >> means you need proper barriers.
> >
> > Actually, no, not at all.  Volatile is a compiler optimisation
> > primitive.  It means the compiler may not keep any assignment to this
> > location internally.  Visibility of stores depends on two types of
> > barrier:  One is influenced by the ability of the compiler to reorder
> > operations, which it may up to a barrier.  The other is the ability of
> > the architecture to reorder the execution pipelines, and so execute out
> > of order the instructions the compiler created, which it may up to a
> > barrier sync instruction.  wmb is a heavyweight barrier instruction that
> > would make sure all stores before this become visibile to everything in
> > the system.  In this case it's not necessary because a function return
> > is also a compile and execution barrier, so as long as we don't care
> > about visibility until the scsi_change_queue_depth() function returns
> > (which I think we don't), then no explicit barrier is required (and
> > certainly no volatile on the stored location).
> >
> > There's a good treatise on this in Documentation/memory-barriers.txt but
> > I do find it over didactic for the simple issues.
> 
> wmb() (or smp_wmb()) is a store ordering barrier, it'll do nothing for 
> visibility. So if we want to order multiple stores against each other, 
> then that'd be appropriate.

Um, that's precisely why it's a visibility guarantee: a write memory
barrier guarantees the issuing (from the CPU) of all the stores that
preceded it.  Architecturally, once a store is issued, it becomes fully
visible to any future load.

>  You'd need a read memory barrier to order 
> the load against the store.

No, that's a misconception: rmb guarantees all loads that precede it are
issued, but it's not required for the visibility of a previously issued
store.

Consider this code:

CPU1               CPU2

...
*location = 1;
wmb();

                   barrier();
                   if (*location)

As long as the load of *location occurs temporally after the wmb, it
sees the value 1.  The barrier() (not a rmb()) may ensure that
temporality (compiler may reorder the if to occur before the CPU1 wmb())
but it's not necessary to the execution of the code.  That if only needs
to see either the prev or current values of *location.   Now, if CPU2
used *location earlier, the if() may still operate on the cached value
but the barrier() also causes a register spill which necessitates a
reload of *location in the if clause (can also do this with
ACCESS_ONCE()).

The reason we don't need rmb is because the if (*location) loads and
uses the value, that means the load has to be issued for the condition
to be tested, meaning we don't need to force the load.

>  Adding that before reading ->queue_depth 
> would be horrible. So then you'd need to do a full barrier, at which 
> point you may as well keep the lock, if your point is about doing the 
> most optimal code so that people will be forced to do that everywhere.

I think I've explained, that's incorrect.  You don't even need a wmb()
because the function return is a memory barrier.

> So your claim is that a function call (or sequence point) is a full 
> memory barrier. That is not correct, or I missed that in the C spec.

Yes, a function call the compiler knows nothing about (i.e. only knows
in this compile unit from a prototype) is a full memory barrier.  It has
to be for optimization theory to work.  From the CPU point of view, most
of them treat the return instruction as a load/store barrier but if they
don't, the compiler adds the necessary instructions to keep its required
memory barrier intact (I think, infact, all CPUs linux deals with ret is
a CPU load/store barrier because it terminates the execution pipelines).

>  If 
> that's the case, what if the function is inlined?

If a function is inlined, then the compiler has some knowledge of the
internals and then may decide not to treat it as a full barrier based on
that knowledge.

In the case of scsi_change_queue_depth(), it's provided by the mid-layer
and consumed by the LLDs, so to them it is a full memory barrier because
it's provided by a different compile segment from the consumer.

James



