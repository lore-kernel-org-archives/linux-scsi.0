From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: Aic7x_x_x 6.3.4 && Aic79xx 2.0.5 Updates
Date: Fri, 26 Dec 2003 21:26:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <2906490000.1072499170@aslan.scsiguy.com>
References: <1051920000.1054684267@aslan.btc.adaptec.com>	<3637050000.1054690456@aslan.s			csiguy.com>
 	<2113050000.1072285128@aslan.scsiguy.com>	<1072288242.1906.35.camel@mulgrave		>	<2148850000.1072292121@aslan.scsiguy.com>
 	<1072292714.2415.39.camel@mulgrave	> 	<2304040000.1072326693@aslan.scsiguy.com>	<1072463795.1873.127.camel@mulgrave>
 	<2832150000.1072484024@aslan.scsiguy.com> <1072495231.1873.363.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.scsiguy.com ([63.229.232.106]:16147 "EHLO
	aslan.scsiguy.com") by vger.kernel.org with ESMTP id S265309AbTL0E0X
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Dec 2003 23:26:23 -0500
In-Reply-To: <1072495231.1873.363.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, Andrew Morton <akpm@osdl.org>

> On Fri, 2003-12-26 at 18:13, Justin T. Gibbs wrote:
>> Recovery is critical.  Why have failover controllers if it takes several
>> minutes for that failover to succeed.  The whole point of these controllers
>> is to allow a critical service to continue to operate almost uninterrupted.
> 
> Recovery for failover controllers will be done at a higher level using
> the fastfail mechanism.

You're telling me that fail-over for a multi-controller external RAID box
connected to a single SCSI controller will occur at a higher level?  The
fail-over has already occurred by the time the HBA see the timeout.  This
means that completion of recovery is the only impediment to completing the
fail-over.

As for higher level fail-over, provide the correct transaction error
codes, and high level fail-over is possible regardless of the transport
specific recovery that occurs in my or other drivers.  In the FreeBSD
system, I can indicate that a command timed-out and was successfully
aborted by the driver.  This is all that is required for multi-path
fail-over to occur - the errors are *still* visible at this level.  Its
not as though my driver *retries* commands that timeout.  It only
aborts them and returns the appropriate status.

> OK, we have differing views about CAM.  However, regardless of why it
> happened, CAM is dead and the committee disbanded.  SCSI development
> will go on without reference to CAM.

Perhaps your development will.  Having a "Common Access Method" for
I/O is still a worthy goal in my mind regardless of whether T10 ratifies
some standard on the subject.  Continuing to make the "SCSI layer" SCSI
centric (or any particular protocol - "centric") limits the ability of
the sub-system to gracefully handle emerging protocols.

>> In general, the peripheral driver should get the first crack at any
>> status returned by an HBA driver.  Until that occurs, the Linux SCSI
>> layer is critically flawed.  If you are interested, you can look at
>> how the FreeBSD SCSI layer deals with these issues.  The peripheral
>> driver "filters" all errors and defaults to using a common, generic
>> error handler for errors that do not need special handling.  Right
>> now, the Linux mid-layer hides information and performs actions that
>> are not necessarily what the peripheral driver wants.  Other than
>> perhaps statistics gathering, and other actions that are not visible
>> to the end device, this should not be the case.
> 
> That's not true.  For a fatal transport error in a multi-path device all
> you'll do is delay the inevitable switchover.  That's why trying to
> second guess error recovery like this is counter productive.

On the contrary.  The fail-over agent gets notification of the error
faster with my driver's recovery than with the current mid-layer strategy
since "transport recovery" and the resulting failed command status is
transmitted with at most a 5 second delay beyond the watchdog timeout value.
The current mid-layer mechanism often takes orders of magnitude longer to
recover and doesn't indicate to anyone that a failure has occurred until
recovery is complete.

> By stopping the timers and redirecting to an internal thread in your
> driver, you are subverting all of the error recovery for your driver.

No.  Only watchdog recovery.  The timers are only used for watchdog
recovery.  Proper status, even for commands aborted due to timeouts,
is still given, so status based recovery is still effective.

> I appreciate its a hard thing to be dependent on code outside your
> control.  However, duplicating functionality solely to bring code under
> your control is not the correct approach.  The open source philosophy is
> to encourage people to get involved in areas of code outside their
> direct responsibility when this happens and, inevitably, to try to reach
> an amicable compromise about fixing it.  This is one of the reasons why
> good open source developers tend to have a strong record of
> contributions outside their perceived fields of expertise.

I've already written one OpenSource SCSI layer, I think I've contributed
more than enough in that particular area.  Back in late 2000 and early 2001,
I voiced my opinions, based on that experience, on how Linux should improve
its SCSI subsystem.  After 3 years of waiting for improvement in the
error recovery semantics of Linux, I had to do something to satisfy customer
complaints on error recovery.  I still don't see things improving in
this area of Linux and I'm not about to *break* the driver until there is
a viable alternative.

> I'm prepared to allow driver writers a considerable amount of slack in
> terms of deviation from the coding standards, useless and obfuscating
> compatibility layers and #ifdef'd code that can never be compiled in
> 2.6; however, this attempt to hijack the basic SCSI APIs within the
> adaptec driver is unacceptable.  Please take it out and resubmit the
> patch without it.

I'm sorry you feel that way.  I suppose I will just have to continue
to point distributors and users of this driver to my own patch sets since
that seems to be the only viable alternative you've given me.

--
Justin

