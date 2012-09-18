From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 8/8] sd: Implement support for WRITE SAME
Date: Tue, 18 Sep 2012 12:19:32 -0400
Message-ID: <1347985172-2495-9-git-send-email-martin.petersen@oracle.com>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:24550 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2IRQUF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2012 12:20:05 -0400
In-Reply-To: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, shli@kernel.org, snitzer@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Implement support for WRITE SAME(10) and WRITE SAME(16) in the SCSI disk
driver.

 - We set the default maximum to 0xFFFF because there are several
   devices out there that only support two-byte block counts even with
   WRITE SAME(16). We only enable transfers bigger than 0xFFFF if the
   device explicitly reports MAXIMUM WRITE SAME LENGTH in the BLOCK
   LIMITS VPD.

 - max_write_same_blocks can be overriden per-device basis in sysfs.

 - The UNMAP discovery heuristics remain unchanged but the discard
   limits are tweaked to match the "real" WRITE SAME commands.

 - In the error handling logic we now distinguish between WRITE SAME
   with and without UNMAP set.


The discovery process heuristics are:

 - If the device reports a SCSI level of SPC-3 or greater we'll issue
   READ SUPPORTED OPERATION CODES to find out whether WRITE SAME(16) is
   supported. If that's the case we will use it.

 - If the device supports the block limits VPD and reports a MAXIMUM
   WRITE SAME LENGTH bigger than 0xFFFF we will use WRITE SAME(16).

 - Otherwise we will use WRITE SAME(10) unless the target LBA is beyond
   0xFFFFFFFF or the block count exceeds 0xFFFF.

 - no_write_same is set for ATA, FireWire and USB.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/libata-scsi.c      |    1 +
 drivers/firewire/sbp2.c        |    1 +
 drivers/scsi/scsi_lib.c        |   22 ++++-
 drivers/scsi/sd.c              |  172 +++++++++++++++++++++++++++++++++++++---
 drivers/scsi/sd.h              |    7 ++
 drivers/usb/storage/scsiglue.c |    3 +
 include/scsi/scsi_device.h     |    1 +
 7 files changed, 191 insertions(+), 16 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 86d43b2..002f1b7 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1053,6 +1053,7 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
 	sdev->no_report_opcodes = 1;
+	sdev->no_write_same = 1;
 
 	/* Schedule policy is determined by ->qc_defer() callback and
 	 * it needs to see every deferred qc.  Set dev_blocked to 1 to
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index f82e9d4..bb1b392 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1547,6 +1547,7 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 
 	sdev->use_10_for_rw = 1;
 	sdev->no_report_opcodes = 1;
+	sdev->no_write_same = 1;
 
 	if (sbp2_param_exclusive_login)
 		sdev->manage_start_stop = 1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..874d41b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -897,11 +897,23 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				action = ACTION_FAIL;
 				error = -EILSEQ;
 			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
-			} else if ((sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-				   (cmd->cmnd[0] == UNMAP ||
-				    cmd->cmnd[0] == WRITE_SAME_16 ||
-				    cmd->cmnd[0] == WRITE_SAME)) {
-				description = "Discard failure";
+			} else if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
+				switch (cmd->cmnd[0]) {
+				case UNMAP:
+					description = "Discard failure";
+					break;
+				case WRITE_SAME:
+				case WRITE_SAME_16:
+					if (cmd->cmnd[1] & 0x8)
+						description = "Discard failure";
+					else
+						description =
+							"Write same failure";
+					break;
+				default:
+					description = "Invalid command failure";
+					break;
+				}
 				action = ACTION_FAIL;
 				error = -EREMOTEIO;
 			} else
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e100b5c..1cf2d5d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -99,6 +99,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 #endif
 
 static void sd_config_discard(struct scsi_disk *, unsigned int);
+static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
@@ -373,6 +374,45 @@ sd_store_max_medium_access_timeouts(struct device *dev,
 	return err ? err : count;
 }
 
+static ssize_t
+sd_show_write_same_blocks(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->max_ws_blocks);
+}
+
+static ssize_t
+sd_store_write_same_blocks(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+	unsigned long max;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (sdp->type != TYPE_DISK)
+		return -EINVAL;
+
+	err = kstrtoul(buf, 10, &max);
+
+	if (err)
+		return err;
+
+	if (max == 0)
+		sdp->no_write_same = 1;
+	else if (max <= SD_MAX_WS16_BLOCKS)
+		sdkp->max_ws_blocks = max;
+
+	sd_config_write_same(sdkp);
+
+	return count;
+}
+
 static struct device_attribute sd_disk_attrs[] = {
 	__ATTR(cache_type, S_IRUGO|S_IWUSR, sd_show_cache_type,
 	       sd_store_cache_type),
@@ -387,6 +427,8 @@ static struct device_attribute sd_disk_attrs[] = {
 	__ATTR(thin_provisioning, S_IRUGO, sd_show_thin_provisioning, NULL),
 	__ATTR(provisioning_mode, S_IRUGO|S_IWUSR, sd_show_provisioning_mode,
 	       sd_store_provisioning_mode),
+	__ATTR(max_write_same_blocks, S_IRUGO|S_IWUSR,
+	       sd_show_write_same_blocks, sd_store_write_same_blocks),
 	__ATTR(max_medium_access_timeouts, S_IRUGO|S_IWUSR,
 	       sd_show_max_medium_access_timeouts,
 	       sd_store_max_medium_access_timeouts),
@@ -538,19 +580,23 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		return;
 
 	case SD_LBP_UNMAP:
-		max_blocks = min_not_zero(sdkp->max_unmap_blocks, 0xffffffff);
+		max_blocks = min_not_zero(sdkp->max_unmap_blocks,
+					  (u32)SD_MAX_WS16_BLOCKS);
 		break;
 
 	case SD_LBP_WS16:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks, 0xffffffff);
+		max_blocks = min_not_zero(sdkp->max_ws_blocks,
+					  (u32)SD_MAX_WS16_BLOCKS);
 		break;
 
 	case SD_LBP_WS10:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks, (u32)0xffff);
+		max_blocks = min_not_zero(sdkp->max_ws_blocks,
+					  (u32)SD_MAX_WS10_BLOCKS);
 		break;
 
 	case SD_LBP_ZERO:
-		max_blocks = min_not_zero(sdkp->max_ws_blocks, (u32)0xffff);
+		max_blocks = min_not_zero(sdkp->max_ws_blocks,
+					  (u32)SD_MAX_WS10_BLOCKS);
 		q->limits.discard_zeroes_data = 1;
 		break;
 	}
@@ -644,6 +690,83 @@ out:
 	return ret;
 }
 
+static void sd_config_write_same(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned int logical_block_size = sdkp->device->sector_size;
+	unsigned int blocks = 0;
+
+	if (sdkp->device->no_write_same) {
+		sdkp->max_ws_blocks = 0;
+		goto out;
+	}
+
+	/* Some devices can not handle block counts above 0xffff despite
+	 * supporting WRITE SAME(16). Consequently we default to 64k
+	 * blocks per I/O unless the device explicitly advertises a
+	 * bigger limit.
+	 */
+	if (sdkp->max_ws_blocks == 0)
+		sdkp->max_ws_blocks = SD_MAX_WS10_BLOCKS;
+
+	if (sdkp->ws16 || sdkp->max_ws_blocks > SD_MAX_WS10_BLOCKS)
+		blocks = min_not_zero(sdkp->max_ws_blocks,
+				      (u32)SD_MAX_WS16_BLOCKS);
+	else
+		blocks = min_not_zero(sdkp->max_ws_blocks,
+				      (u32)SD_MAX_WS10_BLOCKS);
+
+out:
+	blk_queue_max_write_same_sectors(q, blocks * (logical_block_size >> 9));
+}
+
+/**
+ * sd_setup_write_same_cmnd - write the same data to multiple blocks
+ * @sdp: scsi device to operate one
+ * @rq: Request to prepare
+ *
+ * Will issue either WRITE SAME(10) or WRITE SAME(16) depending on
+ * preference indicated by target device.
+ **/
+static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
+{
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct bio *bio = rq->bio;
+	sector_t sector = blk_rq_pos(rq);
+	unsigned int nr_sectors = blk_rq_sectors(rq);
+	unsigned int nr_bytes = blk_rq_bytes(rq);
+	int ret;
+
+	if (sdkp->device->no_write_same)
+		return BLKPREP_KILL;
+
+	BUG_ON(bio_offset(bio) || bio_iovec(bio)->bv_len != sdp->sector_size);
+
+	sector >>= ilog2(sdp->sector_size) - 9;
+	nr_sectors >>= ilog2(sdp->sector_size) - 9;
+
+	rq->__data_len = sdp->sector_size;
+	rq->timeout = SD_WRITE_SAME_TIMEOUT;
+	memset(rq->cmd, 0, rq->cmd_len);
+
+	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff) {
+		rq->cmd_len = 16;
+		rq->cmd[0] = WRITE_SAME_16;
+		put_unaligned_be64(sector, &rq->cmd[2]);
+		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
+	} else {
+		rq->cmd_len = 10;
+		rq->cmd[0] = WRITE_SAME;
+		put_unaligned_be32(sector, &rq->cmd[2]);
+		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
+	}
+
+	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+	rq->__data_len = nr_bytes;
+
+	return ret;
+}
+
 static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	rq->timeout = SD_FLUSH_TIMEOUT;
@@ -689,6 +812,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	if (rq->cmd_flags & REQ_DISCARD) {
 		ret = sd_setup_discard_cmnd(sdp, rq);
 		goto out;
+	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
+		ret = sd_setup_write_same_cmnd(sdp, rq);
+		goto out;
 	} else if (rq->cmd_flags & REQ_FLUSH) {
 		ret = scsi_setup_flush_cmnd(sdp, rq);
 		goto out;
@@ -1462,8 +1588,9 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int sense_valid = 0;
 	int sense_deferred = 0;
 	unsigned char op = SCpnt->cmnd[0];
+	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
-	if (req->cmd_flags & REQ_DISCARD) {
+	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
@@ -1520,9 +1647,25 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		if (sshdr.asc == 0x10)  /* DIX: Host detected corruption */
 			good_bytes = sd_completed_bytes(SCpnt);
 		/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
-		if ((sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
-		    (op == UNMAP || op == WRITE_SAME_16 || op == WRITE_SAME))
-			sd_config_discard(sdkp, SD_LBP_DISABLE);
+		if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
+			switch (op) {
+			case UNMAP:
+				sd_config_discard(sdkp, SD_LBP_DISABLE);
+				break;
+			case WRITE_SAME_16:
+			case WRITE_SAME:
+				if (unmap)
+					sd_config_discard(sdkp, SD_LBP_DISABLE);
+				else {
+					sdkp->device->no_write_same = 1;
+					sd_config_write_same(sdkp);
+
+					good_bytes = 0;
+					req->__data_len = blk_rq_bytes(req);
+					req->cmd_flags |= REQ_QUIET;
+				}
+			}
+		}
 		break;
 	default:
 		break;
@@ -2347,9 +2490,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
 
-		sdkp->max_ws_blocks =
-			(u32) min_not_zero(get_unaligned_be64(&buffer[36]),
-					   (u64)0xffffffff);
+		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
 
 		if (!sdkp->lbpme)
 			goto out;
@@ -2442,6 +2583,13 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 	kfree(buffer);
 }
 
+static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
+{
+	if (scsi_report_opcode(sdkp->device, buffer, SD_BUF_SIZE,
+			       WRITE_SAME_16))
+		sdkp->ws16 = 1;
+}
+
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
 {
 	/*
@@ -2501,6 +2649,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
+		sd_read_write_same(sdkp, buffer);
 	}
 
 	sdkp->first_scan = 0;
@@ -2518,6 +2667,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	blk_queue_flush(sdkp->disk->queue, flush);
 
 	set_capacity(disk, sdkp->capacity);
+	sd_config_write_same(sdkp);
 	kfree(buffer);
 
  out:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f703f48..cfcf8fd 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -14,6 +14,7 @@
 #define SD_TIMEOUT		(30 * HZ)
 #define SD_MOD_TIMEOUT		(75 * HZ)
 #define SD_FLUSH_TIMEOUT	(60 * HZ)
+#define SD_WRITE_SAME_TIMEOUT	(120 * HZ)
 
 /*
  * Number of allowed retries
@@ -39,6 +40,11 @@ enum {
 };
 
 enum {
+	SD_MAX_WS10_BLOCKS = 0xffff,
+	SD_MAX_WS16_BLOCKS = 0x7fffff,
+};
+
+enum {
 	SD_LBP_FULL = 0,	/* Full logical block provisioning */
 	SD_LBP_UNMAP,		/* Use UNMAP command */
 	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
@@ -77,6 +83,7 @@ struct scsi_disk {
 	unsigned	lbpws : 1;
 	unsigned	lbpws10 : 1;
 	unsigned	lbpvpd : 1;
+	unsigned	ws16 : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 6ab376a..92f35ab 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -189,6 +189,9 @@ static int slave_configure(struct scsi_device *sdev)
 		/* Do not attempt to use REPORT SUPPORTED OPERATION CODES */
 		sdev->no_report_opcodes = 1;
 
+		/* Do not attempt to use WRITE SAME */
+		sdev->no_write_same = 1;
+
 		/* Some disks return the total number of blocks in response
 		 * to READ CAPACITY rather than the highest block number.
 		 * If this device makes that mistake, tell the sd driver. */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 7d0b4f6..3d6e315 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -136,6 +136,7 @@ struct scsi_device {
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
+	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
-- 
1.7.7.6

