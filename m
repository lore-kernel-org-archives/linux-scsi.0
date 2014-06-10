From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 77631] task scsi_eh_6:537 blocked for more than 120 seconds.
Date: Tue, 10 Jun 2014 20:55:56 +0000
Message-ID: <bug-77631-11613-2OZDY3BHgB@https.bugzilla.kernel.org/>
References: <bug-77631-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:45869 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbaFJU4A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2014 16:56:00 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A4AE1201C0
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 20:55:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 021F3202BE
	for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2014 20:55:57 +0000 (UTC)
In-Reply-To: <bug-77631-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=77631

--- Comment #1 from Alan Stern <stern@rowland.harvard.edu> ---
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

-- 
You are receiving this mail because:
You are the assignee for the bug.
