From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Fri, 27 Feb 2004 13:50:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3492060000.1077915050@aslan.btc.adaptec.com>
References: <1077906383.2157.98.camel@mulgrave> 	<3462370000.1077909838@aslan.btc.adaptec.com> <1077910452.2157.110.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:55493 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S263067AbUB0Uu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 15:50:57 -0500
In-Reply-To: <1077910452.2157.110.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

> There's no guaranteed minimum delay time required by the specs.  We
> pause for a predetermined number of unplugs if you look at the code,
> which is actually under the control of the driver.  The trade off is
> that we want to try faster under heavy I/O pressure, so the delay isn't
> fixed, it's bounded by the I/O pressure in the system, which is as it
> should be.

Well, experience shows that if you implement a SCSI system based solely
on the spec, it won't work.

There are lots of devices out there that require a delay of at least
250ms in order to not deadlock their internal SCSI processor.  The
I/O load of the system has no bearing on when a device will become
"unbusy" (we can't even say why it is "busy"), so I fail to see why
it should have any effect on how long we wait in response to this
condition.

>> 2) These drivers both include Domain Validation support.  These commands
>>    do not go through the mid-layer at all yet require proper queue full
>>    and busy handling.
> 
> Well, if the driver used the correct command handling infrastructure for
> that, they would go through the mid-layer and there would be no problem.

In order to issue a DV command to the end device via the mid-layer, the
host queue and the device queue must not be blocked.  But, for DV to be
effective, it must be the only activity occurring on that device.  How do
you reconcile the two while using the mid-layer to do your I/O?  The
mid-layer has no concept of allowing a client to freeze the queue,
wait for the active count to go to zero, effectively pre-empt
the command stream with a series of special commands, and then unblock
everyone else only at the end.  The closest the mid-layer comes to this
is in some of its error recovery handling but those are internal
interfaces.

--
Justin

