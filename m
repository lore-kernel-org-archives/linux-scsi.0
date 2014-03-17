From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 26/39] HACK: support blk_delay_queue for blk-mq
Date: Mon, 17 Mar 2014 06:27:59 -0700
Message-ID: <20140317133135.255494845@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0026-HACK-support-blk_delay_queue-for-blk-mq.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4cd5ffc..47af781 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -163,9 +163,14 @@ static void blk_delay_work(struct work_struct *work)
 	struct request_queue *q;
 
 	q = container_of(work, struct request_queue, delay_work.work);
-	spin_lock_irq(q->queue_lock);
-	__blk_run_queue(q);
-	spin_unlock_irq(q->queue_lock);
+
+	if (q->mq_ops) {
+		blk_mq_start_stopped_hw_queues(q, false);
+	} else {
+		spin_lock_irq(q->queue_lock);
+		__blk_run_queue(q);
+		spin_unlock_irq(q->queue_lock);
+	}
 }
 
 /**
-- 
1.7.10.4
