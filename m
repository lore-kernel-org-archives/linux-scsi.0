From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.7-rc6
Date: Thu, 22 Nov 2012 09:27:39 +0000
Message-ID: <1353576459.2449.5.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is a set of four bug fixes.  The isci one is an obvious thinko
(using request buffer instead of response buffer) which causes a command
to fail.  The three others are DIF/DIX updates which are required
because they're part of a series of ten patches, the other seven of
which went into the block layer during the merge window meaning our
current DIF/DIX implementation is broken without these three.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Maciej Patelczyk (1):
      isci: copy fis 0x34 response into proper buffer

Martin K. Petersen (3):
      sd: Implement support for WRITE SAME
      sd: Permit merged discard requests
      Add a report opcode helper

The diffstat is:

 drivers/ata/libata-scsi.c      |   2 +
 drivers/firewire/sbp2.c        |   2 +
 drivers/scsi/isci/request.c    |   2 +-
 drivers/scsi/scsi.c            |  45 +++++++++
 drivers/scsi/scsi_lib.c        |  22 ++++-
 drivers/scsi/sd.c              | 202 ++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/sd.h              |   7 ++
 drivers/usb/storage/scsiglue.c |   6 ++
 include/scsi/scsi_device.h     |   4 +
 9 files changed, 263 insertions(+), 29 deletions(-)

And the full diff attached below.

James

---
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e3bda07..a6df6a3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1052,6 +1052,8 @@ static void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
 	sdev->use_10_for_ms = 1;
+	sdev->no_report_opcodes = 1;
+	sdev->no_write_same = 1;
 
 	/* Schedule policy is determined by ->qc_defer() callback and
 	 * it needs to see every deferred qc.  Set dev_blocked to 1 to
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 1162d6b..bb1b392 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1546,6 +1546,8 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
 	sdev->use_10_for_rw = 1;
+	sdev->no_report_opcodes = 1;
+	sdev->no_write_same = 1;
 
 	if (sbp2_param_exclusive_login)
 		sdev->manage_start_stop = 1;
diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index c1bafc3..9594ab6 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -1972,7 +1972,7 @@ sci_io_request_frame_handler(struct isci_request *ireq,
 								      frame_index,
 								      (void **)&frame_buffer);
 
-			sci_controller_copy_sata_response(&ireq->stp.req,
+			sci_controller_copy_sata_response(&ireq->stp.rsp,
 							       frame_header,
 							       frame_buffer);
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2936b44..2c0d0ec 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -55,6 +55,7 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/async.h>
+#include <asm/unaligned.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1062,6 +1063,50 @@ int scsi_get_vpd_page(struct scsi_device *sdev, u8 page, unsigned char *buf,
 EXPORT_SYMBOL_GPL(scsi_get_vpd_page);
 
 /**
+ * scsi_report_opcode - Find out if a given command opcode is supported
+ * @sdev:	scsi device to query
+ * @buffer:	scratch buffer (must be at least 20 bytes long)
+ * @len:	length of buffer
+ * @opcode:	opcode for command to look up
+ *
+ * Uses the REPORT SUPPORTED OPERATION CODES to look up the given
+ * opcode. Returns 0 if RSOC fails or if the command opcode is
+ * unsupported. Returns 1 if the device claims to support the command.
+ */
+int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
+		       unsigned int len, unsigned char opcode)
+{
+	unsigned char cmd[16];
+	struct scsi_sense_hdr sshdr;
+	int result;
+
+	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
+		return 0;
+
+	memset(cmd, 0, 16);
+	cmd[0] = MAINTENANCE_IN;
+	cmd[1] = MI_REPORT_SUPPORTED_OPERATION_CODES;
+	cmd[2] = 1;		/* One command format */
+	cmd[3] = opcode;
+	put_unaligned_be32(len, &cmd[6]);
+	memset(buffer, 0, len);
+
+	result = scsi_execute_req(sdev, cmd, DMA_FROM_DEVICE, buffer, len,
+				  &sshdr, 30 * HZ, 3, NULL);
+
+	if (result && scsi_sense_valid(&sshdr) &&
+	    sshdr.sense_key == ILLEGAL_REQUEST &&
+	    (sshdr.asc == 0x20 || sshdr.asc == 0x24) && sshdr.ascq == 0x00)
+		return 0;
+
+	if ((buffer[1] & 3) == 3) /* Command supported */
+		return 1;
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_report_opcode);
+
+/**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
  *
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index da36a3a..9032e91 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -900,11 +900,23 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
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
index 12f6fdf..352bc77 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -99,6 +99,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 #endif
 
 static void sd_config_discard(struct scsi_disk *, unsigned int);
+static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
@@ -395,6 +396,45 @@ sd_store_max_medium_access_timeouts(struct device *dev,
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
@@ -410,6 +450,8 @@ static struct device_attribute sd_disk_attrs[] = {
 	__ATTR(thin_provisioning, S_IRUGO, sd_show_thin_provisioning, NULL),
 	__ATTR(provisioning_mode, S_IRUGO|S_IWUSR, sd_show_provisioning_mode,
 	       sd_store_provisioning_mode),
+	__ATTR(max_write_same_blocks, S_IRUGO|S_IWUSR,
+	       sd_show_write_same_blocks, sd_store_write_same_blocks),
 	__ATTR(max_medium_access_timeouts, S_IRUGO|S_IWUSR,
 	       sd_show_max_medium_access_timeouts,
 	       sd_store_max_medium_access_timeouts),
@@ -561,19 +603,23 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
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
@@ -583,29 +629,26 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 }
 
 /**
- * scsi_setup_discard_cmnd - unmap blocks on thinly provisioned device
+ * sd_setup_discard_cmnd - unmap blocks on thinly provisioned device
  * @sdp: scsi device to operate one
  * @rq: Request to prepare
  *
  * Will issue either UNMAP or WRITE SAME(16) depending on preference
  * indicated by target device.
  **/
-static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
+static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	struct bio *bio = rq->bio;
-	sector_t sector = bio->bi_sector;
-	unsigned int nr_sectors = bio_sectors(bio);
+	sector_t sector = blk_rq_pos(rq);
+	unsigned int nr_sectors = blk_rq_sectors(rq);
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	unsigned int len;
 	int ret;
 	char *buf;
 	struct page *page;
 
-	if (sdkp->device->sector_size == 4096) {
-		sector >>= 3;
-		nr_sectors >>= 3;
-	}
-
+	sector >>= ilog2(sdp->sector_size) - 9;
+	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 	rq->timeout = SD_TIMEOUT;
 
 	memset(rq->cmd, 0, rq->cmd_len);
@@ -660,6 +703,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	blk_add_request_payload(rq, page, len);
 	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 	rq->buffer = page_address(page);
+	rq->__data_len = nr_bytes;
 
 out:
 	if (ret != BLKPREP_OK) {
@@ -669,6 +713,83 @@ out:
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
@@ -712,7 +833,10 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * block PC requests to make life easier.
 	 */
 	if (rq->cmd_flags & REQ_DISCARD) {
-		ret = scsi_setup_discard_cmnd(sdp, rq);
+		ret = sd_setup_discard_cmnd(sdp, rq);
+		goto out;
+	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
+		ret = sd_setup_write_same_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_flags & REQ_FLUSH) {
 		ret = scsi_setup_flush_cmnd(sdp, rq);
@@ -1482,12 +1606,21 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
 	struct scsi_sense_hdr sshdr;
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
+	struct request *req = SCpnt->request;
 	int sense_valid = 0;
 	int sense_deferred = 0;
 	unsigned char op = SCpnt->cmnd[0];
+	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
-	if ((SCpnt->request->cmd_flags & REQ_DISCARD) && !result)
-		scsi_set_resid(SCpnt, 0);
+	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
+		if (!result) {
+			good_bytes = blk_rq_bytes(req);
+			scsi_set_resid(SCpnt, 0);
+		} else {
+			good_bytes = 0;
+			scsi_set_resid(SCpnt, blk_rq_bytes(req));
+		}
+	}
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
@@ -1536,9 +1669,25 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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
@@ -2374,9 +2523,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
 
-		sdkp->max_ws_blocks =
-			(u32) min_not_zero(get_unaligned_be64(&buffer[36]),
-					   (u64)0xffffffff);
+		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
 
 		if (!sdkp->lbpme)
 			goto out;
@@ -2469,6 +2616,13 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
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
@@ -2528,6 +2682,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
+		sd_read_write_same(sdkp, buffer);
 	}
 
 	sdkp->first_scan = 0;
@@ -2545,6 +2700,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	blk_queue_flush(sdkp->disk->queue, flush);
 
 	set_capacity(disk, sdkp->capacity);
+	sd_config_write_same(sdkp);
 	kfree(buffer);
 
  out:
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 47c52a6..74a1e4c 100644
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
index a3d5436..92f35ab 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -186,6 +186,12 @@ static int slave_configure(struct scsi_device *sdev)
 		/* Some devices don't handle VPD pages correctly */
 		sdev->skip_vpd_pages = 1;
 
+		/* Do not attempt to use REPORT SUPPORTED OPERATION CODES */
+		sdev->no_report_opcodes = 1;
+
+		/* Do not attempt to use WRITE SAME */
+		sdev->no_write_same = 1;
+
 		/* Some disks return the total number of blocks in response
 		 * to READ CAPACITY rather than the highest block number.
 		 * If this device makes that mistake, tell the sd driver. */
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 88fae8d..55367b0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -135,6 +135,8 @@ struct scsi_device {
 				     * because we did a bus reset. */
 	unsigned use_10_for_rw:1; /* first try 10-byte read / write */
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
+	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
+	unsigned no_write_same:1;	/* no WRITE SAME command */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
 	unsigned skip_vpd_pages:1;	/* do not read VPD pages */
@@ -362,6 +364,8 @@ extern int scsi_test_unit_ready(struct scsi_device *sdev, int timeout,
 				int retries, struct scsi_sense_hdr *sshdr);
 extern int scsi_get_vpd_page(struct scsi_device *, u8 page, unsigned char *buf,
 			     int buf_len);
+extern int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
+			      unsigned int len, unsigned char opcode);
 extern int scsi_device_set_state(struct scsi_device *sdev,
 				 enum scsi_device_state state);
 extern struct scsi_event *sdev_evt_alloc(enum scsi_device_event evt_type,
