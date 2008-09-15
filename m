From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Block timeouts seem not to be working
Date: Mon, 15 Sep 2008 15:01:30 -0500
Message-ID: <48CEBF1A.3010400@cs.wisc.edu>
References: <1221145521.3330.2.camel@localhost.localdomain>	 <20080911183509.GX20055@kernel.dk> <1221256012.3319.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57317 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751707AbYIOUIJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Sep 2008 16:08:09 -0400
In-Reply-To: <1221256012.3319.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2008-09-11 at 20:35 +0200, Jens Axboe wrote:
>> On Thu, Sep 11 2008, James Bottomley wrote:
>>> I just noticed this with a rather finickey SAS system I have.  It's got
>>> a SATA DVD attached over an expander.  Periodically the DVD just hangs
>>> up, so we wait for the timeout and then send a phy reset which clears
>>> it.
>>>
>>> What I'm seeing with the new block timer code is that the timer never
>>> expires.  I can dig some more into this, but if you wanted to test it as
>>> well, the timer code is easy to excite.  Just throw away one command in
>>> every 128 or so in the queuecommand routine of your favourite HBA
>>> driver.
>> James, I've seen a few oddities as well, I'll be beating on it tomorrow
>> again to shake out the last bug(s).
> 
> Actually, turns out it's nothing to do with block timeouts, it's a
> target reset bug.
> 
> This loop:
> 
> 	for (id = 0; id <= shost->max_id; id++) {
> 
> Never terminates if shost->max_id is set to ~0, like aic94xx does.
> 
> It's also pretty inefficient since you mostly have compact target
> numbers, but the max_id can be very high.  The best way would be to sort
> the recovery list by target id and skip them if they're equal, but even
> a worst case O(N^2) traversal is probably OK here.
> 

Sorry about that. I really screwed up on multiple counts there. I tested 
your patch with Linus's tree here on some drivers by setting the command 
timeout to 1 second and letting IO run against slow targets. I saw the 
eh run multiple times and it ran fine with your patch. Thanks for 
finding that.
