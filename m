From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/27] loop: implement REQ_OP_WRITE_ZEROES
Date: Wed,  5 Apr 2017 19:21:15 +0200
Message-ID: <20170405172125.22600-18-hch@lst.de>
References: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

It's identical to discard as hole punches will always leave us with
zeroes on reads.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/block/loop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index cc981f34e017..3bb04c1a4ba1 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -528,6 +528,7 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	case REQ_OP_FLUSH:
 		return lo_req_flush(lo, rq);
 	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE_ZEROES:
 		return lo_discard(lo, rq, pos);
 	case REQ_OP_WRITE:
 		if (lo->transfer)
@@ -826,6 +827,7 @@ static void loop_config_discard(struct loop_device *lo)
 		q->limits.discard_granularity = 0;
 		q->limits.discard_alignment = 0;
 		blk_queue_max_discard_sectors(q, 0);
+		blk_queue_max_write_zeroes_sectors(q, 0);
 		q->limits.discard_zeroes_data = 0;
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 		return;
@@ -834,6 +836,7 @@ static void loop_config_discard(struct loop_device *lo)
 	q->limits.discard_granularity = inode->i_sb->s_blocksize;
 	q->limits.discard_alignment = 0;
 	blk_queue_max_discard_sectors(q, UINT_MAX >> 9);
+	blk_queue_max_write_zeroes_sectors(q, UINT_MAX >> 9);
 	q->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
@@ -1660,6 +1663,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	switch (req_op(cmd->rq)) {
 	case REQ_OP_FLUSH:
 	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE_ZEROES:
 		cmd->use_aio = false;
 		break;
 	default:
-- 
2.11.0
