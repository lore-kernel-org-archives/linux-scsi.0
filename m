From: Damien Le Moal <damien.lemoal@hgst.com>
Subject: [PATCH 8/9] sd: Implement support for ZBC devices
Date: Tue, 20 Sep 2016 06:27:33 +0900
Message-ID: <1474320454-5264-9-git-send-email-damien.lemoal@hgst.com>
References: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:34625 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932719AbcISV3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2016 17:29:14 -0400
In-Reply-To: <1474320454-5264-1-git-send-email-damien.lemoal@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc: martin.petersen@oracle.com, axboe@kernel.dk, hare@suse.de, shaun.tancheff@seagate.com, Hannes Reinecke <hare@suse.com>, Damien Le Moal <damien.lemoal@hgst.com>

From: Hannes Reinecke <hare@suse.com>

Implement ZBC support functions to setup zoned disks and fill the
block device zone information tree during the device scan. The
zone information tree is also always updated on disk revalidation.
This adds support for the REQ_OP_ZONE* operations and also implements
the new RESET_WP provisioning mode so that discard requests can be
mapped to the RESET WRITE POINTER command for devices with a constant
zone size.

The capacity read of the device triggers the zone information read
for zoned block devices. As this needs the device zone model, the
the call to sd_read_capacity is moved after the call to
sd_read_block_characteristics so that host-aware devices are
properlly initialized. The call to sd_zbc_read_zones in
sd_read_capacity may change the device capacity obtained with
the sd_read_capacity_16 function for devices reporting only the
capacity of conventional zones at the beginning of the LBA range
(i.e. devices with rc_basis et to 0).

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 drivers/scsi/Makefile     |    1 +
 drivers/scsi/sd.c         |  147 ++++--
 drivers/scsi/sd.h         |   68 +++
 drivers/scsi/sd_zbc.c     | 1097 +++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_proto.h |   17 +
 5 files changed, 1304 insertions(+), 26 deletions(-)
 create mode 100644 drivers/scsi/sd_zbc.c

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index d539798..fabcb6d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -179,6 +179,7 @@ hv_storvsc-y			:= storvsc_drv.o
 
 sd_mod-objs	:= sd.o
 sd_mod-$(CONFIG_BLK_DEV_INTEGRITY) += sd_dif.o
+sd_mod-$(CONFIG_BLK_DEV_ZONED) += sd_zbc.o
 
 sr_mod-objs	:= sr.o sr_ioctl.o sr_vendor.o
 ncr53c8xx-flags-$(CONFIG_SCSI_ZALON) \
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d3e852a..46b8b78 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -92,6 +92,7 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_DISK);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_MOD);
 MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
+MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
 #define SD_MINORS	16
@@ -99,7 +100,6 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_RBC);
 #define SD_MINORS	0
 #endif
 
-static void sd_config_discard(struct scsi_disk *, unsigned int);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
@@ -162,7 +162,7 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	static const char temp[] = "temporary ";
 	int len;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		/* no cache control on RBC devices; theoretically they
 		 * can do it, but there's probably so many exceptions
 		 * it's not worth the risk */
@@ -261,7 +261,7 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
@@ -369,6 +369,7 @@ static const char *lbp_mode[] = {
 	[SD_LBP_WS16]		= "writesame_16",
 	[SD_LBP_WS10]		= "writesame_10",
 	[SD_LBP_ZERO]		= "writesame_zero",
+	[SD_ZBC_RESET_WP]	= "reset_wp",
 	[SD_LBP_DISABLE]	= "disabled",
 };
 
@@ -391,6 +392,13 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
+	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
+		if (!strncmp(buf, lbp_mode[SD_ZBC_RESET_WP], 20)) {
+			sd_config_discard(sdkp, SD_ZBC_RESET_WP);
+			return count;
+		}
+		return -EINVAL;
+	}
 	if (sdp->type != TYPE_DISK)
 		return -EINVAL;
 
@@ -458,7 +466,7 @@ max_write_same_blocks_store(struct device *dev, struct device_attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
 	err = kstrtoul(buf, 10, &max);
@@ -631,7 +639,7 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
-static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
+void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
@@ -683,6 +691,11 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		q->limits.discard_zeroes_data = sdkp->lbprz;
 		break;
 
+	case SD_ZBC_RESET_WP:
+		max_blocks = min_not_zero(sdkp->max_unmap_blocks,
+					  (u32)SD_MAX_WS16_BLOCKS);
+		break;
+
 	case SD_LBP_ZERO:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
 					  (u32)SD_MAX_WS10_BLOCKS);
@@ -711,16 +724,20 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	unsigned int nr_sectors = blk_rq_sectors(rq);
 	unsigned int nr_bytes = blk_rq_bytes(rq);
 	unsigned int len;
-	int ret;
+	int ret = BLKPREP_OK;
 	char *buf;
-	struct page *page;
+	struct page *page = NULL;
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 
-	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
-	if (!page)
-		return BLKPREP_DEFER;
+	if (sdkp->provisioning_mode != SD_ZBC_RESET_WP) {
+		page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+		if (!page)
+			return BLKPREP_DEFER;
+	}
+
+	rq->completion_data = page;
 
 	switch (sdkp->provisioning_mode) {
 	case SD_LBP_UNMAP:
@@ -760,12 +777,19 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		len = sdkp->device->sector_size;
 		break;
 
+	case SD_ZBC_RESET_WP:
+		ret = sd_zbc_setup_reset_cmnd(cmd);
+		if (ret != BLKPREP_OK)
+			goto out;
+		/* Reset Write Pointer doesn't have a payload */
+		len = 0;
+		break;
+
 	default:
 		ret = BLKPREP_INVALID;
 		goto out;
 	}
 
-	rq->completion_data = page;
 	rq->timeout = SD_TIMEOUT;
 
 	cmd->transfersize = len;
@@ -779,13 +803,17 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	 * discarded on disk. This allows us to report completion on the full
 	 * amount of blocks described by the request.
 	 */
-	blk_add_request_payload(rq, page, 0, len);
-	ret = scsi_init_io(cmd);
+	if (len) {
+		blk_add_request_payload(rq, page, 0, len);
+		ret = scsi_init_io(cmd);
+	}
 	rq->__data_len = nr_bytes;
 
 out:
-	if (ret != BLKPREP_OK)
+	if (page && ret != BLKPREP_OK) {
+		rq->completion_data = NULL;
 		__free_page(page);
+	}
 	return ret;
 }
 
@@ -843,6 +871,13 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
+	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
+		/* sd_zbc_setup_read_write uses block layer sector units */
+		ret = sd_zbc_setup_read_write(sdkp, rq, sector, &nr_sectors);
+		if (ret != BLKPREP_OK)
+			return ret;
+	}
+
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 
@@ -962,6 +997,13 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 
+	if (sdkp->zoned == 1 || sdp->type == TYPE_ZBC) {
+		/* sd_zbc_setup_read_write uses block layer sector units */
+		ret = sd_zbc_setup_read_write(sdkp, rq, block, &this_count);
+		if (ret != BLKPREP_OK)
+			goto out;
+	}
+
 	/*
 	 * If we have a 1K hardware sectorsize, prevent access to single
 	 * 512 byte sectors.  In theory we could handle this - in fact
@@ -1148,6 +1190,16 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
 		return sd_setup_read_write_cmnd(cmd);
+	case REQ_OP_ZONE_REPORT:
+		return sd_zbc_setup_report_cmnd(cmd);
+	case REQ_OP_ZONE_RESET:
+		return sd_zbc_setup_reset_cmnd(cmd);
+	case REQ_OP_ZONE_OPEN:
+		return sd_zbc_setup_open_cmnd(cmd);
+	case REQ_OP_ZONE_CLOSE:
+		return sd_zbc_setup_close_cmnd(cmd);
+	case REQ_OP_ZONE_FINISH:
+		return sd_zbc_setup_finish_cmnd(cmd);
 	default:
 		BUG();
 	}
@@ -1157,7 +1209,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
-	if (req_op(rq) == REQ_OP_DISCARD)
+	if (req_op(rq) == REQ_OP_DISCARD &&
+	    rq->completion_data)
 		__free_page(rq->completion_data);
 
 	if (SCpnt->cmnd != rq->cmd) {
@@ -1778,8 +1831,16 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	int sense_deferred = 0;
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
+	unsigned char sa = SCpnt->cmnd[1] & 0xf;
 
-	if (req_op(req) == REQ_OP_DISCARD || req_op(req) == REQ_OP_WRITE_SAME) {
+	switch(req_op(req)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_ZONE_REPORT:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
@@ -1787,6 +1848,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = 0;
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
+		break;
 	}
 
 	if (result) {
@@ -1829,6 +1891,10 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			case UNMAP:
 				sd_config_discard(sdkp, SD_LBP_DISABLE);
 				break;
+			case ZBC_OUT:
+				if (sa == ZO_RESET_WRITE_POINTER)
+					sd_config_discard(sdkp, SD_LBP_DISABLE);
+				break;
 			case WRITE_SAME_16:
 			case WRITE_SAME:
 				if (unmap)
@@ -1847,7 +1913,11 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	default:
 		break;
 	}
+
  out:
+	if (sdkp->zoned == 1 || sdkp->device->type == TYPE_ZBC)
+		sd_zbc_done(SCpnt, &sshdr);
+
 	SCSI_LOG_HLCOMPLETE(1, scmd_printk(KERN_INFO, SCpnt,
 					   "sd_done: completed %d of %d bytes\n",
 					   good_bytes, scsi_bufflen(SCpnt)));
@@ -1982,7 +2052,6 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	}
 }
 
-
 /*
  * Determine whether disk supports Data Integrity Field.
  */
@@ -2132,6 +2201,9 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 	/* Logical blocks per physical block exponent */
 	sdkp->physical_block_size = (1 << (buffer[13] & 0xf)) * sector_size;
 
+	/* RC basis */
+	sdkp->rc_basis = (buffer[12] >> 4) & 0x3;
+
 	/* Lowest aligned logical block */
 	alignment = ((buffer[14] & 0x3f) << 8 | buffer[15]) * sector_size;
 	blk_queue_alignment_offset(sdp->request_queue, alignment);
@@ -2322,6 +2394,11 @@ got_data:
 		sector_size = 512;
 	}
 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
+	blk_queue_physical_block_size(sdp->request_queue,
+				      sdkp->physical_block_size);
+	sdkp->device->sector_size = sector_size;
+
+	sd_zbc_read_zones(sdkp, buffer);
 
 	{
 		char cap_str_2[10], cap_str_10[10];
@@ -2348,9 +2425,6 @@ got_data:
 	if (sdkp->capacity > 0xffffffff)
 		sdp->use_16_for_rw = 1;
 
-	blk_queue_physical_block_size(sdp->request_queue,
-				      sdkp->physical_block_size);
-	sdkp->device->sector_size = sector_size;
 }
 
 /* called with buffer of length 512 */
@@ -2612,7 +2686,7 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 	struct scsi_mode_data data;
 	struct scsi_sense_hdr sshdr;
 
-	if (sdp->type != TYPE_DISK)
+	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return;
 
 	if (sdkp->protection_type == 0)
@@ -2719,6 +2793,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
  */
 static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
+	struct request_queue *q = sdkp->disk->queue;
 	unsigned char *buffer;
 	u16 rot;
 	const int vpd_len = 64;
@@ -2733,10 +2808,21 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	rot = get_unaligned_be16(&buffer[4]);
 
 	if (rot == 1) {
-		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, sdkp->disk->queue);
-		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, sdkp->disk->queue);
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
+		queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, q);
 	}
 
+	sdkp->zoned = (buffer[8] >> 4) & 3;
+	if (sdkp->zoned == 1)
+		q->limits.zoned = BLK_ZONED_HA;
+	else if (sdkp->device->type == TYPE_ZBC)
+		q->limits.zoned = BLK_ZONED_HM;
+	else
+		q->limits.zoned = BLK_ZONED_NONE;
+	if (blk_queue_zoned(q) && sdkp->first_scan)
+		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
+			  q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+
  out:
 	kfree(buffer);
 }
@@ -2835,14 +2921,14 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	 * react badly if we do.
 	 */
 	if (sdkp->media_present) {
-		sd_read_capacity(sdkp, buffer);
-
 		if (scsi_device_supports_vpd(sdp)) {
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
 		}
 
+		sd_read_capacity(sdkp, buffer);
+
 		sd_read_write_protect_flag(sdkp, buffer);
 		sd_read_cache_type(sdkp, buffer);
 		sd_read_app_tag_own(sdkp, buffer);
@@ -3040,9 +3126,16 @@ static int sd_probe(struct device *dev)
 
 	scsi_autopm_get_device(sdp);
 	error = -ENODEV;
-	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
+	if (sdp->type != TYPE_DISK &&
+	    sdp->type != TYPE_ZBC &&
+	    sdp->type != TYPE_MOD &&
+	    sdp->type != TYPE_RBC)
 		goto out;
 
+#ifndef CONFIG_BLK_DEV_ZONED
+	if (sdp->type == TYPE_ZBC)
+		goto out;
+#endif
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
 					"sd_probe\n"));
 
@@ -3146,6 +3239,8 @@ static int sd_remove(struct device *dev)
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
+	sd_zbc_remove(sdkp);
+
 	blk_register_region(devt, SD_MINORS, NULL,
 			    sd_default_probe, NULL, NULL);
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 765a6f1..3452871 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -56,6 +56,7 @@ enum {
 	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
 	SD_LBP_WS10,		/* Use WRITE SAME(10) with UNMAP bit */
 	SD_LBP_ZERO,		/* Use WRITE SAME(10) with zero payload */
+	SD_ZBC_RESET_WP,	/* Use RESET WRITE POINTER */
 	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
 };
 
@@ -64,6 +65,11 @@ struct scsi_disk {
 	struct scsi_device *device;
 	struct device	dev;
 	struct gendisk	*disk;
+#ifdef CONFIG_BLK_DEV_ZONED
+	struct workqueue_struct *zone_work_q;
+	sector_t zone_sectors;
+	unsigned int nr_zones;
+#endif
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
 	u32		max_xfer_blocks;
@@ -94,6 +100,8 @@ struct scsi_disk {
 	unsigned	lbpvpd : 1;
 	unsigned	ws10 : 1;
 	unsigned	ws16 : 1;
+	unsigned	rc_basis: 2;
+	unsigned	zoned: 2;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 
@@ -156,6 +164,13 @@ static inline unsigned int logical_to_bytes(struct scsi_device *sdev, sector_t b
 	return blocks * sdev->sector_size;
 }
 
+static inline sector_t sectors_to_logical(struct scsi_device *sdev, sector_t sector)
+{
+	return sector >> (ilog2(sdev->sector_size) - 9);
+}
+
+extern void sd_config_discard(struct scsi_disk *, unsigned int);
+
 /*
  * A DIF-capable target device can be formatted with different
  * protection schemes.  Currently 0 through 3 are defined:
@@ -269,4 +284,57 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+#ifdef CONFIG_BLK_DEV_ZONED
+
+extern void sd_zbc_read_zones(struct scsi_disk *, char *);
+extern void sd_zbc_remove(struct scsi_disk *);
+extern int sd_zbc_setup_read_write(struct scsi_disk *, struct request *,
+				   sector_t, unsigned int *);
+extern int sd_zbc_setup_report_cmnd(struct scsi_cmnd *);
+extern int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *);
+extern int sd_zbc_setup_open_cmnd(struct scsi_cmnd *);
+extern int sd_zbc_setup_close_cmnd(struct scsi_cmnd *);
+extern int sd_zbc_setup_finish_cmnd(struct scsi_cmnd *);
+extern void sd_zbc_done(struct scsi_cmnd *, struct scsi_sense_hdr *);
+
+#else /* CONFIG_BLK_DEV_ZONED */
+
+static inline void sd_zbc_read_zones(struct scsi_disk *sdkp,
+				     unsigned char *buf) {}
+static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
+
+static inline int sd_zbc_setup_read_write(struct scsi_disk *sdkp,
+					  struct request *rq, sector_t sector,
+					  unsigned int *num_sectors)
+{
+	/* Let the drive fail requests */
+	return BLKPREP_OK;
+}
+
+static inline int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+static inline int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+static inline int sd_zbc_setup_open_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+static inline int sd_zbc_setup_close_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+static inline int sd_zbc_setup_finish_cmnd(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+
+static inline void sd_zbc_done(struct scsi_cmnd *cmd,
+			       struct scsi_sense_hdr *sshdr) {}
+
+#endif /* CONFIG_BLK_DEV_ZONED */
+
 #endif /* _SCSI_DISK_H */
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
new file mode 100644
index 0000000..ec9c3fc
--- /dev/null
+++ b/drivers/scsi/sd_zbc.c
@@ -0,0 +1,1097 @@
+/*
+ * SCSI Zoned Block commands
+ *
+ * Copyright (C) 2014-2015 SUSE Linux GmbH
+ * Written by: Hannes Reinecke <hare@suse.de>
+ * Modified by: Damien Le Moal <damien.lemoal@hgst.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; see the file COPYING.  If not, write to
+ * the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
+ * USA.
+ *
+ */
+
+#include <linux/blkdev.h>
+#include <linux/rbtree.h>
+
+#include <asm/unaligned.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_eh.h>
+
+#include "sd.h"
+#include "scsi_priv.h"
+
+enum zbc_zone_type {
+	ZBC_ZONE_TYPE_CONV = 0x1,
+	ZBC_ZONE_TYPE_SEQWRITE_REQ,
+	ZBC_ZONE_TYPE_SEQWRITE_PREF,
+	ZBC_ZONE_TYPE_RESERVED,
+};
+
+enum zbc_zone_cond {
+	ZBC_ZONE_COND_NO_WP,
+	ZBC_ZONE_COND_EMPTY,
+	ZBC_ZONE_COND_IMP_OPEN,
+	ZBC_ZONE_COND_EXP_OPEN,
+	ZBC_ZONE_COND_CLOSED,
+	ZBC_ZONE_COND_READONLY = 0xd,
+	ZBC_ZONE_COND_FULL,
+	ZBC_ZONE_COND_OFFLINE,
+};
+
+#define SD_ZBC_BUF_SIZE 131072
+
+#define sd_zbc_debug(sdkp, fmt, args...)			\
+	pr_debug("%s %s [%s]: " fmt,				\
+		 dev_driver_string(&(sdkp)->device->sdev_gendev), \
+		 dev_name(&(sdkp)->device->sdev_gendev),	 \
+		 (sdkp)->disk->disk_name, ## args)
+
+#define sd_zbc_debug_ratelimit(sdkp, fmt, args...)		\
+	do {							\
+		if (printk_ratelimit())				\
+			sd_zbc_debug(sdkp, fmt, ## args);	\
+	} while( 0 )
+
+#define sd_zbc_err(sdkp, fmt, args...)				\
+	pr_err("%s %s [%s]: " fmt,				\
+	       dev_driver_string(&(sdkp)->device->sdev_gendev),	\
+	       dev_name(&(sdkp)->device->sdev_gendev),		\
+	       (sdkp)->disk->disk_name, ## args)
+
+struct zbc_zone_work {
+	struct work_struct 	zone_work;
+	struct scsi_disk 	*sdkp;
+	sector_t		sector;
+	sector_t		nr_sects;
+	bool 			init;
+	unsigned int		nr_zones;
+};
+
+struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
+{
+	struct blk_zone *zone;
+
+	zone = kzalloc(sizeof(struct blk_zone), GFP_KERNEL);
+	if (!zone)
+		return NULL;
+
+	/* Zone type */
+	switch(rec[0] & 0x0f) {
+	case ZBC_ZONE_TYPE_CONV:
+	case ZBC_ZONE_TYPE_SEQWRITE_REQ:
+	case ZBC_ZONE_TYPE_SEQWRITE_PREF:
+		zone->type = rec[0] & 0x0f;
+		break;
+	default:
+		zone->type = BLK_ZONE_TYPE_UNKNOWN;
+		break;
+	}
+
+	/* Zone condition */
+	zone->cond = (rec[1] >> 4) & 0xf;
+	if (rec[1] & 0x01)
+		zone->reset = 1;
+	if (rec[1] & 0x02)
+		zone->non_seq = 1;
+
+	/* Zone start sector and length */
+	zone->len = logical_to_sectors(sdkp->device,
+				       get_unaligned_be64(&rec[8]));
+	zone->start = logical_to_sectors(sdkp->device,
+					 get_unaligned_be64(&rec[16]));
+
+	/* Zone write pointer */
+	if (blk_zone_is_empty(zone) &&
+	    zone->wp != zone->start)
+		zone->wp = zone->start;
+	else if (blk_zone_is_full(zone))
+		zone->wp = zone->start + zone->len;
+	else if (blk_zone_is_seq(zone))
+		zone->wp = logical_to_sectors(sdkp->device,
+					      get_unaligned_be64(&rec[24]));
+	else
+		zone->wp = (sector_t)-1;
+
+	return zone;
+}
+
+static int zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
+			   unsigned int buf_len, sector_t *next_sector)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	unsigned char *rec = buf;
+	unsigned int zone_len, list_length;
+
+	/* Parse REPORT ZONES header */
+	list_length = get_unaligned_be32(&buf[0]);
+	rec = buf + 64;
+	list_length += 64;
+
+	if (list_length < buf_len)
+		buf_len = list_length;
+
+	/* Parse REPORT ZONES zone descriptors */
+	*next_sector = capacity;
+	while (rec < buf + buf_len) {
+
+		struct blk_zone *new, *old;
+
+		new = zbc_desc_to_zone(sdkp, rec);
+		if (!new)
+			return -ENOMEM;
+
+		zone_len = new->len;
+		*next_sector = new->start + zone_len;
+
+		old = blk_insert_zone(q, new);
+		if (old) {
+			blk_lock_zone(old);
+
+			/*
+			 * Always update the zone state flags and the zone
+			 * offline and read-only condition as the drive may
+			 * change those independently of the commands being
+			 * executed
+			 */
+			old->reset = new->reset;
+			old->non_seq = new->non_seq;
+			if (blk_zone_is_offline(new) ||
+			    blk_zone_is_readonly(new))
+				old->cond = new->cond;
+
+			if (blk_zone_in_update(old)) {
+				old->cond = new->cond;
+				old->wp = new->wp;
+				blk_clear_zone_update(old);
+			}
+
+			blk_unlock_zone(old);
+
+			kfree(new);
+		}
+
+		rec += 64;
+
+	}
+
+	return 0;
+}
+
+/**
+ * sd_zbc_report_zones - Issue a REPORT ZONES scsi command
+ * @sdkp: SCSI disk to which the command should be send
+ * @buffer: response buffer
+ * @bufflen: length of @buffer
+ * @start_sector: logical sector for the zone information should be reported
+ * @option: reporting option to be used
+ * @partial: flag to set the 'partial' bit for report zones command
+ */
+int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
+			int bufflen, sector_t start_sector,
+			enum zbc_zone_reporting_options option, bool partial)
+{
+	struct scsi_device *sdp = sdkp->device;
+	const int timeout = sdp->request_queue->rq_timeout;
+	struct scsi_sense_hdr sshdr;
+	sector_t start_lba = sectors_to_logical(sdkp->device, start_sector);
+	unsigned char cmd[16];
+	int result;
+
+	if (!scsi_device_online(sdp))
+		return -ENODEV;
+
+	sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n",
+		     start_lba, bufflen);
+
+	memset(cmd, 0, 16);
+	cmd[0] = ZBC_IN;
+	cmd[1] = ZI_REPORT_ZONES;
+	put_unaligned_be64(start_lba, &cmd[2]);
+	put_unaligned_be32(bufflen, &cmd[10]);
+	cmd[14] = (partial ? ZBC_REPORT_ZONE_PARTIAL : 0) | option;
+	memset(buffer, 0, bufflen);
+
+	result = scsi_execute_req(sdp, cmd, DMA_FROM_DEVICE,
+				buffer, bufflen, &sshdr,
+				timeout, SD_MAX_RETRIES, NULL);
+
+	if (result) {
+		sd_zbc_err(sdkp,
+			   "REPORT ZONES lba %zu failed with %d/%d\n",
+			   start_lba, host_byte(result), driver_byte(result));
+		return -EIO;
+	}
+
+	return 0;
+}
+
+/**
+ * Set or clear the update flag of all zones contained
+ * in the range sector..sector+nr_sects.
+ * Return the number of zones marked/cleared.
+ */
+static int __sd_zbc_zones_updating(struct scsi_disk *sdkp,
+				   sector_t sector, sector_t nr_sects,
+				   bool set)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	struct blk_zone *zone;
+	struct rb_node *node;
+	unsigned long flags;
+	int nr_zones = 0;
+
+	if (!nr_sects) {
+		/* All zones */
+		sector = 0;
+		nr_sects = logical_to_sectors(sdkp->device, sdkp->capacity);
+	}
+
+	spin_lock_irqsave(&q->zones_lock, flags);
+	for (node = rb_first(&q->zones); node && nr_sects; node = rb_next(node)) {
+		zone = rb_entry(node, struct blk_zone, node);
+		if (sector < zone->start || sector >= (zone->start + zone->len))
+			continue;
+		if (set) {
+			if (!test_and_set_bit_lock(BLK_ZONE_IN_UPDATE, &zone->flags))
+				nr_zones++;
+		} else if (test_and_clear_bit(BLK_ZONE_IN_UPDATE, &zone->flags)) {
+			wake_up_bit(&zone->flags, BLK_ZONE_IN_UPDATE);
+			nr_zones++;
+		}
+		sector = zone->start + zone->len;
+		if (nr_sects <= zone->len)
+			nr_sects = 0;
+		else
+			nr_sects -= zone->len;
+	}
+	spin_unlock_irqrestore(&q->zones_lock, flags);
+
+	return nr_zones;
+}
+
+static inline int sd_zbc_set_zones_updating(struct scsi_disk *sdkp,
+					    sector_t sector, sector_t nr_sects)
+{
+	return __sd_zbc_zones_updating(sdkp, sector, nr_sects, true);
+}
+
+static inline int sd_zbc_clear_zones_updating(struct scsi_disk *sdkp,
+					      sector_t sector, sector_t nr_sects)
+{
+	return __sd_zbc_zones_updating(sdkp, sector, nr_sects, false);
+}
+
+static void sd_zbc_start_queue(struct request_queue *q)
+{
+	unsigned long flags;
+
+	if (q->mq_ops) {
+		blk_mq_start_hw_queues(q);
+	} else {
+		spin_lock_irqsave(q->queue_lock, flags);
+		blk_start_queue(q);
+		spin_unlock_irqrestore(q->queue_lock, flags);
+	}
+}
+
+static void sd_zbc_update_zone_work(struct work_struct *work)
+{
+	struct zbc_zone_work *zwork =
+		container_of(work, struct zbc_zone_work, zone_work);
+	struct scsi_disk *sdkp = zwork->sdkp;
+	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	struct request_queue *q = sdkp->disk->queue;
+	sector_t end_sector, sector = zwork->sector;
+	unsigned int bufsize;
+	unsigned char *buf;
+	int ret = -ENOMEM;
+
+	/* Get a buffer */
+	if (!zwork->nr_zones) {
+		bufsize = SD_ZBC_BUF_SIZE;
+	} else {
+		bufsize = (zwork->nr_zones + 1) * 64;
+		if (bufsize < 512)
+			bufsize = 512;
+		else if (bufsize > SD_ZBC_BUF_SIZE)
+				bufsize = SD_ZBC_BUF_SIZE;
+		else
+			bufsize = (bufsize + 511) & ~511;
+	}
+	buf = kmalloc(bufsize, GFP_KERNEL | GFP_DMA);
+	if (!buf) {
+		sd_zbc_err(sdkp, "Failed to allocate zone report buffer\n");
+		goto done_free;
+	}
+
+	/* Process sector range */
+	end_sector = zwork->sector + zwork->nr_sects;
+	while(sector < min(end_sector, capacity)) {
+
+		/* Get zone report */
+		ret = sd_zbc_report_zones(sdkp, buf, bufsize, sector,
+					  ZBC_ZONE_REPORTING_OPTION_ALL, true);
+		if (ret)
+			break;
+
+		ret = zbc_parse_zones(sdkp, buf, bufsize, &sector);
+		if (ret)
+			break;
+
+		/* Kick start the queue to allow requests waiting */
+		/* for the zones just updated to run              */
+		sd_zbc_start_queue(q);
+
+	}
+
+done_free:
+	if (ret)
+		sd_zbc_clear_zones_updating(sdkp, zwork->sector, zwork->nr_sects);
+	if (buf)
+		kfree(buf);
+	kfree(zwork);
+}
+
+/**
+ * sd_zbc_update_zones - Update zone information for zones starting
+ * from @start_sector. If not in init mode, the update is done only
+ * for zones marked with update flag.
+ * @sdkp: SCSI disk for which the zone information needs to be updated
+ * @start_sector: First sector of the first zone to be updated
+ * @bufsize: buffersize to be allocated for report zones
+ */
+static int sd_zbc_update_zones(struct scsi_disk *sdkp,
+			       sector_t sector, sector_t nr_sects,
+			       gfp_t gfpflags, bool init)
+{
+	struct zbc_zone_work *zwork;
+
+	zwork = kzalloc(sizeof(struct zbc_zone_work), gfpflags);
+	if (!zwork) {
+		sd_zbc_err(sdkp, "Failed to allocate zone work\n");
+		return -ENOMEM;
+	}
+
+	if (!nr_sects) {
+		/* All zones */
+		sector = 0;
+		nr_sects = logical_to_sectors(sdkp->device, sdkp->capacity);
+	}
+
+	INIT_WORK(&zwork->zone_work, sd_zbc_update_zone_work);
+	zwork->sdkp = sdkp;
+	zwork->sector = sector;
+	zwork->nr_sects = nr_sects;
+	zwork->init = init;
+
+	if (!init)
+		/* Mark the zones falling in the report as updating */
+		zwork->nr_zones = sd_zbc_set_zones_updating(sdkp, sector, nr_sects);
+
+	if (init || zwork->nr_zones)
+		queue_work(sdkp->zone_work_q, &zwork->zone_work);
+	else
+		kfree(zwork);
+
+	return 0;
+}
+
+int sd_zbc_setup_report_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct gendisk *disk = rq->rq_disk;
+	struct scsi_disk *sdkp = scsi_disk(disk);
+	int ret;
+
+	if (!sdkp->zone_work_q)
+		return BLKPREP_KILL;
+
+	ret = sd_zbc_update_zones(sdkp, blk_rq_pos(rq), blk_rq_sectors(rq),
+				  GFP_ATOMIC, false);
+	if (unlikely(ret))
+		return BLKPREP_DEFER;
+
+	return BLKPREP_DONE;
+}
+
+static void sd_zbc_setup_action_cmnd(struct scsi_cmnd *cmd,
+				     u8 action,
+				     bool all)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t lba;
+
+	cmd->cmd_len = 16;
+	cmd->cmnd[0] = ZBC_OUT;
+	cmd->cmnd[1] = action;
+	if (all) {
+		cmd->cmnd[14] |= 0x01;
+	} else {
+		lba = sectors_to_logical(sdkp->device, blk_rq_pos(rq));
+		put_unaligned_be64(lba, &cmd->cmnd[2]);
+	}
+
+	rq->completion_data = NULL;
+	rq->timeout = SD_TIMEOUT;
+	rq->__data_len = blk_rq_bytes(rq);
+
+	/* Don't retry */
+	cmd->allowed = 0;
+	cmd->transfersize = 0;
+	cmd->sc_data_direction = DMA_NONE;
+}
+
+int sd_zbc_setup_reset_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	sector_t nr_sects = blk_rq_sectors(rq);
+	struct blk_zone *zone = NULL;
+	int ret = BLKPREP_OK;
+
+	if (nr_sects) {
+		zone = blk_lookup_zone(rq->q, sector);
+		if (!zone)
+			return BLKPREP_KILL;
+	}
+
+	if (zone) {
+
+		blk_lock_zone(zone);
+
+		/* If the zone is being updated, wait */
+		if (blk_zone_in_update(zone)) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+
+		if (zone->type == BLK_ZONE_TYPE_UNKNOWN) {
+			sd_zbc_debug(sdkp,
+				     "Discarding unknown zone %zu\n",
+				     zone->start);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+		/* Nothing to do for conventional sequential zones */
+		if (blk_zone_is_conv(zone)) {
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+
+		if (!blk_try_write_lock_zone(zone)) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+
+		/* Nothing to do if the zone is already empty */
+		if (blk_zone_is_empty(zone)) {
+			blk_write_unlock_zone(zone);
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+
+		if (sector != zone->start ||
+		    (nr_sects != zone->len)) {
+			sd_printk(KERN_ERR, sdkp,
+				  "Unaligned reset wp request, start %zu/%zu"
+				  " len %zu/%zu\n",
+				  zone->start, sector, zone->len, nr_sects);
+			blk_write_unlock_zone(zone);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+	}
+
+	sd_zbc_setup_action_cmnd(cmd, ZO_RESET_WRITE_POINTER, !zone);
+
+out:
+	if (zone) {
+		if (ret == BLKPREP_OK) {
+			/*
+			 * Opportunistic update. Will be fixed up
+			 * with zone update if the command fails,
+			 */
+			zone->wp = zone->start;
+			zone->cond = BLK_ZONE_COND_EMPTY;
+			zone->reset = 0;
+			zone->non_seq = 0;
+		}
+		blk_unlock_zone(zone);
+	}
+
+	return ret;
+}
+
+int sd_zbc_setup_open_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	sector_t nr_sects = blk_rq_sectors(rq);
+	struct blk_zone *zone = NULL;
+	int ret = BLKPREP_OK;
+
+	if (nr_sects) {
+		zone = blk_lookup_zone(rq->q, sector);
+		if (!zone)
+			return BLKPREP_KILL;
+	}
+
+	if (zone) {
+
+		blk_lock_zone(zone);
+
+		/* If the zone is being updated, wait */
+		if (blk_zone_in_update(zone)) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+
+		if (zone->type == BLK_ZONE_TYPE_UNKNOWN) {
+			sd_zbc_debug(sdkp,
+				     "Opening unknown zone %zu\n",
+				     zone->start);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+		/*
+		 * Nothing to do for conventional zones,
+		 * zones already open or full zones.
+		 */
+		if (blk_zone_is_conv(zone) ||
+		    blk_zone_is_open(zone) ||
+		    blk_zone_is_full(zone)) {
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+
+		if (sector != zone->start ||
+		    (nr_sects != zone->len)) {
+			sd_printk(KERN_ERR, sdkp,
+				  "Unaligned open zone request, start %zu/%zu"
+				  " len %zu/%zu\n",
+				  zone->start, sector, zone->len, nr_sects);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+	}
+
+	sd_zbc_setup_action_cmnd(cmd, ZO_OPEN_ZONE, !zone);
+
+out:
+	if (zone) {
+		if (ret == BLKPREP_OK)
+			/*
+			 * Opportunistic update. Will be fixed up
+			 * with zone update if the command fails.
+			 */
+			zone->cond = BLK_ZONE_COND_EXP_OPEN;
+		blk_unlock_zone(zone);
+	}
+
+	return ret;
+}
+
+int sd_zbc_setup_close_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	sector_t nr_sects = blk_rq_sectors(rq);
+	struct blk_zone *zone = NULL;
+	int ret = BLKPREP_OK;
+
+	if (nr_sects) {
+		zone = blk_lookup_zone(rq->q, sector);
+		if (!zone)
+			return BLKPREP_KILL;
+	}
+
+	if (zone) {
+
+		blk_lock_zone(zone);
+
+		/* If the zone is being updated, wait */
+		if (blk_zone_in_update(zone)) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+
+		if (zone->type == BLK_ZONE_TYPE_UNKNOWN) {
+			sd_zbc_debug(sdkp,
+				     "Closing unknown zone %zu\n",
+				     zone->start);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+		/*
+		 * Nothing to do for conventional zones,
+		 * full zones or empty zones.
+		 */
+		if (blk_zone_is_conv(zone) ||
+		    blk_zone_is_full(zone) ||
+		    blk_zone_is_empty(zone)) {
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+
+		if (sector != zone->start ||
+		    (nr_sects != zone->len)) {
+			sd_printk(KERN_ERR, sdkp,
+				  "Unaligned close zone request, start %zu/%zu"
+				  " len %zu/%zu\n",
+				  zone->start, sector, zone->len, nr_sects);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+	}
+
+	sd_zbc_setup_action_cmnd(cmd, ZO_CLOSE_ZONE, !zone);
+
+out:
+	if (zone) {
+		if (ret == BLKPREP_OK)
+			/*
+			 * Opportunistic update. Will be fixed up
+			 * with zone update if the command fails.
+			 */
+			zone->cond = BLK_ZONE_COND_CLOSED;
+		blk_unlock_zone(zone);
+	}
+
+	return ret;
+}
+
+int sd_zbc_setup_finish_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	sector_t nr_sects = blk_rq_sectors(rq);
+	struct blk_zone *zone = NULL;
+	int ret = BLKPREP_OK;
+
+	if (nr_sects) {
+		zone = blk_lookup_zone(rq->q, sector);
+		if (!zone)
+			return BLKPREP_KILL;
+	}
+
+	if (zone) {
+
+		blk_lock_zone(zone);
+
+		/* If the zone is being updated, wait */
+		if (blk_zone_in_update(zone)) {
+			ret = BLKPREP_DEFER;
+			goto out;
+		}
+
+		if (zone->type == BLK_ZONE_TYPE_UNKNOWN) {
+			sd_zbc_debug(sdkp,
+				     "Finishing unknown zone %zu\n",
+				     zone->start);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+		/* Nothing to do for conventional zones and full zones */
+		if (blk_zone_is_conv(zone) ||
+		    blk_zone_is_full(zone)) {
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+
+		if (sector != zone->start ||
+		    (nr_sects != zone->len)) {
+			sd_printk(KERN_ERR, sdkp,
+				  "Unaligned finish zone request, start %zu/%zu"
+				  " len %zu/%zu\n",
+				  zone->start, sector, zone->len, nr_sects);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+
+	}
+
+	sd_zbc_setup_action_cmnd(cmd, ZO_FINISH_ZONE, !zone);
+
+out:
+	if (zone) {
+		if (ret == BLKPREP_OK) {
+			/*
+			 * Opportunistic update. Will be fixed up
+			 * with zone update if the command fails.
+			 */
+			zone->cond = BLK_ZONE_COND_FULL;
+			if (blk_zone_is_seq(zone))
+				zone->wp = zone->start + zone->len;
+		}
+		blk_unlock_zone(zone);
+	}
+
+	return ret;
+}
+
+int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
+			    sector_t sector, unsigned int *num_sectors)
+{
+	struct blk_zone *zone;
+	unsigned int sectors = *num_sectors;
+	int ret = BLKPREP_OK;
+
+	zone = blk_lookup_zone(rq->q, sector);
+	if (!zone)
+		/* Let the drive handle the request */
+		return BLKPREP_OK;
+
+	blk_lock_zone(zone);
+
+	/* If the zone is being updated, wait */
+	if (blk_zone_in_update(zone)) {
+		ret = BLKPREP_DEFER;
+		goto out;
+	}
+
+	if (zone->type == BLK_ZONE_TYPE_UNKNOWN) {
+		sd_zbc_debug(sdkp,
+			     "Unknown zone %zu\n",
+			     zone->start);
+		ret = BLKPREP_KILL;
+		goto out;
+	}
+
+	/* For offline and read-only zones, let the drive fail the command */
+	if (blk_zone_is_offline(zone) ||
+	    blk_zone_is_readonly(zone))
+		goto out;
+
+	/* Do not allow zone boundaries crossing */
+	if (sector + sectors > zone->start + zone->len) {
+		ret = BLKPREP_KILL;
+		goto out;
+	}
+
+	/* For conventional zones, no checks */
+	if (blk_zone_is_conv(zone))
+		goto out;
+
+	if (req_op(rq) == REQ_OP_WRITE ||
+	    req_op(rq) == REQ_OP_WRITE_SAME) {
+
+		/*
+		 * Write requests may change the write pointer and
+		 * transition the zone condition to full. Changes
+		 * are oportunistic here. If the request fails, a
+		 * zone update will fix the zone information.
+		 */
+		if (blk_zone_is_seq_req(zone)) {
+
+			/*
+			 * Do not issue more than one write at a time per
+			 * zone. This solves write ordering problems due to
+			 * the unlocking of the request queue in the dispatch
+			 * path in the non scsi-mq case. For scsi-mq, this
+			 * also avoids potential write reordering when multiple
+			 * threads running on different CPUs write to the same
+			 * zone (with a synchronized sequential pattern).
+			 */
+			if (!blk_try_write_lock_zone(zone)) {
+				ret = BLKPREP_DEFER;
+				goto out;
+			}
+
+			/* For host-managed drives, writes are allowed */
+			/* only at the write pointer position.         */
+			if (zone->wp != sector) {
+				blk_write_unlock_zone(zone);
+				ret = BLKPREP_KILL;
+				goto out;
+			}
+
+			zone->wp += sectors;
+			if (zone->wp >= zone->start + zone->len) {
+				zone->cond = BLK_ZONE_COND_FULL;
+				zone->wp = zone->start + zone->len;
+			}
+
+		} else {
+
+			/* For host-aware drives, writes are allowed */
+			/* anywhere in the zone, but wp can only go  */
+			/* forward.                                  */
+			sector_t end_sector = sector + sectors;
+			if (sector == zone->wp &&
+			    end_sector >= zone->start + zone->len) {
+				zone->cond = BLK_ZONE_COND_FULL;
+				zone->wp = zone->start + zone->len;
+			} else if (end_sector > zone->wp) {
+				zone->wp = end_sector;
+			}
+
+		}
+
+	} else {
+
+		/* Check read after write pointer */
+		if (sector + sectors <= zone->wp)
+			goto out;
+
+		if (zone->wp <= sector) {
+			/* Read beyond WP: clear request buffer */
+			struct req_iterator iter;
+			struct bio_vec bvec;
+			unsigned long flags;
+			void *buf;
+			rq_for_each_segment(bvec, rq, iter) {
+				buf = bvec_kmap_irq(&bvec, &flags);
+				memset(buf, 0, bvec.bv_len);
+				flush_dcache_page(bvec.bv_page);
+				bvec_kunmap_irq(buf, &flags);
+			}
+			ret = BLKPREP_DONE;
+			goto out;
+		}
+
+		/* Read straddle WP position: limit request size */
+		*num_sectors = zone->wp - sector;
+
+	}
+
+out:
+	blk_unlock_zone(zone);
+
+	return ret;
+}
+
+void sd_zbc_done(struct scsi_cmnd *cmd,
+		 struct scsi_sense_hdr *sshdr)
+{
+	int result = cmd->result;
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct request_queue *q = sdkp->disk->queue;
+	sector_t pos = blk_rq_pos(rq);
+	struct blk_zone *zone = NULL;
+	bool write_unlock = false;
+
+	/*
+	 * Get the target zone of commands of interest. Some may
+	 * apply to all zones so check the request sectors first.
+	 */
+	switch (req_op(rq)) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_ZONE_RESET:
+		write_unlock = true;
+		/* fallthru */
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+		if (blk_rq_sectors(rq))
+			zone = blk_lookup_zone(q, pos);
+		break;
+	}
+
+	if (zone && write_unlock)
+	    blk_write_unlock_zone(zone);
+
+	if (!result)
+		return;
+
+	if (sshdr->sense_key == ILLEGAL_REQUEST &&
+	    sshdr->asc == 0x21)
+		/*
+		 * It is unlikely that retrying requests failed with any
+		 * kind of alignement error will result in success. So don't
+		 * try. Report the error back to the user quickly so that
+		 * corrective actions can be taken after obtaining updated
+		 * zone information.
+		 */
+		cmd->allowed = 0;
+
+	/* On error, force an update unless this is a failed report */
+	if (req_op(rq) == REQ_OP_ZONE_REPORT)
+		sd_zbc_clear_zones_updating(sdkp, pos, blk_rq_sectors(rq));
+	else if (zone)
+		sd_zbc_update_zones(sdkp, zone->start, zone->len,
+				    GFP_ATOMIC, false);
+}
+
+void sd_zbc_read_zones(struct scsi_disk *sdkp, char *buf)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	struct blk_zone *zone;
+	sector_t capacity;
+	sector_t sector;
+	bool init = false;
+	u32 rep_len;
+	int ret = 0;
+
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
+		/*
+		 * Device managed or normal SCSI disk,
+		 * no special handling required
+		 */
+		return;
+
+	/* Do a report zone to get the maximum LBA to check capacity */
+	ret = sd_zbc_report_zones(sdkp, buf, SD_BUF_SIZE,
+				  0, ZBC_ZONE_REPORTING_OPTION_ALL, false);
+	if (ret < 0)
+		return;
+
+	rep_len = get_unaligned_be32(&buf[0]);
+	if (rep_len < 64) {
+		sd_printk(KERN_WARNING, sdkp,
+			  "REPORT ZONES report invalid length %u\n",
+			  rep_len);
+		return;
+	}
+
+	if (sdkp->rc_basis == 0) {
+		/* The max_lba field is the capacity of this device */
+		sector_t lba = get_unaligned_be64(&buf[8]);
+		if (lba + 1 > sdkp->capacity) {
+			if (sdkp->first_scan)
+				sd_printk(KERN_WARNING, sdkp,
+					  "Changing capacity from %zu "
+					  "to max LBA+1 %zu\n",
+					  sdkp->capacity,
+					  (sector_t) lba + 1);
+			sdkp->capacity = lba + 1;
+		}
+	}
+
+	/* Setup the zone work queue */
+	if (! sdkp->zone_work_q) {
+		sdkp->zone_work_q =
+			alloc_ordered_workqueue("zbc_wq_%s", WQ_MEM_RECLAIM,
+						sdkp->disk->disk_name);
+		if (!sdkp->zone_work_q) {
+			sdev_printk(KERN_WARNING, sdkp->device,
+				    "Create zoned disk workqueue failed\n");
+			return;
+		}
+		init = true;
+	}
+
+	/*
+	 * Parse what we already got. If all zones are not parsed yet,
+	 * kick start an update to get the remaining.
+	 */
+	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
+	ret = zbc_parse_zones(sdkp, buf, SD_BUF_SIZE, &sector);
+	if (ret == 0 && sector < capacity) {
+		sd_zbc_update_zones(sdkp, sector, capacity - sector,
+				    GFP_KERNEL, init);
+		drain_workqueue(sdkp->zone_work_q);
+	}
+	if (ret)
+		return;
+
+	/*
+	 * Analyze the zones layout: if all zones are the same size and
+	 * the size is a power of 2, chunk the device and map discard to
+	 * reset write pointer command. Otherwise, disable discard.
+	 */
+	sdkp->zone_sectors = 0;
+	sdkp->nr_zones = 0;
+	sector = 0;
+	while(sector < capacity) {
+
+		zone = blk_lookup_zone(q, sector);
+		if (!zone) {
+			sdkp->zone_sectors = 0;
+			sdkp->nr_zones = 0;
+			break;
+		}
+
+		sector += zone->len;
+
+		if (sdkp->zone_sectors == 0) {
+			sdkp->zone_sectors = zone->len;
+		} else if (sector != capacity &&
+			 zone->len != sdkp->zone_sectors) {
+			sdkp->zone_sectors = 0;
+			sdkp->nr_zones = 0;
+			break;
+		}
+
+		sdkp->nr_zones++;
+
+	}
+
+	if (!sdkp->zone_sectors ||
+	    !is_power_of_2(sdkp->zone_sectors)) {
+		sd_config_discard(sdkp, SD_LBP_DISABLE);
+		if (sdkp->first_scan)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%u zones (non constant zone size)\n",
+				  sdkp->nr_zones);
+		return;
+	}
+
+	/* Setup discard granularity to the zone size */
+	blk_queue_chunk_sectors(sdkp->disk->queue, sdkp->zone_sectors);
+	sdkp->max_unmap_blocks = sdkp->zone_sectors;
+	sdkp->unmap_alignment = sectors_to_logical(sdkp->device,
+						   sdkp->zone_sectors);
+	sdkp->unmap_granularity = sdkp->unmap_alignment;
+	sd_config_discard(sdkp, SD_ZBC_RESET_WP);
+
+	if (sdkp->first_scan) {
+		if (sdkp->nr_zones * sdkp->zone_sectors == capacity)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%u zones of %zu sectors\n",
+				  sdkp->nr_zones,
+				  sdkp->zone_sectors);
+		else
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%u zones of %zu sectors "
+				  "+ 1 runt zone\n",
+				  sdkp->nr_zones - 1,
+				  sdkp->zone_sectors);
+	}
+}
+
+void sd_zbc_remove(struct scsi_disk *sdkp)
+{
+
+	sd_config_discard(sdkp, SD_LBP_DISABLE);
+
+	if (sdkp->zone_work_q) {
+		drain_workqueue(sdkp->zone_work_q);
+		destroy_workqueue(sdkp->zone_work_q);
+		sdkp->zone_work_q = NULL;
+		blk_drop_zones(sdkp->disk->queue);
+	}
+}
+
diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index d1defd1..6ba66e0 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -299,4 +299,21 @@ struct scsi_lun {
 #define SCSI_ACCESS_STATE_MASK        0x0f
 #define SCSI_ACCESS_STATE_PREFERRED   0x80
 
+/* Reporting options for REPORT ZONES */
+enum zbc_zone_reporting_options {
+	ZBC_ZONE_REPORTING_OPTION_ALL = 0,
+	ZBC_ZONE_REPORTING_OPTION_EMPTY,
+	ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN,
+	ZBC_ZONE_REPORTING_OPTION_CLOSED,
+	ZBC_ZONE_REPORTING_OPTION_FULL,
+	ZBC_ZONE_REPORTING_OPTION_READONLY,
+	ZBC_ZONE_REPORTING_OPTION_OFFLINE,
+	ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP = 0x10,
+	ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE,
+	ZBC_ZONE_REPORTING_OPTION_NON_WP = 0x3f,
+};
+
+#define ZBC_REPORT_ZONE_PARTIAL 0x80
+
 #endif /* _SCSI_PROTO_H_ */
-- 
2.7.4

