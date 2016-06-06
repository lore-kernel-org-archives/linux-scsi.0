From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 1/4] Add support for SCT Write Same
Date: Mon,  6 Jun 2016 10:39:28 -0500
Message-ID: <1465227572-27149-2-git-send-email-shaun@tancheff.com>
References: <1465227572-27149-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1465227572-27149-1-git-send-email-shaun@tancheff.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-ide@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

SATA drives may support write same via SCT. This is useful
for setting the drive contents to a specific pattern (0's).

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 block/blk-core.c         | 17 ++++++++++-------
 block/blk-merge.c        |  2 +-
 block/blk-mq.c           |  2 +-
 block/cfq-iosched.c      |  2 +-
 block/elevator.c         |  4 ++--
 include/linux/elevator.h |  4 ++--
 6 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2475b1c7..945e564 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -959,7 +959,7 @@ static void __freed_request(struct request_list *rl, int sync)
  * A request has just been released.  Account for it, update the full and
  * congestion status, wake up any waiters.   Called under q->queue_lock.
  */
-static void freed_request(struct request_list *rl, unsigned int flags)
+static void freed_request(struct request_list *rl, u64 flags)
 {
 	struct request_queue *q = rl->q;
 	int sync = rw_is_sync(flags);
@@ -1054,7 +1054,7 @@ static struct io_context *rq_ioc(struct bio *bio)
 /**
  * __get_request - get a free request
  * @rl: request list to allocate from
- * @rw_flags: RW and SYNC flags
+ * @rw: RW and SYNC flags
  * @bio: bio to allocate request for (can be %NULL)
  * @gfp_mask: allocation mask
  *
@@ -1065,7 +1065,7 @@ static struct io_context *rq_ioc(struct bio *bio)
  * Returns ERR_PTR on failure, with @q->queue_lock held.
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
-static struct request *__get_request(struct request_list *rl, int rw_flags,
+static struct request *__get_request(struct request_list *rl, unsigned long rw,
 				     struct bio *bio, gfp_t gfp_mask)
 {
 	struct request_queue *q = rl->q;
@@ -1073,6 +1073,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	struct elevator_type *et = q->elevator->type;
 	struct io_context *ioc = rq_ioc(bio);
 	struct io_cq *icq = NULL;
+	u64 rw_flags = rw;
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
 	int may_queue;
 
@@ -1237,7 +1238,8 @@ rq_starved:
  * Returns ERR_PTR on failure, with @q->queue_lock held.
  * Returns request pointer on success, with @q->queue_lock *not held*.
  */
-static struct request *get_request(struct request_queue *q, int rw_flags,
+static struct request *get_request(struct request_queue *q,
+				   unsigned long rw_flags,
 				   struct bio *bio, gfp_t gfp_mask)
 {
 	const bool is_sync = rw_is_sync(rw_flags) != 0;
@@ -1490,7 +1492,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	 * it didn't come out of our reserved rq pools
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
-		unsigned int flags = req->cmd_flags;
+		u64 flags = req->cmd_flags;
 		struct request_list *rl = blk_rq_rl(req);
 
 		BUG_ON(!list_empty(&req->queuelist));
@@ -1712,7 +1714,8 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
 	struct blk_plug *plug;
-	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
+	u64 rw_flags;
+	int el_ret, where = ELEVATOR_INSERT_SORT;
 	struct request *req;
 	unsigned int request_count = 0;
 
@@ -2246,7 +2249,7 @@ EXPORT_SYMBOL_GPL(blk_insert_cloned_request);
  */
 unsigned int blk_rq_err_bytes(const struct request *rq)
 {
-	unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
+	u64 ff = rq->cmd_flags & REQ_FAILFAST_MASK;
 	unsigned int bytes = 0;
 	struct bio *bio;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2613531..fec37e1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -604,7 +604,7 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
  */
 void blk_rq_set_mixed_merge(struct request *rq)
 {
-	unsigned int ff = rq->cmd_flags & REQ_FAILFAST_MASK;
+	u64 ff = rq->cmd_flags & REQ_FAILFAST_MASK;
 	struct bio *bio;
 
 	if (rq->cmd_flags & REQ_MIXED_MERGE)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 29cbc1b..db962bc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -159,7 +159,7 @@ bool blk_mq_can_queue(struct blk_mq_hw_ctx *hctx)
 EXPORT_SYMBOL(blk_mq_can_queue);
 
 static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
-			       struct request *rq, unsigned int rw_flags)
+			       struct request *rq, u64 rw_flags)
 {
 	if (blk_queue_io_stat(q))
 		rw_flags |= REQ_IO_STAT;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 4a34978..2722345 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4285,7 +4285,7 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 	return ELV_MQUEUE_MAY;
 }
 
-static int cfq_may_queue(struct request_queue *q, int rw)
+static int cfq_may_queue(struct request_queue *q, u64 rw)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
diff --git a/block/elevator.c b/block/elevator.c
index c3555c9..7c0a59c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -511,7 +511,7 @@ void elv_merge_requests(struct request_queue *q, struct request *rq,
 			     struct request *next)
 {
 	struct elevator_queue *e = q->elevator;
-	const int next_sorted = next->cmd_flags & REQ_SORTED;
+	const int next_sorted = !!(next->cmd_flags & REQ_SORTED);
 
 	if (next_sorted && e->type->ops.elevator_merge_req_fn)
 		e->type->ops.elevator_merge_req_fn(q, rq, next);
@@ -717,7 +717,7 @@ void elv_put_request(struct request_queue *q, struct request *rq)
 		e->type->ops.elevator_put_req_fn(rq);
 }
 
-int elv_may_queue(struct request_queue *q, int rw)
+int elv_may_queue(struct request_queue *q, u64 rw)
 {
 	struct elevator_queue *e = q->elevator;
 
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 638b324..a06cca4 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -26,7 +26,7 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
-typedef int (elevator_may_queue_fn) (struct request_queue *, int);
+typedef int (elevator_may_queue_fn) (struct request_queue *, u64);
 
 typedef void (elevator_init_icq_fn) (struct io_cq *);
 typedef void (elevator_exit_icq_fn) (struct io_cq *);
@@ -134,7 +134,7 @@ extern struct request *elv_former_request(struct request_queue *, struct request
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
-extern int elv_may_queue(struct request_queue *, int);
+extern int elv_may_queue(struct request_queue *, u64);
 extern void elv_completed_request(struct request_queue *, struct request *);
 extern int elv_set_request(struct request_queue *q, struct request *rq,
 			   struct bio *bio, gfp_t gfp_mask);
-- 
2.8.1

