From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 1/7] blk-mq: allow the callback to blk_mq_tag_busy_iter() to stop looping
Date: Fri, 3 Apr 2015 09:58:17 -0600
Message-ID: <1428076703-31014-2-git-send-email-axboe@fb.com>
References: <1428076703-31014-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428076703-31014-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

Currently blk_mq_tag_busy_iter() loops all busy tags for a given
hardware queue. But sometimes we are looking for a specific request,
and when we find it, we don't have to keep looking over the rest of
them. Change the busy_iter_fn callback to return a bool, where a
true return will break out of the search.

Update current callers (blk-mq timeout and NVMe IO cancel).

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 block/blk-mq-tag.c        |  6 ++++--
 block/blk-mq.c            | 10 ++++++----
 drivers/block/nvme-core.c |  7 ++++---
 include/linux/blk-mq.h    |  2 +-
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index be3290cc0644..129a881b8ef1 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -430,8 +430,10 @@ static void bt_for_each(struct blk_mq_hw_ctx *hctx,
 		     bit < bm->depth;
 		     bit = find_next_bit(&bm->word, bm->depth, bit + 1)) {
 		     	rq = blk_mq_tag_to_rq(hctx->tags, off + bit);
-			if (rq->q == hctx->queue)
-				fn(hctx, rq, data, reserved);
+			if (rq->q != hctx->queue)
+				continue;
+			if (fn(hctx, rq, data, reserved))
+				break;
 		}
 
 		off += (1 << bt->bits_per_word);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b7b8933ec241..1cd34d4d707c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -622,8 +622,8 @@ void blk_mq_rq_timed_out(struct request *req, bool reserved)
 	}
 }
 
-static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
-		struct request *rq, void *priv, bool reserved)
+static bool blk_mq_check_expired(struct blk_mq_hw_ctx *hctx, struct request *rq,
+				 void *priv, bool reserved)
 {
 	struct blk_mq_timeout_data *data = priv;
 
@@ -636,10 +636,10 @@ static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 			rq->errors = -EIO;
 			blk_mq_complete_request(rq);
 		}
-		return;
+		return false;
 	}
 	if (rq->cmd_flags & REQ_NO_TIMEOUT)
-		return;
+		return false;
 
 	if (time_after_eq(jiffies, rq->deadline)) {
 		if (!blk_mark_rq_complete(rq))
@@ -648,6 +648,8 @@ static void blk_mq_check_expired(struct blk_mq_hw_ctx *hctx,
 		data->next = rq->deadline;
 		data->next_set = 1;
 	}
+
+	return false;
 }
 
 static void blk_mq_rq_timer(unsigned long priv)
diff --git a/drivers/block/nvme-core.c b/drivers/block/nvme-core.c
index e23be20a3417..46697ddfda82 100644
--- a/drivers/block/nvme-core.c
+++ b/drivers/block/nvme-core.c
@@ -1260,7 +1260,7 @@ static void nvme_abort_req(struct request *req)
 	}
 }
 
-static void nvme_cancel_queue_ios(struct blk_mq_hw_ctx *hctx,
+static bool nvme_cancel_queue_ios(struct blk_mq_hw_ctx *hctx,
 				struct request *req, void *data, bool reserved)
 {
 	struct nvme_queue *nvmeq = data;
@@ -1270,12 +1270,12 @@ static void nvme_cancel_queue_ios(struct blk_mq_hw_ctx *hctx,
 	struct nvme_completion cqe;
 
 	if (!blk_mq_request_started(req))
-		return;
+		return false;
 
 	cmd = blk_mq_rq_to_pdu(req);
 
 	if (cmd->ctx == CMD_CTX_CANCELLED)
-		return;
+		return false;
 
 	if (blk_queue_dying(req->q))
 		cqe.status = cpu_to_le16((NVME_SC_ABORT_REQ | NVME_SC_DNR) << 1);
@@ -1287,6 +1287,7 @@ static void nvme_cancel_queue_ios(struct blk_mq_hw_ctx *hctx,
 						req->tag, nvmeq->qid);
 	ctx = cancel_cmd_info(cmd, &fn);
 	fn(nvmeq, ctx, &cqe);
+	return false;
 }
 
 static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 7aec86127335..b216deab80d9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -94,7 +94,7 @@ typedef int (init_request_fn)(void *, struct request *, unsigned int,
 typedef void (exit_request_fn)(void *, struct request *, unsigned int,
 		unsigned int);
 
-typedef void (busy_iter_fn)(struct blk_mq_hw_ctx *, struct request *, void *,
+typedef bool (busy_iter_fn)(struct blk_mq_hw_ctx *, struct request *, void *,
 		bool);
 
 struct blk_mq_ops {
-- 
1.9.1
