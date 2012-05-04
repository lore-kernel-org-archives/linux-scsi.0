From: Bart Van Assche <bvasbe@bartvanassche.be>
Subject: [PATCH 1/3] sd: Fix device removal NULL pointer dereference
Date: Fri, 04 May 2012 15:03:43 +0000
Message-ID: <4FA3EFCF.3020601@bartvanassche.be>
References: <4FA3EF10.3040104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay04ant.iops.be ([212.53.5.219]:54749 "EHLO
	relay04ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2EDPKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 11:10:04 -0400
In-Reply-To: <4FA3EF10.3040104@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Tomas Henzl <thenzl@redhat.com>, Mike Snitzer <snitzer@redhat.com>

Since scsi_prep_fn() may be invoked concurrently with
__scsi_remove_device(), keep the queuedata pointer in
__scsi_remove_device(). This patch fixes a kernel oops that
can be triggered by USB device removal. See also
http://www.spinics.net/lists/linux-scsi/msg56254.html.

This patch has been tested as follows:
- Verified that repeated removal (100.000 times) of a
  SCSI disk (sd) device went fine:
    $ target='id_ext=0002c9030005f34e,ioc_guid=0002c9030005f34e,dgid=fe800000000000000002c9030005f34f,pkey=ffff,service_id=0002c9030005f34e'; \
      for ((i=0;i<100000;i++)); do \
        echo "$target" >/sys/class/infiniband_srp/srp-mlx4_0-1/add_target; \
      done
- Verified that a fio data integrity test on a dm device ran
  fine. The dm device was configured to communicate via two
  different paths (iSCSI + SRP). The SRP initiator device node
  was removed and recreated repeatedly.

Reported-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/hosts.c      |    8 +++++++-
 drivers/scsi/scsi_lib.c   |   34 +++++++---------------------------
 drivers/scsi/scsi_priv.h  |    1 -
 drivers/scsi/scsi_sysfs.c |    5 +----
 4 files changed, 15 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..ff1a0be 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -296,9 +296,15 @@ static void scsi_host_dev_release(struct device *dev)
 		destroy_workqueue(shost->work_q);
 	q = shost->uspace_req_q;
 	if (q) {
+		/*
+		 * Note: freeing queuedata before invoking blk_cleanup_queue()
+		 * is safe here because no request function is associated with
+		 * uspace_req_q. See also the __scsi_alloc_queue() call in
+		 * drivers/scsi/scsi_tgt_lib.c.
+		 */
 		kfree(q->queuedata);
 		q->queuedata = NULL;
-		scsi_free_queue(q);
+		blk_cleanup_queue(q);
 	}
 
 	scsi_destroy_command_freelist(shost);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5dfd749..3d11485 100644
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
@@ -1694,20 +1688,6 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 	return q;
 }
 
-void scsi_free_queue(struct request_queue *q)
-{
-	unsigned long flags;
-
-	WARN_ON(q->queuedata);
-
-	/* cause scsi_request_fn() to kill all non-finished requests */
-	spin_lock_irqsave(q->queue_lock, flags);
-	q->request_fn(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
-	blk_cleanup_queue(q);
-}
-
 /*
  * Function:    scsi_block_requests()
  *
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index be4fa6d..fd9f57f 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -84,7 +84,6 @@ extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
-extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
 struct request_queue;
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 04c2a27..42c35ff 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -971,11 +971,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
-	/* cause the request function to reject all I/O requests */
-	sdev->request_queue->queuedata = NULL;
-
 	/* Freeing the queue signals to block that we're done */
-	scsi_free_queue(sdev->request_queue);
+	blk_cleanup_queue(sdev->request_queue);
 	put_device(dev);
 }
 
-- 
1.7.7

