From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/41] block: make sure FSEQ_DATA request has the
	same rq_disk as the original
Date: Fri,  3 Sep 2010 12:29:30 +0200
Message-ID: <1283509796-1510-16-git-send-email-tj@kernel.org>
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

rq->rq_disk and bio->bi_bdev->bd_disk may differ if a request has
passed through remapping drivers.  FSEQ_DATA request incorrectly
followed bio->bi_bdev->bd_disk ending up being issued w/ mismatching
rq_disk.  Make it follow orig_rq->rq_disk.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Tested-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
 block/blk-flush.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index cb4c844..7d1fc98 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -111,6 +111,13 @@ static struct request *queue_next_fseq(struct request_queue *q)
 		break;
 	case QUEUE_FSEQ_DATA:
 		init_request_from_bio(rq, orig_rq->bio);
+		/*
+		 * orig_rq->rq_disk may be different from
+		 * bio->bi_bdev->bd_disk if orig_rq got here through
+		 * remapping drivers.  Make sure rq->rq_disk points
+		 * to the same one as orig_rq.
+		 */
+		rq->rq_disk = orig_rq->rq_disk;
 		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
 		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
 		rq->end_io = flush_data_end_io;
-- 
1.7.1
