From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 12120] [Block layer or SCSI] requests aborted too early
	during check_partition()
Date: Sat, 29 Nov 2008 18:08:22 -0600
Message-ID: <1228003702.4636.29.camel@localhost.localdomain>
References: <20081129193241.9EC3B10800F@picon.linux-foundation.org>
	 <1227988491.4636.14.camel@localhost.localdomain>
	 <tkrat.08c6487c76d999a8@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48741 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbYK3AIX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2008 19:08:23 -0500
In-Reply-To: <tkrat.08c6487c76d999a8@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net

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
-						scmd->device->timeout, 0);
+						3*SENSE_TIMEOUT, 0);
 
 		if (rtn == SUCCESS)
 			return 0;


