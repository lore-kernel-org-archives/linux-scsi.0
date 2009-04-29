From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] block: hide request sector and data_len
Date: Wed, 29 Apr 2009 18:13:48 +0900
Message-ID: <1240996428-10159-11-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Block low level drivers for some reason have been pretty good at
abusing block layer API.  Especially struct request's fields tend to
get violated in all possible ways.  Make it clear that low level
drivers MUST NOT access or manipulate rq->sector and rq->data_len
directly by prefixing them with double underscores.

This change is also necessary to break build of out-of-tree codes
which assume the previous block API where internal fields can be
manipulated and rq->data_len carries residual count on completion.

[ Impact: hide internal fields, block API change ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c       |   20 ++++++++++----------
 block/blk-map.c        |    2 +-
 block/blk-merge.c      |    2 +-
 include/linux/blkdev.h |    9 +++++----
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3596ca7..6226a38 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -127,7 +127,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	INIT_LIST_HEAD(&rq->timeout_list);
 	rq->cpu = -1;
 	rq->q = q;
-	rq->sector = (sector_t) -1;
+	rq->__sector = (sector_t) -1;
 	INIT_HLIST_NODE(&rq->hash);
 	RB_CLEAR_NODE(&rq->rb_node);
 	rq->cmd = rq->__cmd;
@@ -1095,7 +1095,7 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 		req->cmd_flags |= REQ_NOIDLE;
 
 	req->errors = 0;
-	req->sector = bio->bi_sector;
+	req->__sector = bio->bi_sector;
 	req->ioprio = bio_prio(bio);
 	blk_rq_bio_prep(req->q, req, bio);
 }
@@ -1143,7 +1143,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 
 		req->biotail->bi_next = bio;
 		req->biotail = bio;
-		req->data_len += bytes;
+		req->__data_len += bytes;
 		req->ioprio = ioprio_best(req->ioprio, prio);
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
@@ -1169,8 +1169,8 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		 * not touch req->buffer either...
 		 */
 		req->buffer = bio_data(bio);
-		req->sector = bio->bi_sector;
-		req->data_len += bytes;
+		req->__sector = bio->bi_sector;
+		req->__data_len += bytes;
 		req->ioprio = ioprio_best(req->ioprio, prio);
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
@@ -1878,7 +1878,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		 * can find how many bytes remain in the request
 		 * later.
 		 */
-		req->data_len = 0;
+		req->__data_len = 0;
 		return false;
 	}
 
@@ -1892,12 +1892,12 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 		bio_iovec(bio)->bv_len -= nr_bytes;
 	}
 
-	req->data_len -= total_bytes;
+	req->__data_len -= total_bytes;
 	req->buffer = bio_data(req->bio);
 
 	/* update sector only for requests with clear definition of sector */
 	if (blk_fs_request(req) || blk_discard_rq(req))
-		req->sector += total_bytes >> 9;
+		req->__sector += total_bytes >> 9;
 
 	/*
 	 * If total number of sectors is less than the first segment
@@ -1905,7 +1905,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	 */
 	if (blk_rq_bytes(req) < blk_rq_cur_bytes(req)) {
 		printk(KERN_ERR "blk: request botched\n");
-		req->data_len = blk_rq_cur_bytes(req);
+		req->__data_len = blk_rq_cur_bytes(req);
 	}
 
 	/* recalculate the number of segments */
@@ -2032,7 +2032,7 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 		rq->nr_phys_segments = bio_phys_segments(q, bio);
 		rq->buffer = bio_data(bio);
 	}
-	rq->data_len = bio->bi_size;
+	rq->__data_len = bio->bi_size;
 	rq->bio = rq->biotail = bio;
 
 	if (bio->bi_bdev)
diff --git a/block/blk-map.c b/block/blk-map.c
index 694fefa..56082be 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -20,7 +20,7 @@ int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		rq->biotail->bi_next = bio;
 		rq->biotail = bio;
 
-		rq->data_len += bio->bi_size;
+		rq->__data_len += bio->bi_size;
 	}
 	return 0;
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index b8df66a..4974dd5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -370,7 +370,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	req->biotail->bi_next = next->bio;
 	req->biotail = next->biotail;
 
-	req->data_len += blk_rq_bytes(next);
+	req->__data_len += blk_rq_bytes(next);
 
 	elv_merge_requests(q, req, next);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 943cbfe..feb991e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -166,8 +166,9 @@ struct request {
 	enum rq_cmd_type_bits cmd_type;
 	unsigned long atomic_flags;
 
-	sector_t sector;	/* sector cursor */
-	unsigned int data_len;	/* total data len, don't access directly */
+	/* the following two fields are internal, NEVER access directly */
+	sector_t __sector;		/* sector cursor */
+	unsigned int __data_len;	/* total data len */
 
 	struct bio *bio;
 	struct bio *biotail;
@@ -828,12 +829,12 @@ extern void blkdev_dequeue_request(struct request *req);
  */
 static inline sector_t blk_rq_pos(struct request *rq)
 {
-	return rq->sector;
+	return rq->__sector;
 }
 
 static inline unsigned int blk_rq_bytes(struct request *rq)
 {
-	return rq->data_len;
+	return rq->__data_len;
 }
 
 static inline int blk_rq_cur_bytes(struct request *rq)
-- 
1.6.0.2

