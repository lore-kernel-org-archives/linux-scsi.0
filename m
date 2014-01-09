From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 03/11] IB/isert: Avoid frwr notation, user fastreg
Date: Thu,  9 Jan 2014 18:40:50 +0200
Message-ID: <1389285658-7037-4-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389285658-7037-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Use fast registration lingo. fast registration will
also incorporate signature/DIF registration.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   84 ++++++++++++++++---------------
 drivers/infiniband/ulp/isert/ib_isert.h |    8 ++--
 2 files changed, 47 insertions(+), 45 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 3dd2427..295d2be 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -47,10 +47,10 @@ static int
 isert_map_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	       struct isert_rdma_wr *wr);
 static void
-isert_unreg_rdma_frwr(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
+isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
 static int
-isert_reg_rdma_frwr(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-		    struct isert_rdma_wr *wr);
+isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+	       struct isert_rdma_wr *wr);
 
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
@@ -225,11 +225,11 @@ isert_create_device_ib_res(struct isert_device *device)
 
 	/* asign function handlers */
 	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
-		device->use_frwr = 1;
-		device->reg_rdma_mem = isert_reg_rdma_frwr;
-		device->unreg_rdma_mem = isert_unreg_rdma_frwr;
+		device->use_fastreg = 1;
+		device->reg_rdma_mem = isert_reg_rdma;
+		device->unreg_rdma_mem = isert_unreg_rdma;
 	} else {
-		device->use_frwr = 0;
+		device->use_fastreg = 0;
 		device->reg_rdma_mem = isert_map_rdma;
 		device->unreg_rdma_mem = isert_unmap_cmd;
 	}
@@ -237,9 +237,10 @@ isert_create_device_ib_res(struct isert_device *device)
 	device->cqs_used = min_t(int, num_online_cpus(),
 				 device->ib_device->num_comp_vectors);
 	device->cqs_used = min(ISERT_MAX_CQ, device->cqs_used);
-	pr_debug("Using %d CQs, device %s supports %d vectors support FRWR %d\n",
+	pr_debug("Using %d CQs, device %s supports %d vectors support "
+		 "Fast registration %d\n",
 		 device->cqs_used, device->ib_device->name,
-		 device->ib_device->num_comp_vectors, device->use_frwr);
+		 device->ib_device->num_comp_vectors, device->use_fastreg);
 	device->cq_desc = kzalloc(sizeof(struct isert_cq_desc) *
 				device->cqs_used, GFP_KERNEL);
 	if (!device->cq_desc) {
@@ -367,18 +368,18 @@ isert_device_find_by_ib_dev(struct rdma_cm_id *cma_id)
 }
 
 static void
-isert_conn_free_frwr_pool(struct isert_conn *isert_conn)
+isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 {
 	struct fast_reg_descriptor *fr_desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&isert_conn->conn_frwr_pool))
+	if (list_empty(&isert_conn->conn_fr_pool))
 		return;
 
-	pr_debug("Freeing conn %p frwr pool", isert_conn);
+	pr_debug("Freeing conn %p fastreg pool", isert_conn);
 
 	list_for_each_entry_safe(fr_desc, tmp,
-				 &isert_conn->conn_frwr_pool, list) {
+				 &isert_conn->conn_fr_pool, list) {
 		list_del(&fr_desc->list);
 		ib_free_fast_reg_page_list(fr_desc->data_frpl);
 		ib_dereg_mr(fr_desc->data_mr);
@@ -386,20 +387,20 @@ isert_conn_free_frwr_pool(struct isert_conn *isert_conn)
 		++i;
 	}
 
-	if (i < isert_conn->conn_frwr_pool_size)
+	if (i < isert_conn->conn_fr_pool_size)
 		pr_warn("Pool still has %d regions registered\n",
-			isert_conn->conn_frwr_pool_size - i);
+			isert_conn->conn_fr_pool_size - i);
 }
 
 static int
-isert_conn_create_frwr_pool(struct isert_conn *isert_conn)
+isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 {
 	struct fast_reg_descriptor *fr_desc;
 	struct isert_device *device = isert_conn->conn_device;
 	int i, ret;
 
-	INIT_LIST_HEAD(&isert_conn->conn_frwr_pool);
-	isert_conn->conn_frwr_pool_size = 0;
+	INIT_LIST_HEAD(&isert_conn->conn_fr_pool);
+	isert_conn->conn_fr_pool_size = 0;
 	for (i = 0; i < ISCSI_DEF_XMIT_CMDS_MAX; i++) {
 		fr_desc = kzalloc(sizeof(*fr_desc), GFP_KERNEL);
 		if (!fr_desc) {
@@ -431,17 +432,17 @@ isert_conn_create_frwr_pool(struct isert_conn *isert_conn)
 			 fr_desc, fr_desc->data_frpl->page_list);
 
 		fr_desc->valid = true;
-		list_add_tail(&fr_desc->list, &isert_conn->conn_frwr_pool);
-		isert_conn->conn_frwr_pool_size++;
+		list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
+		isert_conn->conn_fr_pool_size++;
 	}
 
-	pr_debug("Creating conn %p frwr pool size=%d",
-		 isert_conn, isert_conn->conn_frwr_pool_size);
+	pr_debug("Creating conn %p fastreg pool size=%d",
+		 isert_conn, isert_conn->conn_fr_pool_size);
 
 	return 0;
 
 err:
-	isert_conn_free_frwr_pool(isert_conn);
+	isert_conn_free_fastreg_pool(isert_conn);
 	return ret;
 }
 
@@ -544,11 +545,12 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out_mr;
 	}
 
-	if (device->use_frwr) {
-		ret = isert_conn_create_frwr_pool(isert_conn);
+	if (device->use_fastreg) {
+		ret = isert_conn_create_fastreg_pool(isert_conn);
 		if (ret) {
-			pr_err("Conn: %p failed to create frwr_pool\n", isert_conn);
-			goto out_frwr;
+			pr_err("Conn: %p failed to create fastreg pool\n",
+			       isert_conn);
+			goto out_fastreg;
 		}
 	}
 
@@ -565,9 +567,9 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	return 0;
 
 out_conn_dev:
-	if (device->use_frwr)
-		isert_conn_free_frwr_pool(isert_conn);
-out_frwr:
+	if (device->use_fastreg)
+		isert_conn_free_fastreg_pool(isert_conn);
+out_fastreg:
 	ib_dereg_mr(isert_conn->conn_mr);
 out_mr:
 	ib_dealloc_pd(isert_conn->conn_pd);
@@ -595,8 +597,8 @@ isert_connect_release(struct isert_conn *isert_conn)
 
 	pr_debug("Entering isert_connect_release(): >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
 
-	if (device && device->use_frwr)
-		isert_conn_free_frwr_pool(isert_conn);
+	if (device && device->use_fastreg)
+		isert_conn_free_fastreg_pool(isert_conn);
 
 	if (isert_conn->conn_qp) {
 		cq_index = ((struct isert_cq_desc *)
@@ -1394,25 +1396,25 @@ isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 }
 
 static void
-isert_unreg_rdma_frwr(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
+isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 {
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	LIST_HEAD(unmap_list);
 
-	pr_debug("unreg_frwr_cmd: %p\n", isert_cmd);
+	pr_debug("unreg_fastreg_cmd: %p\n", isert_cmd);
 
 	if (wr->fr_desc) {
-		pr_debug("unreg_frwr_cmd: %p free fr_desc %p\n",
+		pr_debug("unreg_fastreg_cmd: %p free fr_desc %p\n",
 			 isert_cmd, wr->fr_desc);
 		spin_lock_bh(&isert_conn->conn_lock);
-		list_add_tail(&wr->fr_desc->list, &isert_conn->conn_frwr_pool);
+		list_add_tail(&wr->fr_desc->list, &isert_conn->conn_fr_pool);
 		spin_unlock_bh(&isert_conn->conn_lock);
 		wr->fr_desc = NULL;
 	}
 
 	if (wr->sge) {
-		pr_debug("unreg_frwr_cmd: %p unmap_sg op\n", isert_cmd);
+		pr_debug("unreg_fastreg_cmd: %p unmap_sg op\n", isert_cmd);
 		ib_dma_unmap_sg(ib_dev, wr->sge, wr->num_sge,
 				(wr->iser_ib_op == ISER_IB_RDMA_WRITE) ?
 				DMA_TO_DEVICE : DMA_FROM_DEVICE);
@@ -2224,8 +2226,8 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 }
 
 static int
-isert_reg_rdma_frwr(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
-		    struct isert_rdma_wr *wr)
+isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
+	       struct isert_rdma_wr *wr)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
@@ -2303,7 +2305,7 @@ isert_reg_rdma_frwr(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		wr->fr_desc = NULL;
 	} else {
 		spin_lock_irqsave(&isert_conn->conn_lock, flags);
-		fr_desc = list_first_entry(&isert_conn->conn_frwr_pool,
+		fr_desc = list_first_entry(&isert_conn->conn_fr_pool,
 					   struct fast_reg_descriptor, list);
 		list_del(&fr_desc->list);
 		spin_unlock_irqrestore(&isert_conn->conn_lock, flags);
@@ -2312,7 +2314,7 @@ isert_reg_rdma_frwr(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		ret = isert_fast_reg_mr(fr_desc, isert_cmd, isert_conn,
 				  ib_sge, offset, data_len);
 		if (ret) {
-			list_add_tail(&fr_desc->list, &isert_conn->conn_frwr_pool);
+			list_add_tail(&fr_desc->list, &isert_conn->conn_fr_pool);
 			goto unmap_sg;
 		}
 	}
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index dec74d4..708a069 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -119,9 +119,9 @@ struct isert_conn {
 	wait_queue_head_t	conn_wait;
 	wait_queue_head_t	conn_wait_comp_err;
 	struct kref		conn_kref;
-	struct list_head	conn_frwr_pool;
-	int			conn_frwr_pool_size;
-	/* lock to protect frwr_pool */
+	struct list_head	conn_fr_pool;
+	int			conn_fr_pool_size;
+	/* lock to protect fastreg pool */
 	spinlock_t		conn_lock;
 #define ISERT_COMP_BATCH_COUNT	8
 	int			conn_comp_batch;
@@ -139,7 +139,7 @@ struct isert_cq_desc {
 };
 
 struct isert_device {
-	int			use_frwr;
+	int			use_fastreg;
 	int			cqs_used;
 	int			refcount;
 	int			cq_active_qps[ISERT_MAX_CQ];
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
