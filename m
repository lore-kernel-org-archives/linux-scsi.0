From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Fix a couple of comments in scsi_request_fn
Date: Wed, 15 Dec 2010 21:49:31 -0700
Message-ID: <20101216044931.GB1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37251 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752183Ab0LPEtd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2010 23:49:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


The IO request lock was killed in 2.5, and we don't take the shost lock
in scsi_dispatch_cmd any more.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5b6bbae..9e881cd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1443,7 +1443,7 @@ static void scsi_softirq_done(struct request *rq)
  *
  * Returns:     Nothing
  *
- * Lock status: IO request lock assumed to be held when called.
+ * Lock status: request queue lock held, interrupts disabled
  */
 static void scsi_request_fn(struct request_queue *q)
 {
@@ -1530,10 +1530,6 @@ static void scsi_request_fn(struct request_queue *q)
 		scsi_target(sdev)->target_busy++;
 		shost->host_busy++;
 
-		/*
-		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
-		 *		take the lock again.
-		 */
 		spin_unlock_irq(shost->host_lock);
 
 		/*
-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
