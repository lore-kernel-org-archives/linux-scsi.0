From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/7] libata: simplify the trim implementation
Date: Mon, 20 Mar 2017 16:43:16 -0400
Message-ID: <20170320204319.12628-5-hch@lst.de>
References: <20170320204319.12628-1-hch@lst.de>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-1-hch@lst.de>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Don't try to fake up basic SCSI logical block provisioning and WRITE SAME
support, but offer support for the Linux Vendor Specific TRIM command
instead.  This simplifies the implementation a lot, and avoids rewriting
the data out buffer in the I/O path.   Note that this new command is only
offered to the block layer and will fail for pass through commands.
While this is theoretically a regression in the functionality offered
through SG_IO the previous support was buggy and corrupted user memory
by rewriting the data out buffer in place.

Last but not least this removes the global ata_scsi_rbuf_lock from
the trim path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ata/libata-scsi.c | 179 ++++++++--------------------------------------
 1 file changed, 28 insertions(+), 151 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b93d7e33789a..965b9e7dbb7d 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1322,6 +1322,16 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 	blk_queue_flush_queueable(q, false);
 
+	if (ata_id_has_trim(dev->id) &&
+	    !(dev->horkage & ATA_HORKAGE_NOTRIM)) {
+		sdev->ata_trim = 1;
+		if (ata_id_has_zero_after_trim(dev->id) &&
+		    (dev->horkage & ATA_HORKAGE_ZERO_AFTER_TRIM)) {
+			ata_dev_info(dev, "Enabling discard_zeroes_data\n");
+			sdev->ata_trim_zeroes_data = 1;
+		}
+	}
+
 	dev->sdev = sdev;
 	return 0;
 }
@@ -2383,21 +2393,6 @@ static unsigned int ata_scsiop_inq_b0(struct ata_scsi_args *args, u8 *rbuf)
 	 */
 	min_io_sectors = 1 << ata_id_log2_per_physical_sector(args->id);
 	put_unaligned_be16(min_io_sectors, &rbuf[6]);
-
-	/*
-	 * Optimal unmap granularity.
-	 *
-	 * The ATA spec doesn't even know about a granularity or alignment
-	 * for the TRIM command.  We can leave away most of the unmap related
-	 * VPD page entries, but we have specifify a granularity to signal
-	 * that we support some form of unmap - in thise case via WRITE SAME
-	 * with the unmap bit set.
-	 */
-	if (ata_id_has_trim(args->id)) {
-		put_unaligned_be64(65535 * ATA_MAX_TRIM_RNUM, &rbuf[36]);
-		put_unaligned_be32(1, &rbuf[28]);
-	}
-
 	return 0;
 }
 
@@ -2746,16 +2741,6 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		rbuf[14] = (lowest_aligned >> 8) & 0x3f;
 		rbuf[15] = lowest_aligned;
 
-		if (ata_id_has_trim(args->id) &&
-		    !(dev->horkage & ATA_HORKAGE_NOTRIM)) {
-			rbuf[14] |= 0x80; /* LBPME */
-
-			if (ata_id_has_zero_after_trim(args->id) &&
-			    dev->horkage & ATA_HORKAGE_ZERO_AFTER_TRIM) {
-				ata_dev_info(dev, "Enabling discard_zeroes_data\n");
-				rbuf[14] |= 0x40; /* LBPRZ */
-			}
-		}
 		if (ata_id_zoned_cap(args->id) ||
 		    args->dev->class == ATA_DEV_ZAC)
 			rbuf[12] = (1 << 4); /* RC_BASIS */
@@ -3339,141 +3324,45 @@ static unsigned int ata_scsi_pass_thru(struct ata_queued_cmd *qc)
 }
 
 /**
- * ata_format_dsm_trim_descr() - SATL Write Same to DSM Trim
- * @cmd: SCSI command being translated
- * @trmax: Maximum number of entries that will fit in sector_size bytes.
- * @sector: Starting sector
- * @count: Total Range of request in logical sectors
- *
- * Rewrite the WRITE SAME descriptor to be a DSM TRIM little-endian formatted
- * descriptor.
- *
- * Upto 64 entries of the format:
- *   63:48 Range Length
- *   47:0  LBA
- *
- *  Range Length of 0 is ignored.
- *  LBA's should be sorted order and not overlap.
- *
- * NOTE: this is the same format as ADD LBA(S) TO NV CACHE PINNED SET
- *
- * Return: Number of bytes copied into sglist.
- */
-static size_t ata_format_dsm_trim_descr(struct scsi_cmnd *cmd, u32 trmax,
-					u64 sector, u32 count)
-{
-	struct scsi_device *sdp = cmd->device;
-	size_t len = sdp->sector_size;
-	size_t r;
-	__le64 *buf;
-	u32 i = 0;
-	unsigned long flags;
-
-	WARN_ON(len > ATA_SCSI_RBUF_SIZE);
-
-	if (len > ATA_SCSI_RBUF_SIZE)
-		len = ATA_SCSI_RBUF_SIZE;
-
-	spin_lock_irqsave(&ata_scsi_rbuf_lock, flags);
-	buf = ((void *)ata_scsi_rbuf);
-	memset(buf, 0, len);
-	while (i < trmax) {
-		u64 entry = sector |
-			((u64)(count > 0xffff ? 0xffff : count) << 48);
-		buf[i++] = __cpu_to_le64(entry);
-		if (count <= 0xffff)
-			break;
-		count -= 0xffff;
-		sector += 0xffff;
-	}
-	r = sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd), buf, len);
-	spin_unlock_irqrestore(&ata_scsi_rbuf_lock, flags);
-
-	return r;
-}
-
-/**
- * ata_scsi_write_same_xlat() - SATL Write Same to ATA SCT Write Same
+ * ata_scsi_trim_xlat() - Handle the vendor specific TRIM command.
  * @qc: Command to be translated
  *
- * Translate a SCSI WRITE SAME command to be either a DSM TRIM command or
- * an SCT Write Same command.
- * Based on WRITE SAME has the UNMAP flag
- *   When set translate to DSM TRIM
- *   When clear translate to SCT Write Same
+ * Setup a DSM TRIM command (or it's queued variant) after sd already
+ * prepared the payload for us.
  */
-static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
+static unsigned int ata_scsi_trim_xlat(struct ata_queued_cmd *qc)
 {
 	struct ata_taskfile *tf = &qc->tf;
 	struct scsi_cmnd *scmd = qc->scsicmd;
-	struct scsi_device *sdp = scmd->device;
-	size_t len = sdp->sector_size;
 	struct ata_device *dev = qc->dev;
-	const u8 *cdb = scmd->cmnd;
-	u64 block;
-	u32 n_block;
-	const u32 trmax = len >> 3;
-	u32 size;
-	u16 fp;
-	u8 bp = 0xff;
-	u8 unmap = cdb[1] & 0x8;
-
-	/* we may not issue DMA commands if no DMA mode is set */
-	if (unlikely(!dev->dma_mode))
-		goto invalid_opcode;
 
-	if (unlikely(scmd->cmd_len < 16)) {
-		fp = 15;
-		goto invalid_fld;
+	if (unlikely(!dev->dma_mode)) {
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		return 1;
 	}
-	scsi_16_lba_len(cdb, &block, &n_block);
 
-	if (!unmap ||
-	    (dev->horkage & ATA_HORKAGE_NOTRIM) ||
-	    !ata_id_has_trim(dev->id)) {
-		fp = 1;
-		bp = 3;
-		goto invalid_fld;
-	}
-	/* If the request is too large the cmd is invalid */
-	if (n_block > 0xffff * trmax) {
-		fp = 2;
-		goto invalid_fld;
+	/* We only allow sending this command through the block layer */
+	if (unlikely(req_op(scmd->request) != REQ_OP_DISCARD)) {
+		ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
+		return 1;
 	}
 
-	/*
-	 * WRITE SAME always has a sector sized buffer as payload, this
-	 * should never be a multiple entry S/G list.
-	 */
-	if (!scsi_sg_count(scmd))
-		goto invalid_param_len;
-
-	/*
-	 * size must match sector size in bytes
-	 * For DATA SET MANAGEMENT TRIM in ACS-2 nsect (aka count)
-	 * is defined as number of 512 byte blocks to be transferred.
-	 */
-
-	size = ata_format_dsm_trim_descr(scmd, trmax, block, n_block);
-	if (size != len)
-		goto invalid_param_len;
-
 	if (ata_ncq_enabled(dev) && ata_fpdma_dsm_supported(dev)) {
 		/* Newer devices support queued TRIM commands */
 		tf->protocol = ATA_PROT_NCQ;
 		tf->command = ATA_CMD_FPDMA_SEND;
 		tf->hob_nsect = ATA_SUBCMD_FPDMA_SEND_DSM & 0x1f;
 		tf->nsect = qc->tag << 3;
-		tf->hob_feature = (size / 512) >> 8;
-		tf->feature = size / 512;
+		tf->hob_feature = (scmd->device->sector_size / 512) >> 8;
+		tf->feature = scmd->device->sector_size / 512;
 
 		tf->auxiliary = 1;
 	} else {
 		tf->protocol = ATA_PROT_DMA;
 		tf->hob_feature = 0;
 		tf->feature = ATA_DSM_TRIM;
-		tf->hob_nsect = (size / 512) >> 8;
-		tf->nsect = size / 512;
+		tf->hob_nsect = (scmd->device->sector_size / 512) >> 8;
+		tf->nsect = scmd->device->sector_size / 512;
 		tf->command = ATA_CMD_DSM;
 	}
 
@@ -3483,18 +3372,6 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 	ata_qc_set_pc_nbytes(qc);
 
 	return 0;
-
-invalid_fld:
-	ata_scsi_set_invalid_field(dev, scmd, fp, bp);
-	return 1;
-invalid_param_len:
-	/* "Parameter list length error" */
-	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
-	return 1;
-invalid_opcode:
-	/* "Invalid command operation code" */
-	ata_scsi_set_sense(dev, scmd, ILLEGAL_REQUEST, 0x20, 0x0);
-	return 1;
 }
 
 /**
@@ -4087,9 +3964,6 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case WRITE_16:
 		return ata_scsi_rw_xlat;
 
-	case WRITE_SAME_16:
-		return ata_scsi_write_same_xlat;
-
 	case SYNCHRONIZE_CACHE:
 		if (ata_try_flush_cache(dev))
 			return ata_scsi_flush_xlat;
@@ -4116,6 +3990,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
+
+	case LINUX_VS_TRIM:
+		return ata_scsi_trim_xlat;
 	}
 
 	return NULL;
-- 
2.11.0

