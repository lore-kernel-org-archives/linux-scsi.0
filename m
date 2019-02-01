From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/8] block: remove bidi support
Date: Fri,  1 Feb 2019 08:55:57 +0100
Message-ID: <20190201075557.9249-9-hch@lst.de>
References: <20190201075557.9249-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190201075557.9249-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Unused now, and another field in struct request bites the dust.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-debugfs.c | 1 -
 block/blk-mq.c         | 3 ---
 include/linux/blkdev.h | 6 ------
 3 files changed, 10 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 90d68760af08..ac832547160a 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -115,7 +115,6 @@ static int queue_pm_only_show(void *data, struct seq_file *m)
 static const char *const blk_queue_flag_name[] = {
 	QUEUE_FLAG_NAME(STOPPED),
 	QUEUE_FLAG_NAME(DYING),
-	QUEUE_FLAG_NAME(BIDI),
 	QUEUE_FLAG_NAME(NOMERGES),
 	QUEUE_FLAG_NAME(SAME_COMP),
 	QUEUE_FLAG_NAME(FAIL_IO),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 502cbf964a3b..820d131a6893 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -339,7 +339,6 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
-	rq->next_rq = NULL;
 
 	data->ctx->rq_dispatched[op_is_sync(op)]++;
 	refcount_set(&rq->ref, 1);
@@ -549,8 +548,6 @@ inline void __blk_mq_end_request(struct request *rq, blk_status_t error)
 		rq_qos_done(rq->q, rq);
 		rq->end_io(rq, error);
 	} else {
-		if (unlikely(blk_bidi_rq(rq)))
-			blk_mq_free_request(rq->next_rq);
 		blk_mq_free_request(rq);
 	}
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fd1450d53f1c..21beb456b97a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -234,9 +234,6 @@ struct request {
 	 */
 	rq_end_io_fn *end_io;
 	void *end_io_data;
-
-	/* for bidi */
-	struct request *next_rq;
 };
 
 static inline bool blk_op_is_scsi(unsigned int op)
@@ -572,7 +569,6 @@ struct request_queue {
 
 #define QUEUE_FLAG_STOPPED	1	/* queue is stopped */
 #define QUEUE_FLAG_DYING	2	/* queue being torn down */
-#define QUEUE_FLAG_BIDI		4	/* queue supports bidi requests */
 #define QUEUE_FLAG_NOMERGES     5	/* disable merge attempts */
 #define QUEUE_FLAG_SAME_COMP	6	/* complete on same CPU-group */
 #define QUEUE_FLAG_FAIL_IO	7	/* fake timeout */
@@ -644,8 +640,6 @@ static inline bool blk_account_rq(struct request *rq)
 	return (rq->rq_flags & RQF_STARTED) && !blk_rq_is_passthrough(rq);
 }
 
-#define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
-
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
 #define rq_data_dir(rq)		(op_is_write(req_op(rq)) ? WRITE : READ)
-- 
2.20.1
