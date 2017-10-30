From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v11 3/7] block: Introduce BLK_MQ_REQ_PREEMPT
Date: Mon, 30 Oct 2017 15:42:01 -0700
Message-ID: <20171030224205.25212-4-bart.vanassche@wdc.com>
References: <20171030224205.25212-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:50774 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752521AbdJ3WmJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2017 18:42:09 -0400
In-Reply-To: <20171030224205.25212-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>

Set RQF_PREEMPT if BLK_MQ_REQ_PREEMPT is passed to
blk_get_request_flags().

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-core.c       | 4 +++-
 block/blk-mq.c         | 2 ++
 include/linux/blk-mq.h | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 396104c05b38..48f18f5e2e16 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1262,6 +1262,8 @@ static struct request *__get_request(struct request_list *rl, unsigned int op,
 	blk_rq_set_rl(rq, rl);
 	rq->cmd_flags = op;
 	rq->rq_flags = rq_flags;
+	if (flags & BLK_MQ_REQ_PREEMPT)
+		rq->rq_flags |= RQF_PREEMPT;
 
 	/* init elvpriv */
 	if (rq_flags & RQF_ELVPRIV) {
@@ -1443,7 +1445,7 @@ struct request *blk_get_request_flags(struct request_queue *q, unsigned int op,
 	struct request *req;
 
 	WARN_ON_ONCE(op & REQ_NOWAIT);
-	WARN_ON_ONCE(flags & ~BLK_MQ_REQ_NOWAIT);
+	WARN_ON_ONCE(flags & ~(BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_PREEMPT));
 
 	if (q->mq_ops) {
 		req = blk_mq_alloc_request(q, op, flags);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 59b7de6b616b..6a025b17caac 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -290,6 +290,8 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	rq->q = data->q;
 	rq->mq_ctx = data->ctx;
 	rq->cmd_flags = op;
+	if (data->flags & BLK_MQ_REQ_PREEMPT)
+		rq->rq_flags |= RQF_PREEMPT;
 	if (blk_queue_io_stat(data->q))
 		rq->rq_flags |= RQF_IO_STAT;
 	/* do not touch atomic flags, it needs atomic ops against the timer */
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index e5e6becd57d3..22c7f36745fc 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -213,6 +213,7 @@ enum {
 	BLK_MQ_REQ_NOWAIT	= (1 << 0), /* return when out of requests */
 	BLK_MQ_REQ_RESERVED	= (1 << 1), /* allocate from reserved pool */
 	BLK_MQ_REQ_INTERNAL	= (1 << 2), /* allocate internal/sched tag */
+	BLK_MQ_REQ_PREEMPT	= (1 << 3), /* set RQF_PREEMPT */
 };
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
-- 
2.14.2
