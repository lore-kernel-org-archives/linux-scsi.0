From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] blk-mq: Avoid that request queue removal can trigger list corruption
Date: Wed, 8 Nov 2017 10:23:45 -0800
Message-ID: <20171108182345.8616-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Avoid that removal of a request queue sporadically triggers the
following warning:

list_del corruption. next->prev should be ffff8807d649b970, but was 6b6b6b6b6b6b6b6b
WARNING: CPU: 3 PID: 342 at lib/list_debug.c:56 __list_del_entry_valid+0x92/0xa0
Call Trace:
 process_one_work+0x11b/0x660
 worker_thread+0x3d/0x3b0
 kthread+0x129/0x140
 ret_from_fork+0x27/0x40

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 25ccddd0b82a..1b80d43fcbc6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -339,6 +339,7 @@ void blk_sync_queue(struct request_queue *q)
 		struct blk_mq_hw_ctx *hctx;
 		int i;
 
+		cancel_delayed_work_sync(&q->requeue_work);
 		queue_for_each_hw_ctx(q, hctx, i)
 			cancel_delayed_work_sync(&hctx->run_work);
 	} else {
-- 
2.14.3
