From: Kevin Groeneveld <KGroeneveld@lenbrook.com>
Subject: RE: [PATCH] scsi: fix hang in scsi error handling
Date: Mon, 27 Jul 2015 15:31:59 +0000
Message-ID: <BF6B9AADDDF11740967545E971C7C0DE022C9F@MAIL1.pickering.lenbrook.com>
References: <1436964449-31447-1-git-send-email-kgroeneveld@lenbrook.com>
 <55A79156.3060307@suse.de>
 <BF6B9AADDDF11740967545E971C7C0DE02234A@MAIL1.pickering.lenbrook.com>
 <55B60A2B.1040905@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([206.191.95.214]:7272 "EHLO
	mail.lenbrook.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554AbbG0PcB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2015 11:32:01 -0400
In-Reply-To: <55B60A2B.1040905@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@odin.com" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "festevam@gmail.com" <festevam@gmail.com>, "richard.zhu@freescale.com" <richard.zhu@freescale.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: July-27-15 6:39 AM
> On 07/16/2015 08:55 PM, Kevin Groeneveld wrote:
> >> -----Original Message-----
> >> From: Hannes Reinecke [mailto:hare@suse.de]
> >> Sent: July-16-15 7:11 AM
> >>> When the hang occurs shost->host_busy == 2 and shost->host_failed ==
> >>> 1 in the scsi_eh_wakeup function. However this function only wakes
> >>> the error handler if host_busy == host_failed.
> >>>
> >> Which just means that one command is still outstanding, and we need
> >> to wait for it to complete.
> >> But see below...
> >
> > So the root cause of the hang is maybe that the second command never
> > completes? Maybe host_failed being non zero is blocking something in
> > the port multiplier code?
> >
> >> Hmm.
> >> I am really not sure about this.
> >
> > I wasn't sure either, that is one reason why I posted the patch.
> >
> >> 'host_busy' indicates the number of outstanding commands, and
> >> 'host_failed' is the number of commands which have failed (on the
> >> ground that failed commands are considered outstanding, too).
> >>
> >> So the first hunk would change the behaviour from 'start SCSI EH once
> >> all commands are completed or failed' to 'start SCSI EH for _any_
> >> command if scsi_eh_wakeup is called'
> >> (note that shost_failed might be '0'...).
> >> Which doesn't sound right.
> >
> > So could the patch create any problems by starting the EH any time
> > scsi_eh_wakeup is called? Or is it is just inefficient?
> >
> SCSI EH _relies_ on the fact that no other commands are outstanding on that
> SCSI host, hence the contents of eh_entry list won't change.
> Your patch breaks this assumption, causing some I/O to be lost.
> 
> >> I guess this needs further debugging to get to the bottom of it.
> >
> > Any suggestions on things I could try?
> >
> > The fact that the problem goes away when I only enable one CPU core
> > makes me think there is a race happening somewhere.
> >
> Not sure here. You're effectively creating an endless loop with your patch,
> assuming that each ioctl will be However, you are effectively creating an
> endless loop with you testcase, assuming that 'ioctl' finishes all I/O before
> returning.
> Which _actually_ is not a requirement; the I/O itself needs to be finished by
> the time the ioctl returns (obviously), but the _structures_ associated with
> the ioctl might linger on a bit longer (delayed freeing and whatnot).
> Yet this is a bit far-fetched, and definitely needs some more analysis.
> 
> For debugging I would suggest looking at the lifetime of each scsi command,
> figuring out if by the time the ioctl returns the scsi command is indeed freed
> up.

Thanks for the further feedback on this.

I haven't had a lot of time to debug this further. Last week I did tried enabling SCSI logging as you suggested in your previous post. I tried many different combinations of setting /proc/sys/dev/scsi/logging_level to enable different types and levels of debugging.  However everything I tried either resulted in not being able to trigger the problem or nothing useful in the log.

I was thinking of looking into the SCSI trace functionality to see if that would give more useful results.

One thing I did notice which may be a small clue is the following values each time after the hang:
/sys/class/scsi_device/0:0:0:0/device/device_busy = 1 (CD-ROM)
/sys/class/scsi_device/0:1:0:0/device/device_busy = 0 (HDD)

Before the hang the HDD busy value varies from 0 to 31. After the hang the HDD busy value is always 0.

> Also you might want to play around with the 'usleep' a bit; my assumption is
> that at one point for a large enough wait the problem goes away.
> (And, incidentally, we might actually getting more than one pending
> commands if the sleep is small enough; but this is just conjecture :-)

I tried a 10 second usleep.  On the first attempt the third ioctl never returned.  After a reboot and a second attempt the 10th ioctl never returned.

I also tried getting rid of the usleep entirely. If I avoid HDD access at the same time I can get about 100 ioctl calls per second and /sys/.../device_busy never seems to go above 1.  As soon as I access the HDD all SCSI access hangs.


Kevin
