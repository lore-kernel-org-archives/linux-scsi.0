From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v5 04/14] blk-mq: Move more code into
 blk_mq_direct_issue_request()
Date: Fri, 28 Oct 2016 17:20:02 -0700
Message-ID: <2b30ad84-5b66-f475-7663-28d38b47e67a@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

Move the "hctx stopped" test and the insert request calls into
blk_mq_direct_issue_request(). Rename that function into
blk_mq_try_issue_directly() to reflect its new semantics. Pass
the hctx pointer to that function instead of looking it up a
second time. These changes avoid that code has to be duplicated
in the next patch.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 283e0eb..c8ae970 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1243,11 +1243,11 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	return rq;
 }
 
-static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
+static void blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
+				      struct request *rq, blk_qc_t *cookie)
 {
 	int ret;
 	struct request_queue *q = rq->q;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, rq->mq_ctx->cpu);
 	struct blk_mq_queue_data bd = {
 		.rq = rq,
 		.list = NULL,
@@ -1255,6 +1255,9 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
 	};
 	blk_qc_t new_cookie = blk_tag_to_qc_t(rq->tag, hctx->queue_num);
 
+	if (blk_mq_hctx_stopped(hctx))
+		goto insert;
+
 	/*
 	 * For OK queue, we are done. For error, kill it. Any other
 	 * error (busy), just add it to our list as we previously
@@ -1263,7 +1266,7 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
 	ret = q->mq_ops->queue_rq(hctx, &bd);
 	if (ret == BLK_MQ_RQ_QUEUE_OK) {
 		*cookie = new_cookie;
-		return 0;
+		return;
 	}
 
 	__blk_mq_requeue_request(rq);
@@ -1272,10 +1275,11 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
 		*cookie = BLK_QC_T_NONE;
 		rq->errors = -EIO;
 		blk_mq_end_request(rq, rq->errors);
-		return 0;
+		return;
 	}
 
-	return -1;
+insert:
+	blk_mq_insert_request(rq, false, true, true);
 }
 
 /*
@@ -1352,9 +1356,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (blk_mq_hctx_stopped(data.hctx) ||
-		    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
-			blk_mq_insert_request(old_rq, false, true, true);
+		blk_mq_try_issue_directly(data.hctx, old_rq, &cookie);
 		goto done;
 	}
 
-- 
2.10.1

