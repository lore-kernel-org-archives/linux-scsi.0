From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 12/14] ib_srp: Rework error handling
Date: Thu, 1 Dec 2011 20:10:37 +0100
Message-ID: <201112012010.37276.bvanassche@acm.org>
References: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay02ant.iops.be ([212.53.4.35]:40187 "EHLO
	relay02ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1LATKm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 14:10:42 -0500
In-Reply-To: <201112011954.25811.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org, David Dillow <dillowda@ornl.gov>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Roland Dreier <roland@purestorage.com>
Cc: linux-scsi@vger.kernel.org

Add the necessary functions in the SRP transport module to allow
an SRP initiator driver to implement transport layer recovery.

Convert srp_target_port.qp_in_error into a target port state.

Factor out the code for removing an SRP target into the new function
srp_remove_target().

In the ib_srp IB completion handlers, do not stop processing
completions after the first error completion or a CM DREQ has been
received. Block the SCSI target as soon as the first IB error
completion has been received. Eliminate the SCSI target state test
from srp_queuecommand().

Rework ib_srp transport layer error handling. Instead of letting SCSI
commands time out if a transport layer error occurs, block the SCSI
host and try to reconnect until the reconnect timeout elapses or until
the maximum number of reconnect attempts has been exceeded, whichever
happens first.

Rescan LUNs after having unblocked a SCSI target controlled by ib_srp.

Add the sysfs attributes reconnect_tmo, failed_reconnects and
max_reconnects.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Roland Dreier <roland@purestorage.com>
---
 Documentation/ABI/stable/sysfs-driver-ib_srp |   25 ++
 drivers/infiniband/ulp/srp/ib_srp.c          |  398 ++++++++++++++++++++------
 drivers/infiniband/ulp/srp/ib_srp.h          |   27 ++-
 drivers/scsi/scsi_transport_srp.c            |  162 +++++++++++-
 include/scsi/scsi_transport_srp.h            |   31 ++
 5 files changed, 548 insertions(+), 95 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-ib_srp b/Documentation/ABI/stable/sysfs-driver-ib_srp
index 6b74c09..b1f449c 100644
--- a/Documentation/ABI/stable/sysfs-driver-ib_srp
+++ b/Documentation/ABI/stable/sysfs-driver-ib_srp
@@ -74,6 +74,12 @@ Contact:	linux-rdma@vger.kernel.org
 Description:	InfiniBand destination GID used for communication with the SRP
 		target. Differs from orig_dgid if port redirection has happened.
 
+What:		/sys/class/scsi_host/host<n>/failed_reconnects
+Date:		November 1, 2011
+KernelVersion:	3.3
+Contact:	linux-rdma@vger.kernel.org
+Description:	Number of consecutive failed SRP reconnect attempts.
+
 What:		/sys/class/scsi_host/host<n>/id_ext
 Date:		June 17, 2006
 KernelVersion:	2.6.17
@@ -102,6 +108,14 @@ Contact:	linux-rdma@vger.kernel.org
 Description:	Number of the HCA port used for communicating with the
 		SRP target.
 
+What:		/sys/class/scsi_host/host<n>/max_reconnects
+Date:		November 1, 2011
+KernelVersion:	3.3
+Contact:	linux-rdma@vger.kernel.org
+Description:	Maximum number of times ib_srp should attempt to reconnect
+		to the SRP target after an I/O error occurred. The value -1
+		means that ib_srp should keep trying to reconnect forever.
+
 What:		/sys/class/scsi_host/host<n>/orig_dgid
 Date:		June 17, 2006
 KernelVersion:	2.6.17
@@ -116,6 +130,17 @@ Contact:	linux-rdma@vger.kernel.org
 Description:	A 16-bit number representing the InfiniBand partition key used
 		for communication with the SRP target.
 
+What:		/sys/class/scsi_host/host<n>/reconnect_tmo
+Date:		November 1, 2011
+KernelVersion:	3.3
+Contact:	linux-rdma@vger.kernel.org
+Description:	Time in seconds to wait after a failed connection attempt
+		before trying to reconnect. Setting this parameter to zero or
+		to a negative value prevents ib_srp to attempt to reconnect.
+		Changing this parameter from a value <= 0 into a value > 0 at
+		a time there is no connection with the target will cause
+		ib_srp to try to reconnect with the target.
+
 What:		/sys/class/scsi_host/host<n>/req_lim
 Date:		October 20, 2010
 KernelVersion:	2.6.36
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 44c810b..797a8f1 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2005 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2010-2011 Bart Van Assche <bvanassche@acm.org>.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -430,6 +431,22 @@ static int srp_send_req(struct srp_target_port *target)
 
 static void srp_disconnect_target(struct srp_target_port *target)
 {
+	bool disconnect = false;
+
+	spin_lock_irq(&target->lock);
+	switch (target->state) {
+	case SRP_TARGET_LIVE:
+	case SRP_TARGET_BLOCKED:
+		disconnect = true;
+		target->state = SRP_TARGET_DISCONNECTED;
+	default:
+		break;
+	}
+	spin_unlock_irq(&target->lock);
+
+	if (!disconnect)
+		return;
+
 	/* XXX should send SRP_I_LOGOUT request */
 
 	init_completion(&target->done);
@@ -489,32 +506,77 @@ static void srp_del_scsi_host_attr(struct Scsi_Host *shost)
 		device_remove_file(&shost->shost_dev, *attr);
 }
 
-static void srp_remove_work(struct work_struct *work)
+/**
+ * srp_remove_target() - Remove an SRP target.
+ *
+ * The strategy to remove a target is as follows:
+ * - The caller must have set target->state to SRP_TARGET_REMOVED before
+ *   invoking or queueing this function such that new calls to
+ *   srp_disconnect_target(), srp_reconnect_target(), srp_recovery_timedout()
+ *   or srp_block_work() do not have any effect.
+ * - Cancel block_work and lock and unlock target->mutex to make sure that any
+ *   concurrent srp_block_rport() calls have finished.
+ * - Unblock the rport such that any blocked scanning work resumes.
+ * - Tear down the rport, the SCSI host and the IB resources associated with
+ *   the target.
+ */
+static void srp_remove_target(struct srp_target_port *target)
 {
-	struct srp_target_port *target =
-		container_of(work, struct srp_target_port, work);
-
-	if (!srp_change_state(target, SRP_TARGET_DEAD, SRP_TARGET_REMOVED))
-		return;
-
-	spin_lock(&target->srp_host->target_lock);
-	list_del(&target->list);
-	spin_unlock(&target->srp_host->target_lock);
+	WARN_ON(target->state != SRP_TARGET_REMOVED);
 
 	srp_del_scsi_host_attr(target->scsi_host);
+	cancel_work_sync(&target->block_work);
+	mutex_lock(&target->mutex);
+	mutex_unlock(&target->mutex);
+	srp_unblock_rport(rport);
+	srp_rport_disable_recovery(target->rport);
+	cancel_delayed_work_sync(&target->reconnect_work);
+	srp_stop_rport(target->rport);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
+	cancel_work_sync(&target->scan_work);
+	srp_disconnect_target(target);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
 	scsi_host_put(target->scsi_host);
 }
 
+static void srp_remove_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(work, struct srp_target_port, remove_work);
+
+	spin_lock(&target->srp_host->target_lock);
+	list_del(&target->list);
+	spin_unlock(&target->srp_host->target_lock);
+
+	srp_remove_target(target);
+}
+
+static void srp_recovery_timedout(struct srp_rport *rport)
+{
+	struct srp_target_port *target = rport->lld_data;
+
+	pr_debug("recovery timeout: rport = %p; target = %p / state %d\n",
+		 rport, target, target->state);
+
+	cancel_delayed_work_sync(&target->reconnect_work);
+
+	mutex_lock(&target->mutex);
+	if (srp_change_state(target, SRP_TARGET_BLOCKED, SRP_TARGET_LIVE))
+		srp_unblock_rport(rport);
+	mutex_unlock(&target->mutex);
+}
+
 static int srp_connect_target(struct srp_target_port *target)
 {
 	int retries = 3;
 	int ret;
 
+	WARN_ON(target->state != SRP_TARGET_CONNECTING);
+
 	ret = srp_lookup_path(target);
 	if (ret)
 		return ret;
@@ -606,16 +668,40 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 	srp_remove_req(target, req, 0);
 }
 
+static void srp_scan_target(struct srp_target_port *target)
+{
+	scsi_scan_target(&target->scsi_host->shost_gendev, 0, target->scsi_id,
+			 SCAN_WILD_CARD, 0);
+}
+
+static void srp_scan_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(work, struct srp_target_port, scan_work);
+	srp_scan_target(target);
+}
+
 static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct ib_qp_attr qp_attr;
 	struct ib_wc wc;
 	int i, ret;
 
-	if (!srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_CONNECTING))
-		return -EAGAIN;
+	mutex_lock(&target->mutex);
+	if (srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_BLOCKED)) {
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "blocked SCSI host.\n");
+		srp_block_rport(target->rport);
+	}
+	mutex_unlock(&target->mutex);
 
 	srp_disconnect_target(target);
+
+	if (!srp_change_state(target, SRP_TARGET_DISCONNECTED,
+			      SRP_TARGET_CONNECTING))
+		return -EAGAIN;
+
 	/*
 	 * Now get a new local CM ID so that we avoid confusing the
 	 * target in case things are really fouled up.
@@ -648,38 +734,65 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
-	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
 	if (ret)
 		goto err;
 
-	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE))
+	mutex_lock(&target->mutex);
+	if (srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE)) {
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "unblocked SCSI host.\n");
+		srp_unblock_rport(target->rport);
+	} else {
 		ret = -EAGAIN;
+	}
+	mutex_unlock(&target->mutex);
+
+	/*
+	 * Since this code can be invoked from the context of the SCSI error
+	 * handler, invoke SCSI scanning asynchronously.
+	 */
+	if (ret == 0)
+		queue_work(system_long_wq, &target->scan_work);
 
 	return ret;
 
 err:
-	shost_printk(KERN_ERR, target->scsi_host,
-		     PFX "reconnect failed (%d), removing target port.\n", ret);
+	srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_BLOCKED);
+	return ret;
+}
 
-	/*
-	 * We couldn't reconnect, so kill our target port off.
-	 * However, we have to defer the real removal because we
-	 * are in the context of the SCSI error handler now, which
-	 * will deadlock if we call scsi_remove_host().
-	 *
-	 * Schedule our work inside the lock to avoid a race with
-	 * the flush_scheduled_work() in srp_remove_one().
-	 */
-	spin_lock_irq(&target->lock);
-	if (target->state == SRP_TARGET_CONNECTING) {
-		target->state = SRP_TARGET_DEAD;
-		INIT_WORK(&target->work, srp_remove_work);
-		queue_work(ib_wq, &target->work);
+static void srp_reconnect_repeatedly(struct srp_target_port *target)
+{
+	int res, tmo;
+
+	res = srp_reconnect_target(target);
+	if (res == 0 || target->state != SRP_TARGET_BLOCKED)
+		return;
+
+	++target->failed_reconnects;
+
+	shost_printk(KERN_ERR, target->scsi_host,
+		     PFX "reconnect attempt %d failed (%d).\n",
+		     target->failed_reconnects, res);
+
+	tmo = target->reconnect_tmo;
+	if (tmo > 0 &&
+	    (target->max_reconnects < 0 ||
+	     target->failed_reconnects < target->max_reconnects)) {
+		queue_delayed_work(system_long_wq, &target->reconnect_work,
+				   tmo * HZ);
 	}
-	spin_unlock_irq(&target->lock);
+}
 
-	return ret;
+static void srp_reconnect_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+
+	target = container_of(to_delayed_work(work), struct srp_target_port,
+			      reconnect_work);
+
+	srp_reconnect_repeatedly(target);
 }
 
 static void srp_map_desc(struct srp_map_state *state, dma_addr_t dma_addr,
@@ -1217,13 +1330,39 @@ static void srp_handle_recv(struct srp_target_port *target, struct ib_wc *wc)
 			     PFX "Recv failed with error code %d\n", res);
 }
 
+static void srp_block_work(struct work_struct *work)
+{
+	struct srp_target_port *target;
+	bool reconnect = false;
+
+	target = container_of(work, struct srp_target_port, block_work);
+
+	mutex_lock(&target->mutex);
+	if (srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_BLOCKED)) {
+		shost_printk(KERN_INFO, target->scsi_host,
+			     PFX "blocked SCSI host.\n");
+		srp_block_rport(target->rport);
+		srp_start_recovery_timer(target->rport);
+		reconnect = true;
+	}
+	mutex_unlock(&target->mutex);
+
+	if (reconnect) {
+		target->failed_reconnects = 0;
+		srp_reconnect_repeatedly(target);
+	}
+}
+
 static void srp_handle_qp_err(enum ib_wc_status wc_status,
 			      enum ib_wc_opcode wc_opcode,
 			      struct srp_target_port *target)
 {
-	shost_printk(KERN_ERR, target->scsi_host,
-		     PFX "failed receive status %d\n", wc_status);
-	target->qp_in_error = 1;
+	if (!queue_work(system_long_wq, &target->block_work) ||
+	    target->state == SRP_TARGET_BLOCKED)
+		return;
+
+	shost_printk(KERN_ERR, target->scsi_host, PFX "failed %s status %d\n",
+		     wc_opcode & IB_WC_RECV ? "receive" : "send", wc_status);
 }
 
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
@@ -1233,12 +1372,10 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 
 	ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
 	while (ib_poll_cq(cq, 1, &wc) > 0) {
-		if (wc.status == IB_WC_SUCCESS) {
+		if (wc.status == IB_WC_SUCCESS)
 			srp_handle_recv(target, &wc);
-		} else {
+		else
 			srp_handle_qp_err(wc.status, wc.opcode, target);
-			break;
-		}
 	}
 }
 
@@ -1254,7 +1391,6 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			list_add(&iu->list, &target->free_tx);
 		} else {
 			srp_handle_qp_err(wc.status, wc.opcode, target);
-			break;
 		}
 	}
 }
@@ -1269,16 +1405,6 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (target->state == SRP_TARGET_CONNECTING)
-		goto err;
-
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED) {
-		scmnd->result = DID_BAD_TARGET << 16;
-		scmnd->scsi_done(scmnd);
-		return 0;
-	}
-
 	spin_lock_irqsave(&target->lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
 	if (!iu)
@@ -1335,7 +1461,6 @@ err_iu:
 err_unlock:
 	spin_unlock_irqrestore(&target->lock, flags);
 
-err:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
@@ -1589,6 +1714,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
+		queue_work(system_long_wq, &target->block_work);
 		break;
 
 	case IB_CM_TIMEWAIT_EXIT:
@@ -1623,10 +1749,6 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
-		return -1;
-
 	init_completion(&target->tsk_mgmt_done);
 
 	spin_lock_irq(&target->lock);
@@ -1669,7 +1791,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error)
+	if (!req)
 		return FAILED;
 	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			      SRP_TSK_ABORT_TASK))
@@ -1693,8 +1815,6 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
-	if (target->qp_in_error)
-		return FAILED;
 	if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
 			      SRP_TSK_LUN_RESET))
 		return FAILED;
@@ -1713,12 +1833,38 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 static int srp_reset_host(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_host *host = target->srp_host;
 	int ret = FAILED;
+	bool remove = false;
 
 	shost_printk(KERN_ERR, target->scsi_host, PFX "SRP reset_host called\n");
 
-	if (!srp_reconnect_target(target))
+	if (!srp_reconnect_target(target)) {
 		ret = SUCCESS;
+	} else {
+		/*
+		 * We couldn't reconnect, so kill our target port off.
+		 * However, we have to defer the real removal because we
+		 * are in the context of the SCSI error handler now, which
+		 * will deadlock if we call scsi_remove_host().
+		 *
+		 * Schedule our work inside the lock to avoid a race with
+		 * the flush_work_sync() call in srp_remove_one().
+		 */
+		spin_lock(&host->target_lock);
+		spin_lock_irq(&target->lock);
+		if (target->state != SRP_TARGET_REMOVED) {
+			target->state = SRP_TARGET_REMOVED;
+			remove = true;
+		}
+		spin_unlock_irq(&target->lock);
+		if (remove) {
+			shost_printk(KERN_ERR, target->scsi_host, PFX "recon"
+				     "nect failed, removing target port.\n");
+			queue_work(system_long_wq, &target->remove_work);
+		}
+		spin_unlock(&host->target_lock);
+	}
 
 	return ret;
 }
@@ -1822,6 +1968,66 @@ static ssize_t show_allow_ext_sg(struct device *dev,
 	return sprintf(buf, "%s\n", target->allow_ext_sg ? "true" : "false");
 }
 
+static ssize_t show_reconnect_tmo(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->reconnect_tmo);
+}
+
+static ssize_t store_reconnect_tmo(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, const size_t count)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+	char ch[16];
+	int res, tmo;
+
+	sprintf(ch, "%.*s", (int)min(sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &tmo);
+	if (res)
+		goto out;
+	target->reconnect_tmo = tmo;
+	if (tmo > 0 && target->state == SRP_TARGET_BLOCKED)
+		queue_delayed_work(system_long_wq, &target->reconnect_work,
+				   tmo * HZ);
+	else if (tmo <= 0)
+		cancel_delayed_work(&target->reconnect_work);
+	res = count;
+out:
+	return res;
+}
+
+static ssize_t show_failed_reconnects(struct device *dev,
+				      struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->failed_reconnects);
+}
+
+static ssize_t show_max_reconnects(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+
+	return sprintf(buf, "%d\n", target->max_reconnects);
+}
+
+static ssize_t store_max_reconnects(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, const size_t count)
+{
+	struct srp_target_port *target = host_to_target(class_to_shost(dev));
+	char ch[16];
+	int res;
+
+	sprintf(ch, "%.*s", (int)min(sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &target->max_reconnects);
+	return res == 0 ? count : res;
+}
+
 static DEVICE_ATTR(id_ext,	    S_IRUGO, show_id_ext,	   NULL);
 static DEVICE_ATTR(ioc_guid,	    S_IRUGO, show_ioc_guid,	   NULL);
 static DEVICE_ATTR(service_id,	    S_IRUGO, show_service_id,	   NULL);
@@ -1834,6 +2040,11 @@ static DEVICE_ATTR(local_ib_port,   S_IRUGO, show_local_ib_port,   NULL);
 static DEVICE_ATTR(local_ib_device, S_IRUGO, show_local_ib_device, NULL);
 static DEVICE_ATTR(cmd_sg_entries,  S_IRUGO, show_cmd_sg_entries,  NULL);
 static DEVICE_ATTR(allow_ext_sg,    S_IRUGO, show_allow_ext_sg,    NULL);
+static DEVICE_ATTR(reconnect_tmo,   S_IRUGO | S_IWUSR, show_reconnect_tmo,
+		   store_reconnect_tmo);
+static DEVICE_ATTR(failed_reconnects, S_IRUGO, show_failed_reconnects, NULL);
+static DEVICE_ATTR(max_reconnects, S_IRUGO | S_IWUSR, show_max_reconnects,
+		   store_max_reconnects);
 
 static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_id_ext,
@@ -1848,6 +2059,9 @@ static struct device_attribute *srp_host_attrs[] = {
 	&dev_attr_local_ib_device,
 	&dev_attr_cmd_sg_entries,
 	&dev_attr_allow_ext_sg,
+	&dev_attr_reconnect_tmo,
+	&dev_attr_failed_reconnects,
+	&dev_attr_max_reconnects,
 	NULL
 };
 
@@ -1869,6 +2083,10 @@ static struct scsi_host_template srp_template = {
 	.shost_attrs			= srp_host_attrs
 };
 
+static struct srp_function_template ib_srp_transport_functions = {
+	.rport_recovery_timedout = srp_recovery_timedout,
+};
+
 static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 {
 	struct srp_rport_identifiers ids;
@@ -1889,14 +2107,17 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 		return PTR_ERR(rport);
 	}
 
+	rport->ft = &ib_srp_transport_functions;
+	rport->lld_data = target;
+
 	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
 	spin_unlock(&host->target_lock);
 
 	target->state = SRP_TARGET_LIVE;
+	target->rport = rport;
 
-	scsi_scan_target(&target->scsi_host->shost_gendev,
-			 0, target->scsi_id, SCAN_WILD_CARD, 0);
+	srp_scan_target(target);
 
 	return 0;
 }
@@ -2213,6 +2434,13 @@ static ssize_t srp_create_target(struct device *dev,
 			     sizeof (struct srp_indirect_buf) +
 			     target->cmd_sg_cnt * sizeof (struct srp_direct_buf);
 
+	mutex_init(&target->mutex);
+	INIT_WORK(&target->block_work, srp_block_work);
+	INIT_WORK(&target->remove_work, srp_remove_work);
+	INIT_WORK(&target->scan_work, srp_scan_work);
+	INIT_DELAYED_WORK(&target->reconnect_work, srp_reconnect_work);
+	target->reconnect_tmo = 10;
+	target->max_reconnects = -1;
 	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
@@ -2257,7 +2485,8 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_ib;
 
-	target->qp_in_error = 0;
+	target->state = SRP_TARGET_CONNECTING;
+
 	ret = srp_connect_target(target);
 	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host,
@@ -2448,8 +2677,7 @@ static void srp_remove_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
 	struct srp_host *host, *tmp_host;
-	LIST_HEAD(target_list);
-	struct srp_target_port *target, *tmp_target;
+	struct srp_target_port *target;
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
@@ -2462,36 +2690,31 @@ static void srp_remove_one(struct ib_device *device)
 		wait_for_completion(&host->released);
 
 		/*
-		 * Mark all target ports as removed, so we stop queueing
-		 * commands and don't try to reconnect.
+		 * Mark all target ports as removed so we don't try to
+		 * reconnect. Wait for any removal tasks that may have
+		 * started before we marked our target ports as
+		 * removed.
 		 */
 		spin_lock(&host->target_lock);
-		list_for_each_entry(target, &host->target_list, list) {
+		while (!list_empty(&host->target_list)) {
+			target = list_first_entry(&host->target_list,
+						  struct srp_target_port, list);
 			spin_lock_irq(&target->lock);
 			target->state = SRP_TARGET_REMOVED;
 			spin_unlock_irq(&target->lock);
+			if (work_pending(&target->remove_work)) {
+				spin_unlock(&host->target_lock);
+				flush_work_sync(&target->remove_work);
+				spin_lock(&host->target_lock);
+			} else {
+				list_del(&target->list);
+				spin_unlock(&host->target_lock);
+				srp_remove_target(target);
+				spin_lock(&host->target_lock);
+			}
 		}
 		spin_unlock(&host->target_lock);
 
-		/*
-		 * Wait for any reconnection tasks that may have
-		 * started before we marked our target ports as
-		 * removed, and any target port removal tasks.
-		 */
-		flush_workqueue(ib_wq);
-
-		list_for_each_entry_safe(target, tmp_target,
-					 &host->target_list, list) {
-			srp_del_scsi_host_attr(target->scsi_host);
-			srp_remove_host(target->scsi_host);
-			scsi_remove_host(target->scsi_host);
-			srp_disconnect_target(target);
-			ib_destroy_cm_id(target->cm_id);
-			srp_free_target_ib(target);
-			srp_free_req_data(target);
-			scsi_host_put(target->scsi_host);
-		}
-
 		kfree(host);
 	}
 
@@ -2503,9 +2726,6 @@ static void srp_remove_one(struct ib_device *device)
 	kfree(srp_dev);
 }
 
-static struct srp_function_template ib_srp_transport_functions = {
-};
-
 static int __init srp_init_module(void)
 {
 	int ret;
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index f010bd9..5e30cff 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -78,11 +78,20 @@ enum {
 	SRP_MAP_NO_FMR		= 1,
 };
 
+/**
+ * @SRP_TARGET_LIVE: IB RC connection is established and SCSI host is unblocked.
+ * @SRP_TARGET_CONNECTING: IB RC connection being established.
+ * @SRP_TARGET_BLOCKED: An IB RC error occurred. Recovery timer may be running.
+ *                      SCSI host is blocked.
+ * @SRP_TARGET_DISCONNECTED: IB RC connection has been disconnected.
+ * @SRP_TARGET_REMOVED: SCSI host removal is pending.
+ */
 enum srp_target_state {
 	SRP_TARGET_LIVE,
 	SRP_TARGET_CONNECTING,
-	SRP_TARGET_DEAD,
-	SRP_TARGET_REMOVED
+	SRP_TARGET_BLOCKED,
+	SRP_TARGET_DISCONNECTED,
+	SRP_TARGET_REMOVED,
 };
 
 enum srp_iu_type {
@@ -155,6 +164,7 @@ struct srp_target_port {
 	u16			io_class;
 	struct srp_host	       *srp_host;
 	struct Scsi_Host       *scsi_host;
+	struct srp_rport       *rport;
 	char			target_name[32];
 	unsigned int		scsi_id;
 	unsigned int		sg_tablesize;
@@ -174,15 +184,22 @@ struct srp_target_port {
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
-	struct work_struct	work;
-
 	struct list_head	list;
 	struct completion	done;
 	int			status;
-	int			qp_in_error;
+	struct mutex		mutex;
 
 	struct completion	tsk_mgmt_done;
 	u8			tsk_mgmt_status;
+
+	struct work_struct	block_work;
+	struct work_struct	remove_work;
+	struct work_struct	scan_work;
+
+	int			reconnect_tmo;
+	int			max_reconnects;
+	int			failed_reconnects;
+	struct delayed_work	reconnect_work;
 };
 
 struct srp_iu {
diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 1cbf097..9a57b7b 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -2,6 +2,7 @@
  * SCSI RDMA (SRP) transport class
  *
  * Copyright (C) 2007 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2011 Bart Van Assche <bvanassche@acm.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -38,7 +39,7 @@ struct srp_host_attrs {
 #define to_srp_host_attrs(host)	((struct srp_host_attrs *)(host)->shost_data)
 
 #define SRP_HOST_ATTRS 0
-#define SRP_RPORT_ATTRS 2
+#define SRP_RPORT_ATTRS 3
 
 struct srp_internal {
 	struct scsi_transport_template t;
@@ -116,6 +117,158 @@ show_srp_rport_roles(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(roles, S_IRUGO, show_srp_rport_roles, NULL);
 
+static ssize_t show_srp_rport_recovery_tmo(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+
+	return sprintf(buf, "%d\n", rport->recovery_tmo);
+}
+
+static ssize_t store_srp_rport_recovery_tmo(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct srp_rport *rport = transport_class_to_srp_rport(dev);
+	char ch[16];
+	int res;
+	int recovery_tmo;
+
+	sprintf(ch, "%.*s", (int)min(sizeof(ch) - 1, count), buf);
+	res = kstrtoint(ch, 0, &recovery_tmo);
+	if (res)
+		goto out;
+	rport->recovery_tmo = recovery_tmo;
+	if (recovery_tmo > 0 && rport->state == SRP_RPORT_BLOCKED)
+		queue_delayed_work(system_long_wq, &rport->recovery_work,
+				   recovery_tmo * HZ);
+	else if (recovery_tmo <= 0)
+		cancel_delayed_work(&rport->recovery_work);
+	res = count;
+out:
+	return res;
+}
+
+static DEVICE_ATTR(recovery_tmo, S_IRUGO | S_IWUSR, show_srp_rport_recovery_tmo,
+		   store_srp_rport_recovery_tmo);
+
+/**
+ * rport_recovery_timedout() - Transport layer recovery timeout handler.
+ *
+ * If rport->ft->rport_recovery_timedout is not NULL, invoke that function.
+ * Otherwise unblock the SCSI host.
+ *
+ * Note: rport->ft->rport_recovery_timedout must either unblock or remove the
+ * SCSI host.
+ */
+static void rport_recovery_timedout(struct work_struct *work)
+{
+	struct srp_rport *rport;
+
+	rport = container_of(to_delayed_work(work), struct srp_rport,
+			     recovery_work);
+
+	pr_debug("rport %p recovery timed out after %d secs\n", rport,
+		 rport->recovery_tmo);
+
+	BUG_ON(!rport->ft);
+
+	if (rport->state == SRP_RPORT_BLOCKED &&
+	    rport->ft->rport_recovery_timedout) {
+		rport->ft->rport_recovery_timedout(rport);
+	}
+}
+
+/**
+ * srp_unblock_rport() - Unblock an rport.
+ */
+void srp_unblock_rport(struct srp_rport *rport)
+{
+	unsigned long flags;
+	enum srp_rport_state prev_state;
+	bool unblock = false;
+
+	pr_debug("Trying to unblock rport %p\n", rport);
+
+	spin_lock_irqsave(&rport->lock, flags);
+	prev_state = rport->state;
+	if (prev_state == SRP_RPORT_BLOCKED) {
+		rport->state = SRP_RPORT_LIVE;
+		unblock = true;
+	}
+	spin_unlock_irqrestore(&rport->lock, flags);
+
+	if (!unblock) {
+		pr_debug("Not unblocking rport %p because it is in state %d\n",
+			 rport, prev_state);
+		return;
+	}
+
+	cancel_delayed_work(&rport->recovery_work);
+	scsi_target_unblock(rport->dev.parent);
+
+	pr_debug("Completed unblocking rport %p\n", rport);
+}
+EXPORT_SYMBOL(srp_unblock_rport);
+
+/**
+ * srp_block_rport() - Block an rport.
+ */
+void srp_block_rport(struct srp_rport *rport)
+{
+	unsigned long flags;
+	bool block = false;
+
+	pr_debug("Blocking rport %p\n", rport);
+
+	spin_lock_irqsave(&rport->lock, flags);
+	if (rport->state == SRP_RPORT_LIVE) {
+		rport->state = SRP_RPORT_BLOCKED;
+		block = true;
+	}
+	spin_unlock_irqrestore(&rport->lock, flags);
+
+	scsi_target_block(rport->dev.parent);
+
+	pr_debug("Completed blocking rport %p\n", rport);
+}
+EXPORT_SYMBOL(srp_block_rport);
+
+/**
+ * srp_start_recovery_timer() - Start the rport transport layer recovery timer.
+ */
+void srp_start_recovery_timer(struct srp_rport *rport)
+{
+	WARN_ON(rport->state != SRP_RPORT_BLOCKED);
+
+	if (rport->recovery_tmo >= 0)
+		queue_delayed_work(system_long_wq, &rport->recovery_work,
+				   rport->recovery_tmo * HZ);
+}
+EXPORT_SYMBOL(srp_start_recovery_timer);
+
+/**
+ * srp_rport_disable_recovery() - Disable the transport layer recovery timer.
+ */
+void srp_rport_disable_recovery(struct srp_rport *rport)
+{
+	struct device *dev = rport->dev.parent;
+
+	device_remove_file(dev, &dev_attr_recovery_tmo);
+	cancel_delayed_work_sync(&rport->recovery_work);
+}
+EXPORT_SYMBOL(srp_rport_disable_recovery);
+
+/**
+ * srp_stop_rport() - Stop asynchronous work for an rport.
+ */
+void srp_stop_rport(struct srp_rport *rport)
+{
+	srp_rport_disable_recovery(rport);
+}
+EXPORT_SYMBOL(srp_stop_rport);
+
 static void srp_rport_release(struct device *dev)
 {
 	struct srp_rport *rport = dev_to_rport(dev);
@@ -192,6 +345,11 @@ struct srp_rport *srp_rport_add(struct Scsi_Host *shost,
 	memcpy(rport->port_id, ids->port_id, sizeof(rport->port_id));
 	rport->roles = ids->roles;
 
+	rport->recovery_tmo = 120;
+	INIT_DELAYED_WORK(&rport->recovery_work, rport_recovery_timedout);
+	spin_lock_init(&rport->lock);
+	rport->state = SRP_RPORT_LIVE;
+
 	id = atomic_inc_return(&to_srp_host_attrs(shost)->next_port_id);
 	dev_set_name(&rport->dev, "port-%d:%d", shost->host_no, id);
 
@@ -309,6 +467,8 @@ srp_attach_transport(struct srp_function_template *ft)
 	count = 0;
 	i->rport_attrs[count++] = &dev_attr_port_id;
 	i->rport_attrs[count++] = &dev_attr_roles;
+	if (ft->rport_recovery_timedout)
+		i->rport_attrs[count++] = &dev_attr_recovery_tmo;
 	i->rport_attrs[count++] = NULL;
 	WARN_ON(count > ARRAY_SIZE(i->rport_attrs));
 
diff --git a/include/scsi/scsi_transport_srp.h b/include/scsi/scsi_transport_srp.h
index 9c60ca1..fcda8e3 100644
--- a/include/scsi/scsi_transport_srp.h
+++ b/include/scsi/scsi_transport_srp.h
@@ -8,19 +8,45 @@
 #define SRP_RPORT_ROLE_INITIATOR 0
 #define SRP_RPORT_ROLE_TARGET 1
 
+/**
+ * enum srp_rport_state - Rport state.
+ * SRP_RPORT_LIVE: SCSI host logged in.
+ * SRP_RPORT_BLOCKED: SCSI host blocked because of a transport layer issue.
+ */
+enum srp_rport_state {
+	SRP_RPORT_LIVE,
+	SRP_RPORT_BLOCKED,
+};
+
 struct srp_rport_identifiers {
 	u8 port_id[16];
 	u8 roles;
 };
 
 struct srp_rport {
+	/* for initiator and target drivers */
+
+	struct srp_function_template *ft;
+
 	struct device dev;
 
 	u8 port_id[16];
 	u8 roles;
+
+	/* for initiator drivers */
+
+	void			*lld_data;	/* LLD private data */
+
+	spinlock_t		lock;
+	enum srp_rport_state	state;
+
+	int			recovery_tmo;
+	struct delayed_work	recovery_work;
 };
 
 struct srp_function_template {
+	/* for initiator drivers */
+	void (*rport_recovery_timedout) (struct srp_rport *rport);
 	/* for target drivers */
 	int (* tsk_mgmt_response)(struct Scsi_Host *, u64, u64, int);
 	int (* it_nexus_response)(struct Scsi_Host *, u64, int);
@@ -33,6 +59,11 @@ extern void srp_release_transport(struct scsi_transport_template *);
 extern struct srp_rport *srp_rport_add(struct Scsi_Host *,
 				       struct srp_rport_identifiers *);
 extern void srp_rport_del(struct srp_rport *);
+extern void srp_unblock_rport(struct srp_rport *rport);
+extern void srp_block_rport(struct srp_rport *rport);
+extern void srp_start_recovery_timer(struct srp_rport *rport);
+extern void srp_rport_disable_recovery(struct srp_rport *rport);
+extern void srp_stop_rport(struct srp_rport *rport);
 
 extern void srp_remove_host(struct Scsi_Host *);
 
-- 
1.7.3.4

