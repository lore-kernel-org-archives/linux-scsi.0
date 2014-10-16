From: michaelc@cs.wisc.edu
Subject: [PATCH 3/5] scsi: add support for COMPARE_AND_WRITE
Date: Thu, 16 Oct 2014 00:37:13 -0500
Message-ID: <1413437835-13778-4-git-send-email-michaelc@cs.wisc.edu>
References: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39637 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaJPFha (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2014 01:37:30 -0400
In-Reply-To: <1413437835-13778-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, ceph-devel@vger.kernel.org, axboe@kernel.dk

From: Mike Christie <michaelc@cs.wisc.edu>

This patch adds support to detect if a device supports COMPARE_AND_WRITE
and execute REQ_COMPARE_AND_WRITE commands.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_lib.c |    7 +++++
 drivers/scsi/sd.c       |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.h       |    1 +
 3 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d837dc1..9e7ba4f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1021,6 +1021,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			/* See SSC3rXX or current. */
 			action = ACTION_FAIL;
 			break;
+		case MISCOMPARE:
+			/* miscompare during verify */
+			if (sshdr.asc == 0x1d)
+				/* TODO: better error code to use ??? */
+				error = -ECANCELED;
+			action = ACTION_FAIL;
+			break;
 		default:
 			action = ACTION_FAIL;
 			break;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2c2041c..d1fa4ef 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -477,6 +477,16 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(max_write_same_blocks);
 
+static ssize_t
+max_cmp_and_write_blocks_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->max_cmp_and_write_blocks);
+}
+static DEVICE_ATTR_RO(max_cmp_and_write_blocks);
+
 static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_cache_type.attr,
 	&dev_attr_FUA.attr,
@@ -488,6 +498,7 @@ static struct attribute *sd_disk_attrs[] = {
 	&dev_attr_thin_provisioning.attr,
 	&dev_attr_provisioning_mode.attr,
 	&dev_attr_max_write_same_blocks.attr,
+	&dev_attr_max_cmp_and_write_blocks.attr,
 	&dev_attr_max_medium_access_timeouts.attr,
 	NULL,
 };
@@ -635,6 +646,54 @@ static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
 	scsi_set_prot_type(scmd, dif);
 }
 
+static void sd_config_cmp_and_write(struct scsi_disk *sdkp)
+{
+	if (sdkp->max_cmp_and_write_blocks > sdkp->max_xfer_blocks) {
+		/* Invalid settings returned. Do not try to support for now */
+		blk_queue_max_cmp_and_write_sectors(sdkp->disk->queue, 0);
+		return;
+	}
+
+	/*
+	 * mult by 2, because the block layer wants the total number of
+	 * sectors that will be put in bios and transferred.
+	 */
+	blk_queue_max_cmp_and_write_sectors(sdkp->disk->queue,
+					2 * sdkp->max_cmp_and_write_blocks *
+					(sdkp->device->sector_size  >> 9));
+}
+
+/**
+ * sd_setup_cmp_and_write_cmnd - compare and write data
+ * @cmd: scsi_cmnd to prepare
+ **/
+static int sd_setup_cmd_and_write_cmd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_device *sdp = cmd->device;
+	sector_t sector = blk_rq_pos(rq);
+	unsigned int nr_sectors = blk_rq_sectors(rq);
+
+	sector >>= ilog2(sdp->sector_size) - 9;
+	nr_sectors >>= ilog2(sdp->sector_size) - 9;
+
+	cmd->cmnd[0] = COMPARE_AND_WRITE;
+	put_unaligned_be64(sector, &cmd->cmnd[2]);
+	/*
+	 * rq/bio contains total data to transfer, but the nr LBAs field
+	 * is only the data to be compared/written in each step of the
+	 * operation.
+	 */
+	cmd->cmnd[13] = nr_sectors >> 1;
+	/* TODO - wrprotect and FUA and DPO flags */
+
+	cmd->transfersize = sdp->sector_size;
+	cmd->allowed = SD_MAX_RETRIES;
+	rq->timeout = SD_TIMEOUT;
+
+	return scsi_init_io(cmd, GFP_ATOMIC);
+}
+
 static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 {
 	struct request_queue *q = sdkp->disk->queue;
@@ -1134,6 +1193,8 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 		return sd_setup_write_same_cmnd(cmd);
 	else if (rq->cmd_flags & REQ_FLUSH)
 		return sd_setup_flush_cmnd(cmd);
+	else if (rq->cmd_flags & REQ_CMP_AND_WRITE)
+		return sd_setup_cmd_and_write_cmd(cmd);
 	else
 		return sd_setup_read_write_cmnd(cmd);
 }
@@ -2596,6 +2657,8 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
 	blk_queue_io_opt(sdkp->disk->queue,
 			 get_unaligned_be32(&buffer[12]) * sector_sz);
+	sdkp->max_cmp_and_write_blocks = buffer[5];
+	sd_config_cmp_and_write(sdkp);
 
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4c3ab83..fe04ac8 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -68,6 +68,7 @@ struct scsi_disk {
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u32		max_xfer_blocks;
 	u32		max_ws_blocks;
+	u32		max_cmp_and_write_blocks;
 	u32		max_unmap_blocks;
 	u32		unmap_granularity;
 	u32		unmap_alignment;
-- 
1.7.1

