From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] sd: Logical Block Provisioning update
Date: Tue, 08 Mar 2011 02:07:15 -0500
Message-ID: <yq1sjuyccpo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23499 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1CHHJC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2011 02:09:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com, Douglas Gilbert <dgilbert@interlog.com>


SBC3r26 contains many changes to the Logical Block Provisioning
interfaces (formerly known as Thin Provisioning ditto). This patch
implements support for both the old and new schemes using the same
heuristic as before (whether the LBP VPD page is present).

The new code also allows the provisioning mode (i.e. choice of command)
to be overridden on a per-device basis via sysfs. Two additional modes
are supported in this version:

 - WRITE SAME(10) with the UNMAP bit set 

 - WRITE SAME(10) without the UNMAP bit set. This allows us to support
   devices that predate the TP/LBP enhancements in SBC3 and which work
   by way zero-detection

Switching between modes has been consolidated in a helper function that
also updates the block layer topology according to the limitations of
the chosen command.

I experimented with trying WRITE SAME(16) if UNMAP fails, WRITE SAME(10)
if WRITE SAME(16) fails, etc. but found several devices that got
cranky. So for now we'll disable discard if one of the commands
fail. The user still has the option of selecting a different mode in
sysfs.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fb2bb35..566473d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -843,6 +843,13 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				description = "Host Data Integrity Failure";
 				action = ACTION_FAIL;
 				error = -EILSEQ;
+			/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
+			} else if ((sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+				   (cmd->cmnd[0] == UNMAP ||
+				    cmd->cmnd[0] == WRITE_SAME_16 ||
+				    cmd->cmnd[0] == WRITE_SAME)) {
+				description = "Discard failure";
+				action = ACTION_FAIL;
 			} else
 				action = ACTION_FAIL;
 			break;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e567302..3be5db5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -96,6 +96,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 #define SD_MINORS	0
 #endif
 
+static void sd_config_discard(struct scsi_disk *, unsigned int);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
 static int  sd_probe(struct device *);
@@ -294,7 +295,54 @@ sd_show_thin_provisioning(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 
-	return snprintf(buf, 20, "%u\n", sdkp->thin_provisioning);
+	return snprintf(buf, 20, "%u\n", sdkp->lbpme);
+}
+
+static const char *lbp_mode[] = {
+	[SD_LBP_FULL]		= "full",
+	[SD_LBP_UNMAP]		= "unmap",
+	[SD_LBP_WS16]		= "writesame_16",
+	[SD_LBP_WS10]		= "writesame_10",
+	[SD_LBP_ZERO]		= "writesame_zero",
+	[SD_LBP_DISABLE]	= "disabled",
+};
+
+static ssize_t
+sd_show_provisioning_mode(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+
+	return snprintf(buf, 20, "%s\n", lbp_mode[sdkp->provisioning_mode]);
+}
+
+static ssize_t
+sd_store_provisioning_mode(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(dev);
+	struct scsi_device *sdp = sdkp->device;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (sdp->type != TYPE_DISK)
+		return -EINVAL;
+
+	if (!strncmp(buf, lbp_mode[SD_LBP_UNMAP], 20))
+		sd_config_discard(sdkp, SD_LBP_UNMAP);
+	else if (!strncmp(buf, lbp_mode[SD_LBP_WS16], 20))
+		sd_config_discard(sdkp, SD_LBP_WS16);
+	else if (!strncmp(buf, lbp_mode[SD_LBP_WS10], 20))
+		sd_config_discard(sdkp, SD_LBP_WS10);
+	else if (!strncmp(buf, lbp_mode[SD_LBP_ZERO], 20))
+		sd_config_discard(sdkp, SD_LBP_ZERO);
+	else if (!strncmp(buf, lbp_mode[SD_LBP_DISABLE], 20))
+		sd_config_discard(sdkp, SD_LBP_DISABLE);
+	else
+		return -EINVAL;
+
+	return count;
 }
 
 static struct device_attribute sd_disk_attrs[] = {
@@ -309,6 +357,8 @@ static struct device_attribute sd_disk_attrs[] = {
 	__ATTR(protection_mode, S_IRUGO, sd_show_protection_mode, NULL),
 	__ATTR(app_tag_own, S_IRUGO, sd_show_app_tag_own, NULL),
 	__ATTR(thin_provisioning, S_IRUGO, sd_show_thin_provisioning, NULL),
+	__ATTR(provisioning_mode, S_IRUGO|S_IWUSR, sd_show_provisioning_mode,
+	       sd_store_provisioning_mode),
 	__ATTR_NULL,
 };
 
@@ -433,6 +483,49 @@ static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
 	scsi_set_prot_type(scmd, dif);
 }
 
+static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned int logical_block_size = sdkp->device->sector_size;
+	unsigned int max_blocks = 0;
+
+	q->limits.discard_zeroes_data = sdkp->lbprz;
+	q->limits.discard_alignment = sdkp->unmap_alignment;
+	q->limits.discard_granularity =
+		max(sdkp->physical_block_size,
+		    sdkp->unmap_granularity * logical_block_size);
+
+	switch (mode) {
+
+	case SD_LBP_DISABLE:
+		q->limits.max_discard_sectors = 0;
+		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
+		return;
+
+	case SD_LBP_UNMAP:
+		max_blocks = min_not_zero(sdkp->max_unmap_blocks, 0xffffffff);
+		break;
+
+	case SD_LBP_WS16:
+		max_blocks = min_not_zero(sdkp->max_ws_blocks, 0xffffffff);
+		break;
+
+	case SD_LBP_WS10:
+		max_blocks = min_not_zero(sdkp->max_ws_blocks, (u32)0xffff);
+		break;
+
+	case SD_LBP_ZERO:
+		max_blocks = min_not_zero(sdkp->max_ws_blocks, (u32)0xffff);
+		q->limits.discard_zeroes_data = 1;
+		break;
+	}
+
+	q->limits.max_discard_sectors = max_blocks * (logical_block_size >> 9);
+	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+
+	sdkp->provisioning_mode = mode;
+}
+
 /**
  * scsi_setup_discard_cmnd - unmap blocks on thinly provisioned device
  * @sdp: scsi device to operate one
@@ -449,6 +542,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	unsigned int nr_sectors = bio_sectors(bio);
 	unsigned int len;
 	int ret;
+	char *buf;
 	struct page *page;
 
 	if (sdkp->device->sector_size == 4096) {
@@ -464,8 +558,9 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	if (!page)
 		return BLKPREP_DEFER;
 
-	if (sdkp->unmap) {
-		char *buf = page_address(page);
+	switch (sdkp->provisioning_mode) {
+	case SD_LBP_UNMAP:
+		buf = page_address(page);
 
 		rq->cmd_len = 10;
 		rq->cmd[0] = UNMAP;
@@ -477,7 +572,9 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 		put_unaligned_be32(nr_sectors, &buf[16]);
 
 		len = 24;
-	} else {
+		break;
+
+	case SD_LBP_WS16:
 		rq->cmd_len = 16;
 		rq->cmd[0] = WRITE_SAME_16;
 		rq->cmd[1] = 0x8; /* UNMAP */
@@ -485,11 +582,29 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
 
 		len = sdkp->device->sector_size;
+		break;
+
+	case SD_LBP_WS10:
+	case SD_LBP_ZERO:
+		rq->cmd_len = 10;
+		rq->cmd[0] = WRITE_SAME;
+		if (sdkp->provisioning_mode == SD_LBP_WS10)
+			rq->cmd[1] = 0x8; /* UNMAP */
+		put_unaligned_be32(sector, &rq->cmd[2]);
+		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
+
+		len = sdkp->device->sector_size;
+		break;
+
+	default:
+		goto out;
 	}
 
 	blk_add_request_payload(rq, page, len);
 	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 	rq->buffer = page_address(page);
+
+out:
 	if (ret != BLKPREP_OK) {
 		__free_page(page);
 		rq->buffer = NULL;
@@ -1251,12 +1366,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	int sense_valid = 0;
 	int sense_deferred = 0;
+	unsigned char op = SCpnt->cmnd[0];
 
-	if (SCpnt->request->cmd_flags & REQ_DISCARD) {
-		if (!result)
-			scsi_set_resid(SCpnt, 0);
-		return good_bytes;
-	}
+	if ((SCpnt->request->cmd_flags & REQ_DISCARD) && !result)
+		scsi_set_resid(SCpnt, 0);
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
@@ -1295,10 +1408,17 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		SCpnt->result = 0;
 		memset(SCpnt->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
 		break;
-	case ABORTED_COMMAND: /* DIF: Target detected corruption */
-	case ILLEGAL_REQUEST: /* DIX: Host detected corruption */
-		if (sshdr.asc == 0x10)
+	case ABORTED_COMMAND:
+		if (sshdr.asc == 0x10)  /* DIF: Target detected corruption */
+			good_bytes = sd_completed_bytes(SCpnt);
+		break;
+	case ILLEGAL_REQUEST:
+		if (sshdr.asc == 0x10)  /* DIX: Host detected corruption */
 			good_bytes = sd_completed_bytes(SCpnt);
+		/* INVALID COMMAND OPCODE or INVALID FIELD IN CDB */
+		if ((sshdr.asc == 0x20 || sshdr.asc == 0x24) &&
+		    (op == UNMAP || op == WRITE_SAME_16 || op == WRITE_SAME))
+			sd_config_discard(sdkp, SD_LBP_DISABLE);
 		break;
 	default:
 		break;
@@ -1596,17 +1716,13 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		sd_printk(KERN_NOTICE, sdkp,
 			  "physical block alignment offset: %u\n", alignment);
 
-	if (buffer[14] & 0x80) { /* TPE */
-		struct request_queue *q = sdp->request_queue;
+	if (buffer[14] & 0x80) { /* LBPME */
+		sdkp->lbpme = 1;
 
-		sdkp->thin_provisioning = 1;
-		q->limits.discard_granularity = sdkp->physical_block_size;
-		q->limits.max_discard_sectors = 0xffffffff;
+		if (buffer[14] & 0x40) /* LBPRZ */
+			sdkp->lbprz = 1;
 
-		if (buffer[14] & 0x40) /* TPRZ */
-			q->limits.discard_zeroes_data = 1;
-
-		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+		sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
@@ -2091,7 +2207,6 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
  */
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
-	struct request_queue *q = sdkp->disk->queue;
 	unsigned int sector_sz = sdkp->device->sector_size;
 	const int vpd_len = 64;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
@@ -2106,39 +2221,46 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	blk_queue_io_opt(sdkp->disk->queue,
 			 get_unaligned_be32(&buffer[12]) * sector_sz);
 
-	/* Thin provisioning enabled and page length indicates TP support */
-	if (sdkp->thin_provisioning && buffer[3] == 0x3c) {
-		unsigned int lba_count, desc_count, granularity;
+	if (buffer[3] == 0x3c) {
+		unsigned int lba_count, desc_count;
 
-		lba_count = get_unaligned_be32(&buffer[20]);
-		desc_count = get_unaligned_be32(&buffer[24]);
-
-		if (lba_count && desc_count) {
-			if (sdkp->tpvpd && !sdkp->tpu)
-				sdkp->unmap = 0;
-			else
-				sdkp->unmap = 1;
-		}
+		sdkp->max_ws_blocks =
+			(u32) min_not_zero(get_unaligned_be64(&buffer[36]),
+					   (u64)0xffffffff);
 
-		if (sdkp->tpvpd && !sdkp->tpu && !sdkp->tpws) {
-			sd_printk(KERN_ERR, sdkp, "Thin provisioning is " \
-				  "enabled but neither TPU, nor TPWS are " \
-				  "set. Disabling discard!\n");
+		if (!sdkp->lbpme)
 			goto out;
-		}
 
-		if (lba_count)
-			q->limits.max_discard_sectors =
-				lba_count * sector_sz >> 9;
+		lba_count = get_unaligned_be32(&buffer[20]);
+		desc_count = get_unaligned_be32(&buffer[24]);
 
-		granularity = get_unaligned_be32(&buffer[28]);
+		if (lba_count && desc_count)
+			sdkp->max_unmap_blocks = lba_count;
 
-		if (granularity)
-			q->limits.discard_granularity = granularity * sector_sz;
+		sdkp->unmap_granularity = get_unaligned_be32(&buffer[28]);
 
 		if (buffer[32] & 0x80)
-			q->limits.discard_alignment =
+			sdkp->unmap_alignment =
 				get_unaligned_be32(&buffer[32]) & ~(1 << 31);
+
+		if (!sdkp->lbpvpd) { /* LBP VPD page not provided */
+
+			if (sdkp->max_unmap_blocks)
+				sd_config_discard(sdkp, SD_LBP_UNMAP);
+			else
+				sd_config_discard(sdkp, SD_LBP_WS16);
+
+		} else {	/* LBP VPD page tells us what to use */
+
+			if (sdkp->lbpu && sdkp->max_unmap_blocks)
+				sd_config_discard(sdkp, SD_LBP_UNMAP);
+			else if (sdkp->lbpws)
+				sd_config_discard(sdkp, SD_LBP_WS16);
+			else if (sdkp->lbpws10)
+				sd_config_discard(sdkp, SD_LBP_WS10);
+			else
+				sd_config_discard(sdkp, SD_LBP_DISABLE);
+		}
 	}
 
  out:
@@ -2172,15 +2294,15 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 }
 
 /**
- * sd_read_thin_provisioning - Query thin provisioning VPD page
+ * sd_read_block_provisioning - Query provisioning VPD page
  * @disk: disk to query
  */
-static void sd_read_thin_provisioning(struct scsi_disk *sdkp)
+static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 {
 	unsigned char *buffer;
 	const int vpd_len = 8;
 
-	if (sdkp->thin_provisioning == 0)
+	if (sdkp->lbpme == 0)
 		return;
 
 	buffer = kmalloc(vpd_len, GFP_KERNEL);
@@ -2188,9 +2310,10 @@ static void sd_read_thin_provisioning(struct scsi_disk *sdkp)
 	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb2, buffer, vpd_len))
 		goto out;
 
-	sdkp->tpvpd = 1;
-	sdkp->tpu   = (buffer[5] >> 7) & 1;	/* UNMAP */
-	sdkp->tpws  = (buffer[5] >> 6) & 1;	/* WRITE SAME(16) with UNMAP */
+	sdkp->lbpvpd	= 1;
+	sdkp->lbpu	= (buffer[5] >> 7) & 1;	/* UNMAP */
+	sdkp->lbpws	= (buffer[5] >> 6) & 1;	/* WRITE SAME(16) with UNMAP */
+	sdkp->lbpws10	= (buffer[5] >> 5) & 1;	/* WRITE SAME(10) with UNMAP */
 
  out:
 	kfree(buffer);
@@ -2247,7 +2370,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_capacity(sdkp, buffer);
 
 		if (sd_try_extended_inquiry(sdp)) {
-			sd_read_thin_provisioning(sdkp);
+			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 		}
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index c9d8f6c..6ad798b 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -43,6 +43,15 @@ enum {
 	SD_MEMPOOL_SIZE = 2,	/* CDB pool size */
 };
 
+enum {
+	SD_LBP_FULL = 0,	/* Full logical block provisioning */
+	SD_LBP_UNMAP,		/* Use UNMAP command */
+	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
+	SD_LBP_WS10,		/* Use WRITE SAME(10) with UNMAP bit */
+	SD_LBP_ZERO,		/* Use WRITE SAME(10) with zero payload */
+	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
+};
+
 struct scsi_disk {
 	struct scsi_driver *driver;	/* always &sd_template */
 	struct scsi_device *device;
@@ -50,21 +59,27 @@ struct scsi_disk {
 	struct gendisk	*disk;
 	atomic_t	openers;
 	sector_t	capacity;	/* size in 512-byte sectors */
+	u32		max_ws_blocks;
+	u32		max_unmap_blocks;
+	u32		unmap_granularity;
+	u32		unmap_alignment;
 	u32		index;
 	unsigned int	physical_block_size;
 	u8		media_present;
 	u8		write_prot;
 	u8		protection_type;/* Data Integrity Field */
+	u8		provisioning_mode;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
 	unsigned	first_scan : 1;
-	unsigned	thin_provisioning : 1;
-	unsigned	unmap : 1;
-	unsigned	tpws : 1;
-	unsigned	tpu : 1;
-	unsigned	tpvpd : 1;
+	unsigned	lbpme : 1;
+	unsigned	lbprz : 1;
+	unsigned	lbpu : 1;
+	unsigned	lbpws : 1;
+	unsigned	lbpws10 : 1;
+	unsigned	lbpvpd : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
