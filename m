From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6/6] [SCSI] sd: Implement copy offload support
Date: Wed, 28 May 2014 23:52:45 -0400
Message-ID: <1401335565-29865-7-git-send-email-martin.petersen@oracle.com>
References: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38862 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983AbaE2Dwx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:52:53 -0400
In-Reply-To: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Implement support for hardware copy offload. This initial implementation
only supports EXTENDED COPY(LID1). If need be we can add support for
LID4 or token copy at a later date.

If a device has the 3PC flag set in the standard INQUIRY response we'll
issue a RECEIVE COPY OPERATION PARAMETERS command. We require the device
to support two copy source/copy destination descriptors and one block to
block (0x02) segment descriptor. The device must support the NAA
identification descriptor (0xE4). If the device is capable we'll set the
queue limits to indicate that the device supports copy offload.

The copy block range limit can be overridden in scsi_disk's
max_copy_block sysfs attribute.

sd_setup_copy_command() is used to prepare any REQ_COPY requests. The
relevant descriptors are placed in a payload page akin to REQ_DISCARD.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c          | 254 ++++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h          |   4 +
 include/scsi/scsi_device.h |   1 +
 3 files changed, 257 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 96af195224f2..071225f34d63 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -100,6 +100,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 
 static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
+static void sd_config_copy(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
@@ -461,6 +462,48 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(max_write_same_blocks);
 
+static ssize_t
+max_copy_blocks_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->max_copy_blocks);
+}
+
+static ssize_t
+max_copy_blocks_store(struct device *dev, struct device_attribute *attr,
+		      const char *buf, size_t count)
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
+		sdp->no_copy = 1;
+	else if (max <= SD_MAX_COPY_BLOCKS) {
+		sdp->no_copy = 0;
+		sdkp->max_copy_blocks = max;
+	}
+
+	sd_config_copy(sdkp);
+
+	return count;
+}
+static DEVICE_ATTR_RW(max_copy_blocks);
+
 static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_cache_type.attr,
 	&dev_attr_FUA.attr,
@@ -472,6 +515,7 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_thin_provisioning.attr,
 	&dev_attr_provisioning_mode.attr,
 	&dev_attr_max_write_same_blocks.attr,
+	&dev_attr_max_copy_blocks.attr,
 	&dev_attr_max_medium_access_timeouts.attr,
 	NULL,
 };
@@ -826,6 +870,100 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 	return ret;
 }
 
+static void sd_config_copy(struct scsi_disk *sdkp)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned int logical_block_size = sdkp->device->sector_size;
+
+	if (sdkp->device->no_copy)
+		sdkp->max_copy_blocks = 0;
+
+	/* Segment descriptor 0x02 has a 64k block limit */
+	sdkp->max_copy_blocks = min(sdkp->max_copy_blocks,
+				    (u32)SD_MAX_CSD2_BLOCKS);
+
+	blk_queue_max_copy_sectors(q, sdkp->max_copy_blocks *
+				   (logical_block_size >> 9));
+}
+
+static int sd_setup_copy_cmnd(struct scsi_device *sdp, struct request *rq)
+{
+	struct scsi_device *src_sdp, *dst_sdp;
+	sector_t src_lba, dst_lba;
+	unsigned int nr_blocks, buf_len, nr_bytes = blk_rq_bytes(rq);
+	int ret;
+	struct bio *bio = rq->bio;
+	struct bio_copy *bic = bio_copy(bio);
+	struct page *page;
+	unsigned char *buf;
+
+	if (!bic)
+		return BLKPREP_KILL;
+
+	dst_sdp = scsi_disk(rq->rq_disk)->device;
+	src_sdp = scsi_disk(bic->bic_bdev->bd_disk)->device;
+
+	if (src_sdp->no_copy || dst_sdp->no_copy)
+		return BLKPREP_KILL;
+
+	if (src_sdp->sector_size != dst_sdp->sector_size)
+		return BLKPREP_KILL;
+
+	dst_lba = blk_rq_pos(rq) >> (ilog2(dst_sdp->sector_size) - 9);
+	src_lba = bic->bic_sector >> (ilog2(src_sdp->sector_size) - 9);
+	nr_blocks = blk_rq_sectors(rq) >> (ilog2(dst_sdp->sector_size) - 9);
+
+	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!page)
+		return BLKPREP_DEFER;
+
+	buf = page_address(page);
+
+	/* Extended Copy (LID1) Parameter List (16 bytes) */
+	buf[0] = 0;				/* LID */
+	buf[1] = 3 << 3;			/* LID usage 11b */
+	put_unaligned_be16(32 + 32, &buf[2]);	/* 32 bytes per E4 desc. */
+	put_unaligned_be32(28, &buf[8]);	/* 28 bytes per B2B desc. */
+	buf += 16;
+
+	/* Source CSCD (32 bytes) */
+	buf[0] = 0xe4;				/* Identification desc. */
+	memcpy(&buf[4], src_sdp->naa, src_sdp->naa_len);
+	buf += 32;
+
+	/* Destination CSCD (32 bytes) */
+	buf[0] = 0xe4;				/* Identification desc. */
+	memcpy(&buf[4], dst_sdp->naa, dst_sdp->naa_len);
+	buf += 32;
+
+	/* Segment descriptor (28 bytes) */
+	buf[0] = 0x02;				/* Block to block desc. */
+	put_unaligned_be16(0x18, &buf[2]);	/* Descriptor length */
+	put_unaligned_be16(0, &buf[4]);		/* Source is desc. 0 */
+	put_unaligned_be16(1, &buf[6]);		/* Dest. is desc. 1 */
+	put_unaligned_be16(nr_blocks, &buf[10]);
+	put_unaligned_be64(src_lba, &buf[12]);
+	put_unaligned_be64(dst_lba, &buf[20]);
+
+	/* CDB */
+	memset(rq->cmd, 0, rq->cmd_len);
+	rq->cmd[0] = EXTENDED_COPY;
+	rq->cmd[1] = 0; 			/* LID1 */
+	buf_len = 16 + 32 + 32 + 28;
+	put_unaligned_be32(buf_len, &rq->cmd[10]);
+	rq->timeout = SD_COPY_TIMEOUT;
+
+	rq->completion_data = page;
+	blk_add_request_payload(rq, page, buf_len);
+	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+	rq->__data_len = nr_bytes;
+
+	if (ret != BLKPREP_OK)
+		__free_page(page);
+
+	return ret;
+}
+
 static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
@@ -840,7 +978,7 @@ static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 {
 	struct scsi_cmnd *SCpnt = rq->special;
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->cmd_flags & (REQ_DISCARD | REQ_COPY))
 		__free_page(rq->completion_data);
 
 	if (SCpnt->cmnd != rq->cmd) {
@@ -880,6 +1018,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
 		ret = sd_setup_write_same_cmnd(sdp, rq);
 		goto out;
+	} else if (rq->cmd_flags & REQ_COPY) {
+		ret = sd_setup_copy_cmnd(sdp, rq);
+		goto out;
 	} else if (rq->cmd_flags & REQ_FLUSH) {
 		ret = scsi_setup_flush_cmnd(sdp, rq);
 		goto out;
@@ -1660,7 +1801,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
-	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
+	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME ||
+	    req->cmd_flags & REQ_COPY) {
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
@@ -1719,6 +1861,14 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
 		if (sshdr.asc == 0x20 || sshdr.asc == 0x24) {
 			switch (op) {
+			case EXTENDED_COPY:
+				sdkp->device->no_copy = 1;
+				sd_config_copy(sdkp);
+
+				good_bytes = 0;
+				req->__data_len = blk_rq_bytes(req);
+				req->cmd_flags |= REQ_QUIET;
+				break;
 			case UNMAP:
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 				break;
@@ -2687,6 +2837,105 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->ws10 = 1;
 }
 
+static void sd_read_copy_operations(struct scsi_disk *sdkp,
+				    unsigned char *buffer)
+{
+	struct scsi_device *sdev = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+	unsigned char cdb[16];
+	unsigned int result, len, i;
+	bool b2b_desc = false, id_desc = false;
+
+	if (sdev->naa_len == 0)
+		return;
+
+	/* Verify that the device has 3PC set in INQUIRY response */
+	if (sdev->inquiry_len < 6 || (sdev->inquiry[5] & (1 << 3)) == 0)
+		return;
+
+	/* Receive Copy Operation Parameters */
+	memset(cdb, 0, 16);
+	cdb[0] = RECEIVE_COPY_RESULTS;
+	cdb[1] = 0x3;
+	put_unaligned_be32(SD_BUF_SIZE, &cdb[10]);
+
+	memset(buffer, 0, SD_BUF_SIZE);
+	result = scsi_execute_req(sdev, cdb, DMA_FROM_DEVICE,
+				  buffer, SD_BUF_SIZE, &sshdr,
+				  SD_TIMEOUT, SD_MAX_RETRIES, NULL);
+
+	if (!scsi_status_is_good(result)) {
+		sd_printk(KERN_ERR, sdkp,
+			  "%s: Receive Copy Operating Parameters failed\n",
+			  __func__);
+		return;
+	}
+
+	/* The RCOP response is a minimum of 44 bytes long. First 4
+	 * bytes contain the length of the remaining buffer, i.e. 40+
+	 * bytes. Trailing the defined fields is a list of supported
+	 * descriptors. We need at least 2 descriptors to drive the
+	 * target, hence 42.
+	 */
+	len = get_unaligned_be32(&buffer[0]);
+	if (len < 42) {
+		sd_printk(KERN_ERR, sdkp, "%s: result too short (%u)\n",
+			  __func__, len);
+		return;
+	}
+
+	if ((buffer[4] & 1) == 0) {
+		sd_printk(KERN_ERR, sdkp, "%s: does not support SNLID\n",
+			  __func__);
+		return;
+	}
+
+	if (get_unaligned_be16(&buffer[8]) < 2) {
+		sd_printk(KERN_ERR, sdkp,
+			  "%s: Need 2 or more CSCD descriptors\n", __func__);
+		return;
+	}
+
+	if (get_unaligned_be16(&buffer[10]) < 1) {
+		sd_printk(KERN_ERR, sdkp,
+			  "%s: Need 1 or more segment descriptor\n", __func__);
+		return;
+	}
+
+	if (len - 40 != buffer[43]) {
+		sd_printk(KERN_ERR, sdkp,
+			  "%s: Buffer len and descriptor count mismatch " \
+			  "(%u vs. %u)\n", __func__, len - 40, buffer[43]);
+		return;
+	}
+
+	for (i = 44 ; i < len + 4 ; i++) {
+		if (buffer[i] == 0x02)
+			b2b_desc = true;
+
+		if (buffer[i] == 0xe4)
+			id_desc = true;
+	}
+
+	if (!b2b_desc) {
+		sd_printk(KERN_ERR, sdkp,
+			  "%s: No block 2 block descriptor (0x02)\n",
+			  __func__);
+		return;
+	}
+
+	if (!id_desc) {
+		sd_printk(KERN_ERR, sdkp,
+			  "%s: No identification descriptor (0xE4)\n",
+			  __func__);
+		return;
+	}
+
+	sdkp->max_copy_blocks = get_unaligned_be32(&buffer[16])
+		>> ilog2(sdev->sector_size);
+	sd_config_copy(sdkp);
+}
+
 static int sd_try_extended_inquiry(struct scsi_device *sdp)
 {
 	/*
@@ -2747,6 +2996,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
 		sd_read_write_same(sdkp, buffer);
+		sd_read_copy_operations(sdkp, buffer);
 	}
 
 	sdkp->first_scan = 0;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 620871efbf0a..e7345c552197 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -19,6 +19,7 @@
  */
 #define SD_FLUSH_TIMEOUT_MULTIPLIER	2
 #define SD_WRITE_SAME_TIMEOUT	(120 * HZ)
+#define SD_COPY_TIMEOUT		(120 * HZ)
 
 /*
  * Number of allowed retries
@@ -46,6 +47,8 @@ enum {
 enum {
 	SD_MAX_WS10_BLOCKS = 0xffff,
 	SD_MAX_WS16_BLOCKS = 0x7fffff,
+	SD_MAX_CSD2_BLOCKS = 0xffff,
+	SD_MAX_COPY_BLOCKS = 0x7fffff,
 };
 
 enum {
@@ -66,6 +69,7 @@ struct scsi_disk {
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		max_ws_blocks;
 	u32		max_unmap_blocks;
+	u32		max_copy_blocks;
 	u32		unmap_granularity;
 	u32		unmap_alignment;
 	u32		index;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 67bb70012802..f0a3a3e861e8 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -153,6 +153,7 @@ struct scsi_device {
 	unsigned use_10_for_ms:1; /* first try 10-byte mode sense/select */
 	unsigned no_report_opcodes:1;	/* no REPORT SUPPORTED OPERATION CODES */
 	unsigned no_write_same:1;	/* no WRITE SAME command */
+	unsigned no_copy:1;		/* no copy offload */
 	unsigned use_16_for_rw:1; /* Use read/write(16) over read/write(10) */
 	unsigned skip_ms_page_8:1;	/* do not use MODE SENSE page 0x08 */
 	unsigned skip_ms_page_3f:1;	/* do not use MODE SENSE page 0x3f */
-- 
1.9.0

