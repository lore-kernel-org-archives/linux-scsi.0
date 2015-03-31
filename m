From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] libata: implement ZBC IN translation
Date: Tue, 31 Mar 2015 10:52:41 +0200
Message-ID: <1427791963-90832-2-git-send-email-hare@suse.de>
References: <1427791963-90832-1-git-send-email-hare@suse.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1427791963-90832-1-git-send-email-hare@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

ZAC drives implement 'zac management in' command template,
which maps onto the ZBC IN command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-eh.c       |   1 +
 drivers/ata/libata-scsi.c     | 144 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/ata.h           |   4 ++
 include/scsi/scsi.h           |   3 +
 include/trace/events/libata.h |   1 +
 5 files changed, 153 insertions(+)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 07f41be..adf306e 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2479,6 +2479,7 @@ const char *ata_get_cmd_descript(u8 command)
 		{ ATA_CMD_CFA_WRITE_MULT_NE,	"CFA WRITE MULTIPLE WITHOUT ERASE" },
 		{ ATA_CMD_REQ_SENSE_DATA,	"REQUEST SENSE DATA EXT" },
 		{ ATA_CMD_SANITIZE_DEVICE,	"SANITIZE DEVICE" },
+		{ ATA_CMD_ZAC_MGMT_IN,		"ZAC MANAGEMENT IN" },
 		{ ATA_CMD_READ_LONG,		"READ LONG (with retries)" },
 		{ ATA_CMD_READ_LONG_ONCE,	"READ LONG (without retries)" },
 		{ ATA_CMD_WRITE_LONG,		"WRITE LONG (with retries)" },
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 35fec70..fa480de 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3202,6 +3202,147 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	return 1;
 }
 
+/*
+ * ata_scsi_report_zones_complete
+ *
+ * Convert T-13 little-endian field representation into
+ * T-10 big-endian field representation.
+ */
+static void ata_scsi_report_zones_complete(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	struct sg_mapping_iter miter;
+	unsigned long flags;
+	unsigned int bytes = 0;
+
+	sg_miter_start(&miter, scsi_sglist(scmd), scsi_sg_count(scmd),
+		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+
+	local_irq_save(flags);
+	while (sg_miter_next(&miter)) {
+		unsigned int offset = 0;
+
+		if (bytes == 0) {
+			char *hdr;
+			u32 list_length;
+			u64 max_lba, opt_lba;
+			u16 same;
+
+			/* Swizzle header */
+			hdr = miter.addr;
+			list_length = get_unaligned_le32(&hdr[0]);
+			same = get_unaligned_le16(&hdr[4]);
+			max_lba = get_unaligned_le64(&hdr[8]);
+			opt_lba = get_unaligned_le64(&hdr[16]);
+			put_unaligned_be32(list_length, &hdr[0]);
+			hdr[4] = same & 0xf;
+			put_unaligned_be64(max_lba, &hdr[8]);
+			put_unaligned_be64(opt_lba, &hdr[16]);
+			offset += 64;
+			bytes += 64;
+		}
+		while (offset < miter.length) {
+			char *rec;
+			u16 option;
+			u8 cond, type, reset;
+			u64 size, start, wp, checkpoint;
+
+			/* Swizzle zone descriptor */
+			rec = miter.addr + offset;
+			option = get_unaligned_le16(&rec[0]);
+			cond = (option >> 4) & 0xf;
+			type = (option >> 8) & 0xf;
+			reset = (option & 1);
+			size = get_unaligned_le64(&rec[8]);
+			start = get_unaligned_le64(&rec[16]);
+			wp = get_unaligned_le64(&rec[24]);
+			checkpoint = get_unaligned_le64(&rec[32]);
+			rec[0] = type;
+			rec[1] = (cond << 4) | reset;
+			put_unaligned_be64(size, &rec[8]);
+			put_unaligned_be64(start, &rec[16]);
+			put_unaligned_be64(wp, &rec[24]);
+			put_unaligned_be64(checkpoint, &rec[32]);
+			WARN_ON(offset + 64 > miter.length);
+			offset += 64;
+			bytes += 64;
+		}
+	}
+	sg_miter_stop(&miter);
+	local_irq_restore(flags);
+
+	ata_scsi_qc_complete(qc);
+}
+
+static unsigned int ata_scsi_zbc_in_xlat(struct ata_queued_cmd *qc)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
+	u16 sect;
+	u8 sa, options;
+	u64 block;
+	u32 n_block;
+
+	if (unlikely(scmd->cmd_len < 16)) {
+		ata_dev_warn(qc->dev, "invalid cdb length %d\n",
+			     scmd->cmd_len);
+		goto invalid_fld;
+	}
+	scsi_16_lba_len(cdb, &block, &n_block);
+	if (n_block != scsi_bufflen(scmd)) {
+		ata_dev_warn(qc->dev, "non-matching transfer count (%d/%d)\n",
+			     n_block, scsi_bufflen(scmd));
+		goto invalid_fld;
+	}
+	sa = cdb[1] & 0x1f;
+	if (sa != ZI_REPORT_ZONES) {
+		ata_dev_warn(qc->dev, "invalid service action %d\n", sa);
+		goto invalid_fld;
+	}
+	/*
+	 * ZAC allows only for transfers in 512 byte blocks,
+	 * and uses a 16 bit value for the transfer count.
+	 */
+	if ((n_block / 512) > 0xffff || n_block < 512 || (n_block % 512)) {
+		ata_dev_warn(qc->dev, "invalid transfer count %d\n", n_block);
+		goto invalid_fld;
+	}
+	sect = n_block / 512;
+	options = cdb[14];
+
+	tf->command = ATA_CMD_ZAC_MGMT_IN;
+	tf->feature = ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES;
+	if (qc->dev->dma_mode)
+		tf->protocol = ATA_PROT_DMA;
+	else
+		tf->protocol = ATA_PROT_PIO;
+	tf->hob_feature = options & 0x3f;
+	tf->hob_nsect = (sect >> 8) & 0xff;
+	tf->nsect = sect & 0xff;
+	tf->device |= (1 << 6);
+	tf->lbah = (block >> 16) & 0xff;
+	tf->lbam = (block >> 8) & 0xff;
+	tf->lbal = block & 0xff;
+	tf->hob_lbah = (block >> 40) & 0xff;
+	tf->hob_lbam = (block >> 32) & 0xff;
+	tf->hob_lbal = (block >> 24) & 0xff;
+
+	tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE | ATA_TFLAG_LBA48;
+	qc->flags |= ATA_QCFLAG_RESULT_TF;
+
+	ata_qc_set_pc_nbytes(qc);
+
+	qc->complete_fn = ata_scsi_report_zones_complete;
+
+	return 0;
+
+ invalid_fld:
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x00);
+	/* "Invalid field in cdb" */
+	return 1;
+}
+
 /**
  *	ata_mselect_caching - Simulate MODE SELECT for caching info page
  *	@qc: Storage for translated ATA taskfile
@@ -3429,6 +3570,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 		return ata_scsi_mode_select_xlat;
 		break;
 
+	case ZBC_IN:
+		return ata_scsi_zbc_in_xlat;
+
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
 	}
diff --git a/include/linux/ata.h b/include/linux/ata.h
index b666b77..63427b1 100644
--- a/include/linux/ata.h
+++ b/include/linux/ata.h
@@ -300,6 +300,7 @@ enum {
 	ATA_CMD_CFA_WRITE_MULT_NE = 0xCD,
 	ATA_CMD_REQ_SENSE_DATA  = 0x0B,
 	ATA_CMD_SANITIZE_DEVICE = 0xB4,
+	ATA_CMD_ZAC_MGMT_IN	= 0x4A,
 
 	/* marked obsolete in the ATA/ATAPI-7 spec */
 	ATA_CMD_RESTORE		= 0x10,
@@ -308,6 +309,9 @@ enum {
 	ATA_SUBCMD_FPDMA_SEND_DSM            = 0x00,
 	ATA_SUBCMD_FPDMA_SEND_WR_LOG_DMA_EXT = 0x02,
 
+	/* Subcmds for ATA_CMD_ZAC_MGMT_IN */
+	ATA_SUBCMD_ZAC_MGMT_IN_REPORT_ZONES = 0x00,
+
 	/* READ_LOG_EXT pages */
 	ATA_LOG_SATA_NCQ	= 0x10,
 	ATA_LOG_NCQ_SEND_RECV	  = 0x13,
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index d0a66aa..607c25a 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -153,6 +153,7 @@ enum scsi_timeouts {
 #define VERIFY_16	      0x8f
 #define SYNCHRONIZE_CACHE_16  0x91
 #define WRITE_SAME_16	      0x93
+#define ZBC_IN		      0x95
 #define SERVICE_ACTION_BIDIRECTIONAL 0x9d
 #define SERVICE_ACTION_IN_16  0x9e
 #define SERVICE_ACTION_OUT_16 0x9f
@@ -181,6 +182,8 @@ enum scsi_timeouts {
 #define MO_SET_PRIORITY       0x0e
 #define MO_SET_TIMESTAMP      0x0f
 #define MO_MANAGEMENT_PROTOCOL_OUT 0x10
+/* values for ZBC_IN */
+#define ZI_REPORT_ZONES	      0x00
 /* values for variable length command */
 #define XDREAD_32	      0x03
 #define XDWRITE_32	      0x04
diff --git a/include/trace/events/libata.h b/include/trace/events/libata.h
index 8b0fbd9..02ec4e5 100644
--- a/include/trace/events/libata.h
+++ b/include/trace/events/libata.h
@@ -97,6 +97,7 @@
 		 ata_opcode_name(ATA_CMD_CFA_WRITE_MULT_NE),	\
 		 ata_opcode_name(ATA_CMD_REQ_SENSE_DATA),	\
 		 ata_opcode_name(ATA_CMD_SANITIZE_DEVICE),	\
+		 ata_opcode_name(ATA_CMD_ZAC_MGMT_IN),		\
 		 ata_opcode_name(ATA_CMD_RESTORE),		\
 		 ata_opcode_name(ATA_CMD_READ_LONG),		\
 		 ata_opcode_name(ATA_CMD_READ_LONG_ONCE),	\
-- 
1.8.5.2

