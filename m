From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 04/13] block: export blk_end_io
Date: Fri, 15 Feb 2008 17:30:25 -0500 (EST)
Message-ID: <20080215.173025.105430617.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762215AbYBOWaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:30:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch exports blk_end_io() so that request-based dm can use it
to complete their clone.

Request-based dm can't use blk_end_request interfaces for their clone,
since their callback is called again.
So another request completion interface which has no stacking hook
is needed.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c       |    6 +++---
 include/linux/blkdev.h |    3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

Index: 2.6.25-rc1/block/blk-core.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-core.c
+++ 2.6.25-rc1/block/blk-core.c
@@ -1938,9 +1938,8 @@ EXPORT_SYMBOL(end_request);
  *     0 - we are done with this request
  *     1 - this request is not freed yet, it still has pending buffers.
  **/
-static int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
-		      unsigned int bidi_bytes,
-		      int (drv_callback)(struct request *))
+int blk_end_io(struct request *rq, int error, unsigned int nr_bytes,
+	       unsigned int bidi_bytes, int (drv_callback)(struct request *))
 {
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
@@ -1967,6 +1966,7 @@ static int blk_end_io(struct request *rq
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(blk_end_io);
 
 /**
  * blk_end_request - Helper function for drivers to complete the request.
Index: 2.6.25-rc1/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc1.orig/include/linux/blkdev.h
+++ 2.6.25-rc1/include/linux/blkdev.h
@@ -701,6 +701,9 @@ extern int __blk_end_request(struct requ
 				unsigned int nr_bytes);
 extern int blk_end_bidi_request(struct request *rq, int error,
 				unsigned int nr_bytes, unsigned int bidi_bytes);
+extern int blk_end_io(struct request *rq, int error,
+		      unsigned int nr_bytes, unsigned int bidi_bytes,
+		      int (drv_callback)(struct request *));
 extern void blk_async_end_request(struct request *rq, int error);
 extern void end_request(struct request *, int);
 extern void end_queued_request(struct request *, int);
