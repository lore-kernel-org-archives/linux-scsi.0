From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 02/11] IB/isert: seperate connection protection domains and dma MRs
Date: Thu,  9 Jan 2014 18:40:49 +0200
Message-ID: <1389285658-7037-3-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389285658-7037-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

It is more correct to seperate connections protection domains
and dma_mr handles. protection information support requires to
do so.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   46 ++++++++++++++++---------------
 drivers/infiniband/ulp/isert/ib_isert.h |    2 -
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 6be57c3..3dd2427 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -248,13 +248,6 @@ isert_create_device_ib_res(struct isert_device *device)
 	}
 	cq_desc = device->cq_desc;
 
-	device->dev_pd = ib_alloc_pd(ib_dev);
-	if (IS_ERR(device->dev_pd)) {
-		ret = PTR_ERR(device->dev_pd);
-		pr_err("ib_alloc_pd failed for dev_pd: %d\n", ret);
-		goto out_cq_desc;
-	}
-
 	for (i = 0; i < device->cqs_used; i++) {
 		cq_desc[i].device = device;
 		cq_desc[i].cq_index = i;
@@ -282,13 +275,6 @@ isert_create_device_ib_res(struct isert_device *device)
 			goto out_cq;
 	}
 
-	device->dev_mr = ib_get_dma_mr(device->dev_pd, IB_ACCESS_LOCAL_WRITE);
-	if (IS_ERR(device->dev_mr)) {
-		ret = PTR_ERR(device->dev_mr);
-		pr_err("ib_get_dma_mr failed for dev_mr: %d\n", ret);
-		goto out_cq;
-	}
-
 	return 0;
 
 out_cq:
@@ -304,9 +290,6 @@ out_cq:
 			ib_destroy_cq(device->dev_tx_cq[j]);
 		}
 	}
-	ib_dealloc_pd(device->dev_pd);
-
-out_cq_desc:
 	kfree(device->cq_desc);
 
 	return ret;
@@ -329,8 +312,6 @@ isert_free_device_ib_res(struct isert_device *device)
 		device->dev_tx_cq[i] = NULL;
 	}
 
-	ib_dereg_mr(device->dev_mr);
-	ib_dealloc_pd(device->dev_pd);
 	kfree(device->cq_desc);
 }
 
@@ -437,7 +418,7 @@ isert_conn_create_frwr_pool(struct isert_conn *isert_conn)
 			goto err;
 		}
 
-		fr_desc->data_mr = ib_alloc_fast_reg_mr(device->dev_pd,
+		fr_desc->data_mr = ib_alloc_fast_reg_mr(isert_conn->conn_pd,
 					ISCSI_ISER_SG_TABLESIZE);
 		if (IS_ERR(fr_desc->data_mr)) {
 			pr_err("Failed to allocate frmr err=%ld\n",
@@ -546,8 +527,22 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	}
 
 	isert_conn->conn_device = device;
-	isert_conn->conn_pd = device->dev_pd;
-	isert_conn->conn_mr = device->dev_mr;
+	isert_conn->conn_pd = ib_alloc_pd(isert_conn->conn_device->ib_device);
+	if (IS_ERR(isert_conn->conn_pd)) {
+		ret = PTR_ERR(isert_conn->conn_pd);
+		pr_err("ib_alloc_pd failed for conn %p: ret=%d\n",
+		       isert_conn, ret);
+		goto out_pd;
+	}
+
+	isert_conn->conn_mr = ib_get_dma_mr(isert_conn->conn_pd,
+					   IB_ACCESS_LOCAL_WRITE);
+	if (IS_ERR(isert_conn->conn_mr)) {
+		ret = PTR_ERR(isert_conn->conn_mr);
+		pr_err("ib_get_dma_mr failed for conn %p: ret=%d\n",
+		       isert_conn, ret);
+		goto out_mr;
+	}
 
 	if (device->use_frwr) {
 		ret = isert_conn_create_frwr_pool(isert_conn);
@@ -573,6 +568,10 @@ out_conn_dev:
 	if (device->use_frwr)
 		isert_conn_free_frwr_pool(isert_conn);
 out_frwr:
+	ib_dereg_mr(isert_conn->conn_mr);
+out_mr:
+	ib_dealloc_pd(isert_conn->conn_pd);
+out_pd:
 	isert_device_try_release(device);
 out_rsp_dma_map:
 	ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
@@ -611,6 +610,9 @@ isert_connect_release(struct isert_conn *isert_conn)
 	isert_free_rx_descriptors(isert_conn);
 	rdma_destroy_id(isert_conn->conn_cm_id);
 
+	ib_dereg_mr(isert_conn->conn_mr);
+	ib_dealloc_pd(isert_conn->conn_pd);
+
 	if (isert_conn->login_buf) {
 		ib_dma_unmap_single(ib_dev, isert_conn->login_rsp_dma,
 				    ISER_RX_LOGIN_SIZE, DMA_TO_DEVICE);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 691f90f..dec74d4 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -144,8 +144,6 @@ struct isert_device {
 	int			refcount;
 	int			cq_active_qps[ISERT_MAX_CQ];
 	struct ib_device	*ib_device;
-	struct ib_pd		*dev_pd;
-	struct ib_mr		*dev_mr;
 	struct ib_cq		*dev_rx_cq[ISERT_MAX_CQ];
 	struct ib_cq		*dev_tx_cq[ISERT_MAX_CQ];
 	struct isert_cq_desc	*cq_desc;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
