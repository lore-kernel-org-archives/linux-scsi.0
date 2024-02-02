Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D56481CE;
	Fri,  2 Feb 2024 07:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859100; cv=none; b=rDT6/xMRIeMBygRnf6XiA2HGdLB99o1aOhYW52D1EGqSYAQovtrIu/QgAHvQdsRr4Hb1Pk0nLgHsNk5mJtOYqxMEiKfq6iUt1gRxzWS4A8LH1T9HG6wPKD7RaLNVt7Ep3lOd+VM8mgNKJ/0MyuOxi1XvS9fk0t7ksSB5PCJgPVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859100; c=relaxed/simple;
	bh=bkuQoK9N2DwOS56DZ/C8NjTI7zdIm+iaND+EpXQvMtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFfRf2qH1g9K9lpJsZpeSh3rZgbxzuTk+hfrKymbtCSLXB5o84jAgRrg1l7n6SVIKWL1fkBhBcET7VAs+PHVHWAVi3Jts+CwjIXegfvsTwaY4zEItpBJHmhY8D7fw/9DnfmTs2LeX7CPWaNSx1DA0Z1FyxYZtSbTPsmiE2mtuWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eppRjXbl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eppRjXbl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10882C43390;
	Fri,  2 Feb 2024 07:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859100;
	bh=bkuQoK9N2DwOS56DZ/C8NjTI7zdIm+iaND+EpXQvMtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eppRjXblV9IIFMtXp3Y0upqSHBctatNxUqVZvezsVBnyLGFqDf6qyfK/0O1w3XQxs
	 1q91TzfFsXDOFKjNAZaCXezIiXnxtClLHgLrVIMuK5FzQUcfG/IM9ZgqFiTrwOTbZB
	 it+eZHnIKfy54VIE4CmMt/ITWVreggka2K8NXO/0IanOZOTiZDuKmHJ4exOEE0sp96
	 brardHpolD0IeVF/e0oNWvpT51AcFQo/coWHcTPdLn//DmmT9kmhQbrtPTlhubtNyA
	 ehztDVciU+MnW3SFw+IAyZNOD3Hm/3dG/ZPfLS5N2zNvseKTP/xMXHydX0kE1lVW1G
	 2BZWOSriH5lJw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/26] block: Remove zone write locking
Date: Fri,  2 Feb 2024 16:31:01 +0900
Message-ID: <20240202073104.2418230-24-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zone write locking is now unused and replaced with zone write plugging.
Remove all code that was implementing zone write locking, that is, the
various helper functions controlling request zone write locking and
the gendisk attached zone bitmaps.

The "zone_wlock" mq-debugfs entry that was listing zones that are
write-locked is replaced with the zone_plugged_wplugs entry which lists
the number of zones that have a zone write plug throttling write
operations.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq-debugfs.c    |  3 +-
 block/blk-mq-debugfs.h    |  4 +-
 block/blk-zoned.c         | 98 ++++++---------------------------------
 include/linux/blk-mq.h    | 83 ---------------------------------
 include/linux/blk_types.h |  1 -
 include/linux/blkdev.h    | 36 ++------------
 6 files changed, 21 insertions(+), 204 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 94668e72ab09..b803f5b370e9 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -160,7 +160,7 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_queue_attrs[] = {
 	{ "requeue_list", 0400, .seq_ops = &queue_requeue_list_seq_ops },
 	{ "pm_only", 0600, queue_pm_only_show, NULL },
 	{ "state", 0600, queue_state_show, queue_state_write },
-	{ "zone_wlock", 0400, queue_zone_wlock_show, NULL },
+	{ "zone_plugged_wplugs", 0400, queue_zone_plugged_wplugs_show, NULL },
 	{ },
 };
 
@@ -256,7 +256,6 @@ static const char *const rqf_name[] = {
 	RQF_NAME(HASHED),
 	RQF_NAME(STATS),
 	RQF_NAME(SPECIAL_PAYLOAD),
-	RQF_NAME(ZONE_WRITE_LOCKED),
 	RQF_NAME(TIMED_OUT),
 	RQF_NAME(RESV),
 };
diff --git a/block/blk-mq-debugfs.h b/block/blk-mq-debugfs.h
index 3ebe2c29b624..6d3ac4b77d59 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -84,9 +84,9 @@ static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
 #endif
 
 #if defined(CONFIG_BLK_DEV_ZONED) && defined(CONFIG_BLK_DEBUG_FS)
-int queue_zone_wlock_show(void *data, struct seq_file *m);
+int queue_zone_plugged_wplugs_show(void *data, struct seq_file *m);
 #else
-static inline int queue_zone_wlock_show(void *data, struct seq_file *m)
+static inline int queue_zone_plugged_wplugs_show(void *data, struct seq_file *m)
 {
 	return 0;
 }
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index bac642e26a3e..4da634e9f5a0 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -80,52 +80,6 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond)
 }
 EXPORT_SYMBOL_GPL(blk_zone_cond_str);
 
-/*
- * Return true if a request is a write requests that needs zone write locking.
- */
-bool blk_req_needs_zone_write_lock(struct request *rq)
-{
-	if (!rq->q->disk->seq_zones_wlock)
-		return false;
-
-	return blk_rq_is_seq_zoned_write(rq);
-}
-EXPORT_SYMBOL_GPL(blk_req_needs_zone_write_lock);
-
-bool blk_req_zone_write_trylock(struct request *rq)
-{
-	unsigned int zno = blk_rq_zone_no(rq);
-
-	if (test_and_set_bit(zno, rq->q->disk->seq_zones_wlock))
-		return false;
-
-	WARN_ON_ONCE(rq->rq_flags & RQF_ZONE_WRITE_LOCKED);
-	rq->rq_flags |= RQF_ZONE_WRITE_LOCKED;
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(blk_req_zone_write_trylock);
-
-void __blk_req_zone_write_lock(struct request *rq)
-{
-	if (WARN_ON_ONCE(test_and_set_bit(blk_rq_zone_no(rq),
-					  rq->q->disk->seq_zones_wlock)))
-		return;
-
-	WARN_ON_ONCE(rq->rq_flags & RQF_ZONE_WRITE_LOCKED);
-	rq->rq_flags |= RQF_ZONE_WRITE_LOCKED;
-}
-EXPORT_SYMBOL_GPL(__blk_req_zone_write_lock);
-
-void __blk_req_zone_write_unlock(struct request *rq)
-{
-	rq->rq_flags &= ~RQF_ZONE_WRITE_LOCKED;
-	if (rq->q->disk->seq_zones_wlock)
-		WARN_ON_ONCE(!test_and_clear_bit(blk_rq_zone_no(rq),
-						 rq->q->disk->seq_zones_wlock));
-}
-EXPORT_SYMBOL_GPL(__blk_req_zone_write_unlock);
-
 /**
  * bdev_nr_zones - Get number of zones
  * @bdev:	Target device
@@ -1213,11 +1167,6 @@ void disk_free_zone_resources(struct gendisk *disk)
 	if (disk->zone_wplugs)
 		cancel_delayed_work_sync(&disk->zone_wplugs_work);
 
-	kfree(disk->conv_zones_bitmap);
-	disk->conv_zones_bitmap = NULL;
-	kfree(disk->seq_zones_wlock);
-	disk->seq_zones_wlock = NULL;
-
 	blk_zone_free_write_plugs(disk, disk->zone_wplugs, disk->nr_zones);
 	disk->zone_wplugs = NULL;
 
@@ -1226,9 +1175,6 @@ void disk_free_zone_resources(struct gendisk *disk)
 
 struct blk_revalidate_zone_args {
 	struct gendisk	*disk;
-	unsigned long	*conv_zones_bitmap;
-	unsigned long	*seq_zones_wlock;
-	unsigned int	nr_zones;
 	struct blk_zone_wplug *zone_wplugs;
 	sector_t	sector;
 };
@@ -1277,22 +1223,9 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	/* Check zone type */
 	switch (zone->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
-		if (!args->conv_zones_bitmap) {
-			args->conv_zones_bitmap =
-				blk_alloc_zone_bitmap(q->node, args->nr_zones);
-			if (!args->conv_zones_bitmap)
-				return -ENOMEM;
-		}
-		set_bit(idx, args->conv_zones_bitmap);
 		args->zone_wplugs[idx].flags |= BLK_ZONE_WPLUG_CONV;
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
-		if (!args->seq_zones_wlock) {
-			args->seq_zones_wlock =
-				blk_alloc_zone_bitmap(q->node, args->nr_zones);
-			if (!args->seq_zones_wlock)
-				return -ENOMEM;
-		}
 		args->zone_wplugs[idx].capacity = zone->capacity;
 		args->zone_wplugs[idx].wp_offset = blk_zone_wp_offset(zone);
 		break;
@@ -1308,7 +1241,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 }
 
 /**
- * blk_revalidate_disk_zones - (re)allocate and initialize zone bitmaps
+ * blk_revalidate_disk_zones - (re)allocate and initialize zone write plugs
  * @disk:	Target disk
  *
  * Helper function for low-level device drivers to check, (re) allocate and
@@ -1326,7 +1259,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	sector_t zone_sectors = q->limits.chunk_sectors;
 	sector_t capacity = get_capacity(disk);
 	struct blk_revalidate_zone_args args = { };
-	unsigned int noio_flag;
+	unsigned int nr_zones, noio_flag;
 	int ret = -ENOMEM;
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
@@ -1351,6 +1284,8 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 		return -ENODEV;
 	}
 
+	nr_zones = (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
+
 	/*
 	 * Ensure that all memory allocations in this context are done as if
 	 * GFP_NOIO was specified.
@@ -1358,8 +1293,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	noio_flag = memalloc_noio_save();
 
 	args.disk = disk;
-	args.nr_zones = (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
-	args.zone_wplugs = blk_zone_alloc_write_plugs(args.nr_zones);
+	args.zone_wplugs = blk_zone_alloc_write_plugs(nr_zones);
 	if (!args.zone_wplugs)
 		goto out_restore_noio;
 
@@ -1389,16 +1323,13 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	}
 
 	/*
-	 * Install the new bitmaps and update nr_zones only once the queue is
-	 * stopped and all I/Os are completed (i.e. a scheduler is not
-	 * referencing the bitmaps).
+	 * Install the new write plugs and update nr_zones only once the queue
+	 * is frozen and all I/Os are completed.
 	 */
 	blk_mq_freeze_queue(q);
 	if (ret > 0) {
 		mutex_lock(&disk->zone_wplugs_mutex);
-		disk->nr_zones = args.nr_zones;
-		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
-		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
+		disk->nr_zones = nr_zones;
 		swap(disk->zone_wplugs, args.zone_wplugs);
 		mutex_unlock(&disk->zone_wplugs_mutex);
 		ret = 0;
@@ -1408,9 +1339,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	}
 	blk_mq_unfreeze_queue(q);
 
-	kfree(args.seq_zones_wlock);
-	kfree(args.conv_zones_bitmap);
-	blk_zone_free_write_plugs(disk, args.zone_wplugs, args.nr_zones);
+	blk_zone_free_write_plugs(disk, args.zone_wplugs, nr_zones);
 
 	return ret;
 
@@ -1422,16 +1351,17 @@ EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 
 #ifdef CONFIG_BLK_DEBUG_FS
 
-int queue_zone_wlock_show(void *data, struct seq_file *m)
+int queue_zone_plugged_wplugs_show(void *data, struct seq_file *m)
 {
 	struct request_queue *q = data;
+	struct gendisk *disk = q->disk;
 	unsigned int i;
 
-	if (!q->disk->seq_zones_wlock)
+	if (!disk->zone_wplugs)
 		return 0;
 
-	for (i = 0; i < q->disk->nr_zones; i++)
-		if (test_bit(i, q->disk->seq_zones_wlock))
+	for (i = 0; i < disk->nr_zones; i++)
+		if (disk->zone_wplugs[i].flags & BLK_ZONE_WPLUG_PLUGGED)
 			seq_printf(m, "%u\n", i);
 
 	return 0;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index bc74f904b5a1..1478cc4fdebe 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -53,8 +53,6 @@ typedef __u32 __bitwise req_flags_t;
 /* Look at ->special_vec for the actual data payload instead of the
    bio chain. */
 #define RQF_SPECIAL_PAYLOAD	((__force req_flags_t)(1 << 18))
-/* The per-zone write lock is held for this request */
-#define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
 /* The request completion needs to be signaled to zone write pluging. */
 #define RQF_ZONE_WRITE_PLUGGING	((__force req_flags_t)(1 << 20))
 /* ->timeout has been called, don't expire again */
@@ -1148,85 +1146,4 @@ static inline int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 }
 void blk_dump_rq_flags(struct request *, char *);
 
-#ifdef CONFIG_BLK_DEV_ZONED
-static inline unsigned int blk_rq_zone_no(struct request *rq)
-{
-	return disk_zone_no(rq->q->disk, blk_rq_pos(rq));
-}
-
-static inline unsigned int blk_rq_zone_is_seq(struct request *rq)
-{
-	return disk_zone_is_seq(rq->q->disk, blk_rq_pos(rq));
-}
-
-/**
- * blk_rq_is_seq_zoned_write() - Check if @rq requires write serialization.
- * @rq: Request to examine.
- *
- * Note: REQ_OP_ZONE_APPEND requests do not require serialization.
- */
-static inline bool blk_rq_is_seq_zoned_write(struct request *rq)
-{
-	return op_needs_zoned_write_locking(req_op(rq)) &&
-		blk_rq_zone_is_seq(rq);
-}
-
-bool blk_req_needs_zone_write_lock(struct request *rq);
-bool blk_req_zone_write_trylock(struct request *rq);
-void __blk_req_zone_write_lock(struct request *rq);
-void __blk_req_zone_write_unlock(struct request *rq);
-
-static inline void blk_req_zone_write_lock(struct request *rq)
-{
-	if (blk_req_needs_zone_write_lock(rq))
-		__blk_req_zone_write_lock(rq);
-}
-
-static inline void blk_req_zone_write_unlock(struct request *rq)
-{
-	if (rq->rq_flags & RQF_ZONE_WRITE_LOCKED)
-		__blk_req_zone_write_unlock(rq);
-}
-
-static inline bool blk_req_zone_is_write_locked(struct request *rq)
-{
-	return rq->q->disk->seq_zones_wlock &&
-		test_bit(blk_rq_zone_no(rq), rq->q->disk->seq_zones_wlock);
-}
-
-static inline bool blk_req_can_dispatch_to_zone(struct request *rq)
-{
-	if (!blk_req_needs_zone_write_lock(rq))
-		return true;
-	return !blk_req_zone_is_write_locked(rq);
-}
-#else /* CONFIG_BLK_DEV_ZONED */
-static inline bool blk_rq_is_seq_zoned_write(struct request *rq)
-{
-	return false;
-}
-
-static inline bool blk_req_needs_zone_write_lock(struct request *rq)
-{
-	return false;
-}
-
-static inline void blk_req_zone_write_lock(struct request *rq)
-{
-}
-
-static inline void blk_req_zone_write_unlock(struct request *rq)
-{
-}
-static inline bool blk_req_zone_is_write_locked(struct request *rq)
-{
-	return false;
-}
-
-static inline bool blk_req_can_dispatch_to_zone(struct request *rq)
-{
-	return true;
-}
-#endif /* CONFIG_BLK_DEV_ZONED */
-
 #endif /* BLK_MQ_H */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fd0dc2d08924..31994887cbdb 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -295,7 +295,6 @@ enum {
 	BIO_QOS_THROTTLED,	/* bio went through rq_qos throttle path */
 	BIO_QOS_MERGED,		/* but went through rq_qos merge path */
 	BIO_REMAPPED,
-	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
 	BIO_FLAG_LAST
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cb90a59d35cb..6dfefb2de652 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -176,24 +176,14 @@ struct gendisk {
 
 #ifdef CONFIG_BLK_DEV_ZONED
 	/*
-	 * Zoned block device information for request dispatch control.
-	 * nr_zones is the total number of zones of the device. This is always
-	 * 0 for regular block devices. conv_zones_bitmap is a bitmap of nr_zones
-	 * bits which indicates if a zone is conventional (bit set) or
-	 * sequential (bit clear). seq_zones_wlock is a bitmap of nr_zones
-	 * bits which indicates if a zone is write locked, that is, if a write
-	 * request targeting the zone was dispatched.
-	 *
-	 * Reads of this information must be protected with blk_queue_enter() /
-	 * blk_queue_exit(). Modifying this information is only allowed while
-	 * no requests are being processed. See also blk_mq_freeze_queue() and
-	 * blk_mq_unfreeze_queue().
+	 * Zoned block device information. Reads of this information must be
+	 * protected with blk_queue_enter() / blk_queue_exit(). Modifying this
+	 * information is only allowed while no requests are being processed.
+	 * See also blk_mq_freeze_queue() and blk_mq_unfreeze_queue().
 	 */
 	unsigned int		nr_zones;
 	unsigned int		max_open_zones;
 	unsigned int		max_active_zones;
-	unsigned long		*conv_zones_bitmap;
-	unsigned long		*seq_zones_wlock;
 	struct blk_zone_wplug	*zone_wplugs;
 	struct mutex		zone_wplugs_mutex;
 	atomic_t		zone_nr_wplugs_with_error;
@@ -629,15 +619,6 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 	return sector >> ilog2(disk->queue->limits.chunk_sectors);
 }
 
-static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
-{
-	if (!blk_queue_is_zoned(disk->queue))
-		return false;
-	if (!disk->conv_zones_bitmap)
-		return true;
-	return !test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
-}
-
 static inline void disk_set_max_open_zones(struct gendisk *disk,
 		unsigned int max_open_zones)
 {
@@ -671,10 +652,6 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return 0;
 }
-static inline bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
-{
-	return false;
-}
 static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
 {
 	return 0;
@@ -859,11 +836,6 @@ static inline bool bio_straddle_zones(struct bio *bio)
 		disk_zone_no(bio->bi_bdev->bd_disk, bio_end_sector(bio) - 1);
 }
 
-static inline unsigned int bio_zone_is_seq(struct bio *bio)
-{
-	return disk_zone_is_seq(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
-}
-
 /*
  * Return how much of the chunk is left to be used for I/O at a given offset.
  */
-- 
2.43.0

