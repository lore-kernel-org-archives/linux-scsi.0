From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH] target: Fix handling of small allocation lengths in REPORT LUNS
Date: Wed, 12 Aug 2015 23:05:58 -0700
Message-ID: <1439445958-24753-1-git-send-email-sbaugh@catern.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Roland Dreier <roland@purestorage.com>, Spencer Baugh <sbaugh@catern.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

REPORT LUNS should not fail just because the allocation length is less
than 16.  The relevant section of SPC-4 is:

  4.2.5.6 Allocation length

  The ALLOCATION LENGTH field specifies the maximum number of bytes or
  blocks that an application client has allocated in the Data-In
  Buffer. The ALLOCATION LENGTH field specifies bytes unless a
  different requirement is stated in the command definition.

  An allocation length of zero specifies that no data shall be
  transferred. This condition shall not be considered an error.

So we should just truncate our response rather than return an error.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Spencer Baugh <sbaugh@catern.com>
---
 drivers/target/target_core_spc.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index b5ba1ec..67487e1 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1203,17 +1203,13 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	struct se_dev_entry *deve;
 	struct se_session *sess = cmd->se_sess;
 	struct se_node_acl *nacl;
+	struct scsi_lun slun;
 	unsigned char *buf;
 	u32 lun_count = 0, offset = 8;
-
-	if (cmd->data_length < 16) {
-		pr_warn("REPORT LUNS allocation length %u too small\n",
-			cmd->data_length);
-		return TCM_INVALID_CDB_FIELD;
-	}
+ 	__be32 len;
 
 	buf = transport_kmap_data_sg(cmd);
-	if (!buf)
+	if (cmd->data_length && !buf)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	/*
@@ -1222,7 +1218,10 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	 * a $FABRIC_MOD.  In that case, report LUN=0 only.
 	 */
 	if (!sess) {
-		int_to_scsilun(0, (struct scsi_lun *)&buf[offset]);
+		int_to_scsilun(0, &slun);
+		if (cmd->data_length > 8)
+			memcpy(buf + offset, &slun,
+			       min(8u, cmd->data_length - offset));
 		lun_count = 1;
 		goto done;
 	}
@@ -1236,10 +1235,12 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 		 * See SPC2-R20 7.19.
 		 */
 		lun_count++;
-		if ((offset + 8) > cmd->data_length)
+		if (offset >= cmd->data_length)
 			continue;
 
-		int_to_scsilun(deve->mapped_lun, (struct scsi_lun *)&buf[offset]);
+		int_to_scsilun(deve->mapped_lun, &slun);
+		memcpy(buf + offset, &slun,
+		       min(8u, cmd->data_length - offset));
 		offset += 8;
 	}
 	rcu_read_unlock();
@@ -1248,12 +1249,11 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
 	 * See SPC3 r07, page 159.
 	 */
 done:
-	lun_count *= 8;
-	buf[0] = ((lun_count >> 24) & 0xff);
-	buf[1] = ((lun_count >> 16) & 0xff);
-	buf[2] = ((lun_count >> 8) & 0xff);
-	buf[3] = (lun_count & 0xff);
-	transport_kunmap_data_sg(cmd);
+	if (buf) {
+		len = cpu_to_be32(lun_count * 8);
+		memcpy(buf, &len, min_t(int, sizeof len, cmd->data_length));
+		transport_kunmap_data_sg(cmd);
+	}
 
 	target_complete_cmd_with_length(cmd, GOOD, 8 + lun_count * 8);
 	return 0;
-- 
2.5.0.rc3
