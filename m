From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Make scsi_free_queue() kill pending SCSI commands
Date: Fri, 23 Sep 2011 19:48:18 +0200
Message-ID: <201109231948.18850.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:46785 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab1IWSTO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2011 14:19:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>

Make sure that SCSI device removal via scsi_remove_host() does finish
all pending SCSI commands. Currently that's not the case and hence
removal of a SCSI host during I/O can cause a deadlock. See also
"blkdev_issue_discard() hangs forever if underlying storage device is
removed" (http://bugzilla.kernel.org/show_bug.cgi?id=40472). See also
http://lkml.org/lkml/2011/8/27/6.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: <stable@kernel.org>
---
 drivers/scsi/hosts.c    |    9 ++++++---
 drivers/scsi/scsi_lib.c |    9 +++++++++
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 4f7a582..351dc0b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -286,6 +286,7 @@ static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
 	struct device *parent = dev->parent;
+	struct request_queue *q;
 
 	scsi_proc_hostdir_rm(shost->hostt);
 
@@ -293,9 +294,11 @@ static void scsi_host_dev_release(struct device *dev)
 		kthread_stop(shost->ehandler);
 	if (shost->work_q)
 		destroy_workqueue(shost->work_q);
-	if (shost->uspace_req_q) {
-		kfree(shost->uspace_req_q->queuedata);
-		scsi_free_queue(shost->uspace_req_q);
+	q = shost->uspace_req_q;
+	if (q) {
+		kfree(q->queuedata);
+		q->queuedata = NULL;
+		scsi_free_queue(q);
 	}
 
 	scsi_destroy_command_freelist(shost);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc3f168..b4d43ae 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1698,6 +1698,15 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 
 void scsi_free_queue(struct request_queue *q)
 {
+	unsigned long flags;
+
+	WARN_ON(q->queuedata);
+
+	/* cause scsi_request_fn() to kill all non-finished requests */
+	spin_lock_irqsave(q->queue_lock, flags);
+	q->request_fn(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
 	blk_cleanup_queue(q);
 }
 
-- 
1.7.3.4

