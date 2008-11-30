From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12120] [Block layer or SCSI] requests aborted too early during check_partition()
Date: Sat, 29 Nov 2008 16:08:31 -0800 (PST)
Message-ID: <20081130000831.2B11110800F@picon.linux-foundation.org>
References: <bug-12120-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56783 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbYK3AId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 19:08:33 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mAU08Vi6030728
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2008 16:08:32 -0800
In-Reply-To: <bug-12120-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=12120





------- Comment #8 from anonymous@kernel-bugs.osdl.org  2008-11-29 16:08 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Sat, 2008-11-29 at 22:30 +0100, Stefan Richter wrote:
> Nov 29 22:12:53 mini scsi_eh_2: Sending START_UNIT to sdev: 0xffff8800712ef000
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Send: 0xffff88007b76af08 
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
> Nov 29 22:12:53 mini buffer = 0x0000000000000000, bufflen = 0, queuecommand 0xffffffffa015d445
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Done: 0xffff88007b76af08 SUCCESS
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Result: hostbyte=DID_OK driverbyte=DRIVER_OK,SUGGEST_OK
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Unrecognized sense data (in hex):
> Nov 29 22:12:53 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Nov 29 22:12:53 mini 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Nov 29 22:12:53 mini Sense Key : No Sense [current] 
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] Add. Sense: No additional sense information
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] scsi host busy 1 failed 1
> Nov 29 22:12:53 mini scsi_send_eh_cmnd: scmd: ffff88007b76af08, timeleft: 0

This is suggestive:  timeleft shouldn't be zero since according to the
logging ticks virtually no time had elapsed.

> Nov 29 22:12:53 mini ieee1394: sbp2: aborting sbp2 command
> Nov 29 22:12:53 mini sd 2:0:0:0: [sdb] CDB: Start/Stop Unit: 1b 00 00 00 01 00
> Nov 29 22:12:53 mini scsi_eh_done scmd: ffff88007b76af08 result: 50000

And this is the actual command completion occurring after timeout.

Theory number two is a block timeout cockup.  It looks like
sdev->timeout is vestigial and has zero value, so we shouldn't be using
it in the start command, so try this.

If this works, the correct fix will be to kill the sdev timeout
parameter so we get a compile failure where anything tries to use it.

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3863617..de3f6d0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -933,7 +933,7 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)

                for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
                        rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
-                                               scmd->device->timeout, 0);
+                                               3*SENSE_TIMEOUT, 0);

                if (rtn == SUCCESS)
                        return 0;


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
