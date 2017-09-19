From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 01/10] blk-mq: only run hw queues for blk-mq
Date: Tue, 19 Sep 2017 11:49:16 +0800
Message-ID: <20170919034925.9894-2-ming.lei@redhat.com>
References: <20170919034925.9894-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170919034925.9894-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This patch just makes it explicitely.

Tested-by: Cathy Avery <cavery@redhat.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 98a18609755e..6fd9f86fc86d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -125,7 +125,8 @@ void blk_freeze_queue_start(struct request_queue *q)
 	freeze_depth = atomic_inc_return(&q->mq_freeze_depth);
 	if (freeze_depth == 1) {
 		percpu_ref_kill(&q->q_usage_counter);
-		blk_mq_run_hw_queues(q, false);
+		if (q->mq_ops)
+			blk_mq_run_hw_queues(q, false);
 	}
 }
 EXPORT_SYMBOL_GPL(blk_freeze_queue_start);
-- 
2.9.5
