From: Kevin Groeneveld <KGroeneveld@lenbrook.com>
Subject: RE: [PATCH] scsi: fix hang in scsi error handling
Date: Thu, 16 Jul 2015 18:55:43 +0000
Message-ID: <BF6B9AADDDF11740967545E971C7C0DE02234A@MAIL1.pickering.lenbrook.com>
References: <1436964449-31447-1-git-send-email-kgroeneveld@lenbrook.com>
 <55A79156.3060307@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.lenbrook.com ([206.191.95.214]:60234 "EHLO
	mail.lenbrook.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbbGPSzp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jul 2015 14:55:45 -0400
In-Reply-To: <55A79156.3060307@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "JBottomley@odin.com" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "festevam@gmail.com" <festevam@gmail.com>, "richard.zhu@freescale.com" <richard.zhu@freescale.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: July-16-15 7:11 AM
> > When the hang occurs shost->host_busy == 2 and shost->host_failed == 1
> > in the scsi_eh_wakeup function. However this function only wakes the
> > error handler if host_busy == host_failed.
> >
> Which just means that one command is still outstanding, and we need to wait
> for it to complete.
> But see below...

So the root cause of the hang is maybe that the second command never
completes? Maybe host_failed being non zero is blocking something in the
port multiplier code?

> Hmm.
> I am really not sure about this.

I wasn't sure either, that is one reason why I posted the patch.

> 'host_busy' indicates the number of outstanding commands, and
> 'host_failed' is the number of commands which have failed (on the ground
> that failed commands are considered outstanding, too).
> 
> So the first hunk would change the behaviour from 'start SCSI EH once all
> commands are completed or failed' to 'start SCSI EH for _any_ command if
> scsi_eh_wakeup is called'
> (note that shost_failed might be '0'...).
> Which doesn't sound right.

So could the patch create any problems by starting the EH any time
scsi_eh_wakeup is called? Or is it is just inefficient?

> I guess this needs further debugging to get to the bottom of it.

Any suggestions on things I could try?

The fact that the problem goes away when I only enable one CPU core makes
me think there is a race happening somewhere.


Kevin
