Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4BDDDBD;
	Thu, 28 Mar 2024 00:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586668; cv=none; b=nrSfe7iMhO6egUV20DsWcX6zF7I9wKAafk1X4riHyVRPlTuLHfJOUrE/2dvKWuywa7xC9OJKixUuDDyGJiEy9Pkew1g7gRt2IbGycdwSRbG5g1M+7j+yyF3y/Apw5LYGyIaCk/5Prza71wNyy27fV6MmaRoMQhaojpovqGsXZXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586668; c=relaxed/simple;
	bh=KtpNurEW7RUKH+aaJ8BOzwJRO9mLCe+9fwUXLYfosMg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5SS7ea5sfPLjPLckVRJ5wot02XrQHzD5vcLQrdpmWyFTr7KIybsQDQmmSAi8LOIYN9a99KcleCuDyigUFswc2t/We9CslDJyCq6KkcjeUHpQ42AX9HXV/9wqVrTF4pii0CIXT9veWOpKoPemvoRdqCYN2zvy365Kf0Mwjq6Y7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IM8L/lce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IM8L/lce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8E5C433A6;
	Thu, 28 Mar 2024 00:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586667;
	bh=KtpNurEW7RUKH+aaJ8BOzwJRO9mLCe+9fwUXLYfosMg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IM8L/lceF8Y/Mog4WC0nHLGUvqyc6c88a+zQ77QrIbiiZAUvk8TluNZ6HkqB/XY9O
	 fbjmjPgryW3ykRYYpu+J9n2e8LHqAEpkvOG0aDn2eGPKV6JzEW/0zClL0ANP1X7iG3
	 Hxa3VNQKa9eIDeoMlB2yeBTJmTAtvswGw4VS9eT9LDUFWHAr0mKz5slZeWuZ2DmI6D
	 1GnW0s1NVQ407r8xqzMLzTiRT49LgvDH98435wqpykPFBlwTMcrFryRV+XgkOyi/kZ
	 0gfH61SHNLB5jgC7REHrcduSgO22mMIof6QvhTBq8lNtJwr+bm7i67O1kWmQ9iziJc
	 6qiKupGuvoeWQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 08/30] block: Introduce zone write plugging
Date: Thu, 28 Mar 2024 09:43:47 +0900
Message-ID: <20240328004409.594888-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zone write plugging implements a per-zone "plug" for write operations
to control the submission and execution order of write operations to
sequential write required zones of a zoned block device. Per-zone
plugging guarantees that at any time there is at most only one write
request per zone being executed. This mechanism is intended to replace
zone write locking which implements a similar per-zone write throttling
at the scheduler level, but is implemented only by mq-deadline.

Unlike zone write locking which operates on requests, zone write
plugging operates on BIOs. A zone write plug is simply a BIO list that
is atomically manipulated using a spinlock and a kblockd submission
work. A write BIO to a zone is "plugged" to delay its execution if a
write BIO for the same zone was already issued, that is, if a write
request for the same zone is being executed. The next plugged BIO is
unplugged and issued once the write request completes.

This mechanism allows to:
 - Untangle zone write ordering from block IO schedulers. This allows
   removing the restriction on using mq-deadline for writing to zoned
   block devices. Any block IO scheduler, including "none" can be used.
 - Zone write plugging operates on BIOs instead of requests. Plugged
   BIOs waiting for execution thus do not hold scheduling tags and thus
   are not preventing other BIOs from executing (reads or writes to
   other zones). Depending on the workload, this can significantly
   improve the device use (higher queue depth operation) and
   performance.
 - Both blk-mq (request based) zoned devices and BIO-based zoned devices
   (e.g.  device mapper) can use zone write plugging. It is mandatory
   for the former but optional for the latter. BIO-based drivers can
   use zone write plugging to implement write ordering guarantees, or
   the drivers can implement their own if needed.
 - The code is less invasive in the block layer and is mostly limited to
   blk-zoned.c with some small changes in blk-mq.c, blk-merge.c and
   bio.c.

Zone write plugging is implemented using struct blk_zone_wplug. This
structure includes a spinlock, a BIO list and a work structure to
handle the submission of plugged BIOs. Zone write plugs structures are
managed using a per-disk hash table.

Plugging of zone write BIOs is done using the function
blk_zone_write_plug_bio() which returns false if a BIO execution does
not need to be delayed and true otherwise. This function is called
from blk_mq_submit_bio() after a BIO is split to avoid large BIOs
spanning multiple zones which would cause mishandling of zone write
plugs. This ichange enables by default zone write plugging for any mq
request-based block device. BIO-based device drivers can also use zone
write plugging by expliclty calling blk_zone_write_plug_bio() in their
->submit_bio method. For such devices, the driver must ensure that a
BIO passed to blk_zone_write_plug_bio() is already split and not
straddling zone boundaries.

Only write and write zeroes BIOs are plugged. Zone write plugging does
not introduce any significant overhead for other operations. A BIO that
is being handled through zone write plugging is flagged using the new
BIO flag BIO_ZONE_WRITE_PLUGGING. A request handling a BIO flagged with
this new flag is flagged with the new RQF_ZONE_WRITE_PLUGGING flag.
The completion of BIOs and requests flagged trigger respectively calls
to the functions blk_zone_write_plug_bio_endio() and
blk_zone_write_plug_complete_request(). The latter function is used to
trigger submission of the next plugged BIO using the zone plug work.
blk_zone_write_plug_bio_endio() does the same for BIO-based devices.
This ensures that at any time, at most one request (blk-mq devices) or
one BIO (BIO-based devices) is being executed for any zone. The
handling of zone write plugs using a per-zone plug spinlock maximizes
parallelism and device usage by allowing multiple zones to be writen
simultaneously without lock contention.

Zone write plugging ignores flush BIOs without data. Hovever, any flush
BIO that has data is always plugged so that the write part of the flush
sequence is serialized with other regular writes.

Given that any BIO handled through zone write plugging will be the only
BIO in flight for the target zone when it is executed, the unplugging
and submission of a BIO will have no chance of successfully merging with
plugged requests or requests in the scheduler. To overcome this
potential performance degradation, blk_mq_submit_bio() calls the
function blk_zone_write_plug_attempt_merge() to try to merge other
plugged BIOs with the one just unplugged and submitted. Successful
merging is signaled using blk_zone_write_plug_bio_merged(), called from
bio_attempt_back_merge(). Furthermore, to avoid recalculating the number
of segments of plugged BIOs to attempt merging, the number of segments
of a plugged BIO is saved using the new struct bio field
__bi_nr_segments. To avoid growing the size of struct bio, this field is
added as a union with the bio_cookie field. This is safe to do as
polling is always disabled for plugged BIOs.

When BIOs are plugged in a zone write plug, the device request queue
usage counter is always incremented. This reference is kept and reused
for blk-mq devices when the plugged BIO is unplugged and submitted
again using submit_bio_noacct_nocheck(). For this case, the unplugged
BIO is already flagged with BIO_ZONE_WRITE_PLUGGING and
blk_mq_submit_bio() proceeds directly to allocating a new request for
the BIO, re-using the usage reference count taken when the BIO was
plugged. This extra reference count is dropped in
blk_zone_write_plug_attempt_merge() for any plugged BIO that is
successfully merged. Given that BIO-based devices will not take this
path, the extra reference is dropped after a plugged BIO is unplugged
and submitted.

Zone write plugs are dynamically allocated and managed using a hash
table (an array of struct hlist_head) with RCU protection.
A zone write plug is allocated when a write BIO is received for the
zone and not freed until the zone is fully written, reset or finished.
To detect when a zone write plug can be freed, the write state of each
zone is tracked using a write pointer offset which corresponds to the
offset of a zone write pointer relative to the zone start. Write
operations always increment this write pointer offset. Zone reset
operations set it to 0 and zone finish operations set it to the zone
size.

If a write error happens, the wp_offset value of a zone write plug may
become incorrect and out of sync with the device managed write pointer.
This is handled using the zone write plug flag BLK_ZONE_WPLUG_ERROR.
The function blk_zone_wplug_handle_error() is called from the new disk
zone write plug work when this flag is set. This function executes a
report zone to update the zone write pointer offset to the current
value as indicated by the device. The disk zone write plug work is
scheduled whenever a BIO flagged with BIO_ZONE_WRITE_PLUGGING completes
with an error or when bio_zone_wplug_prepare_bio() detects an unaligned
write. Once scheduled, the disk zone write plugs work keeps running
until all zone errors are handled.

To match the new data structures used for zoned disks, the function
disk_free_zone_bitmaps() is renamed to the more generic
disk_free_zone_resources(). The function disk_init_zone_resources() is
also introduced to initialize zone write plugs resources when a gendisk
is allocated.

This commit contains contributions from Christoph Hellwig <hch@lst.de>.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/bio.c               |    7 +
 block/blk-merge.c         |   11 +
 block/blk-mq.c            |   38 +-
 block/blk-zoned.c         | 1098 ++++++++++++++++++++++++++++++++++++-
 block/blk.h               |   36 +-
 block/genhd.c             |    3 +-
 include/linux/blk-mq.h    |    2 +
 include/linux/blk_types.h |    8 +-
 include/linux/blkdev.h    |   11 +
 9 files changed, 1203 insertions(+), 11 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index d24420ed1c4c..4ece8cef1fbe 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1576,6 +1576,13 @@ void bio_endio(struct bio *bio)
 	if (!bio_integrity_endio(bio))
 		return;
 
+	/*
+	 * For BIOs handled through a zone write plug, signal the completion
+	 * of the BIO so that the next plugged BIO can be submitted.
+	 */
+	if (bio_zone_write_plugging(bio))
+		blk_zone_write_plug_bio_endio(bio);
+
 	rq_qos_done_bio(bio);
 
 	if (bio->bi_bdev && bio_flagged(bio, BIO_TRACE_COMPLETION)) {
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 88367c10c8bc..b96466d2ba94 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -377,6 +377,7 @@ struct bio *__bio_split_to_limits(struct bio *bio,
 		blkcg_bio_issue_init(split);
 		bio_chain(split, bio);
 		trace_block_split(split, bio->bi_iter.bi_sector);
+		WARN_ON_ONCE(bio_zone_write_plugging(bio));
 		submit_bio_noacct(bio);
 		return split;
 	}
@@ -988,6 +989,9 @@ enum bio_merge_status bio_attempt_back_merge(struct request *req,
 
 	blk_update_mixed_merge(req, bio, false);
 
+	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
+		blk_zone_write_plug_bio_merged(bio);
+
 	req->biotail->bi_next = bio;
 	req->biotail = bio;
 	req->__data_len += bio->bi_iter.bi_size;
@@ -1003,6 +1007,13 @@ static enum bio_merge_status bio_attempt_front_merge(struct request *req,
 {
 	const blk_opf_t ff = bio_failfast(bio);
 
+	/*
+	 * A front merge for zone writes can happen only if the user submitted
+	 * writes out of order. Do not attempt this to let the write fail.
+	 */
+	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
+		return BIO_MERGE_FAILED;
+
 	if (!ll_front_merge_fn(req, bio, nr_segs))
 		return BIO_MERGE_FAILED;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 70dfb4af65cf..4b8dd2e7b870 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -828,6 +828,9 @@ static void blk_complete_request(struct request *req)
 		bio = next;
 	} while (bio);
 
+	if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
+		blk_zone_write_plug_complete_request(req);
+
 	/*
 	 * Reset counters so that the request stacking driver
 	 * can find how many bytes remain in the request
@@ -938,6 +941,9 @@ bool blk_update_request(struct request *req, blk_status_t error,
 	 * completely done
 	 */
 	if (!req->bio) {
+		if (req->rq_flags & RQF_ZONE_WRITE_PLUGGING)
+			blk_zone_write_plug_complete_request(req);
+
 		/*
 		 * Reset counters so that the request stacking driver
 		 * can find how many bytes remain in the request
@@ -2952,15 +2958,30 @@ void blk_mq_submit_bio(struct bio *bio)
 	struct request *rq;
 	blk_status_t ret;
 
+	/*
+	 * If the plug has a cached request for this queue, try use it.
+	 */
+	rq = blk_mq_peek_cached_request(plug, q, bio->bi_opf);
+
+	/*
+	 * A BIO that was released from a zone write plug has already been
+	 * through the preparation in this function, already holds a reference
+	 * on the queue usage counter, and is the only write BIO in-flight for
+	 * the target zone. Go straight to preparing a request for it.
+	 */
+	if (bio_zone_write_plugging(bio)) {
+		nr_segs = bio->__bi_nr_segments;
+		if (rq)
+			blk_queue_exit(q);
+		goto new_request;
+	}
+
 	bio = blk_queue_bounce(bio, q);
 
 	/*
-	 * If the plug has a cached request for this queue, try use it.
-	 *
 	 * The cached request already holds a q_usage_counter reference and we
 	 * don't have to acquire a new one if we use it.
 	 */
-	rq = blk_mq_peek_cached_request(plug, q, bio->bi_opf);
 	if (!rq) {
 		if (unlikely(bio_queue_enter(bio)))
 			return;
@@ -2977,6 +2998,10 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
 
+	if (blk_queue_is_zoned(q) && blk_zone_write_plug_bio(bio, nr_segs))
+		goto queue_exit;
+
+new_request:
 	if (!rq) {
 		rq = blk_mq_get_new_requests(q, plug, bio, nr_segs);
 		if (unlikely(!rq))
@@ -2993,8 +3018,12 @@ void blk_mq_submit_bio(struct bio *bio)
 
 	ret = blk_crypto_rq_get_keyslot(rq);
 	if (ret != BLK_STS_OK) {
+		bool zwplugging = bio_zone_write_plugging(bio);
+
 		bio->bi_status = ret;
 		bio_endio(bio);
+		if (zwplugging)
+			blk_zone_write_plug_complete_request(rq);
 		blk_mq_free_request(rq);
 		return;
 	}
@@ -3002,6 +3031,9 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (op_is_flush(bio->bi_opf) && blk_insert_flush(rq))
 		return;
 
+	if (bio_zone_write_plugging(bio))
+		blk_zone_write_plug_attempt_merge(rq);
+
 	if (plug) {
 		blk_add_rq_to_plug(plug, rq);
 		return;
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 23d9bb21c459..03083522df84 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -7,6 +7,7 @@
  *
  * Copyright (c) 2016, Damien Le Moal
  * Copyright (c) 2016, Western Digital
+ * Copyright (c) 2024, Western Digital Corporation or its affiliates.
  */
 
 #include <linux/kernel.h>
@@ -16,8 +17,11 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/mm.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
 
 #include "blk.h"
+#include "blk-mq-sched.h"
 
 #define ZONE_COND_NAME(name) [BLK_ZONE_COND_##name] = #name
 static const char *const zone_cond_name[] = {
@@ -32,6 +36,62 @@ static const char *const zone_cond_name[] = {
 };
 #undef ZONE_COND_NAME
 
+/*
+ * Per-zone write plug.
+ * @node: hlist_node structure for managing the plug using a hash table.
+ * @link: To list the plug in the zone write plug error list of the disk.
+ * @ref: Zone write plug reference counter. A zone write plug reference is
+ *       always at least 1 when the plug is hashed in the disk plug hash table.
+ *       The reference is incremented whenever a new BIO needing plugging is
+ *       submitted and when a function needs to manipulate a plug. The
+ *       reference count is decremented whenever a plugged BIO completes and
+ *       when a function that referenced the plug returns. The initial
+ *       reference is dropped whenever the zone of the zone write plug is reset,
+ *       finished and when the zone becomes full (last write BIO to the zone
+ *       completes).
+ * @lock: Spinlock to atomically manipulate the plug.
+ * @flags: Flags indicating the plug state.
+ * @zone_no: The number of the zone the plug is managing.
+ * @wp_offset: The zone write pointer location relative to the start of the zone
+ *             as a number of 512B sectors.
+ * @bio_list: The list of BIOs that are currently plugged.
+ * @bio_work: Work struct to handle issuing of plugged BIOs
+ * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
+ */
+struct blk_zone_wplug {
+	struct hlist_node	node;
+	struct list_head	link;
+	atomic_t		ref;
+	spinlock_t		lock;
+	unsigned int		flags;
+	unsigned int		zone_no;
+	unsigned int		wp_offset;
+	struct bio_list		bio_list;
+	struct work_struct	bio_work;
+	struct rcu_head		rcu_head;
+};
+
+/*
+ * Zone write plug flags bits:
+ *  - BLK_ZONE_WPLUG_PLUGGED: Indicate that the zone write plug is plugged,
+ *    that is, that write BIOs are being throttled due to a write BIO already
+ *    being executed or the zone write plug bio list is not empty.
+ *  - BLK_ZONE_WPLUG_ERROR: Indicate that a write error happened which will be
+ *    recovered with a report zone to update the zone write pointer offset.
+ *  - BLK_ZONE_WPLUG_UNHASHED: Indicates that the zone write plug was removed
+ *    from the disk hash table and that the initial reference to the zone
+ *    write plug set when the plug was first added to the hash table has been
+ *    dropped. This flag is set when a zone is reset, finished or become full,
+ *    to prevent new references to the zone write plug to be taken for
+ *    newly incoming BIOs. A zone write plug flagged with this flag will be
+ *    freed once all remaining references from BIOs or functions are dropped.
+ */
+#define BLK_ZONE_WPLUG_PLUGGED		(1U << 0)
+#define BLK_ZONE_WPLUG_ERROR		(1U << 1)
+#define BLK_ZONE_WPLUG_UNHASHED		(1U << 2)
+
+#define BLK_ZONE_WPLUG_BUSY	(BLK_ZONE_WPLUG_PLUGGED | BLK_ZONE_WPLUG_ERROR)
+
 /**
  * blk_zone_cond_str - Return string XXX in BLK_ZONE_COND_XXX.
  * @zone_cond: BLK_ZONE_COND_XXX.
@@ -425,12 +485,1020 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 	return ret;
 }
 
-void disk_free_zone_bitmaps(struct gendisk *disk)
+static inline bool disk_zone_is_conv(struct gendisk *disk, sector_t sector)
+{
+	if (!disk->conv_zones_bitmap)
+		return false;
+	return test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
+}
+
+static inline bool bio_zone_is_conv(struct bio *bio)
+{
+	return disk_zone_is_conv(bio->bi_bdev->bd_disk, bio->bi_iter.bi_sector);
+}
+
+static void blk_zone_wplug_bio_work(struct work_struct *work);
+
+static void disk_init_zone_wplug(struct gendisk *disk,
+				 struct blk_zone_wplug *zwplug,
+				 unsigned int flags, sector_t sector)
+{
+	unsigned int zno = disk_zone_no(disk, sector);
+
+	/*
+	 * Initialize the zoen write plug with an extra reference so that
+	 * it is not freed when the zone write plug becomes idle without
+	 * the zone being full.
+	 */
+	INIT_HLIST_NODE(&zwplug->node);
+	INIT_LIST_HEAD(&zwplug->link);
+	atomic_set(&zwplug->ref, 2);
+	spin_lock_init(&zwplug->lock);
+	zwplug->flags = flags;
+	zwplug->zone_no = zno;
+	zwplug->wp_offset = sector & (disk->queue->limits.chunk_sectors - 1);
+	bio_list_init(&zwplug->bio_list);
+	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
+}
+
+static struct blk_zone_wplug *disk_alloc_zone_wplug(struct gendisk *disk,
+						sector_t sector, gfp_t gfp_mask)
+{
+	struct blk_zone_wplug *zwplug;
+
+	/* Allocate a new zone write plug. */
+	zwplug = kmalloc(sizeof(struct blk_zone_wplug), gfp_mask);
+	if (!zwplug)
+		return NULL;
+
+	disk_init_zone_wplug(disk, zwplug, 0, sector);
+
+	return zwplug;
+}
+
+static bool disk_insert_zone_wplug(struct gendisk *disk,
+				   struct blk_zone_wplug *zwplug)
+{
+	struct blk_zone_wplug *zwplg;
+	unsigned long flags;
+	unsigned int idx =
+		hash_32(zwplug->zone_no, disk->zone_wplugs_hash_bits);
+
+	/*
+	 * Add the new zone write plug to the hash table, but carefully as we
+	 * are racing with other submission context, so we may already have a
+	 * zone write plug for the same zone.
+	 */
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	hlist_for_each_entry_rcu(zwplg, &disk->zone_wplugs_hash[idx], node) {
+		if (zwplg->zone_no == zwplug->zone_no) {
+			spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+			return false;
+		}
+	}
+	hlist_add_head_rcu(&zwplug->node, &disk->zone_wplugs_hash[idx]);
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+
+	return true;
+}
+
+static void disk_remove_zone_wplug(struct gendisk *disk,
+				   struct blk_zone_wplug *zwplug)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	zwplug->flags |= BLK_ZONE_WPLUG_UNHASHED;
+	atomic_dec(&zwplug->ref);
+	hlist_del_init_rcu(&zwplug->node);
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+}
+
+static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
+						 struct blk_zone_wplug *zwplug)
+{
+	/* If the zone is still busy, the plug cannot be removed. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
+		return false;
+
+	/* We can remove zone write plugs for zones that are empty or full. */
+	return !zwplug->wp_offset ||
+		zwplug->wp_offset >= disk->zone_capacity;
+}
+
+static inline struct blk_zone_wplug *
+disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
+{
+	unsigned int zno = disk_zone_no(disk, sector);
+	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
+	struct blk_zone_wplug *zwplug;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
+		if (zwplug->zone_no == zno)
+			goto unlock;
+	}
+	zwplug = NULL;
+
+unlock:
+	rcu_read_unlock();
+	return zwplug;
+}
+
+static inline struct blk_zone_wplug *bio_lookup_zone_wplug(struct bio *bio)
+{
+	return disk_lookup_zone_wplug(bio->bi_bdev->bd_disk,
+				      bio->bi_iter.bi_sector);
+}
+
+static inline void blk_get_zone_wplug(struct blk_zone_wplug *zwplug)
+{
+	atomic_inc(&zwplug->ref);
+}
+
+static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
+						  sector_t sector)
+{
+	struct blk_zone_wplug *zwplug;
+
+	rcu_read_lock();
+	zwplug = disk_lookup_zone_wplug(disk, sector);
+	if (zwplug && !atomic_inc_not_zero(&zwplug->ref))
+		zwplug = NULL;
+	rcu_read_unlock();
+
+	return zwplug;
+}
+
+static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
+{
+	if (atomic_dec_and_test(&zwplug->ref)) {
+		WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
+		WARN_ON_ONCE(!list_empty(&zwplug->link));
+
+		kfree_rcu(zwplug, rcu_head);
+	}
+}
+
+static void blk_zone_wplug_bio_work(struct work_struct *work);
+
+/*
+ * Get a reference on the write plug for the zone containing @sector.
+ * If the plug does not exist, it is allocated and hashed.
+ * Return a pointer to the zone write plug with the plug spinlock held.
+ */
+static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
+					sector_t sector, gfp_t gfp_mask,
+					unsigned long *flags)
+{
+	struct blk_zone_wplug *zwplug;
+
+again:
+	zwplug = disk_get_zone_wplug(disk, sector);
+	if (zwplug) {
+		/*
+		 * Check that a BIO completion or a zone reset or finish
+		 * operation has not already removed the zone write plug from
+		 * the hash table and dropped its reference count. In such case,
+		 * we need to get a new plug so start over from the beginning.
+		 */
+		spin_lock_irqsave(&zwplug->lock, *flags);
+		if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED) {
+			spin_unlock_irqrestore(&zwplug->lock, *flags);
+			disk_put_zone_wplug(zwplug);
+			goto again;
+		}
+		return zwplug;
+	}
+
+	zwplug = disk_alloc_zone_wplug(disk, sector, gfp_mask);
+	if (!zwplug)
+		return NULL;
+
+	spin_lock_irqsave(&zwplug->lock, *flags);
+
+	/*
+	 * Insert the new zone write plug in the hash table. This can fail only
+	 * if another context already inserted a plug. Retry from the beginning
+	 * in such case.
+	 */
+	if (!disk_insert_zone_wplug(disk, zwplug)) {
+		spin_unlock_irqrestore(&zwplug->lock, *flags);
+		kfree(zwplug);
+		goto again;
+	}
+
+	return zwplug;
+}
+
+static struct blk_zone_wplug *bio_get_and_lock_zone_wplug(struct bio *bio,
+							  unsigned long *flags)
+{
+	gfp_t gfp_mask;
+
+	if (bio->bi_opf & REQ_NOWAIT)
+		gfp_mask = GFP_NOWAIT;
+	else
+		gfp_mask = GFP_NOIO;
+
+	return disk_get_and_lock_zone_wplug(bio->bi_bdev->bd_disk,
+				bio->bi_iter.bi_sector, gfp_mask, flags);
+}
+
+static inline void blk_zone_wplug_bio_io_error(struct bio *bio)
+{
+	struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+
+	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
+	bio_io_error(bio);
+	blk_queue_exit(q);
+}
+
+/*
+ * Abort (fail) all plugged BIOs of a zone write plug.
+ */
+static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
+{
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&zwplug->bio_list))) {
+		blk_zone_wplug_bio_io_error(bio);
+		disk_put_zone_wplug(zwplug);
+	}
+}
+
+/*
+ * Abort (fail) all plugged BIOs of a zone write plug that are not aligned
+ * with the assumed write pointer location of the zone when the BIO will
+ * be unplugged.
+ */
+static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
+					    struct blk_zone_wplug *zwplug)
+{
+	unsigned int zone_capacity = disk->zone_capacity;
+	unsigned int wp_offset = zwplug->wp_offset;
+	struct bio_list bl = BIO_EMPTY_LIST;
+	struct bio *bio;
+
+	while ((bio = bio_list_pop(&zwplug->bio_list))) {
+		if (wp_offset >= zone_capacity ||
+		     bio_offset_from_zone_start(bio) != wp_offset) {
+			blk_zone_wplug_bio_io_error(bio);
+			disk_put_zone_wplug(zwplug);
+			continue;
+		}
+
+		wp_offset += bio_sectors(bio);
+		bio_list_add(&bl, bio);
+	}
+
+	bio_list_merge(&zwplug->bio_list, &bl);
+}
+
+/*
+ * Set a zone write plug write pointer offset to either 0 (zone reset case)
+ * or to the zone size (zone finish case). This aborts all plugged BIOs, which
+ * is fine to do as doing a zone reset or zone finish while writes are in-flight
+ * is a mistake from the user which will most likely cause all plugged BIOs to
+ * fail anyway.
+ */
+static void disk_zone_wplug_set_wp_offset(struct gendisk *disk,
+					  struct blk_zone_wplug *zwplug,
+					  unsigned int wp_offset)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zwplug->lock, flags);
+
+	/*
+	 * Make sure that a BIO completion or another zone reset or finish
+	 * operation has not already removed the plug from the hash table.
+	 */
+	if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED) {
+		spin_unlock_irqrestore(&zwplug->lock, flags);
+		return;
+	}
+
+	/* Update the zone write pointer and abort all plugged BIOs. */
+	zwplug->wp_offset = wp_offset;
+	disk_zone_wplug_abort(zwplug);
+
+	/*
+	 * Updating the write pointer offset puts back the zone
+	 * in a good state. So clear the error flag and decrement the
+	 * error count if we were in error state.
+	 */
+	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
+		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
+		spin_lock(&disk->zone_wplugs_lock);
+		list_del_init(&zwplug->link);
+		spin_unlock(&disk->zone_wplugs_lock);
+	}
+
+	/*
+	 * The zone write plug now has no BIO plugged: remove it from the
+	 * hash table so that it cannot be seen. The plug will be freed
+	 * when the last reference is dropped.
+	 */
+	if (disk_should_remove_zone_wplug(disk, zwplug))
+		disk_remove_zone_wplug(disk, zwplug);
+
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+}
+
+static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
+						  unsigned int wp_offset)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	struct blk_zone_wplug *zwplug;
+
+	/* Conventional zones cannot be reset nor finished. */
+	if (bio_zone_is_conv(bio)) {
+		bio_io_error(bio);
+		return true;
+	}
+
+	/*
+	 * If we have a zone write plug, set its write pointer offset to 0
+	 * (reset case) or to the zone size (finish case). This will abort all
+	 * BIOs plugged for the target zone. It is fine as resetting or
+	 * finishing zones while writes are still in-flight will result in the
+	 * writes failing anyway.
+	 */
+	zwplug = disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
+	if (zwplug) {
+		disk_zone_wplug_set_wp_offset(disk, zwplug, wp_offset);
+		disk_put_zone_wplug(zwplug);
+	}
+
+	return false;
+}
+
+static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	struct blk_zone_wplug *zwplug;
+	sector_t sector;
+
+	/*
+	 * Set the write pointer offset of all zone write plugs to 0. This will
+	 * abort all plugged BIOs. It is fine as resetting zones while writes
+	 * are still in-flight will result in the writes failing anyway.
+	 */
+	for (sector = 0; sector < get_capacity(disk);
+	     sector += disk->queue->limits.chunk_sectors) {
+		zwplug = disk_get_zone_wplug(disk, sector);
+		if (zwplug) {
+			disk_zone_wplug_set_wp_offset(disk, zwplug, 0);
+			disk_put_zone_wplug(zwplug);
+		}
+	}
+
+	return false;
+}
+
+static inline void blk_zone_wplug_add_bio(struct blk_zone_wplug *zwplug,
+					  struct bio *bio, unsigned int nr_segs)
+{
+	/*
+	 * Grab an extra reference on the BIO request queue usage counter.
+	 * This reference will be reused to submit a request for the BIO for
+	 * blk-mq devices and dropped when the BIO is failed and after
+	 * it is issued in the case of BIO-based devices.
+	 */
+	percpu_ref_get(&bio->bi_bdev->bd_disk->queue->q_usage_counter);
+
+	/*
+	 * The BIO is being plugged and thus will have to wait for the on-going
+	 * write and for all other writes already plugged. So polling makes
+	 * no sense.
+	 */
+	bio_clear_polled(bio);
+
+	/*
+	 * Reuse the poll cookie field to store the number of segments when
+	 * split to the hardware limits.
+	 */
+	bio->__bi_nr_segments = nr_segs;
+
+	/*
+	 * We always receive BIOs after they are split and ready to be issued.
+	 * The block layer passes the parts of a split BIO in order, and the
+	 * user must also issue write sequentially. So simply add the new BIO
+	 * at the tail of the list to preserve the sequential write order.
+	 */
+	bio_list_add(&zwplug->bio_list, bio);
+}
+
+/*
+ * Called from bio_attempt_back_merge() when a BIO was merged with a request.
+ */
+void blk_zone_write_plug_bio_merged(struct bio *bio)
+{
+	struct blk_zone_wplug *zwplug;
+	unsigned long flags;
+
+	/*
+	 * If the BIO was already plugged, then we were called through
+	 * blk_zone_write_plug_attempt_merge() -> blk_attempt_bio_merge().
+	 * For this case, blk_zone_write_plug_attempt_merge() will handle the
+	 * zone write pointer offset update.
+	 */
+	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
+		return;
+
+	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
+
+	/*
+	 * Increase the plug reference count and advance the zone write
+	 * pointer offset.
+	 */
+	zwplug = bio_lookup_zone_wplug(bio);
+	spin_lock_irqsave(&zwplug->lock, flags);
+	blk_get_zone_wplug(zwplug);
+	zwplug->wp_offset += bio_sectors(bio);
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+}
+
+/*
+ * Attempt to merge plugged BIOs with a newly prepared request for a BIO that
+ * already went through zone write plugging (either a new BIO or one that was
+ * unplugged).
+ */
+void blk_zone_write_plug_attempt_merge(struct request *req)
+{
+	sector_t req_back_sector = blk_rq_pos(req) + blk_rq_sectors(req);
+	struct request_queue *q = req->q;
+	struct gendisk *disk = q->disk;
+	unsigned int zone_capacity = disk->zone_capacity;
+	struct blk_zone_wplug *zwplug =
+		disk_lookup_zone_wplug(disk, blk_rq_pos(req));
+	unsigned long flags;
+	struct bio *bio;
+
+	/*
+	 * Completion of this request needs to be handled with
+	 * blk_zone_write_complete_request().
+	 */
+	req->rq_flags |= RQF_ZONE_WRITE_PLUGGING;
+	blk_get_zone_wplug(zwplug);
+
+	if (blk_queue_nomerges(q))
+		return;
+
+	/*
+	 * Walk through the list of plugged BIOs to check if they can be merged
+	 * into the back of the request.
+	 */
+	spin_lock_irqsave(&zwplug->lock, flags);
+	while (zwplug->wp_offset < zone_capacity &&
+	       (bio = bio_list_peek(&zwplug->bio_list))) {
+		if (bio->bi_iter.bi_sector != req_back_sector ||
+		    !blk_rq_merge_ok(req, bio))
+			break;
+
+		WARN_ON_ONCE(bio_op(bio) != REQ_OP_WRITE_ZEROES &&
+			     !bio->__bi_nr_segments);
+
+		bio_list_pop(&zwplug->bio_list);
+		if (bio_attempt_back_merge(req, bio, bio->__bi_nr_segments) !=
+		    BIO_MERGE_OK) {
+			bio_list_add_head(&zwplug->bio_list, bio);
+			break;
+		}
+
+		/*
+		 * Drop the extra reference on the queue usage we got when
+		 * plugging the BIO and advance the write pointer offset.
+		 */
+		blk_queue_exit(q);
+		zwplug->wp_offset += bio_sectors(bio);
+
+		req_back_sector += bio_sectors(bio);
+	}
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+}
+
+static inline void disk_zone_wplug_set_error(struct gendisk *disk,
+					     struct blk_zone_wplug *zwplug)
+{
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR)) {
+		unsigned long flags;
+
+		zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
+
+		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+		list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
+		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+	}
+}
+
+/*
+ * Check and prepare a BIO for submission by incrementing the write pointer
+ * offset of its zone write plug.
+ */
+static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
+				       struct bio *bio)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+
+	/*
+	 * Check that the user is not attempting to write to a full zone.
+	 * We know such BIO will fail, and that would potentially overflow our
+	 * write pointer offset beyond the end of the zone.
+	 */
+	if (zwplug->wp_offset >= disk->zone_capacity)
+		goto err;
+
+	/*
+	 * Check for non-sequential writes early because we avoid a
+	 * whole lot of error handling trouble if we don't send it off
+	 * to the driver.
+	 */
+	if (bio_offset_from_zone_start(bio) != zwplug->wp_offset)
+		goto err;
+
+	/* Advance the zone write pointer offset. */
+	zwplug->wp_offset += bio_sectors(bio);
+
+	return true;
+
+err:
+	/* We detected an invalid write BIO: schedule error recovery. */
+	disk_zone_wplug_set_error(disk, zwplug);
+	kblockd_schedule_work(&disk->zone_wplugs_work);
+	return false;
+}
+
+static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
+{
+	struct blk_zone_wplug *zwplug;
+	unsigned long flags;
+
+	/*
+	 * BIOs must be fully contained within a zone so that we use the correct
+	 * zone write plug for the entire BIO. For blk-mq devices, the block
+	 * layer should already have done any splitting required to ensure this
+	 * and this BIO should thus not be straddling zone boundaries. For
+	 * BIO-based devices, it is the responsibility of the driver to split
+	 * the bio before submitting it.
+	 */
+	if (WARN_ON_ONCE(bio_straddles_zones(bio))) {
+		bio_io_error(bio);
+		return true;
+	}
+
+	/* Conventional zones do not need write plugging. */
+	if (bio_zone_is_conv(bio))
+		return false;
+
+	zwplug = bio_get_and_lock_zone_wplug(bio, &flags);
+	if (!zwplug) {
+		bio_io_error(bio);
+		return true;
+	}
+
+	/* Indicate that this BIO is being handled using zone write plugging. */
+	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
+
+	/*
+	 * If the zone is already plugged or has a pending error, add the BIO
+	 * to the plug BIO list. Otherwise, plug and let the BIO execute.
+	 */
+	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
+		goto plug;
+
+	/*
+	 * If an error is detected when preparing the BIO, add it to the BIO
+	 * list so that error recovery can deal with it.
+	 */
+	if (!blk_zone_wplug_prepare_bio(zwplug, bio))
+		goto plug;
+
+	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
+
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	return false;
+
+plug:
+	zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
+	blk_zone_wplug_add_bio(zwplug, bio, nr_segs);
+
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	return true;
+}
+
+/**
+ * blk_zone_write_plug_bio - Handle a zone write BIO with zone write plugging
+ * @bio: The BIO being submitted
+ * @nr_segs: The number of physical segments of @bio
+ *
+ * Handle write and write zeroes operations using zone write plugging.
+ * Return true whenever @bio execution needs to be delayed through the zone
+ * write plug. Otherwise, return false to let the submission path process
+ * @bio normally.
+ */
+bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs)
+{
+	struct block_device *bdev = bio->bi_bdev;
+
+	if (!bdev->bd_disk->zone_wplugs_hash)
+		return false;
+
+	/*
+	 * If the BIO already has the plugging flag set, then it was already
+	 * handled through this path and this is a submission from the zone
+	 * plug bio submit work.
+	 */
+	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
+		return false;
+
+	/*
+	 * We do not need to do anything special for empty flush BIOs, e.g
+	 * BIOs such as issued by blkdev_issue_flush(). The is because it is
+	 * the responsibility of the user to first wait for the completion of
+	 * write operations for flush to have any effect on the persistence of
+	 * the written data.
+	 */
+	if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
+		return false;
+
+	/*
+	 * Regular writes and write zeroes need to be handled through the target
+	 * zone write plug. This includes writes with REQ_FUA | REQ_PREFLUSH
+	 * which may need to go through the flush machinery depending on the
+	 * target device capabilities. Plugging such writes is fine as the flush
+	 * machinery operates at the request level, below the plug, and
+	 * completion of the flush sequence will go through the regular BIO
+	 * completion, which will handle zone write plugging.
+	 * Zone reset, reset all and finish commands need special treatment
+	 * to correctly track the write pointer offset of zones. These commands
+	 * are not plugged as we do not need serialization with write
+	 * operations. It is the responsibility of the user to not issue reset
+	 * and finish commands when write operations are in flight.
+	 */
+	switch (bio_op(bio)) {
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_ZEROES:
+		return blk_zone_wplug_handle_write(bio, nr_segs);
+	case REQ_OP_ZONE_RESET:
+		return blk_zone_wplug_handle_reset_or_finish(bio, 0);
+	case REQ_OP_ZONE_FINISH:
+		return blk_zone_wplug_handle_reset_or_finish(bio,
+						bdev_zone_sectors(bdev));
+	case REQ_OP_ZONE_RESET_ALL:
+		return blk_zone_wplug_handle_reset_all(bio);
+	default:
+		return false;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(blk_zone_write_plug_bio);
+
+static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
+				       struct blk_zone_wplug *zwplug)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&zwplug->lock, flags);
+
+	/*
+	 * If we had an error, schedule error recovery. The recovery work
+	 * will restart submission of plugged BIOs.
+	 */
+	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
+		spin_unlock_irqrestore(&zwplug->lock, flags);
+		kblockd_schedule_work(&disk->zone_wplugs_work);
+		return;
+	}
+
+	/* Schedule submission of the next plugged BIO if we have one. */
+	if (!bio_list_empty(&zwplug->bio_list)) {
+		spin_unlock_irqrestore(&zwplug->lock, flags);
+		kblockd_schedule_work(&zwplug->bio_work);
+		return;
+	}
+
+	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
+
+	/*
+	 * If the zone is full (it was fully written or finished, or empty
+	 * (it was reset), remove its zone write plug from the hash table.
+	 */
+	if (disk_should_remove_zone_wplug(disk, zwplug))
+		disk_remove_zone_wplug(disk, zwplug);
+
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+}
+
+void blk_zone_write_plug_bio_endio(struct bio *bio)
+{
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	struct blk_zone_wplug *zwplug = bio_lookup_zone_wplug(bio);
+	unsigned long flags;
+
+	/* Make sure we do not see this BIO again by clearing the plug flag. */
+	bio_clear_flag(bio, BIO_ZONE_WRITE_PLUGGING);
+
+	/*
+	 * If the BIO failed, mark the plug as having an error to trigger
+	 * recovery.
+	 */
+	if (bio->bi_status != BLK_STS_OK) {
+		spin_lock_irqsave(&zwplug->lock, flags);
+		disk_zone_wplug_set_error(disk, zwplug);
+		spin_unlock_irqrestore(&zwplug->lock, flags);
+	}
+
+	/*
+	 * For BIO-based devices, blk_zone_write_plug_complete_request()
+	 * is not called. So we need to schedule execution of the next
+	 * plugged BIO here.
+	 */
+	if (bio->bi_bdev->bd_has_submit_bio)
+		disk_zone_wplug_unplug_bio(disk, zwplug);
+
+	disk_put_zone_wplug(zwplug);
+}
+
+void blk_zone_write_plug_complete_request(struct request *req)
+{
+	struct gendisk *disk = req->q->disk;
+	struct blk_zone_wplug *zwplug =
+		disk_lookup_zone_wplug(disk, req->__sector);
+
+	req->rq_flags &= ~RQF_ZONE_WRITE_PLUGGING;
+
+	disk_zone_wplug_unplug_bio(disk, zwplug);
+
+	disk_put_zone_wplug(zwplug);
+}
+
+static void blk_zone_wplug_bio_work(struct work_struct *work)
+{
+	struct blk_zone_wplug *zwplug =
+		container_of(work, struct blk_zone_wplug, bio_work);
+	struct block_device *bdev;
+	unsigned long flags;
+	struct bio *bio;
+
+	/*
+	 * Submit the next plugged BIO. If we do not have any, clear
+	 * the plugged flag.
+	 */
+	spin_lock_irqsave(&zwplug->lock, flags);
+
+	bio = bio_list_pop(&zwplug->bio_list);
+	if (!bio) {
+		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
+		spin_unlock_irqrestore(&zwplug->lock, flags);
+		return;
+	}
+
+	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
+		/* Error recovery will decide what to do with the BIO. */
+		bio_list_add_head(&zwplug->bio_list, bio);
+		spin_unlock_irqrestore(&zwplug->lock, flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	bdev = bio->bi_bdev;
+	submit_bio_noacct_nocheck(bio);
+
+	/*
+	 * blk-mq devices will reuse the extra reference on the request queue
+	 * usage counter we took when the BIO was plugged, but the submission
+	 * path for BIO-based devices will not do that. So drop this extra
+	 * reference here.
+	 */
+	if (bdev->bd_has_submit_bio)
+		blk_queue_exit(bdev->bd_disk->queue);
+}
+
+static unsigned int blk_zone_wp_offset(struct blk_zone *zone)
+{
+	switch (zone->cond) {
+	case BLK_ZONE_COND_IMP_OPEN:
+	case BLK_ZONE_COND_EXP_OPEN:
+	case BLK_ZONE_COND_CLOSED:
+		return zone->wp - zone->start;
+	case BLK_ZONE_COND_FULL:
+		return zone->len;
+	case BLK_ZONE_COND_EMPTY:
+		return 0;
+	case BLK_ZONE_COND_NOT_WP:
+	case BLK_ZONE_COND_OFFLINE:
+	case BLK_ZONE_COND_READONLY:
+	default:
+		/*
+		 * Conventional, offline and read-only zones do not have a valid
+		 * write pointer.
+		 */
+		return UINT_MAX;
+	}
+}
+
+static int blk_zone_wplug_report_zone_cb(struct blk_zone *zone,
+					 unsigned int idx, void *data)
+{
+	struct blk_zone *zonep = data;
+
+	*zonep = *zone;
+	return 0;
+}
+
+static void disk_zone_wplug_handle_error(struct gendisk *disk,
+					 struct blk_zone_wplug *zwplug)
+{
+	sector_t zone_start_sector =
+		bdev_zone_sectors(disk->part0) * zwplug->zone_no;
+	unsigned int noio_flag;
+	struct blk_zone zone;
+	unsigned long flags;
+	int ret;
+
+	/* Get the current zone information from the device. */
+	noio_flag = memalloc_noio_save();
+	ret = disk->fops->report_zones(disk, zone_start_sector, 1,
+				       blk_zone_wplug_report_zone_cb, &zone);
+	memalloc_noio_restore(noio_flag);
+
+	spin_lock_irqsave(&zwplug->lock, flags);
+
+	/*
+	 * A zone reset or finish may have cleared the error already. In such
+	 * case, do nothing as the report zones may have seen the "old" write
+	 * pointer value before the reset/finish operation completed.
+	 */
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR))
+		goto unlock;
+
+	zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
+
+	if (ret != 1) {
+		/*
+		 * We failed to get the zone information, meaning that something
+		 * is likely really wrong with the device. Abort all remaining
+		 * plugged BIOs as otherwise we could endup waiting forever on
+		 * plugged BIOs to complete if there is a queue freeze on-going.
+		 */
+		disk_zone_wplug_abort(zwplug);
+		goto unplug;
+	}
+
+	/* Update the zone write pointer offset. */
+	zwplug->wp_offset = blk_zone_wp_offset(&zone);
+	disk_zone_wplug_abort_unaligned(disk, zwplug);
+
+	/* Restart BIO submission if we still have any BIO left. */
+	if (!bio_list_empty(&zwplug->bio_list)) {
+		WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
+		kblockd_schedule_work(&zwplug->bio_work);
+		goto unlock;
+	}
+
+unplug:
+	zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
+	if (disk_should_remove_zone_wplug(disk, zwplug))
+		disk_remove_zone_wplug(disk, zwplug);
+
+unlock:
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+}
+
+static void disk_zone_wplugs_work(struct work_struct *work)
+{
+	struct gendisk *disk =
+		container_of(work, struct gendisk, zone_wplugs_work);
+	struct blk_zone_wplug *zwplug;
+	unsigned long flags;
+
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+
+	while (!list_empty(&disk->zone_wplugs_err_list)) {
+		zwplug = list_first_entry(&disk->zone_wplugs_err_list,
+					  struct blk_zone_wplug, link);
+		list_del_init(&zwplug->link);
+		blk_get_zone_wplug(zwplug);
+		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+
+		disk_zone_wplug_handle_error(disk, zwplug);
+		disk_put_zone_wplug(zwplug);
+
+		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	}
+
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+}
+
+static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *disk)
+{
+	return 1U << disk->zone_wplugs_hash_bits;
+}
+
+static void disk_free_zone_wplugs(struct gendisk *disk)
+{
+	struct blk_zone_wplug *zwplug;
+	unsigned int i;
+
+	if (!disk->zone_wplugs_hash)
+		return;
+
+	/* Free all the zone write plugs we have. */
+	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++) {
+		while (!hlist_empty(&disk->zone_wplugs_hash[i])) {
+			zwplug = hlist_entry(disk->zone_wplugs_hash[i].first,
+					     struct blk_zone_wplug, node);
+			blk_get_zone_wplug(zwplug);
+			disk_remove_zone_wplug(disk, zwplug);
+			disk_put_zone_wplug(zwplug);
+		}
+	}
+
+	/* Wait for the zone write plugs to be RCU-freed. */
+	rcu_barrier();
+}
+
+void disk_init_zone_resources(struct gendisk *disk)
+{
+	spin_lock_init(&disk->zone_wplugs_lock);
+	INIT_LIST_HEAD(&disk->zone_wplugs_err_list);
+	INIT_WORK(&disk->zone_wplugs_work, disk_zone_wplugs_work);
+}
+
+/*
+ * For the size of a disk zone write plug hash table, use the disk maximum
+ * open zones and maximum active zones limits, but do not exceed 4KB (512 hlist
+ * head entries), that is, 9 bits. For a disk that has no limits, default to
+ * 128 zones for the number of zone write plugs to hash.
+ */
+#define BLK_ZONE_MAX_WPLUG_HASH_BITS		9
+#define BLK_ZONE_DEFAULT_MAX_NR_WPLUGS		128
+
+static int disk_alloc_zone_resources(struct gendisk *disk,
+				     unsigned int max_nr_zwplugs)
+{
+	unsigned int i;
+
+	disk->zone_wplugs_hash_bits =
+		min(ilog2(max_nr_zwplugs) + 1, BLK_ZONE_MAX_WPLUG_HASH_BITS);
+
+	disk->zone_wplugs_hash =
+		kcalloc(disk_zone_wplugs_hash_size(disk),
+			sizeof(struct hlist_head), GFP_KERNEL);
+	if (!disk->zone_wplugs_hash)
+		return -ENOMEM;
+
+	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++)
+		INIT_HLIST_HEAD(&disk->zone_wplugs_hash[i]);
+
+	return 0;
+}
+
+void disk_free_zone_resources(struct gendisk *disk)
 {
+	cancel_work_sync(&disk->zone_wplugs_work);
+
+	disk_free_zone_wplugs(disk);
+
+	kfree(disk->zone_wplugs_hash);
+	disk->zone_wplugs_hash = NULL;
+	disk->zone_wplugs_hash_bits = 0;
+
 	kfree(disk->conv_zones_bitmap);
 	disk->conv_zones_bitmap = NULL;
 	kfree(disk->seq_zones_wlock);
 	disk->seq_zones_wlock = NULL;
+
+	disk->zone_capacity = 0;
+	disk->nr_zones = 0;
+}
+
+static int disk_revalidate_zone_resources(struct gendisk *disk,
+					  unsigned int nr_zones)
+{
+	struct queue_limits *lim = &disk->queue->limits;
+	unsigned int max_nr_zwplugs;
+
+	/*
+	 * If the device has no limit on the maximum number of open and active
+	 * zones, use BLK_ZONE_DEFAULT_MAX_NR_WPLUGS for the maximum number
+	 * of zone write plugs to hash.
+	 */
+	max_nr_zwplugs = max(lim->max_open_zones, lim->max_active_zones);
+	if (!max_nr_zwplugs)
+		max_nr_zwplugs =
+			min(BLK_ZONE_DEFAULT_MAX_NR_WPLUGS, nr_zones);
+
+	if (!disk->zone_wplugs_hash)
+		return disk_alloc_zone_resources(disk, max_nr_zwplugs);
+
+	return 0;
 }
 
 struct blk_revalidate_zone_args {
@@ -453,6 +1521,9 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	struct request_queue *q = disk->queue;
 	sector_t capacity = get_capacity(disk);
 	sector_t zone_sectors = q->limits.chunk_sectors;
+	struct blk_zone_wplug *zwplug;
+	unsigned long flags;
+	unsigned int wp_offset;
 
 	/* Check for bad zones and holes in the zone report */
 	if (zone->start != args->sector) {
@@ -524,6 +1595,22 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 				disk->disk_name);
 			return -ENODEV;
 		}
+
+		/*
+		 * We need to track the write pointer of all zones that are not
+		 * empty nor full. So make sure we have a zone write plug for
+		 * such zone.
+		 */
+		wp_offset = blk_zone_wp_offset(zone);
+		if (wp_offset && wp_offset < zone_sectors) {
+			zwplug = disk_get_and_lock_zone_wplug(disk, zone->start,
+							      GFP_NOIO, &flags);
+			if (!zwplug)
+				return -ENOMEM;
+			spin_unlock_irqrestore(&zwplug->lock, flags);
+			disk_put_zone_wplug(zwplug);
+		}
+
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:
 	default:
@@ -560,7 +1647,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	sector_t capacity = get_capacity(disk);
 	struct blk_revalidate_zone_args args = { };
 	unsigned int noio_flag;
-	int ret;
+	int ret = -ENOMEM;
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
 		return -EIO;
@@ -593,6 +1680,11 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	args.disk = disk;
 	args.nr_zones = (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
 	noio_flag = memalloc_noio_save();
+	ret = disk_revalidate_zone_resources(disk, args.nr_zones);
+	if (ret) {
+		memalloc_noio_restore(noio_flag);
+		return ret;
+	}
 	ret = disk->fops->report_zones(disk, 0, UINT_MAX,
 				       blk_revalidate_zone_cb, &args);
 	if (!ret) {
@@ -627,7 +1719,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 		ret = 0;
 	} else {
 		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-		disk_free_zone_bitmaps(disk);
+		disk_free_zone_resources(disk);
 	}
 	blk_mq_unfreeze_queue(q);
 
diff --git a/block/blk.h b/block/blk.h
index f2a521b72f9d..7c7059655c97 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -416,7 +416,14 @@ static inline struct bio *blk_queue_bounce(struct bio *bio,
 }
 
 #ifdef CONFIG_BLK_DEV_ZONED
-void disk_free_zone_bitmaps(struct gendisk *disk);
+void disk_init_zone_resources(struct gendisk *disk);
+void disk_free_zone_resources(struct gendisk *disk);
+static inline bool bio_zone_write_plugging(struct bio *bio)
+{
+	return bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING);
+}
+void blk_zone_write_plug_bio_merged(struct bio *bio);
+void blk_zone_write_plug_attempt_merge(struct request *rq);
 static inline void blk_zone_update_request_bio(struct request *rq,
 					       struct bio *bio)
 {
@@ -424,22 +431,45 @@ static inline void blk_zone_update_request_bio(struct request *rq,
 	 * For zone append requests, the request sector indicates the location
 	 * at which the BIO data was written. Return this value to the BIO
 	 * issuer through the BIO iter sector.
+	 * For plugged zone writes, we need the original BIO sector so
+	 * that blk_zone_write_plug_bio_endio() can lookup the zone write plug.
 	 */
-	if (req_op(rq) == REQ_OP_ZONE_APPEND)
+	if (req_op(rq) == REQ_OP_ZONE_APPEND || bio_zone_write_plugging(bio))
 		bio->bi_iter.bi_sector = rq->__sector;
 }
+void blk_zone_write_plug_bio_endio(struct bio *bio);
+void blk_zone_write_plug_complete_request(struct request *rq);
 int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
 		unsigned long arg);
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 #else /* CONFIG_BLK_DEV_ZONED */
-static inline void disk_free_zone_bitmaps(struct gendisk *disk)
+static inline void disk_init_zone_resources(struct gendisk *disk)
+{
+}
+static inline void disk_free_zone_resources(struct gendisk *disk)
+{
+}
+static inline bool bio_zone_write_plugging(struct bio *bio)
+{
+	return false;
+}
+static inline void blk_zone_write_plug_bio_merged(struct bio *bio)
+{
+}
+static inline void blk_zone_write_plug_attempt_merge(struct request *rq)
 {
 }
 static inline void blk_zone_update_request_bio(struct request *rq,
 					       struct bio *bio)
 {
 }
+static inline void blk_zone_write_plug_bio_endio(struct bio *bio)
+{
+}
+static inline void blk_zone_write_plug_complete_request(struct request *rq)
+{
+}
 static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
 		unsigned int cmd, unsigned long arg)
 {
diff --git a/block/genhd.c b/block/genhd.c
index bb29a68e1d67..eb893df56d51 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1182,7 +1182,7 @@ static void disk_release(struct device *dev)
 
 	disk_release_events(disk);
 	kfree(disk->random);
-	disk_free_zone_bitmaps(disk);
+	disk_free_zone_resources(disk);
 	xa_destroy(&disk->part_tbl);
 
 	disk->queue->disk = NULL;
@@ -1364,6 +1364,7 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	if (blkcg_init_disk(disk))
 		goto out_erase_part0;
 
+	disk_init_zone_resources(disk);
 	rand_initialize_disk(disk);
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d3d8fd8e229b..60090c8366fb 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -56,6 +56,8 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_SPECIAL_PAYLOAD	((__force req_flags_t)(1 << 18))
 /* The per-zone write lock is held for this request */
 #define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
+/* The request completion needs to be signaled to zone write pluging. */
+#define RQF_ZONE_WRITE_PLUGGING	((__force req_flags_t)(1 << 20))
 /* ->timeout has been called, don't expire again */
 #define RQF_TIMED_OUT		((__force req_flags_t)(1 << 21))
 #define RQF_RESV		((__force req_flags_t)(1 << 23))
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cb1526ec44b5..ed45de07d2ef 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -234,7 +234,12 @@ struct bio {
 
 	struct bvec_iter	bi_iter;
 
-	blk_qc_t		bi_cookie;
+	union {
+		/* for polled bios: */
+		blk_qc_t		bi_cookie;
+		/* for plugged zoned writes only: */
+		unsigned int		__bi_nr_segments;
+	};
 	bio_end_io_t		*bi_end_io;
 	void			*bi_private;
 #ifdef CONFIG_BLK_CGROUP
@@ -305,6 +310,7 @@ enum {
 	BIO_QOS_MERGED,		/* but went through rq_qos merge path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
+	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_FLAG_LAST
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4e81f714cca7..6faa1abe8506 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -194,6 +194,11 @@ struct gendisk {
 	unsigned int		zone_capacity;
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
+	unsigned int            zone_wplugs_hash_bits;
+	spinlock_t              zone_wplugs_lock;
+	struct hlist_head       *zone_wplugs_hash;
+	struct list_head        zone_wplugs_err_list;
+	struct work_struct	zone_wplugs_work;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 #if IS_ENABLED(CONFIG_CDROM)
@@ -663,6 +668,7 @@ static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
 	return bdev->bd_disk->queue->limits.max_active_zones;
 }
 
+bool blk_zone_write_plug_bio(struct bio *bio, unsigned int nr_segs);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int bdev_nr_zones(struct block_device *bdev)
 {
@@ -690,6 +696,11 @@ static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
 {
 	return 0;
 }
+static inline bool blk_zone_write_plug_bio(struct bio *bio,
+					   unsigned int nr_segs)
+{
+	return false;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline unsigned int blk_queue_depth(struct request_queue *q)
-- 
2.44.0

