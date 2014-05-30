From: Liu Ping Fan <kernelfans@gmail.com>
Subject: [RFC 4/9] blk: change the prototype of blk_complete_request()
Date: Fri, 30 May 2014 16:15:42 +0800
Message-ID: <1401437747-2097-5-git-send-email-pingfank@linux.vnet.ibm.com>
References: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yk0-f182.google.com ([209.85.160.182]:56050 "EHLO
	mail-yk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbaE3INJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 May 2014 04:13:09 -0400
Received: by mail-yk0-f182.google.com with SMTP id 9so1244025ykp.27
        for <linux-scsi@vger.kernel.org>; Fri, 30 May 2014 01:13:08 -0700 (PDT)
In-Reply-To: <1401437747-2097-1-git-send-email-pingfank@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Jens Axboe <axboe@kernel.dk>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Jeff Moyer <jmoyer@redhat.com>

This patch is for the incoming refcnt on scsi_cmnd. It can help the
scsi_done handler to run against the abort handler in parallel.

In the following patch, if a thread takes the REQ_ATOM_COMPLETE,
then it can drop the ref when end of this request. But if it fails
to take REQ_ATOM_COMPLETE, it should drop the ref immediately.
Here, using the return of blk_complete_request() to notice its caller.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 block/blk-softirq.c    | 13 ++++++++++---
 include/linux/blkdev.h |  2 +-
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/blk-softirq.c b/block/blk-softirq.c
index 467c8de..6a841ae 100644
--- a/block/blk-softirq.c
+++ b/block/blk-softirq.c
@@ -156,6 +156,9 @@ do_local:
  * blk_complete_request - end I/O on a request
  * @req:      the request being processed
  *
+ * return -1 if fail to call __blk_complete_request which implies another
+ * routine is handling this req
+ *
  * Description:
  *     Ends all I/O on a request. It does not handle partial completions,
  *     unless the driver actually implements this in its completion callback
@@ -163,12 +166,16 @@ do_local:
  *     through a softirq handler. The user must have registered a completion
  *     callback through blk_queue_softirq_done().
  **/
-void blk_complete_request(struct request *req)
+int blk_complete_request(struct request *req)
 {
+	int ret = -1;
 	if (unlikely(blk_should_fake_timeout(req->q)))
-		return;
-	if (!blk_mark_rq_complete(req))
+		return ret;
+	if (!blk_mark_rq_complete(req)) {
 		__blk_complete_request(req);
+		ret = 0;
+	}
+	return ret;
 }
 EXPORT_SYMBOL(blk_complete_request);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ee7ddcd..23deadb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -945,7 +945,7 @@ extern void __blk_end_request_all(struct request *rq, int error);
 extern bool __blk_end_request_cur(struct request *rq, int error);
 extern bool __blk_end_request_err(struct request *rq, int error);
 
-extern void blk_complete_request(struct request *);
+extern int blk_complete_request(struct request *);
 extern void __blk_complete_request(struct request *);
 extern void blk_abort_request(struct request *);
 extern void blk_unprep_request(struct request *);
-- 
1.8.1.4

