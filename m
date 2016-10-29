From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v5 11/14] SRP transport: Move queuecommand() wait code to SCSI
 core
Date: Fri, 28 Oct 2016 17:22:37 -0700
Message-ID: <b447e9bc-7e29-d058-76ad-89ba2a7bf729@sandisk.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0077.outbound.protection.outlook.com ([104.47.41.77]:21852
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S964933AbcJ2AWp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Oct 2016 20:22:45 -0400
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, Ming Lei <tom.leiming@gmail.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>, Laurence Oberman <loberman@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

Additionally, rename srp_wait_for_queuecommand() into
scsi_wait_for_queuecommand() and add a comment about the
queuecommand() call from scsi_send_eh_cmnd().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>
---
 drivers/scsi/scsi_lib.c           | 38 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_transport_srp.c | 41 ++++++---------------------------------
 2 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b4f682c..3ab9c87 100644
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
@@ -2814,6 +2847,10 @@ EXPORT_SYMBOL(scsi_target_resume);
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
@@ -2841,6 +2878,7 @@ scsi_internal_device_block(struct scsi_device *sdev)
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
2.10.1

