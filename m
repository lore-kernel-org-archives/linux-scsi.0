From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: 29 Feb 2004 15:25:00 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078089901.1756.79.camel@mulgrave>
References: <1077906383.2157.98.camel@mulgrave>		<3462370000.1077909838@aslan.btc.adapte
	c.com>	<1077910452.2157.110.camel@mulgrave>
		<3492060000.1077915050@aslan.btc.adaptec.com>
	<1077982791.2020.25.camel@mulgrave>
	<154922704.1078082802@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:32993 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262143AbUB2VZE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Feb 2004 16:25:04 -0500
In-Reply-To: <154922704.1078082802@aslan.btc.adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

On Sun, 2004-02-29 at 13:26, Justin T. Gibbs wrote:
> While it is certainly possible to move domain validation into the mid-layer
> and remove it from LLDs, I doubt that is the type of change you want to
> include in 2.6.  It would require at minimum:

Well, possibly not, but it's certainly something to begin thinking about
now.

> 1) A generic method for fetching and changing the transport parameters for
>    devices attached to LLDs.

That's what the embryonic transport classes will become for SPI and when
they finally have this capability, then I'll try to put domain
validation into them.

> 2) A generic method for freezing the execution queue and "single-stepping"
>    things like domain validation and error recovery commands.

We have that all ready in the mid-layer as part of error recovery.  This
would simply be an extension for domain validation.

> 3) A way to wait for the active count on a device or target (including all
>    luns) to drop to 0.

That too is done in error recovery (admittedly at the host level rather
than the device level).

> Don't get me wrong.  One of my main complaints of the Linux SCSI layer is
> its intrinsic lack of consistency.  In my opinion, the code path for sending
> commands to and processing the results from a LLD should be identical
> regardless of whether the commands are from error recovery, domain validation,
> a peripheral driver, or the probe code.  Instead we only get certain behavior
> (like a bus settle delay) for some clients and not others.  Fixing this
> would allow the behavior to be defined in one place and these "workarounds"
> could be removed from the LLDs.  Unfortunately, the LLDs are the only "code
> path" common to all of the clients of the mid-layer, so you wind up with the
> LLDs enforcing correct behavior.

Well, I haven't claimed SCSI to be anything more than a work in
progress.  I do, however, think it is in better shape than it was a
couple of years ago.  What I really need is for people actually to try
out the mid-layer code where they would have worked around it in 2.4.

James


