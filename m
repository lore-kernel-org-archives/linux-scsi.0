From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 2/4] Target/iser: Consider DIF and RDMA_READ completions when calculating post_send counter
Date: Mon, 17 Mar 2014 12:52:17 +0200
Message-ID: <1395053539-31314-3-git-send-email-sagig@mellanox.com>
References: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: oren@mellanox.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If protection is involved, iSER target must wait for
completion of RDMA_READ before sending SCSI response.
So we must consider that when calculating post_send_buf_count
additions, also when processing good/error completions.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   47 +++++++++++++++++++++++++++----
 1 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e4ebb4c..faec224 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1705,6 +1705,7 @@ isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
 
 fail_mr_status:
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
+	wr->send_wr_num = 0;
 	if (ret)
 		transport_send_check_condition_and_sense(se_cmd,
 							 se_cmd->pi_err, 0);
@@ -1838,7 +1839,18 @@ isert_response_completion(struct iser_tx_desc *tx_desc,
 		queue_work(isert_comp_wq, &isert_cmd->comp_work);
 		return;
 	}
-	atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
+
+	/**
+	 * If send_wr_num is 0 this means that we got
+	 * RDMA completion and we cleared it and we should
+	 * simply decrement the response post. else the
+	 * response is incorporated in send_wr_num, just
+	 * sub it.
+	 **/
+	if (wr->send_wr_num)
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
+	else
+		atomic_dec(&isert_conn->post_send_buf_count);
 
 	cmd->i_state = ISTATE_SENT_STATUS;
 	isert_completion_put(tx_desc, isert_cmd, ib_dev);
@@ -1871,7 +1883,7 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
 		break;
 	case ISER_IB_RDMA_WRITE:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
-		atomic_dec(&isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 		isert_completion_rdma_write(tx_desc, isert_cmd);
 		break;
 	case ISER_IB_RDMA_READ:
@@ -1922,7 +1934,18 @@ isert_cq_drain_comp_llist(struct isert_conn *isert_conn, struct ib_device *ib_de
 		llnode = llist_next(llnode);
 		wr = &t->isert_cmd->rdma_wr;
 
-		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
+		/**
+		 * If send_wr_num is 0 this means that we got
+		 * RDMA completion and we cleared it and we should
+		 * simply decrement the response post. else the
+		 * response is incorporated in send_wr_num, just
+		 * sub it.
+		 **/
+		if (wr->send_wr_num)
+			atomic_sub(wr->send_wr_num,
+				   &isert_conn->post_send_buf_count);
+		else
+			atomic_dec(&isert_conn->post_send_buf_count);
 		isert_completion_put(t, t->isert_cmd, ib_dev);
 	}
 }
@@ -1941,7 +1964,18 @@ isert_cq_tx_comp_err(struct iser_tx_desc *tx_desc, struct isert_conn *isert_conn
 		llnode = llist_next(llnode);
 		wr = &t->isert_cmd->rdma_wr;
 
-		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
+		/**
+		 * If send_wr_num is 0 this means that we got
+		 * RDMA completion and we cleared it and we should
+		 * simply decrement the response post. else the
+		 * response is incorporated in send_wr_num, just
+		 * sub it.
+		 **/
+		if (wr->send_wr_num)
+			atomic_sub(wr->send_wr_num,
+				   &isert_conn->post_send_buf_count);
+		else
+			atomic_dec(&isert_conn->post_send_buf_count);
 		isert_completion_put(t, t->isert_cmd, ib_dev);
 	}
 	tx_desc->comp_llnode_batch = NULL;
@@ -2795,14 +2829,15 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 		isert_init_send_wr(isert_conn, isert_cmd,
 				   &isert_cmd->tx_desc.send_wr, true);
 		isert_cmd->rdma_wr.s_send_wr.next = &isert_cmd->tx_desc.send_wr;
+		wr->send_wr_num += 1;
 	}
 
-	atomic_add(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
+	atomic_add(wr->send_wr_num, &isert_conn->post_send_buf_count);
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
 	if (rc) {
 		pr_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
-		atomic_sub(wr->send_wr_num + 1, &isert_conn->post_send_buf_count);
+		atomic_sub(wr->send_wr_num, &isert_conn->post_send_buf_count);
 	}
 
 	if (se_cmd->prot_op == TARGET_PROT_NORMAL)
-- 
1.7.1
