From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 3/9] blk: Add a unprep_rq_fn
Date: Mon,  3 May 2010 20:37:02 -0700
Message-ID: <1272944228-30511-4-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39577 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0EDDhm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:42 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443OphH002299
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:24:51 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443bfsl169688
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:41 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443beDM018892
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:41 -0400
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Add a unprep_rq_fn to the block layer allowing a function to be called if
set to release resources if a request is being unprepared at the block
level.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axobe <jens.axboe@oracle.com>
---
 block/blk-settings.c   |   17 +++++++++++++++++
 include/linux/blkdev.h |    3 +++
 2 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d9a9db5..1a33494 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -36,6 +36,23 @@ void blk_queue_prep_rq(struct request_queue *q, prep_rq_fn *pfn)
 EXPORT_SYMBOL(blk_queue_prep_rq);
 
 /**
+ * blk_queue_unprep_rq - set a unprepare_request function for queue
+ * @q:		queue
+ * @pfn:	unprepare_request function
+ *
+ * It's possible for a queue to register a unprepare_request callback which
+ * may be invoked to unprepare a request that is on a queue. The goal of
+ * the function is to unprepare a request for I/O, it can be used to
+ * release a cdb from the request for instance.
+ *
+ */
+void blk_queue_unprep_rq(struct request_queue *q, unprep_rq_fn *unpfn)
+{
+	q->unprep_rq_fn = unpfn;
+}
+EXPORT_SYMBOL(blk_queue_unprep_rq);
+
+/**
  * blk_queue_merge_bvec - set a merge_bvec function for queue
  * @q:		queue
  * @mbfn:	merge_bvec_fn
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebd22db..2818e80 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -259,6 +259,7 @@ struct request_pm_state
 typedef void (request_fn_proc) (struct request_queue *q);
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
+typedef void (unprep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
 
 struct bio_vec;
@@ -341,6 +342,7 @@ struct request_queue
 	request_fn_proc		*request_fn;
 	make_request_fn		*make_request_fn;
 	prep_rq_fn		*prep_rq_fn;
+	unprep_rq_fn		*unprep_rq_fn;
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
 	prepare_flush_fn	*prepare_flush_fn;
@@ -968,6 +970,7 @@ extern int blk_queue_dma_drain(struct request_queue *q,
 extern void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_prep_rq(struct request_queue *, prep_rq_fn *pfn);
+extern void blk_queue_unprep_rq(struct request_queue *, unprep_rq_fn *unpfn);
 extern void blk_queue_merge_bvec(struct request_queue *, merge_bvec_fn *);
 extern void blk_queue_dma_alignment(struct request_queue *, int);
 extern void blk_queue_update_dma_alignment(struct request_queue *, int);
-- 
1.6.6.1

