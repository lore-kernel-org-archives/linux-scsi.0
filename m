From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 08 Jun 2009 10:37:50 -0700
Message-ID: <4A2D4C6E.6080108@linux.intel.com>
References: <200906061959.55592.chris2553@googlemail.com>  <200906062215.30571.chris2553@googlemail.com>  <1244381140.30664.12.camel@ht.satnam>  <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>  <1244413881.18742.31.camel@ht.satnam>  <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>  <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>  <c6b1100b0906080358y4033c402ra236eff3f972d169@mail.gmail.com>  <1244460875.12644.2.camel@ht.satnam>  <c6b1100b0906080553o2aa77a40pe0077b1b10a7d88a@mail.gmail.com>  <alpine.LFD.2.01.0906080916130.6847@localhost.localdomain> <1244479879.4079.284.camel@mulgrave.site> <alpine.LFD.2.01.0906081003370.6847@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:5394 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbZFHRiK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 13:38:10 -0400
In-Reply-To: <alpine.LFD.2.01.0906081003370.6847@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Chris Clayton <chris2553@googlemail.com>, Jaswinder Singh Rajput <jaswinder@kernel.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>

Linus Torvalds wrote:
> 
> On Mon, 8 Jun 2009, James Bottomley wrote:
>> The root cause is a reordering of the devices caused by the async code.
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
> 
> You tried to avoid a deadlock situation of waiting for too much, but you 
> avoided the deadlock by now waiting for too little. 
> 
> I also think that your code is simply buggy. As far as I can tell, int he 
> case of having both running and pending events, you'll always pick the 
> pending cookie. But it's the _running_ cookie that has the lower event 
> number, isn't it?
> 
> I dunno. It all looks very fishy to me.
> 

that's likely my screwup, not james'

the patch looks ok to me, it indeed should fix the problem.
(and is simpler than the idea I had around using min() )
