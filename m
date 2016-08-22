From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 2/4] On Discard either do Reset WP or Write Same
Date: Sun, 21 Aug 2016 23:31:14 -0500
Message-ID: <20160822043116.21168-3-shaun@tancheff.com>
References: <20160822043116.21168-1-shaun@tancheff.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160822043116.21168-1-shaun@tancheff.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Based on the type of zone either perform a Reset WP
for Sequential zones or a Write Same for Conventional zones.

Also detect and handle the runt zone, if there is one.

One additional check is added to error on discard requests
that do not include all the active data in zone.
By way of example when the WP indicates that 2000 blocks
in the zone are in use and the discard indicated 1000 blocks
can be unmapped the discard should fail as a Reset WP will
unmap all the 2000 blocks in the zone.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/scsi/sd.c     |  45 ++++++-----------
 drivers/scsi/sd.h     |   9 ++--
 drivers/scsi/sd_zbc.c | 135 +++++++++++++++++++++++++++++++++++---------------
 3 files changed, 114 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7903e21..d5ef6d8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -729,21 +729,19 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	sector_t sector = blk_rq_pos(rq);
 	unsigned int nr_sectors = blk_rq_sectors(rq);
 	unsigned int nr_bytes = blk_rq_bytes(rq);
-	unsigned int len;
-	int ret = 0;
+	int ret;
 	char *buf;
-	struct page *page = NULL;
+	struct page *page;
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 
-	if (sdkp->provisioning_mode != SD_ZBC_RESET_WP) {
-		page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
-		if (!page)
-			return BLKPREP_DEFER;
-	}
+	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!page)
+		return BLKPREP_DEFER;
 
 	rq->completion_data = page;
+	rq->timeout = SD_TIMEOUT;
 
 	switch (sdkp->provisioning_mode) {
 	case SD_LBP_UNMAP:
@@ -758,7 +756,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		put_unaligned_be64(sector, &buf[8]);
 		put_unaligned_be32(nr_sectors, &buf[16]);
 
-		len = 24;
+		cmd->transfersize = 24;
 		break;
 
 	case SD_LBP_WS16:
@@ -768,7 +766,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		put_unaligned_be64(sector, &cmd->cmnd[2]);
 		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
 
-		len = sdkp->device->sector_size;
+		cmd->transfersize = sdp->sector_size;
 		break;
 
 	case SD_LBP_WS10:
@@ -777,35 +775,24 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		cmd->cmnd[0] = WRITE_SAME;
 		if (sdkp->provisioning_mode == SD_LBP_WS10)
 			cmd->cmnd[1] = 0x8; /* UNMAP */
+		else
+			rq->timeout = SD_WRITE_SAME_TIMEOUT;
 		put_unaligned_be32(sector, &cmd->cmnd[2]);
 		put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
 
-		len = sdkp->device->sector_size;
+		cmd->transfersize = sdp->sector_size;
 		break;
 
 	case SD_ZBC_RESET_WP:
-		/* sd_zbc_setup_discard uses block layer sector units */
-		ret = sd_zbc_setup_discard(sdkp, rq, blk_rq_pos(rq),
-					   blk_rq_sectors(rq));
+		ret = sd_zbc_setup_discard(cmd);
 		if (ret != BLKPREP_OK)
 			goto out;
-		cmd->cmd_len = 16;
-		cmd->cmnd[0] = ZBC_OUT;
-		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
-		put_unaligned_be64(sector, &cmd->cmnd[2]);
-		/* Reset Write Pointer doesn't have a payload */
-		len = 0;
-		cmd->sc_data_direction = DMA_NONE;
 		break;
-
 	default:
 		ret = BLKPREP_INVALID;
 		goto out;
 	}
 
-	rq->timeout = SD_TIMEOUT;
-
-	cmd->transfersize = len;
 	cmd->allowed = SD_MAX_RETRIES;
 
 	/*
@@ -816,17 +803,15 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	 * discarded on disk. This allows us to report completion on the full
 	 * amount of blocks described by the request.
 	 */
-	if (len) {
-		blk_add_request_payload(rq, page, 0, len);
+	if (cmd->transfersize) {
+		blk_add_request_payload(rq, page, 0, cmd->transfersize);
 		ret = scsi_init_io(cmd);
 	}
 	rq->__data_len = nr_bytes;
 
 out:
-	if (page && ret != BLKPREP_OK) {
-		rq->completion_data = NULL;
+	if (ret != BLKPREP_OK)
 		__free_page(page);
-	}
 	return ret;
 }
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index ef6c132..2792c10 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -295,8 +295,7 @@ extern int sd_zbc_report_zones(struct scsi_disk *, unsigned char *, int,
 extern int sd_zbc_setup(struct scsi_disk *, u64 zlen, char *buf, int buf_len);
 extern void sd_zbc_remove(struct scsi_disk *);
 extern void sd_zbc_reset_zones(struct scsi_disk *);
-extern int sd_zbc_setup_discard(struct scsi_disk *, struct request *,
-				sector_t, unsigned int);
+extern int sd_zbc_setup_discard(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_read_write(struct scsi_disk *, struct request *,
 				   sector_t, unsigned int *);
 extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, int reason);
@@ -319,11 +318,9 @@ static inline int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen,
 	return 0;
 }
 
-static inline int sd_zbc_setup_discard(struct scsi_disk *sdkp,
-				       struct request *rq, sector_t sector,
-				       unsigned int num_sectors)
+static inline int int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
 {
-	return BLKPREP_OK;
+	return BLKPREP_KILL;
 }
 
 static inline int sd_zbc_setup_read_write(struct scsi_disk *sdkp,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 17414fb..0780118 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -382,23 +382,45 @@ int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
 	return 0;
 }
 
-int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
-			 sector_t sector, unsigned int num_sectors)
+int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
 {
-	struct blk_zone *zone;
+	struct request *rq = cmd->request;
+	struct scsi_device *sdp = cmd->device;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	unsigned int nr_sectors = blk_rq_sectors(rq);
 	int ret = BLKPREP_OK;
+	struct blk_zone *zone;
 	unsigned long flags;
+	u32 wp_offset;
+	bool use_write_same = false;
 
 	zone = blk_lookup_zone(rq->q, sector);
-	if (!zone)
+	if (!zone) {
+		/* Test for a runt zone before giving up */
+		if (sdp->type != TYPE_ZBC) {
+			struct request_queue *q = rq->q;
+			struct rb_node *node;
+
+			node = rb_last(&q->zones);
+			if (node)
+				zone = rb_entry(node, struct blk_zone, node);
+			if (zone) {
+				spin_lock_irqsave(&zone->lock, flags);
+				if ((zone->start + zone->len) <= sector)
+					goto out;
+				spin_unlock_irqrestore(&zone->lock, flags);
+				zone = NULL;
+			}
+		}
 		return BLKPREP_KILL;
+	}
 
 	spin_lock_irqsave(&zone->lock, flags);
-
 	if (zone->state == BLK_ZONE_UNKNOWN ||
 	    zone->state == BLK_ZONE_BUSY) {
 		sd_zbc_debug_ratelimit(sdkp,
-				       "Discarding zone %zu state %x, deferring\n",
+				       "Discarding zone %zx state %x, deferring\n",
 				       zone->start, zone->state);
 		ret = BLKPREP_DEFER;
 		goto out;
@@ -406,46 +428,80 @@ int sd_zbc_setup_discard(struct scsi_disk *sdkp, struct request *rq,
 	if (zone->state == BLK_ZONE_OFFLINE) {
 		/* let the drive fail the command */
 		sd_zbc_debug_ratelimit(sdkp,
-				       "Discarding offline zone %zu\n",
+				       "Discarding offline zone %zx\n",
 				       zone->start);
 		goto out;
 	}
-
-	if (!blk_zone_is_smr(zone)) {
+	if (blk_zone_is_cmr(zone)) {
+		use_write_same = true;
 		sd_zbc_debug_ratelimit(sdkp,
-				       "Discarding %s zone %zu\n",
-				       blk_zone_is_cmr(zone) ? "CMR" : "unknown",
+				       "Discarding CMR zone %zx\n",
 				       zone->start);
-		ret = BLKPREP_DONE;
 		goto out;
 	}
-	if (blk_zone_is_empty(zone)) {
-		sd_zbc_debug_ratelimit(sdkp,
-				       "Discarding empty zone %zu\n",
-				       zone->start);
-		ret = BLKPREP_DONE;
+	if (zone->start != sector || zone->len < nr_sectors) {
+		sd_printk(KERN_ERR, sdkp,
+			  "Misaligned RESET WP %zx/%x on zone %zx/%zx\n",
+			  sector, nr_sectors, zone->start, zone->len);
+		ret = BLKPREP_KILL;
 		goto out;
 	}
-
-	if (zone->start != sector ||
-	    zone->len < num_sectors) {
+	/* Protect against Reset WP when more data had been written to the
+	 * zone than is being discarded.
+	 */
+	wp_offset = zone->wp - zone->start;
+	if (wp_offset > nr_sectors) {
 		sd_printk(KERN_ERR, sdkp,
-			  "Misaligned RESET WP, start %zu/%zu "
-			  "len %zu/%u\n",
-			  zone->start, sector, zone->len, num_sectors);
+			  "Will Corrupt RESET WP %zx/%x/%x on zone %zx/%zx/%zx\n",
+			  sector, wp_offset, nr_sectors,
+			  zone->start, zone->wp, zone->len);
 		ret = BLKPREP_KILL;
 		goto out;
 	}
-
-	/*
-	 * Opportunistic setting, will be fixed up with
-	 * zone update if RESET WRITE POINTER fails.
-	 */
-	zone->wp = zone->start;
+	if (blk_zone_is_empty(zone)) {
+		sd_zbc_debug_ratelimit(sdkp,
+				       "Discarding empty zone %zx [WP: %zx]\n",
+				       zone->start, zone->wp);
+		ret = BLKPREP_DONE;
+		goto out;
+	}
 
 out:
 	spin_unlock_irqrestore(&zone->lock, flags);
 
+	if (ret != BLKPREP_OK)
+		goto done;
+	/*
+	 * blk_zone cache uses block layer sector units
+	 * but commands use device units
+	 */
+	sector >>= ilog2(sdp->sector_size) - 9;
+	nr_sectors >>= ilog2(sdp->sector_size) - 9;
+
+	if (use_write_same) {
+		cmd->cmd_len = 16;
+		cmd->cmnd[0] = WRITE_SAME_16;
+		cmd->cmnd[1] = 0; /* UNMAP (not set) */
+		put_unaligned_be64(sector, &cmd->cmnd[2]);
+		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
+		cmd->transfersize = sdp->sector_size;
+		rq->timeout = SD_WRITE_SAME_TIMEOUT;
+	} else {
+		cmd->cmd_len = 16;
+		cmd->cmnd[0] = ZBC_OUT;
+		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
+		put_unaligned_be64(sector, &cmd->cmnd[2]);
+		/* Reset Write Pointer doesn't have a payload */
+		cmd->transfersize = 0;
+		cmd->sc_data_direction = DMA_NONE;
+		/*
+		 * Opportunistic setting, will be fixed up with
+		 * zone update if RESET WRITE POINTER fails.
+		 */
+		zone->wp = zone->start;
+	}
+
+done:
 	return ret;
 }
 
@@ -468,6 +524,9 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 
 	spin_lock_irqsave(&zone->lock, flags);
 
+	if (blk_zone_is_cmr(zone))
+		goto out;
+
 	if (zone->state == BLK_ZONE_UNKNOWN ||
 	    zone->state == BLK_ZONE_BUSY) {
 		sd_zbc_debug_ratelimit(sdkp,
@@ -476,16 +535,6 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 		ret = BLKPREP_DEFER;
 		goto out;
 	}
-	if (zone->state == BLK_ZONE_OFFLINE) {
-		/* let the drive fail the command */
-		sd_zbc_debug_ratelimit(sdkp,
-				       "zone %zu offline\n",
-				       zone->start);
-		goto out;
-	}
-
-	if (blk_zone_is_cmr(zone))
-		goto out;
 
 	if (blk_zone_is_seq_pref(zone)) {
 		if (op_is_write(req_op(rq))) {
@@ -514,6 +563,14 @@ int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 		goto out;
 	}
 
+	if (zone->state == BLK_ZONE_OFFLINE) {
+		/* let the drive fail the command */
+		sd_zbc_debug_ratelimit(sdkp,
+				       "zone %zu offline\n",
+				       zone->start);
+		goto out;
+	}
+
 	if (op_is_write(req_op(rq))) {
 		if (zone->state == BLK_ZONE_READONLY)
 			goto out;
-- 
2.9.3

