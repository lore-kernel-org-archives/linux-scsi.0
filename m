From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Thu, 03 Jul 2008 10:22:43 -0500
Message-ID: <1215098563.3309.12.camel@localhost.localdomain>
References: <877ic8o4iq.fsf@denkblock.local>
	 <87prpxnv4w.fsf@denkblock.local>
	 <1214963700.3316.41.camel@localhost.localdomain>
	 <87zlp0n4p8.fsf@denkblock.local>
	 <1215009983.3330.14.camel@localhost.localdomain>
	 <87vdzomg4c.fsf@denkblock.local> <20080702162306.GV14894@parisc-linux.org>
	 <87abgz30h1.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55349 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYGCPWt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2008 11:22:49 -0400
In-Reply-To: <87abgz30h1.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Thu, 2008-07-03 at 09:12 +0200, Elias Oltmanns wrote:
> Matthew Wilcox <matthew@wil.cx> wrote:
> > On Wed, Jul 02, 2008 at 05:59:31PM +0200, Elias Oltmanns wrote:
> >> > The reason no locks are necessary is that there's no race to mediate.
> >
> >> > The checks are only is it set or not ...
> >> 
> >> I'm not sure whether that is of any consequence. Don't get me wrong, I
> >> really don't know and you may well be right. But how exactly does
> >> decrementing from 2 to 1 work? Do we know for sure that there will
> >> always be at least one bit set so reading that address will reliably
> >> return a non zero value?
> >
> > The assumption we make (and it is believed to be true on all SMP systems)
> > is that a write to a naturally aligned memory location that is sized <=
> > sizeof(long) is atomic.  That is, a reader will get either the previous
> > value or the subsequent value, not a mixture.  The RCU code relies
> > heavily on this assumption.
> 
> Does that mean that where ever I have
> 
> spin_lock_irqsave(some_lock, flags);
> var = some_val;
> spin_unlock_irqrestore(some_lock, flags);
> 
> I could just as well discard the locking provided that
> sizeof(var) <= sizeof(long)
> because the assignment of some_val to var will be atomic anyway?

I think you're still confused about the difference between integral
observation of values and serialisation.

Assignment is always integral.  In your example above anything observing
the variable always sees either the previous value or the one you set it
to, nothing else.  So, if all you're doing is setting a flag and
clearing it (as in setting it to an integral value, not setting it via a
bit operation) and checking it, no locking is needed.  It's when you
start doing operations on variables that require serialisation, or the
variables themselves are absolute indicators of events that need
serialisation that you start having to introduce locking.

James


