From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH v2 4/4] Integrate ZBC command requests with zone cache.
Date: Sun, 21 Aug 2016 23:31:16 -0500
Message-ID: <20160822043116.21168-5-shaun@tancheff.com>
References: <20160822043116.21168-1-shaun@tancheff.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160822043116.21168-1-shaun@tancheff.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Damien Le Moal <damien.lemoal@hgst.com>, Hannes Reinecke <hare@suse.de>, Josh Bingaman <josh.bingaman@seagate.com>, Dan Williams <dan.j.williams@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

Block layer (bio/request) commands can use or update the
sd_zbc zone cache as appropriate for each command.

Report Zones [REQ_OP_ZONE_REPORT] by default uses the current
zone cache data to generate a device (ZBC spec) formatted response.
REQ_META can also be specified to force the command to the device
and the result will be used to refresh the zone cache.

Reset WP [REQ_OP_ZONE_RESET] by default will attempt to translate
the request into a discard following the SD_ZBC_RESET_WP provisioning
mode. REQ_META can also be specified to force the command to be sent
to the device.

Open, Close and Finish zones having no other analog are sent directly
to the device.

On successful completion each zone action will update the zone cache
as appropriate.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 block/blk-lib.c       |  16 --
 drivers/scsi/sd.c     |  42 +++-
 drivers/scsi/sd.h     |  22 +-
 drivers/scsi/sd_zbc.c | 672 +++++++++++++++++++++++++++++++++++++++++++++++---
 4 files changed, 698 insertions(+), 54 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 67b9258..8cc5893 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -307,22 +307,6 @@ int blkdev_issue_zone_report(struct block_device *bdev, unsigned int op_flags,
 	bio_set_op_attrs(bio, REQ_OP_ZONE_REPORT, op_flags);
 	ret = submit_bio_wait(bio);
 
-	/*
-	 * When our request it nak'd the underlying device maybe conventional
-	 * so ... report a single conventional zone the size of the device.
-	 */
-	if (ret == -EIO && conv->descriptor_count) {
-		/* Adjust the conventional to the size of the partition ... */
-		__be64 blksz = cpu_to_be64(bdev->bd_part->nr_sects);
-
-		conv->maximum_lba = blksz;
-		conv->descriptors[0].type = BLK_ZONE_TYPE_CONVENTIONAL;
-		conv->descriptors[0].flags = BLK_ZONE_NO_WP << 4;
-		conv->descriptors[0].length = blksz;
-		conv->descriptors[0].lba_start = 0;
-		conv->descriptors[0].lba_wptr = blksz;
-		ret = 0;
-	}
 	bio_put(bio);
 	return ret;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b76ffbb..9a649fa 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1181,9 +1181,10 @@ static int sd_setup_zone_report_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	struct bio *bio = rq->bio;
 	sector_t sector = blk_rq_pos(rq);
-	struct gendisk *disk = rq->rq_disk;
 	unsigned int nr_bytes = blk_rq_bytes(rq);
 	int ret = BLKPREP_KILL;
+	bool is_fua = (rq->cmd_flags & REQ_META) ? true : false;
+	u8 rpt_opt = ZBC_ZONE_REPORTING_OPTION_ALL;
 
 	WARN_ON(nr_bytes == 0);
 
@@ -1194,18 +1195,35 @@ static int sd_setup_zone_report_cmnd(struct scsi_cmnd *cmd)
 	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC) {
 		void *src;
 		struct bdev_zone_report *conv;
+		__be64 blksz = cpu_to_be64(sdkp->capacity);
 
-		if (nr_bytes < sizeof(struct bdev_zone_report))
+		if (nr_bytes < 512)
 			goto out;
 
 		src = kmap_atomic(bio->bi_io_vec->bv_page);
 		conv = src + bio->bi_io_vec->bv_offset;
 		conv->descriptor_count = cpu_to_be32(1);
 		conv->same_field = BLK_ZONE_SAME_ALL;
-		conv->maximum_lba = cpu_to_be64(disk->part0.nr_sects);
+		conv->maximum_lba = blksz;
+		conv->descriptors[0].type = BLK_ZONE_TYPE_CONVENTIONAL;
+		conv->descriptors[0].flags = BLK_ZONE_NO_WP << 4;
+		conv->descriptors[0].length = blksz;
+		conv->descriptors[0].lba_start = 0;
+		conv->descriptors[0].lba_wptr = blksz;
 		kunmap_atomic(src);
+		ret = BLKPREP_DONE;
 		goto out;
 	}
+	/* FUTURE ... when streamid is available */
+	/* rpt_opt = bio_get_streamid(bio); */
+
+	if (!is_fua) {
+		ret = sd_zbc_setup_zone_report_cmnd(cmd, rpt_opt);
+		if (ret == BLKPREP_DONE || ret == BLKPREP_DEFER)
+			goto out;
+		if (ret == BLKPREP_KILL)
+			pr_err("No Zone Cache, query media.\n");
+	}
 
 	ret = scsi_init_io(cmd);
 	if (ret != BLKPREP_OK)
@@ -1224,8 +1242,7 @@ static int sd_setup_zone_report_cmnd(struct scsi_cmnd *cmd)
 	cmd->cmnd[1] = ZI_REPORT_ZONES;
 	put_unaligned_be64(sector, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_bytes, &cmd->cmnd[10]);
-	/* FUTURE ... when streamid is available */
-	/* cmd->cmnd[14] = bio_get_streamid(bio); */
+	cmd->cmnd[14] = rpt_opt;
 
 	cmd->sc_data_direction = DMA_FROM_DEVICE;
 	cmd->sdb.length = nr_bytes;
@@ -1243,11 +1260,22 @@ static int sd_setup_zone_action_cmnd(struct scsi_cmnd *cmd)
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	int ret = BLKPREP_KILL;
+	bool is_fua = (rq->cmd_flags & REQ_META) ? true : false;
 	u8 allbit = 0;
 
 	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
 		goto out;
 
+	rq->timeout = SD_TIMEOUT;
+	rq->completion_data = NULL;
+
+	/* Allow the ZBC zone cache an opportunity to hijack the request */
+	if (!is_fua) {
+		ret = sd_zbc_setup_zone_action(cmd);
+		if (ret == BLKPREP_OK || ret == BLKPREP_DEFER)
+			goto out;
+	}
+
 	if (sector == ~0ul) {
 		allbit = 1;
 		sector = 0;
@@ -1316,6 +1344,8 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
+	sd_zbc_uninit_command(SCpnt);
+
 	if (req_op(rq) == REQ_OP_DISCARD &&
 	    rq->completion_data)
 		__free_page(rq->completion_data);
@@ -2044,6 +2074,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	if (rq_data_dir(SCpnt->request) == READ && scsi_prot_sg_count(SCpnt))
 		sd_dif_complete(SCpnt, good_bytes);
 
+	sd_zbc_done(SCpnt, good_bytes);
+
 	return good_bytes;
 }
 
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2792c10..adbf3e0 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -293,11 +293,15 @@ static inline void sd_dif_complete(struct scsi_cmnd *cmd, unsigned int a)
 extern int sd_zbc_report_zones(struct scsi_disk *, unsigned char *, int,
 			       sector_t, enum zbc_zone_reporting_options, bool);
 extern int sd_zbc_setup(struct scsi_disk *, u64 zlen, char *buf, int buf_len);
-extern void sd_zbc_remove(struct scsi_disk *);
-extern void sd_zbc_reset_zones(struct scsi_disk *);
+extern int sd_zbc_setup_zone_report_cmnd(struct scsi_cmnd *cmd, u8 rpt_opt);
+extern int sd_zbc_setup_zone_action(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_discard(struct scsi_cmnd *cmd);
 extern int sd_zbc_setup_read_write(struct scsi_disk *, struct request *,
 				   sector_t, unsigned int *);
+extern void sd_zbc_done(struct scsi_cmnd *cmd, int good_bytes);
+extern void sd_zbc_uninit_command(struct scsi_cmnd *cmd);
+extern void sd_zbc_remove(struct scsi_disk *);
+extern void sd_zbc_reset_zones(struct scsi_disk *);
 extern void sd_zbc_update_zones(struct scsi_disk *, sector_t, int, int reason);
 extern unsigned int sd_zbc_discard_granularity(struct scsi_disk *sdkp);
 
@@ -318,7 +322,19 @@ static inline int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen,
 	return 0;
 }
 
-static inline int int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
+static inline void sd_zbc_done(struct scsi_cmnd *cmd, int good_bytes) {}
+
+extern int sd_zbc_setup_zone_report_cmnd(struct scsi_cmnd *cmd, u8 rpt_opt)
+{
+	return BLKPREP_KILL;
+}
+
+static inline sd_zbc_setup_zone_action(struct scsi_cmnd *cmd)
+{
+	return BLKPREP_KILL;
+}
+
+static inline int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
 {
 	return BLKPREP_KILL;
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0780118..0259bda 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -58,6 +58,43 @@ struct zbc_update_work {
 	char		zone_buf[0];
 };
 
+/**
+ * get_len_from_desc() - Decode write pointer as # of blocks from start
+ * @bzde: Zone descriptor entry.
+ *
+ * Return: Write Pointer as number of blocks from start of zone.
+ */
+static inline sector_t get_len_from_desc(struct scsi_disk *sdkp,
+					 struct bdev_zone_descriptor *bzde)
+{
+	return logical_to_sectors(sdkp->device, be64_to_cpu(bzde->length));
+}
+
+/**
+ * get_wp_from_desc() - Decode write pointer as # of blocks from start
+ * @bzde: Zone descriptor entry.
+ *
+ * Return: Write Pointer as number of blocks from start of zone.
+ */
+static inline sector_t get_wp_from_desc(struct scsi_disk *sdkp,
+					struct bdev_zone_descriptor *bzde)
+{
+	return logical_to_sectors(sdkp->device,
+		be64_to_cpu(bzde->lba_wptr) - be64_to_cpu(bzde->lba_start));
+}
+
+/**
+ * get_start_from_desc() - Decode write pointer as # of blocks from start
+ * @bzde: Zone descriptor entry.
+ *
+ * Return: Write Pointer as number of blocks from start of zone.
+ */
+static inline sector_t get_start_from_desc(struct scsi_disk *sdkp,
+					   struct bdev_zone_descriptor *bzde)
+{
+	return logical_to_sectors(sdkp->device, be64_to_cpu(bzde->lba_start));
+}
+
 static
 struct blk_zone *zbc_desc_to_zone(struct scsi_disk *sdkp, unsigned char *rec)
 {
@@ -289,7 +326,7 @@ retry:
 	zbc_work->zone_buflen = bufsize;
 	zbc_work->sdkp = sdkp;
 	INIT_WORK(&zbc_work->zone_work, sd_zbc_refresh_zone_work);
-	num_rec = (bufsize / 64) - 1;
+	num_rec = max_report_entries(bufsize);
 
 	/*
 	 * Mark zones under update as BUSY
@@ -382,6 +419,59 @@ int sd_zbc_report_zones(struct scsi_disk *sdkp, unsigned char *buffer,
 	return 0;
 }
 
+/**
+ * discard_or_write_same - Wrapper to setup Write Same or Reset WP for ZBC dev
+ * @cmd: SCSI command / request to setup
+ * @sector: Block layer sector (512 byte sector) to map to device.
+ * @nr_sectors: Number of 512 byte sectors.
+ * @use_write_same: When true setup WRITE_SAME_16 w/o UNMAP set.
+ *                  When false setup RESET WP for zone starting at sector.
+ */
+static void discard_or_write_same(struct scsi_cmnd *cmd, sector_t sector,
+				  unsigned int nr_sectors, bool use_write_same)
+{
+	struct scsi_device *sdp = cmd->device;
+
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
+		cmd->request->timeout = SD_WRITE_SAME_TIMEOUT;
+	} else {
+		cmd->cmd_len = 16;
+		cmd->cmnd[0] = ZBC_OUT;
+		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
+		put_unaligned_be64(sector, &cmd->cmnd[2]);
+		/* Reset Write Pointer doesn't have a payload */
+		cmd->transfersize = 0;
+		cmd->sc_data_direction = DMA_NONE;
+	}
+}
+
+/**
+ * sd_zbc_setup_discard() - ZBC device hook for sd_setup_discard
+ * @cmd: SCSI command/request being setup
+ *
+ * Handle SD_ZBC_RESET_WP provisioning mode.
+ * If zone is sequential and discard matches zone size issue RESET WP
+ * If zone is conventional issue WRITE_SAME_16 w/o UNMAP.
+ *
+ * Return:
+ *  BLKPREP_OK    - Zone action not handled here (Skip futher processing)
+ *  BLKPREP_DONE  - Zone action not handled here (Process as normal)
+ *  BLKPREP_DEFER - Zone action should be handled here but memory
+ *                  allocation failed. Retry.
+ */
 int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
@@ -467,44 +557,430 @@ int sd_zbc_setup_discard(struct scsi_cmnd *cmd)
 	}
 
 out:
-	spin_unlock_irqrestore(&zone->lock, flags);
-
-	if (ret != BLKPREP_OK)
-		goto done;
 	/*
-	 * blk_zone cache uses block layer sector units
-	 * but commands use device units
+	 * Opportunistic setting, will be fixed up with
+	 * zone update if RESET WRITE POINTER fails.
 	 */
-	sector >>= ilog2(sdp->sector_size) - 9;
-	nr_sectors >>= ilog2(sdp->sector_size) - 9;
+	if (ret == BLKPREP_OK && !use_write_same)
+		zone->wp = zone->start;
+	spin_unlock_irqrestore(&zone->lock, flags);
 
-	if (use_write_same) {
-		cmd->cmd_len = 16;
-		cmd->cmnd[0] = WRITE_SAME_16;
-		cmd->cmnd[1] = 0; /* UNMAP (not set) */
-		put_unaligned_be64(sector, &cmd->cmnd[2]);
-		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
-		cmd->transfersize = sdp->sector_size;
-		rq->timeout = SD_WRITE_SAME_TIMEOUT;
+	if (ret == BLKPREP_OK)
+		discard_or_write_same(cmd, sector, nr_sectors, use_write_same);
+
+	return ret;
+}
+
+
+static void __set_zone_state(struct blk_zone *zone, int op)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zone->lock, flags);
+	if (blk_zone_is_cmr(zone))
+		goto out_unlock;
+
+	switch (op) {
+	case REQ_OP_ZONE_OPEN:
+		zone->state = BLK_ZONE_OPEN_EXPLICIT;
+		break;
+	case REQ_OP_ZONE_FINISH:
+		zone->state = BLK_ZONE_FULL;
+		zone->wp = zone->start + zone->len;
+		break;
+	case REQ_OP_ZONE_CLOSE:
+		zone->state = BLK_ZONE_CLOSED;
+		break;
+	case REQ_OP_ZONE_RESET:
+		zone->wp = zone->start;
+		break;
+	default:
+		WARN_ONCE(1, "%s: invalid op code: %u\n", __func__, op);
+	}
+out_unlock:
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
+static void update_zone_state(struct request *rq, sector_t lba, unsigned int op)
+{
+	struct request_queue *q = rq->q;
+	struct blk_zone *zone = NULL;
+
+	if (lba == ~0ul) {
+		struct rb_node *node;
+
+		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+			zone = rb_entry(node, struct blk_zone, node);
+			__set_zone_state(zone, op);
+		}
+		return;
 	} else {
-		cmd->cmd_len = 16;
-		cmd->cmnd[0] = ZBC_OUT;
-		cmd->cmnd[1] = ZO_RESET_WRITE_POINTER;
-		put_unaligned_be64(sector, &cmd->cmnd[2]);
-		/* Reset Write Pointer doesn't have a payload */
-		cmd->transfersize = 0;
-		cmd->sc_data_direction = DMA_NONE;
+		zone = blk_lookup_zone(q, lba);
+		if (zone)
+			__set_zone_state(zone, op);
+	}
+}
+
+/**
+ * sd_zbc_setup_zone_action() - ZBC device hook for sd_setup_zone_action
+ * @cmd: SCSI command/request being setup
+ *
+ * Currently for RESET WP (REQ_OP_ZONE_RESET) if the META flag is cleared
+ * the command may be translated to follow SD_ZBC_RESET_WP provisioning mode.
+ *
+ * Return:
+ *  BLKPREP_OK    - Zone action handled here (Skip futher processing)
+ *  BLKPREP_DONE  - Zone action not handled here (Caller must process)
+ *  BLKPREP_DEFER - Zone action should be handled here but memory
+ *                  allocation failed. Retry.
+ */
+int sd_zbc_setup_zone_action(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	struct blk_zone *zone;
+	unsigned long flags;
+	unsigned int nr_sectors;
+	int ret = BLKPREP_DONE;
+	int op = req_op(rq);
+	bool is_fua = (rq->cmd_flags & REQ_META) ? true : false;
+	bool use_write_same = false;
+
+	if (is_fua || op != REQ_OP_ZONE_RESET)
+		goto out;
+
+	zone = blk_lookup_zone(rq->q, sector);
+	if (!zone || sdkp->provisioning_mode != SD_ZBC_RESET_WP)
+		goto out;
+
+	/* Map a Reset WP w/o FUA to a discard request */
+	spin_lock_irqsave(&zone->lock, flags);
+	sector = zone->start;
+	nr_sectors = zone->len;
+	if (blk_zone_is_cmr(zone))
+		use_write_same = true;
+	spin_unlock_irqrestore(&zone->lock, flags);
+
+	rq->completion_data = NULL;
+	if (use_write_same) {
+		struct page *page;
+
+		page = alloc_page(GFP_ATOMIC | GFP_DMA | __GFP_ZERO);
+		if (!page)
+			return BLKPREP_DEFER;
+		rq->completion_data = page;
+		rq->timeout = SD_TIMEOUT;
+		cmd->sc_data_direction = DMA_TO_DEVICE;
+	}
+	rq->__sector = sector;
+	rq->__data_len = nr_sectors << 9;
+	ret = sd_zbc_setup_discard(cmd);
+	if (ret != BLKPREP_OK)
+		goto out;
+
+	cmd->allowed = SD_MAX_RETRIES;
+	if (cmd->transfersize) {
+		blk_add_request_payload(rq, rq->completion_data,
+					0, cmd->transfersize);
+		ret = scsi_init_io(cmd);
+	}
+	rq->__data_len = nr_sectors << 9;
+	if (ret != BLKPREP_OK && rq->completion_data) {
+		__free_page(rq->completion_data);
+		rq->completion_data = NULL;
+	}
+out:
+	return ret;
+}
+
+
+/**
+ * bzrpt_fill() - Fill a ZEPORT ZONES request in pages
+ * @rq: Request where zone cache lives
+ * @bzrpt: Zone report header.
+ * @bzd: Zone report descriptors.
+ * @sz: allocated size of bzrpt or bzd.
+ * @lba: LBA to start filling in.
+ * @opt: Report option.
+ *
+ * Returns: next_lba
+ */
+static sector_t bzrpt_fill(struct request *rq,
+			   struct bdev_zone_report *bzrpt,
+			   struct bdev_zone_descriptor *bzd,
+			   size_t sz, sector_t lba, u8 opt)
+{
+	struct request_queue *q = rq->q;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct blk_zone *zone = NULL;
+	struct rb_node *node = NULL;
+	sector_t progress = lba;
+	sector_t clen = ~0ul;
+	unsigned long flags;
+	u32 max_entries = bzrpt ? max_report_entries(sz) : sz / sizeof(*bzd);
+	u32 entry = 0;
+	int len_diffs = 0;
+	int type_diffs = 0;
+	u8 ctype;
+	u8 same = 0;
+
+	zone = blk_lookup_zone(q, lba);
+	if (zone)
+		node = &zone->node;
+
+	for (entry = 0; entry < max_entries && node; node = rb_next(node)) {
+		u64 z_len, z_start, z_wp_abs;
+		u8 cond = 0;
+		u8 flgs = 0;
+
+		spin_lock_irqsave(&zone->lock, flags);
+		z_len = zone->len;
+		z_start = zone->start;
+		z_wp_abs = zone->wp;
+		progress = z_start + z_len;
+		cond = zone->state;
+		if (blk_zone_is_cmr(zone))
+			flgs |= 0x02;
+		else if (zone->wp != zone->start)
+			flgs |= 0x01; /* flag as RWP recommended? */
+		spin_unlock_irqrestore(&zone->lock, flags);
+
+		switch (opt & ZBC_REPORT_OPTION_MASK) {
+		case ZBC_ZONE_REPORTING_OPTION_EMPTY:
+			if (z_wp_abs != z_start)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_IMPLICIT_OPEN:
+			if (cond != BLK_ZONE_OPEN)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_EXPLICIT_OPEN:
+			if (cond != BLK_ZONE_OPEN_EXPLICIT)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_CLOSED:
+			if (cond != BLK_ZONE_CLOSED)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_FULL:
+			if (cond != BLK_ZONE_FULL)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_READONLY:
+			if (cond == BLK_ZONE_READONLY)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_OFFLINE:
+			if (cond == BLK_ZONE_OFFLINE)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_NEED_RESET_WP:
+			if (z_wp_abs == z_start)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_NON_WP:
+			if (cond == BLK_ZONE_NO_WP)
+				continue;
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_NON_SEQWRITE:
+			/* this can only be reported by the HW */
+			break;
+		case ZBC_ZONE_REPORTING_OPTION_ALL:
+		default:
+			break;
+		}
+
+		/* if same code only applies to returned zones */
+		if (opt & ZBC_REPORT_ZONE_PARTIAL) {
+			if (clen != ~0ul) {
+				clen = z_len;
+				ctype = zone->type;
+			}
+			if (z_len != clen)
+				len_diffs++;
+			if (zone->type != ctype)
+				type_diffs++;
+			ctype = zone->type;
+		}
+
+		/* shift to device units */
+		z_start >>= ilog2(sdkp->device->sector_size) - 9;
+		z_len >>= ilog2(sdkp->device->sector_size) - 9;
+		z_wp_abs >>= ilog2(sdkp->device->sector_size) - 9;
+
+		if (!bzd) {
+			if (bzrpt)
+				bzrpt->descriptor_count =
+					cpu_to_be32(++entry);
+			continue;
+		}
+
+		bzd[entry].lba_start = cpu_to_be64(z_start);
+		bzd[entry].length = cpu_to_be64(z_len);
+		bzd[entry].lba_wptr = cpu_to_be64(z_wp_abs);
+		bzd[entry].type = zone->type;
+		bzd[entry].flags = cond << 4 | flgs;
+		entry++;
+		if (bzrpt)
+			bzrpt->descriptor_count = cpu_to_be32(entry);
+	}
+
+	/* if same code applies to all zones */
+	if (bzrpt && !(opt & ZBC_REPORT_ZONE_PARTIAL)) {
+		for (node = rb_first(&q->zones); node; node = rb_next(node)) {
+			zone = rb_entry(node, struct blk_zone, node);
+
+			spin_lock_irqsave(&zone->lock, flags);
+			if (clen != ~0ul) {
+				clen = zone->len;
+				ctype = zone->type;
+			}
+			if (zone->len != clen)
+				len_diffs++;
+			if (zone->type != ctype)
+				type_diffs++;
+			ctype = zone->type;
+			spin_unlock_irqrestore(&zone->lock, flags);
+		}
+	}
+
+	if (bzrpt) {
+		/* calculate same code  */
+		if (len_diffs == 0) {
+			if (type_diffs == 0)
+				same = BLK_ZONE_SAME_ALL;
+			else
+				same = BLK_ZONE_SAME_LEN_TYPES_DIFFER;
+		} else if (len_diffs == 1 && type_diffs == 0) {
+			same = BLK_ZONE_SAME_LAST_DIFFERS;
+		} else {
+			same = BLK_ZONE_SAME_ALL_DIFFERENT;
+		}
+		bzrpt->same_field = same;
+		bzrpt->maximum_lba = cpu_to_be64(
+			logical_to_bytes(sdkp->device, sdkp->capacity));
+	}
+
+	return progress;
+}
+
+/**
+ * copy_buffer_into_request() - Copy a buffer into a (part) of a request
+ * @rq: Request to copy into
+ * @src: Buffer to copy from
+ * @bytes: Number of bytes in src
+ * @skip: Number of bytes of request to 'seek' into before overwriting with src
+ *
+ * Return: Number of bytes copied into the request.
+ */
+static int copy_buffer_into_request(struct request *rq, void *src, uint bytes,
+				    off_t skip)
+{
+	struct req_iterator iter;
+	struct bio_vec bvec;
+	off_t skipped = 0;
+	uint copied = 0;
+
+	rq_for_each_segment(bvec, rq, iter) {
+		void *buf;
+		unsigned long flags;
+		uint len;
+		uint remain = 0;
+
+		buf = bvec_kmap_irq(&bvec, &flags);
+		if (skip > skipped)
+			remain = skip - skipped;
+
+		if (remain < bvec.bv_len) {
+			len = min_t(uint, bvec.bv_len - remain, bytes - copied);
+			memcpy(buf + remain, src + copied, len);
+			copied += len;
+		}
+		skipped += min(remain, bvec.bv_len);
+		bvec_kunmap_irq(buf, &flags);
+		if (copied >= bytes)
+			break;
+	}
+	return copied;
+}
+
+/**
+ * sd_zbc_setup_zone_report_cmnd() - Handle a zone report request
+ * @cmd: SCSI command request
+ * @ropt: Current report option flags to use
+ *
+ * Use the zone cache to fill in a report zones request.
+ *
+ * Return: BLKPREP_DONE if copy was sucessful.
+ *         BLKPREP_KILL if payload size was invalid.
+ *         BLKPREP_DEFER if unable to acquire a temporary page of working data.
+ */
+int sd_zbc_setup_zone_report_cmnd(struct scsi_cmnd *cmd, u8 ropt)
+{
+	struct request *rq = cmd->request;
+	sector_t sector = blk_rq_pos(rq);
+	struct bdev_zone_descriptor *bzd;
+	struct bdev_zone_report *bzrpt;
+	void *pbuf;
+	off_t skip = 0;
+	unsigned int nr_bytes = blk_rq_bytes(rq);
+	int rnum;
+	int ret = BLKPREP_DEFER;
+	unsigned int chunk;
+
+	if (nr_bytes < 512) {
+		ret = BLKPREP_KILL;
+		goto out;
+	}
+
+	pbuf = (void *)__get_free_page(GFP_ATOMIC);
+	if (!pbuf)
+		goto out;
+
+	bzrpt = pbuf;
+	/* fill in the header and first chunk of data*/
+	bzrpt_fill(rq, bzrpt, NULL, nr_bytes, sector, ropt);
+
+	bzd = pbuf + sizeof(struct bdev_zone_report);
+	chunk = min_t(unsigned int, nr_bytes, PAGE_SIZE) -
+		sizeof(struct bdev_zone_report);
+	sector = bzrpt_fill(rq, NULL, bzd, chunk, sector, ropt);
+	chunk += sizeof(struct bdev_zone_report);
+	do {
+		rnum = copy_buffer_into_request(rq, pbuf, chunk, skip);
+		if (rnum != chunk) {
+			pr_err("buffer_to_request_partial() failed to copy "
+			       "zone report to command data [%u != %u]\n",
+				chunk, rnum);
+			ret = BLKPREP_KILL;
+			goto out;
+		}
+		skip += chunk;
+		if (skip >= nr_bytes)
+			break;
 		/*
-		 * Opportunistic setting, will be fixed up with
-		 * zone update if RESET WRITE POINTER fails.
+		 * keep loading more descriptors until nr_bytes have been
+		 * copied to the command
 		 */
-		zone->wp = zone->start;
-	}
+		chunk = min_t(unsigned int, nr_bytes - skip, PAGE_SIZE);
+		sector = bzrpt_fill(rq, NULL, pbuf, chunk, sector, ropt);
+	} while (skip < nr_bytes);
+	ret = BLKPREP_DONE;
 
-done:
+out:
+	if (pbuf)
+		free_page((unsigned long) pbuf);
 	return ret;
 }
 
+/**
+ * sd_zbc_setup_read_write() - ZBC device hook for sd_setup_read_write
+ * @sdkp: SCSI Disk
+ * @rq: Request being setup
+ * @sector: Request sector
+ * @num_sectors: Request size
+ */
 int sd_zbc_setup_read_write(struct scsi_disk *sdkp, struct request *rq,
 			    sector_t sector, unsigned int *num_sectors)
 {
@@ -622,6 +1098,140 @@ out:
 }
 
 /**
+ * update_zones_from_report() - Update zone WP's and state [condition]
+ * @cmd: SCSI command request
+ * @nr_bytes: Number of 'good' bytes in this request.
+ *
+ * Read the result data from a REPORT ZONES in PAGE_SIZE chunks util
+ * the full report is digested into the zone cache.
+ */
+static void update_zones_from_report(struct scsi_cmnd *cmd, u32 nr_bytes)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	struct bdev_zone_descriptor *bzde;
+	u32 nread = 0;
+	u32 dmax = 0;
+	void *pbuf = (void *)__get_free_page(GFP_ATOMIC);
+
+	if (!pbuf)
+		goto done;
+
+	/* read a page at a time and update the zone cache's WPs */
+	while (nr_bytes > nread) {
+		u32 iter, count;
+		u32 len = min_t(u32, nr_bytes - nread, PAGE_SIZE);
+		size_t rnum = sg_pcopy_to_buffer(scsi_sglist(cmd),
+						 scsi_sg_count(cmd), pbuf, len,
+						 nread);
+		if (rnum != len) {
+			pr_err("%s: FAIL sg_pcopy_to_buffer: %u of %u bytes\n",
+				__func__, (uint)rnum, len);
+			goto done;
+		}
+		bzde = pbuf;
+		count = len / sizeof(struct bdev_zone_report);
+		if (nread == 0) {
+			const struct bdev_zone_report *bzrpt = pbuf;
+
+			dmax = min_t(u32, be32_to_cpu(bzrpt->descriptor_count),
+					  max_report_entries(nr_bytes));
+			bzde = pbuf + sizeof(struct bdev_zone_report);
+			count--;
+		}
+		for (iter = 0; iter < count && dmax > 0; dmax--, iter++) {
+			struct blk_zone *zone;
+			struct bdev_zone_descriptor *entry = &bzde[iter];
+			sector_t s = get_start_from_desc(sdkp, entry);
+			sector_t z_len = get_len_from_desc(sdkp, entry);
+			unsigned long flags;
+
+			if (!z_len)
+				goto done;
+
+			zone = blk_lookup_zone(rq->q, s);
+			if (!zone)
+				goto done;
+
+			spin_lock_irqsave(&zone->lock, flags);
+			zone->type = entry->type & 0xF;
+			zone->state = (entry->flags >> 4) & 0xF;
+			zone->wp = get_wp_from_desc(sdkp, entry);
+			zone->len = z_len;
+			spin_unlock_irqrestore(&zone->lock, flags);
+		}
+		nread += len;
+		if (!dmax)
+			goto done;
+	}
+done:
+	if (pbuf)
+		free_page((unsigned long) pbuf);
+}
+
+/**
+ * sd_zbc_done() - ZBC device hook for sd_done
+ * @cmd: SCSI command that is done.
+ * @good_bytes: number of bytes (successfully) completed.
+ *
+ * Cleanup or sync zone cache with cmd.
+ * Currently a successful REPORT ZONES w/FUA flag will pull data
+ * from the media. On done the zone cache is re-sync'd with the
+ * result which is presumed to be the most accurate picture of
+ * the zone condition and WP location.
+ */
+void sd_zbc_done(struct scsi_cmnd *cmd, int good_bytes)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	sector_t sector = blk_rq_pos(rq);
+	int result = cmd->result;
+	int op = req_op(rq);
+	bool is_fua = (rq->cmd_flags & REQ_META) ? true : false;
+
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
+		return;
+
+	switch (op) {
+	case REQ_OP_ZONE_REPORT:
+		if (is_fua && good_bytes > 0)
+			update_zones_from_report(cmd, good_bytes);
+		break;
+	case REQ_OP_ZONE_OPEN:
+	case REQ_OP_ZONE_CLOSE:
+	case REQ_OP_ZONE_FINISH:
+	case REQ_OP_ZONE_RESET:
+		if (result == 0)
+			update_zone_state(rq, sector, op);
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * sd_zbc_uninit_command() - ZBC device hook for sd_uninit_command
+ * @cmd: SCSI command that is done.
+ *
+ * On uninit if a RESET WP (w/o FUA flag) was translated to a
+ * DISCARD and then to an SCT Write Same then there may be a
+ * page of completion_data that was allocated and needs to be freed.
+ */
+void sd_zbc_uninit_command(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	int op = req_op(rq);
+	bool is_fua = (rq->cmd_flags & REQ_META) ? true : false;
+
+	if (sdkp->zoned != 1 && sdkp->device->type != TYPE_ZBC)
+		return;
+
+	if (!is_fua && op == REQ_OP_ZONE_RESET && rq->completion_data)
+		__free_page(rq->completion_data);
+}
+
+/**
  * sd_zbc_setup - Load zones of matching zlen size into rb tree.
  *
  */
@@ -663,7 +1273,8 @@ int sd_zbc_setup(struct scsi_disk *sdkp, u64 zlen, char *buf, int buf_len)
 }
 
 /**
- * sd_zbc_remove -
+ * sd_zbc_remove - Prepare for device removal.
+ * @sdkp: SCSI Disk being removed.
  */
 void sd_zbc_remove(struct scsi_disk *sdkp)
 {
@@ -674,6 +1285,7 @@ void sd_zbc_remove(struct scsi_disk *sdkp)
 		destroy_workqueue(sdkp->zone_work_q);
 	}
 }
+
 /**
  * sd_zbc_discard_granularity - Determine discard granularity.
  * @sdkp: SCSI disk used to calculate discard granularity.
-- 
2.9.3

