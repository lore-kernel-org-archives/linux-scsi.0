From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 02/13] block: Use accessor functions for queue limits
Date: Fri, 15 May 2009 00:40:24 -0400
Message-ID: <1242362435-11953-3-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

Convert all external users of queue limits to using wrapper functions
instead of poking the request queue variables directly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-barrier.c            |    8 ++++----
 block/blk-core.c               |   16 ++++++++--------
 block/blk-map.c                |    4 ++--
 block/blk-merge.c              |   27 ++++++++++++++-------------
 block/blk-settings.c           |   15 ++++++++++++---
 block/blk-sysfs.c              |    8 ++++----
 block/compat_ioctl.c           |    2 +-
 block/ioctl.c                  |   10 +++++-----
 block/scsi_ioctl.c             |    8 ++++----
 drivers/block/pktcdvd.c        |    6 ++++--
 drivers/cdrom/cdrom.c          |    4 ++--
 drivers/md/dm-table.c          |   28 ++++++++++++++--------------
 drivers/md/linear.c            |    2 +-
 drivers/md/multipath.c         |    4 ++--
 drivers/md/raid0.c             |    2 +-
 drivers/md/raid1.c             |    4 ++--
 drivers/md/raid10.c            |    8 ++++----
 drivers/md/raid5.c             |    4 ++--
 drivers/scsi/sg.c              |   15 ++++++++-------
 drivers/scsi/st.c              |    4 ++--
 drivers/usb/storage/scsiglue.c |    4 ++--
 fs/bio.c                       |   19 ++++++++++---------
 include/linux/bio.h            |    2 +-
 include/linux/blkdev.h         |   36 ++++++++++++++++++++++++++++++++++++
 mm/bounce.c                    |    4 ++--
 25 files changed, 147 insertions(+), 97 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 0ab81a0..8714bb9 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -388,10 +388,10 @@ int blkdev_issue_discard(struct block_device *bdev,
 
 		bio->bi_sector = sector;
 
-		if (nr_sects > q->max_hw_sectors) {
-			bio->bi_size = q->max_hw_sectors << 9;
-			nr_sects -= q->max_hw_sectors;
-			sector += q->max_hw_sectors;
+		if (nr_sects > queue_max_hw_sectors(q)) {
+			bio->bi_size = queue_max_hw_sectors(q) << 9;
+			nr_sects -= queue_max_hw_sectors(q);
+			sector += queue_max_hw_sectors(q);
 		} else {
 			bio->bi_size = nr_sects << 9;
 			nr_sects = 0;
diff --git a/block/blk-core.c b/block/blk-core.c
index a2d97de..c924303 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1383,11 +1383,11 @@ static inline void __generic_make_request(struct bio *bio)
 			goto end_io;
 		}
 
-		if (unlikely(nr_sectors > q->max_hw_sectors)) {
+		if (unlikely(nr_sectors > queue_max_hw_sectors(q))) {
 			printk(KERN_ERR "bio too big device %s (%u > %u)\n",
-				bdevname(bio->bi_bdev, b),
-				bio_sectors(bio),
-				q->max_hw_sectors);
+			       bdevname(bio->bi_bdev, b),
+			       bio_sectors(bio),
+			       queue_max_hw_sectors(q));
 			goto end_io;
 		}
 
@@ -1554,8 +1554,8 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
-	if (blk_rq_sectors(rq) > q->max_sectors ||
-	    blk_rq_bytes(rq) > q->max_hw_sectors << 9) {
+	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
+	    blk_rq_bytes(rq) > queue_max_hw_sectors(q) << 9) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
 		return -EIO;
 	}
@@ -1567,8 +1567,8 @@ int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 	 * limitation.
 	 */
 	blk_recalc_rq_segments(rq);
-	if (rq->nr_phys_segments > q->max_phys_segments ||
-	    rq->nr_phys_segments > q->max_hw_segments) {
+	if (rq->nr_phys_segments > queue_max_phys_segments(q) ||
+	    rq->nr_phys_segments > queue_max_hw_segments(q)) {
 		printk(KERN_ERR "%s: over max segments limit.\n", __func__);
 		return -EIO;
 	}
diff --git a/block/blk-map.c b/block/blk-map.c
index 56082be..da64add 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -116,7 +116,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	struct bio *bio = NULL;
 	int ret;
 
-	if (len > (q->max_hw_sectors << 9))
+	if (len > (queue_max_hw_sectors(q) << 9))
 		return -EINVAL;
 	if (!len)
 		return -EINVAL;
@@ -291,7 +291,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 	int do_copy = 0;
 	struct bio *bio;
 
-	if (len > (q->max_hw_sectors << 9))
+	if (len > (queue_max_hw_sectors(q) << 9))
 		return -EINVAL;
 	if (!len || !kbuf)
 		return -EINVAL;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4974dd5..39ce644 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -32,11 +32,12 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 			 * never considered part of another segment, since that
 			 * might change with the bounce page.
 			 */
-			high = page_to_pfn(bv->bv_page) > q->bounce_pfn;
+			high = page_to_pfn(bv->bv_page) > queue_bounce_pfn(q);
 			if (high || highprv)
 				goto new_segment;
 			if (cluster) {
-				if (seg_size + bv->bv_len > q->max_segment_size)
+				if (seg_size + bv->bv_len
+				    > queue_max_segment_size(q))
 					goto new_segment;
 				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bv))
 					goto new_segment;
@@ -91,7 +92,7 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 		return 0;
 
 	if (bio->bi_seg_back_size + nxt->bi_seg_front_size >
-	    q->max_segment_size)
+	    queue_max_segment_size(q))
 		return 0;
 
 	if (!bio_has_data(bio))
@@ -134,7 +135,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		int nbytes = bvec->bv_len;
 
 		if (bvprv && cluster) {
-			if (sg->length + nbytes > q->max_segment_size)
+			if (sg->length + nbytes > queue_max_segment_size(q))
 				goto new_segment;
 
 			if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
@@ -205,8 +206,8 @@ static inline int ll_new_hw_segment(struct request_queue *q,
 {
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_phys_segments + nr_phys_segs > q->max_hw_segments
-	    || req->nr_phys_segments + nr_phys_segs > q->max_phys_segments) {
+	if (req->nr_phys_segments + nr_phys_segs > queue_max_hw_segments(q) ||
+	    req->nr_phys_segments + nr_phys_segs > queue_max_phys_segments(q)) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
 			q->last_merge = NULL;
@@ -227,9 +228,9 @@ int ll_back_merge_fn(struct request_queue *q, struct request *req,
 	unsigned short max_sectors;
 
 	if (unlikely(blk_pc_request(req)))
-		max_sectors = q->max_hw_sectors;
+		max_sectors = queue_max_hw_sectors(q);
 	else
-		max_sectors = q->max_sectors;
+		max_sectors = queue_max_sectors(q);
 
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
@@ -251,9 +252,9 @@ int ll_front_merge_fn(struct request_queue *q, struct request *req,
 	unsigned short max_sectors;
 
 	if (unlikely(blk_pc_request(req)))
-		max_sectors = q->max_hw_sectors;
+		max_sectors = queue_max_hw_sectors(q);
 	else
-		max_sectors = q->max_sectors;
+		max_sectors = queue_max_sectors(q);
 
 
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
@@ -287,7 +288,7 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	/*
 	 * Will it become too large?
 	 */
-	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) > q->max_sectors)
+	if ((blk_rq_sectors(req) + blk_rq_sectors(next)) > queue_max_sectors(q))
 		return 0;
 
 	total_phys_segments = req->nr_phys_segments + next->nr_phys_segments;
@@ -299,10 +300,10 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 		total_phys_segments--;
 	}
 
-	if (total_phys_segments > q->max_phys_segments)
+	if (total_phys_segments > queue_max_phys_segments(q))
 		return 0;
 
-	if (total_phys_segments > q->max_hw_segments)
+	if (total_phys_segments > queue_max_hw_segments(q))
 		return 0;
 
 	/* Merge is OK... */
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 15c3164..0b32f98 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -219,6 +219,15 @@ void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
 }
 EXPORT_SYMBOL(blk_queue_max_sectors);
 
+void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_sectors)
+{
+	if (BLK_DEF_MAX_SECTORS > max_sectors)
+		q->max_hw_sectors = BLK_DEF_MAX_SECTORS;
+	else
+		q->max_hw_sectors = max_sectors;
+}
+EXPORT_SYMBOL(blk_queue_max_hw_sectors);
+
 /**
  * blk_queue_max_phys_segments - set max phys segments for a request for this queue
  * @q:  the request queue for the device
@@ -395,11 +404,11 @@ int blk_queue_dma_drain(struct request_queue *q,
 			       dma_drain_needed_fn *dma_drain_needed,
 			       void *buf, unsigned int size)
 {
-	if (q->max_hw_segments < 2 || q->max_phys_segments < 2)
+	if (queue_max_hw_segments(q) < 2 || queue_max_phys_segments(q) < 2)
 		return -EINVAL;
 	/* make room for appending the drain */
-	--q->max_hw_segments;
-	--q->max_phys_segments;
+	blk_queue_max_hw_segments(q, queue_max_hw_segments(q) - 1);
+	blk_queue_max_phys_segments(q, queue_max_phys_segments(q) - 1);
 	q->dma_drain_needed = dma_drain_needed;
 	q->dma_drain_buffer = buf;
 	q->dma_drain_size = size;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 13d38b7..142a4ac 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -95,7 +95,7 @@ queue_ra_store(struct request_queue *q, const char *page, size_t count)
 
 static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
 {
-	int max_sectors_kb = q->max_sectors >> 1;
+	int max_sectors_kb = queue_max_sectors(q) >> 1;
 
 	return queue_var_show(max_sectors_kb, (page));
 }
@@ -109,7 +109,7 @@ static ssize_t
 queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 {
 	unsigned long max_sectors_kb,
-			max_hw_sectors_kb = q->max_hw_sectors >> 1,
+		max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1,
 			page_kb = 1 << (PAGE_CACHE_SHIFT - 10);
 	ssize_t ret = queue_var_store(&max_sectors_kb, page, count);
 
@@ -117,7 +117,7 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 		return -EINVAL;
 
 	spin_lock_irq(q->queue_lock);
-	q->max_sectors = max_sectors_kb << 1;
+	blk_queue_max_sectors(q, max_sectors_kb << 1);
 	spin_unlock_irq(q->queue_lock);
 
 	return ret;
@@ -125,7 +125,7 @@ queue_max_sectors_store(struct request_queue *q, const char *page, size_t count)
 
 static ssize_t queue_max_hw_sectors_show(struct request_queue *q, char *page)
 {
-	int max_hw_sectors_kb = q->max_hw_sectors >> 1;
+	int max_hw_sectors_kb = queue_max_hw_sectors(q) >> 1;
 
 	return queue_var_show(max_hw_sectors_kb, (page));
 }
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 9eaa194..df18a15 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -766,7 +766,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_int(arg, bdev_logical_block_size(bdev));
 	case BLKSECTGET:
 		return compat_put_ushort(arg,
-					 bdev_get_queue(bdev)->max_sectors);
+					 queue_max_sectors(bdev_get_queue(bdev)));
 	case BLKRASET: /* compatible, but no compat_ptr (!) */
 	case BLKFRASET:
 		if (!capable(CAP_SYS_ADMIN))
diff --git a/block/ioctl.c b/block/ioctl.c
index 7aa97f6..500e4c7 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -152,10 +152,10 @@ static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 		bio->bi_private = &wait;
 		bio->bi_sector = start;
 
-		if (len > q->max_hw_sectors) {
-			bio->bi_size = q->max_hw_sectors << 9;
-			len -= q->max_hw_sectors;
-			start += q->max_hw_sectors;
+		if (len > queue_max_hw_sectors(q)) {
+			bio->bi_size = queue_max_hw_sectors(q) << 9;
+			len -= queue_max_hw_sectors(q);
+			start += queue_max_hw_sectors(q);
 		} else {
 			bio->bi_size = len << 9;
 			len = 0;
@@ -313,7 +313,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKSSZGET: /* get block device hardware sector size */
 		return put_int(arg, bdev_logical_block_size(bdev));
 	case BLKSECTGET:
-		return put_ushort(arg, bdev_get_queue(bdev)->max_sectors);
+		return put_ushort(arg, queue_max_sectors(bdev_get_queue(bdev)));
 	case BLKRASET:
 	case BLKFRASET:
 		if(!capable(CAP_SYS_ADMIN))
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a9670dd..5f8e798 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -75,7 +75,7 @@ static int sg_set_timeout(struct request_queue *q, int __user *p)
 
 static int sg_get_reserved_size(struct request_queue *q, int __user *p)
 {
-	unsigned val = min(q->sg_reserved_size, q->max_sectors << 9);
+	unsigned val = min(q->sg_reserved_size, queue_max_sectors(q) << 9);
 
 	return put_user(val, p);
 }
@@ -89,8 +89,8 @@ static int sg_set_reserved_size(struct request_queue *q, int __user *p)
 
 	if (size < 0)
 		return -EINVAL;
-	if (size > (q->max_sectors << 9))
-		size = q->max_sectors << 9;
+	if (size > (queue_max_sectors(q) << 9))
+		size = queue_max_sectors(q) << 9;
 
 	q->sg_reserved_size = size;
 	return 0;
@@ -264,7 +264,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	if (hdr->cmd_len > BLK_MAX_CDB)
 		return -EINVAL;
 
-	if (hdr->dxfer_len > (q->max_hw_sectors << 9))
+	if (hdr->dxfer_len > (queue_max_hw_sectors(q) << 9))
 		return -EIO;
 
 	if (hdr->dxfer_len)
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 293f585..d57f117 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -991,13 +991,15 @@ static void pkt_iosched_process_queue(struct pktcdvd_device *pd)
  */
 static int pkt_set_segment_merging(struct pktcdvd_device *pd, struct request_queue *q)
 {
-	if ((pd->settings.size << 9) / CD_FRAMESIZE <= q->max_phys_segments) {
+	if ((pd->settings.size << 9) / CD_FRAMESIZE
+	    <= queue_max_phys_segments(q)) {
 		/*
 		 * The cdrom device can handle one segment/frame
 		 */
 		clear_bit(PACKET_MERGE_SEGS, &pd->flags);
 		return 0;
-	} else if ((pd->settings.size << 9) / PAGE_SIZE <= q->max_phys_segments) {
+	} else if ((pd->settings.size << 9) / PAGE_SIZE
+		   <= queue_max_phys_segments(q)) {
 		/*
 		 * We can handle this case at the expense of some extra memory
 		 * copies during write operations
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index cceace6..71d1b9b 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2101,8 +2101,8 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		nr = nframes;
 		if (cdi->cdda_method == CDDA_BPC_SINGLE)
 			nr = 1;
-		if (nr * CD_FRAMESIZE_RAW > (q->max_sectors << 9))
-			nr = (q->max_sectors << 9) / CD_FRAMESIZE_RAW;
+		if (nr * CD_FRAMESIZE_RAW > (queue_max_sectors(q) << 9))
+			nr = (queue_max_sectors(q) << 9) / CD_FRAMESIZE_RAW;
 
 		len = nr * CD_FRAMESIZE_RAW;
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 65e2d97..e9a73bb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -510,7 +510,7 @@ void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 	 *        combine_restrictions_low()
 	 */
 	rs->max_sectors =
-		min_not_zero(rs->max_sectors, q->max_sectors);
+		min_not_zero(rs->max_sectors, queue_max_sectors(q));
 
 	/*
 	 * Check if merge fn is supported.
@@ -525,25 +525,25 @@ void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 
 	rs->max_phys_segments =
 		min_not_zero(rs->max_phys_segments,
-			     q->max_phys_segments);
+			     queue_max_phys_segments(q));
 
 	rs->max_hw_segments =
-		min_not_zero(rs->max_hw_segments, q->max_hw_segments);
+		min_not_zero(rs->max_hw_segments, queue_max_hw_segments(q));
 
 	rs->logical_block_size = max(rs->logical_block_size,
 				     queue_logical_block_size(q));
 
 	rs->max_segment_size =
-		min_not_zero(rs->max_segment_size, q->max_segment_size);
+		min_not_zero(rs->max_segment_size, queue_max_segment_size(q));
 
 	rs->max_hw_sectors =
-		min_not_zero(rs->max_hw_sectors, q->max_hw_sectors);
+		min_not_zero(rs->max_hw_sectors, queue_max_hw_sectors(q));
 
 	rs->seg_boundary_mask =
 		min_not_zero(rs->seg_boundary_mask,
-			     q->seg_boundary_mask);
+			     queue_segment_boundary(q));
 
-	rs->bounce_pfn = min_not_zero(rs->bounce_pfn, q->bounce_pfn);
+	rs->bounce_pfn = min_not_zero(rs->bounce_pfn, queue_bounce_pfn(q));
 
 	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 }
@@ -914,13 +914,13 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 	 * restrictions.
 	 */
 	blk_queue_max_sectors(q, t->limits.max_sectors);
-	q->max_phys_segments = t->limits.max_phys_segments;
-	q->max_hw_segments = t->limits.max_hw_segments;
-	q->logical_block_size = t->limits.logical_block_size;
-	q->max_segment_size = t->limits.max_segment_size;
-	q->max_hw_sectors = t->limits.max_hw_sectors;
-	q->seg_boundary_mask = t->limits.seg_boundary_mask;
-	q->bounce_pfn = t->limits.bounce_pfn;
+	blk_queue_max_phys_segments(q, t->limits.max_phys_segments);
+	blk_queue_max_hw_segments(q, t->limits.max_hw_segments);
+	blk_queue_logical_block_size(q, t->limits.logical_block_size);
+	blk_queue_max_segment_size(q, t->limits.max_segment_size);
+	blk_queue_max_hw_sectors(q, t->limits.max_hw_sectors);
+	blk_queue_segment_boundary(q, t->limits.seg_boundary_mask);
+	blk_queue_bounce_limit(q, t->limits.bounce_pfn);
 
 	if (t->limits.no_cluster)
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 7a36e38..64f1f3e 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -146,7 +146,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		 * a one page request is never in violation.
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->num_sectors = rdev->sectors;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 41ced0c..4ee31aa 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -303,7 +303,7 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 		 * merge_bvec_fn will be involved in multipath.)
 		 */
 			if (q->merge_bvec_fn &&
-			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+			    queue_max_sectors(q) > (PAGE_SIZE>>9))
 				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			conf->working_disks++;
@@ -467,7 +467,7 @@ static int multipath_run (mddev_t *mddev)
 		 * violating it, not that we ever expect a device with
 		 * a merge_bvec_fn to be involved in multipath */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!test_bit(Faulty, &rdev->flags))
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c08d755..925507e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -144,7 +144,7 @@ static int create_strip_zones (mddev_t *mddev)
 		 */
 
 		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!smallest || (rdev1->sectors < smallest->sectors))
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 36df910..e23758b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1130,7 +1130,7 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			 * a one page request is never in violation.
 			 */
 			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+			    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
 				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			p->head_position = 0;
@@ -1996,7 +1996,7 @@ static int run(mddev_t *mddev)
 		 * a one page request is never in violation.
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
+		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
 			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->head_position = 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 81a54f1..1a41aea 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1158,8 +1158,8 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			 * a one page request is never in violation.
 			 */
 			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-				mddev->queue->max_sectors = (PAGE_SIZE>>9);
+			    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
+				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -2145,8 +2145,8 @@ static int run(mddev_t *mddev)
 		 * a one page request is never in violation.
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			mddev->queue->max_sectors = (PAGE_SIZE>>9);
+		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
+			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->head_position = 0;
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4616bc3..7970dc8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3463,10 +3463,10 @@ static int bio_fits_rdev(struct bio *bi)
 {
 	struct request_queue *q = bdev_get_queue(bi->bi_bdev);
 
-	if ((bi->bi_size>>9) > q->max_sectors)
+	if ((bi->bi_size>>9) > queue_max_sectors(q))
 		return 0;
 	blk_recount_segments(q, bi);
-	if (bi->bi_phys_segments > q->max_phys_segments)
+	if (bi->bi_phys_segments > queue_max_phys_segments(q))
 		return 0;
 
 	if (q->merge_bvec_fn)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dec4c70..350f430 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -289,8 +289,8 @@ sg_open(struct inode *inode, struct file *filp)
 	if (list_empty(&sdp->sfds)) {	/* no existing opens on this device */
 		sdp->sgdebug = 0;
 		q = sdp->device->request_queue;
-		sdp->sg_tablesize = min(q->max_hw_segments,
-					q->max_phys_segments);
+		sdp->sg_tablesize = min(queue_max_hw_segments(q),
+					queue_max_phys_segments(q));
 	}
 	if ((sfp = sg_add_sfp(sdp, dev)))
 		filp->private_data = sfp;
@@ -909,7 +909,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
                 if (val < 0)
                         return -EINVAL;
 		val = min_t(int, val,
-				sdp->device->request_queue->max_sectors * 512);
+			    queue_max_sectors(sdp->device->request_queue) * 512);
 		if (val != sfp->reserve.bufflen) {
 			if (sg_res_in_use(sfp) || sfp->mmap_called)
 				return -EBUSY;
@@ -919,7 +919,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 		return 0;
 	case SG_GET_RESERVED_SIZE:
 		val = min_t(int, sfp->reserve.bufflen,
-				sdp->device->request_queue->max_sectors * 512);
+			    queue_max_sectors(sdp->device->request_queue) * 512);
 		return put_user(val, ip);
 	case SG_SET_COMMAND_Q:
 		result = get_user(val, ip);
@@ -1059,7 +1059,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 			return -ENODEV;
 		return scsi_ioctl(sdp->device, cmd_in, p);
 	case BLKSECTGET:
-		return put_user(sdp->device->request_queue->max_sectors * 512,
+		return put_user(queue_max_sectors(sdp->device->request_queue) * 512,
 				ip);
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
@@ -1377,7 +1377,8 @@ static Sg_device *sg_alloc(struct gendisk *disk, struct scsi_device *scsidp)
 	sdp->device = scsidp;
 	INIT_LIST_HEAD(&sdp->sfds);
 	init_waitqueue_head(&sdp->o_excl_wait);
-	sdp->sg_tablesize = min(q->max_hw_segments, q->max_phys_segments);
+	sdp->sg_tablesize = min(queue_max_hw_segments(q),
+				queue_max_phys_segments(q));
 	sdp->index = k;
 	kref_init(&sdp->d_ref);
 
@@ -2052,7 +2053,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
 		sg_big_buff = def_reserved_size;
 
 	bufflen = min_t(int, sg_big_buff,
-			sdp->device->request_queue->max_sectors * 512);
+			queue_max_sectors(sdp->device->request_queue) * 512);
 	sg_build_reserve(sfp, bufflen);
 	SCSI_LOG_TIMEOUT(3, printk("sg_add_sfp:   bufflen=%d, k_use_sg=%d\n",
 			   sfp->reserve.bufflen, sfp->reserve.k_use_sg));
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8681b70..89bd438 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3983,8 +3983,8 @@ static int st_probe(struct device *dev)
 		return -ENODEV;
 	}
 
-	i = min(SDp->request_queue->max_hw_segments,
-		SDp->request_queue->max_phys_segments);
+	i = min(queue_max_hw_segments(SDp->request_queue),
+		queue_max_phys_segments(SDp->request_queue));
 	if (st_max_sg_segs < i)
 		i = st_max_sg_segs;
 	buffer = new_tape_buffer((SDp->host)->unchecked_isa_dma, i);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 4ca3b58..cfa26d5 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -132,7 +132,7 @@ static int slave_configure(struct scsi_device *sdev)
 
 		if (us->fflags & US_FL_MAX_SECTORS_MIN)
 			max_sectors = PAGE_CACHE_SIZE >> 9;
-		if (sdev->request_queue->max_sectors > max_sectors)
+		if (queue_max_sectors(sdev->request_queue) > max_sectors)
 			blk_queue_max_sectors(sdev->request_queue,
 					      max_sectors);
 	} else if (sdev->type == TYPE_TAPE) {
@@ -483,7 +483,7 @@ static ssize_t show_max_sectors(struct device *dev, struct device_attribute *att
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
-	return sprintf(buf, "%u\n", sdev->request_queue->max_sectors);
+	return sprintf(buf, "%u\n", queue_max_sectors(sdev->request_queue));
 }
 
 /* Input routine for the sysfs max_sectors file */
diff --git a/fs/bio.c b/fs/bio.c
index 28f9f17..05a356b 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -499,11 +499,11 @@ int bio_get_nr_vecs(struct block_device *bdev)
 	struct request_queue *q = bdev_get_queue(bdev);
 	int nr_pages;
 
-	nr_pages = ((q->max_sectors << 9) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (nr_pages > q->max_phys_segments)
-		nr_pages = q->max_phys_segments;
-	if (nr_pages > q->max_hw_segments)
-		nr_pages = q->max_hw_segments;
+	nr_pages = ((queue_max_sectors(q) << 9) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (nr_pages > queue_max_phys_segments(q))
+		nr_pages = queue_max_phys_segments(q);
+	if (nr_pages > queue_max_hw_segments(q))
+		nr_pages = queue_max_hw_segments(q);
 
 	return nr_pages;
 }
@@ -562,8 +562,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 	 * make this too complex.
 	 */
 
-	while (bio->bi_phys_segments >= q->max_phys_segments
-	       || bio->bi_phys_segments >= q->max_hw_segments) {
+	while (bio->bi_phys_segments >= queue_max_phys_segments(q)
+	       || bio->bi_phys_segments >= queue_max_hw_segments(q)) {
 
 		if (retried_segments)
 			return 0;
@@ -634,7 +634,8 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 int bio_add_pc_page(struct request_queue *q, struct bio *bio, struct page *page,
 		    unsigned int len, unsigned int offset)
 {
-	return __bio_add_page(q, bio, page, len, offset, q->max_hw_sectors);
+	return __bio_add_page(q, bio, page, len, offset,
+			      queue_max_hw_sectors(q));
 }
 
 /**
@@ -654,7 +655,7 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset)
 {
 	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
-	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
+	return __bio_add_page(q, bio, page, len, offset, queue_max_sectors(q));
 }
 
 struct bio_map_data {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d30ec6f..12737be 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -279,7 +279,7 @@ static inline int bio_has_allocated_vec(struct bio *bio)
 #define __BIO_SEG_BOUNDARY(addr1, addr2, mask) \
 	(((addr1) | (mask)) == (((addr2) - 1) | (mask)))
 #define BIOVEC_SEG_BOUNDARY(q, b1, b2) \
-	__BIO_SEG_BOUNDARY(bvec_to_phys((b1)), bvec_to_phys((b2)) + (b2)->bv_len, (q)->seg_boundary_mask)
+	__BIO_SEG_BOUNDARY(bvec_to_phys((b1)), bvec_to_phys((b2)) + (b2)->bv_len, queue_segment_boundary((q)))
 #define BIO_SEG_BOUNDARY(q, b1, b2) \
 	BIOVEC_SEG_BOUNDARY((q), __BVEC_END((b1)), __BVEC_START((b2)))
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 85c7f7d..e7950df 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -896,6 +896,7 @@ extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_sectors(struct request_queue *, unsigned int);
+extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
@@ -986,6 +987,41 @@ extern void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter);
 
 #define blkdev_entry_to_request(entry) list_entry((entry), struct request, queuelist)
 
+static inline unsigned long queue_bounce_pfn(struct request_queue *q)
+{
+	return q->bounce_pfn;
+}
+
+static inline unsigned long queue_segment_boundary(struct request_queue *q)
+{
+	return q->seg_boundary_mask;
+}
+
+static inline unsigned int queue_max_sectors(struct request_queue *q)
+{
+	return q->max_sectors;
+}
+
+static inline unsigned int queue_max_hw_sectors(struct request_queue *q)
+{
+	return q->max_hw_sectors;
+}
+
+static inline unsigned short queue_max_hw_segments(struct request_queue *q)
+{
+	return q->max_hw_segments;
+}
+
+static inline unsigned short queue_max_phys_segments(struct request_queue *q)
+{
+	return q->max_phys_segments;
+}
+
+static inline unsigned int queue_max_segment_size(struct request_queue *q)
+{
+	return q->max_segment_size;
+}
+
 static inline unsigned short queue_logical_block_size(struct request_queue *q)
 {
 	int retval = 512;
diff --git a/mm/bounce.c b/mm/bounce.c
index e590272..8dcd431 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -192,7 +192,7 @@ static void __blk_queue_bounce(struct request_queue *q, struct bio **bio_orig,
 		/*
 		 * is destination page below bounce pfn?
 		 */
-		if (page_to_pfn(page) <= q->bounce_pfn)
+		if (page_to_pfn(page) <= queue_bounce_pfn(q))
 			continue;
 
 		/*
@@ -284,7 +284,7 @@ void blk_queue_bounce(struct request_queue *q, struct bio **bio_orig)
 	 * don't waste time iterating over bio segments
 	 */
 	if (!(q->bounce_gfp & GFP_DMA)) {
-		if (q->bounce_pfn >= blk_max_pfn)
+		if (queue_bounce_pfn(q) >= blk_max_pfn)
 			return;
 		pool = page_pool;
 	} else {
-- 
1.6.0.6

