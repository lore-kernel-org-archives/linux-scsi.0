From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 4/8] IB/srp: don't move active requests to their own list
Date: Thu, 23 Dec 2010 16:31:29 -0500
Message-ID: <1293139893-11678-5-git-send-email-dillowda@ornl.gov>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

We use req->scmnd != NULL to indicate an active request, so there's no
need to keep a separate list for them. We can afford the array iteration
during error handling, and dropping it gives us one less item that needs
lock protection.

This is a break-out and slight cleanup of Bart Van Assche's work.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   17 ++++++++++-------
 drivers/infiniband/ulp/srp/ib_srp.h |    1 -
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 6d98217..fcc8702 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -566,7 +566,6 @@ static void srp_reset_req(struct srp_target_port *target, struct srp_request *re
 static int srp_reconnect_target(struct srp_target_port *target)
 {
 	struct ib_qp_attr qp_attr;
-	struct srp_request *req, *tmp;
 	struct ib_wc wc;
 	int i, ret;
 
@@ -597,8 +596,11 @@ static int srp_reconnect_target(struct srp_target_port *target)
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
@@ -1165,7 +1167,7 @@ static int srp_queuecommand_lck(struct scsi_cmnd *scmnd,
 		goto err_unmap;
 	}
 
-	list_move_tail(&req->list, &target->req_queue);
+	list_del_init(&req->list);
 
 	return 0;
 
@@ -1505,7 +1507,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 static int srp_reset_device(struct scsi_cmnd *scmnd)
 {
 	struct srp_target_port *target = host_to_target(scmnd->device->host);
-	struct srp_request *req, *tmp;
+	int i;
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
@@ -1519,9 +1521,11 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	spin_lock_irq(target->scsi_host->host_lock);
 
-	list_for_each_entry_safe(req, tmp, &target->req_queue, list)
+	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
+		struct srp_request *req = &target->req_ring[i];
 		if (req->scmnd && req->scmnd->device == scmnd->device)
 			srp_reset_req(target, req);
+	}
 
 	spin_unlock_irq(target->scsi_host->host_lock);
 
@@ -1955,7 +1959,6 @@ static ssize_t srp_create_target(struct device *dev,
 
 	INIT_LIST_HEAD(&target->free_tx);
 	INIT_LIST_HEAD(&target->free_reqs);
-	INIT_LIST_HEAD(&target->req_queue);
 	for (i = 0; i < SRP_CMD_SQ_SIZE; ++i) {
 		target->req_ring[i].index = i;
 		list_add_tail(&target->req_ring[i].list, &target->free_reqs);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index 0db525e..b3808dd 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -148,7 +148,6 @@ struct srp_target_port {
 	struct srp_iu	       *tx_ring[SRP_SQ_SIZE];
 
 	struct list_head	free_reqs;
-	struct list_head	req_queue;
 	struct srp_request	req_ring[SRP_CMD_SQ_SIZE];
 
 	struct work_struct	work;
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
