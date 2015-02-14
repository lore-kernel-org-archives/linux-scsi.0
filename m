From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 5/8] target: Add sanity checks for DPO/FUA bit usage
Date: Sat, 14 Feb 2015 03:27:40 +0000
Message-ID: <1423884463-16797-6-git-send-email-nab@daterainc.com>
References: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1423884463-16797-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds a sbc_check_dpofua() function that performs sanity
checks for DPO/FUA command bits.

It introduces checks to fail when either bit is set, but the backend
device is not advertising support for them.

It also moves the existing cmd->se_cmd_flags |= SCF_FUA assignement
into the new helper function.

Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c | 56 +++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 87cbbe2..856e800 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -692,6 +692,29 @@ sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
 	return TCM_NO_SENSE;
 }
 
+static int
+sbc_check_dpofua(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
+{
+	if (cdb[1] & 0x10) {
+		if (!dev->dev_attrib.emulate_dpo) {
+			pr_err("Got CDB: 0x%02x with DPO bit set, but device"
+			       " does not advertise support for DPO\n", cdb[0]);
+			return -EINVAL;
+		}
+	}
+	if (cdb[1] & 0x8) {
+		if (!dev->dev_attrib.emulate_fua_write ||
+		    !dev->dev_attrib.emulate_write_cache) {
+			pr_err("Got CDB: 0x%02x with FUA bit set, but device"
+			       " does not advertise support for FUA write\n",
+			       cdb[0]);
+			return -EINVAL;
+		}
+		cmd->se_cmd_flags |= SCF_FUA;
+	}
+	return 0;
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 {
@@ -713,6 +736,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
+		if (sbc_check_dpofua(dev, cmd, cdb))
+			return TCM_INVALID_CDB_FIELD;
+
 		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
 		if (ret)
 			return ret;
@@ -725,6 +751,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
+		if (sbc_check_dpofua(dev, cmd, cdb))
+			return TCM_INVALID_CDB_FIELD;
+
 		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
 		if (ret)
 			return ret;
@@ -737,6 +766,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 
+		if (sbc_check_dpofua(dev, cmd, cdb))
+			return TCM_INVALID_CDB_FIELD;
+
 		ret = sbc_check_prot(dev, cmd, cdb, sectors, false);
 		if (ret)
 			return ret;
@@ -757,12 +789,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
+		if (sbc_check_dpofua(dev, cmd, cdb))
+			return TCM_INVALID_CDB_FIELD;
+
 		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
 		if (ret)
 			return ret;
 
-		if (cdb[1] & 0x8)
-			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
@@ -771,12 +804,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 
+		if (sbc_check_dpofua(dev, cmd, cdb))
+			return TCM_INVALID_CDB_FIELD;
+
 		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
 		if (ret)
 			return ret;
 
-		if (cdb[1] & 0x8)
-			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
@@ -785,12 +819,13 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 
+		if (sbc_check_dpofua(dev, cmd, cdb))
+			return TCM_INVALID_CDB_FIELD;
+
 		ret = sbc_check_prot(dev, cmd, cdb, sectors, true);
 		if (ret)
 			return ret;
 
-		if (cdb[1] & 0x8)
-			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
@@ -801,6 +836,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			return TCM_INVALID_CDB_FIELD;
 		sectors = transport_get_sectors_10(cdb);
 
+		if (sbc_check_dpofua(dev, cmd, cdb))
+			return TCM_INVALID_CDB_FIELD;
+
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 
@@ -810,8 +848,6 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
 		cmd->transport_complete_callback = &xdreadwrite_callback;
-		if (cdb[1] & 0x8)
-			cmd->se_cmd_flags |= SCF_FUA;
 		break;
 	case VARIABLE_LENGTH_CMD:
 	{
@@ -820,6 +856,8 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		case XDWRITEREAD_32:
 			sectors = transport_get_sectors_32(cdb);
 
+			if (sbc_check_dpofua(dev, cmd, cdb))
+				return TCM_INVALID_CDB_FIELD;
 			/*
 			 * Use WRITE_32 and READ_32 opcodes for the emulated
 			 * XDWRITE_READ_32 logic.
@@ -834,8 +872,6 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 			cmd->execute_rw = ops->execute_rw;
 			cmd->execute_cmd = sbc_execute_rw;
 			cmd->transport_complete_callback = &xdreadwrite_callback;
-			if (cdb[1] & 0x8)
-				cmd->se_cmd_flags |= SCF_FUA;
 			break;
 		case WRITE_SAME_32:
 			sectors = transport_get_sectors_32(cdb);
-- 
1.9.1
