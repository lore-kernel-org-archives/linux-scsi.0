From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: 29 Feb 2004 15:10:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078089009.1756.62.camel@mulgrave>
References: <1077906383.2157.98.camel@mulgrave>		<3462370000.1077909838@aslan.btc.adapte
	c.com>	<1077910452.2157.110.camel@mulgrave>
		<3492060000.1077915050@aslan.btc.adaptec.com>
	<1077982791.2020.25.camel@mulgrave>
	<154922704.1078082802@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:26336 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262140AbUB2VKN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 16:10:13 -0500
In-Reply-To: <154922704.1078082802@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, 2004-02-29 at 13:26, Justin T. Gibbs wrote:
> This is not something worth black-listing.  It is not a special case.
> Busy and/or queue full with no I/O pending is a rare event.  The user
> will never notice this in practice other than their devices that need
> this delay will work correctly in this situation.  To put it another
> way, the aic7xxx and aic79xx drivers have enforced this delay for almost
> four years in Linux and I have yet to have someone complain that they
> had poor device performance due to this delay.  It is just not worth
> the code complexity or potential of missing a broken device to "optimize"
> this delay.

Well, actually, it is: there are certain array vendors (who should
justifiably remain nameless) who implemented the array queue resources
as global controller pools.  Thus, under heavy I/O to multiple LUNs,
they become highly likely to throw BUSY or QUEUE FULL at zero depth and
do it quite often.  Pausing for fractions of a second here will cause
nasty performance glitches in the benchmarks.

What about putting a rate limited printk in when the stutter is
triggered?  That way if someone still has one of the problem devices we
should have a very good trace when they report the hang.

James


