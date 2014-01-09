From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 09/11] IB/isert: Accept RDMA_WRITE completions
Date: Thu,  9 Jan 2014 18:40:56 +0200
Message-ID: <1389285658-7037-10-git-send-email-sagig@mellanox.com>
References: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailp.voltaire.com ([193.47.165.129]:57716 "EHLO mellanox.co.il"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755354AbaAIQlJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jan 2014 11:41:09 -0500
In-Reply-To: <1389285658-7037-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, martin.petersen@oracle.com, nab@linux-iscsi.org, ogerlitz@mellanox.com, oren@mellanox.com

In case of protected transactions, we will need to check the
protection status of the transaction before sending SCSI response.
So be ready for RDMA_WRITE completions. currently we don't ask
for these completions, but for T10-PI we will.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 98aab21..9aa933e 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -51,6 +51,8 @@ isert_unreg_rdma(struct isert_cmd *isert_cmd, struct isert_conn *isert_conn);
 static int
 isert_reg_rdma(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 	       struct isert_rdma_wr *wr);
+static int
+isert_put_response(struct iscsi_conn *conn, struct iscsi_cmd *cmd);
 
 static void
 isert_qp_event_callback(struct ib_event *e, void *context)
@@ -1602,6 +1604,18 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 }
 
 static void
+isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
+			    struct isert_cmd *isert_cmd)
+{
+	struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
+	struct isert_conn *isert_conn = isert_cmd->conn;
+	struct isert_device *device = isert_conn->conn_device;
+
+	device->unreg_rdma_mem(isert_cmd, isert_conn);
+	isert_put_response(isert_conn->conn, cmd);
+}
+
+static void
 isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 			   struct isert_cmd *isert_cmd)
 {
@@ -1721,9 +1735,9 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
 					  isert_conn, ib_dev);
 		break;
 	case ISER_IB_RDMA_WRITE:
-		pr_err("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
-		dump_stack();
-		break;
+		pr_debug("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
+		atomic_dec(&isert_conn->post_send_buf_count);
+		isert_completion_rdma_write(tx_desc, isert_cmd);
 	case ISER_IB_RDMA_READ:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
 
-- 
1.7.1

