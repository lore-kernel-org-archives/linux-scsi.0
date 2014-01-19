From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 03/17] target/sbc: Add DIF setup in sbc_check_prot + sbc_parse_cdb
Date: Sun, 19 Jan 2014 02:44:26 +0000
Message-ID: <1390099480-29013-4-git-send-email-nab@daterainc.com>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds sbc_check_prot() for performing various DIF
related CDB sanity checks, along with setting cmd->prot_type
once sanity checks have passed.

Also, add calls in sbc_parse_cdb() for READ_[10,12,16] +
WRITE_[10,12,16] to perform DIF sanity checking.

v2 changes:
  - Make sbc_check_prot defined as static (Fengguang + Wei)
  - Remove unprotected READ/WRITE warning (mkp)
  - Populate cmd->prot_type + friends (Sagi)
  - Drop SCF_PROT usage

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c |   62 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 6863dbe..91a92f3 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -563,6 +563,44 @@ sbc_compare_and_write(struct se_cmd *cmd)
 	return TCM_NO_SENSE;
 }
 
+static bool
+sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
+	       u32 sectors)
+{
+	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
+		return true;
+
+	switch (dev->dev_attrib.pi_prot_type) {
+	case TARGET_DIF_TYPE3_PROT:
+		if (!(cdb[1] & 0xe0))
+			return true;
+
+		cmd->reftag_seed = 0xffffffff;
+		break;
+	case TARGET_DIF_TYPE2_PROT:
+		if (cdb[1] & 0xe0)
+			return false;
+
+		cmd->reftag_seed = cmd->t_task_lba;
+		break;
+	case TARGET_DIF_TYPE1_PROT:
+		if (!(cdb[1] & 0xe0))
+			return true;
+
+		cmd->reftag_seed = cmd->t_task_lba;
+		break;
+	case TARGET_DIF_TYPE0_PROT:
+	default:
+		return true;
+	}
+
+	cmd->prot_type = dev->dev_attrib.pi_prot_type;
+	cmd->prot_length = dev->prot_length * sectors;
+	cmd->prot_handover = PROT_SEPERATED;
+
+	return true;
+}
+
 sense_reason_t
 sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 {
@@ -583,6 +621,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case READ_10:
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
+
+		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
@@ -590,6 +632,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case READ_12:
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
+
+		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
@@ -597,6 +643,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case READ_16:
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
+
+		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
 		cmd->execute_rw = ops->execute_rw;
 		cmd->execute_cmd = sbc_execute_rw;
@@ -612,6 +662,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case WRITE_VERIFY:
 		sectors = transport_get_sectors_10(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
+
+		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		if (cdb[1] & 0x8)
 			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -621,6 +675,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case WRITE_12:
 		sectors = transport_get_sectors_12(cdb);
 		cmd->t_task_lba = transport_lba_32(cdb);
+
+		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		if (cdb[1] & 0x8)
 			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
@@ -630,6 +688,10 @@ sbc_parse_cdb(struct se_cmd *cmd, struct sbc_ops *ops)
 	case WRITE_16:
 		sectors = transport_get_sectors_16(cdb);
 		cmd->t_task_lba = transport_lba_64(cdb);
+
+		if (!sbc_check_prot(dev, cmd, cdb, sectors))
+			return TCM_UNSUPPORTED_SCSI_OPCODE;
+
 		if (cdb[1] & 0x8)
 			cmd->se_cmd_flags |= SCF_FUA;
 		cmd->se_cmd_flags |= SCF_SCSI_DATA_CDB;
-- 
1.7.10.4
