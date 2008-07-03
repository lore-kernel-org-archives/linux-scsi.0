From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Thu, 03 Jul 2008 09:12:26 +0200
Message-ID: <87abgz30h1.fsf@denkblock.local>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local>
	<1214963700.3316.41.camel@localhost.localdomain>
	<87zlp0n4p8.fsf@denkblock.local>
	<1215009983.3330.14.camel@localhost.localdomain>
	<87vdzomg4c.fsf@denkblock.local>
	<20080702162306.GV14894@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:35444 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935434AbYGCHMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jul 2008 03:12:43 -0400
In-Reply-To: <20080702162306.GV14894@parisc-linux.org> (Matthew Wilcox's
	message of "Wed, 2 Jul 2008 10:23:06 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Jul 02, 2008 at 05:59:31PM +0200, Elias Oltmanns wrote:
>> > The reason no locks are necessary is that there's no race to mediate.
>
>> > The checks are only is it set or not ...
>> 
>> I'm not sure whether that is of any consequence. Don't get me wrong, I
>> really don't know and you may well be right. But how exactly does
>> decrementing from 2 to 1 work? Do we know for sure that there will
>> always be at least one bit set so reading that address will reliably
>> return a non zero value?
>
> The assumption we make (and it is believed to be true on all SMP systems)
> is that a write to a naturally aligned memory location that is sized <=
> sizeof(long) is atomic.  That is, a reader will get either the previous
> value or the subsequent value, not a mixture.  The RCU code relies
> heavily on this assumption.

Does that mean that where ever I have

spin_lock_irqsave(some_lock, flags);
var = some_val;
spin_unlock_irqrestore(some_lock, flags);

I could just as well discard the locking provided that
sizeof(var) <= sizeof(long)
because the assignment of some_val to var will be atomic anyway?

Regards,

Elias
