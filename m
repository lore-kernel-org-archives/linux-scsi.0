From: Jay Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/1] IB/iser: Remove hard coded values for cqe and send_wr
Date: Tue,  7 Oct 2014 20:41:28 -0400
Message-ID: <1412728888-13100-1-git-send-email-jkallickal@emulex.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jayamohan Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Jayamohan Kallickal <jayamohank-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

	This patch allows the underlying hardware to choose 
values other than  hard coded max values for cqe and send_wr
while preventing them from exceeding max supported values.

Signed-off-by: Minh Tran <minhduc.tran-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 32849f2..7cdb297 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -73,7 +73,7 @@ static int iser_create_device_ib_res(struct iser_device *device)
 {
 	struct iser_cq_desc *cq_desc;
 	struct ib_device_attr *dev_attr = &device->dev_attr;
-	int ret, i, j;
+	int ret, i, j, max_cqe;
 
 	ret = ib_query_device(device->ib_device, dev_attr);
 	if (ret) {
@@ -120,18 +120,24 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		cq_desc[i].device   = device;
 		cq_desc[i].cq_index = i;
 
+		max_cqe = (dev_attr->max_cqe < ISER_MAX_RX_CQ_LEN) ?
+			   dev_attr->max_cqe : ISER_MAX_RX_CQ_LEN;
+
 		device->rx_cq[i] = ib_create_cq(device->ib_device,
 					  iser_cq_callback,
 					  iser_cq_event_callback,
 					  (void *)&cq_desc[i],
-					  ISER_MAX_RX_CQ_LEN, i);
+					  max_cqe, i);
 		if (IS_ERR(device->rx_cq[i]))
 			goto cq_err;
 
+		max_cqe = (dev_attr->max_cqe < ISER_MAX_TX_CQ_LEN) ?
+			   dev_attr->max_cqe : ISER_MAX_TX_CQ_LEN;
+
 		device->tx_cq[i] = ib_create_cq(device->ib_device,
 					  NULL, iser_cq_event_callback,
 					  (void *)&cq_desc[i],
-					  ISER_MAX_TX_CQ_LEN, i);
+					  max_cqe, i);
 
 		if (IS_ERR(device->tx_cq[i]))
 			goto cq_err;
@@ -439,6 +445,7 @@ void iser_free_fastreg_pool(struct iser_conn *ib_conn)
 static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 {
 	struct iser_device	*device;
+	struct ib_device_attr *dev_attr;
 	struct ib_qp_init_attr	init_attr;
 	int			ret = -ENOMEM;
 	int index, min_index = 0;
@@ -459,6 +466,7 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 	mutex_unlock(&ig.connlist_mutex);
 	iser_info("cq index %d used for ib_conn %p\n", min_index, ib_conn);
 
+	dev_attr = &device->dev_attr;
 	init_attr.event_handler = iser_qp_event_callback;
 	init_attr.qp_context	= (void *)ib_conn;
 	init_attr.send_cq	= device->tx_cq[min_index];
@@ -472,7 +480,9 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 		init_attr.cap.max_send_wr = ISER_QP_SIG_MAX_REQ_DTOS;
 		init_attr.create_flags |= IB_QP_CREATE_SIGNATURE_EN;
 	} else {
-		init_attr.cap.max_send_wr  = ISER_QP_MAX_REQ_DTOS;
+		init_attr.cap.max_send_wr  =
+			(dev_attr->max_qp_wr < ISER_QP_MAX_REQ_DTOS) ?
+			 dev_attr->max_qp_wr : ISER_QP_MAX_REQ_DTOS;
 	}
 
 	ret = rdma_create_qp(ib_conn->cma_id, device->pd, &init_attr);
-- 
1.8.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
