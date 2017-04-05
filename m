From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/27] drbd: make intelligent use of
	blkdev_issue_zeroout
Date: Wed,  5 Apr 2017 19:21:21 +0200
Message-ID: <20170405172125.22600-24-hch@lst.de>
References: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

drbd always wants its discard wire operations to zero the blocks, so
use blkdev_issue_zeroout with the BLKDEV_ZERO_UNMAP flag instead of
reinventing it poorly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/block/drbd/drbd_debugfs.c  |   3 --
 drivers/block/drbd/drbd_int.h      |   6 ---
 drivers/block/drbd/drbd_receiver.c | 102 ++-----------------------------------
 drivers/block/drbd/drbd_req.c      |   6 +--
 4 files changed, 7 insertions(+), 110 deletions(-)

diff --git a/drivers/block/drbd/drbd_debugfs.c b/drivers/block/drbd/drbd_debugfs.c
index de5c3ee8a790..494837e59f23 100644
--- a/drivers/block/drbd/drbd_debugfs.c
+++ b/drivers/block/drbd/drbd_debugfs.c
@@ -236,9 +236,6 @@ static void seq_print_peer_request_flags(struct seq_file *m, struct drbd_peer_re
 	seq_print_rq_state_bit(m, f & EE_CALL_AL_COMPLETE_IO, &sep, "in-AL");
 	seq_print_rq_state_bit(m, f & EE_SEND_WRITE_ACK, &sep, "C");
 	seq_print_rq_state_bit(m, f & EE_MAY_SET_IN_SYNC, &sep, "set-in-sync");
-
-	if (f & EE_IS_TRIM)
-		__seq_print_rq_state_bit(m, f & EE_IS_TRIM_USE_ZEROOUT, &sep, "zero-out", "trim");
 	seq_print_rq_state_bit(m, f & EE_WRITE_SAME, &sep, "write-same");
 	seq_putc(m, '\n');
 }
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 724d1c50fc52..d5da45bb03a6 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -437,9 +437,6 @@ enum {
 
 	/* is this a TRIM aka REQ_DISCARD? */
 	__EE_IS_TRIM,
-	/* our lower level cannot handle trim,
-	 * and we want to fall back to zeroout instead */
-	__EE_IS_TRIM_USE_ZEROOUT,
 
 	/* In case a barrier failed,
 	 * we need to resubmit without the barrier flag. */
@@ -482,7 +479,6 @@ enum {
 #define EE_CALL_AL_COMPLETE_IO (1<<__EE_CALL_AL_COMPLETE_IO)
 #define EE_MAY_SET_IN_SYNC     (1<<__EE_MAY_SET_IN_SYNC)
 #define EE_IS_TRIM             (1<<__EE_IS_TRIM)
-#define EE_IS_TRIM_USE_ZEROOUT (1<<__EE_IS_TRIM_USE_ZEROOUT)
 #define EE_RESUBMITTED         (1<<__EE_RESUBMITTED)
 #define EE_WAS_ERROR           (1<<__EE_WAS_ERROR)
 #define EE_HAS_DIGEST          (1<<__EE_HAS_DIGEST)
@@ -1561,8 +1557,6 @@ extern void start_resync_timer_fn(unsigned long data);
 extern void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req);
 
 /* drbd_receiver.c */
-extern int drbd_issue_discard_or_zero_out(struct drbd_device *device,
-		sector_t start, unsigned int nr_sectors, bool discard);
 extern int drbd_receiver(struct drbd_thread *thi);
 extern int drbd_ack_receiver(struct drbd_thread *thi);
 extern void drbd_send_ping_wf(struct work_struct *ws);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index dc9a6dcd431c..bc1d296581f9 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1448,108 +1448,14 @@ void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backin
 		drbd_info(resource, "Method to ensure write ordering: %s\n", write_ordering_str[resource->write_ordering]);
 }
 
-/*
- * We *may* ignore the discard-zeroes-data setting, if so configured.
- *
- * Assumption is that it "discard_zeroes_data=0" is only because the backend
- * may ignore partial unaligned discards.
- *
- * LVM/DM thin as of at least
- *   LVM version:     2.02.115(2)-RHEL7 (2015-01-28)
- *   Library version: 1.02.93-RHEL7 (2015-01-28)
- *   Driver version:  4.29.0
- * still behaves this way.
- *
- * For unaligned (wrt. alignment and granularity) or too small discards,
- * we zero-out the initial (and/or) trailing unaligned partial chunks,
- * but discard all the aligned full chunks.
- *
- * At least for LVM/DM thin, the result is effectively "discard_zeroes_data=1".
- */
-int drbd_issue_discard_or_zero_out(struct drbd_device *device, sector_t start, unsigned int nr_sectors, bool discard)
-{
-	struct block_device *bdev = device->ldev->backing_bdev;
-	struct request_queue *q = bdev_get_queue(bdev);
-	sector_t tmp, nr;
-	unsigned int max_discard_sectors, granularity;
-	int alignment;
-	int err = 0;
-
-	if (!discard)
-		goto zero_out;
-
-	/* Zero-sector (unknown) and one-sector granularities are the same.  */
-	granularity = max(q->limits.discard_granularity >> 9, 1U);
-	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
-
-	max_discard_sectors = min(q->limits.max_discard_sectors, (1U << 22));
-	max_discard_sectors -= max_discard_sectors % granularity;
-	if (unlikely(!max_discard_sectors))
-		goto zero_out;
-
-	if (nr_sectors < granularity)
-		goto zero_out;
-
-	tmp = start;
-	if (sector_div(tmp, granularity) != alignment) {
-		if (nr_sectors < 2*granularity)
-			goto zero_out;
-		/* start + gran - (start + gran - align) % gran */
-		tmp = start + granularity - alignment;
-		tmp = start + granularity - sector_div(tmp, granularity);
-
-		nr = tmp - start;
-		err |= blkdev_issue_zeroout(bdev, start, nr, GFP_NOIO,
-				BLKDEV_ZERO_NOUNMAP);
-		nr_sectors -= nr;
-		start = tmp;
-	}
-	while (nr_sectors >= granularity) {
-		nr = min_t(sector_t, nr_sectors, max_discard_sectors);
-		err |= blkdev_issue_discard(bdev, start, nr, GFP_NOIO,
-				BLKDEV_ZERO_NOUNMAP);
-		nr_sectors -= nr;
-		start += nr;
-	}
- zero_out:
-	if (nr_sectors) {
-		err |= blkdev_issue_zeroout(bdev, start, nr_sectors, GFP_NOIO,
-				BLKDEV_ZERO_NOUNMAP);
-	}
-	return err != 0;
-}
-
-static bool can_do_reliable_discards(struct drbd_device *device)
-{
-	struct request_queue *q = bdev_get_queue(device->ldev->backing_bdev);
-	struct disk_conf *dc;
-	bool can_do;
-
-	if (!blk_queue_discard(q))
-		return false;
-
-	if (q->limits.discard_zeroes_data)
-		return true;
-
-	rcu_read_lock();
-	dc = rcu_dereference(device->ldev->disk_conf);
-	can_do = dc->discard_zeroes_if_aligned;
-	rcu_read_unlock();
-	return can_do;
-}
-
 static void drbd_issue_peer_discard(struct drbd_device *device, struct drbd_peer_request *peer_req)
 {
-	/* If the backend cannot discard, or does not guarantee
-	 * read-back zeroes in discarded ranges, we fall back to
-	 * zero-out.  Unless configuration specifically requested
-	 * otherwise. */
-	if (!can_do_reliable_discards(device))
-		peer_req->flags |= EE_IS_TRIM_USE_ZEROOUT;
+	struct block_device *bdev = device->ldev->backing_bdev;
 
-	if (drbd_issue_discard_or_zero_out(device, peer_req->i.sector,
-	    peer_req->i.size >> 9, !(peer_req->flags & EE_IS_TRIM_USE_ZEROOUT)))
+	if (blkdev_issue_zeroout(bdev, peer_req->i.sector, peer_req->i.size >> 9,
+			GFP_NOIO, 0))
 		peer_req->flags |= EE_WAS_ERROR;
+
 	drbd_endio_write_sec_final(peer_req);
 }
 
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 652114ae1a8a..6da9ea8c48b6 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1148,10 +1148,10 @@ static int drbd_process_write_request(struct drbd_request *req)
 
 static void drbd_process_discard_req(struct drbd_request *req)
 {
-	int err = drbd_issue_discard_or_zero_out(req->device,
-				req->i.sector, req->i.size >> 9, true);
+	struct block_device *bdev = req->device->ldev->backing_bdev;
 
-	if (err)
+	if (blkdev_issue_zeroout(bdev, req->i.sector, req->i.size >> 9,
+			GFP_NOIO, 0))
 		req->private_bio->bi_error = -EIO;
 	bio_endio(req->private_bio);
 }
-- 
2.11.0
