From: Spencer Baugh <sbaugh@catern.com>
Subject: [PATCH v2] target: Fix handling of small allocation lengths in REPORT LUNS
Date: Thu, 13 Aug 2015 21:59:19 -0700
Message-ID: <1439528359-32351-1-git-send-email-sbaugh@catern.com>
References: <1439508184.31978.57.camel@haakon3.risingtidesystems.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from catern.com ([104.131.201.120]:42855 "EHLO mail.catern.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750728AbbHNFA6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Aug 2015 01:00:58 -0400
In-Reply-To: <1439508184.31978.57.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:TARGET SUBSYSTEM" <target-devel@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Cc: Joern Engel <joern@purestorage.com>, Spencer Baugh <Spencer.baugh@purestorage.com>, Roland Dreier <roland@purestorage.com>, Spencer Baugh <sbaugh@catern.com>

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
index da6130a..43a27bf 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1210,17 +1210,13 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
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
@@ -1241,10 +1237,12 @@ sense_reason_t spc_emulate_report_luns(struct se_cmd *cmd)
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
@@ -1257,16 +1255,18 @@ done:
 	 * If no LUNs are accessible, report virtual LUN 0.
 	 */
 	if (lun_count == 0) {
-		int_to_scsilun(0, (struct scsi_lun *)&buf[offset]);
+		int_to_scsilun(0, &slun);
+		if (cmd->data_length > 8)
+			memcpy(buf + offset, &slun,
+			       min(8u, cmd->data_length - offset));
 		lun_count = 1;
 	}
 
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

