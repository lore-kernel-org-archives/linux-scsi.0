From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/3] scsi_transport_srp: Fix a race condition
Date: Wed, 11 Dec 2013 17:06:14 +0100
Message-ID: <52A88D76.1090105@acm.org>
References: <52A88CF9.206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:33803 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab3LKQGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2013 11:06:18 -0500
In-Reply-To: <52A88CF9.206@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, James Bottomley <JBottomley@Parallels.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

The rport timers must be stopped before the SRP initiator destroys the
resources associated with the SCSI host. This is necessary because
otherwise the callback functions invoked from the SRP transport layer
could trigger a use-after-free. Stopping the rport timers before
invoking scsi_remove_host() can trigger long delays in the SCSI error
handler if a transport layer failure occurs while scsi_remove_host()
is in progress. Hence move the code for stopping the rport timers
from srp_rport_release() into a new function and invoke that function
after scsi_remove_host() has finished. This patch fixes the following
sporadic kernel crash:

kernel BUG at include/asm-generic/dma-mapping-common.h:64!
invalid opcode: 0000 [#1] SMP
RIP: 0010:[<ffffffffa03b20b1>]  [<ffffffffa03b20b1>] srp_unmap_data+0x121/0x130 [ib_srp]
Call Trace:
[<ffffffffa03b20fc>] srp_free_req+0x3c/0x80 [ib_srp]
[<ffffffffa03b2188>] srp_finish_req+0x48/0x70 [ib_srp]
[<ffffffffa03b21fb>] srp_terminate_io+0x4b/0x60 [ib_srp]
[<ffffffffa03a6fb5>] __rport_fail_io_fast+0x75/0x80 [scsi_transport_srp]
[<ffffffffa03a7438>] rport_fast_io_fail_timedout+0x88/0xc0 [scsi_transport_srp]
[<ffffffff8108b370>] worker_thread+0x170/0x2a0
[<ffffffff81090876>] kthread+0x96/0xa0
[<ffffffff8100c0ca>] child_rip+0xa/0x20

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: James Bottomley <JBottomley@Parallels.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  1 +
 drivers/scsi/scsi_transport_srp.c   | 83 +++++++++++++++++++------------------
 include/scsi/scsi_transport_srp.h   |  4 +-
 3 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6787d7b..91bb991 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -695,6 +695,7 @@ static void srp_remove_target(struct srp_target_port *target)
 	srp_rport_get(target->rport);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
+	srp_stop_rport_timers(target->rport);
 	srp_disconnect_target(target);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 8b9cb22..a349d44 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -456,37 +456,29 @@ static void __srp_start_tl_fail_timers(struct srp_rport *rport)
 
 	lockdep_assert_held(&rport->mutex);
 
-	if (!rport->deleted) {
-		delay = rport->reconnect_delay;
-		fast_io_fail_tmo = rport->fast_io_fail_tmo;
-		dev_loss_tmo = rport->dev_loss_tmo;
-		pr_debug("%s current state: %d\n",
-			 dev_name(&shost->shost_gendev), rport->state);
+	delay = rport->reconnect_delay;
+	fast_io_fail_tmo = rport->fast_io_fail_tmo;
+	dev_loss_tmo = rport->dev_loss_tmo;
+	pr_debug("%s current state: %d\n", dev_name(&shost->shost_gendev),
+		 rport->state);
 
-		if (delay > 0)
+	if (rport->state == SRP_RPORT_LOST)
+		return;
+	if (delay > 0)
+		queue_delayed_work(system_long_wq, &rport->reconnect_work,
+				   1UL * delay * HZ);
+	if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
+		pr_debug("%s new state: %d\n", dev_name(&shost->shost_gendev),
+			 rport->state);
+		scsi_target_block(&shost->shost_gendev);
+		if (fast_io_fail_tmo >= 0)
 			queue_delayed_work(system_long_wq,
-					   &rport->reconnect_work,
-					   1UL * delay * HZ);
-		if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
-			pr_debug("%s new state: %d\n",
-				 dev_name(&shost->shost_gendev),
-				 rport->state);
-			scsi_target_block(&shost->shost_gendev);
-			if (fast_io_fail_tmo >= 0)
-				queue_delayed_work(system_long_wq,
-						   &rport->fast_io_fail_work,
-						   1UL * fast_io_fail_tmo * HZ);
-			if (dev_loss_tmo >= 0)
-				queue_delayed_work(system_long_wq,
-						   &rport->dev_loss_work,
-						   1UL * dev_loss_tmo * HZ);
-		}
-	} else {
-		pr_debug("%s has already been deleted\n",
-			 dev_name(&shost->shost_gendev));
-		srp_rport_set_state(rport, SRP_RPORT_FAIL_FAST);
-		scsi_target_unblock(&shost->shost_gendev,
-				    SDEV_TRANSPORT_OFFLINE);
+					   &rport->fast_io_fail_work,
+					   1UL * fast_io_fail_tmo * HZ);
+		if (dev_loss_tmo >= 0)
+			queue_delayed_work(system_long_wq,
+					   &rport->dev_loss_work,
+					   1UL * dev_loss_tmo * HZ);
 	}
 }
 
@@ -560,7 +552,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	scsi_target_block(&shost->shost_gendev);
 	while (scsi_request_fn_active(shost))
 		msleep(20);
-	res = i->f->reconnect(rport);
+	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
 	if (res == 0) {
@@ -626,10 +618,6 @@ static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
 
-	cancel_delayed_work_sync(&rport->reconnect_work);
-	cancel_delayed_work_sync(&rport->fast_io_fail_work);
-	cancel_delayed_work_sync(&rport->dev_loss_work);
-
 	put_device(dev->parent);
 	kfree(rport);
 }
@@ -784,12 +772,6 @@ void srp_rport_del(struct srp_rport *rport)
 	device_del(dev);
 	transport_destroy_device(dev);
 
-	mutex_lock(&rport->mutex);
-	if (rport->state == SRP_RPORT_BLOCKED)
-		__rport_fail_io_fast(rport);
-	rport->deleted = true;
-	mutex_unlock(&rport->mutex);
-
 	put_device(dev);
 }
 EXPORT_SYMBOL_GPL(srp_rport_del);
@@ -814,6 +796,27 @@ void srp_remove_host(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL_GPL(srp_remove_host);
 
+/**
+ * srp_stop_rport_timers - stop the transport layer recovery timers
+ *
+ * Must be called after srp_remove_host() and scsi_remove_host(). The caller
+ * must hold a reference on the rport (rport->dev) and on the SCSI host
+ * (rport->dev.parent).
+ */
+void srp_stop_rport_timers(struct srp_rport *rport)
+{
+	mutex_lock(&rport->mutex);
+	if (rport->state == SRP_RPORT_BLOCKED)
+		__rport_fail_io_fast(rport);
+	srp_rport_set_state(rport, SRP_RPORT_LOST);
+	mutex_unlock(&rport->mutex);
+
+	cancel_delayed_work_sync(&rport->reconnect_work);
+	cancel_delayed_work_sync(&rport->fast_io_fail_work);
+	cancel_delayed_work_sync(&rport->dev_loss_work);
+}
+EXPORT_SYMBOL_GPL(srp_stop_rport_timers);
+
 static int srp_tsk_mgmt_response(struct Scsi_Host *shost, u64 nexus, u64 tm_id,
 				 int result)
 {
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 4ebf691..f24e763 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -19,7 +19,7 @@ struct srp_rport_identifiers {
  * @SRP_RPORT_BLOCKED:   Transport layer not operational; fast I/O fail timer
  *                       is running and I/O has been blocked.
  * @SRP_RPORT_FAIL_FAST: Fast I/O fail timer has expired; fail I/O fast.
- * @SRP_RPORT_LOST:      Device loss timer has expired; port is being removed.
+ * @SRP_RPORT_LOST:      Port is being removed.
  */
 enum srp_rport_state {
 	SRP_RPORT_RUNNING,
@@ -48,7 +48,6 @@ struct srp_rport {
 
 	struct mutex		mutex;
 	enum srp_rport_state	state;
-	bool			deleted;
 	int			reconnect_delay;
 	int			failed_reconnects;
 	struct delayed_work	reconnect_work;
@@ -101,6 +100,7 @@ extern int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo,
 extern int srp_reconnect_rport(struct srp_rport *rport);
 extern void srp_start_tl_fail_timers(struct srp_rport *rport);
 extern void srp_remove_host(struct Scsi_Host *);
+extern void srp_stop_rport_timers(struct srp_rport *rport);
 
 /**
  * srp_chkready() - evaluate the transport layer state before I/O
-- 
1.8.1.4

