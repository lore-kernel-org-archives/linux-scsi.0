From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 08 Jun 2009 17:38:16 +0000
Message-ID: <1244482696.4079.345.camel@mulgrave.site>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
	 <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>
	 <1244460875.12644.2.camel@ht.satnam>
	 <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>
	 <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain>
	 <1244479879.4079.284.camel@mulgrave.site>
	 <alpine.LFD.2.01.0906081003370.6847@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52663 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752493AbZFHRiR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 13:38:17 -0400
In-Reply-To: <alpine.LFD.2.01.0906081003370.6847@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Clayton <chris2553@googlemail.com>, Jaswinder Singh Rajput <jaswinder@kernel.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>

On Mon, 2009-06-08 at 10:21 -0700, Linus Torvalds wrote:
> 
> On Mon, 8 Jun 2009, James Bottomley wrote:
> > 
> > The root cause is a reordering of the devices caused by the async code.
> 
> That's NULL information.
> 
> OF COURSE the root cause is the async code. We know that. We're looking 
> for the specifics.
> 
> In particular, before that commit, at most you will wait for too _much_. 
> In other words, it's a "good" wait. 
> 
> Your commit caused it to wait for less, and that then showed a bug. Not 
> all that surprising - it's now not waiting enough.

right ... my question was whether this exposed an existing bug that was
hidden by the waiting too much.  Actually, I audited all the async code
and that's impossible: we don't actually have any async domains at all
(except for the spurious superblock s_async_list, which never gets
anything added to its runqueue), so it must be a bug in the code.

> You tried to avoid a deadlock situation of waiting for too much, but you 
> avoided the deadlock by now waiting for too little. 
> 
> I also think that your code is simply buggy. As far as I can tell, int he 
> case of having both running and pending events, you'll always pick the 
> pending cookie. But it's the _running_ cookie that has the lower event 
> number, isn't it?

Yes, see later fix.  Assuming we get confirmation from the reporter, we
should be good to go.

> I dunno. It all looks very fishy to me.

Well, the other option is to revert the fix ... since there is no other
separated domain, there's nothing really to fix ... the original code
that showed the problem was a SCSI feature tree conversion of our
current async scanning code to the async infrastructure which used a
separate domain.

James


