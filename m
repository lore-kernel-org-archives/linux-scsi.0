From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 06/13] bsg: Remove unused function bsg_goose_queue()
Date: Wed, 28 Nov 2012 13:47:36 +0100
Message-ID: <50B607E8.20800@acm.org>
References: <50B60619.4080406@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46499 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754829Ab2K1Mrh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Nov 2012 07:47:37 -0500
In-Reply-To: <50B60619.4080406@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, Hannes Reinecke <hare@suse.de>

The function bsg_goose_queue() does not have any in-tree callers,
so let's remove it.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
---
 block/bsg-lib.c         |   13 -------------
 include/linux/bsg-lib.h |    1 -
 2 files changed, 14 deletions(-)

diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index deee61f..650f427 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -151,19 +151,6 @@ failjob_rls_job:
 	return -ENOMEM;
 }
 
-/*
- * bsg_goose_queue - restart queue in case it was stopped
- * @q: request q to be restarted
- */
-void bsg_goose_queue(struct request_queue *q)
-{
-	if (!q)
-		return;
-
-	blk_run_queue_async(q);
-}
-EXPORT_SYMBOL_GPL(bsg_goose_queue);
-
 /**
  * bsg_request_fn - generic handler for bsg requests
  * @q: request queue to manage
diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
index 4d0fb3d..a226652 100644
--- a/include/linux/bsg-lib.h
+++ b/include/linux/bsg-lib.h
@@ -67,6 +67,5 @@ void bsg_job_done(struct bsg_job *job, int result,
 int bsg_setup_queue(struct device *dev, struct request_queue *q, char *name,
 		    bsg_job_fn *job_fn, int dd_job_size);
 void bsg_request_fn(struct request_queue *q);
-void bsg_goose_queue(struct request_queue *q);
 
 #endif
-- 
1.7.10.4


