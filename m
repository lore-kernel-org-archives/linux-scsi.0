From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/4] add a struct request pointer to the request structure
Date: Sat, 9 Jun 2007 00:12:00 +0900 (JST)
Message-ID: <20070608132945F.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:58285 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935079AbXFHPM3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jun 2007 11:12:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org

This adds a struct request pointer to the request structure for the
second data phase (e.g. for bidi). We set QUEUE_FLAG_BIDI for a
request queue to support bidi requests.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/ll_rw_blk.c      |    1 +
 include/linux/blkdev.h |    5 +++++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 5873861..8dba61d 100644
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
index 4db7bcc..b3b87ee 100644
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
@@ -486,6 +489,7 @@ #define QUEUE_FLAG_DEAD		5	/* queue bein
 #define QUEUE_FLAG_REENTER	6	/* Re-entrancy avoidance */
 #define QUEUE_FLAG_PLUGGED	7	/* queue is plugged */
 #define QUEUE_FLAG_ELVSWITCH	8	/* don't use elevator, just do FIFO */
+#define QUEUE_FLAG_BIDI		9	/* queue supports bidi requests */
 
 enum {
 	/*
@@ -550,6 +554,7 @@ #define blk_pm_request(rq)	\
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
+#define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-- 
1.4.3.2

