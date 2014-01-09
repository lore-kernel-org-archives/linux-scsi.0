From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 06/11] IB/isert: Initialize T10-PI resources
Date: Thu,  9 Jan 2014 18:40:53 +0200
Message-ID: <1389285658-7037-7-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

Upon connection establishment check if network portal is T10-PI
enabled and allocate T10-PI resources if necessary, allocate
signature enabled memory regions and mark connection queue-pair
as signature enabled.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  104 +++++++++++++++++++++++++++----
 drivers/infiniband/ulp/isert/ib_isert.h |   19 +++++-
 2 files changed, 106 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 9ef9193..98f23f4 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -87,7 +87,8 @@ isert_query_device(struct ib_device *ib_dev, struct ib_device_attr *devattr)
 }
 
 static int
-isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
+isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id,
+		    u8 protection)
 {
 	struct isert_device *device = isert_conn->conn_device;
 	struct ib_qp_init_attr attr;
@@ -119,6 +120,8 @@ isert_conn_setup_qp(struct isert_conn *isert_conn, struct rdma_cm_id *cma_id)
 	attr.cap.max_recv_sge = 1;
 	attr.sq_sig_type = IB_SIGNAL_REQ_WR;
 	attr.qp_type = IB_QPT_RC;
+	if (protection)
+		attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
 
 	pr_debug("isert_conn_setup_qp cma_id->device: %p\n",
 		 cma_id->device);
@@ -234,13 +237,18 @@ isert_create_device_ib_res(struct isert_device *device)
 		device->unreg_rdma_mem = isert_unmap_cmd;
 	}
 
+	/* Check signature cap */
+	device->pi_capable = dev_attr->device_cap_flags &
+			     IB_DEVICE_SIGNATURE_HANDOVER ? true : false;
+
 	device->cqs_used = min_t(int, num_online_cpus(),
 				 device->ib_device->num_comp_vectors);
 	device->cqs_used = min(ISERT_MAX_CQ, device->cqs_used);
 	pr_debug("Using %d CQs, device %s supports %d vectors support "
-		 "Fast registration %d\n",
+		 "Fast registration %d pi_capable %d\n",
 		 device->cqs_used, device->ib_device->name,
-		 device->ib_device->num_comp_vectors, device->use_fastreg);
+		 device->ib_device->num_comp_vectors, device->use_fastreg,
+		 device->pi_capable);
 	device->cq_desc = kzalloc(sizeof(struct isert_cq_desc) *
 				device->cqs_used, GFP_KERNEL);
 	if (!device->cq_desc) {
@@ -383,6 +391,12 @@ isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 		list_del(&fr_desc->list);
 		ib_free_fast_reg_page_list(fr_desc->data_frpl);
 		ib_dereg_mr(fr_desc->data_mr);
+		if (fr_desc->pi_ctx) {
+			ib_free_fast_reg_page_list(fr_desc->pi_ctx->prot_frpl);
+			ib_dereg_mr(fr_desc->pi_ctx->prot_mr);
+			ib_destroy_mr(fr_desc->pi_ctx->sig_mr);
+			kfree(fr_desc->pi_ctx);
+		}
 		kfree(fr_desc);
 		++i;
 	}
@@ -394,8 +408,10 @@ isert_conn_free_fastreg_pool(struct isert_conn *isert_conn)
 
 static int
 isert_create_fr_desc(struct ib_device *ib_device, struct ib_pd *pd,
-		     struct fast_reg_descriptor *fr_desc)
+		     struct fast_reg_descriptor *fr_desc, u8 protection)
 {
+	int ret;
+
 	fr_desc->data_frpl = ib_alloc_fast_reg_page_list(ib_device,
 							 ISCSI_ISER_SG_TABLESIZE);
 	if (IS_ERR(fr_desc->data_frpl)) {
@@ -408,19 +424,73 @@ isert_create_fr_desc(struct ib_device *ib_device, struct ib_pd *pd,
 	if (IS_ERR(fr_desc->data_mr)) {
 		pr_err("Failed to allocate data frmr err=%ld\n",
 		       PTR_ERR(fr_desc->data_mr));
-		ib_free_fast_reg_page_list(fr_desc->data_frpl);
-		return PTR_ERR(fr_desc->data_mr);
+		ret = PTR_ERR(fr_desc->data_mr);
+		goto err_data_frpl;
 	}
 	pr_debug("Create fr_desc %p page_list %p\n",
 		 fr_desc, fr_desc->data_frpl->page_list);
+	fr_desc->data_key_valid = true;
 
-	fr_desc->valid = true;
+	if (protection) {
+		struct ib_mr_init_attr mr_init_attr = {0};
+		struct pi_context *pi_ctx;
+
+		fr_desc->pi_ctx = kzalloc(sizeof(*fr_desc->pi_ctx), GFP_KERNEL);
+		if (!fr_desc->pi_ctx) {
+			pr_err("Failed to allocate pi context\n");
+			ret = -ENOMEM;
+			goto err_data_mr;
+		}
+		pi_ctx = fr_desc->pi_ctx;
+
+		pi_ctx->prot_frpl = ib_alloc_fast_reg_page_list(ib_device,
+						    ISCSI_ISER_SG_TABLESIZE);
+		if (IS_ERR(pi_ctx->prot_frpl)) {
+			pr_err("Failed to allocate prot frpl err=%ld\n",
+			       PTR_ERR(pi_ctx->prot_frpl));
+			ret = PTR_ERR(pi_ctx->prot_frpl);
+			goto err_pi_ctx;
+		}
+
+		pi_ctx->prot_mr = ib_alloc_fast_reg_mr(pd, ISCSI_ISER_SG_TABLESIZE);
+		if (IS_ERR(pi_ctx->prot_mr)) {
+			pr_err("Failed to allocate prot frmr err=%ld\n",
+			       PTR_ERR(pi_ctx->prot_mr));
+			ret = PTR_ERR(pi_ctx->prot_mr);
+			goto err_prot_frpl;
+		}
+		pi_ctx->prot_key_valid = true;
+
+		mr_init_attr.max_reg_descriptors = 2;
+		mr_init_attr.flags |= IB_MR_SIGNATURE_EN;
+		pi_ctx->sig_mr = ib_create_mr(pd, &mr_init_attr);
+		if (IS_ERR(pi_ctx->sig_mr)) {
+			pr_err("Failed to allocate signature enabled mr err=%ld\n",
+			       PTR_ERR(pi_ctx->sig_mr));
+			ret = PTR_ERR(pi_ctx->sig_mr);
+			goto err_prot_mr;
+		}
+		pi_ctx->sig_key_valid = true;
+	}
+	fr_desc->protected = false;
 
 	return 0;
+err_prot_mr:
+	ib_dereg_mr(fr_desc->pi_ctx->prot_mr);
+err_prot_frpl:
+	ib_free_fast_reg_page_list(fr_desc->pi_ctx->prot_frpl);
+err_pi_ctx:
+	kfree(fr_desc->pi_ctx);
+err_data_mr:
+	ib_dereg_mr(fr_desc->data_mr);
+err_data_frpl:
+	ib_free_fast_reg_page_list(fr_desc->data_frpl);
+
+	return ret;
 }
 
 static int
-isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
+isert_conn_create_fastreg_pool(struct isert_conn *isert_conn, u8 pi_support)
 {
 	struct fast_reg_descriptor *fr_desc;
 	struct isert_device *device = isert_conn->conn_device;
@@ -437,7 +507,8 @@ isert_conn_create_fastreg_pool(struct isert_conn *isert_conn)
 		}
 
 		ret = isert_create_fr_desc(device->ib_device,
-					   isert_conn->conn_pd, fr_desc);
+					   isert_conn->conn_pd, fr_desc,
+					   pi_support);
 		if (ret) {
 			pr_err("Failed to create fastreg descriptor err=%d\n",
 			       ret);
@@ -467,6 +538,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	struct isert_device *device;
 	struct ib_device *ib_dev = cma_id->device;
 	int ret = 0;
+	u8 pi_support = np->tpg_np->tpg->tpg_attrib.t10_pi;
 
 	pr_debug("Entering isert_connect_request cma_id: %p, context: %p\n",
 		 cma_id, cma_id->context);
@@ -557,8 +629,14 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out_mr;
 	}
 
+	if (pi_support && !device->pi_capable) {
+		pr_err("Protection information requested but not supported\n");
+		ret = -EINVAL;
+		goto out_mr;
+	}
+
 	if (device->use_fastreg) {
-		ret = isert_conn_create_fastreg_pool(isert_conn);
+		ret = isert_conn_create_fastreg_pool(isert_conn, pi_support);
 		if (ret) {
 			pr_err("Conn: %p failed to create fastreg pool\n",
 			       isert_conn);
@@ -566,7 +644,7 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		}
 	}
 
-	ret = isert_conn_setup_qp(isert_conn, cma_id);
+	ret = isert_conn_setup_qp(isert_conn, cma_id, pi_support);
 	if (ret)
 		goto out_conn_dev;
 
@@ -2193,7 +2271,7 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 	pagelist_len = isert_map_fr_pagelist(ib_dev, sg_start, sg_nents,
 					     &fr_desc->data_frpl->page_list[0]);
 
-	if (!fr_desc->valid) {
+	if (!fr_desc->data_key_valid) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
 		inv_wr.opcode = IB_WR_LOCAL_INV;
 		inv_wr.ex.invalidate_rkey = fr_desc->data_mr->rkey;
@@ -2225,7 +2303,7 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 		pr_err("fast registration failed, ret:%d\n", ret);
 		return ret;
 	}
-	fr_desc->valid = false;
+	fr_desc->data_key_valid = false;
 
 	ib_sge->lkey = fr_desc->data_mr->lkey;
 	ib_sge->addr = fr_desc->data_frpl->page_list[0] + page_off;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 708a069..fab8b50 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -48,11 +48,21 @@ struct iser_tx_desc {
 	struct ib_send_wr send_wr;
 } __packed;
 
+struct pi_context {
+	struct ib_mr		       *prot_mr;
+	bool				prot_key_valid;
+	struct ib_fast_reg_page_list   *prot_frpl;
+	struct ib_mr		       *sig_mr;
+	bool				sig_key_valid;
+};
+
 struct fast_reg_descriptor {
-	struct list_head	list;
-	struct ib_mr		*data_mr;
-	struct ib_fast_reg_page_list	*data_frpl;
-	bool			valid;
+	struct list_head		list;
+	struct ib_mr		       *data_mr;
+	bool				data_key_valid;
+	struct ib_fast_reg_page_list   *data_frpl;
+	bool				protected;
+	struct pi_context	       *pi_ctx;
 };
 
 struct isert_rdma_wr {
@@ -140,6 +150,7 @@ struct isert_cq_desc {
 
 struct isert_device {
 	int			use_fastreg;
+	bool			pi_capable;
 	int			cqs_used;
 	int			refcount;
 	int			cq_active_qps[ISERT_MAX_CQ];
-- 
1.7.1
