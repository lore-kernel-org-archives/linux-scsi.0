From: akpm@osdl.org
Subject: [patch 17/19] st.c: Improve sense output
Date: Fri, 07 Jul 2006 00:02:18 -0700
Message-ID: <200607070702.k6772IZ6030654@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:11203 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751200AbWGGHCV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2006 03:02:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, ltuikov@yahoo.com

From: Luben Tuikov <ltuikov@yahoo.com>

Convert this:
st0: Error with sense data: <6>st: Current: sense key: Illegal Request
    Additional sense: Invalid field in cdb

To this:
st0: Current: sense key: Illegal Request
    Additional sense: Invalid field in cdb

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/st.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/st.c~stc-improve-sense-output drivers/scsi/st.c
--- a/drivers/scsi/st.c~stc-improve-sense-output
+++ a/drivers/scsi/st.c
@@ -368,7 +368,7 @@ static int st_chk_result(struct scsi_tap
 		       SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
 		       SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
-			 __scsi_print_sense("st", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			 __scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
@@ -384,9 +384,8 @@ static int st_chk_result(struct scsi_tap
 			 scode != VOLUME_OVERFLOW &&
 			 SRpnt->cmd[0] != MODE_SENSE &&
 			 SRpnt->cmd[0] != TEST_UNIT_READY) {
-				printk(KERN_WARNING "%s: Error with sense data: ", name);
-				__scsi_print_sense("st", SRpnt->sense,
-						   SCSI_SENSE_BUFFERSIZE);
+
+			__scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 		}
 	}
 
_
