From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 7/8] IB/srp: stop sharing the host lock with SCSI
Date: Thu, 23 Dec 2010 16:31:32 -0500
Message-ID: <1293139893-11678-8-git-send-email-dillowda@ornl.gov>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

We don't need protection against the SCSI stack, so use our own lock to
allow parallel progress on separate CPUs.

This is a break-out of Bart Van Assche's work.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   42 +++++++++++++++++-----------------
 drivers/infiniband/ulp/srp/ib_srp.h |    2 +
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 4e8ae59..fff72c8 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -447,12 +447,12 @@ static bool srp_change_state(struct srp_target_port *target,
 {
 	int changed = false;
 
-	spin_lock_irq(target->scsi_host->host_lock);
+	spin_lock_irq(&target->lock);
 	if (target->state == old) {
 		target->state = new;
 		changed = true;
 	}
-	spin_unlock_irq(target->scsi_host->host_lock);
+	spin_unlock_irq(&target->lock);
 	return changed;
 }
 
@@ -555,11 +555,11 @@ static void srp_remove_req(struct srp_target_port *target,
 	unsigned long flags;
 
 	srp_unmap_data(req->scmnd, target, req);
-	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&target->lock, flags);
 	target->req_lim += req_lim_delta;
 	req->scmnd = NULL;
 	list_move_tail(&req->list, &target->free_reqs);
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&target->lock, flags);
 }
 
 static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
@@ -634,13 +634,13 @@ err:
 	 * Schedule our work inside the lock to avoid a race with
 	 * the flush_scheduled_work() in srp_remove_one().
 	 */
-	spin_lock_irq(target->scsi_host->host_lock);
+	spin_lock_irq(&target->lock);
 	if (target->state == SRP_TARGET_CONNECTING) {
 		target->state = SRP_TARGET_DEAD;
 		INIT_WORK(&target->work, srp_remove_work);
 		schedule_work(&target->work);
 	}
-	spin_unlock_irq(target->scsi_host->host_lock);
+	spin_unlock_irq(&target->lock);
 
 	return ret;
 }
@@ -829,17 +829,16 @@ static void srp_put_tx_iu(struct srp_target_port *target, struct srp_iu *iu,
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&target->lock, flags);
 	list_add(&iu->list, &target->free_tx);
 	if (iu_type != SRP_IU_RSP)
 		++target->req_lim;
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&target->lock, flags);
 }
 
 /*
- * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and free_tx.  If IU is not sent, it must be returned using
- * srp_put_tx_iu().
+ * Must be called with target->lock held to protect req_lim and free_tx.
+ * If IU is not sent, it must be returned using srp_put_tx_iu().
  *
  * Note:
  * An upper limit for the number of allocated information units for each
@@ -958,10 +957,10 @@ static int srp_response_common(struct srp_target_port *target, s32 req_delta,
 	struct srp_iu *iu;
 	int err;
 
-	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+	spin_lock_irqsave(&target->lock, flags);
 	target->req_lim += req_delta;
 	iu = __srp_get_tx_iu(target, SRP_IU_RSP);
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+	spin_unlock_irqrestore(&target->lock, flags);
 
 	if (!iu) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX
@@ -1126,7 +1125,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 		return 0;
 	}
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&target->lock, flags);
 	/* This goes away once the scsi_eh routines stop testing it. */
 	scsi_cmd_get_serial(shost, scmnd);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
@@ -1135,7 +1134,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 				      list);
 		list_del_init(&req->list);
 	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&target->lock, flags);
 
 	if (!iu)
 		goto err;
@@ -1181,9 +1180,9 @@ err_unmap:
 err_iu:
 	srp_put_tx_iu(target, iu, SRP_IU_CMD);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irqsave(&target->lock, flags);
 	list_add(&req->list, &target->free_reqs);
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irqrestore(&target->lock, flags);
 
 err:
 	return SCSI_MLQUEUE_HOST_BUSY;
@@ -1449,9 +1448,9 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	init_completion(&target->tsk_mgmt_done);
 
-	spin_lock_irq(target->scsi_host->host_lock);
+	spin_lock_irq(&target->lock);
 	iu = __srp_get_tx_iu(target, SRP_IU_TSK_MGMT);
-	spin_unlock_irq(target->scsi_host->host_lock);
+	spin_unlock_irq(&target->lock);
 
 	if (!iu)
 		return -1;
@@ -1955,6 +1954,7 @@ static ssize_t srp_create_target(struct device *dev,
 	target->scsi_host  = target_host;
 	target->srp_host   = host;
 
+	spin_lock_init(&target->lock);
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
@@ -2184,9 +2184,9 @@ static void srp_remove_one(struct ib_device *device)
 		 */
 		spin_lock(&host->target_lock);
 		list_for_each_entry(target, &host->target_list, list) {
-			spin_lock_irq(target->scsi_host->host_lock);
+			spin_lock_irq(&target->lock);
 			target->state = SRP_TARGET_REMOVED;
-			spin_unlock_irq(target->scsi_host->host_lock);
+			spin_unlock_irq(&target->lock);
 		}
 		spin_unlock(&host->target_lock);
 
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index e2b1719..c4699ea 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -144,6 +144,8 @@ struct srp_target_port {
 
 	struct srp_iu	       *rx_ring[SRP_RQ_SIZE];
 
+	spinlock_t		lock;
+
 	struct list_head	free_tx;
 	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
