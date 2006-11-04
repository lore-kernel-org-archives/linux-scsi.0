From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] st.c: Improve sense output
Date: Sat, 4 Nov 2006 12:02:57 -0800 (PST)
Message-ID: <587723.63610.qm@web31807.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-206653271-1162670577=:63610"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:13953 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S965614AbWKDUC6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Nov 2006 15:02:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kai Makisara <kai.makisara@kolumbus.fi>

--0-206653271-1162670577=:63610
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

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

March 24, 2006!

    Luben
--0-206653271-1162670577=:63610
Content-Type: text/inline; name="st.txt"
Content-Description: 2928128166-st.txt
Content-Disposition: name="st.txt"; filename="st.txt"

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
1.4.3.3.g8478


--0-206653271-1162670577=:63610--
