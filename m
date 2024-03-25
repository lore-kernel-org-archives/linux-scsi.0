Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EF21C32AE;
	Mon, 25 Mar 2024 04:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341942; cv=none; b=PhRM/bQWY81C+XkH1uvpD6cRhFbsY75swfhRIILKy/rzFQdOtPXN6YQP7k5r7Q98+rrOippW5+LKTAt8uplnlo7QKJR1mZ1Dre6c8lh5K4t+qRvc9BXm7f9SPX+T2zUessPA3nhAzlzod+TT5vU6uP177s0oHBLxfMVTfZNH+cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341942; c=relaxed/simple;
	bh=VAtl+ms88AH/sXG99NwuJHhNGmhRrTtEeI27vK4JWvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QSxR0kHa2aD4iQmH3tnfm/w99uc2Tx0k7n4HjmkGuC245jfczyBpr5dzOAec3/E0PlUl3NcsqsPhFebMyB8Qjfjru/tmBpv7kv9gI2JRMuYvnecVu7buxenhiOhgltw00s1hiPrHEL6BSOj4HEtt5R5mAlHxLqKmC57ocOed5t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVe/UdhE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVe/UdhE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F517C433C7;
	Mon, 25 Mar 2024 04:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341942;
	bh=VAtl+ms88AH/sXG99NwuJHhNGmhRrTtEeI27vK4JWvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVe/UdhEY2G+KgmSWqfrFvDn5VE2zurGgDv9ELZm/PX6E1edKCJQ+2GipddcOQ7ZI
	 CLyn5bqCaYnPZNxHTCd0xh8VVEEj2pKPtX7AAEWJ9NAD2MnlQt079ReUjYe6HtZSg0
	 vE5RYddB08/cftsOrcAORyvTGqRJm0USSOLWUVf2FjrE3wnJ8TjSjFblmzSPARe8e5
	 fYw6WoiQRGnQNq88BorLov30ti4A0PEZxIBPqlmRM8tG5EzKhSsX3JNa5ae6ta4Psu
	 2jVGeCpFqCmfWWSR0+yALm7W/aBL/wCCd7pF9PGTdpX48ZG1/f4rfcTyGBZDYeoTac
	 fIAc3GqZp4hUA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 26/28] block: Remove zone write locking
Date: Mon, 25 Mar 2024 13:44:50 +0900
Message-ID: <20240325044452.3125418-27-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
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
write-locked is replaced with the zone_wplugs entry which lists
the zones that currently have a write plug allocated. The information
provided is: the zone number, the zone write plug flags, the zone write
plug write pointer offset and the number of BIOs currently waiting for
execution in the zone write plug BIO list.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq-debugfs.c    |  3 +-
 block/blk-mq-debugfs.h    |  4 +-
 block/blk-zoned.c         | 92 ++++++++++-----------------------------
 include/linux/blk-mq.h    | 83 -----------------------------------
 include/linux/blk_types.h |  1 -
 include/linux/blkdev.h    | 35 ++-------------
 6 files changed, 29 insertions(+), 189 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 94668e72ab09..770c0c2b72fa 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -160,7 +160,7 @@ static const struct blk_mq_debugfs_attr blk_mq_debugfs_queue_attrs[] = {
 	{ "requeue_list", 0400, .seq_ops = &queue_requeue_list_seq_ops },
 	{ "pm_only", 0600, queue_pm_only_show, NULL },
 	{ "state", 0600, queue_state_show, queue_state_write },
-	{ "zone_wlock", 0400, queue_zone_wlock_show, NULL },
+	{ "zone_wplugs", 0400, queue_zone_wplugs_show, NULL },
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
index 3ebe2c29b624..c80e453e3014 100644
--- a/block/blk-mq-debugfs.h
+++ b/block/blk-mq-debugfs.h
@@ -84,9 +84,9 @@ static inline void blk_mq_debugfs_unregister_rqos(struct rq_qos *rqos)
 #endif
 
 #if defined(CONFIG_BLK_DEV_ZONED) && defined(CONFIG_BLK_DEBUG_FS)
-int queue_zone_wlock_show(void *data, struct seq_file *m);
+int queue_zone_wplugs_show(void *data, struct seq_file *m);
 #else
-static inline int queue_zone_wlock_show(void *data, struct seq_file *m)
+static inline int queue_zone_wplugs_show(void *data, struct seq_file *m)
 {
 	return 0;
 }
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 62160a8675f4..6ecead2babe4 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -89,52 +89,6 @@ const char *blk_zone_cond_str(enum blk_zone_cond zone_cond)
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
@@ -1465,9 +1419,6 @@ void disk_free_zone_resources(struct gendisk *disk)
 
 	kfree(disk->conv_zones_bitmap);
 	disk->conv_zones_bitmap = NULL;
-	kfree(disk->seq_zones_wlock);
-	disk->seq_zones_wlock = NULL;
-
 	disk->zone_capacity = 0;
 	disk->nr_zones = 0;
 
@@ -1527,7 +1478,6 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 struct blk_revalidate_zone_args {
 	struct gendisk	*disk;
 	unsigned long	*conv_zones_bitmap;
-	unsigned long	*seq_zones_wlock;
 	unsigned int	nr_zones;
 	unsigned int	zone_capacity;
 	sector_t	sector;
@@ -1596,13 +1546,6 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 		set_bit(idx, args->conv_zones_bitmap);
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
-		if (!args->seq_zones_wlock) {
-			args->seq_zones_wlock =
-				blk_alloc_zone_bitmap(q->node, args->nr_zones);
-			if (!args->seq_zones_wlock)
-				return -ENOMEM;
-		}
-
 		/*
 		 * Remember the capacity of the first sequential zone and check
 		 * if it is constant for all zones.
@@ -1644,7 +1587,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 }
 
 /**
- * blk_revalidate_disk_zones - (re)allocate and initialize zone bitmaps
+ * blk_revalidate_disk_zones - (re)allocate and initialize zone write plugs
  * @disk:	Target disk
  *
  * Helper function for low-level device drivers to check, (re) allocate and
@@ -1718,15 +1661,13 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	}
 
 	/*
-	 * Install the new bitmaps and update nr_zones only once the queue is
-	 * stopped and all I/Os are completed (i.e. a scheduler is not
-	 * referencing the bitmaps).
+	 * Set the new disk zone parameters only once the queue is frozen and
+	 * all I/Os are completed.
 	 */
 	blk_mq_freeze_queue(q);
 	if (ret > 0) {
 		disk->nr_zones = args.nr_zones;
 		disk->zone_capacity = args.zone_capacity;
-		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
 		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
 		ret = 0;
 	} else {
@@ -1735,7 +1676,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	}
 	blk_mq_unfreeze_queue(q);
 
-	kfree(args.seq_zones_wlock);
 	kfree(args.conv_zones_bitmap);
 
 	return ret;
@@ -1749,17 +1689,29 @@ void blk_zone_dev_init(void)
 
 #ifdef CONFIG_BLK_DEBUG_FS
 
-int queue_zone_wlock_show(void *data, struct seq_file *m)
+int queue_zone_wplugs_show(void *data, struct seq_file *m)
 {
 	struct request_queue *q = data;
+	struct gendisk *disk = q->disk;
+	struct blk_zone_wplug *zwplug;
+	unsigned long flags;
 	unsigned int i;
 
-	if (!q->disk->seq_zones_wlock)
-		return 0;
-
-	for (i = 0; i < q->disk->nr_zones; i++)
-		if (test_bit(i, q->disk->seq_zones_wlock))
-			seq_printf(m, "%u\n", i);
+	rcu_read_lock();
+	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++) {
+		hlist_for_each_entry_rcu(zwplug,
+					 &disk->zone_wplugs_hash[i], node) {
+			spin_lock_irqsave(&zwplug->lock, flags);
+			seq_printf(m, "%u 0x%x %u %u %u\n",
+				   zwplug->zone_no,
+				   zwplug->flags,
+				   atomic_read(&zwplug->ref),
+				   zwplug->wp_offset,
+				   bio_list_size(&zwplug->bio_list));
+			spin_unlock_irqrestore(&zwplug->lock, flags);
+		}
+	}
+	rcu_read_unlock();
 
 	return 0;
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 60090c8366fb..89ba6b16fe8b 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -54,8 +54,6 @@ typedef __u32 __bitwise req_flags_t;
 /* Look at ->special_vec for the actual data payload instead of the
    bio chain. */
 #define RQF_SPECIAL_PAYLOAD	((__force req_flags_t)(1 << 18))
-/* The per-zone write lock is held for this request */
-#define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
 /* The request completion needs to be signaled to zone write pluging. */
 #define RQF_ZONE_WRITE_PLUGGING	((__force req_flags_t)(1 << 20))
 /* ->timeout has been called, don't expire again */
@@ -1152,85 +1150,4 @@ static inline int blk_rq_map_sg(struct request_queue *q, struct request *rq,
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
index ffe0c112b128..5751292fee6a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -297,7 +297,6 @@ enum {
 	BIO_QOS_THROTTLED,	/* bio went through rq_qos throttle path */
 	BIO_QOS_MERGED,		/* but went through rq_qos merge path */
 	BIO_REMAPPED,
-	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
 	BIO_FLAG_LAST
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 82cda82e9891..9e3590ad8a07 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -178,24 +178,15 @@ struct gendisk {
 
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
 	unsigned int		zone_capacity;
 	unsigned int		zone_hw_limits;
 	unsigned long		*conv_zones_bitmap;
-	unsigned long		*seq_zones_wlock;
 	unsigned int		zone_wplugs_pool_size;
 	mempool_t		*zone_wplugs_pool;
 	unsigned int            zone_wplugs_hash_bits;
@@ -638,15 +629,6 @@ static inline unsigned int disk_zone_no(struct gendisk *disk, sector_t sector)
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
@@ -680,10 +662,6 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
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
@@ -873,11 +851,6 @@ static inline bool bio_straddle_zones(struct bio *bio)
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
2.44.0

