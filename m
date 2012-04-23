From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5] sd: Fix device removal NULL pointer dereference
Date: Mon, 23 Apr 2012 18:18:21 +0000
Message-ID: <4F959CED.8000200@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay01ant.iops.be ([212.53.4.34]:40711 "EHLO
	relay01ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2DWSS2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2012 14:18:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Since scsi_prep_fn() may be invoked concurrently with
scsi_remove_device(), keep the queuedata pointer in
scsi_remove_device(). This patch fixes a kernel oops that
can be triggered by USB device removal. See also
http://www.spinics.net/lists/linux-scsi/msg56254.html.

This patch has been tested as follows:
- Verified that repeated removal (100.000 times) of a
  SCSI disk (sd) device went fine:
    $ time for ((i=0;i<100000;i++)); do \
    echo 'id_ext=0002c9030005f34e,ioc_guid=0002c9030005f34e,dgid=fe800000000000000002c9030005f34f,pkey=ffff,service_id=0002c9030005f34e' \
    >/sys/class/infiniband_srp/srp-mlx4_0-1/add_target; \
    done
    real    28m49.672s
    user    0m4.000s
    sys     3m25.950s
- Verified that a fio data integrity test on a dm device ran
  fine. The dm device was configured to communicate via two
  different paths (iSCSI + SRP). The SRP initiator device node
  was removed and recreated repeatedly.

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@kernel.org>
---


Changes compared to v4:
- Mentioned dm test in patch description.
- Added stable to CC list.


 drivers/scsi/hosts.c      |    6 ++++++
 drivers/scsi/scsi_lib.c   |   29 +++++++----------------------
 drivers/scsi/scsi_sysfs.c |    3 ---
 3 files changed, 13 insertions(+), 25 deletions(-)

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
index ead6405..4aa41d1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -406,10 +406,7 @@ static void scsi_run_queue(struct request_queue *q)
 	LIST_HEAD(starved_list);
 	unsigned long flags;
 
-	/* if the device is dead, sdev will be NULL, so no queue to run */
-	if (!sdev)
-		return;
-
+	BUG_ON(!sdev);
 	shost = sdev->host;
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
@@ -1370,9 +1367,9 @@ static inline int scsi_host_queue_ready(struct request_queue *q,
  * may be changed after request stacking drivers call the function,
  * regardless of taking lock or not.
  *
- * When scsi can't dispatch I/Os anymore and needs to kill I/Os
- * (e.g. !sdev), scsi needs to return 'not busy'.
- * Otherwise, request stacking drivers may hold requests forever.
+ * When scsi can't dispatch I/Os anymore and needs to kill I/Os scsi
+ * needs to return 'not busy'. Otherwise, request stacking drivers
+ * may hold requests forever.
  */
 static int scsi_lld_busy(struct request_queue *q)
 {
@@ -1380,9 +1377,10 @@ static int scsi_lld_busy(struct request_queue *q)
 	struct Scsi_Host *shost;
 	struct scsi_target *starget;
 
-	if (!sdev)
+	if (blk_queue_dead(q))
 		return 0;
 
+	BUG_ON(!sdev);
 	shost = sdev->host;
 	starget = scsi_target(sdev);
 
@@ -1487,11 +1485,7 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if (!sdev) {
-		while ((req = blk_peek_request(q)) != NULL)
-			scsi_kill_request(req, q);
-		return;
-	}
+	BUG_ON(!sdev);
 
 	if(!get_device(&sdev->sdev_gendev))
 		/* We must be tearing the block queue down already */
@@ -1696,15 +1690,6 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 
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

