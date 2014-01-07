From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 07 Jan 2014 13:43:36 -0500
Message-ID: <52CC4AD8.8080901@ubuntu.com>
References: <Pine.LNX.4.44L0.1401071251330.1296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:50126 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaAGSnj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jan 2014 13:43:39 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401071251330.1296-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/7/2014 1:05 PM, Alan Stern wrote:
> I disagree with your argument.  If you aren't using autosuspend at
> all then you don't mind having your disks spin all the time.
> Therefore you don't mind if the disks spin up during system
> resume.

I prefer to manually spin the disk down when I don't plan on using it
for a while instead of letting it auto suspend using a timeout since
the timeout often either is too short and spins the disk down before
I'm done with it, or too long, and doesn't let it sleep as much as it
could.  Yet, I do mind that the disk must spin up whenever I resume,
even though I don't plan on using it any time soon.

> If you're using a long timeout and you don't like the way the timer
>  gets reset by a system sleep, then you have set the timeout too
> long.

It isn't reset, it simply hasn't timed out at the time I suspend.
This isn't very hard to do with even only a 5 minute auto suspend
delay.  If I do something with the disk then suspend the whole system
3 minutes later, it would spin up again when I resume even though I
finished my use of the disk before suspending the system.

> Now, a more reasonable argument might be that for some disks, the 
> kernel doesn't need to do an explicit spin-up or spin-down (for
> runtime suspend) at all; instead we can rely on the drive's
> internal power management.  In fact there already is a
> "manage_start_stop" attribute to control this.  (Well, almost -- if
> the attribute is set to 0 then the kernel won't issue a spin-down
> command even for system suspend.)

This flag is broken and unusable and should be removed.  First, SCSI
disks *require* the start command after a suspend, and secondly, not
stopping the drive before suspend causes an emergency head retract,
which damages the drive.

> I don't understand.  Under what circumstances would this happen?
> Are you saying this would happen during system resume?  Why would
> the disk spin up of its own accord at that time?

By default, ATA disks spin up on their own when they are powered on.

> And if it does spin up of its own accord, what makes you think the
>  kernel can do anything to prevent it from spinning up?

It can't.  What it should do is notice when this has happened and not
claim the device is runtime suspended when it is in fact, spinning.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSzErYAAoJEI5FoCIzSKrw8R4H/RZZfPxQYcFEw1oVlkVY1gdM
TCi0MJoSBVAg9Iepplbl3RPZKb4DR9W+k6ICcZyOdw155B8mRzznn9RYoqkDEXX8
u2mqGfqx4TRf1OJo8jGKyJhPW6tJjwHM+G5Dx4WO6XAoVtwAvJHrFiNfuG9wQa1t
DswH0IOm6ZfEH0Z4hjeq6vnyEtmB3ecrMpvplM5+tRchE1SuvP+OkD3J6EXIlL3c
J7+b7pmu3Cx/+2vz92NlWHLpFXeC1fnOAy2+jJhwia1X3tVtf+wN1KIrQBK9Lq+i
Dmgmd++DUr4//CwKftPUx/cmv/RUgSnfd7MLfHZvxJrBOsOHFoI8BYbDHqoGWEU=
=O0Xo
-----END PGP SIGNATURE-----
