From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 6/9] blk: Add request atomic flag for abort
Date: Mon,  3 May 2010 20:37:05 -0700
Message-ID: <1272944228-30511-7-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39581 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290Ab0EDDhs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 May 2010 23:37:48 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e9.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id o443Ov0b002344
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:24:57 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o443blNi175340
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id o443bkIv019046
	for <linux-scsi@vger.kernel.org>; Mon, 3 May 2010 23:37:46 -0400
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com

Add atomic flag for a request to indicate that it has marked as aborted.
Provide functions to mark and test the aborted flag.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axobe <jens.axboe@oracle.com>
---
 block/blk-timeout.c    |    6 ++++++
 block/blk.h            |   14 ++++++++++++++
 include/linux/blkdev.h |    1 +
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 89fbe0a..ad45b44 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -155,6 +155,12 @@ void blk_abort_request(struct request *req)
 }
 EXPORT_SYMBOL_GPL(blk_abort_request);
 
+int blk_request_aborted(struct request *req)
+{
+	return blk_test_rq_aborted(req);
+}
+EXPORT_SYMBOL_GPL(blk_request_aborted);
+
 /**
  * blk_add_timer - Start timeout timer for a single request
  * @req:	request that is about to start running.
diff --git a/block/blk.h b/block/blk.h
index 5ee3d7e..165262a 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -30,6 +30,7 @@ void __generic_unplug_device(struct request_queue *);
  */
 enum rq_atomic_flags {
 	REQ_ATOM_COMPLETE = 0,
+	REQ_ATOM_ABORT = 1,
 };
 
 /*
@@ -47,6 +48,19 @@ static inline void blk_clear_rq_complete(struct request *rq)
 }
 
 /*
+ * Mark and test a request for aborted.
+ */
+static inline int blk_mark_rq_aborted(struct request *rq)
+{
+	return test_and_set_bit(REQ_ATOM_ABORT, &rq->atomic_flags);
+}
+
+static inline int blk_test_rq_aborted(struct request *rq)
+{
+	return test_bit(REQ_ATOM_ABORT, &rq->atomic_flags);
+}
+
+/*
  * Internal elevator interface
  */
 #define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2818e80..7636e58 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -912,6 +912,7 @@ extern void blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_abort_queue(struct request_queue *);
+extern int blk_request_aborted(struct request *);
 
 /*
  * Access functions for manipulating queue properties
-- 
1.6.6.1

