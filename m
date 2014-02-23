From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 07/11] IB/iser: Initialize T10-PI resources
Date: Sun, 23 Feb 2014 14:19:30 +0200
Message-ID: <1393157974-24931-8-git-send-email-sagig@mellanox.com>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:40921 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751314AbaBWMTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Feb 2014 07:19:43 -0500
In-Reply-To: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: oren@mellanox.com, martin.petersen@oracle.com, michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org

During connection establishment we also initiatlize
T10-PI resources (QP, PI contexts) in order to support
SCSI's protection operations.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |   19 ++++++
 drivers/infiniband/ulp/iser/iser_initiator.c |    8 +++
 drivers/infiniband/ulp/iser/iser_verbs.c     |   81 +++++++++++++++++++++++--
 3 files changed, 101 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 76b2124..a4626d9 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -134,6 +134,15 @@
 					ISER_MAX_TX_MISC_PDUS        + \
 					ISER_MAX_RX_MISC_PDUS)
 
+/* Max registration work requests per command */
+#define ISER_MAX_REG_WR_PER_CMD		5
+
+/* For Signature we don't support DATAOUTs so no need to make room for them */
+#define ISER_QP_SIG_MAX_REQ_DTOS	(ISER_DEF_XMIT_CMDS_MAX	*       \
+					(1 + ISER_MAX_REG_WR_PER_CMD) + \
+					ISER_MAX_TX_MISC_PDUS         + \
+					ISER_MAX_RX_MISC_PDUS)
+
 #define ISER_VER			0x10
 #define ISER_WSV			0x08
 #define ISER_RSV			0x04
@@ -282,6 +291,15 @@ struct iser_device {
 
 enum iser_reg_indicator {
 	ISER_DATA_KEY_VALID = 1 << 0,
+	ISER_PROT_KEY_VALID = 1 << 1,
+	ISER_SIG_KEY_VALID  = 1 << 2,
+	ISER_FR_PROTECTED   = 1 << 3,
+};
+
+struct iser_pi_context {
+	struct ib_mr                   *prot_mr;
+	struct ib_fast_reg_page_list   *prot_frpl;
+	struct ib_mr                   *sig_mr;
 };
 
 struct fast_reg_descriptor {
@@ -289,6 +307,7 @@ struct fast_reg_descriptor {
 	/* For fast registration - FRWR */
 	struct ib_mr			 *data_mr;
 	struct ib_fast_reg_page_list     *data_frpl;
+	struct iser_pi_context		 *pi_ctx;
 	/* registration indicators container */
 	u8				  reg_indicators;
 };
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 334f34b..8352b0c 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -255,6 +255,14 @@ int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *s
 	ib_conn->qp_max_recv_dtos_mask = session->cmds_max - 1; /* cmds_max is 2^N */
 	ib_conn->min_posted_rx = ib_conn->qp_max_recv_dtos >> 2;
 
+	/* Check T10-PI support request against device capability */
+	if (ib_conn->pi_support &&
+	    !(device->dev_attr.device_cap_flags & IB_DEVICE_SIGNATURE_HANDOVER)) {
+		iser_err("T10-PI requested but not supported on device %s\n",
+			 device->ib_device->name);
+		return -EINVAL;
+	}
+
 	if (device->iser_alloc_rdma_reg_res(ib_conn, session->scsi_cmds_max))
 		goto create_rdma_reg_res_failed;
 
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 94f967c..b00e1ec 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -215,6 +215,11 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 	struct ib_fmr_pool_param params;
 	int ret = -ENOMEM;
 
+	if (ib_conn->pi_support) {
+		iser_err("T10-PI is not supported for FMRs\n");
+		return -EINVAL;
+	}
+
 	ib_conn->fmr.page_vec = kmalloc(sizeof(struct iser_page_vec) +
 						(sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE + 1)),
 						GFP_KERNEL);
@@ -275,7 +280,7 @@ void iser_free_fmr_pool(struct iser_conn *ib_conn)
 
 static int
 iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
-			 struct fast_reg_descriptor *desc)
+			 bool pi_enable, struct fast_reg_descriptor *desc)
 {
 	int ret;
 
@@ -294,12 +299,64 @@ iser_create_fastreg_desc(struct ib_device *ib_device, struct ib_pd *pd,
 		iser_err("Failed to allocate ib_fast_reg_mr err=%d\n", ret);
 		goto fast_reg_mr_failure;
 	}
+	desc->reg_indicators |= ISER_DATA_KEY_VALID;
+
+	if (pi_enable) {
+		struct ib_mr_init_attr mr_init_attr = {0};
+		struct iser_pi_context *pi_ctx = NULL;
+
+		desc->pi_ctx = kzalloc(sizeof(*desc->pi_ctx), GFP_KERNEL);
+		if (!desc->pi_ctx) {
+			iser_err("Failed to allocate pi context\n");
+			ret = -ENOMEM;
+			goto pi_ctx_alloc_failure;
+		}
+		pi_ctx = desc->pi_ctx;
+
+		pi_ctx->prot_frpl = ib_alloc_fast_reg_page_list(ib_device,
+						    ISCSI_ISER_SG_TABLESIZE);
+		if (IS_ERR(pi_ctx->prot_frpl)) {
+			ret = PTR_ERR(pi_ctx->prot_frpl);
+			iser_err("Failed to allocate prot frpl ret=%d\n",
+				 ret);
+			goto prot_frpl_failure;
+		}
+
+		pi_ctx->prot_mr = ib_alloc_fast_reg_mr(pd,
+						ISCSI_ISER_SG_TABLESIZE + 1);
+		if (IS_ERR(pi_ctx->prot_mr)) {
+			ret = PTR_ERR(pi_ctx->prot_mr);
+			iser_err("Failed to allocate prot frmr ret=%d\n",
+				 ret);
+			goto prot_mr_failure;
+		}
+		desc->reg_indicators |= ISER_PROT_KEY_VALID;
+
+		mr_init_attr.max_reg_descriptors = 2;
+		mr_init_attr.flags |= IB_MR_SIGNATURE_EN;
+		pi_ctx->sig_mr = ib_create_mr(pd, &mr_init_attr);
+		if (IS_ERR(pi_ctx->sig_mr)) {
+			ret = PTR_ERR(pi_ctx->sig_mr);
+			iser_err("Failed to allocate signature enabled mr err=%d\n",
+				 ret);
+			goto sig_mr_failure;
+		}
+		desc->reg_indicators |= ISER_SIG_KEY_VALID;
+	}
+	desc->reg_indicators &= ~ISER_FR_PROTECTED;
+
 	iser_info("Create fr_desc %p page_list %p\n",
 		  desc, desc->data_frpl->page_list);
-	desc->reg_indicators |= ISER_DATA_KEY_VALID;
 
 	return 0;
-
+sig_mr_failure:
+	ib_dereg_mr(desc->pi_ctx->prot_mr);
+prot_mr_failure:
+	ib_free_fast_reg_page_list(desc->pi_ctx->prot_frpl);
+prot_frpl_failure:
+	kfree(desc->pi_ctx);
+pi_ctx_alloc_failure:
+	ib_dereg_mr(desc->data_mr);
 fast_reg_mr_failure:
 	ib_free_fast_reg_page_list(desc->data_frpl);
 
@@ -320,15 +377,15 @@ int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 	INIT_LIST_HEAD(&ib_conn->fastreg.pool);
 	ib_conn->fastreg.pool_size = 0;
 	for (i = 0; i < cmds_max; i++) {
-		desc = kmalloc(sizeof(*desc), GFP_KERNEL);
+		desc = kzalloc(sizeof(*desc), GFP_KERNEL);
 		if (!desc) {
 			iser_err("Failed to allocate a new fast_reg descriptor\n");
 			ret = -ENOMEM;
 			goto err;
 		}
 
-		ret = iser_create_fastreg_desc(device->ib_device,
-					       device->pd, desc);
+		ret = iser_create_fastreg_desc(device->ib_device, device->pd,
+					       ib_conn->pi_support, desc);
 		if (ret) {
 			iser_err("Failed to create fastreg descriptor err=%d\n",
 				 ret);
@@ -364,6 +421,12 @@ void iser_free_fastreg_pool(struct iser_conn *ib_conn)
 		list_del(&desc->list);
 		ib_free_fast_reg_page_list(desc->data_frpl);
 		ib_dereg_mr(desc->data_mr);
+		if (desc->pi_ctx) {
+			ib_free_fast_reg_page_list(desc->pi_ctx->prot_frpl);
+			ib_dereg_mr(desc->pi_ctx->prot_mr);
+			ib_destroy_mr(desc->pi_ctx->sig_mr);
+			kfree(desc->pi_ctx);
+		}
 		kfree(desc);
 		++i;
 	}
@@ -405,12 +468,16 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	init_attr.qp_context	= (void *)ib_conn;
 	init_attr.send_cq	= device->tx_cq[min_index];
 	init_attr.recv_cq	= device->rx_cq[min_index];
-	init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
 	init_attr.cap.max_recv_wr  = ISER_QP_MAX_RECV_DTOS;
 	init_attr.cap.max_send_sge = 2;
 	init_attr.cap.max_recv_sge = 1;
 	init_attr.sq_sig_type	= IB_SIGNAL_REQ_WR;
 	init_attr.qp_type	= IB_QPT_RC;
+	if (ib_conn->pi_support) {
+		init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS;
+		init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
+	} else
+		init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
 
 	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
 	if (ret)
-- 
1.7.1

