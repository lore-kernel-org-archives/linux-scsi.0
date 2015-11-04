From: mchristi@redhat.com
Subject: [PATCH 29/32] block/drivers: rm request cmd_flags REQ_OP
	use
Date: Wed,  4 Nov 2015 16:08:26 -0600
Message-ID: <1446674909-5371-30-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

With this patch the request struct code no longer uses the
cmd_flags field for REQ_OP operations.

---
 block/blk-core.c                  | 17 +++++++++--------
 block/blk-merge.c                 | 10 ++++++----
 block/blk-mq.c                    | 10 +++++-----
 block/cfq-iosched.c               |  4 ++--
 block/elevator.c                  |  8 ++++----
 drivers/block/loop.c              |  2 +-
 drivers/block/mtip32xx/mtip32xx.c |  2 +-
 drivers/block/nbd.c               |  2 +-
 drivers/block/nvme-core.c         |  6 +++---
 drivers/block/rbd.c               |  2 +-
 drivers/block/skd_main.c          | 11 ++++-------
 drivers/block/xen-blkfront.c      |  8 +++++---
 drivers/md/dm.c                   |  2 +-
 drivers/mmc/card/block.c          |  7 +++----
 drivers/mmc/card/queue.c          |  6 ++----
 drivers/mmc/card/queue.h          |  5 ++++-
 drivers/mtd/mtd_blkdevs.c         |  2 +-
 drivers/scsi/sd.c                 | 22 ++++++++++++++--------
 include/linux/blkdev.h            | 26 +++++++++++++-------------
 include/linux/elevator.h          |  4 ++--
 20 files changed, 82 insertions(+), 74 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e625516..deb8bfd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -889,10 +889,10 @@ static void __freed_request(struct request_list *rl, int sync)
  * A request has just been released.  Account for it, update the full and
  * congestion status, wake up any waiters.   Called under q->queue_lock.
  */
-static void freed_request(struct request_list *rl, unsigned int flags)
+static void freed_request(struct request_list *rl, int op, unsigned int flags)
 {
 	struct request_queue *q = rl->q;
-	int sync = rw_is_sync(flags);
+	int sync = rw_is_sync(op, flags);
 
 	q->nr_rqs[sync]--;
 	rl->count[sync]--;
@@ -1005,13 +1005,13 @@ static struct request *__get_request(struct request_list *rl, int op,
 	struct elevator_type *et = q->elevator->type;
 	struct io_context *ioc = rq_ioc(bio);
 	struct io_cq *icq = NULL;
-	const bool is_sync = rw_is_sync(op | op_flags) != 0;
+	const bool is_sync = rw_is_sync(op, op_flags) != 0;
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
 		return ERR_PTR(-ENODEV);
 
-	may_queue = elv_may_queue(q, op | op_flags);
+	may_queue = elv_may_queue(q, op, op_flags);
 	if (may_queue == ELV_MQUEUE_NO)
 		goto rq_starved;
 
@@ -1141,7 +1141,7 @@ fail_alloc:
 	 * queue, but this is pretty rare.
 	 */
 	spin_lock_irq(q->queue_lock);
-	freed_request(rl, op | op_flags);
+	freed_request(rl, op, op_flags);
 
 	/*
 	 * in the very unlikely event that allocation failed and no
@@ -1175,7 +1175,7 @@ static struct request *get_request(struct request_queue *q, int op,
 				   int op_flags, struct bio *bio,
 				   gfp_t gfp_mask)
 {
-	const bool is_sync = rw_is_sync(op | op_flags) != 0;
+	const bool is_sync = rw_is_sync(op, op_flags) != 0;
 	DEFINE_WAIT(wait);
 	struct request_list *rl;
 	struct request *rq;
@@ -1424,13 +1424,14 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	 */
 	if (req->cmd_flags & REQ_ALLOCED) {
 		unsigned int flags = req->cmd_flags;
+		int op = req->op;
 		struct request_list *rl = blk_rq_rl(req);
 
 		BUG_ON(!list_empty(&req->queuelist));
 		BUG_ON(ELV_ON_HASH(req));
 
 		blk_free_request(rl, req);
-		freed_request(rl, flags);
+		freed_request(rl, op, flags);
 		blk_put_rl(rl);
 	}
 }
@@ -2054,7 +2055,7 @@ int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 	if (!rq_mergeable(rq))
 		return 0;
 
-	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
+	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->op)) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
 		return -EIO;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index fe00d94..ec42c7e 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -582,7 +582,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (!rq_mergeable(req) || !rq_mergeable(next))
 		return 0;
 
-	if (!blk_check_merge_flags(req->cmd_flags, next->cmd_flags))
+	if (!blk_check_merge_flags(req->cmd_flags, req->op, next->cmd_flags,
+				   next->op))
 		return 0;
 
 	/*
@@ -596,7 +597,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	    || req_no_special_merge(next))
 		return 0;
 
-	if (req->cmd_flags & REQ_WRITE_SAME &&
+	if (req->op == REQ_OP_WRITE_SAME &&
 	    !blk_write_same_mergeable(req->bio, next->bio))
 		return 0;
 
@@ -684,7 +685,8 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (!rq_mergeable(rq) || !bio_mergeable(bio))
 		return false;
 
-	if (!blk_check_merge_flags(rq->cmd_flags, bio->bi_rw))
+	if (!blk_check_merge_flags(rq->cmd_flags, rq->op, bio->bi_rw,
+				   bio->bi_op))
 		return false;
 
 	/* different data direction or already started, don't merge */
@@ -700,7 +702,7 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		return false;
 
 	/* must be using the same buffer */
-	if (rq->cmd_flags & REQ_WRITE_SAME &&
+	if (rq->op == REQ_OP_WRITE_SAME &&
 	    !blk_write_same_mergeable(rq->bio, bio))
 		return false;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index d57a581..b7352ad 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -187,7 +187,7 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->q = q;
 	rq->mq_ctx = ctx;
 	rq->op = op;
-	rq->cmd_flags |= op | op_flags;
+	rq->cmd_flags |= op_flags;
 	/* do not touch atomic flags, it needs atomic ops against the timer */
 	rq->cpu = -1;
 	INIT_HLIST_NODE(&rq->hash);
@@ -222,7 +222,7 @@ static void blk_mq_rq_ctx_init(struct request_queue *q, struct blk_mq_ctx *ctx,
 	rq->end_io_data = NULL;
 	rq->next_rq = NULL;
 
-	ctx->rq_dispatched[rw_is_sync(op | op_flags)]++;
+	ctx->rq_dispatched[rw_is_sync(op, op_flags)]++;
 }
 
 static struct request *
@@ -1187,7 +1187,7 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	ctx = blk_mq_get_ctx(q);
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
-	if (rw_is_sync(bio->bi_rw))
+	if (rw_is_sync(bio->bi_op, bio->bi_rw))
 		op_flags |= REQ_SYNC;
 
 	trace_block_getrq(q, bio, op);
@@ -1253,7 +1253,7 @@ static int blk_mq_direct_issue_request(struct request *rq)
  */
 static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio->bi_op, bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
@@ -1341,7 +1341,7 @@ run_queue:
  */
 static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
-	const int is_sync = rw_is_sync(bio->bi_rw);
+	const int is_sync = rw_is_sync(bio->bi_op, bio->bi_rw);
 	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dbc3da4..fc964e1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -4271,7 +4271,7 @@ static inline int __cfq_may_queue(struct cfq_queue *cfqq)
 	return ELV_MQUEUE_MAY;
 }
 
-static int cfq_may_queue(struct request_queue *q, int rw)
+static int cfq_may_queue(struct request_queue *q, int op, int op_flags)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct task_struct *tsk = current;
@@ -4288,7 +4288,7 @@ static int cfq_may_queue(struct request_queue *q, int rw)
 	if (!cic)
 		return ELV_MQUEUE_MAY;
 
-	cfqq = cic_to_cfqq(cic, rw_is_sync(rw));
+	cfqq = cic_to_cfqq(cic, rw_is_sync(op, op_flags));
 	if (cfqq) {
 		cfq_init_prio_data(cfqq, cic);
 
diff --git a/block/elevator.c b/block/elevator.c
index 84d6394..1624d48 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -366,8 +366,8 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 	list_for_each_prev(entry, &q->queue_head) {
 		struct request *pos = list_entry_rq(entry);
 
-		if ((rq->cmd_flags & REQ_DISCARD) !=
-		    (pos->cmd_flags & REQ_DISCARD))
+		if ((rq->op == REQ_OP_DISCARD) !=
+		    (pos->op == REQ_OP_DISCARD))
 			break;
 		if (rq_data_dir(rq) != rq_data_dir(pos))
 			break;
@@ -717,12 +717,12 @@ void elv_put_request(struct request_queue *q, struct request *rq)
 		e->type->ops.elevator_put_req_fn(rq);
 }
 
-int elv_may_queue(struct request_queue *q, int rw)
+int elv_may_queue(struct request_queue *q, int op, int op_flags)
 {
 	struct elevator_queue *e = q->elevator;
 
 	if (e->type->ops.elevator_may_queue_fn)
-		return e->type->ops.elevator_may_queue_fn(q, rw);
+		return e->type->ops.elevator_may_queue_fn(q, op, op_flags);
 
 	return ELV_MQUEUE_MAY;
 }
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e214936..bddffed 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -399,7 +399,7 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	if (rq_data_dir(rq) == WRITE) {
 		if (rq->cmd_flags & REQ_FLUSH)
 			ret = lo_req_flush(lo, rq);
-		else if (rq->cmd_flags & REQ_DISCARD)
+		else if (rq->op == REQ_OP_DISCARD)
 			ret = lo_discard(lo, rq, pos);
 		else if (lo->transfer)
 			ret = lo_write_transfer(lo, rq, pos);
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index f504232..a3f1b7a 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3677,7 +3677,7 @@ static int mtip_submit_request(struct blk_mq_hw_ctx *hctx, struct request *rq)
 			return -ENXIO;
 	}
 
-	if (rq->cmd_flags & REQ_DISCARD) {
+	if (rq->op == REQ_OP_DISCARD) {
 		int err;
 
 		err = mtip_send_trim(dd, blk_rq_pos(rq), blk_rq_sectors(rq));
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 1b87623..2d24c1a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -242,7 +242,7 @@ static int nbd_send_req(struct nbd_device *nbd, struct request *req)
 
 	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
 		type = NBD_CMD_DISC;
-	else if (req->cmd_flags & REQ_DISCARD)
+	else if (req->op == REQ_OP_DISCARD)
 		type = NBD_CMD_TRIM;
 	else if (req->cmd_flags & REQ_FLUSH)
 		type = NBD_CMD_FLUSH;
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index ccc0c1f..aeba59e 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -440,7 +440,7 @@ __nvme_alloc_iod(unsigned nseg, unsigned bytes, struct nvme_dev *dev,
 static struct nvme_iod *nvme_alloc_iod(struct request *rq, struct nvme_dev *dev,
 			               gfp_t gfp)
 {
-	unsigned size = !(rq->cmd_flags & REQ_DISCARD) ? blk_rq_bytes(rq) :
+	unsigned size = !(rq->op == REQ_OP_DISCARD) ? blk_rq_bytes(rq) :
                                                 sizeof(struct nvme_dsm_range);
 	struct nvme_iod *iod;
 
@@ -877,7 +877,7 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (!iod)
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
-	if (req->cmd_flags & REQ_DISCARD) {
+	if (req->op == REQ_OP_DISCARD) {
 		void *range;
 		/*
 		 * We reuse the small pool to allocate the 16-byte range here
@@ -927,7 +927,7 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	spin_lock_irq(&nvmeq->q_lock);
 	if (req->cmd_type == REQ_TYPE_DRV_PRIV)
 		nvme_submit_priv(nvmeq, req, iod);
-	else if (req->cmd_flags & REQ_DISCARD)
+	else if (req->op == REQ_OP_DISCARD)
 		nvme_submit_discard(nvmeq, ns, req, iod);
 	else if (req->cmd_flags & REQ_FLUSH)
 		nvme_submit_flush(nvmeq, ns, req->tag);
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 39104ca..5ee8abe 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3375,7 +3375,7 @@ static void rbd_queue_workfn(struct work_struct *work)
 		goto err;
 	}
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->op == REQ_OP_DISCARD)
 		op_type = OBJ_OP_DISCARD;
 	else if (rq_data_dir(rq) == WRITE)
 		op_type = OBJ_OP_WRITE;
diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 586f916..f89a0c8 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -576,7 +576,6 @@ static void skd_request_fn(struct request_queue *q)
 	struct request *req = NULL;
 	struct skd_scsi_request *scsi_req;
 	struct page *page;
-	unsigned long io_flags;
 	int error;
 	u32 lba;
 	u32 count;
@@ -624,12 +623,11 @@ static void skd_request_fn(struct request_queue *q)
 		lba = (u32)blk_rq_pos(req);
 		count = blk_rq_sectors(req);
 		data_dir = rq_data_dir(req);
-		io_flags = req->cmd_flags;
 
-		if (io_flags & REQ_FLUSH)
+		if (req->cmd_flags & REQ_FLUSH)
 			flush++;
 
-		if (io_flags & REQ_FUA)
+		if (req->cmd_flags & REQ_FUA)
 			fua++;
 
 		pr_debug("%s:%s:%d new req=%p lba=%u(0x%x) "
@@ -735,7 +733,7 @@ static void skd_request_fn(struct request_queue *q)
 		else
 			skreq->sg_data_dir = SKD_DATA_DIR_HOST_TO_CARD;
 
-		if (io_flags & REQ_DISCARD) {
+		if (req->op == REQ_OP_DISCARD) {
 			page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
 			if (!page) {
 				pr_err("request_fn:Page allocation failed.\n");
@@ -852,9 +850,8 @@ static void skd_end_request(struct skd_device *skdev,
 			    struct skd_request_context *skreq, int error)
 {
 	struct request *req = skreq->req;
-	unsigned int io_flags = req->cmd_flags;
 
-	if ((io_flags & REQ_DISCARD) &&
+	if ((req->op == REQ_OP_DISCARD) &&
 		(skreq->discard_page == 1)) {
 		pr_debug("%s:%s:%d, free the page!",
 			 skdev->name, __func__, __LINE__);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index ec76178..91eccd1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -452,7 +452,8 @@ static int blkif_queue_request(struct request *req)
 	id = get_id_from_freelist(info);
 	info->shadow[id].request = req;
 
-	if (unlikely(req->cmd_flags & (REQ_DISCARD | REQ_SECURE))) {
+	if (unlikely(req->op == REQ_OP_DISCARD ||
+		     req->cmd_flags & REQ_SECURE)) {
 		ring_req->operation = BLKIF_OP_DISCARD;
 		ring_req->u.discard.nr_sectors = blk_rq_sectors(req);
 		ring_req->u.discard.id = id;
@@ -1533,8 +1534,9 @@ static int blkif_recover(struct blkfront_info *info)
 		/*
 		 * Get the bios in the request so we can re-queue them.
 		 */
-		if (copy[i].request->cmd_flags &
-		    (REQ_FLUSH | REQ_FUA | REQ_DISCARD | REQ_SECURE)) {
+		if (copy[i].request->cmd_flags & REQ_FLUSH ||
+		    copy[i].request->op == REQ_OP_DISCARD ||
+		    copy[i].request->cmd_flags & (REQ_FUA | REQ_SECURE)) {
 			/*
 			 * Flush operations don't contain bios, so
 			 * we need to requeue the whole request
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ea4bc70..e03ca09 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1245,7 +1245,7 @@ static void dm_done(struct request *clone, int error, bool mapped)
 			r = rq_end_io(tio->ti, clone, error, &tio->info);
 	}
 
-	if (unlikely(r == -EREMOTEIO && (clone->cmd_flags & REQ_WRITE_SAME) &&
+	if (unlikely(r == -EREMOTEIO && (clone->op == REQ_OP_WRITE_SAME) &&
 		     !clone->q->limits.max_write_same_sectors))
 		disable_write_same(tio->md);
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index c742cfd..e99361f 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1613,8 +1613,7 @@ static u8 mmc_blk_prep_packed_list(struct mmc_queue *mq, struct request *req)
 		    !IS_ALIGNED(blk_rq_sectors(next), 8))
 			break;
 
-		if (next->cmd_flags & REQ_DISCARD ||
-		    next->cmd_flags & REQ_FLUSH)
+		if (next->op == REQ_OP_DISCARD || next->cmd_flags & REQ_FLUSH)
 			break;
 
 		if (rq_data_dir(cur) != rq_data_dir(next))
@@ -2055,7 +2054,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 	}
 
 	mq->flags &= ~MMC_QUEUE_NEW_REQUEST;
-	if (cmd_flags & REQ_DISCARD) {
+	if (req && req->op == REQ_OP_DISCARD) {
 		/* complete ongoing async transfer before issuing discard */
 		if (card->host->areq)
 			mmc_blk_issue_rw_rq(mq, NULL);
@@ -2079,7 +2078,7 @@ static int mmc_blk_issue_rq(struct mmc_queue *mq, struct request *req)
 
 out:
 	if ((!req && !(mq->flags & MMC_QUEUE_NEW_REQUEST)) ||
-	     (cmd_flags & MMC_REQ_SPECIAL_MASK))
+	    mmc_req_is_special(req))
 		/*
 		 * Release host when there are no more requests
 		 * and after special request(discard, flush) is done.
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 6f4323c..9fb8d21 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -33,7 +33,7 @@ static int mmc_prep_request(struct request_queue *q, struct request *req)
 	/*
 	 * We only like normal block requests and discards.
 	 */
-	if (req->cmd_type != REQ_TYPE_FS && !(req->cmd_flags & REQ_DISCARD)) {
+	if (req->cmd_type != REQ_TYPE_FS && req->op != REQ_OP_DISCARD) {
 		blk_dump_rq_flags(req, "MMC bad request");
 		return BLKPREP_KILL;
 	}
@@ -56,7 +56,6 @@ static int mmc_queue_thread(void *d)
 	down(&mq->thread_sem);
 	do {
 		struct request *req = NULL;
-		unsigned int cmd_flags = 0;
 
 		spin_lock_irq(q->queue_lock);
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -66,7 +65,6 @@ static int mmc_queue_thread(void *d)
 
 		if (req || mq->mqrq_prev->req) {
 			set_current_state(TASK_RUNNING);
-			cmd_flags = req ? req->cmd_flags : 0;
 			mq->issue_fn(mq, req);
 			cond_resched();
 			if (mq->flags & MMC_QUEUE_NEW_REQUEST) {
@@ -81,7 +79,7 @@ static int mmc_queue_thread(void *d)
 			 * has been finished. Do not assign it to previous
 			 * request.
 			 */
-			if (cmd_flags & MMC_REQ_SPECIAL_MASK)
+			if (mmc_req_is_special(req))
 				mq->mqrq_cur->req = NULL;
 
 			mq->mqrq_prev->brq.mrq.data = NULL;
diff --git a/drivers/mmc/card/queue.h b/drivers/mmc/card/queue.h
index 36cddab..f166e5b 100644
--- a/drivers/mmc/card/queue.h
+++ b/drivers/mmc/card/queue.h
@@ -1,7 +1,10 @@
 #ifndef MMC_QUEUE_H
 #define MMC_QUEUE_H
 
-#define MMC_REQ_SPECIAL_MASK	(REQ_DISCARD | REQ_FLUSH)
+static inline bool mmc_req_is_special(struct request *req)
+{
+	return req && (req->cmd_flags & REQ_FLUSH || req->op == REQ_OP_DISCARD);
+}
 
 struct request;
 struct task_struct;
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 44dc965..49017f0 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -94,7 +94,7 @@ static int do_blktrans_request(struct mtd_blktrans_ops *tr,
 	    get_capacity(req->rq_disk))
 		return -EIO;
 
-	if (req->cmd_flags & REQ_DISCARD)
+	if (req->op == REQ_OP_DISCARD)
 		return tr->discard(dev, block, nsect);
 
 	if (rq_data_dir(req) == READ) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f37022..353508c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1122,21 +1122,27 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 {
 	struct request *rq = cmd->request;
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	switch (rq->op) {
+	case REQ_OP_DISCARD:
 		return sd_setup_discard_cmnd(cmd);
-	else if (rq->cmd_flags & REQ_WRITE_SAME)
+	case REQ_OP_WRITE_SAME:
 		return sd_setup_write_same_cmnd(cmd);
-	else if (rq->cmd_flags & REQ_FLUSH)
-		return sd_setup_flush_cmnd(cmd);
-	else
-		return sd_setup_read_write_cmnd(cmd);
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+		if (rq->cmd_flags & REQ_FLUSH)
+			return sd_setup_flush_cmnd(cmd);
+		else
+			return sd_setup_read_write_cmnd(cmd);
+	default:
+		BUG();
+	}
 }
 
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
-	if (rq->cmd_flags & REQ_DISCARD)
+	if (rq->op == REQ_OP_DISCARD)
 		__free_page(rq->completion_data);
 
 	if (SCpnt->cmnd != rq->cmd) {
@@ -1658,7 +1664,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
-	if (req->cmd_flags & REQ_DISCARD || req->cmd_flags & REQ_WRITE_SAME) {
+	if (req->op == REQ_OP_DISCARD || req->op == REQ_OP_WRITE_SAME) {
 		if (!result) {
 			good_bytes = blk_rq_bytes(req);
 			scsi_set_resid(SCpnt, 0);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4376ec6..d930191 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -618,14 +618,14 @@ static inline unsigned int blk_queue_cluster(struct request_queue *q)
 /*
  * We regard a request as sync, if either a read or a sync write
  */
-static inline bool rw_is_sync(unsigned int rw_flags)
+static inline bool rw_is_sync(int op, unsigned int rw_flags)
 {
-	return !(rw_flags & REQ_WRITE) || (rw_flags & REQ_SYNC);
+	return (op_to_data_dir(op) == READ) || (rw_flags & REQ_SYNC);
 }
 
 static inline bool rq_is_sync(struct request *rq)
 {
-	return rw_is_sync(rq->cmd_flags);
+	return rw_is_sync(rq->op, rq->cmd_flags);
 }
 
 static inline bool blk_rl_full(struct request_list *rl, bool sync)
@@ -660,16 +660,16 @@ static inline bool rq_mergeable(struct request *rq)
 	return true;
 }
 
-static inline bool blk_check_merge_flags(unsigned int flags1,
-					 unsigned int flags2)
+static inline bool blk_check_merge_flags(unsigned int flags1, unsigned int op1,
+					 unsigned int flags2, unsigned int op2)
 {
-	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
+	if ((op1 == REQ_OP_DISCARD) != (op2 == REQ_OP_DISCARD))
 		return false;
 
 	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
 		return false;
 
-	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
+	if ((op1 == REQ_OP_WRITE_SAME) != (op2 == REQ_OP_WRITE_SAME))
 		return false;
 
 	return true;
@@ -863,12 +863,12 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 }
 
 static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     unsigned int cmd_flags)
+						     int op)
 {
-	if (unlikely(cmd_flags & REQ_DISCARD))
+	if (unlikely(op == REQ_OP_DISCARD))
 		return min(q->limits.max_discard_sectors, UINT_MAX >> 9);
 
-	if (unlikely(cmd_flags & REQ_WRITE_SAME))
+	if (unlikely(op == REQ_OP_WRITE_SAME))
 		return q->limits.max_write_same_sectors;
 
 	return q->limits.max_sectors;
@@ -895,11 +895,11 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
 	if (unlikely(rq->cmd_type == REQ_TYPE_BLOCK_PC))
 		return q->limits.max_hw_sectors;
 
-	if (!q->limits.chunk_sectors || (rq->cmd_flags & REQ_DISCARD))
-		return blk_queue_get_max_sectors(q, rq->cmd_flags);
+	if (!q->limits.chunk_sectors || (rq->op == REQ_OP_DISCARD))
+		return blk_queue_get_max_sectors(q, rq->op);
 
 	return min(blk_max_size_offset(q, blk_rq_pos(rq)),
-			blk_queue_get_max_sectors(q, rq->cmd_flags));
+			blk_queue_get_max_sectors(q, rq->op));
 }
 
 static inline unsigned int blk_rq_count_bios(struct request *rq)
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 638b324..953d286 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -26,7 +26,7 @@ typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
-typedef int (elevator_may_queue_fn) (struct request_queue *, int);
+typedef int (elevator_may_queue_fn) (struct request_queue *, int, int);
 
 typedef void (elevator_init_icq_fn) (struct io_cq *);
 typedef void (elevator_exit_icq_fn) (struct io_cq *);
@@ -134,7 +134,7 @@ extern struct request *elv_former_request(struct request_queue *, struct request
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
 extern void elv_unregister_queue(struct request_queue *q);
-extern int elv_may_queue(struct request_queue *, int);
+extern int elv_may_queue(struct request_queue *, int, int);
 extern void elv_completed_request(struct request_queue *, struct request *);
 extern int elv_set_request(struct request_queue *q, struct request *rq,
 			   struct bio *bio, gfp_t gfp_mask);
-- 
1.8.3.1
