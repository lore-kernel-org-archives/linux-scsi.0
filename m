From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/2] scsi: exports busy status via
	bdi_lld_congested
Date: Fri, 19 Sep 2008 10:49:22 -0400 (EDT)
Message-ID: <20080919.104922.97297160.k-ueda@ct.jp.nec.com>
References: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080919.104756.41628866.k-ueda@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James.Bottomley@HansenPartnership.com
Cc: j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch change scsi mid layer to export its busy status.
Not set the busy flag, when scsi can't dispatch I/Os anymore and
needs to kill I/Os.  Otherwise, request stacking drivers may hold
requests forever.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi.c     |    4 ++--
 drivers/scsi/scsi_lib.c |   23 ++++++++++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c
+++ scsi-misc-2.6/drivers/scsi/scsi_lib.c
@@ -459,17 +459,30 @@ static void scsi_init_cmd_errh(struct sc
 
 void scsi_device_unbusy(struct scsi_device *sdev)
 {
+	int host_congested;
 	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	shost->host_busy--;
+	if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
+	    shost->host_blocked || shost->host_self_blocked ||
+	    scsi_host_in_recovery(shost))
+		host_congested = 1;
+	else
+		host_congested = 0;
+
 	if (unlikely(scsi_host_in_recovery(shost) &&
 		     (shost->host_failed || shost->host_eh_scheduled)))
 		scsi_eh_wakeup(shost);
 	spin_unlock(shost->host_lock);
+
 	spin_lock(sdev->request_queue->queue_lock);
 	sdev->device_busy--;
+	if (bdi_lld_congested(&sdev->request_queue->backing_dev_info) &&
+	    !host_congested && sdev->device_busy < sdev->queue_depth &&
+	    !sdev->device_blocked)
+		clear_bdi_lld_congested(&sdev->request_queue->backing_dev_info);
 	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
 }
 
@@ -1496,9 +1509,14 @@ static void scsi_request_fn(struct reque
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
 			break;
 
+		if (!scsi_dev_queue_ready(q, sdev)) {
+			set_bdi_lld_congested(&q->backing_dev_info);
+			break;
+		}
+
 		if (unlikely(!scsi_device_online(sdev))) {
 			sdev_printk(KERN_ERR, sdev,
 				    "rejecting I/O to offline device\n");
@@ -1569,6 +1587,8 @@ static void scsi_request_fn(struct reque
 		rtn = scsi_dispatch_cmd(cmd);
 		spin_lock_irq(q->queue_lock);
 		if(rtn) {
+			set_bdi_lld_congested(&q->backing_dev_info);
+
 			/* we're refusing the command; because of
 			 * the way locks get dropped, we need to 
 			 * check here if plugging is required */
@@ -1593,6 +1613,7 @@ static void scsi_request_fn(struct reque
 	 * later time.
 	 */
 	spin_lock_irq(q->queue_lock);
+	set_bdi_lld_congested(&q->backing_dev_info);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 	if(sdev->device_busy == 0)
Index: scsi-misc-2.6/drivers/scsi/scsi.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi.c
+++ scsi-misc-2.6/drivers/scsi/scsi.c
@@ -862,8 +862,6 @@ void scsi_finish_command(struct scsi_cmn
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
 
-	scsi_device_unbusy(sdev);
-
         /*
          * Clear the flags which say that the device/host is no longer
          * capable of accepting new commands.  These are set in scsi_queue.c
@@ -875,6 +873,8 @@ void scsi_finish_command(struct scsi_cmn
         shost->host_blocked = 0;
         sdev->device_blocked = 0;
 
+	scsi_device_unbusy(sdev);
+
 	/*
 	 * If we have valid sense information, then some kind of recovery
 	 * must have taken place.  Make a note of this.
