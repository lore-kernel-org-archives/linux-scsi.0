From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 2/2] Enable support for Seagate HostAware drives (testing).
Date: Wed,  3 Aug 2016 14:06:45 -0500
Message-ID: <1470251205-4916-3-git-send-email-shaun@tancheff.com>
References: <1470251205-4916-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470251205-4916-1-git-send-email-shaun@tancheff.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Josh Bingaman <josh.bingaman@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@hgst.com>
List-Id: linux-scsi@vger.kernel.org

Seagate drives report a SAME code of 0 due to having:
  - Zones of different types (CMR zones at the low LBA space).
  - Zones of different size (A terminating 'runt' zone in the high lba space).

Support loading the zone topology into the sd_zbc zone cache.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>

Cc: Hannes Reinecke <hare@suse.de>
Cc: Damien Le Moal <damien.lemoal@hgst.com>
---
v1:
 - Updated kernel version / re-sync with Hannes' zac.v3 branch.
---
 drivers/scsi/sd.c     |  22 ++++----
 drivers/scsi/sd.h     |  20 +++++--
 drivers/scsi/sd_zbc.c | 150 ++++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 155 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7c38975..5fbc599 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -694,8 +694,13 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 
 	case SD_ZBC_RESET_WP:
-		max_blocks = sdkp->unmap_granularity;
 		q->limits.discard_zeroes_data = 1;
+		q->limits.discard_granularity =
+			sd_zbc_discard_granularity(sdkp);
+
+		max_blocks = min_not_zero(sdkp->unmap_granularity,
+					  q->limits.discard_granularity >>
+						ilog2(logical_block_size));
 		break;
 
 	case SD_LBP_ZERO:
@@ -1952,13 +1957,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
 		} else {
-#ifdef CONFIG_SCSI_ZBC
 			if (op == ZBC_OUT)
 				/* RESET WRITE POINTER failed */
 				sd_zbc_update_zones(sdkp,
 						    blk_rq_pos(req),
-						    512, true);
-#endif
+						    512, SD_ZBC_RESET_WP_ERR);
+
 			good_bytes = 0;
 			scsi_set_resid(SCpnt, blk_rq_bytes(req));
 		}
@@ -2031,7 +2035,6 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 				good_bytes = blk_rq_bytes(req);
 				scsi_set_resid(SCpnt, 0);
 			}
-#ifdef CONFIG_SCSI_ZBC
 			/*
 			 * ZBC: Unaligned write command.
 			 * Write did not start a write pointer position.
@@ -2039,8 +2042,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			if (sshdr.ascq == 0x04)
 				sd_zbc_update_zones(sdkp,
 						    blk_rq_pos(req),
-						    512, true);
-#endif
+						    512, SD_ZBC_WRITE_ERR);
 		}
 		break;
 	default:
@@ -2267,7 +2269,7 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 	 * supports equal zone sizes.
 	 */
 	same = buffer[4] & 0xf;
-	if (same == 0 || same > 3) {
+	if (same > 3) {
 		sd_printk(KERN_WARNING, sdkp,
 			  "REPORT ZONES SAME type %d not supported\n", same);
 		return;
@@ -2279,9 +2281,9 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 	sdkp->unmap_granularity = zone_len;
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 				logical_to_sectors(sdkp->device, zone_len));
-	sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 
-	sd_zbc_setup(sdkp, buffer, SD_BUF_SIZE);
+	sd_zbc_setup(sdkp, zone_len, buffer, SD_BUF_SIZE);
+	sd_config_discard(sdkp, SD_ZBC_RESET_WP);
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 6ae4505..ef6c132 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -283,19 +283,24 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+
+#define SD_ZBC_INIT		0
+#define SD_ZBC_RESET_WP_ERR	1
+#define SD_ZBC_WRITE_ERR	2
+
 #ifdef CONFIG_SCSI_ZBC
 
 extern int sd_zbc_report_zones(struct scsi_disk *, unsigned char *, int,
 			       sector_t, enum zbc_zone_reporting_options, bool);
-extern int sd_zbc_setup(struct scsi_disk *, char *, int);
+extern int sd_zbc_setup(struct scsi_disk *, u64 zlen, char *buf, int buf_len);
 extern void sd_zbc_remove(struct scsi_disk *);
 extern void sd_zbc_reset_zones(struct scsi_disk *);
 extern int sd_zbc_setup_discard(struct scsi_disk *, struct request *,
 				sector_t, unsigned int);
 extern int sd_zbc_setup_read_write(struct scsi_disk *, struct request *,
 				   sector_t, unsigned int *);
-extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, bool);
-extern void sd_zbc_refresh_zone_work(struct work_struct *);
+extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, int reason);
+extern unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp);
 
 #else /* CONFIG_SCSI_ZBC */
 
@@ -308,7 +313,7 @@ static inline int sd_zbc_report_zones(struct scsi_disk *sdkp,
 	return -EOPNOTSUPP;
 }
 
-static inline int sd_zbc_setup(struct scsi_disk *sdkp,
+static inline int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen,
 			       unsigned char *buf, int buf_len)
 {
 	return 0;
@@ -328,6 +333,13 @@ static inline int sd_zbc_setup_read_write(struct scsi_disk *sdkp,
 	return BLKPREP_OK;
 }
 
+static inline unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp)
+{
+	return sdkp->device->sector_size;
+}
+
+static inline void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t s,
+				       int buf_sz, int reason) {}
 static inline void sd_zbc_remove(struct scsi_disk *sdkp) {}
 #endif /* CONFIG_SCSI_ZBC */
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index f953d16..91f4437 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -69,6 +69,7 @@ struct zbc_update_work {
 	char		zone_buf[0];
 };
 
+static
 struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
 {
 	struct blk_zone *zone;
@@ -122,7 +123,8 @@ struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
 	return zone;
 }
 
-sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
+static
+sector_t zbc_parse_zones(struct scsi_disk *sdkp, u64 zlen, unsigned char *buf,
 			 unsigned int buf_len)
 {
 	struct request_queue *q = sdkp->disk->queue;
@@ -149,6 +151,11 @@ sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
 		if (!this)
 			break;
 
+		if (same == 0 && this->len != zlen) {
+			next_sector = this->start + this->len;
+			break;
+		}
+
 		next_sector = this->start + this->len;
 		old = blk_insert_zone(q, this);
 		if (old) {
@@ -171,29 +178,58 @@ sector_t zbc_parse_zones(struct scsi_disk *sdkp, unsigned char *buf,
 	return next_sector;
 }
 
-void sd_zbc_refresh_zone_work(struct work_struct *work)
+static void sd_zbc_refresh_zone_work(struct work_struct *work)
 {
 	struct zbc_update_work *zbc_work =
 		container_of(work, struct zbc_update_work, zone_work);
 	struct scsi_disk *sdkp = zbc_work->sdkp;
 	struct request_queue *q = sdkp->disk->queue;
-	unsigned int zone_buflen;
+	unsigned char *zone_buf = zbc_work->zone_buf;
+	unsigned int zone_buflen = zbc_work->zone_buflen;
 	int ret;
+	u8 same;
+	u64 zlen = 0;
 	sector_t last_sector;
 	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 
-	zone_buflen = zbc_work->zone_buflen;
-	ret = sd_zbc_report_zones(sdkp, zbc_work->zone_buf, zone_buflen,
+	ret = sd_zbc_report_zones(sdkp, zone_buf, zone_buflen,
 				  zbc_work->zone_sector,
 				  ZBC_ZONE_REPORTING_OPTION_ALL, true);
 	if (ret)
 		goto done_free;
 
-	last_sector = zbc_parse_zones(sdkp, zbc_work->zone_buf, zone_buflen);
+	/* this whole path is unlikely so extra reports shouldn't be a
+	 * large impact */
+	same = zone_buf[4] & 0xf;
+	if (same == 0) {
+		unsigned char *desc = &zone_buf[64];
+		unsigned int blen = zone_buflen;
+
+		/* just pull the first zone */
+		if (blen > 512)
+			blen = 512;
+		ret = sd_zbc_report_zones(sdkp, zone_buf, blen, 0,
+					  ZBC_ZONE_REPORTING_OPTION_ALL, true);
+		if (ret)
+			goto done_free;
+
+		/* Read the zone length from the first zone descriptor */
+		zlen = logical_to_sectors(sdkp->device,
+					  get_unaligned_be64(&desc[8]));
+
+		ret = sd_zbc_report_zones(sdkp, zone_buf, zone_buflen,
+					  zbc_work->zone_sector,
+					  ZBC_ZONE_REPORTING_OPTION_ALL, true);
+		if (ret)
+			goto done_free;
+	}
+
+	last_sector = zbc_parse_zones(sdkp, zlen, zone_buf, zone_buflen);
+	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	if (last_sector != -1 && last_sector < capacity) {
 		if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
 			sd_zbc_debug(sdkp,
-				     "zones in reset, cancelling refresh\n");
+				     "zones in reset, canceling refresh\n");
 			ret = -EAGAIN;
 			goto done_free;
 		}
@@ -207,7 +243,7 @@ done_free:
 	kfree(zbc_work);
 	if (test_and_clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags) && ret) {
 		sd_zbc_debug(sdkp,
-			     "Cancelling zone initialisation\n");
+			     "Canceling zone initialization\n");
 	}
 done_start_queue:
 	if (q->mq_ops)
@@ -226,10 +262,10 @@ done_start_queue:
  * @sdkp: SCSI disk for which the zone information needs to be updated
  * @sector: sector to be updated
  * @bufsize: buffersize to be allocated
- * @update: true if existing zones should be updated
+ * @reason: non-zero if existing zones should be updated
  */
 void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
-			 bool update)
+			 int reason)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	struct zbc_update_work *zbc_work;
@@ -240,13 +276,24 @@ void sd_zbc_update_zones(struct scsi_disk *sdkp, sector_t sector, int bufsize,
 
 	if (test_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags)) {
 		sd_zbc_debug(sdkp,
-			     "zones in reset, not starting update\n");
+			     "zones in reset, not starting reason\n");
 		return;
 	}
 
+	if (reason != SD_ZBC_INIT) {
+		/* lookup sector, is zone pref? then ignore */
+		struct blk_zone *zone = blk_lookup_zone(q, sector);
+
+		if (reason == SD_ZBC_RESET_WP)
+			sd_zbc_debug(sdkp, "RESET WP failed %lx\n", sector);
+
+		if (zone && blk_zone_is_seq_pref(zone))
+			return;
+	}
+
 retry:
 	zbc_work = kzalloc(sizeof(struct zbc_update_work) + bufsize,
-			   update ? GFP_NOWAIT : GFP_KERNEL);
+			   reason != SD_ZBC_INIT ? GFP_NOWAIT : GFP_KERNEL);
 	if (!zbc_work) {
 		if (bufsize > 512) {
 			sd_zbc_debug(sdkp,
@@ -256,7 +303,7 @@ retry:
 		}
 		sd_zbc_debug(sdkp,
 			     "failed to allocate %d bytes\n", bufsize);
-		if (!update)
+		if (reason == SD_ZBC_INIT)
 			clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
 		return;
 	}
@@ -269,7 +316,7 @@ retry:
 	/*
 	 * Mark zones under update as BUSY
 	 */
-	if (update) {
+	if (reason != SD_ZBC_INIT) {
 		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
 			unsigned long flags;
 
@@ -333,8 +380,7 @@ int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n",
-		     start_lba, bufflen);
+	sd_zbc_debug(sdkp, "REPORT ZONES lba %zu len %d\n", start_lba, bufflen);
 
 	memset(cmd, 0, 16);
 	cmd[0] = ZBC_IN;
@@ -460,8 +506,36 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 		goto out;
 	}
 
-	if (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_WRITE_SAME) {
-		if (zone->type != BLK_ZONE_TYPE_SEQWRITE_REQ)
+	if (blk_zone_is_cmr(zone))
+		goto out;
+
+	if (blk_zone_is_seq_pref(zone) && op_is_write(req_op(rq))) {
+		u64 nwp = sector + sectors;
+
+		while (nwp > (zone->start + zone->len)) {
+			struct rb_node *node = rb_next(&zone->node);
+
+			zone->wp = zone->start + zone->len;
+			sector = zone->wp;
+			sectors = nwp - zone->wp;
+			spin_unlock_irqrestore(&zone->lock, flags);
+
+			if (!node)
+				return BLKPREP_OK;
+			zone = rb_entry(node, struct blk_zone, node);
+			if (!zone)
+				return BLKPREP_OK;
+
+			spin_lock_irqsave(&zone->lock, flags);
+			nwp = sector + sectors;
+		}
+		if (nwp > zone->wp)
+			zone->wp = nwp;
+		goto out;
+	}
+
+	if (op_is_write(req_op(rq))) {
+		if (!blk_zone_is_seq_req(zone))
 			goto out;
 		if (zone->state == BLK_ZONE_READONLY)
 			goto out;
@@ -480,7 +554,7 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 			goto out;
 		}
 		zone->wp += sectors;
-	} else if (zone->type == BLK_ZONE_TYPE_SEQWRITE_REQ &&
+	} else if (blk_zone_is_seq_req(zone) &&
 		   zone->wp <= sector + sectors) {
 		if (zone->wp <= sector) {
 			/* Read beyond WP: clear request buffer */
@@ -513,14 +587,18 @@ out:
 	return ret;
 }
 
-int sd_zbc_setup(struct scsi_disk *sdkp, char *buf, int buf_len)
+/**
+ * sd_zbc_setup - Load zones of matching zlen size into rb tree.
+ *
+ */
+int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen, char *buf, int buf_len)
 {
 	sector_t capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	sector_t last_sector;
 
 	if (test_and_set_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags)) {
 		sdev_printk(KERN_WARNING, sdkp->device,
-			    "zone initialisation already running\n");
+			    "zone initialization already running\n");
 		return 0;
 	}
 
@@ -539,15 +617,20 @@ int sd_zbc_setup(struct scsi_disk *sdkp, char *buf, int buf_len)
 		clear_bit(SD_ZBC_ZONE_RESET, &sdkp->zone_flags);
 	}
 
-	last_sector = zbc_parse_zones(sdkp, buf, buf_len);
+	last_sector = zbc_parse_zones(sdkp, zlen, buf, buf_len);
+	capacity = logical_to_sectors(sdkp->device, sdkp->capacity);
 	if (last_sector != -1 && last_sector < capacity) {
-		sd_zbc_update_zones(sdkp, last_sector, SD_ZBC_BUF_SIZE, false);
+		sd_zbc_update_zones(sdkp, last_sector,
+				    SD_ZBC_BUF_SIZE, SD_ZBC_INIT);
 	} else
 		clear_bit(SD_ZBC_ZONE_INIT, &sdkp->zone_flags);
 
 	return 0;
 }
 
+/**
+ * sd_zbc_remove -
+ */
 void sd_zbc_remove(struct scsi_disk *sdkp)
 {
 	if (sdkp->zone_work_q) {
@@ -557,3 +640,24 @@ void sd_zbc_remove(struct scsi_disk *sdkp)
 		destroy_workqueue(sdkp->zone_work_q);
 	}
 }
+/**
+ * sd_zbc_discard_granularity - Determine discard granularity.
+ * @sdkp: SCSI disk used to calculate discard granularity.
+ *
+ * Discard granularity should match the (maximum non-CMR) zone
+ * size reported on the drive.
+ */
+unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp)
+{
+	unsigned int bytes = 1;
+	struct request_queue *q = sdkp->disk->queue;
+	struct rb_node *node = rb_first(&q->zones);
+
+	if (node) {
+		struct blk_zone *zone = rb_entry(node, struct blk_zone, node);
+
+		bytes = zone->len;
+	}
+	bytes <<= ilog2(sdkp->device->sector_size);
+	return bytes;
+}
-- 
2.8.1
