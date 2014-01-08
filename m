From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 03/14] target/sbc: Add sbc_check_prot + update sbc_parse_cdb for DIF
Date: Wed,  8 Jan 2014 20:15:46 +0000
Message-ID: <1389212157-14540-4-git-send-email-nab@daterainc.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds sbc_check_prot() for performing various DIF
related CDB sanity checks, along with setting SCF_PROT once
sanity checks have passed.

Also, add calls in sbc_parse_cdb() for READ_[10,12,16] +
WRITE_[10,12,16] to perform DIF sanity checking.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c |   39 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 52ae54e..600ffcb 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -563,6 +563,27 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
+bool
+sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb)
+{
+	if (!dev->dev_attrib.pi_prot_type)
+		return true;
+
+	if (dev->dev_attrib.pi_prot_type == TARGET_DIF_TYPE2_PROT &&
+	   (cdb[1] & 0xe0))
+		return false;
+
+	if (!(cdb[1] & 0xe0)) {
+		pr_warn("Target: Unprotected READ/WRITE to DIF device\n");
+		return true;
+	}
+	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
+		return true;
+
+	cmd->se_cmd_flags |= SCF_PROT;
+	return true;
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 {
@@ -581,6 +602,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case READ_10:
+		if (!sbc_check_prot(dev, cmd, cdb))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -588,6 +612,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case READ_12:
+		if (!sbc_check_prot(dev, cmd, cdb))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -595,6 +622,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case READ_16:
+		if (!sbc_check_prot(dev, cmd, cdb))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -610,6 +640,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		break;
 	case WRITE_10:
 	case WRITE_VERIFY:
+		if (!sbc_check_prot(dev, cmd, cdb))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 		if (cdb[1] & 0x8)
@@ -619,6 +652,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_12:
+		if (!sbc_check_prot(dev, cmd, cdb))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
 		if (cdb[1] & 0x8)
@@ -628,6 +664,9 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 		cmd->execute_cmd = sbc_execute_rw;
 		break;
 	case WRITE_16:
+		if (!sbc_check_prot(dev, cmd, cdb))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
 		if (cdb[1] & 0x8)
-- 
1.7.10.4
