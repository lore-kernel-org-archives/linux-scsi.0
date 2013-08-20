From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 1/2] iscsi/iser-target: Convert to command priv_size usage
Date: Tue, 20 Aug 2013 20:36:00 +0000
Message-ID: <1377030961-19831-2-git-send-email-nab@daterainc.com>
References: <1377030961-19831-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377030961-19831-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Kent Overstreet <kmo@daterainc.com>, Or Gerlitz <ogerlitz@mellanox.com>, Tejun Heo <tj@kernel.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This command converts iscsi/isert-target to use allocations based on
iscsit_transport->priv_size within iscsit_allocate_cmd(), instead of
using an embedded isert_cmd->iscsi_cmd.

This includes removing iscsit_transport->alloc_cmd() usage, along
with updating isert-target code to use iscsit_priv_cmd().

Also, remove left-over iscsit_transport->release_cmd() usage for
direct calls to iscsit_release_cmd(), and drop the now unused
lio_cmd_cache and isert_cmd_cache.

Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c      |  114 +++++++++-----------------
 drivers/infiniband/ulp/isert/ib_isert.h      |    2 +-
 drivers/target/iscsi/iscsi_target.c          |   16 +---
 drivers/target/iscsi/iscsi_target.h          |    1 -
 drivers/target/iscsi/iscsi_target_configfs.c |    2 +-
 drivers/target/iscsi/iscsi_target_core.h     |    1 -
 drivers/target/iscsi/iscsi_target_util.c     |   20 ++---
 include/target/iscsi/iscsi_transport.h       |    8 +-
 8 files changed, 55 insertions(+), 109 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d17ff13..a535b22 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -39,7 +39,6 @@ static DEFINE_MUTEX(device_list_mutex);
 static LIST_HEAD(device_list);
 static struct workqueue_struct *isert_rx_wq;
 static struct workqueue_struct *isert_comp_wq;
-static struct kmem_cache *isert_cmd_cache;
 
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
@@ -879,43 +878,30 @@ isert_rx_login_req(struct iser_rx_desc *rx_desc, int rx_buflen,
 	schedule_delayed_work(&conn->login_work, 0);
 }
 
-static void
-isert_release_cmd(struct iscsi_cmd *cmd)
-{
-	struct isert_cmd *isert_cmd = container_of(cmd, struct isert_cmd,
-						   iscsi_cmd);
-
-	pr_debug("Entering isert_release_cmd %p >>>>>>>>>>>>>>>.\n", isert_cmd);
-
-	kfree(cmd->buf_ptr);
-	kfree(cmd->tmr_req);
-
-	kmem_cache_free(isert_cmd_cache, isert_cmd);
-}
-
 static struct iscsi_cmd
-*isert_alloc_cmd(struct iscsi_conn *conn, gfp_t gfp)
+*isert_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp)
 {
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct isert_cmd *isert_cmd;
+	struct iscsi_cmd *cmd;
 
-	isert_cmd = kmem_cache_zalloc(isert_cmd_cache, gfp);
-	if (!isert_cmd) {
-		pr_err("Unable to allocate isert_cmd\n");
+	cmd = iscsit_allocate_cmd(conn, gfp);
+	if (!cmd) {
+		pr_err("Unable to allocate iscsi_cmd + isert_cmd\n");
 		return NULL;
 	}
+	isert_cmd = iscsit_priv_cmd(cmd);
 	isert_cmd->conn = isert_conn;
-	isert_cmd->iscsi_cmd.release_cmd = &isert_release_cmd;
+	isert_cmd->iscsi_cmd = cmd;
 
-	return &isert_cmd->iscsi_cmd;
+	return cmd;
 }
 
 static int
 isert_handle_scsi_cmd(struct isert_conn *isert_conn,
-		      struct isert_cmd *isert_cmd, struct iser_rx_desc *rx_desc,
-		      unsigned char *buf)
+		      struct isert_cmd *isert_cmd, struct iscsi_cmd *cmd,
+		      struct iser_rx_desc *rx_desc, unsigned char *buf)
 {
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
 	struct iscsi_conn *conn = isert_conn->conn;
 	struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)buf;
 	struct scatterlist *sg;
@@ -1022,9 +1008,9 @@ isert_handle_iscsi_dataout(struct isert_conn *isert_conn,
 
 static int
 isert_handle_nop_out(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
-		     struct iser_rx_desc *rx_desc, unsigned char *buf)
+		     struct iscsi_cmd *cmd, struct iser_rx_desc *rx_desc,
+		     unsigned char *buf)
 {
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
 	struct iscsi_conn *conn = isert_conn->conn;
 	struct iscsi_nopout *hdr = (struct iscsi_nopout *)buf;
 	int rc;
@@ -1041,9 +1027,9 @@ isert_handle_nop_out(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 
 static int
 isert_handle_text_cmd(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
-		      struct iser_rx_desc *rx_desc, struct iscsi_text *hdr)
+		      struct iscsi_cmd *cmd, struct iser_rx_desc *rx_desc,
+		      struct iscsi_text *hdr)
 {
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
 	struct iscsi_conn *conn = isert_conn->conn;
 	u32 payload_length = ntoh24(hdr->dlength);
 	int rc;
@@ -1088,26 +1074,26 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 
 	switch (opcode) {
 	case ISCSI_OP_SCSI_CMD:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
 		if (!cmd)
 			break;
 
-		isert_cmd = container_of(cmd, struct isert_cmd, iscsi_cmd);
+		isert_cmd = iscsit_priv_cmd(cmd);
 		isert_cmd->read_stag = read_stag;
 		isert_cmd->read_va = read_va;
 		isert_cmd->write_stag = write_stag;
 		isert_cmd->write_va = write_va;
 
-		ret = isert_handle_scsi_cmd(isert_conn, isert_cmd,
+		ret = isert_handle_scsi_cmd(isert_conn, isert_cmd, cmd,
 					rx_desc, (unsigned char *)hdr);
 		break;
 	case ISCSI_OP_NOOP_OUT:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
 		if (!cmd)
 			break;
 
-		isert_cmd = container_of(cmd, struct isert_cmd, iscsi_cmd);
-		ret = isert_handle_nop_out(isert_conn, isert_cmd,
+		isert_cmd = iscsit_priv_cmd(cmd);
+		ret = isert_handle_nop_out(isert_conn, isert_cmd, cmd,
 					   rx_desc, (unsigned char *)hdr);
 		break;
 	case ISCSI_OP_SCSI_DATA_OUT:
@@ -1115,7 +1101,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 						(unsigned char *)hdr);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
 		if (!cmd)
 			break;
 
@@ -1123,7 +1109,7 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 						(unsigned char *)hdr);
 		break;
 	case ISCSI_OP_LOGOUT:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
 		if (!cmd)
 			break;
 
@@ -1134,12 +1120,12 @@ isert_rx_opcode(struct isert_conn *isert_conn, struct iser_rx_desc *rx_desc,
 						    HZ);
 		break;
 	case ISCSI_OP_TEXT:
-		cmd = iscsit_allocate_cmd(conn, GFP_KERNEL);
+		cmd = isert_allocate_cmd(conn, GFP_KERNEL);
 		if (!cmd)
 			break;
 
-		isert_cmd = container_of(cmd, struct isert_cmd, iscsi_cmd);
-		ret = isert_handle_text_cmd(isert_conn, isert_cmd,
+		isert_cmd = iscsit_priv_cmd(cmd);
+		ret = isert_handle_text_cmd(isert_conn, isert_cmd, cmd,
 					    rx_desc, (struct iscsi_text *)hdr);
 		break;
 	default:
@@ -1267,7 +1253,7 @@ isert_unmap_cmd(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn)
 static void
 isert_put_cmd(struct isert_cmd *isert_cmd)
 {
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct iscsi_conn *conn = isert_conn->conn;
 
@@ -1318,7 +1304,7 @@ isert_put_cmd(struct isert_cmd *isert_cmd)
 		 * Fall-through
 		 */
 	default:
-		isert_release_cmd(cmd);
+		iscsit_release_cmd(cmd);
 		break;
 	}
 }
@@ -1354,7 +1340,7 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 			   struct isert_cmd *isert_cmd)
 {
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct ib_device *ib_dev = isert_cmd->conn->conn_cm_id->device;
 
@@ -1390,7 +1376,7 @@ isert_do_control_comp(struct work_struct *work)
 			struct isert_cmd, comp_work);
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 
 	switch (cmd->i_state) {
 	case ISTATE_SEND_TASKMGTRSP:
@@ -1436,7 +1422,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 			  struct isert_conn *isert_conn,
 			  struct ib_device *ib_dev)
 {
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 
 	if (cmd->i_state == ISTATE_SEND_TASKMGTRSP ||
 	    cmd->i_state == ISTATE_SEND_LOGOUTRSP ||
@@ -1628,8 +1614,7 @@ isert_post_response(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd)
 static int
 isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
-	struct isert_cmd *isert_cmd = container_of(cmd,
-					struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 	struct iscsi_scsi_rsp *hdr = (struct iscsi_scsi_rsp *)
@@ -1678,8 +1663,7 @@ static int
 isert_put_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 		bool nopout_response)
 {
-	struct isert_cmd *isert_cmd = container_of(cmd,
-				struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 
@@ -1698,8 +1682,7 @@ isert_put_nopin(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
 static int
 isert_put_logout_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct isert_cmd *isert_cmd = container_of(cmd,
-				struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 
@@ -1717,8 +1700,7 @@ isert_put_logout_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 static int
 isert_put_tm_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct isert_cmd *isert_cmd = container_of(cmd,
-				struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 
@@ -1736,8 +1718,7 @@ isert_put_tm_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 static int
 isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct isert_cmd *isert_cmd = container_of(cmd,
-				struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
@@ -1769,8 +1750,7 @@ isert_put_reject(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 static int
 isert_put_text_rsp(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
 {
-	struct isert_cmd *isert_cmd = container_of(cmd,
-				struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *send_wr = &isert_cmd->tx_desc.send_wr;
 	struct iscsi_text_rsp *hdr =
@@ -1812,7 +1792,7 @@ isert_build_rdma_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 		    struct ib_sge *ib_sge, struct ib_send_wr *send_wr,
 		    u32 data_left, u32 offset)
 {
-	struct iscsi_cmd *cmd = &isert_cmd->iscsi_cmd;
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
 	struct scatterlist *sg_start, *tmp_sg;
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	u32 sg_off, page_off;
@@ -1857,8 +1837,7 @@ static int
 isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct isert_cmd *isert_cmd = container_of(cmd,
-					struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *wr_failed, *send_wr;
@@ -1961,8 +1940,7 @@ static int
 isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 {
 	struct se_cmd *se_cmd = &cmd->se_cmd;
-	struct isert_cmd *isert_cmd = container_of(cmd,
-					struct isert_cmd, iscsi_cmd);
+	struct isert_cmd *isert_cmd = iscsit_priv_cmd(cmd);
 	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 	struct isert_conn *isert_conn = (struct isert_conn *)conn->context;
 	struct ib_send_wr *wr_failed, *send_wr;
@@ -2408,12 +2386,12 @@ static void isert_free_conn(struct iscsi_conn *conn)
 static struct iscsit_transport iser_target_transport = {
 	.name			= "IB/iSER",
 	.transport_type		= ISCSI_INFINIBAND,
+	.priv_size		= sizeof(struct isert_cmd),
 	.owner			= THIS_MODULE,
 	.iscsit_setup_np	= isert_setup_np,
 	.iscsit_accept_np	= isert_accept_np,
 	.iscsit_free_np		= isert_free_np,
 	.iscsit_free_conn	= isert_free_conn,
-	.iscsit_alloc_cmd	= isert_alloc_cmd,
 	.iscsit_get_login_rx	= isert_get_login_rx,
 	.iscsit_put_login_tx	= isert_put_login_tx,
 	.iscsit_immediate_queue	= isert_immediate_queue,
@@ -2440,21 +2418,10 @@ static int __init isert_init(void)
 		goto destroy_rx_wq;
 	}
 
-	isert_cmd_cache = kmem_cache_create("isert_cmd_cache",
-			sizeof(struct isert_cmd), __alignof__(struct isert_cmd),
-			0, NULL);
-	if (!isert_cmd_cache) {
-		pr_err("Unable to create isert_cmd_cache\n");
-		ret = -ENOMEM;
-		goto destroy_tx_cq;
-	}
-
 	iscsit_register_transport(&iser_target_transport);
 	pr_debug("iSER_TARGET[0] - Loaded iser_target_transport\n");
 	return 0;
 
-destroy_tx_cq:
-	destroy_workqueue(isert_comp_wq);
 destroy_rx_wq:
 	destroy_workqueue(isert_rx_wq);
 	return ret;
@@ -2462,7 +2429,6 @@ destroy_rx_wq:
 
 static void __exit isert_exit(void)
 {
-	kmem_cache_destroy(isert_cmd_cache);
 	destroy_workqueue(isert_comp_wq);
 	destroy_workqueue(isert_rx_wq);
 	iscsit_unregister_transport(&iser_target_transport);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 191117b..0d45945 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -67,7 +67,7 @@ struct isert_cmd {
 	u32			write_va_off;
 	u32			rdma_wr_num;
 	struct isert_conn	*conn;
-	struct iscsi_cmd	iscsi_cmd;
+	struct iscsi_cmd	*iscsi_cmd;
 	struct ib_sge		*ib_sge;
 	struct iser_tx_desc	tx_desc;
 	struct isert_rdma_wr	rdma_wr;
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7228cc7..92f2776 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -63,7 +63,6 @@ spinlock_t sess_idr_lock;
 
 struct iscsit_global *iscsit_global;
 
-struct kmem_cache *lio_cmd_cache;
 struct kmem_cache *lio_qr_cache;
 struct kmem_cache *lio_dr_cache;
 struct kmem_cache *lio_ooo_cache;
@@ -500,7 +499,6 @@ static struct iscsit_transport iscsi_target_transport = {
 	.iscsit_setup_np	= iscsit_setup_np,
 	.iscsit_accept_np	= iscsit_accept_np,
 	.iscsit_free_np		= iscsit_free_np,
-	.iscsit_alloc_cmd	= iscsit_alloc_cmd,
 	.iscsit_get_login_rx	= iscsit_get_login_rx,
 	.iscsit_put_login_tx	= iscsit_put_login_tx,
 	.iscsit_get_dataout	= iscsit_build_r2ts_for_cmd,
@@ -541,22 +539,13 @@ static int __init iscsi_target_init_module(void)
 		goto ts_out1;
 	}
 
-	lio_cmd_cache = kmem_cache_create("lio_cmd_cache",
-			sizeof(struct iscsi_cmd), __alignof__(struct iscsi_cmd),
-			0, NULL);
-	if (!lio_cmd_cache) {
-		pr_err("Unable to kmem_cache_create() for"
-				" lio_cmd_cache\n");
-		goto ts_out2;
-	}
-
 	lio_qr_cache = kmem_cache_create("lio_qr_cache",
 			sizeof(struct iscsi_queue_req),
 			__alignof__(struct iscsi_queue_req), 0, NULL);
 	if (!lio_qr_cache) {
 		pr_err("nable to kmem_cache_create() for"
 				" lio_qr_cache\n");
-		goto cmd_out;
+		goto ts_out2;
 	}
 
 	lio_dr_cache = kmem_cache_create("lio_dr_cache",
@@ -600,8 +589,6 @@ dr_out:
 	kmem_cache_destroy(lio_dr_cache);
 qr_out:
 	kmem_cache_destroy(lio_qr_cache);
-cmd_out:
-	kmem_cache_destroy(lio_cmd_cache);
 ts_out2:
 	iscsi_deallocate_thread_sets();
 ts_out1:
@@ -619,7 +606,6 @@ static void __exit iscsi_target_cleanup_module(void)
 	iscsi_thread_set_free();
 	iscsit_release_discovery_tpg();
 	iscsit_unregister_transport(&iscsi_target_transport);
-	kmem_cache_destroy(lio_cmd_cache);
 	kmem_cache_destroy(lio_qr_cache);
 	kmem_cache_destroy(lio_dr_cache);
 	kmem_cache_destroy(lio_ooo_cache);
diff --git a/drivers/target/iscsi/iscsi_target.h b/drivers/target/iscsi/iscsi_target.h
index f82f627..e936d56 100644
--- a/drivers/target/iscsi/iscsi_target.h
+++ b/drivers/target/iscsi/iscsi_target.h
@@ -39,7 +39,6 @@ extern struct target_fabric_configfs *lio_target_fabric_configfs;
 
 extern struct kmem_cache *lio_dr_cache;
 extern struct kmem_cache *lio_ooo_cache;
-extern struct kmem_cache *lio_cmd_cache;
 extern struct kmem_cache *lio_qr_cache;
 extern struct kmem_cache *lio_r2t_cache;
 
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index ddfa32c..116114f 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1925,7 +1925,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	pr_debug("Entering lio_release_cmd for se_cmd: %p\n", se_cmd);
-	cmd->release_cmd(cmd);
+	iscsit_release_cmd(cmd);
 }
 
 /* End functions for target_core_fabric_ops */
diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index 8a4c32d..5e1a068 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -489,7 +489,6 @@ struct iscsi_cmd {
 	u32			first_data_sg_off;
 	u32			kmapped_nents;
 	sense_reason_t		sense_reason;
-	void (*release_cmd)(struct iscsi_cmd *);
 }  ____cacheline_aligned;
 
 struct iscsi_tmr_req {
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1df06d5..5784cad 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -149,18 +149,6 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
 	spin_unlock_bh(&cmd->r2t_lock);
 }
 
-struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
-{
-	struct iscsi_cmd *cmd;
-
-	cmd = kmem_cache_zalloc(lio_cmd_cache, gfp_mask);
-	if (!cmd)
-		return NULL;
-
-	cmd->release_cmd = &iscsit_release_cmd;
-	return cmd;
-}
-
 /*
  * May be called from software interrupt (timer) context for allocating
  * iSCSI NopINs.
@@ -168,8 +156,9 @@ struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
 {
 	struct iscsi_cmd *cmd;
+	int priv_size = conn->conn_transport->priv_size;
 
-	cmd = conn->conn_transport->iscsit_alloc_cmd(conn, gfp_mask);
+	cmd = kzalloc(sizeof(struct iscsi_cmd) + priv_size, gfp_mask);
 	if (!cmd) {
 		pr_err("Unable to allocate memory for struct iscsi_cmd.\n");
 		return NULL;
@@ -696,8 +685,9 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 	kfree(cmd->iov_data);
 	kfree(cmd->text_in_ptr);
 
-	kmem_cache_free(lio_cmd_cache, cmd);
+	kfree(cmd);
 }
+EXPORT_SYMBOL(iscsit_release_cmd);
 
 static void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool scsi_cmd,
 			      bool check_queues)
@@ -761,7 +751,7 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 		/* Fall-through */
 	default:
 		__iscsit_free_cmd(cmd, false, shutdown);
-		cmd->release_cmd(cmd);
+		iscsit_release_cmd(cmd);
 		break;
 	}
 }
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index e5d09d2..a12589c 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -6,13 +6,13 @@ struct iscsit_transport {
 #define ISCSIT_TRANSPORT_NAME	16
 	char name[ISCSIT_TRANSPORT_NAME];
 	int transport_type;
+	int priv_size;
 	struct module *owner;
 	struct list_head t_node;
 	int (*iscsit_setup_np)(struct iscsi_np *, struct __kernel_sockaddr_storage *);
 	int (*iscsit_accept_np)(struct iscsi_np *, struct iscsi_conn *);
 	void (*iscsit_free_np)(struct iscsi_np *);
 	void (*iscsit_free_conn)(struct iscsi_conn *);
-	struct iscsi_cmd *(*iscsit_alloc_cmd)(struct iscsi_conn *, gfp_t);
 	int (*iscsit_get_login_rx)(struct iscsi_conn *, struct iscsi_login *);
 	int (*iscsit_put_login_tx)(struct iscsi_conn *, struct iscsi_login *, u32);
 	int (*iscsit_immediate_queue)(struct iscsi_conn *, struct iscsi_cmd *, int);
@@ -22,6 +22,11 @@ struct iscsit_transport {
 	int (*iscsit_queue_status)(struct iscsi_conn *, struct iscsi_cmd *);
 };
 
+static inline void *iscsit_priv_cmd(struct iscsi_cmd *cmd)
+{
+	return (void *)(cmd + 1);
+}
+
 /*
  * From iscsi_target_transport.c
  */
@@ -92,3 +97,4 @@ extern int iscsit_tmr_post_handler(struct iscsi_cmd *, struct iscsi_conn *);
 extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, gfp_t);
 extern int iscsit_sequence_cmd(struct iscsi_conn *, struct iscsi_cmd *,
 			       unsigned char *, __be32);
+extern void iscsit_release_cmd(struct iscsi_cmd *);
-- 
1.7.10.4
