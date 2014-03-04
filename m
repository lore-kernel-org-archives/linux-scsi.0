From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 6/6] iser-target: Fix command leak for tx_desc->comp_llnode_batch
Date: Tue,  4 Mar 2014 00:01:05 +0000
Message-ID: <1393891265-22910-7-git-send-email-nab@daterainc.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a number of active I/O shutdown issues
related to isert_cmd descriptors being leaked that are part
of a completion interrupt coalescing batch.

This includes adding logic in isert_cq_tx_comp_err() to
drain any associated tx_desc->comp_llnode_batch, as well
as isert_cq_drain_comp_llist() to drain any associated
isert_conn->conn_comp_llist.

Also, set tx_desc->llnode_active in isert_init_send_wr()
in order to determine when work requests need to be skipped
in isert_cq_tx_work() exception path code.

Finally, update isert_init_send_wr() to only allow interrupt
coalescing when ISER_CONN_UP.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   50 +++++++++++++++++++++++++++----
 drivers/infiniband/ulp/isert/ib_isert.h |    2 +-
 2 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 003b5d0..fdd3042 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -484,7 +484,6 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 	kref_init(&isert_conn->conn_kref);
 	kref_get(&isert_conn->conn_kref);
 	mutex_init(&isert_conn->conn_mutex);
-	mutex_init(&isert_conn->conn_comp_mutex);
 	spin_lock_init(&isert_conn->conn_lock);
 
 	cma_id->context = isert_conn;
@@ -875,16 +874,17 @@ isert_init_send_wr(struct isert_conn *isert_conn, struct isert_cmd *isert_cmd,
 	 * Coalesce send completion interrupts by only setting IB_SEND_SIGNALED
 	 * bit for every ISERT_COMP_BATCH_COUNT number of ib_post_send() calls.
 	 */
-	mutex_lock(&isert_conn->conn_comp_mutex);
-	if (coalesce &&
+	mutex_lock(&isert_conn->conn_mutex);
+	if (coalesce && isert_conn->state == ISER_CONN_UP &&
 	    ++isert_conn->conn_comp_batch < ISERT_COMP_BATCH_COUNT) {
+		tx_desc->llnode_active = true;
 		llist_add(&tx_desc->comp_llnode, &isert_conn->conn_comp_llist);
-		mutex_unlock(&isert_conn->conn_comp_mutex);
+		mutex_unlock(&isert_conn->conn_mutex);
 		return;
 	}
 	isert_conn->conn_comp_batch = 0;
 	tx_desc->comp_llnode_batch = llist_del_all(&isert_conn->conn_comp_llist);
-	mutex_unlock(&isert_conn->conn_comp_mutex);
+	mutex_unlock(&isert_conn->conn_mutex);
 
 	send_wr->send_flags = IB_SEND_SIGNALED;
 }
@@ -1680,10 +1680,45 @@ isert_send_completion(struct iser_tx_desc *tx_desc,
 }
 
 static void
+isert_cq_drain_comp_llist(struct isert_conn *isert_conn, struct ib_device *ib_dev)
+{
+	struct llist_node *llnode;
+	struct isert_rdma_wr *wr;
+	struct iser_tx_desc *t;
+
+	mutex_lock(&isert_conn->conn_mutex);
+	llnode = llist_del_all(&isert_conn->conn_comp_llist);
+	isert_conn->conn_comp_batch = 0;
+	mutex_unlock(&isert_conn->conn_mutex);
+
+	while (llnode) {
+		t = llist_entry(llnode, struct iser_tx_desc, comp_llnode);
+		llnode = llist_next(llnode);
+		wr = &t->isert_cmd->rdma_wr;
+
+		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
+		isert_completion_put(t, t->isert_cmd, ib_dev);
+	}
+}
+
+static void
 isert_cq_tx_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn)
 {
 	struct ib_device *ib_dev = isert_conn->conn_cm_id->device;
 	struct isert_cmd *isert_cmd = tx_desc->isert_cmd;
+	struct llist_node *llnode = tx_desc->comp_llnode_batch;
+	struct isert_rdma_wr *wr;
+	struct iser_tx_desc *t;
+
+	while (llnode) {
+		t = llist_entry(llnode, struct iser_tx_desc, comp_llnode);
+		llnode = llist_next(llnode);
+		wr = &t->isert_cmd->rdma_wr;
+
+		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
+		isert_completion_put(t, t->isert_cmd, ib_dev);
+	}
+	tx_desc->comp_llnode_batch = NULL;
 
 	if (!isert_cmd)
 		isert_unmap_tx_desc(tx_desc, ib_dev);
@@ -1700,6 +1735,8 @@ isert_cq_rx_comp_err(struct isert_conn *isert_conn)
 	if (isert_conn->post_recv_buf_count)
 		return;
 
+	isert_cq_drain_comp_llist(isert_conn, ib_dev);
+
 	if (conn->sess) {
 		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
 		target_wait_for_sess_cmds(conn->sess->se_sess);
@@ -1739,6 +1776,9 @@ isert_cq_tx_work(struct work_struct *work)
 			pr_debug("TX wc.vendor_err: 0x%08x\n", wc.vendor_err);
 
 			if (wc.wr_id != ISER_FRWR_LI_WRID) {
+				if (tx_desc->llnode_active)
+					continue;
+
 				atomic_dec(&isert_conn->post_send_buf_count);
 				isert_cq_tx_comp_err(tx_desc, isert_conn);
 			}
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 599b4e2..6059ae1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -46,6 +46,7 @@ struct iser_tx_desc {
 	struct isert_cmd *isert_cmd;
 	struct llist_node *comp_llnode_batch;
 	struct llist_node comp_llnode;
+	bool		llnode_active;
 	struct ib_send_wr send_wr;
 } __packed;
 
@@ -127,7 +128,6 @@ struct isert_conn {
 #define ISERT_COMP_BATCH_COUNT	8
 	int			conn_comp_batch;
 	struct llist_head	conn_comp_llist;
-	struct mutex		conn_comp_mutex;
 };
 
 #define ISERT_MAX_CQ 64
-- 
1.7.10.4
