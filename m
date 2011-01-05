From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH v2 5/8] IB/srp: reduce local coverage for command submission and EH
Date: Wed,  5 Jan 2011 15:35:13 -0500
Message-ID: <1294259716-30706-6-git-send-email-dillowda@ornl.gov>
References: <1294259716-30706-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294259716-30706-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

We only need locks to protect our lists and number of credits available.
By pre-consuming the credit for the request, we can reduce our lock
coverage to just those areas. If we don't actually send the request,
we'll need to put the credit back into the pool.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
[ broken out and small cleanups by David Dillow ]
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |  124 +++++++++++++++++++----------------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 -
 2 files changed, 67 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6f36dbe..d320dd4 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -818,9 +818,24 @@ static int srp_map_data(struct scsi_cmnd *scmnd, struct srp_target_port *target,
 }
 
 /*
+ * Return an IU and possible credit to the free pool
+ */
+static void srp_put_tx_iu(struct srp_target_port *target, struct srp_iu *iu,
+			  enum srp_iu_type iu_type)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(target->scsi_host->host_lock, flags);
+	list_add(&iu->list, &target->free_tx);
+	if (iu_type != SRP_IU_RSP)
+		++target->req_lim;
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+}
+
+/*
  * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and free_tx.  Lock cannot be dropped between call here and
- * call to __srp_post_send().
+ * req_lim and free_tx.  If IU is not sent, it must be returned using
+ * srp_put_tx_iu().
  *
  * Note:
  * An upper limit for the number of allocated information units for each
@@ -843,26 +858,25 @@ static struct srp_iu *__srp_get_tx_iu(struct srp_target_port *target,
 		return NULL;
 
 	/* Initiator responses to target requests do not consume credits */
-	if (target->req_lim <= rsv && iu_type != SRP_IU_RSP) {
-		++target->zero_req_lim;
-		return NULL;
+	if (iu_type != SRP_IU_RSP) {
+		if (target->req_lim <= rsv) {
+			++target->zero_req_lim;
+			return NULL;
+		}
+
+		--target->req_lim;
 	}
 
 	iu = list_first_entry(&target->free_tx, struct srp_iu, list);
-	iu->type = iu_type;
+	list_del(&iu->list);
 	return iu;
 }
 
-/*
- * Must be called with target->scsi_host->host_lock held to protect
- * req_lim and free_tx.
- */
-static int __srp_post_send(struct srp_target_port *target,
-			   struct srp_iu *iu, int len)
+static int srp_post_send(struct srp_target_port *target,
+			 struct srp_iu *iu, int len)
 {
 	struct ib_sge list;
 	struct ib_send_wr wr, *bad_wr;
-	int ret = 0;
 
 	list.addr   = iu->dma;
 	list.length = len;
@@ -875,15 +889,7 @@ static int __srp_post_send(struct srp_target_port *target,
 	wr.opcode     = IB_WR_SEND;
 	wr.send_flags = IB_SEND_SIGNALED;
 
-	ret = ib_post_send(target->qp, &wr, &bad_wr);
-
-	if (!ret) {
-		list_del(&iu->list);
-		if (iu->type != SRP_IU_RSP)
-			--target->req_lim;
-	}
-
-	return ret;
+	return ib_post_send(target->qp, &wr, &bad_wr);
 }
 
 static int srp_post_recv(struct srp_target_port *target, struct srp_iu *iu)
@@ -953,34 +959,33 @@ static void srp_process_rsp(struct srp_target_port *target, struct srp_rsp *rsp)
 static int srp_response_common(struct srp_target_port *target, s32 req_delta,
 			       void *rsp, int len)
 {
-	struct ib_device *dev;
+	struct ib_device *dev = target->srp_host->srp_dev->dev;
 	unsigned long flags;
 	struct srp_iu *iu;
-	int err = 1;
-
-	dev = target->srp_host->srp_dev->dev;
+	int err;
 
 	spin_lock_irqsave(target->scsi_host->host_lock, flags);
 	target->req_lim += req_delta;
-
 	iu = __srp_get_tx_iu(target, SRP_IU_RSP);
+	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
+
 	if (!iu) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX
 			     "no IU available to send response\n");
-		goto out;
+		return 1;
 	}
 
 	ib_dma_sync_single_for_cpu(dev, iu->dma, len, DMA_TO_DEVICE);
 	memcpy(iu->buf, rsp, len);
 	ib_dma_sync_single_for_device(dev, iu->dma, len, DMA_TO_DEVICE);
 
-	err = __srp_post_send(target, iu, len);
-	if (err)
+	err = srp_post_send(target, iu, len);
+	if (err) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX
 			     "unable to post response: %d\n", err);
+		srp_put_tx_iu(target, iu, SRP_IU_RSP);
+	}
 
-out:
-	spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 	return err;
 }
 
@@ -1107,14 +1112,14 @@ static void srp_send_completion(struct ib_cq *cq, void *target_ptr)
 	}
 }
 
-static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
-			    void (*done)(struct scsi_cmnd *))
+static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 {
-	struct srp_target_port *target = host_to_target(scmnd->device->host);
+	struct srp_target_port *target = host_to_target(shost);
 	struct srp_request *req;
 	struct srp_iu *iu;
 	struct srp_cmd *cmd;
 	struct ib_device *dev;
+	unsigned long flags;
 	int len;
 
 	if (target->state == SRP_TARGET_CONNECTING)
@@ -1123,11 +1128,19 @@ static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
 	if (target->state == SRP_TARGET_DEAD ||
 	    target->state == SRP_TARGET_REMOVED) {
 		scmnd->result = DID_BAD_TARGET << 16;
-		done(scmnd);
+		scmnd->scsi_done(scmnd);
 		return 0;
 	}
 
+	spin_lock_irqsave(shost->host_lock, flags);
 	iu = __srp_get_tx_iu(target, SRP_IU_CMD);
+	if (iu) {
+		req = list_first_entry(&target->free_reqs, struct srp_request,
+				      list);
+		list_del(&req->list);
+	}
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 	if (!iu)
 		goto err;
 
@@ -1135,9 +1148,6 @@ static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
 	ib_dma_sync_single_for_cpu(dev, iu->dma, srp_max_iu_len,
 				   DMA_TO_DEVICE);
 
-	req = list_first_entry(&target->free_reqs, struct srp_request, list);
-
-	scmnd->scsi_done     = done;
 	scmnd->result        = 0;
 	scmnd->host_scribble = (void *) req;
 
@@ -1156,30 +1166,33 @@ static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
 	if (len < 0) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Failed to map data\n");
-		goto err;
+		goto err_iu;
 	}
 
 	ib_dma_sync_single_for_device(dev, iu->dma, srp_max_iu_len,
 				      DMA_TO_DEVICE);
 
-	if (__srp_post_send(target, iu, len)) {
+	if (srp_post_send(target, iu, len)) {
 		shost_printk(KERN_ERR, target->scsi_host, PFX "Send failed\n");
 		goto err_unmap;
 	}
 
-	list_del(&req->list);
-
 	return 0;
 
 err_unmap:
 	srp_unmap_data(scmnd, target, req);
 
+err_iu:
+	srp_put_tx_iu(target, iu, SRP_IU_CMD);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_add(&req->list, &target->free_reqs);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
 err:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static DEF_SCSI_QCMD(srp_queuecommand)
-
 static int srp_alloc_iu_bufs(struct srp_target_port *target)
 {
 	int i;
@@ -1433,17 +1446,18 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	spin_lock_irq(target->scsi_host->host_lock);
-
 	if (target->state == SRP_TARGET_DEAD ||
 	    target->state == SRP_TARGET_REMOVED)
-		goto out;
+		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
 
+	spin_lock_irq(target->scsi_host->host_lock);
 	iu = __srp_get_tx_iu(target, SRP_IU_TSK_MGMT);
+	spin_unlock_irq(target->scsi_host->host_lock);
+
 	if (!iu)
-		goto out;
+		return -1;
 
 	ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mgmt,
 				   DMA_TO_DEVICE);
@@ -1458,20 +1472,16 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 
 	ib_dma_sync_single_for_device(dev, iu->dma, sizeof *tsk_mgmt,
 				      DMA_TO_DEVICE);
-	if (__srp_post_send(target, iu, sizeof *tsk_mgmt))
-		goto out;
-
-	spin_unlock_irq(target->scsi_host->host_lock);
+	if (srp_post_send(target, iu, sizeof *tsk_mgmt)) {
+		srp_put_tx_iu(target, iu, SRP_IU_TSK_MGMT);
+		return -1;
+	}
 
 	if (!wait_for_completion_timeout(&target->tsk_mgmt_done,
 					 msecs_to_jiffies(SRP_ABORT_TIMEOUT_MS)))
 		return -1;
 
 	return 0;
-
-out:
-	spin_unlock_irq(target->scsi_host->host_lock);
-	return -1;
 }
 
 static int srp_abort(struct scsi_cmnd *scmnd)
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 924d8e9..81686ee 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -168,7 +168,6 @@ struct srp_iu {
 	void		       *buf;
 	size_t			size;
 	enum dma_data_direction	direction;
-	enum srp_iu_type	type;
 };
 
 #endif /* IB_SRP_H */
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
