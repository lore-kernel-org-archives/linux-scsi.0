From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Thu, 3 Jul 2008 09:47:13 -0600
Message-ID: <20080703154713.GF14894@parisc-linux.org>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local> <1214963700.3316.41.camel@localhost.localdomain> <87zlp0n4p8.fsf@denkblock.local> <1215009983.3330.14.camel@localhost.localdomain> <87vdzomg4c.fsf@denkblock.local> <20080702162306.GV14894@parisc-linux.org> <87abgz30h1.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44939 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbYGCPrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2008 11:47:31 -0400
Content-Disposition: inline
In-Reply-To: <87abgz30h1.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Thu, Jul 03, 2008 at 09:12:26AM +0200, Elias Oltmanns wrote:
> Matthew Wilcox <matthew@wil.cx> wrote:
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

You might need a barrier.

Also, I realised I mis-spoke above.  Early Alphas do not have instructions
that store byte or 16-bit sized quantities.  So the compiler implements
a byte store by loading a 32-bit quantity, replacing the appropriate 8
bits with the new value and storing the word back again.  The same is
true for most processors with, say, bit-sized quantities.  So while it's
atomic with respect to other _readers_, it's unsafe with respect to other
_writers_ in that if you have two modification attempts simultaneously,
you can end up with only one modification having taken place, not both.

eg:

CPU 0		CPU 1
load value
		load value
modify
		modify
store value
		store value

CPU 1 got the old value, and stored it over CPU 0's value.

CPUs which have instructions like cmpxchg can avoid these kinds of
problems, but not all do.  It's certainly not something that you can
make a blanket statement on; you really need to analyse it carefully.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
