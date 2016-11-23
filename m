From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/2] SRP transport: Move queuecommand() wait code to SCSI core
Date: Tue, 22 Nov 2016 16:17:13 -0800
Message-ID: <649cb037-3196-df4d-0d31-47f040ce44a2@sandisk.com>
References: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <39d8cb23-0406-e8c3-6e3a-a467ebe41470-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Additionally, rename srp_wait_for_queuecommand() into
scsi_wait_for_queuecommand() and add a comment about the
queuecommand() call from scsi_send_eh_cmnd().

Note: this patch changes scsi_internal_device_block from a function
that did not sleep into a function that may sleep. This is fine for
all callers of this function:
* scsi_internal_device_block() is called from the mpt3sas device while
  that driver holds the ioc->dm_cmds.mutex. This means that the mpt3sas
  driver calls this function from thread context.
* scsi_target_block() is called by __iscsi_block_session() from
  kernel thread context and with IRQs enabled.
* The SRP transport code also calls scsi_target_block() from kernel
  thread context while sleeping is allowed.
* The snic driver also calls scsi_target_block() from a context from
  which sleeping is allowed. The scsi_target_block() call namely occurs
  immediately after a scsi_flush_work() call.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Reviewed-by: Martin K. Petersen <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/scsi_lib.c           | 41 +++++++++++++++++++++++++++++++++++++--
 drivers/scsi/scsi_transport_srp.c | 41 ++++++---------------------------------
 2 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b4f682c..84c9e61 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2721,6 +2721,39 @@ void sdev_evt_send_simple(struct scsi_device *sdev,
 EXPORT_SYMBOL_GPL(sdev_evt_send_simple);
 
 /**
+ * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
+ * @sdev: SCSI device to count the number of scsi_request_fn() callers for.
+ */
+static int scsi_request_fn_active(struct scsi_device *sdev)
+{
+	struct request_queue *q = sdev->request_queue;
+	int request_fn_active;
+
+	WARN_ON_ONCE(sdev->host->use_blk_mq);
+
+	spin_lock_irq(q->queue_lock);
+	request_fn_active = q->request_fn_active;
+	spin_unlock_irq(q->queue_lock);
+
+	return request_fn_active;
+}
+
+/**
+ * scsi_wait_for_queuecommand() - wait for ongoing queuecommand() calls
+ * @shost: SCSI host pointer.
+ *
+ * Wait until the ongoing shost->hostt->queuecommand() calls that are
+ * invoked from scsi_request_fn() have finished.
+ */
+static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
+{
+	WARN_ON_ONCE(sdev->host->use_blk_mq);
+
+	while (scsi_request_fn_active(sdev))
+		msleep(20);
+}
+
+/**
  *	scsi_device_quiesce - Block user issued commands.
  *	@sdev:	scsi device to quiesce.
  *
@@ -2804,8 +2837,7 @@ EXPORT_SYMBOL(scsi_target_resume);
  * @sdev:	device to block
  *
  * Block request made by scsi lld's to temporarily stop all
- * scsi commands on the specified device.  Called from interrupt
- * or normal process context.
+ * scsi commands on the specified device. May sleep.
  *
  * Returns zero if successful or error if not
  *
@@ -2814,6 +2846,10 @@ EXPORT_SYMBOL(scsi_target_resume);
  *	(which must be a legal transition).  When the device is in this
  *	state, all commands are deferred until the scsi lld reenables
  *	the device with scsi_device_unblock or device_block_tmo fires.
+ *
+ * To do: avoid that scsi_send_eh_cmnd() calls queuecommand() after
+ * scsi_internal_device_block() has blocked a SCSI device and also
+ * remove the rport mutex lock and unlock calls from srp_queuecommand().
  */
 int
 scsi_internal_device_block(struct scsi_device *sdev)
@@ -2841,6 +2877,7 @@ scsi_internal_device_block(struct scsi_device *sdev)
 		spin_lock_irqsave(q->queue_lock, flags);
 		blk_stop_queue(q);
 		spin_unlock_irqrestore(q->queue_lock, flags);
+		scsi_wait_for_queuecommand(sdev);
 	}
 
 	return 0;
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index e3cd3ec..b48328a 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -24,7 +24,6 @@
 #include <linux/err.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -402,36 +401,6 @@ static void srp_reconnect_work(struct work_struct *work)
 	}
 }
 
-/**
- * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
- * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
- *
- * To do: add support for scsi-mq in this function.
- */
-static int scsi_request_fn_active(struct Scsi_Host *shost)
-{
-	struct scsi_device *sdev;
-	struct request_queue *q;
-	int request_fn_active = 0;
-
-	shost_for_each_device(sdev, shost) {
-		q = sdev->request_queue;
-
-		spin_lock_irq(q->queue_lock);
-		request_fn_active += q->request_fn_active;
-		spin_unlock_irq(q->queue_lock);
-	}
-
-	return request_fn_active;
-}
-
-/* Wait until ongoing shost->hostt->queuecommand() calls have finished. */
-static void srp_wait_for_queuecommand(struct Scsi_Host *shost)
-{
-	while (scsi_request_fn_active(shost))
-		msleep(20);
-}
-
 static void __rport_fail_io_fast(struct srp_rport *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
@@ -441,14 +410,17 @@ static void __rport_fail_io_fast(struct srp_rport *rport)
 
 	if (srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST))
 		return;
+	/*
+	 * Call scsi_target_block() to wait for ongoing shost->queuecommand()
+	 * calls before invoking i->f->terminate_rport_io().
+	 */
+	scsi_target_block(rport->dev.parent);
 	scsi_target_unblock(rport->dev.parent, SDEV_TRANSPORT_OFFLINE);
 
 	/* Involve the LLD if possible to terminate all I/O on the rport. */
 	i = to_srp_internal(shost->transportt);
-	if (i->f->terminate_rport_io) {
-		srp_wait_for_queuecommand(shost);
+	if (i->f->terminate_rport_io)
 		i->f->terminate_rport_io(rport);
-	}
 }
 
 /**
@@ -576,7 +548,6 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	if (res)
 		goto out;
 	scsi_target_block(&shost->shost_gendev);
-	srp_wait_for_queuecommand(shost);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
