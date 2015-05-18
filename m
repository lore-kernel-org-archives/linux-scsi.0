From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 01/12] scsi_transport_srp: Introduce srp_wait_for_queuecommand()
Date: Mon, 18 May 2015 13:22:19 +0200
Message-ID: <5559CB6B.1090508@sandisk.com>
References: <5559CB3A.6060102@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:16171
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753669AbbERLW2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 May 2015 07:22:28 -0400
In-Reply-To: <5559CB3A.6060102@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: James Bottomley <jbottomley@odin.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Introduce the helper function srp_wait_for_queuecommand().
Move the definition of scsi_request_fn_active(). Add a comment
above srp_wait_for_queuecommand() that support for scsi-mq needs
to be added.

This patch does not change any functionality. A second call to
srp_wait_for_queuecommand() will be introduced in the next patch.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <JBottomley@Odin.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: <stable@vger.kernel.org> #v3.13
---
 drivers/scsi/scsi_transport_srp.c | 54 ++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index ae45bd9..e05cd7e 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -396,6 +396,36 @@ static void srp_reconnect_work(struct work_struct *work)
 	}
 }
 
+/**
+ * scsi_request_fn_active() - number of kernel threads inside scsi_request_fn()
+ * @shost: SCSI host for which to count the number of scsi_request_fn() callers.
+ *
+ * To do: add support for scsi-mq in this function.
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
@@ -504,27 +534,6 @@ void srp_start_tl_fail_timers(struct srp_rport *rport)
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
@@ -559,8 +568,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
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

