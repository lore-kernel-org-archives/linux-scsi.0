From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sun, 30 Nov 2008 08:16:45 -0800 (PST)
Message-ID: <20081130161645.B9D56108041@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYK3QQr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Nov 2008 11:16:47 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAUGGjm8020051
	for <linux-scsi@vger.kernel.org>; Sun, 30 Nov 2008 08:16:46 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #10 from anonymous@kernel-bugs.osdl.org  2008-11-30 08:16 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Sun, 2008-11-30 at 10:44 +0100, Stefan Richter wrote:
> James Bottomley wrote:
> > Theory number two is a block timeout cockup.  It looks like
> > sdev->timeout is vestigial and has zero value, so we shouldn't be using
> > it in the start command, so try this.
> > 
> > If this works, the correct fix will be to kill the sdev timeout
> > parameter so we get a compile failure where anything tries to use it.
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> > index 3863617..de3f6d0 100644
> > --- a/drivers/scsi/scsi_error.c
> > +++ b/drivers/scsi/scsi_error.c
> > @@ -933,7 +933,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
> >  
> >  		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
> >  			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
> > -						scmd->device->timeout, 0);
> > +						3*SENSE_TIMEOUT, 0);
> >  
> >  		if (rtn == SUCCESS)
> >  			return 0;
> > 
> > 
> 
> Yes, this works with all of the SBP-2 bridges here which exhibit this
> false TEST UNIT READY "GOOD" status.
> 
> BTW, 3 * SENSE_TIMEOUT == 30 seconds may actually be a little bit narrow
> as a START UNIT timeout.  The disks which I tested here --- a few 7200
> RPM IDE or SATA disks behind the SBP-2 bridges --- usually take about 7
> seconds to spin up in single-disk enclosures and 14 seconds in dual-disk
> enclosures, since the bridge spins them up serially.  But a dual-disk
> enclosure with Hitachi Deskstar 7K400 took 28 seconds.  Maybe this
> should be used in scsi_eh_try_stu:
> include/scsi/scsi.h:#define START_STOP_TIMEOUT          (60 * HZ)

Actually, unfortunately not.  This feature isn't designed to spin up non
standards compliant devices, it's designed to restart automatically
stopping media.  As such, the timeout is going to have to go back to
being the queue timeout ... it's just that this exposes a few more
problems than firewire.

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
