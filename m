From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] libata: Implement ZBC OUT translation
Date: Mon,  4 Apr 2016 11:47:49 +0200
Message-ID: <1459763271-125856-3-git-send-email-hare@suse.de>
References: <1459763271-125856-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1459763271-125856-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

ZAC drives implement a 'zac management out' command template,
which maps onto the ZBC OUT command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c       |  1 +
 drivers/ata/libata-scsi.c     | 73 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h           |  7 +++++
 include/trace/events/libata.h |  1 +
 4 files changed, 82 insertions(+)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index e947bd5..ee984f9 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2481,6 +2481,7 @@ const char *ata_get_cmd_descript(u8 command)
 		{ ATA_CMD_REQ_SENSE_DATA,	"REQUEST SENSE DATA EXT" },
 		{ ATA_CMD_SANITIZE_DEVICE,	"SANITIZE DEVICE" },
 		{ ATA_CMD_ZAC_MGMT_IN,		"ZAC MANAGEMENT IN" },
+		{ ATA_CMD_ZAC_MGMT_OUT,		"ZAC MANAGEMENT OUT" },
 		{ ATA_CMD_READ_LONG,		"READ LONG (with retries)" },
 		{ ATA_CMD_READ_LONG_ONCE,	"READ LONG (without retries)" },
 		{ ATA_CMD_WRITE_LONG,		"WRITE LONG (with retries)" },
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 21c2b40..6db2aaf 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3451,6 +3451,76 @@ invalid_param_len:
 	return 1;
 }
 
+static unsigned int ata_scsi_zbc_out_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct ata_device *dev = qc->dev;
+	const u8 *cdb = scmd->cmnd;
+	u8 reset_all, sa;
+	u64 block;
+	u32 n_block;
+	u16 fp = (u16)-1;
+
+	if (unlikely(scmd->cmd_len < 16)) {
+		fp = 15;
+		goto invalid_fld;
+	}
+
+	/*
+	 * The service action definition got moved from
+	 * 0x00 to 0x04 with zbc-r02, so accept both.
+	 */
+	sa = cdb[1] & 0x1f;
+	/* Compatibility with ZBC r01 */
+	if (!sa)
+		sa = ZO_RESET_WRITE_POINTER;
+	if (sa != ZO_RESET_WRITE_POINTER) {
+		fp = 1;
+		goto invalid_fld;
+	}
+
+	scsi_16_lba_len(cdb, &block, &n_block);
+	if (n_block) {
+		/*
+		 * ZAC MANAGEMENT OUT doesn't define any length
+		 */
+		goto invalid_param_len;
+	}
+	if (block > dev->n_sectors)
+		goto out_of_range;
+
+	reset_all = cdb[14] & 0x1;
+
+	tf->protocol = ATA_PROT_NODATA;
+	tf->command = ATA_CMD_ZAC_MGMT_OUT;
+	tf->feature = sa;
+	tf->hob_feature = reset_all & 0x1;
+
+	tf->lbah = (block >> 16) & 0xff;
+	tf->lbam = (block >> 8) & 0xff;
+	tf->lbal = block & 0xff;
+	tf->hob_lbah = (block >> 40) & 0xff;
+	tf->hob_lbam = (block >> 32) & 0xff;
+	tf->hob_lbal = (block >> 24) & 0xff;
+	tf->device = ATA_LBA;
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
+
+	return 0;
+
+ invalid_fld:
+	ata_scsi_set_invalid_field(qc->dev, scmd, fp, 0xff);
+	return 1;
+ out_of_range:
+	/* "Logical Block Address out of range" */
+	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x21, 0x00);
+	return 1;
+invalid_param_len:
+	/* "Parameter list length error" */
+	ata_scsi_set_sense(qc->dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	return 1;
+}
+
 /**
  *	ata_mselect_caching - Simulate MODE SELECT for caching info page
  *	@qc: Storage for translated ATA taskfile
@@ -3767,6 +3837,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case ZBC_IN:
 		return ata_scsi_zbc_in_xlat;
 
+	case ZBC_OUT:
+		return ata_scsi_zbc_out_xlat;
+
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
 	}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index 2e4a6af..eef9d80 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -302,6 +302,7 @@ enum {
 	ATA_CMD_REQ_SENSE_DATA  = 0x0B,
 	ATA_CMD_SANITIZE_DEVICE = 0xB4,
 	ATA_CMD_ZAC_MGMT_IN	= 0x4A,
+	ATA_CMD_ZAC_MGMT_OUT	= 0x9F,
 
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
@@ -313,6 +314,12 @@ enum {
 	/* Subcmds for ATA_CMD_ZAC_MGMT_IN */
 	ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES = 0x00,
 
+	/* Subcmds for ATA_CMD_ZAC_MGMT_OUT */
+	ATA_SUBCMD_ZAC_MGMT_OUT_CLOSE_ZONE = 0x01,
+	ATA_SUBCMD_ZAC_MGMT_OUT_FINISH_ZONE = 0x02,
+	ATA_SUBCMD_ZAC_MGMT_OUT_OPEN_ZONE = 0x03,
+	ATA_SUBCMD_ZAC_MGMT_OUT_RESET_WRITE_POINTER = 0x04,
+
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
 	ATA_LOG_NCQ_SEND_RECV	  = 0x13,
diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
index 02ec4e5..24dcd43 100644
--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -98,6 +98,7 @@
 		 ata_opcode_name(ATA_CMD_REQ_SENSE_DATA),	\
 		 ata_opcode_name(ATA_CMD_SANITIZE_DEVICE),	\
 		 ata_opcode_name(ATA_CMD_ZAC_MGMT_IN),		\
+		 ata_opcode_name(ATA_CMD_ZAC_MGMT_OUT),		\
 		 ata_opcode_name(ATA_CMD_RESTORE),		\
 		 ata_opcode_name(ATA_CMD_READ_LONG),		\
 		 ata_opcode_name(ATA_CMD_READ_LONG_ONCE),	\
-- 
1.8.5.6

