From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Sun, 29 Feb 2004 15:23:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <230252704.1078093385@aslan.btc.adaptec.com>
References: <1077906383.2157.98.camel@mulgrave>		<3462370000.1077909838@aslan.btc.adapte	c.com>	<1077910452.2157.110.camel@mulgrave>		<3492060000.1077915050@aslan.btc.adaptec.com>	<1077982791.2020.25.camel@mulgrave> 	<154922704.1078082802@aslan.btc.adaptec.com> <1078089009.1756.62.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:44013 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262165AbUB2WXN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 17:23:13 -0500
In-Reply-To: <1078089009.1756.62.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

> On Sun, 2004-02-29 at 13:26, Justin T. Gibbs wrote:
>> This is not something worth black-listing.  It is not a special case.
>> Busy and/or queue full with no I/O pending is a rare event.  The user
>> will never notice this in practice other than their devices that need
>> this delay will work correctly in this situation.  To put it another
>> way, the aic7xxx and aic79xx drivers have enforced this delay for almost
>> four years in Linux and I have yet to have someone complain that they
>> had poor device performance due to this delay.  It is just not worth
>> the code complexity or potential of missing a broken device to "optimize"
>> this delay.
> 
> Well, actually, it is: there are certain array vendors (who should
> justifiably remain nameless) who implemented the array queue resources
> as global controller pools.  Thus, under heavy I/O to multiple LUNs,
> they become highly likely to throw BUSY or QUEUE FULL at zero depth and
> do it quite often.  Pausing for fractions of a second here will cause
> nasty performance glitches in the benchmarks.

In the case of heavy I/O from one machine, the OS should be guaranteeing
fare access to resources.  FreeBSD has done this using a round-robin
scheduler since '97.  In my testing with that system, you get a few
queue full or busy events until the scheduler can rebalance and then
no stalls at all.  This is exactly how it should be since busy and
queue full events rob precious bus bandwidth.

If you are using a multi-initiator setup with multiple hosts connecting
to the same controller, you typically are buying from someone who knows
how to build a properly functioning target (Well, either that or you
are going to get exactly what you paid for - bad performance in not
only this situation but most others).  In this case, even if a global
transaction pool is being used, a resource fairness algorithm is employed
so that very quickly the resources are rebalanced based on load.  From
the test matrices I've seen from customers of these types of boxes,
high transactional loads on multiple "completely independent" channels
is one of the first things they do.  There is no tolerance for starving
out a channel except for the first command after a long period of no
activity.

> What about putting a rate limited printk in when the stutter is
> triggered?  That way if someone still has one of the problem devices we
> should have a very good trace when they report the hang.

Feel free to log repeated busy events as you see fit, but so long
as the status of the last command sent that caused a device to go
offline is printed, I would have all I need to see that the device
was "perpetually busy".

--
Justin

