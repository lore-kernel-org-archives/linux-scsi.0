From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] iscsi-target: use '%*ph' specifier to dump hex buffer
Date: Thu, 15 Jan 2015 13:40:56 +0200
Message-ID: <1421322056-25121-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Instead of pushing each byte via stack the %*ph specifier allows to supply just
a pointer and length of the buffer. The patch converts code to use the
specifier.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 9059c1e..526becd 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -674,12 +674,9 @@ static ssize_t lio_target_nacl_show_info(
 		rb += sprintf(page+rb, "InitiatorAlias: %s\n",
 			sess->sess_ops->InitiatorAlias);
 
-		rb += sprintf(page+rb, "LIO Session ID: %u   "
-			"ISID: 0x%02x %02x %02x %02x %02x %02x  "
-			"TSIH: %hu  ", sess->sid,
-			sess->isid[0], sess->isid[1], sess->isid[2],
-			sess->isid[3], sess->isid[4], sess->isid[5],
-			sess->tsih);
+		rb += sprintf(page+rb,
+			      "LIO Session ID: %u   ISID: 0x%6ph  TSIH: %hu  ",
+			      sess->sid, sess->isid, sess->tsih);
 		rb += sprintf(page+rb, "SessionType: %s\n",
 				(sess->sess_ops->SessionType) ?
 				"Discovery" : "Normal");
@@ -1758,9 +1755,7 @@ static u32 lio_sess_get_initiator_sid(
 	/*
 	 * iSCSI Initiator Session Identifier from RFC-3720.
 	 */
-	return snprintf(buf, size, "%02x%02x%02x%02x%02x%02x",
-		sess->isid[0], sess->isid[1], sess->isid[2],
-		sess->isid[3], sess->isid[4], sess->isid[5]);
+	return snprintf(buf, size, "%6phN", sess->isid);
 }
 
 static int lio_queue_data_in(struct se_cmd *se_cmd)
-- 
2.1.4
