From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 4/5] block: change elevator to use __blk_end_request()
Date: Wed, 01 Oct 2008 10:13:44 -0400 (EDT)
Message-ID: <20081001.101344.78703914.k-ueda@ct.jp.nec.com>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753965AbYJAOQ1@vger.kernel.org>
In-Reply-To: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
List-Id: linux-scsi@vger.kernel.org

This patch converts elevator to use __blk_end_request() directly
so that end_{queued|dequeued}_request() can be removed.
Related 'uptodate' arguments is converted to 'error'.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/elevator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-block/block/elevator.c
===================================================================
--- linux-2.6-block.orig/block/elevator.c
+++ linux-2.6-block/block/elevator.c
@@ -754,7 +754,7 @@ struct request *elv_next_request(struct 
 		 * not ever see it.
 		 */
 		if (blk_empty_barrier(rq)) {
-			end_queued_request(rq, 1);
+			__blk_end_request(rq, 0, blk_rq_bytes(rq));
 			continue;
 		}
 		if (!(rq->cmd_flags & REQ_STARTED)) {
@@ -825,7 +825,7 @@ struct request *elv_next_request(struct 
 			break;
 		} else if (ret == BLKPREP_KILL) {
 			rq->cmd_flags |= REQ_QUIET;
-			end_queued_request(rq, 0);
+			__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
 		} else {
 			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
 			break;
@@ -922,7 +922,7 @@ void elv_abort_queue(struct request_queu
 		rq = list_entry_rq(q->queue_head.next);
 		rq->cmd_flags |= REQ_QUIET;
 		blk_add_trace_rq(q, rq, BLK_TA_ABORT);
-		end_queued_request(rq, 0);
+		__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
 	}
 }
 EXPORT_SYMBOL(elv_abort_queue);
