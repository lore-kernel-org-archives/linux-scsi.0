From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/3] block: Separate zone requests from medium access requests
Date: Tue, 28 Feb 2017 19:25:34 +0900
Message-ID: <20170228102535.15966-3-damien.lemoal@wdc.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170228102535.15966-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: MPT-FusionLinux.pdl@broadcom.com, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bart.vanassche@sandisk.com>

Use blk_rq_accesses_medium() instead of !blk_rq_is_passthrough() to
ensure that code that is intended for normal medium access requests,
e.g. DISCARD, READ and WRITE requests, is not applied to
REQ_OP_ZONE_REPORT requests nor to REQ_OP_ZONE_RESET requests.
This allows excluding these zone requests from request accounting
and from request scheduling.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 block/blk-core.c       |  2 +-
 block/blk.h            |  2 +-
 block/elevator.c       | 12 ++++++++----
 block/mq-deadline.c    |  2 +-
 include/linux/blkdev.h |  6 +++---
 5 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b9e857f..addd8e1 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2608,7 +2608,7 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	req->__data_len -= total_bytes;
 
 	/* update sector only for requests with clear definition of sector */
-	if (!blk_rq_is_passthrough(req))
+	if (blk_rq_accesses_medium(req))
 		req->__sector += total_bytes >> 9;
 
 	/* mixed attributes always follow the first bio */
diff --git a/block/blk.h b/block/blk.h
index d1ea4bd9..9b63db7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -255,7 +255,7 @@ static inline int blk_do_io_stat(struct request *rq)
 {
 	return rq->rq_disk &&
 	       (rq->rq_flags & RQF_IO_STAT) &&
-		!blk_rq_is_passthrough(rq);
+		blk_rq_accesses_medium(rq);
 }
 
 static inline void req_set_nomerge(struct request_queue *q, struct request *req)
diff --git a/block/elevator.c b/block/elevator.c
index 699d10f..cbf81c6 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -635,16 +635,20 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 
 	rq->q = q;
 
-	if (rq->rq_flags & RQF_SOFTBARRIER) {
+	if (!blk_rq_accesses_medium(rq)) {
+		/* Do not schedule zone requests */
+		where = ELEVATOR_INSERT_FRONT;
+	} if (rq->rq_flags & RQF_SOFTBARRIER) {
 		/* barriers are scheduling boundary, update end_sector */
-		if (!blk_rq_is_passthrough(rq)) {
+		if (blk_rq_accesses_medium(rq)) {
 			q->end_sector = rq_end_sector(rq);
 			q->boundary_rq = rq;
 		}
 	} else if (!(rq->rq_flags & RQF_ELVPRIV) &&
 		    (where == ELEVATOR_INSERT_SORT ||
-		     where == ELEVATOR_INSERT_SORT_MERGE))
+		     where == ELEVATOR_INSERT_SORT_MERGE)) {
 		where = ELEVATOR_INSERT_BACK;
+	}
 
 	switch (where) {
 	case ELEVATOR_INSERT_REQUEUE:
@@ -679,7 +683,7 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 		if (elv_attempt_insert_merge(q, rq))
 			break;
 	case ELEVATOR_INSERT_SORT:
-		BUG_ON(blk_rq_is_passthrough(rq));
+		BUG_ON(!blk_rq_accesses_medium(rq));
 		rq->rq_flags |= RQF_SORTED;
 		q->nr_sorted++;
 		if (rq_mergeable(rq)) {
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 23612163..389c1af 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -399,7 +399,7 @@ static void dd_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 
 	blk_mq_sched_request_inserted(rq);
 
-	if (at_head || blk_rq_is_passthrough(rq)) {
+	if (at_head || !blk_rq_accesses_medium(rq)) {
 		if (at_head)
 			list_add(&rq->queuelist, &dd->dispatch);
 		else
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7d1ce2d..dcf926d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -720,7 +720,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 static inline bool blk_account_rq(struct request *rq)
 {
-	return (rq->rq_flags & RQF_STARTED) && !blk_rq_is_passthrough(rq);
+	return (rq->rq_flags & RQF_STARTED) && blk_rq_accesses_medium(rq);
 }
 
 #define blk_rq_cpu_valid(rq)	((rq)->cpu != -1)
@@ -796,7 +796,7 @@ static inline void blk_clear_rl_full(struct request_list *rl, bool sync)
 
 static inline bool rq_mergeable(struct request *rq)
 {
-	if (blk_rq_is_passthrough(rq))
+	if (!blk_rq_accesses_medium(rq))
 		return false;
 
 	if (req_op(rq) == REQ_OP_FLUSH)
@@ -1070,7 +1070,7 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 {
 	struct request_queue *q = rq->q;
 
-	if (blk_rq_is_passthrough(rq))
+	if (!blk_rq_accesses_medium(rq))
 		return q->limits.max_hw_sectors;
 
 	if (!q->limits.chunk_sectors ||
-- 
2.9.3
