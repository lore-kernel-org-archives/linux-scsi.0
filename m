From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/7] sd: provide a new ata trim provisioning mode
Date: Mon, 20 Mar 2017 16:43:14 -0400
Message-ID: <20170320204319.12628-3-hch@lst.de>
References: <20170320204319.12628-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170320204319.12628-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This uses a vendor specific command to pass the ATA TRIM payload to
libata without having to rewrite it in place.  Support for it is
indicated by a new flag in struct scsi_device that libata will set
in it's slave_configure routine.  A second flag indicates if TRIM
will reliably zero data.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c          | 60 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/scsi/sd.h          |  1 +
 include/scsi/scsi_device.h |  2 ++
 include/scsi/scsi_proto.h  |  3 +++
 4 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b853f91fb3da..cc8684818305 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -371,6 +371,7 @@ static const char *lbp_mode[] = {
 	[SD_LBP_WS16]		= "writesame_16",
 	[SD_LBP_WS10]		= "writesame_10",
 	[SD_LBP_ZERO]		= "writesame_zero",
+	[SD_LBP_ATA_TRIM]	= "ata_trim",
 	[SD_LBP_DISABLE]	= "disabled",
 };
 
@@ -411,7 +412,7 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 		sd_config_discard(sdkp, SD_LBP_ZERO);
 	else if (!strncmp(buf, lbp_mode[SD_LBP_DISABLE], 20))
 		sd_config_discard(sdkp, SD_LBP_DISABLE);
-	else
+	else /* we don't allow manual setting of SD_LBP_ATA_TRIM */
 		return -EINVAL;
 
 	return count;
@@ -653,7 +654,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	 * lead to data corruption. If LBPRZ is not set, we honor the
 	 * device preference.
 	 */
-	if (sdkp->lbprz) {
+	if (sdkp->lbprz || sdkp->device->ata_trim) {
 		q->limits.discard_alignment = 0;
 		q->limits.discard_granularity = logical_block_size;
 	} else {
@@ -695,6 +696,12 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 					  (u32)SD_MAX_WS10_BLOCKS);
 		q->limits.discard_zeroes_data = 1;
 		break;
+
+	case SD_LBP_ATA_TRIM:
+		max_blocks = 65535 * (512 / sizeof(__le64));
+		if (sdkp->device->ata_trim_zeroes_data)
+			q->limits.discard_zeroes_data = 1;
+		break;
 	}
 
 	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9));
@@ -794,6 +801,49 @@ static int sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd, bool unmap)
 	return scsi_init_io(cmd);
 }
 
+static int sd_setup_ata_trim_cmnd(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdp = cmd->device;
+	struct request *rq = cmd->request;
+	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 data_len = sdp->sector_size, i;
+	__le64 *buf;
+
+	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!rq->special_vec.bv_page)
+		return BLKPREP_DEFER;
+	rq->special_vec.bv_offset = 0;
+	rq->special_vec.bv_len = data_len;
+	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
+
+	/*
+	 * Use the Linux Vendor Specific TRIM command to pass the TRIM payload
+	 * to libata.
+	 */
+	cmd->cmd_len = 10;
+	cmd->cmnd[0] = LINUX_VS_TRIM;
+	cmd->cmnd[8] = data_len;
+
+	buf = page_address(rq->special_vec.bv_page);
+	for (i = 0; i < (data_len >> 3); i++) {
+		u64 n = min(nr_sectors, 0xffffu);
+
+		buf[i] = cpu_to_le64(sector | (n << 48));
+		if (nr_sectors <= 0xffff)
+			break;
+		sector += 0xffff;
+		nr_sectors -= 0xffff;
+	}
+
+	cmd->allowed = SD_MAX_RETRIES;
+	cmd->transfersize = data_len;
+	rq->timeout = SD_TIMEOUT;
+	scsi_req(rq)->resid_len = data_len;
+
+	return scsi_init_io(cmd);
+}
+
 static void sd_config_write_same(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
@@ -1168,6 +1218,8 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 			return sd_setup_write_same10_cmnd(cmd, true);
 		case SD_LBP_ZERO:
 			return sd_setup_write_same10_cmnd(cmd, false);
+		case SD_LBP_ATA_TRIM:
+			return sd_setup_ata_trim_cmnd(cmd);
 		default:
 			return BLKPREP_INVALID;
 		}
@@ -2739,7 +2791,9 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	sdkp->max_xfer_blocks = get_unaligned_be32(&buffer[8]);
 	sdkp->opt_xfer_blocks = get_unaligned_be32(&buffer[12]);
 
-	if (buffer[3] == 0x3c) {
+	if (sdkp->device->ata_trim) {
+		sd_config_discard(sdkp, SD_LBP_ATA_TRIM);
+	} else if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
 
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4dac35e96a75..711d48cea5d7 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -56,6 +56,7 @@ enum {
 	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
 	SD_LBP_WS10,		/* Use WRITE SAME(10) with UNMAP bit */
 	SD_LBP_ZERO,		/* Use WRITE SAME(10) with zero payload */
+	SD_LBP_ATA_TRIM,	/* generate a ATA TRIM payload for libata */
 	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
 };
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 080c7ce9bae8..7b1450b1b130 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -182,6 +182,8 @@ struct scsi_device {
 	unsigned broken_fua:1;		/* Don't set FUA bit */
 	unsigned lun_in_cdb:1;		/* Store LUN bits in CDB[1] */
 	unsigned synchronous_alua:1;	/* Synchronous ALUA commands */
+	unsigned ata_trim:1;		/* use ATA TRIM payload for discard */
+	unsigned ata_trim_zeroes_data:1;/* ATA TRIM zeroes discard blocks */
 
 	atomic_t disk_events_disable_depth; /* disable depth for disk events */
 
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 6ba66e01f6df..033b5662a5f5 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -169,6 +169,9 @@
 /* Vendor specific CDBs start here */
 #define VENDOR_SPECIFIC_CDB 0xc0
 
+/* used to pass the TRIM payload to libata with rewriting it: */
+#define LINUX_VS_TRIM		VENDOR_SPECIFIC_CDB
+
 /*
  *	SCSI command lengths
  */
-- 
2.11.0
