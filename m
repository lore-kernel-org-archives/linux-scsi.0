From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] add a struct request pointer to the request structure
Date: Mon, 9 Jul 2007 22:02:55 +0900
Message-ID: <20070708152621E.fujita.tomonori@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:38770 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbXGINRZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jul 2007 09:17:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, tomof@acm.org

This adds a struct request pointer to the request structure for the
second data phase (bidi for now). A request queue supporting bidi
requests sets QUEUE_FLAG_BIDI. This prevents sending bidi requests to
a non-bidi queue.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/ll_rw_blk.c      |    1 +
 include/linux/blkdev.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index c99b463..a133d51 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -256,6 +256,7 @@ static void rq_init(request_queue_t *q, struct request *rq)
 	rq->end_io = NULL;
 	rq->end_io_data = NULL;
 	rq->completion_data = NULL;
+	rq->next_rq = NULL;
 }
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1645354..7accf7e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -317,6 +317,9 @@ struct request {
 	 */
 	rq_end_io_fn *end_io;
 	void *end_io_data;
+
+	/* for bidi */
+	struct request *next_rq;
 };
 
 /*
@@ -486,6 +489,7 @@ struct request_queue
 #define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
 
 enum {
 	/*
@@ -550,6 +554,7 @@ enum {
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
+#define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-- 
1.4.4.4

