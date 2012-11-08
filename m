From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] target/sbc: Make WRITE_SAME check differentiate between UNMAP=[1,0]
Date: Thu,  8 Nov 2012 20:07:16 +0000
Message-ID: <1352405238-23267-2-git-send-email-nab@linux-iscsi.org>
References: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352405238-23267-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates sbc_write_same_supported() to set SCF_WRITE_SAME_DISCARD
to signal when WRITE_SAME w/ UNMAP=1 is requested.

Also, allow WRITE_SAME w/ UNMAP=0 to be passed to backend driver logic.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c  |   19 +++++++------------
 include/target/target_core_base.h |    1 +
 2 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index b802421..ee9fa52 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -235,7 +235,7 @@ static inline unsigned long long transport_lba_64_ext(unsigned char *cdb)
 	return ((unsigned long long)__v2) | (unsigned long long)__v1 << 32;
 }
 
-static int sbc_write_same_supported(struct se_device *dev,
+static int sbc_write_same_supported(struct se_cmd *cmd,
 		unsigned char *flags)
 {
 	if ((flags[0] & 0x04) || (flags[0] & 0x02)) {
@@ -244,16 +244,11 @@ static int sbc_write_same_supported(struct se_device *dev,
 			" Emulation\n");
 		return -ENOSYS;
 	}
-
 	/*
-	 * Currently for the emulated case we only accept
-	 * tpws with the UNMAP=1 bit set.
+	 * UNMAP=1 bit translantes to blkdev_issue_discard() execution
 	 */
-	if (!(flags[0] & 0x08)) {
-		pr_err("WRITE_SAME w/o UNMAP bit not"
-			" supported for Block Discard Emulation\n");
-		return -ENOSYS;
-	}
+	if (flags[0] & 0x08)
+		cmd->se_cmd_flags |= SCF_WRITE_SAME_DISCARD;
 
 	return 0;
 }
@@ -431,7 +426,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			size = sbc_get_size(cmd, 1);
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 
-			if (sbc_write_same_supported(dev, &cdb[10]) < 0)
+			if (sbc_write_same_supported(cmd, &cdb[10]) < 0)
 				return TCM_UNSUPPORTED_SCSI_OPCODE;
 			cmd->execute_cmd = ops->execute_write_same;
 			break;
@@ -507,7 +502,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		size = sbc_get_size(cmd, 1);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
 
-		if (sbc_write_same_supported(dev, &cdb[1]) < 0)
+		if (sbc_write_same_supported(cmd, &cdb[1]) < 0)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		cmd->execute_cmd = ops->execute_write_same;
 		break;
@@ -528,7 +523,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 * Follow sbcr26 with WRITE_SAME (10) and check for the existence
 		 * of byte 1 bit 3 UNMAP instead of original reserved field
 		 */
-		if (sbc_write_same_supported(dev, &cdb[1]) < 0)
+		if (sbc_write_same_supported(cmd, &cdb[1]) < 0)
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		cmd->execute_cmd = ops->execute_write_same;
 		break;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 5350f6e..2787b85 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -154,6 +154,7 @@ enum se_cmd_flags_table {
 	SCF_ALUA_NON_OPTIMIZED		= 0x00008000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
 	SCF_ACK_KREF			= 0x00040000,
+	SCF_WRITE_SAME_DISCARD		= 0x00080000,
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
-- 
1.7.2.5
