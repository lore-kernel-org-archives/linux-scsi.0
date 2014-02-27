From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 06/13] IB/iser: Generalize iser_unmap_task_data and finalize_rdma_unaligned_sg
Date: Thu, 27 Feb 2014 13:13:02 +0200
Message-ID: <1393499589-15633-7-git-send-email-sagig@mellanox.com>
References: <1393499589-15633-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393499589-15633-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This routines operates on data buffers and may also work with
protection infomation buffers. So we generalize them to handle
an iser_data_buf which can be the command data or command protection
information.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    9 ++++--
 drivers/infiniband/ulp/iser/iser_initiator.c |   37 +++++++++++++++++-------
 drivers/infiniband/ulp/iser/iser_memory.c    |   40 ++++++++++---------------
 3 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index 5660714..623defa 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -410,8 +410,10 @@ void iser_task_rdma_finalize(struct iscsi_iser_task *task);
 
 void iser_free_rx_descriptors(struct iser_conn *ib_conn);
 
-void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *task,
-				     enum iser_data_dir         cmd_dir);
+void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
+				     struct iser_data_buf *mem,
+				     struct iser_data_buf *mem_copy,
+				     enum iser_data_dir cmd_dir);
 
 int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
 			   enum iser_data_dir cmd_dir);
@@ -441,7 +443,8 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 			    enum   iser_data_dir       iser_dir,
 			    enum   dma_data_direction  dma_dir);
 
-void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task);
+void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
+			      struct iser_data_buf *data);
 int  iser_initialize_task_headers(struct iscsi_task *task,
 			struct iser_tx_desc *tx_desc);
 int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *session);
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 334f34b..58e14c7 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -644,27 +644,42 @@ void iser_task_rdma_init(struct iscsi_iser_task *iser_task)
 void iser_task_rdma_finalize(struct iscsi_iser_task *iser_task)
 {
 	struct iser_device *device = iser_task->iser_conn->ib_conn->device;
-	int is_rdma_aligned = 1;
+	int is_rdma_data_aligned = 1;
 
 	/* if we were reading, copy back to unaligned sglist,
 	 * anyway dma_unmap and free the copy
 	 */
 	if (iser_task->data_copy[ISER_DIR_IN].copy_buf != NULL) {
-		is_rdma_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_task, ISER_DIR_IN);
+		is_rdma_data_aligned = 0;
+		iser_finalize_rdma_unaligned_sg(iser_task,
+						&iser_task->data[ISER_DIR_IN],
+						&iser_task->data_copy[ISER_DIR_IN],
+						ISER_DIR_IN);
 	}
+
 	if (iser_task->data_copy[ISER_DIR_OUT].copy_buf != NULL) {
-		is_rdma_aligned = 0;
-		iser_finalize_rdma_unaligned_sg(iser_task, ISER_DIR_OUT);
+		is_rdma_data_aligned = 0;
+		iser_finalize_rdma_unaligned_sg(iser_task,
+						&iser_task->data[ISER_DIR_OUT],
+						&iser_task->data_copy[ISER_DIR_OUT],
+						ISER_DIR_OUT);
 	}
 
-	if (iser_task->dir[ISER_DIR_IN])
+	if (iser_task->dir[ISER_DIR_IN]) {
 		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_IN);
+		if (is_rdma_data_aligned)
+			iser_dma_unmap_task_data(iser_task,
+						 &iser_task->data[ISER_DIR_IN]);
 
-	if (iser_task->dir[ISER_DIR_OUT])
-		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
+	}
 
-       /* if the data was unaligned, it was already unmapped and then copied */
-       if (is_rdma_aligned)
-		iser_dma_unmap_task_data(iser_task);
+	if (iser_task->dir[ISER_DIR_OUT]) {
+		device->iser_unreg_rdma_mem(iser_task, ISER_DIR_OUT);
+		if (is_rdma_data_aligned)
+			iser_dma_unmap_task_data(iser_task,
+						 &iser_task->data[ISER_DIR_OUT]);
+		if (prot_count && is_rdma_prot_aligned)
+			iser_dma_unmap_task_data(iser_task,
+						 &iser_task->prot[ISER_DIR_OUT]);
+	}
 }
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index a7a0d3e..a933508 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -105,17 +105,18 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 /**
  * iser_finalize_rdma_unaligned_sg
  */
+
 void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
-				     enum iser_data_dir         cmd_dir)
+				     struct iser_data_buf *data,
+				     struct iser_data_buf *data_copy,
+				     enum iser_data_dir cmd_dir)
 {
 	struct ib_device *dev;
-	struct iser_data_buf *mem_copy;
 	unsigned long  cmd_data_len;
 
 	dev = iser_task->iser_conn->ib_conn->device->ib_device;
-	mem_copy = &iser_task->data_copy[cmd_dir];
 
-	ib_dma_unmap_sg(dev, &mem_copy->sg_single, 1,
+	ib_dma_unmap_sg(dev, &data_copy->sg_single, 1,
 			(cmd_dir == ISER_DIR_OUT) ?
 			DMA_TO_DEVICE : DMA_FROM_DEVICE);
 
@@ -127,10 +128,10 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 		int i;
 
 		/* copy back read RDMA to unaligned sg */
-		mem	= mem_copy->copy_buf;
+		mem = data_copy->copy_buf;
 
-		sgl	= (struct scatterlist *)iser_task->data[ISER_DIR_IN].buf;
-		sg_size = iser_task->data[ISER_DIR_IN].size;
+		sgl = (struct scatterlist *)data->buf;
+		sg_size = data->size;
 
 		p = mem;
 		for_each_sg(sgl, sg, sg_size, i) {
@@ -143,15 +144,15 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *iser_task,
 		}
 	}
 
-	cmd_data_len = iser_task->data[cmd_dir].data_len;
+	cmd_data_len = data->data_len;
 
 	if (cmd_data_len > ISER_KMALLOC_THRESHOLD)
-		free_pages((unsigned long)mem_copy->copy_buf,
+		free_pages((unsigned long)data_copy->copy_buf,
 			   ilog2(roundup_pow_of_two(cmd_data_len)) - PAGE_SHIFT);
 	else
-		kfree(mem_copy->copy_buf);
+		kfree(data_copy->copy_buf);
 
-	mem_copy->copy_buf = NULL;
+	data_copy->copy_buf = NULL;
 }
 
 #define IS_4K_ALIGNED(addr)	((((unsigned long)addr) & ~MASK_4K) == 0)
@@ -329,22 +330,13 @@ int iser_dma_map_task_data(struct iscsi_iser_task *iser_task,
 	return 0;
 }
 
-void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task)
+void iser_dma_unmap_task_data(struct iscsi_iser_task *iser_task,
+			      struct iser_data_buf *data)
 {
 	struct ib_device *dev;
-	struct iser_data_buf *data;
 
 	dev = iser_task->iser_conn->ib_conn->device->ib_device;
-
-	if (iser_task->dir[ISER_DIR_IN]) {
-		data = &iser_task->data[ISER_DIR_IN];
-		ib_dma_unmap_sg(dev, data->buf, data->size, DMA_FROM_DEVICE);
-	}
-
-	if (iser_task->dir[ISER_DIR_OUT]) {
-		data = &iser_task->data[ISER_DIR_OUT];
-		ib_dma_unmap_sg(dev, data->buf, data->size, DMA_TO_DEVICE);
-	}
+	ib_dma_unmap_sg(dev, data->buf, data->size, DMA_FROM_DEVICE);
 }
 
 static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
@@ -363,7 +355,7 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 		iser_data_buf_dump(mem, ibdev);
 
 	/* unmap the command data before accessing it */
-	iser_dma_unmap_task_data(iser_task);
+	iser_dma_unmap_task_data(iser_task, &iser_task->data[cmd_dir]);
 
 	/* allocate copy buf, if we are writing, copy the */
 	/* unaligned scatterlist, dma map the copy        */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
