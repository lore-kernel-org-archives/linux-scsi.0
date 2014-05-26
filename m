From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/3] block: Introduce blk_rq_completed()
Date: Mon, 26 May 2014 17:15:03 +0200
Message-ID: <53835A77.1090708@acm.org>
References: <538359DB.9080601@acm.org> <53835A52.9010306@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:46934 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaEZPPD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 May 2014 11:15:03 -0400
In-Reply-To: <53835A52.9010306@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Joe Lawrence <jdl1291@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Make it possible to test the REQ_ATOM_COMPLETE bit from outside the
block layer core.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@fb.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Joe Lawrence <joe.lawrence@stratus.com>
---
 block/blk-softirq.c    | 13 +++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 53b1737..fc7d160 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -172,6 +172,19 @@ void blk_complete_request(struct request *req)
 }
 EXPORT_SYMBOL(blk_complete_request);
 
+/**
+ * blk_rq_completed - whether or not a request has been completed
+ *
+ * Intended for debugging purposes only. Any completion handler code should go
+ * into the softirq_done_fn() and/or in the rq_timed_out_fn() request_queue
+ * callback functions.
+ */
+bool blk_rq_completed(struct request *rq)
+{
+	return test_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
+}
+EXPORT_SYMBOL(blk_rq_completed);
+
 static __init int blk_softirq_init(void)
 {
 	int i;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0d84981..a621bc5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -952,6 +952,7 @@ extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_unprep_request(struct request *);
+extern bool blk_rq_completed(struct request *);
 
 /*
  * Access functions for manipulating queue properties
-- 
1.8.4.5

