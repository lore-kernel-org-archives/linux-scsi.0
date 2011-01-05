From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH v2 4/8] IB/srp: don't move active requests to their own list
Date: Wed,  5 Jan 2011 15:35:12 -0500
Message-ID: <1294259716-30706-5-git-send-email-dillowda@ornl.gov>
References: <1294259716-30706-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294259716-30706-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>

We use req->scmnd != NULL to indicate an active request, so there's no
need to keep a separate list for them. We can afford the array iteration
during error handling, and dropping it gives us one less item that needs
lock protection.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
[ broken out and small cleanups by David Dillow ]
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   21 ++++++++++++---------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 -
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index aa78d26..6f36dbe 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -553,7 +553,7 @@ static void srp_remove_req(struct srp_target_port *target, struct srp_request *r
 {
 	srp_unmap_data(req->scmnd, target, req);
 	req->scmnd = NULL;
-	list_move_tail(&req->list, &target->free_reqs);
+	list_add_tail(&req->list, &target->free_reqs);
 }
 
 static void srp_reset_req(struct srp_target_port *target, struct srp_request *req)
@@ -566,7 +566,6 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct ib_qp_attr qp_attr;
-	struct srp_request *req, *tmp;
 	struct ib_wc wc;
 	int i, ret;
 
@@ -597,13 +596,16 @@ static int srp_reconnect_target(struct srp_target_port *target)
 		; /* nothing */
 
 	spin_lock_irq(target->scsi_host->host_lock);
-	list_for_each_entry_safe(req, tmp, &target->req_queue, list)
-		srp_reset_req(target, req);
+	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+		struct srp_request *req = &target->req_ring[i];
+		if (req->scmnd)
+			srp_reset_req(target, req);
+	}
 	spin_unlock_irq(target->scsi_host->host_lock);
 
 	list_del_init(&target->free_tx);
 	for (i = 0; i < SRP_SQ_SIZE; ++i)
-		list_move(&target->tx_ring[i]->list, &target->free_tx);
+		list_add(&target->tx_ring[i]->list, &target->free_tx);
 
 	target->qp_in_error = 0;
 	ret = srp_connect_target(target);
@@ -1165,7 +1167,7 @@ static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
 		goto err_unmap;
 	}
 
-	list_move_tail(&req->list, &target->req_queue);
+	list_del(&req->list);
 
 	return 0;
 
@@ -1504,7 +1506,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 static int srp_reset_device(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	struct srp_request *req, *tmp;
+	int i;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
@@ -1518,9 +1520,11 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	spin_lock_irq(target->scsi_host->host_lock);
 
-	list_for_each_entry_safe(req, tmp, &target->req_queue, list)
+	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd && req->scmnd->device == scmnd->device)
 			srp_reset_req(target, req);
+	}
 
 	spin_unlock_irq(target->scsi_host->host_lock);
 
@@ -1954,7 +1958,6 @@ static ssize_t srp_create_target(struct device *dev,
 
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
-	INIT_LIST_HEAD(&target->req_queue);
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		target->req_ring[i].index = i;
 		list_add_tail(&target->req_ring[i].list, &target->free_reqs);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 41ecb46..924d8e9 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -148,7 +148,6 @@ struct srp_target_port {
 	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
 	struct list_head	free_reqs;
-	struct list_head	req_queue;
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
 	struct work_struct	work;
-- 
1.7.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
