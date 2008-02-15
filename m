From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 01/13] block: don't call
 __end_that_request_first() for clone
Date: Fri, 15 Feb 2008 17:29:18 -0500 (EST)
Message-ID: <20080215.172918.18578042.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758300AbYBOW36 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 17:29:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

This patch adds a flag to indicate the request is a clone and
avoids __end_that_request_first() call for cloned requests
in blk_end_io().
So request-based dm can use blk_end_io() to complete clones
while dm doesn't want to complete the data in the clones.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 block/blk-core.c       |    2 +-
 include/linux/blkdev.h |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

Index: 2.6.25-rc1/block/blk-core.c
===================================================================
--- 2.6.25-rc1.orig/block/blk-core.c
+++ 2.6.25-rc1/block/blk-core.c
@@ -1880,7 +1880,7 @@ static int blk_end_io(struct request *rq
 	struct request_queue *q = rq->q;
 	unsigned long flags = 0UL;
 
-	if (blk_fs_request(rq) || blk_pc_request(rq)) {
+	if ((blk_fs_request(rq) || blk_pc_request(rq)) && !blk_cloned_rq(rq)) {
 		if (__end_that_request_first(rq, error, nr_bytes))
 			return 1;
 
Index: 2.6.25-rc1/include/linux/blkdev.h
===================================================================
--- 2.6.25-rc1.orig/include/linux/blkdev.h
+++ 2.6.25-rc1/include/linux/blkdev.h
@@ -115,6 +115,7 @@ enum rq_flag_bits {
 	__REQ_RW_SYNC,		/* request is sync (O_DIRECT) */
 	__REQ_ALLOCED,		/* request came from our alloc pool */
 	__REQ_RW_META,		/* metadata io request */
+	__REQ_CLONED,		/* request is a clone of another request */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -136,6 +137,7 @@ enum rq_flag_bits {
 #define REQ_RW_SYNC	(1 << __REQ_RW_SYNC)
 #define REQ_ALLOCED	(1 << __REQ_ALLOCED)
 #define REQ_RW_META	(1 << __REQ_RW_META)
+#define REQ_CLONED	(1 << __REQ_CLONED)
 
 #define BLK_MAX_CDB	16
 
@@ -500,6 +502,7 @@ enum {
 #define blk_sorted_rq(rq)	((rq)->cmd_flags & REQ_SORTED)
 #define blk_barrier_rq(rq)	((rq)->cmd_flags & REQ_HARDBARRIER)
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
+#define blk_cloned_rq(rq)	((rq)->cmd_flags & REQ_CLONED)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
 #define blk_empty_barrier(rq)	(blk_barrier_rq(rq) && blk_fs_request(rq) && !(rq)->hard_nr_sectors)
 /* rq->queuelist of dequeued request must be list_empty() */
