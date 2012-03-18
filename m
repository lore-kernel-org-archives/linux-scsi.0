From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] sd: Fix device removal NULL pointer dereference
Date: Sun, 18 Mar 2012 13:26:28 +0000
Message-ID: <4F65E284.2050208@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:49056 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab2CRN0b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Mar 2012 09:26:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>

Keep sdev->request_queue->queuedata even after scsi_remove_device()
finished. Functions like sd_pref_fn() may access the SCSI device
request queue after scsi_remove_device() finished and before the
final put on the SCSI device.

See also http://www.spinics.net/lists/linux-scsi/msg56254.html.

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@vger.kernel.org
---
 drivers/scsi/hosts.c      |    6 ++++++
 drivers/scsi/scsi_lib.c   |   13 +++----------
 drivers/scsi/scsi_sysfs.c |    3 ---
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..5cf3a92 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -296,6 +296,12 @@ static void scsi_host_dev_release(struct device *dev)
 		destroy_workqueue(shost->work_q);
 	q = shost->uspace_req_q;
 	if (q) {
+		/*
+		 * Note: freeing queuedata before invoking scsi_free_queue()
+		 * is safe here because no request function is associated with
+		 * uspace_req_q. See also the __scsi_alloc_queue() call in
+		 * drivers/scsi/scsi_tgt_lib.c.
+		 */
 		kfree(q->queuedata);
 		q->queuedata = NULL;
 		scsi_free_queue(q);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2c95db..c974032 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1486,7 +1486,9 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
-	if (!sdev) {
+	BUG_ON(!sdev);
+
+	if (unlikely(blk_queue_dead(q))) {
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;
@@ -1695,15 +1697,6 @@ struct request_queue *scsi_alloc_queue(struct
scsi_device *sdev)
  void scsi_free_queue(struct request_queue *q)
 {
-	unsigned long flags;
-
-	WARN_ON(q->queuedata);
-
-	/* cause scsi_request_fn() to kill all non-finished requests */
-	spin_lock_irqsave(q->queue_lock, flags);
-	q->request_fn(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	blk_cleanup_queue(q);
 }
 diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..65801e9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -971,9 +971,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-	/* cause the request function to reject all I/O requests */
-	sdev->request_queue->queuedata = NULL;
-
 	/* Freeing the queue signals to block that we're done */
 	scsi_free_queue(sdev->request_queue);
 	put_device(dev);
-- 
1.7.7


