From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Fix device removal NULL pointer dereference
Date: Sun, 19 Feb 2012 18:29:41 +0000
Message-ID: <20462111.cpi7fe2q4p@asus>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:39068 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492Ab2BSSkT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Feb 2012 13:40:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

The current approach to stop SCSI I/O during device removal is
to clear sdev->request_queue->queuedata and to let scsi_request_fn()
kill all outstanding requests once invoked with queuedata == NULL.
This approach is racy since the prep_fn in certain SCSI drivers (e.g.
sd) needs that queuedata pointer. Hence don't modify the queuedata
pointer before invoking scsi_remove_device() but test for the
QUEUE_FLAG_DEAD in scsi_request_fn() instead.

See also http://www.spinics.net/lists/linux-scsi/msg56254.html.

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: stabel@vger.kernel.org
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
@@ -1695,15 +1697,6 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 
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


