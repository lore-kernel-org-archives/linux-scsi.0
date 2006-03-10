From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 4/6] block layer: use blk_rq_bio_prep in
 init_request_from_bio
Date: Fri, 10 Mar 2006 20:47:05 +0900
Message-ID: <20060310204705Q.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:29859 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932732AbWCJLua
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 06:50:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Patch to use blk_rq_bio_prep in init_request_from_bio. And remove
blk_rq_bio_prep's flags copying. The first three bits have not been
the same for some time so that has been broken. The user of
blk_rq_bio_prep will setup the request flags so if it wanted failfast
or to be a barrier it will set the correct flag itself.


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

---

 block/ll_rw_blk.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

a0f146d5293039d720f6cc38ef30eff1713e8758
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 13c40a0..da2c57d 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -2765,16 +2765,12 @@ static void init_request_from_bio(struct
 
 	req->errors = 0;
 	req->hard_sector = req->sector = bio->bi_sector;
-	req->hard_nr_sectors = req->nr_sectors = bio_sectors(bio);
-	req->current_nr_sectors = req->hard_cur_sectors = bio_cur_sectors(bio);
-	req->nr_phys_segments = bio_phys_segments(req->q, bio);
-	req->nr_hw_segments = bio_hw_segments(req->q, bio);
-	req->buffer = bio_data(bio);	/* see ->buffer comment above */
 	req->waiting = NULL;
-	req->bio = req->biotail = bio;
 	req->ioprio = bio_prio(bio);
 	req->rq_disk = bio->bi_bdev->bd_disk;
 	req->start_time = jiffies;
+
+	blk_rq_bio_prep(req->q, req, bio);
 }
 
 static int __make_request(request_queue_t *q, struct bio *bio)
@@ -3403,9 +3399,6 @@ EXPORT_SYMBOL(end_request);
 
 void blk_rq_bio_prep(request_queue_t *q, struct request *rq, struct bio *bio)
 {
-	/* first three bits are identical in rq->flags and bio->bi_rw */
-	rq->flags |= (bio->bi_rw & 7);
-
 	rq->nr_phys_segments = bio_phys_segments(q, bio);
 	rq->nr_hw_segments = bio_hw_segments(q, bio);
 	rq->current_nr_sectors = bio_cur_sectors(bio);
-- 
1.1.5
