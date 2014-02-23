From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 01/11] IB/iser: Avoid FRWR notation, use fastreg instead
Date: Sun, 23 Feb 2014 14:19:24 +0200
Message-ID: <1393157974-24931-2-git-send-email-sagig@mellanox.com>
References: <1393157974-24931-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393157974-24931-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Cc: oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

FRWR stands for "fast registration work request". We
want to avoid calling the fastreg pool with that name,
instead we name it fastreg which stands for "fast registration".

This pool will include more elements in the future, so
it is a good idea to generalize the name.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iscsi_iser.h  |   18 ++++---
 drivers/infiniband/ulp/iser/iser_memory.c |   24 +++++-----
 drivers/infiniband/ulp/iser/iser_verbs.c  |   78 ++++++++++++++--------------
 3 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index e1a01c6..265ab99 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -312,6 +312,8 @@ struct iser_conn {
 	unsigned int 		     rx_desc_head;
 	struct iser_rx_desc	     *rx_descs;
 	struct ib_recv_wr	     rx_wr[ISER_MIN_POSTED_RX];
+
+	/* Connection memory registration pool */
 	union {
 		struct {
 			struct ib_fmr_pool      *pool;	   /* pool of IB FMRs         */
@@ -321,8 +323,8 @@ struct iser_conn {
 		struct {
 			struct list_head	pool;
 			int			pool_size;
-		} frwr;
-	} fastreg;
+		} fastreg;
+	};
 };
 
 struct iscsi_iser_conn {
@@ -408,8 +410,8 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_task *task,
 
 int  iser_reg_rdma_mem_fmr(struct iscsi_iser_task *task,
 			   enum iser_data_dir cmd_dir);
-int  iser_reg_rdma_mem_frwr(struct iscsi_iser_task *task,
-			    enum iser_data_dir cmd_dir);
+int  iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *task,
+			       enum iser_data_dir cmd_dir);
 
 int  iser_connect(struct iser_conn   *ib_conn,
 		  struct sockaddr_in *src_addr,
@@ -422,8 +424,8 @@ int  iser_reg_page_vec(struct iser_conn     *ib_conn,
 
 void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 			enum iser_data_dir cmd_dir);
-void iser_unreg_mem_frwr(struct iscsi_iser_task *iser_task,
-			 enum iser_data_dir cmd_dir);
+void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
+			    enum iser_data_dir cmd_dir);
 
 int  iser_post_recvl(struct iser_conn *ib_conn);
 int  iser_post_recvm(struct iser_conn *ib_conn, int count);
@@ -440,6 +442,6 @@ int  iser_initialize_task_headers(struct iscsi_task *task,
 int iser_alloc_rx_descriptors(struct iser_conn *ib_conn, struct iscsi_session *session);
 int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
 void iser_free_fmr_pool(struct iser_conn *ib_conn);
-int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max);
-void iser_free_frwr_pool(struct iser_conn *ib_conn);
+int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max);
+void iser_free_fastreg_pool(struct iser_conn *ib_conn);
 #endif
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index f770179..4e34729 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -422,8 +422,8 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 			 (unsigned long)regd_buf->reg.va,
 			 (unsigned long)regd_buf->reg.len);
 	} else { /* use FMR for multiple dma entries */
-		iser_page_vec_build(mem, ib_conn->fastreg.fmr.page_vec, ibdev);
-		err = iser_reg_page_vec(ib_conn, ib_conn->fastreg.fmr.page_vec,
+		iser_page_vec_build(mem, ib_conn->fmr.page_vec, ibdev);
+		err = iser_reg_page_vec(ib_conn, ib_conn->fmr.page_vec,
 					&regd_buf->reg);
 		if (err && err != -EAGAIN) {
 			iser_data_buf_dump(mem, ibdev);
@@ -431,12 +431,12 @@ int iser_reg_rdma_mem_fmr(struct iscsi_iser_task *iser_task,
 				 mem->dma_nents,
 				 ntoh24(iser_task->desc.iscsi_header.dlength));
 			iser_err("page_vec: data_size = 0x%x, length = %d, offset = 0x%x\n",
-				 ib_conn->fastreg.fmr.page_vec->data_size,
-				 ib_conn->fastreg.fmr.page_vec->length,
-				 ib_conn->fastreg.fmr.page_vec->offset);
-			for (i = 0; i < ib_conn->fastreg.fmr.page_vec->length; i++)
+				 ib_conn->fmr.page_vec->data_size,
+				 ib_conn->fmr.page_vec->length,
+				 ib_conn->fmr.page_vec->offset);
+			for (i = 0; i < ib_conn->fmr.page_vec->length; i++)
 				iser_err("page_vec[%d] = 0x%llx\n", i,
-					 (unsigned long long) ib_conn->fastreg.fmr.page_vec->pages[i]);
+					 (unsigned long long) ib_conn->fmr.page_vec->pages[i]);
 		}
 		if (err)
 			return err;
@@ -503,13 +503,13 @@ static int iser_fast_reg_mr(struct fast_reg_descriptor *desc,
 }
 
 /**
- * iser_reg_rdma_mem_frwr - Registers memory intended for RDMA,
+ * iser_reg_rdma_mem_fastreg - Registers memory intended for RDMA,
  * using Fast Registration WR (if possible) obtaining rkey and va
  *
  * returns 0 on success, errno code on failure
  */
-int iser_reg_rdma_mem_frwr(struct iscsi_iser_task *iser_task,
-			   enum iser_data_dir cmd_dir)
+int iser_reg_rdma_mem_fastreg(struct iscsi_iser_task *iser_task,
+			      enum iser_data_dir cmd_dir)
 {
 	struct iser_conn *ib_conn = iser_task->iser_conn->ib_conn;
 	struct iser_device *device = ib_conn->device;
@@ -544,7 +544,7 @@ int iser_reg_rdma_mem_frwr(struct iscsi_iser_task *iser_task,
 		regd_buf->reg.is_mr = 0;
 	} else {
 		spin_lock_irqsave(&ib_conn->lock, flags);
-		desc = list_first_entry(&ib_conn->fastreg.frwr.pool,
+		desc = list_first_entry(&ib_conn->fastreg.pool,
 					struct fast_reg_descriptor, list);
 		list_del(&desc->list);
 		spin_unlock_irqrestore(&ib_conn->lock, flags);
@@ -567,7 +567,7 @@ int iser_reg_rdma_mem_frwr(struct iscsi_iser_task *iser_task,
 	return 0;
 err_reg:
 	spin_lock_irqsave(&ib_conn->lock, flags);
-	list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
+	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
 	spin_unlock_irqrestore(&ib_conn->lock, flags);
 	return err;
 }
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 7bdb811..4809693 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -94,13 +94,13 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		device->iser_unreg_rdma_mem = iser_unreg_mem_fmr;
 	} else
 	if (dev_attr->device_cap_flags & IB_DEVICE_MEM_MGT_EXTENSIONS) {
-		iser_info("FRWR supported, using FRWR for registration\n");
-		device->iser_alloc_rdma_reg_res = iser_create_frwr_pool;
-		device->iser_free_rdma_reg_res = iser_free_frwr_pool;
-		device->iser_reg_rdma_mem = iser_reg_rdma_mem_frwr;
-		device->iser_unreg_rdma_mem = iser_unreg_mem_frwr;
+		iser_info("FR supported, using FastReg for registration\n");
+		device->iser_alloc_rdma_reg_res = iser_create_fastreg_pool;
+		device->iser_free_rdma_reg_res = iser_free_fastreg_pool;
+		device->iser_reg_rdma_mem = iser_reg_rdma_mem_fastreg;
+		device->iser_unreg_rdma_mem = iser_unreg_mem_fastreg;
 	} else {
-		iser_err("IB device does not support FMRs nor FRWRs, can't register memory\n");
+		iser_err("IB device does not support FMRs nor FastRegs, can't register memory\n");
 		goto dev_attr_err;
 	}
 
@@ -221,13 +221,13 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 	struct ib_fmr_pool_param params;
 	int ret = -ENOMEM;
 
-	ib_conn->fastreg.fmr.page_vec = kmalloc(sizeof(struct iser_page_vec) +
+	ib_conn->fmr.page_vec = kmalloc(sizeof(struct iser_page_vec) +
 						(sizeof(u64)*(ISCSI_ISER_SG_TABLESIZE + 1)),
 						GFP_KERNEL);
-	if (!ib_conn->fastreg.fmr.page_vec)
+	if (!ib_conn->fmr.page_vec)
 		return ret;
 
-	ib_conn->fastreg.fmr.page_vec->pages = (u64 *)(ib_conn->fastreg.fmr.page_vec + 1);
+	ib_conn->fmr.page_vec->pages = (u64 *)(ib_conn->fmr.page_vec + 1);
 
 	params.page_shift        = SHIFT_4K;
 	/* when the first/last SG element are not start/end *
@@ -243,16 +243,16 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 				    IB_ACCESS_REMOTE_WRITE |
 				    IB_ACCESS_REMOTE_READ);
 
-	ib_conn->fastreg.fmr.pool = ib_create_fmr_pool(device->pd, &params);
-	if (!IS_ERR(ib_conn->fastreg.fmr.pool))
+	ib_conn->fmr.pool = ib_create_fmr_pool(device->pd, &params);
+	if (!IS_ERR(ib_conn->fmr.pool))
 		return 0;
 
 	/* no FMR => no need for page_vec */
-	kfree(ib_conn->fastreg.fmr.page_vec);
-	ib_conn->fastreg.fmr.page_vec = NULL;
+	kfree(ib_conn->fmr.page_vec);
+	ib_conn->fmr.page_vec = NULL;
 
-	ret = PTR_ERR(ib_conn->fastreg.fmr.pool);
-	ib_conn->fastreg.fmr.pool = NULL;
+	ret = PTR_ERR(ib_conn->fmr.pool);
+	ib_conn->fmr.pool = NULL;
 	if (ret != -ENOSYS) {
 		iser_err("FMR allocation failed, err %d\n", ret);
 		return ret;
@@ -268,30 +268,30 @@ int iser_create_fmr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 void iser_free_fmr_pool(struct iser_conn *ib_conn)
 {
 	iser_info("freeing conn %p fmr pool %p\n",
-		  ib_conn, ib_conn->fastreg.fmr.pool);
+		  ib_conn, ib_conn->fmr.pool);
 
-	if (ib_conn->fastreg.fmr.pool != NULL)
-		ib_destroy_fmr_pool(ib_conn->fastreg.fmr.pool);
+	if (ib_conn->fmr.pool != NULL)
+		ib_destroy_fmr_pool(ib_conn->fmr.pool);
 
-	ib_conn->fastreg.fmr.pool = NULL;
+	ib_conn->fmr.pool = NULL;
 
-	kfree(ib_conn->fastreg.fmr.page_vec);
-	ib_conn->fastreg.fmr.page_vec = NULL;
+	kfree(ib_conn->fmr.page_vec);
+	ib_conn->fmr.page_vec = NULL;
 }
 
 /**
- * iser_create_frwr_pool - Creates pool of fast_reg descriptors
+ * iser_create_fastreg_pool - Creates pool of fast_reg descriptors
  * for fast registration work requests.
  * returns 0 on success, or errno code on failure
  */
-int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
+int iser_create_fastreg_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 {
 	struct iser_device	*device = ib_conn->device;
 	struct fast_reg_descriptor	*desc;
 	int i, ret;
 
-	INIT_LIST_HEAD(&ib_conn->fastreg.frwr.pool);
-	ib_conn->fastreg.frwr.pool_size = 0;
+	INIT_LIST_HEAD(&ib_conn->fastreg.pool);
+	ib_conn->fastreg.pool_size = 0;
 	for (i = 0; i < cmds_max; i++) {
 		desc = kmalloc(sizeof(*desc), GFP_KERNEL);
 		if (!desc) {
@@ -316,8 +316,8 @@ int iser_create_frwr_pool(struct iser_conn *ib_conn, unsigned cmds_max)
 			goto fast_reg_mr_failure;
 		}
 		desc->valid = true;
-		list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
-		ib_conn->fastreg.frwr.pool_size++;
+		list_add_tail(&desc->list, &ib_conn->fastreg.pool);
+		ib_conn->fastreg.pool_size++;
 	}
 
 	return 0;
@@ -327,24 +327,24 @@ fast_reg_mr_failure:
 fast_reg_page_failure:
 	kfree(desc);
 err:
-	iser_free_frwr_pool(ib_conn);
+	iser_free_fastreg_pool(ib_conn);
 	return ret;
 }
 
 /**
- * iser_free_frwr_pool - releases the pool of fast_reg descriptors
+ * iser_free_fastreg_pool - releases the pool of fast_reg descriptors
  */
-void iser_free_frwr_pool(struct iser_conn *ib_conn)
+void iser_free_fastreg_pool(struct iser_conn *ib_conn)
 {
 	struct fast_reg_descriptor *desc, *tmp;
 	int i = 0;
 
-	if (list_empty(&ib_conn->fastreg.frwr.pool))
+	if (list_empty(&ib_conn->fastreg.pool))
 		return;
 
-	iser_info("freeing conn %p frwr pool\n", ib_conn);
+	iser_info("freeing conn %p fr pool\n", ib_conn);
 
-	list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.frwr.pool, list) {
+	list_for_each_entry_safe(desc, tmp, &ib_conn->fastreg.pool, list) {
 		list_del(&desc->list);
 		ib_free_fast_reg_page_list(desc->data_frpl);
 		ib_dereg_mr(desc->data_mr);
@@ -352,9 +352,9 @@ void iser_free_frwr_pool(struct iser_conn *ib_conn)
 		++i;
 	}
 
-	if (i < ib_conn->fastreg.frwr.pool_size)
+	if (i < ib_conn->fastreg.pool_size)
 		iser_warn("pool still has %d regions registered\n",
-			  ib_conn->fastreg.frwr.pool_size - i);
+			  ib_conn->fastreg.pool_size - i);
 }
 
 /**
@@ -801,7 +801,7 @@ int iser_reg_page_vec(struct iser_conn     *ib_conn,
 	page_list = page_vec->pages;
 	io_addr	  = page_list[0];
 
-	mem  = ib_fmr_pool_map_phys(ib_conn->fastreg.fmr.pool,
+	mem  = ib_fmr_pool_map_phys(ib_conn->fmr.pool,
 				    page_list,
 				    page_vec->length,
 				    io_addr);
@@ -855,8 +855,8 @@ void iser_unreg_mem_fmr(struct iscsi_iser_task *iser_task,
 	reg->mem_h = NULL;
 }
 
-void iser_unreg_mem_frwr(struct iscsi_iser_task *iser_task,
-			 enum iser_data_dir cmd_dir)
+void iser_unreg_mem_fastreg(struct iscsi_iser_task *iser_task,
+			    enum iser_data_dir cmd_dir)
 {
 	struct iser_mem_reg *reg = &iser_task->rdma_regd[cmd_dir].reg;
 	struct iser_conn *ib_conn = iser_task->iser_conn->ib_conn;
@@ -868,7 +868,7 @@ void iser_unreg_mem_frwr(struct iscsi_iser_task *iser_task,
 	reg->mem_h = NULL;
 	reg->is_mr = 0;
 	spin_lock_bh(&ib_conn->lock);
-	list_add_tail(&desc->list, &ib_conn->fastreg.frwr.pool);
+	list_add_tail(&desc->list, &ib_conn->fastreg.pool);
 	spin_unlock_bh(&ib_conn->lock);
 }
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
