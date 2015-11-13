From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 7/9] IB/iser: Use a dedicated descriptor for login
Date: Fri, 13 Nov 2015 14:46:48 +0100
Message-ID: <1447422410-20891-8-git-send-email-hch@lst.de>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447422410-20891-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Sagi Grimberg <sagig@mellanox.com>

Makes better sense and we'll need it later with CQ
abstraction.
iser switch login bufs to void

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |  30 +++++--
 drivers/infiniband/ulp/iser/iser_initiator.c | 128 +++++++++++++--------------
 drivers/infiniband/ulp/iser/iser_verbs.c     |  14 +--
 3 files changed, 89 insertions(+), 83 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 502063b..5648409 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -326,6 +326,25 @@ struct iser_rx_desc {
 	char		             pad[ISER_RX_PAD_SIZE];
 } __attribute__((packed));
 
+
+/**
+ * struct iser_login_desc - iSER login descriptor
+ *
+ * @req:           pointer to login request buffer
+ * @resp:          pointer to login response buffer
+ * @req_dma:       DMA address of login request buffer
+ * @rsp_dma:      DMA address of login response buffer
+ * @sge:           IB sge for login post recv
+ */
+struct iser_login_desc {
+	void                         *req;
+	void                         *rsp;
+	u64                          req_dma;
+	u64                          rsp_dma;
+	struct ib_sge                sge;
+} __attribute__((packed));
+
+
 struct iser_conn;
 struct ib_conn;
 struct iscsi_iser_task;
@@ -512,11 +531,7 @@ struct ib_conn {
  * @up_completion:    connection establishment completed
  *                    (state is ISER_CONN_UP)
  * @conn_list:        entry in ig conn list
- * @login_buf:        login data buffer (stores login parameters)
- * @login_req_buf:    login request buffer
- * @login_req_dma:    login request buffer dma address
- * @login_resp_buf:   login response buffer
- * @login_resp_dma:   login response buffer dma address
+ * @login_desc:       login descriptor
  * @rx_desc_head:     head of rx_descs cyclic buffer
  * @rx_descs:         rx buffers array (cyclic buffer)
  * @num_rx_descs:     number of rx descriptors
@@ -539,10 +554,7 @@ struct iser_conn {
 	struct completion	     ib_completion;
 	struct completion	     up_completion;
 	struct list_head	     conn_list;
-
-	char  			     *login_buf;
-	char			     *login_req_buf, *login_resp_buf;
-	u64			     login_req_dma, login_resp_dma;
+	struct iser_login_desc       login_desc;
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
 	u32                          num_rx_descs;
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index ffd00c4..21f28c8 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -174,73 +174,63 @@ static void iser_create_send_desc(struct iser_conn	*iser_conn,
 static void iser_free_login_buf(struct iser_conn *iser_conn)
 {
 	struct iser_device *device = iser_conn->ib_conn.device;
+	struct iser_login_desc *desc = &iser_conn->login_desc;
 
-	if (!iser_conn->login_buf)
+	if (!desc->req)
 		return;
 
-	if (iser_conn->login_req_dma)
-		ib_dma_unmap_single(device->ib_device,
-				    iser_conn->login_req_dma,
-				    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
+	ib_dma_unmap_single(device->ib_device, desc->req_dma,
+			    ISCSI_DEF_MAX_RECV_SEG_LEN, DMA_TO_DEVICE);
 
-	if (iser_conn->login_resp_dma)
-		ib_dma_unmap_single(device->ib_device,
-				    iser_conn->login_resp_dma,
-				    ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
+	ib_dma_unmap_single(device->ib_device, desc->rsp_dma,
+			    ISER_RX_LOGIN_SIZE, DMA_FROM_DEVICE);
 
-	kfree(iser_conn->login_buf);
+	kfree(desc->req);
+	kfree(desc->rsp);
 
 	/* make sure we never redo any unmapping */
-	iser_conn->login_req_dma = 0;
-	iser_conn->login_resp_dma = 0;
-	iser_conn->login_buf = NULL;
+	desc->req = NULL;
+	desc->rsp = NULL;
 }
 
 static int iser_alloc_login_buf(struct iser_conn *iser_conn)
 {
 	struct iser_device *device = iser_conn->ib_conn.device;
-	int			req_err, resp_err;
-
-	BUG_ON(device == NULL);
-
-	iser_conn->login_buf = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN +
-				     ISER_RX_LOGIN_SIZE, GFP_KERNEL);
-	if (!iser_conn->login_buf)
-		goto out_err;
-
-	iser_conn->login_req_buf  = iser_conn->login_buf;
-	iser_conn->login_resp_buf = iser_conn->login_buf +
-						ISCSI_DEF_MAX_RECV_SEG_LEN;
-
-	iser_conn->login_req_dma = ib_dma_map_single(device->ib_device,
-						     iser_conn->login_req_buf,
-						     ISCSI_DEF_MAX_RECV_SEG_LEN,
-						     DMA_TO_DEVICE);
-
-	iser_conn->login_resp_dma = ib_dma_map_single(device->ib_device,
-						      iser_conn->login_resp_buf,
-						      ISER_RX_LOGIN_SIZE,
-						      DMA_FROM_DEVICE);
-
-	req_err  = ib_dma_mapping_error(device->ib_device,
-					iser_conn->login_req_dma);
-	resp_err = ib_dma_mapping_error(device->ib_device,
-					iser_conn->login_resp_dma);
-
-	if (req_err || resp_err) {
-		if (req_err)
-			iser_conn->login_req_dma = 0;
-		if (resp_err)
-			iser_conn->login_resp_dma = 0;
-		goto free_login_buf;
-	}
+	struct iser_login_desc *desc = &iser_conn->login_desc;
+
+	desc->req = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
+	if (!desc->req)
+		return -ENOMEM;
+
+	desc->req_dma = ib_dma_map_single(device->ib_device, desc->req,
+					  ISCSI_DEF_MAX_RECV_SEG_LEN,
+					  DMA_TO_DEVICE);
+	if (ib_dma_mapping_error(device->ib_device,
+				desc->req_dma))
+		goto free_req;
+
+	desc->rsp = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
+	if (!desc->rsp)
+		goto unmap_req;
+
+	desc->rsp_dma = ib_dma_map_single(device->ib_device, desc->rsp,
+					   ISER_RX_LOGIN_SIZE,
+					   DMA_FROM_DEVICE);
+	if (ib_dma_mapping_error(device->ib_device,
+				desc->rsp_dma))
+		goto free_rsp;
+
 	return 0;
 
-free_login_buf:
-	iser_free_login_buf(iser_conn);
+free_rsp:
+	kfree(desc->rsp);
+unmap_req:
+	ib_dma_unmap_single(device->ib_device, desc->req_dma,
+			    ISCSI_DEF_MAX_RECV_SEG_LEN,
+			    DMA_TO_DEVICE);
+free_req:
+	kfree(desc->req);
 
-out_err:
-	iser_err("unable to alloc or map login buf\n");
 	return -ENOMEM;
 }
 
@@ -520,25 +510,25 @@ int iser_send_control(struct iscsi_conn *conn,
 	data_seg_len = ntoh24(task->hdr->dlength);
 
 	if (data_seg_len > 0) {
+		struct iser_login_desc *desc = &iser_conn->login_desc;
 		struct ib_sge *tx_dsg = &mdesc->tx_sg[1];
+
 		if (task != conn->login_task) {
 			iser_err("data present on non login task!!!\n");
 			goto send_control_error;
 		}
 
-		ib_dma_sync_single_for_cpu(device->ib_device,
-			iser_conn->login_req_dma, task->data_count,
-			DMA_TO_DEVICE);
+		ib_dma_sync_single_for_cpu(device->ib_device, desc->req_dma,
+					   task->data_count, DMA_TO_DEVICE);
 
-		memcpy(iser_conn->login_req_buf, task->data, task->data_count);
+		memcpy(desc->req, task->data, task->data_count);
 
-		ib_dma_sync_single_for_device(device->ib_device,
-			iser_conn->login_req_dma, task->data_count,
-			DMA_TO_DEVICE);
+		ib_dma_sync_single_for_device(device->ib_device, desc->req_dma,
+					      task->data_count, DMA_TO_DEVICE);
 
-		tx_dsg->addr    = iser_conn->login_req_dma;
-		tx_dsg->length  = task->data_count;
-		tx_dsg->lkey    = device->pd->local_dma_lkey;
+		tx_dsg->addr = desc->req_dma;
+		tx_dsg->length = task->data_count;
+		tx_dsg->lkey = device->pd->local_dma_lkey;
 		mdesc->num_sge = 2;
 	}
 
@@ -572,27 +562,31 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	struct iser_conn *iser_conn = container_of(ib_conn, struct iser_conn,
 						   ib_conn);
 	struct iscsi_hdr *hdr;
+	char *data;
 	u64 rx_dma;
 	int rx_buflen, outstanding, count, err;
 
 	/* differentiate between login to all other PDUs */
-	if ((char *)rx_desc == iser_conn->login_resp_buf) {
-		rx_dma = iser_conn->login_resp_dma;
+	if (rx_desc == (void *)&iser_conn->login_desc) {
+		rx_dma = iser_conn->login_desc.rsp_dma;
 		rx_buflen = ISER_RX_LOGIN_SIZE;
+		hdr = iser_conn->login_desc.rsp + sizeof(struct iser_hdr);
+		data = iser_conn->login_desc.rsp + ISER_HEADERS_LEN;
 	} else {
 		rx_dma = rx_desc->dma_addr;
 		rx_buflen = ISER_RX_PAYLOAD_SIZE;
+		hdr = &rx_desc->iscsi_header;
+		data = rx_desc->data;
 	}
 
 	ib_dma_sync_single_for_cpu(ib_conn->device->ib_device, rx_dma,
 				   rx_buflen, DMA_FROM_DEVICE);
 
-	hdr = &rx_desc->iscsi_header;
 
 	iser_dbg("op 0x%x itt 0x%x dlen %d\n", hdr->opcode,
 			hdr->itt, (int)(rx_xfer_len - ISER_HEADERS_LEN));
 
-	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, rx_desc->data,
+	iscsi_iser_recv(iser_conn->iscsi_conn, hdr, data,
 			rx_xfer_len - ISER_HEADERS_LEN);
 
 	ib_dma_sync_single_for_device(ib_conn->device->ib_device, rx_dma,
@@ -604,7 +598,7 @@ void iser_rcv_completion(struct iser_rx_desc *rx_desc,
 	 * for the posted rx bufs refcount to become zero handles everything   */
 	ib_conn->post_recv_buf_count--;
 
-	if (rx_dma == iser_conn->login_resp_dma)
+	if (rx_desc == (void *)&iser_conn->login_desc)
 		return;
 
 	outstanding = ib_conn->post_recv_buf_count;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index bf29ddf..ee4cebc 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1041,17 +1041,17 @@ int iser_post_recvl(struct iser_conn *iser_conn)
 {
 	struct ib_recv_wr rx_wr, *rx_wr_failed;
 	struct ib_conn *ib_conn = &iser_conn->ib_conn;
-	struct ib_sge	  sge;
+	struct iser_login_desc *desc = &iser_conn->login_desc;
 	int ib_ret;
 
-	sge.addr   = iser_conn->login_resp_dma;
-	sge.length = ISER_RX_LOGIN_SIZE;
-	sge.lkey   = ib_conn->device->pd->local_dma_lkey;
+	desc->sge.addr = desc->rsp_dma;
+	desc->sge.length = ISER_RX_LOGIN_SIZE;
+	desc->sge.lkey = ib_conn->device->pd->local_dma_lkey;
 
-	rx_wr.wr_id   = (uintptr_t)iser_conn->login_resp_buf;
-	rx_wr.sg_list = &sge;
+	rx_wr.wr_id = (uintptr_t)desc;
+	rx_wr.sg_list = &desc->sge;
 	rx_wr.num_sge = 1;
-	rx_wr.next    = NULL;
+	rx_wr.next = NULL;
 
 	ib_conn->post_recv_buf_count++;
 	ib_ret	= ib_post_recv(ib_conn->qp, &rx_wr, &rx_wr_failed);
-- 
1.9.1
