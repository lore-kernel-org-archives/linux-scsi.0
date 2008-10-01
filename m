From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 5/5] block: remove end_{queued|dequeued}_request()
Date: Wed, 01 Oct 2008 10:14:46 -0400 (EDT)
Message-ID: <20081001.101446.112628304.k-ueda@ct.jp.nec.com>
References: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42704 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbYJAORp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2008 10:17:45 -0400
In-Reply-To: <20081001.100942.74754500.k-ueda@ct.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: rusty@rustcorp.com.au, oakad@yahoo.com, adrian@mcmen.demon.co.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch removes end_queued_request() and end_dequeued_request(),
which are no longer used.

As a results, users of __end_request() became only end_request().
So the actual code in __end_request() is moved to end_request()
and __end_request() is removed.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-core.c       |   58 +++++--------------------------------------------
 include/linux/blkdev.h |    2 -
 2 files changed, 7 insertions(+), 53 deletions(-)

Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c
+++ linux-2.6-block/block/blk-core.c
@@ -1788,17 +1788,6 @@ static void end_that_request_last(struct
 	}
 }
 
-static inline void __end_request(struct request *rq, int uptodate,
-				 unsigned int nr_bytes)
-{
-	int error = 0;
-
-	if (uptodate <= 0)
-		error = uptodate ? uptodate : -EIO;
-
-	__blk_end_request(rq, error, nr_bytes);
-}
-
 /**
  * blk_rq_bytes - Returns bytes left to complete in the entire request
  * @rq: the request being processed
@@ -1829,41 +1818,6 @@ unsigned int blk_rq_cur_bytes(struct req
 EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
 
 /**
- * end_queued_request - end all I/O on a queued request
- * @rq:		the request being processed
- * @uptodate:	error value or %0/%1 uptodate flag
- *
- * Description:
- *     Ends all I/O on a request, and removes it from the block layer queues.
- *     Not suitable for normal I/O completion, unless the driver still has
- *     the request attached to the block layer.
- *
- **/
-void end_queued_request(struct request *rq, int uptodate)
-{
-	__end_request(rq, uptodate, blk_rq_bytes(rq));
-}
-EXPORT_SYMBOL(end_queued_request);
-
-/**
- * end_dequeued_request - end all I/O on a dequeued request
- * @rq:		the request being processed
- * @uptodate:	error value or %0/%1 uptodate flag
- *
- * Description:
- *     Ends all I/O on a request. The request must already have been
- *     dequeued using blkdev_dequeue_request(), as is normally the case
- *     for most drivers.
- *
- **/
-void end_dequeued_request(struct request *rq, int uptodate)
-{
-	__end_request(rq, uptodate, blk_rq_bytes(rq));
-}
-EXPORT_SYMBOL(end_dequeued_request);
-
-
-/**
  * end_request - end I/O on the current segment of the request
  * @req:	the request being processed
  * @uptodate:	error value or %0/%1 uptodate flag
@@ -1877,14 +1831,16 @@ EXPORT_SYMBOL(end_dequeued_request);
  *     they have a residual value to account for. For that case this function
  *     isn't really useful, unless the residual just happens to be the
  *     full current segment. In other words, don't use this function in new
- *     code. Use blk_end_request() or __blk_end_request() to end partial parts
- *     of a request, or end_dequeued_request() and end_queued_request() to
- *     completely end IO on a dequeued/queued request.
- *
+ *     code. Use blk_end_request() or __blk_end_request() to end a request.
  **/
 void end_request(struct request *req, int uptodate)
 {
-	__end_request(req, uptodate, req->hard_cur_sectors << 9);
+	int error = 0;
+
+	if (uptodate <= 0)
+		error = uptodate ? uptodate : -EIO;
+
+	__blk_end_request(req, error, req->hard_cur_sectors << 9);
 }
 EXPORT_SYMBOL(end_request);
 
Index: linux-2.6-block/include/linux/blkdev.h
===================================================================
--- linux-2.6-block.orig/include/linux/blkdev.h
+++ linux-2.6-block/include/linux/blkdev.h
@@ -790,8 +790,6 @@ extern int __blk_end_request(struct requ
 extern int blk_end_bidi_request(struct request *rq, int error,
 				unsigned int nr_bytes, unsigned int bidi_bytes);
 extern void end_request(struct request *, int);
-extern void end_queued_request(struct request *, int);
-extern void end_dequeued_request(struct request *, int);
 extern int blk_end_request_callback(struct request *rq, int error,
 				unsigned int nr_bytes,
 				int (drv_callback)(struct request *));
