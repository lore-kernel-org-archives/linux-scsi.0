Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F054482E6;
	Fri,  2 Feb 2024 07:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859103; cv=none; b=Odul+gj8YX+uKDydXGH7n/D7DPymFp5FH9WhAuWcMjKsjwdv1WgUuo/0VejTcLn3pGhtVRMmVPG3LkGFhnkPMxrVXNFs2Ln+5bw5/77IAs4pQZu5pcOAXLACaSUDITrLbsZke/3KR/4CuSry6fLdNy735PeSkMb3IkbUg9O8QtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859103; c=relaxed/simple;
	bh=7p9/u6sVFTM08YxgkFIISjwvgTCPfP1zry3vGJqXKTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=omuQZdEa/3AEGFKxNAA1UEwHGZUL3j236fddNh79LsUkFI2hcWX9kgjcBVazyV8W49WwxYyOCa1ZxJw5gIkFPjmis1LSlQXd65v63rfWHsu2IRHUHL9Jx5X+XiGg6rSzwtSS422c1k3QNH53YdTwmKLuLKNOZYdZZQ0sgGe0TN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCQ2L03R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCQ2L03R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38F9C43394;
	Fri,  2 Feb 2024 07:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859103;
	bh=7p9/u6sVFTM08YxgkFIISjwvgTCPfP1zry3vGJqXKTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCQ2L03RXaFJBLbLRVVkk8dhn/uBEC/8aXyp6oGnyqXhOyZW76ckd84IOiZdo/H2R
	 O4MCImHR/mVRUZGsuoKK8DaU//Ut5boe2/ABKqySDTxxH4jaORk911qB49DhY/2oJ2
	 0XzgybFwiPd8w0Le/p8Hqc99lGJqHPwPCU6ji9Hvt2rRpDDqnn61ojJTUvp4C3Pi/T
	 XXGmfw/EgD04o6LYr6P5PPXuqvGAJ1xoAnA7XA3+f+tlq/l44PPhB5wzYOwIA0HD9i
	 HU4j5v4SLdEcrlbeGOKl6/u0bQlIqzwZf6Xp6KYZ7mrN+VHMcLttdlQe5KeyQrk0kZ
	 riQS/m4CAy1Zw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 25/26] block: Reduce zone write plugging memory usage
Date: Fri,  2 Feb 2024 16:31:03 +0900
Message-ID: <20240202073104.2418230-26-dlemoal@kernel.org>
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

With zone write plugging, each zone of a zoned block device has a
64B struct blk_zone_wplug. While this is not a problem for small
capacity drives with few zones, this structure size result in large
memory usage per device for large capacity block devices.
E.g., for a 28 TB SMR disk with over 104,000 zones of 256 MB, the zone
write plug array of the gendisk uses 6.6 MB of memory.

However, except for the zone write plug spinlock, flags, zone capacity
and zone write pointer offset which all need to be always available
(the later 2 to avoid having to do too many report zones), the remaining
fields of struct blk_zone_wplug are needed only when a zone is being
written to.

This commit introduces struct blk_zone_active_wplug to reduce the size
of struct blk_zone_wplug from 64B down to 16B. This is done using an
union of a pointer to a struct blk_zone_active_wplug and of the zone
write pointer offset and zone capacity, with the zone write plug
spinlock and flags left as the first fields of struct blk_zone_wplug.

The flag BLK_ZONE_WPLUG_ACTIVE is introduced to indicate if the pointer
to struct blk_zone_active_wplug of a zone write plug is valid. For such
case, the write pointer offset and zone capacity fields are accessible
from struct blk_zone_active_wplug. Otherwise, they can be accessed from
struct blk_zone_wplug.

This data structure organization allows tracking the write pointer
offset of zones regardless of the zone write state (active or not).
Handling of zone reset, reset all and finish operations are modified
to update a zone write pointer offset according to its state.

A zone is activated in blk_zone_wplug_handle_write() with a call to
blk_zone_activate_wplug(). Reclaiming of allocated active zone write
plugs is done after a zone becomes full or is reset and
becomes empty. Reclaiming (freeing) of a zone active write plug
structure is done either directly when a plugged BIO completes and the
zone is full, or when resetting or finishing zones. Freeing of active
zone write plug is done using blk_zone_free_active_wplug().

For allocating struct blk_zone_active_wplug, a mempool is created and
sized according to the disk zone resources (maximum number of open zones
and maximum number of active zones). For devices with no zone resource
limits, the default BLK_ZONE_DEFAULT_ACTIVE_WPLUG_NR (128) is used.

With this mechanism, the amount of memory used per block device for zone
write plugs is roughly reduced by a factor of 4. E.g. for a 28 TB SMR
hard disk, memory usage is reduce to about 1.6 MB.

This commit contains contributions from Christoph Hellwig <hch@lst.de>.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-core.c       |   2 +
 block/blk-zoned.c      | 293 ++++++++++++++++++++++++++++++++---------
 block/blk.h            |   4 +
 include/linux/blkdev.h |   4 +
 4 files changed, 240 insertions(+), 63 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 5cef05572f68..e926f17d04d8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1220,5 +1220,7 @@ int __init blk_dev_init(void)
 
 	blk_debugfs_root = debugfs_create_dir("block", NULL);
 
+	blk_zone_dev_init();
+
 	return 0;
 }
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 4da634e9f5a0..865fc372f25e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -36,17 +36,33 @@ static const char *const zone_cond_name[] = {
 #undef ZONE_COND_NAME
 
 /*
- * Per-zone write plug.
+ * Active zone write plug.
  */
-struct blk_zone_wplug {
-	spinlock_t		lock;
-	unsigned int		flags;
+struct blk_zone_active_wplug {
+	struct blk_zone_wplug	*zwplug;
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	unsigned int		wp_offset;
 	unsigned int		capacity;
 };
 
+static struct kmem_cache *blk_zone_active_wplugs_cachep;
+
+/*
+ * Per-zone write plug.
+ */
+struct blk_zone_wplug {
+	spinlock_t		lock;
+	unsigned int		flags;
+	union {
+		struct {
+			unsigned int	wp_offset;
+			unsigned int	capacity;
+		} info;
+		struct blk_zone_active_wplug *zawplug;
+	};
+};
+
 /*
  * Zone write plug flags bits:
  *  - BLK_ZONE_WPLUG_CONV: Indicate that the zone is a conventional one. Writes
@@ -56,10 +72,13 @@ struct blk_zone_wplug {
  *    being executed or the zone write plug bio list is not empty.
  *  - BLK_ZONE_WPLUG_ERROR: Indicate that a write error happened which will be
  *    recovered with a report zone to update the zone write pointer offset.
+ *  - BLK_ZONE_WPLUG_ACTIVE: Indicate that the zone is active, meaning that
+ *    a struct blk_zone_active_wplug was allocated for the zone.
  */
 #define BLK_ZONE_WPLUG_CONV	(1U << 0)
 #define BLK_ZONE_WPLUG_PLUGGED	(1U << 1)
 #define BLK_ZONE_WPLUG_ERROR	(1U << 2)
+#define BLK_ZONE_WPLUG_ACTIVE	(1U << 3)
 
 /**
  * blk_zone_cond_str - Return string XXX in BLK_ZONE_COND_XXX.
@@ -426,13 +445,13 @@ static inline void blk_zone_wplug_bio_io_error(struct bio *bio)
 	blk_queue_exit(q);
 }
 
-static int blk_zone_wplug_abort(struct gendisk *disk,
-				struct blk_zone_wplug *zwplug)
+static int blk_zone_active_wplug_abort(struct gendisk *disk,
+				struct blk_zone_active_wplug *zawplug)
 {
 	struct bio *bio;
 	int nr_aborted = 0;
 
-	while ((bio = bio_list_pop(&zwplug->bio_list))) {
+	while ((bio = bio_list_pop(&zawplug->bio_list))) {
 		blk_zone_wplug_bio_io_error(bio);
 		nr_aborted++;
 	}
@@ -440,15 +459,15 @@ static int blk_zone_wplug_abort(struct gendisk *disk,
 	return nr_aborted;
 }
 
-static void blk_zone_wplug_abort_unaligned(struct gendisk *disk,
-					   struct blk_zone_wplug *zwplug)
+static void blk_zone_active_wplug_abort_unaligned(struct gendisk *disk,
+				struct blk_zone_active_wplug *zawplug)
 {
-	unsigned int wp_offset = zwplug->wp_offset;
+	unsigned int wp_offset = zawplug->wp_offset;
 	struct bio_list bl = BIO_EMPTY_LIST;
 	struct bio *bio;
 
-	while ((bio = bio_list_pop(&zwplug->bio_list))) {
-		if (wp_offset >= zwplug->capacity ||
+	while ((bio = bio_list_pop(&zawplug->bio_list))) {
+		if (wp_offset >= zawplug->capacity ||
 		    (bio_op(bio) != REQ_OP_ZONE_APPEND &&
 		     bio_offset_from_zone_start(bio) != wp_offset)) {
 			blk_zone_wplug_bio_io_error(bio);
@@ -459,7 +478,57 @@ static void blk_zone_wplug_abort_unaligned(struct gendisk *disk,
 		bio_list_add(&bl, bio);
 	}
 
-	bio_list_merge(&zwplug->bio_list, &bl);
+	bio_list_merge(&zawplug->bio_list, &bl);
+}
+
+static void blk_zone_wplug_bio_work(struct work_struct *work);
+
+/*
+ * Activate an inactive zone by allocating its active write plug.
+ */
+static bool blk_zone_activate_wplug(struct gendisk *disk,
+				    struct blk_zone_wplug *zwplug)
+{
+	struct blk_zone_active_wplug *zawplug;
+
+	/* If we have an active write plug already, keep using it. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_ACTIVE)
+		return true;
+
+	/*
+	 * Allocate an active write plug. This may fail if the mempool is fully
+	 * used if the user partially writes too many zones, which is possible
+	 * if the device has no active zone limit, if the user is not respecting
+	 * the open zone limit or if the device has no limits at all.
+	 */
+	zawplug = mempool_alloc(disk->zone_awplugs_pool, GFP_NOWAIT);
+	if (!zawplug)
+		return false;
+
+	zawplug->zwplug = zwplug;
+	bio_list_init(&zawplug->bio_list);
+	INIT_WORK(&zawplug->bio_work, blk_zone_wplug_bio_work);
+	zawplug->capacity = zwplug->info.capacity;
+	zawplug->wp_offset = zwplug->info.wp_offset;
+
+	zwplug->zawplug = zawplug;
+	zwplug->flags |= BLK_ZONE_WPLUG_ACTIVE;
+
+	return true;
+}
+
+static void blk_zone_free_active_wplug(struct gendisk *disk,
+				       struct blk_zone_active_wplug *zawplug)
+{
+	struct blk_zone_wplug *zwplug = zawplug->zwplug;
+
+	WARN_ON_ONCE(!bio_list_empty(&zawplug->bio_list));
+
+	zwplug->flags &= ~(BLK_ZONE_WPLUG_PLUGGED | BLK_ZONE_WPLUG_ACTIVE);
+	zwplug->info.capacity = zawplug->capacity;
+	zwplug->info.wp_offset = zawplug->wp_offset;
+
+	mempool_free(zawplug, disk->zone_awplugs_pool);
 }
 
 /*
@@ -499,6 +568,8 @@ static void blk_zone_wplug_set_wp_offset(struct gendisk *disk,
 					 struct blk_zone_wplug *zwplug,
 					 unsigned int wp_offset)
 {
+	struct blk_zone_active_wplug *zawplug;
+
 	/*
 	 * Updating the write pointer offset puts back the zone
 	 * in a good state. So clear the error flag and decrement the
@@ -509,9 +580,24 @@ static void blk_zone_wplug_set_wp_offset(struct gendisk *disk,
 		atomic_dec(&disk->zone_nr_wplugs_with_error);
 	}
 
+	/* Inactive zones only need the write pointer updated. */
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_ACTIVE)) {
+		zwplug->info.wp_offset = wp_offset;
+		return;
+	}
+
 	/* Update the zone write pointer and abort all plugged BIOs. */
-	zwplug->wp_offset = wp_offset;
-	blk_zone_wplug_abort(disk, zwplug);
+	zawplug = zwplug->zawplug;
+	zawplug->wp_offset = wp_offset;
+	blk_zone_active_wplug_abort(disk, zawplug);
+
+	/*
+	 * We have no remaining plugged BIOs. So if there is no BIO being
+	 * executed (i.e. the zone is not plugged), then free the active write
+	 * plug as it is now either full or empty.
+	 */
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED))
+		blk_zone_free_active_wplug(disk, zawplug);
 }
 
 static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
@@ -526,9 +612,6 @@ static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
 		return true;
 	}
 
-	if (!bdev_emulates_zone_append(bio->bi_bdev))
-		return false;
-
 	/*
 	 * Set the zone write pointer offset to 0 (reset case) or to the
 	 * zone size (finish case). This will abort all BIOs plugged for the
@@ -549,9 +632,6 @@ static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
 	unsigned long flags;
 	unsigned int i;
 
-	if (!bdev_emulates_zone_append(bio->bi_bdev))
-		return false;
-
 	/*
 	 * Set the write pointer offset of all zones to 0. This will abort all
 	 * plugged BIOs. It is fine as resetting zones while writes are still
@@ -598,7 +678,7 @@ static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
 	 * user must also issue write sequentially. So simply add the new BIO
 	 * at the tail of the list to preserve the sequential write order.
 	 */
-	bio_list_add(&zwplug->bio_list, bio);
+	bio_list_add(&zwplug->zawplug->bio_list, bio);
 }
 
 /*
@@ -623,7 +703,8 @@ void blk_zone_write_plug_bio_merged(struct bio *bio)
 	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 
 	/* Advance the zone write pointer offset. */
-	zwplug->wp_offset += bio_sectors(bio);
+	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_ACTIVE));
+	zwplug->zawplug->wp_offset += bio_sectors(bio);
 
 	blk_zone_wplug_unlock(zwplug, flags);
 }
@@ -636,6 +717,7 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 {
 	struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(req->bio);
 	sector_t req_back_sector = blk_rq_pos(req) + blk_rq_sectors(req);
+	struct blk_zone_active_wplug *zawplug = zwplug->zawplug;
 	struct request_queue *q = req->q;
 	unsigned long flags;
 	struct bio *bio;
@@ -654,8 +736,8 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 	 * into the back of the request.
 	 */
 	blk_zone_wplug_lock(zwplug, flags);
-	while (zwplug->wp_offset < zwplug->capacity &&
-	       (bio = bio_list_peek(&zwplug->bio_list))) {
+	while (zawplug->wp_offset < zawplug->capacity &&
+	       (bio = bio_list_peek(&zawplug->bio_list))) {
 		if (bio->bi_iter.bi_sector != req_back_sector ||
 		    !blk_rq_merge_ok(req, bio))
 			break;
@@ -663,10 +745,10 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 		WARN_ON_ONCE(bio_op(bio) != REQ_OP_WRITE_ZEROES &&
 			     !bio->__bi_nr_segments);
 
-		bio_list_pop(&zwplug->bio_list);
+		bio_list_pop(&zawplug->bio_list);
 		if (bio_attempt_back_merge(req, bio, bio->__bi_nr_segments) !=
 		    BIO_MERGE_OK) {
-			bio_list_add_head(&zwplug->bio_list, bio);
+			bio_list_add_head(&zawplug->bio_list, bio);
 			break;
 		}
 
@@ -675,7 +757,7 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 		 * plugging the BIO and advance the write pointer offset.
 		 */
 		blk_queue_exit(q);
-		zwplug->wp_offset += bio_sectors(bio);
+		zawplug->wp_offset += bio_sectors(bio);
 
 		req_back_sector += bio_sectors(bio);
 	}
@@ -698,12 +780,7 @@ static inline void blk_zone_wplug_set_error(struct gendisk *disk,
 static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 				       struct bio *bio)
 {
-	/*
-	 * If we do not need to emulate zone append, zone write pointer offset
-	 * tracking is not necessary and we have nothing to do.
-	 */
-	if (!bdev_emulates_zone_append(bio->bi_bdev))
-		return true;
+	struct blk_zone_active_wplug *zawplug = zwplug->zawplug;
 
 	/*
 	 * Check that the user is not attempting to write to a full zone.
@@ -711,7 +788,7 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 	 * write pointer offset, causing zone append BIOs for one zone to be
 	 * directed at the following zone.
 	 */
-	if (zwplug->wp_offset >= zwplug->capacity)
+	if (zawplug->wp_offset >= zawplug->capacity)
 		goto err;
 
 	if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
@@ -722,7 +799,7 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 		 */
 		bio->bi_opf &= ~REQ_OP_MASK;
 		bio->bi_opf |= REQ_OP_WRITE | REQ_NOMERGE;
-		bio->bi_iter.bi_sector += zwplug->wp_offset;
+		bio->bi_iter.bi_sector += zawplug->wp_offset;
 
 		/*
 		 * Remember that this BIO is in fact a zone append operation
@@ -735,12 +812,12 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 		 * whole lot of error handling trouble if we don't send it off
 		 * to the driver.
 		 */
-		if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
+		if (bio_offset_from_zone_start(bio) != zawplug->wp_offset)
 			goto err;
 	}
 
 	/* Advance the zone write pointer offset. */
-	zwplug->wp_offset += bio_sectors(bio);
+	zawplug->wp_offset += bio_sectors(bio);
 
 	return true;
 
@@ -785,6 +862,12 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 
 	blk_zone_wplug_lock(zwplug, flags);
 
+	if (!blk_zone_activate_wplug(bio->bi_bdev->bd_disk, zwplug)) {
+		blk_zone_wplug_unlock(zwplug, flags);
+		bio_io_error(bio);
+		return true;
+	}
+
 	/* Indicate that this BIO is being handled using zone write plugging. */
 	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 
@@ -867,6 +950,15 @@ bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
 	 * not need serialization with write and append operations. It is the
 	 * responsibility of the user to not issue reset and finish commands
 	 * when write operations are in flight.
+	 *
+	 * Note: for native zone append operations, we do not do any tracking of
+	 * the zone write pointer offset. This means that zones written only
+	 * using zone append operations will never be activated, thus avoiding
+	 * any overhead. If the user mixes regular writes and native zone append
+	 * operations for the same zone, the zone write plug will be activated
+	 * and have an incorrect write pointer offset. That is fine as mixing
+	 * these operations will very likely fail anyway, in which case the
+	 * zone error handling will recover a correct write pointer offset.
 	 */
 	switch (bio_op(bio)) {
 	case REQ_OP_ZONE_APPEND:
@@ -894,6 +986,7 @@ EXPORT_SYMBOL_GPL(blk_zone_write_plug_bio);
 static void blk_zone_write_plug_unplug_bio(struct gendisk *disk,
 					   struct blk_zone_wplug *zwplug)
 {
+	struct blk_zone_active_wplug *zawplug;
 	unsigned long flags;
 
 	blk_zone_wplug_lock(zwplug, flags);
@@ -910,10 +1003,22 @@ static void blk_zone_write_plug_unplug_bio(struct gendisk *disk,
 	}
 
 	/* Schedule submission of the next plugged BIO if we have one. */
-	if (!bio_list_empty(&zwplug->bio_list))
-		kblockd_schedule_work(&zwplug->bio_work);
-	else
-		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
+	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_ACTIVE));
+	zawplug = zwplug->zawplug;
+	if (!bio_list_empty(&zawplug->bio_list)) {
+		kblockd_schedule_work(&zawplug->bio_work);
+		blk_zone_wplug_unlock(zwplug, flags);
+		return;
+	}
+
+	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
+
+	/*
+	 * If the zone is empty (a reset was executed) or was fully written
+	 * (or a zone finish was executed), free its active write plug.
+	 */
+	if (!zawplug->wp_offset || zawplug->wp_offset >= zawplug->capacity)
+		blk_zone_free_active_wplug(disk, zawplug);
 
 	blk_zone_wplug_unlock(zwplug, flags);
 }
@@ -964,8 +1069,9 @@ void blk_zone_write_plug_complete_request(struct request *req)
 
 static void blk_zone_wplug_bio_work(struct work_struct *work)
 {
-	struct blk_zone_wplug *zwplug =
-		container_of(work, struct blk_zone_wplug, bio_work);
+	struct blk_zone_active_wplug *zawplug =
+		container_of(work, struct blk_zone_active_wplug, bio_work);
+	struct blk_zone_wplug *zwplug = zawplug->zwplug;
 	unsigned long flags;
 	struct bio *bio;
 
@@ -975,7 +1081,7 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 	 */
 	blk_zone_wplug_lock(zwplug, flags);
 
-	bio = bio_list_pop(&zwplug->bio_list);
+	bio = bio_list_pop(&zawplug->bio_list);
 	if (!bio) {
 		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
 		blk_zone_wplug_unlock(zwplug, flags);
@@ -984,7 +1090,7 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
 		/* Error recovery will decide what to do with the BIO. */
-		bio_list_add_head(&zwplug->bio_list, bio);
+		bio_list_add_head(&zawplug->bio_list, bio);
 		blk_zone_wplug_unlock(zwplug, flags);
 		return;
 	}
@@ -1039,7 +1145,8 @@ static void blk_zone_wplug_handle_error(struct gendisk *disk,
 {
 	unsigned int zno = zwplug - disk->zone_wplugs;
 	sector_t zone_start_sector = bdev_zone_sectors(disk->part0) * zno;
-	unsigned int noio_flag;
+	struct blk_zone_active_wplug *zawplug;
+	unsigned int noio_flag, wp_offset;
 	struct blk_zone zone;
 	unsigned long flags;
 	int ret;
@@ -1068,25 +1175,40 @@ static void blk_zone_wplug_handle_error(struct gendisk *disk,
 		 * forever on plugged BIOs to complete if there is a revalidate
 		 * or queue freeze on-going.
 		 */
-		blk_zone_wplug_abort(disk, zwplug);
-		goto unplug;
+		if (zwplug->flags & BLK_ZONE_WPLUG_ACTIVE) {
+			zawplug = zwplug->zawplug;
+			zawplug->wp_offset = UINT_MAX;
+			blk_zone_active_wplug_abort(disk, zawplug);
+			goto unplug;
+		}
+		goto unlock;
 	}
 
 	/* Update the zone capacity and write pointer offset. */
-	zwplug->wp_offset = blk_zone_wp_offset(&zone);
-	zwplug->capacity = zone.capacity;
+	wp_offset = blk_zone_wp_offset(&zone);
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_ACTIVE)) {
+		zwplug->info.wp_offset = wp_offset;
+		zwplug->info.capacity = zone.capacity;
+		goto unlock;
+	}
 
-	blk_zone_wplug_abort_unaligned(disk, zwplug);
+	zawplug = zwplug->zawplug;
+	zawplug->wp_offset = wp_offset;
+	zawplug->capacity = zone.capacity;
+
+	blk_zone_active_wplug_abort_unaligned(disk, zawplug);
 
 	/* Restart BIO submission if we still have any BIO left. */
-	if (!bio_list_empty(&zwplug->bio_list)) {
+	if (!bio_list_empty(&zawplug->bio_list)) {
 		WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
-		kblockd_schedule_work(&zwplug->bio_work);
+		kblockd_schedule_work(&zawplug->bio_work);
 		goto unlock;
 	}
 
 unplug:
 	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
+	if (!zawplug->wp_offset || zawplug->wp_offset >= zawplug->capacity)
+		blk_zone_free_active_wplug(disk, zawplug);
 
 unlock:
 	blk_zone_wplug_unlock(zwplug, flags);
@@ -1125,11 +1247,8 @@ static struct blk_zone_wplug *blk_zone_alloc_write_plugs(unsigned int nr_zones)
 	if (!zwplugs)
 		return NULL;
 
-	for (i = 0; i < nr_zones; i++) {
+	for (i = 0; i < nr_zones; i++)
 		spin_lock_init(&zwplugs[i].lock);
-		bio_list_init(&zwplugs[i].bio_list);
-		INIT_WORK(&zwplugs[i].bio_work, blk_zone_wplug_bio_work);
-	}
 
 	return zwplugs;
 }
@@ -1152,7 +1271,12 @@ static void blk_zone_free_write_plugs(struct gendisk *disk,
 			atomic_dec(&disk->zone_nr_wplugs_with_error);
 			zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
 		}
-		n = blk_zone_wplug_abort(disk, zwplug);
+		if (!(zwplug->flags & BLK_ZONE_WPLUG_ACTIVE)) {
+			blk_zone_wplug_unlock(zwplug, flags);
+			continue;
+		}
+		n = blk_zone_active_wplug_abort(disk, zwplug->zawplug);
+		blk_zone_free_active_wplug(disk, zwplug->zawplug);
 		blk_zone_wplug_unlock(zwplug, flags);
 		if (n)
 			pr_warn_ratelimited("%s: zone %u, %u plugged BIOs aborted\n",
@@ -1171,6 +1295,8 @@ void disk_free_zone_resources(struct gendisk *disk)
 	disk->zone_wplugs = NULL;
 
 	mutex_destroy(&disk->zone_wplugs_mutex);
+	mempool_destroy(disk->zone_awplugs_pool);
+	disk->zone_awplugs_pool = NULL;
 }
 
 struct blk_revalidate_zone_args {
@@ -1226,8 +1352,8 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 		args->zone_wplugs[idx].flags |= BLK_ZONE_WPLUG_CONV;
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
-		args->zone_wplugs[idx].capacity = zone->capacity;
-		args->zone_wplugs[idx].wp_offset = blk_zone_wp_offset(zone);
+		args->zone_wplugs[idx].info.capacity = zone->capacity;
+		args->zone_wplugs[idx].info.wp_offset = blk_zone_wp_offset(zone);
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:
 	default:
@@ -1240,6 +1366,25 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	return 0;
 }
 
+#define BLK_ZONE_DEFAULT_ACTIVE_WPLUG_NR	128
+
+static int blk_zone_active_wplugs_pool_size(struct gendisk *disk,
+					    unsigned int nr_zones)
+{
+	unsigned int pool_size;
+
+	/*
+	 * Size the disk mempool of active zone write plugs with enough elements
+	 * given the device open and active zones limits. There may be no device
+	 * limits, in which case, we use BLK_ZONE_DEFAULT_ACTIVE_WPLUG_NR.
+	 */
+	pool_size = max(disk->max_active_zones, disk->max_open_zones);
+	if (!pool_size)
+		pool_size = BLK_ZONE_DEFAULT_ACTIVE_WPLUG_NR;
+
+	return min(pool_size, nr_zones);
+}
+
 /**
  * blk_revalidate_disk_zones - (re)allocate and initialize zone write plugs
  * @disk:	Target disk
@@ -1260,6 +1405,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	sector_t capacity = get_capacity(disk);
 	struct blk_revalidate_zone_args args = { };
 	unsigned int nr_zones, noio_flag;
+	unsigned int pool_size;
 	int ret = -ENOMEM;
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
@@ -1297,11 +1443,23 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	if (!args.zone_wplugs)
 		goto out_restore_noio;
 
+	pool_size = blk_zone_active_wplugs_pool_size(disk, nr_zones);
 	if (!disk->zone_wplugs) {
 		mutex_init(&disk->zone_wplugs_mutex);
 		atomic_set(&disk->zone_nr_wplugs_with_error, 0);
 		INIT_DELAYED_WORK(&disk->zone_wplugs_work,
 				  disk_zone_wplugs_work);
+		disk->zone_awplugs_pool_size = pool_size;
+		disk->zone_awplugs_pool =
+			mempool_create_slab_pool(disk->zone_awplugs_pool_size,
+						 blk_zone_active_wplugs_cachep);
+		if (!disk->zone_awplugs_pool)
+			goto out_restore_noio;
+	} else if (disk->zone_awplugs_pool_size != pool_size) {
+		ret = mempool_resize(disk->zone_awplugs_pool, pool_size);
+		if (ret)
+			goto out_restore_noio;
+		disk->zone_awplugs_pool_size = pool_size;
 	}
 
 	ret = disk->fops->report_zones(disk, 0, UINT_MAX,
@@ -1332,19 +1490,20 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 		disk->nr_zones = nr_zones;
 		swap(disk->zone_wplugs, args.zone_wplugs);
 		mutex_unlock(&disk->zone_wplugs_mutex);
+		blk_zone_free_write_plugs(disk, args.zone_wplugs, nr_zones);
 		ret = 0;
 	} else {
 		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
+		blk_zone_free_write_plugs(disk, args.zone_wplugs, nr_zones);
 		disk_free_zone_resources(disk);
 	}
 	blk_mq_unfreeze_queue(q);
 
-	blk_zone_free_write_plugs(disk, args.zone_wplugs, nr_zones);
-
 	return ret;
 
 out_restore_noio:
 	memalloc_noio_restore(noio_flag);
+	blk_zone_free_write_plugs(disk, args.zone_wplugs, nr_zones);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
@@ -1368,3 +1527,11 @@ int queue_zone_plugged_wplugs_show(void *data, struct seq_file *m)
 }
 
 #endif
+
+void blk_zone_dev_init(void)
+{
+	blk_zone_active_wplugs_cachep =
+		kmem_cache_create("blk_zone_active_wplug",
+				  sizeof(struct blk_zone_active_wplug), 0,
+				  SLAB_PANIC, NULL);
+}
diff --git a/block/blk.h b/block/blk.h
index 7fbef6bb1aee..7e08bdddb725 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -403,6 +403,7 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 }
 
 #ifdef CONFIG_BLK_DEV_ZONED
+void blk_zone_dev_init(void);
 void disk_free_zone_resources(struct gendisk *disk);
 static inline bool bio_zone_write_plugging(struct bio *bio)
 {
@@ -436,6 +437,9 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 #else /* CONFIG_BLK_DEV_ZONED */
+void blk_zone_dev_init(void)
+{
+}
 static inline void disk_free_zone_resources(struct gendisk *disk)
 {
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e96baa552e12..e444dab0bef8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -24,6 +24,8 @@
 #include <linux/sbitmap.h>
 #include <linux/uuid.h>
 #include <linux/xarray.h>
+#include <linux/timekeeping.h>
+#include <linux/mempool.h>
 
 struct module;
 struct request_queue;
@@ -188,6 +190,8 @@ struct gendisk {
 	struct mutex		zone_wplugs_mutex;
 	atomic_t		zone_nr_wplugs_with_error;
 	struct delayed_work	zone_wplugs_work;
+	unsigned int		zone_awplugs_pool_size;
+	mempool_t		*zone_awplugs_pool;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 #if IS_ENABLED(CONFIG_CDROM)
-- 
2.43.0

