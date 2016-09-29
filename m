From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 5/7] dm: Fix a race condition related to stopping and
 starting queues
Date: Wed, 28 Sep 2016 17:00:54 -0700
Message-ID: <8fcd8dd3-567f-a6d6-0ea8-f8cd510aea6e@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f153ee47-e599-c333-92b0-d5da475012f3-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Ensure that all ongoing dm_mq_queue_rq() and dm_mq_requeue_request()
calls have stopped before setting the "queue stopped" flag. This
allows to remove the "queue stopped" test from dm_mq_queue_rq() and
dm_mq_requeue_request(). This patch fixes a race condition because
dm_mq_queue_rq() is called without holding the queue lock and hence
BLK_MQ_S_STOPPED can be set at any time while dm_mq_queue_rq() is
in progress. This patch prevents that the following hang occurs
sporadically when using dm-mq:

INFO: task systemd-udevd:10111 blocked for more than 480 seconds.
      Not tainted 4.7.0-dbg+ #1
Call Trace:
 [<ffffffff8161f397>] schedule+0x37/0x90
 [<ffffffff816239ef>] schedule_timeout+0x27f/0x470
 [<ffffffff8161e76f>] io_schedule_timeout+0x9f/0x110
 [<ffffffff8161fb36>] bit_wait_io+0x16/0x60
 [<ffffffff8161f929>] __wait_on_bit_lock+0x49/0xa0
 [<ffffffff8114fe69>] __lock_page+0xb9/0xc0
 [<ffffffff81165d90>] truncate_inode_pages_range+0x3e0/0x760
 [<ffffffff81166120>] truncate_inode_pages+0x10/0x20
 [<ffffffff81212a20>] kill_bdev+0x30/0x40
 [<ffffffff81213d41>] __blkdev_put+0x71/0x360
 [<ffffffff81214079>] blkdev_put+0x49/0x170
 [<ffffffff812141c0>] blkdev_close+0x20/0x30
 [<ffffffff811d48e8>] __fput+0xe8/0x1f0
 [<ffffffff811d4a29>] ____fput+0x9/0x10
 [<ffffffff810842d3>] task_work_run+0x83/0xb0
 [<ffffffff8106606e>] do_exit+0x3ee/0xc40
 [<ffffffff8106694b>] do_group_exit+0x4b/0xc0
 [<ffffffff81073d9a>] get_signal+0x2ca/0x940
 [<ffffffff8101bf43>] do_signal+0x23/0x660
 [<ffffffff810022b3>] exit_to_usermode_loop+0x73/0xb0
 [<ffffffff81002cb0>] syscall_return_slowpath+0xb0/0xc0
 [<ffffffff81624e33>] entry_SYSCALL_64_fastpath+0xa6/0xa8

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>
Reviewed-by: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/md/dm-rq.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index f2c271a..f7a8ba3 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -102,9 +102,12 @@ static void dm_mq_stop_queue(struct request_queue *q)
 	if (blk_mq_queue_stopped(q))
 		return;
 
+	/* Wait until dm_mq_queue_rq() has finished. */
+	blk_mq_quiesce_queue(q);
 	/* Avoid that requeuing could restart the queue. */
 	blk_mq_cancel_requeue_work(q);
 	blk_mq_stop_hw_queues(q);
+	blk_mq_resume_queue(q);
 }
 
 void dm_stop_queue(struct request_queue *q)
@@ -887,17 +890,6 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 		dm_put_live_table(md, srcu_idx);
 	}
 
-	/*
-	 * On suspend dm_stop_queue() handles stopping the blk-mq
-	 * request_queue BUT: even though the hw_queues are marked
-	 * BLK_MQ_S_STOPPED at that point there is still a race that
-	 * is allowing block/blk-mq.c to call ->queue_rq against a
-	 * hctx that it really shouldn't.  The following check guards
-	 * against this rarity (albeit _not_ race-free).
-	 */
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
-		return BLK_MQ_RQ_QUEUE_BUSY;
-
 	if (ti->type->busy && ti->type->busy(ti))
 		return BLK_MQ_RQ_QUEUE_BUSY;
 
-- 
2.10.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
