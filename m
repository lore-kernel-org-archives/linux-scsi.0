From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] skip sense logging for some ATA PASS-THROUGH cdbs
Date: Sun, 03 Jan 2010 13:51:15 -0500
Message-ID: <4B40E723.7050607@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010708090709080600010104"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:56417 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab0ACSvW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jan 2010 13:51:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: kb@sysmikro.com.pl

This is a multi-part message in MIME format.
--------------010708090709080600010104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Further to the lsml thread titled:
"does scsi_io_completion need to dump sense data for ata pass through (ck_cond =
1) ?"

This is a patch to skip logging when the sense data is
associated with a SENSE_KEY of "RECOVERED_ERROR" and the
additional sense code is "ATA PASS-THROUGH INFORMATION
AVAILABLE". This only occurs with the SAT ATA PASS-THROUGH
commands when CK_COND=1 (in the cdb). It indicates that
the sense data contains ATA registers.

Smartmontools uses such commands on ATA disks connected via
SAT. Periodic checks such as those done by smartd cause
nuisance entries into logs that are:
    - neither errors nor warnings
    - pointless unless the cdb that caused them are also logged

The patch is against lk 2.6.32

Doug Gilbert


--------------010708090709080600010104
Content-Type: text/x-patch;
 name="scsi_lib2632smart1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_lib2632smart1.patch"

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--- linux/drivers/scsi/scsi_lib.c2632	2009-12-03 11:11:18.000000000 -0500
+++ linux/drivers/scsi/scsi_lib.c	2010-01-03 13:18:04.000000000 -0500
@@ -773,8 +773,14 @@
 	 * we already took a copy of the original into rq->errors which
 	 * is what gets returned to the user
 	 */
-	if (sense_valid && sshdr.sense_key == RECOVERED_ERROR) {
-		if (!(req->cmd_flags & REQ_QUIET))
+	if (sense_valid && (sshdr.sense_key == RECOVERED_ERROR)) {
+		/* if ATA PASS-THROUGH INFORMATION AVAILABLE skip
+ 		 * print since caller wants ATA registers. Only occurs on
+		 * SCSI ATA PASS_THROUGH commands when CK_COND=1
+		 */
+		if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
+			;
+		else if (!(req->cmd_flags & REQ_QUIET))
 			scsi_print_sense("", cmd);
 		result = 0;
 		/* BLOCK_PC may have set error */


--------------010708090709080600010104--
