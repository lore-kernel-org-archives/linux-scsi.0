From: michaelc@cs.wisc.edu
Subject: [PATCH 4/5] lio: use REQ_COMPARE_AND_WRITE if supported
Date: Thu, 16 Oct 2014 00:37:14 -0500
Message-ID: <1413437835-13778-5-git-send-email-michaelc@cs.wisc.edu>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Sender: target-devel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

This has lio callout to the backing store module if it supports
using REQ_COMPARE_AND_WRITE. The backing store would set the
device attribute max_compare_and_write_len if it supports using
the new request type. If it is not supported then we do the
read/cmp/write emulation in the sbc layer like before.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/target/target_core_sbc.c       |   21 ++++++++++++++++-----
 drivers/target/target_core_spc.c       |   12 ++++++++++--
 drivers/target/target_core_transport.c |    1 +
 include/target/target_core_backend.h   |    1 +
 include/target/target_core_base.h      |    1 +
 5 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ebe62af..fe0c16a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -555,6 +555,21 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
+static void sbc_setup_compare_and_write(struct se_cmd *cmd, struct sbc_ops *ops,
+					u32 sectors)
+{
+	cmd->t_task_nolb = sectors;
+	cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB | SCF_COMPARE_AND_WRITE;
+
+	if (cmd->se_dev->dev_attrib.max_compare_and_write_len) {
+		cmd->execute_cmd = ops->execute_compare_and_write;
+	} else {
+		cmd->execute_rw = ops->execute_rw;
+		cmd->execute_cmd = sbc_compare_and_write;
+		cmd->transport_complete_callback = compare_and_write_callback;
+	}
+}
+
 static int
 sbc_set_prot_op_checks(u8 protect, enum target_prot_type prot_type,
 		       bool is_write, struct se_cmd *cmd)
@@ -842,11 +857,7 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		 */
 		size = 2 * sbc_get_size(cmd, sectors);
 		cmd->t_task_lba = get_unaligned_be64(&cdb[2]);
-		cmd->t_task_nolb = sectors;
-		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB | SCF_COMPARE_AND_WRITE;
-		cmd->execute_rw = ops->execute_rw;
-		cmd->execute_cmd = sbc_compare_and_write;
-		cmd->transport_complete_callback = compare_and_write_callback;
+		sbc_setup_compare_and_write(cmd, ops, sectors);
 		break;
 	case READ_CAPACITY:
 		size = READ_CAP_LEN;
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 6cd7222..7db8c22 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -525,8 +525,16 @@ spc_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	/*
 	 * Set MAXIMUM COMPARE AND WRITE LENGTH
 	 */
-	if (dev->dev_attrib.emulate_caw)
-		buf[5] = 0x01;
+	if (dev->dev_attrib.emulate_caw) {
+		if (!dev->dev_attrib.max_compare_and_write_len)
+			/*
+			 * if backing device does not have special handling
+			 * then sbc will support up to 1 block.
+		 	 */
+			buf[5] = 0x01;
+		else
+			buf[5] = dev->dev_attrib.max_compare_and_write_len;
+	}
 
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9ea0d5f..e7706f9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1637,6 +1637,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	case TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED:
 	case TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED:
 	case TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED:
+	case TCM_MISCOMPARE_VERIFY:
 		break;
 	case TCM_OUT_OF_RESOURCES:
 		sense_reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index 9adc1bc..06924b1 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -53,6 +53,7 @@ struct sbc_ops {
 	sense_reason_t (*execute_write_same)(struct se_cmd *cmd);
 	sense_reason_t (*execute_write_same_unmap)(struct se_cmd *cmd);
 	sense_reason_t (*execute_unmap)(struct se_cmd *cmd);
+	sense_reason_t (*execute_compare_and_write)(struct se_cmd *cmd);
 };
 
 int	transport_subsystem_register(struct se_subsystem_api *);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 23c518a..bc0a26e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -697,6 +697,7 @@ struct se_dev_attrib {
 	u32		unmap_granularity;
 	u32		unmap_granularity_alignment;
 	u32		max_write_same_len;
+	u32		max_compare_and_write_len;
 	u32		max_bytes_per_io;
 	struct se_device *da_dev;
 	struct config_group da_group;
-- 
1.7.1
