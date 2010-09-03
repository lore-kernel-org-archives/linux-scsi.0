From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/41] block: kick queue after sequencing
	REQ_FLUSH/FUA
Date: Fri,  3 Sep 2010 12:29:29 +0200
Message-ID: <1283509796-1510-15-git-send-email-tj@kernel.org>
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

While completing a request from a REQ_FLUSH/FUA sequence, another
request can be pushed to the request queue.  If a driver tests
elv_queue_empty() before completing a request and runs the queue again
only if the queue wasn't empty, this may lead to hang.  Please note
that most drivers either kick the queue unconditionally or test queue
emptiness after completing the current request and don't have this
problem.

This patch removes this possibility by making REQ_FLUSH/FUA sequence
code kick the queue if the queue was empty before completing a request
from REQ_FLUSH/FUA sequence.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-flush.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index f357f1f..cb4c844 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -56,22 +56,38 @@ static struct request *blk_flush_complete_seq(struct request_queue *q,
 	return next_rq;
 }
 
+static void blk_flush_complete_seq_end_io(struct request_queue *q,
+					  unsigned seq, int error)
+{
+	bool was_empty = elv_queue_empty(q);
+	struct request *next_rq;
+
+	next_rq = blk_flush_complete_seq(q, seq, error);
+
+	/*
+	 * Moving a request silently to empty queue_head may stall the
+	 * queue.  Kick the queue in those cases.
+	 */
+	if (was_empty && next_rq)
+		__blk_run_queue(q);
+}
+
 static void pre_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_PREFLUSH, error);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_DATA, error);
 }
 
 static void post_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
 }
 
 static void init_flush_request(struct request *rq, struct gendisk *disk)
-- 
1.7.1
