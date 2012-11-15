From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 1/3] target/sbc: Seperate WRITE_SAME based on UNMAP flag in sbc_ops
Date: Thu, 15 Nov 2012 20:13:57 +0000
Message-ID: <1353010439-4600-2-git-send-email-nab@linux-iscsi.org>
References: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1353010439-4600-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a new sbc_ops->execute_write_same_unmap() caller for use
with WRITE_SAME w/ UNMAP=1, and performs the ->execute_cmd() setup based
this bit within sbc_setup_write_same() code.

Also, makes the changes in sbc_parse_cdb() to handle a sense_reason_t
return from sbc_setup_write_same() on error.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c     |   51 +++++++++++++++------------------
 include/target/target_core_backend.h |    1 +
 2 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index b802421..a5a8f46 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -235,26 +235,30 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 	return ((unsigned long long)__v2) | (unsigned long long)__v1 << 32;
 }
 
-static int sbc_write_same_supported(struct se_device *dev,
-		unsigned char *flags)
+static sense_reason_t
+sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *ops)
 {
 	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
 		pr_err("WRITE_SAME PBDATA and LBDATA"
 			" bits not supported for Block Discard"
 			" Emulation\n");
-		return -ENOSYS;
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
 	}
-
 	/*
-	 * Currently for the emulated case we only accept
-	 * tpws with the UNMAP=1 bit set.
+	 * Special case for WRITE_SAME w/ UNMAP=1 that ends up getting
+	 * translated into block discard requests within backend code.
 	 */
-	if (!(flags[0] & 0x08)) {
-		pr_err("WRITE_SAME w/o UNMAP bit not"
-			" supported for Block Discard Emulation\n");
-		return -ENOSYS;
+	if (flags[0] & 0x08) {
+		if (!ops->execute_write_same_unmap)
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
+		cmd->execute_cmd = ops->execute_write_same_unmap;
+		return 0;
 	}
+	if (!ops->execute_write_same)
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
 
+	cmd->execute_cmd = ops->execute_write_same;
 	return 0;
 }
 
@@ -418,9 +422,6 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 				cmd->se_cmd_flags |= SCF_FUA;
 			break;
 		case WRITE_SAME_32:
-			if (!ops->execute_write_same)
-				return TCM_UNSUPPORTED_SCSI_OPCODE;
-
 			sectors = transport_get_sectors_32(cdb);
 			if (!sectors) {
 				pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not"
@@ -431,9 +432,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
-			if (sbc_write_same_supported(dev, &cdb[10]) < 0)
-				return TCM_UNSUPPORTED_SCSI_OPCODE;
-			cmd->execute_cmd = ops->execute_write_same;
+			ret = sbc_setup_write_same(cmd, &cdb[10], ops);
+			if (ret < 0)
+				return ret;
 			break;
 		default:
 			pr_err("VARIABLE_LENGTH_CMD service action"
@@ -495,9 +496,6 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = ops->execute_unmap;
 		break;
 	case WRITE_SAME_16:
-		if (!ops->execute_write_same)
-			return TCM_UNSUPPORTED_SCSI_OPCODE;
-
 		sectors = transport_get_sectors_16(cdb);
 		if (!sectors) {
 			pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
@@ -507,14 +505,11 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
-		if (sbc_write_same_supported(dev, &cdb[1]) < 0)
-			return TCM_UNSUPPORTED_SCSI_OPCODE;
-		cmd->execute_cmd = ops->execute_write_same;
+		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		if (ret < 0)
+			return ret;
 		break;
 	case WRITE_SAME:
-		if (!ops->execute_write_same)
-			return TCM_UNSUPPORTED_SCSI_OPCODE;
-
 		sectors = transport_get_sectors_10(cdb);
 		if (!sectors) {
 			pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
@@ -528,9 +523,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 * Follow sbcr26 with WRITE_SAME (10) and check for the existence
 		 * of byte 1 bit 3 UNMAP instead of original reserved field
 		 */
-		if (sbc_write_same_supported(dev, &cdb[1]) < 0)
-			return TCM_UNSUPPORTED_SCSI_OPCODE;
-		cmd->execute_cmd = ops->execute_write_same;
+		ret = sbc_setup_write_same(cmd, &cdb[1], ops);
+		if (ret < 0)
+			return ret;
 		break;
 	case VERIFY:
 		size = 0;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index aa86809..3393ab1 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -41,6 +41,7 @@ struct sbc_ops {
 	sense_reason_t (*execute_rw)(struct se_cmd *cmd);
 	sense_reason_t (*execute_sync_cache)(struct se_cmd *cmd);
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
+	sense_reason_t (*execute_write_same_unmap)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd);
 };
 
-- 
1.7.2.5
