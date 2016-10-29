From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v5 10/14] dm: Fix a race condition related to stopping and
 starting queues
Date: Fri, 28 Oct 2016 17:22:16 -0700
Message-ID: <740b6120-f11b-c5f5-8072-af16ff1ffe5c@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0061.outbound.protection.outlook.com ([104.47.36.61]:51712
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964933AbcJ2AW0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 20:22:26 -0400
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Ensure that all ongoing dm_mq_queue_rq() and dm_mq_requeue_request()
calls have stopped before setting the "queue stopped" flag. This
allows to remove the "queue stopped" test from dm_mq_queue_rq() and
dm_mq_requeue_request(). This patch fixes a race condition because
dm_mq_queue_rq() is called without holding the queue lock and hence
BLK_MQ_S_STOPPED can be set at any time while dm_mq_queue_rq() is
in progress. This patch prevents that the following hang occurs
sporadically when using dm-mq:

INFO: task systemd-udevd:10111 blocked for more than 480 seconds.
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

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-rq.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 0103031..f9f37ad 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -102,7 +102,7 @@ static void dm_mq_stop_queue(struct request_queue *q)
 	if (blk_mq_queue_stopped(q))
 		return;
 
-	blk_mq_stop_hw_queues(q);
+	blk_mq_quiesce_queue(q);
 }
 
 void dm_stop_queue(struct request_queue *q)
@@ -883,17 +883,6 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
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
2.10.1

