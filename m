From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5/9] block: introduce blk_drain_queue()
Date: Fri,  1 Sep 2017 01:27:24 +0800
Message-ID: <20170831172728.15817-6-ming.lei@redhat.com>
References: <20170831172728.15817-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170831172728.15817-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

So that we can support legacy version of freezing queue,
which is required by safe SCSI quiescing.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c       | 16 ++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 17 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index d579501f24ba..636452f151ea 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -530,6 +530,22 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 }
 
 /**
+ * blk_drain_queue - drain requests from request_queue
+ * @q: queue to drain
+ *
+ * Drain requests from @q.  All pending requests are drained.
+ * The caller is responsible for ensuring that no new requests
+ * which need to be drained are queued.
+ */
+void blk_drain_queue(struct request_queue *q)
+{
+	spin_lock_irq(q->queue_lock);
+	__blk_drain_queue(q, true);
+	spin_unlock_irq(q->queue_lock);
+}
+EXPORT_SYMBOL(blk_drain_queue);
+
+/**
  * blk_queue_bypass_start - enter queue bypass mode
  * @q: queue of interest
  *
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f45f157b2910..02959ca03b66 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1146,6 +1146,7 @@ extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern int blk_init_allocated_queue(struct request_queue *);
 extern void blk_cleanup_queue(struct request_queue *);
+extern void blk_drain_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
 extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
-- 
2.9.5
