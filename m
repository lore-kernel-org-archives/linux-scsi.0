From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH v1 5/7] IB/isert: Accept RDMA_WRITE completions
Date: Thu, 16 Jan 2014 15:55:54 +0200
Message-ID: <1389880556-21059-6-git-send-email-sagig@mellanox.com>
References: <1389880556-21059-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389880556-21059-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@daterainc.com
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, oren@mellanox.com
List-Id: linux-scsi@vger.kernel.org

In case of protected transactions, we will need to check the
protection status of the transaction before sending SCSI response.
So be ready for RDMA_WRITE completions. currently we don't ask
for these completions, but for T10-PI we will.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index e5159ee..e4352c8 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1602,6 +1602,18 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
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
@@ -1721,8 +1733,9 @@ __isert_send_completion(struct iser_tx_desc *tx_desc,
 					  isert_conn, ib_dev);
 		break;
 	case ISER_IB_RDMA_WRITE:
-		pr_err("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
-		dump_stack();
+		pr_debug("isert_send_completion: Got ISER_IB_RDMA_WRITE\n");
+		atomic_dec(&isert_conn->post_send_buf_count);
+		isert_completion_rdma_write(tx_desc, isert_cmd);
 		break;
 	case ISER_IB_RDMA_READ:
 		pr_debug("isert_send_completion: Got ISER_IB_RDMA_READ:\n");
-- 
1.7.1
