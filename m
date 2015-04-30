From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Thu, 30 Apr 2015 10:56:42 +0200
Message-ID: <5541EE4A.30803@sandisk.com>
References: <5541EE21.3050809@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0077.outbound.protection.outlook.com ([157.56.110.77]:40992
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750947AbbD3I4w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Apr 2015 04:56:52 -0400
In-Reply-To: <5541EE21.3050809@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Introduce the helper function srp_wait_for_queuecommand().
Move the definition of scsi_request_fn_active(). This patch
does not change any functionality. A second call to
scsi_wait_for_queuecommand() will be introduced in the next
patch.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <JBottomley@Odin.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: <stable@vger.kernel.org> #v3.13
---
 drivers/scsi/scsi_transport_srp.c | 52 ++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index ae45bd9..6ce1c48 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -396,6 +396,34 @@ static void srp_reconnect_work(struct work_struct *work)
 	}
 }
 
+/**
+ * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
+ * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
+ */
+static int scsi_request_fn_active(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+	struct request_queue *q;
+	int request_fn_active = 0;
+
+	shost_for_each_device(sdev, shost) {
+		q = sdev->request_queue;
+
+		spin_lock_irq(q->queue_lock);
+		request_fn_active += q->request_fn_active;
+		spin_unlock_irq(q->queue_lock);
+	}
+
+	return request_fn_active;
+}
+
+/* Wait until ongoing shost->hostt->queuecommand() calls have finished. */
+static void srp_wait_for_queuecommand(struct Scsi_Host *shost)
+{
+	while (scsi_request_fn_active(shost))
+		msleep(20);
+}
+
 static void __rport_fail_io_fast(struct srp_rport *rport)
 {
 	struct Scsi_Host *shost = rport_to_shost(rport);
@@ -504,27 +532,6 @@ void srp_start_tl_fail_timers(struct srp_rport *rport)
 EXPORT_SYMBOL(srp_start_tl_fail_timers);
 
 /**
- * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
- * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
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
-/**
  * srp_reconnect_rport() - reconnect to an SRP target port
  * @rport: SRP target port.
  *
@@ -559,8 +566,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	if (res)
 		goto out;
 	scsi_target_block(&shost->shost_gendev);
-	while (scsi_request_fn_active(shost))
-		msleep(20);
+	srp_wait_for_queuecommand(shost);
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
-- 
2.1.4

