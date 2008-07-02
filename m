From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] SCSI: Fix some locking issues
Date: Wed, 2 Jul 2008 10:23:06 -0600
Message-ID: <20080702162306.GV14894@parisc-linux.org>
References: <877ic8o4iq.fsf@denkblock.local> <87prpxnv4w.fsf@denkblock.local> <1214963700.3316.41.camel@localhost.localdomain> <87zlp0n4p8.fsf@denkblock.local> <1215009983.3330.14.camel@localhost.localdomain> <87vdzomg4c.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41741 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYGBQXI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 12:23:08 -0400
Content-Disposition: inline
In-Reply-To: <87vdzomg4c.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Wed, Jul 02, 2008 at 05:59:31PM +0200, Elias Oltmanns wrote:
> > The reason no locks are necessary is that there's no race to mediate.
> > The checks are only is it set or not ...
> 
> I'm not sure whether that is of any consequence. Don't get me wrong, I
> really don't know and you may well be right. But how exactly does
> decrementing from 2 to 1 work? Do we know for sure that there will
> always be at least one bit set so reading that address will reliably
> return a non zero value?

The assumption we make (and it is believed to be true on all SMP systems)
is that a write to a naturally aligned memory location that is sized <=
sizeof(long) is atomic.  That is, a reader will get either the previous
value or the subsequent value, not a mixture.  The RCU code relies
heavily on this assumption.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
