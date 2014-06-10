From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 77631] New: task scsi_eh_6:537 blocked for more than 120
 seconds.
Date: Tue, 10 Jun 2014 16:49:10 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1406101638390.27331-100000@netrider.rowland.org>
References: <1402421480.2185.75.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:45452 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753845AbaFJUtM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 16:49:12 -0400
In-Reply-To: <1402421480.2185.75.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: mikhail.v.gavrilov@gmail.com, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Tue, 10 Jun 2014, James Bottomley wrote:

> From the trace below, this looks to be a USB issue (USB added to cc):
> the scsi error handler thread is waiting for usb storage to complete the
> reset.  It's a 3.14.5 kernel, so the previous reset hang because of
> spurious sense requests should be fixed.
> 
> James
> 
> 
> On Tue, 2014-06-10 at 16:50 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
> > https://bugzilla.kernel.org/show_bug.cgi?id=77631
> > 
> >             Bug ID: 77631
> >            Summary: task scsi_eh_6:537 blocked for more than 120 seconds.
> >            Product: IO/Storage
> >            Version: 2.5
> >     Kernel Version: 3.14.6
> >           Hardware: All
> >                 OS: Linux
> >               Tree: Mainline
> >             Status: NEW
> >           Severity: normal
> >           Priority: P1
> >          Component: SCSI
> >           Assignee: linux-scsi@vger.kernel.org
> >           Reporter: mikhail.v.gavrilov@gmail.com
> >         Regression: No
> > 
> > Created attachment 138941
> >   --> https://bugzilla.kernel.org/attachment.cgi?id=138941&action=edit
> > kernel log
> > 
> > task scsi_eh_6:537 blocked for more than 120 seconds.

This line from earlier in the kernel log is highly suspicious:

> [   46.330470] usb-storage: Error in queuecommand_lck: us->srb = ffff88080c532600

This means that the SCSI midlayer called the queuecommand routine twice 
with no intervening completion, even though the maximum queue depth is 
only 1.

Mikhail, is this bug reproducible?  If it is, can you post a usbmon 
trace showing the events leading up to the bug?

Does the bug occur if the device is plugged into a USB-2 bus rather 
than a USB-3 bus?

Alan Stern

