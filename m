From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] st.c: Improve sense output
Date: Fri, 30 Jun 2006 18:07:21 -0700 (PDT)
Message-ID: <20060701010721.90143.qmail@web31808.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:54705 "HELO
	web31808.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932546AbWGABHW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 21:07:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>

>From this:
st0: Error with sense data: <6>st: Current: sense key: Illegal Request
    Additional sense: Invalid field in cdb

To this:
st0: Current: sense key: Illegal Request
    Additional sense: Invalid field in cdb

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/st.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 29d7319..2a59635 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
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
 
-- 
1.4.1.rc2.g4ce4


