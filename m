From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 03/27] blk_end_request: changing block layer core
	(take 2)
Date: Tue, 11 Sep 2007 14:56:58 -0400 (EDT)
Message-ID: <20070911.145658.112978437.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts core parts of block layer to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/ll_rw_blk.c |   15 +++++----------
 1 files changed, 5 insertions(+), 10 deletions(-)

diff -rupN 02-rq-size-macro/block/ll_rw_blk.c 03-blkcore-caller-change/block/ll_rw_blk.c
--- 02-rq-size-macro/block/ll_rw_blk.c	2007-09-10 17:42:56.000000000 -0400
+++ 03-blkcore-caller-change/block/ll_rw_blk.c	2007-09-10 17:57:59.000000000 -0400
@@ -365,8 +365,8 @@ void blk_ordered_complete_seq(struct req
 	q->ordseq = 0;
 	rq = q->orig_bar_rq;
 
-	end_that_request_first(rq, uptodate, rq->hard_nr_sectors);
-	end_that_request_last(rq, uptodate);
+	if (__blk_end_request(rq, uptodate, blk_rq_size(rq)))
+		BUG();
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -484,9 +484,8 @@ int blk_do_ordered(struct request_queue 
 			 * ORDERED_NONE while this request is on it.
 			 */
 			blkdev_dequeue_request(rq);
-			end_that_request_first(rq, -EOPNOTSUPP,
-					       rq->hard_nr_sectors);
-			end_that_request_last(rq, -EOPNOTSUPP);
+			if (__blk_end_request(rq, -EOPNOTSUPP, blk_rq_size(rq)))
+				BUG();
 			*rqp = NULL;
 			return 0;
 		}
@@ -3720,11 +3719,7 @@ EXPORT_SYMBOL(end_that_request_last);
 static inline void __end_request(struct request *rq, int uptodate,
 				 unsigned int nr_bytes)
 {
-	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
-		blkdev_dequeue_request(rq);
-		add_disk_randomness(rq->rq_disk);
-		end_that_request_last(rq, uptodate);
-	}
+	__blk_end_request(rq, uptodate, nr_bytes);
 }
 
 /**
