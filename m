From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH 02/11] IB/srp: simplify state tracking
Date: Sun, 25 Nov 2012 23:44:07 -0500
Message-ID: <6f9ad200f981a2fe49319e7437c842f03063a4f1.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:38059 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab2KZEzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2012 23:55:09 -0500
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, bvanassche@acm.org, roland@purestorage.com

The state of the target has several conditions that overlap, making it
easier to model as a bit-field of exceptional conditions rather than an
enum of all possible states.

Bart Van Assche did the hard work of identifying the states that can be
removed, and did a first patch that consolidated the state space.

Needs-to-be-signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Dillow <dillowda@ornl.gov>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  146 +++++++++++++++++------------------
 drivers/infiniband/ulp/srp/ib_srp.h |   11 +--
 2 files changed, 76 insertions(+), 81 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6c0cd66..1e8ce81 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -102,6 +102,34 @@ static struct ib_client srp_client = {
 
 static struct ib_sa_client srp_sa_client;
 
+static inline void srp_mark_connected(struct srp_target_port *target)
+{
+	smp_mb__before_clear_bit();
+	clear_bit(SRP_STATE_ERROR, &target->state);
+	clear_bit(SRP_STATE_DISCONNECTED, &target->state);
+	smp_mb__after_clear_bit();
+}
+
+static inline bool srp_mark_disconnected(struct srp_target_port *target)
+{
+	return test_and_set_bit(SRP_STATE_DISCONNECTED, &target->state);
+}
+
+static inline bool srp_is_disconnected(struct srp_target_port *target)
+{
+	return ACCESS_ONCE(target->state) & (1UL << SRP_STATE_DISCONNECTED);
+}
+
+static inline bool srp_is_removed(struct srp_target_port *target)
+{
+	return ACCESS_ONCE(target->state) & (1UL << SRP_STATE_REMOVED);
+}
+
+static inline bool srp_in_error(struct srp_target_port *target)
+{
+	return ACCESS_ONCE(target->state) & (1UL << SRP_STATE_ERROR);
+}
+
 static inline struct srp_target_port *host_to_target(struct Scsi_Host *host)
 {
 	return (struct srp_target_port *) host->hostdata;
@@ -430,6 +458,9 @@ static int srp_send_req(struct srp_target_port *target)
 
 static void srp_disconnect_target(struct srp_target_port *target)
 {
+	if (srp_mark_disconnected(target))
+		return;
+
 	/* XXX should send SRP_I_LOGOUT request */
 
 	init_completion(&target->done);
@@ -441,21 +472,6 @@ static void srp_disconnect_target(struct srp_target_port *target)
 	wait_for_completion(&target->done);
 }
 
-static bool srp_change_state(struct srp_target_port *target,
-			    enum srp_target_state old,
-			    enum srp_target_state new)
-{
-	bool changed = false;
-
-	spin_lock_irq(&target->lock);
-	if (target->state == old) {
-		target->state = new;
-		changed = true;
-	}
-	spin_unlock_irq(&target->lock);
-	return changed;
-}
-
 static void srp_free_req_data(struct srp_target_port *target)
 {
 	struct ib_device *ibdev = target->srp_host->srp_dev->dev;
@@ -494,9 +510,6 @@ static void srp_remove_work(struct work_struct *work)
 	struct srp_target_port *target =
 		container_of(work, struct srp_target_port, work);
 
-	if (!srp_change_state(target, SRP_TARGET_DEAD, SRP_TARGET_REMOVED))
-		return;
-
 	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
 	spin_unlock(&target->srp_host->target_lock);
@@ -504,12 +517,26 @@ static void srp_remove_work(struct work_struct *work)
 	srp_del_scsi_host_attr(target->scsi_host);
 	srp_remove_host(target->scsi_host);
 	scsi_remove_host(target->scsi_host);
+
+	/*
+	 * Now that we've removed our SCSI host, we will not see new requests
+	 * from the mid-layer. We can now clean up our IB resources.
+	 */
+	srp_disconnect_target(target);
 	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	srp_free_req_data(target);
 	scsi_host_put(target->scsi_host);
 }
 
+static void srp_queued_remove(struct srp_target_port *target)
+{
+	if (!test_and_set_bit(SRP_STATE_REMOVED, &target->state)) {
+		INIT_WORK(&target->work, srp_remove_work);
+		queue_work(ib_wq, &target->work);
+	}
+}
+
 static int srp_connect_target(struct srp_target_port *target)
 {
 	int retries = 3;
@@ -650,7 +677,7 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	struct ib_wc wc;
 	int i, ret;
 
-	if (!srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_CONNECTING))
+	if (srp_is_removed(target))
 		return -EAGAIN;
 
 	srp_disconnect_target(target);
@@ -686,13 +713,11 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
 		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
-	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
 	if (ret)
 		goto err;
 
-	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE))
-		ret = -EAGAIN;
+	srp_mark_connected(target);
 
 	return ret;
 
@@ -705,17 +730,8 @@ err:
 	 * However, we have to defer the real removal because we
 	 * are in the context of the SCSI error handler now, which
 	 * will deadlock if we call scsi_remove_host().
-	 *
-	 * Schedule our work inside the lock to avoid a race with
-	 * the flush_scheduled_work() in srp_remove_one().
 	 */
-	spin_lock_irq(&target->lock);
-	if (target->state == SRP_TARGET_CONNECTING) {
-		target->state = SRP_TARGET_DEAD;
-		INIT_WORK(&target->work, srp_remove_work);
-		queue_work(ib_wq, &target->work);
-	}
-	spin_unlock_irq(&target->lock);
+	srp_queued_remove(target);
 
 	return ret;
 }
@@ -1273,7 +1289,7 @@ static void srp_recv_completion(struct ib_cq *cq, void *target_ptr)
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "failed receive status %d\n",
 				     wc.status);
-			target->qp_in_error = 1;
+			set_bit(SRP_STATE_ERROR, &target->state);
 			break;
 		}
 
@@ -1292,7 +1308,7 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "failed send status %d\n",
 				     wc.status);
-			target->qp_in_error = 1;
+			set_bit(SRP_STATE_ERROR, &target->state);
 			break;
 		}
 
@@ -1311,14 +1327,15 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	unsigned long flags;
 	int len;
 
-	if (target->state == SRP_TARGET_CONNECTING)
-		goto err;
+	if (unlikely(target->state)) {
+		if (srp_is_disconnected(target))
+			goto err;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED) {
-		scmnd->result = DID_BAD_TARGET << 16;
-		scmnd->scsi_done(scmnd);
-		return 0;
+		if (srp_is_removed(target)) {
+			scmnd->result = DID_BAD_TARGET << 16;
+			scmnd->scsi_done(scmnd);
+			return 0;
+		}
 	}
 
 	spin_lock_irqsave(&target->lock, flags);
@@ -1628,6 +1645,7 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 	case IB_CM_DREQ_RECEIVED:
 		shost_printk(KERN_WARNING, target->scsi_host,
 			     PFX "DREQ received - connection closed\n");
+		srp_mark_disconnected(target);
 		if (ib_send_cm_drep(cm_id, NULL, 0))
 			shost_printk(KERN_ERR, target->scsi_host,
 				     PFX "Sending CM DREP failed\n");
@@ -1665,8 +1683,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (target->state == SRP_TARGET_DEAD ||
-	    target->state == SRP_TARGET_REMOVED)
+	if (srp_is_removed(target))
 		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
@@ -1710,7 +1727,9 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (!req || target->qp_in_error || !srp_claim_req(target, req, scmnd))
+	if (srp_in_error(target))
+		return FAILED;
+	if (!req || !srp_claim_req(target, req, scmnd))
 		return FAILED;
 	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
 			  SRP_TSK_ABORT_TASK);
@@ -1728,7 +1747,7 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
-	if (target->qp_in_error)
+	if (srp_in_error(target))
 		return FAILED;
 	if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
 			      SRP_TSK_LUN_RESET))
@@ -1943,7 +1962,7 @@ static int srp_add_target(struct srp_host *host, struct srp_target_port *target)
 	list_add_tail(&target->list, &host->target_list);
 	spin_unlock(&host->target_lock);
 
-	target->state = SRP_TARGET_LIVE;
+	srp_mark_connected(target);
 
 	scsi_scan_target(&target->scsi_host->shost_gendev,
 			 0, target->scsi_id, SCAN_WILD_CARD, 0);
@@ -2207,6 +2226,7 @@ static ssize_t srp_create_target(struct device *dev,
 
 	target = host_to_target(target_host);
 
+	target->state		= 1UL << SRP_STATE_DISCONNECTED;
 	target->io_class	= SRP_REV16A_IB_IO_CLASS;
 	target->scsi_host	= target_host;
 	target->srp_host	= host;
@@ -2277,7 +2297,6 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret)
 		goto err_free_ib;
 
-	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
 	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host,
@@ -2467,8 +2486,7 @@ static void srp_remove_one(struct ib_device *device)
 {
 	struct srp_device *srp_dev;
 	struct srp_host *host, *tmp_host;
-	LIST_HEAD(target_list);
-	struct srp_target_port *target, *tmp_target;
+	struct srp_target_port *target;
 
 	srp_dev = ib_get_client_data(device, &srp_client);
 
@@ -2481,36 +2499,14 @@ static void srp_remove_one(struct ib_device *device)
 		wait_for_completion(&host->released);
 
 		/*
-		 * Mark all target ports as removed, so we stop queueing
-		 * commands and don't try to reconnect.
+		 * Initiate removal of our targets, and wait for that to
+		 * complete.
 		 */
 		spin_lock(&host->target_lock);
-		list_for_each_entry(target, &host->target_list, list) {
-			spin_lock_irq(&target->lock);
-			target->state = SRP_TARGET_REMOVED;
-			spin_unlock_irq(&target->lock);
-		}
+		list_for_each_entry(target, &host->target_list, list)
+			srp_queued_remove(target);
 		spin_unlock(&host->target_lock);
-
-		/*
-		 * Wait for any reconnection tasks that may have
-		 * started before we marked our target ports as
-		 * removed, and any target port removal tasks.
-		 */
 		flush_workqueue(ib_wq);
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
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e3a6304..750ba47 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -78,11 +78,10 @@ enum {
 	SRP_MAP_NO_FMR		= 1,
 };
 
-enum srp_target_state {
-	SRP_TARGET_LIVE,
-	SRP_TARGET_CONNECTING,
-	SRP_TARGET_DEAD,
-	SRP_TARGET_REMOVED
+enum srp_state_bits {
+	SRP_STATE_REMOVED	= 0,
+	SRP_STATE_DISCONNECTED	= 1,
+	SRP_STATE_ERROR		= 2,
 };
 
 enum srp_iu_type {
@@ -137,7 +136,7 @@ struct srp_target_port {
 	struct ib_qp	       *qp;
 	u32			lkey;
 	u32			rkey;
-	enum srp_target_state	state;
+	unsigned long		state;
 	unsigned int		max_iu_len;
 	unsigned int		cmd_sg_cnt;
 	unsigned int		indirect_size;
-- 
1.7.7.6

