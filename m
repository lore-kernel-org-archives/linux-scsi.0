From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12120] [Block layer or SCSI] requests aborted too early
	during check_partition()
Date: Sat, 29 Nov 2008 13:54:51 -0600
Message-ID: <1227988491.4636.14.camel@localhost.localdomain>
References: <20081129193241.9EC3B10800F@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48355 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbYK2Tyy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 14:54:54 -0500
In-Reply-To: <20081129193241.9EC3B10800F@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

OK, so there are a few problems.  First, by responding OK to the test
unit ready (which is illegal under spec) it avoids the spin up the sd
driver normally does, so we're relying on the eh allow_restart flag to
start the unit on the first failing command.  Then, in the failure case:

> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Read(10): 28 00 00 00 00 00 00 00
> 08 00
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Sense Key : Not Ready [current] 
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Add. Sense: Logical unit not ready,
> initializing command required
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] scsi host busy 1 failed 0
> Nov 29 19:57:06 stein Waking error handler thread
> Nov 29 19:57:06 stein Error handler scsi_eh_20 waking up
> Nov 29 19:57:06 stein sd 20:0:0:0: scsi_eh_prt_fail_stats: cmds failed: 1,
> cancel: 0
> Nov 29 19:57:06 stein Total of 1 commands on 1 devices require eh work
> Nov 29 19:57:06 stein scsi_eh_20: Sending START_UNIT to sdev: 0xe58fc7f0
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Send: 0xf5798ef0 
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Start/Stop Unit: 1b 00 00 00 01
> 00
> Nov 29 19:57:06 stein buffer = 0x00000000, bufflen = 0, queuecommand 0xf85fb980
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Done: 0xf5798ef0 SUCCESS
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Result: hostbyte=DID_OK
> driverbyte=DRIVER_OK,SUGGEST_OK
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] CDB: Start/Stop Unit: 1b 00 00 00 01
> 00
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Unrecognized sense data (in hex):
> Nov 29 19:57:06 stein 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Nov 29 19:57:06 stein 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
> Nov 29 19:57:06 stein Sense Key : No Sense [current] 
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] Add. Sense: No additional sense
> information
> Nov 29 19:57:06 stein sd 20:0:0:0: [sdd] scsi host busy 1 failed 1

The second start unit is a failure ... I suspect because of our change
to no sense return handling.  What the drive is probably trying to say
is (I'm spinning up) but this gets interpreted as an error because the
sense data for this isn't present (because we didn't ask for it).

Can you try this patch?  It should take the success return of the first
spin up and act on it instead of blindly sending another.

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 3863617..635d8b4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -931,12 +931,15 @@ static int scsi_eh_try_stu(struct scsi_cmnd *scmd)
 	if (scmd->device->allow_restart) {
 		int i, rtn = NEEDS_RETRY;
 
-		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++)
+		for (i = 0; rtn == NEEDS_RETRY && i < 2; i++) {
 			rtn = scsi_send_eh_cmnd(scmd, stu_command, 6,
 						scmd->device->timeout, 0);
 
-		if (rtn == SUCCESS)
-			return 0;
+			if (rtn == SUCCESS)
+				return 0;
+			/* if failure, wait before retrying */
+			ssleep(3);
+		}
 	}
 
 	return 1;



