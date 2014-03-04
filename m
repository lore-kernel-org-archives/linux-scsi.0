From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 4/6] iser-target: Fix post_send_buf_count for RDMA READ/WRITE
Date: Tue,  4 Mar 2014 00:01:03 +0000
Message-ID: <1393891265-22910-5-git-send-email-nab@daterainc.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes the incorrect setting of ->post_send_buf_count
related to RDMA WRITEs + READs where isert_rdma_rw->send_wr_num
was not being taken into account.

This includes incrementing ->post_send_buf_count within
isert_put_datain() + isert_get_dataout(), decrementing within
__isert_send_completion() + isert_response_completion(), and
clearing wr->send_wr_num within isert_completion_rdma_read()

This is necessary because even though IB_SEND_SIGNALED is
not set for RDMA WRITEs + READs, during a QP failure event
the work requests will be returned with exception status
from the TX completion queue.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 8283f5a..c9d488f 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1536,6 +1536,7 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	iscsit_stop_dataout_timer(cmd);
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
 	cmd->write_data_done = wr->cur_rdma_length;
+	wr->send_wr_num = 0;
 
 	pr_debug("Cmd: %p RDMA_READ comp calling execute_cmd\n", isert_cmd);
 	spin_lock_bh(&cmd->istate_lock);
@@ -1600,6 +1601,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 			  struct ib_device *ib_dev)
 {
 	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
+	struct isert_rdma_wr *wr = &isert_cmd->rdma_wr;
 
 	if (cmd->i_state == ISTATE_SEND_TASKMGTRSP ||
 	    cmd->i_state == ISTATE_SEND_LOGOUTRSP ||
@@ -1611,7 +1613,7 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 		queue_work(isert_comp_wq, &isert_cmd->comp_work);
 		return;
 	}
-	atomic_dec(&isert_conn->post_send_buf_count);
+	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
 	isert_completion_put(tx_desc, isert_cmd, ib_dev);
@@ -1649,7 +1651,7 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
 	case ISER_IB_RDMA_READ:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
 
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 		isert_completion_rdma_read(tx_desc, isert_cmd);
 		break;
 	default:
@@ -2375,12 +2377,12 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	isert_init_send_wr(isert_conn, isert_cmd,
 			   &isert_cmd->tx_desc.send_wr, true);
 
-	atomic_inc(&isert_conn->post_send_buf_count);
+	atomic_add(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
 	}
 	pr_debug("Cmd: %p posted RDMA_WRITE + Response for iSER Data READ\n",
 		 isert_cmd);
@@ -2408,12 +2410,12 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 		return rc;
 	}
 
-	atomic_inc(&isert_conn->post_send_buf_count);
+	atomic_add(wr->send_wr_num, &isert_conn->post_send_buf_count);
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 	}
 	pr_debug("Cmd: %p posted RDMA_READ memory for ISER Data WRITE\n",
 		 isert_cmd);
-- 
1.7.10.4
