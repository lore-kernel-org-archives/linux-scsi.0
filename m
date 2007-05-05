From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/2] add linked request support
Date: Sat, 05 May 2007 18:02:31 +0900
Message-ID: <200705050902.l4592aCE030982@mbox.iij4u.or.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:58837 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423161AbXEEJEM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 May 2007 05:04:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, bhalevy@panasas.com, hch@infradead.org, akpm@linux-foundation.org, michaelc@cs.wisc.edu

This adds a pointer, next_rq, to the request structure for the second
data phase (e.g. for bidi).

We need bidi support for block pc requests, special requests, etc so
instead of introducing REQ_TYPE_BIDI, a bidi requests simply set a
req->next_rq pointer. linked request support can be used for other
stuff REQ_BIDI might be nice for the future.

A bidi request uses two request structures (one in request and one out
request). The in request is linked and the out request is en-queued.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/ll_rw_blk.c      |    1 +
 include/linux/blkdev.h |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 123003a..9b799ee 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -256,6 +256,7 @@ static void rq_init(request_queue_t *q,
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
+	rq->next_rq = NULL;
 }
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a686eab..5234d17 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -314,6 +314,9 @@ struct request {
 	 */
 	rq_end_io_fn *end_io;
 	void *end_io_data;
+
+	/* for bidi */
+	struct request *next_rq;
 };
 
 /*
@@ -543,6 +546,7 @@ #define blk_pm_request(rq)	\
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
+#define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-- 
1.4.3.2

