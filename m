From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/41] block: simplify queue_next_fseq
Date: Fri,  3 Sep 2010 12:29:27 +0200
Message-ID: <1283509796-1510-13-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

We need to call blk_rq_init and elv_insert for all cases in queue_next_fseq,
so take these calls into common code.  Also move the end_io initialization
from queue_flush into queue_next_fseq and rename queue_flush to
init_flush_request now that it's old name doesn't apply anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-flush.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 452c552..72905f8 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -74,16 +74,11 @@ static void post_flush_end_io(struct request *rq, int error)
 	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
 }
 
-static void queue_flush(struct request_queue *q, struct request *rq,
-			rq_end_io_fn *end_io)
+static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
-	blk_rq_init(q, rq);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->cmd_flags = REQ_FLUSH;
-	rq->rq_disk = q->orig_flush_rq->rq_disk;
-	rq->end_io = end_io;
-
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	rq->rq_disk = disk;
 }
 
 static struct request *queue_next_fseq(struct request_queue *q)
@@ -91,29 +86,28 @@ static struct request *queue_next_fseq(struct request_queue *q)
 	struct request *orig_rq = q->orig_flush_rq;
 	struct request *rq = &q->flush_rq;
 
+	blk_rq_init(q, rq);
+
 	switch (blk_flush_cur_seq(q)) {
 	case QUEUE_FSEQ_PREFLUSH:
-		queue_flush(q, rq, pre_flush_end_io);
+		init_flush_request(rq, orig_rq->rq_disk);
+		rq->end_io = pre_flush_end_io;
 		break;
-
 	case QUEUE_FSEQ_DATA:
-		/* initialize proxy request, inherit FLUSH/FUA and queue it */
-		blk_rq_init(q, rq);
 		init_request_from_bio(rq, orig_rq->bio);
 		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
 		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
 		rq->end_io = flush_data_end_io;
-
-		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 		break;
-
 	case QUEUE_FSEQ_POSTFLUSH:
-		queue_flush(q, rq, post_flush_end_io);
+		init_flush_request(rq, orig_rq->rq_disk);
+		rq->end_io = post_flush_end_io;
 		break;
-
 	default:
 		BUG();
 	}
+
+	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 	return rq;
 }
 
-- 
1.7.1
