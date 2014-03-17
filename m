From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 3/4] Target/iser: Move check signature status to a function
Date: Mon, 17 Mar 2014 12:52:18 +0200
Message-ID: <1395053539-31314-4-git-send-email-sagig@mellanox.com>
References: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: oren@mellanox.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove code duplication from RDMA_READ and RDMA_WRITE
completions that do basically the same check.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |  115 +++++++++++++-----------------
 1 files changed, 50 insertions(+), 65 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index faec224..e2d48a9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1657,6 +1657,50 @@ isert_completion_put(struct iser_tx_desc *tx_desc, struct isert_cmd *isert_cmd,
 	isert_put_cmd(isert_cmd);
 }
 
+static int
+isert_check_pi_status(struct se_cmd *se_cmd, struct ib_mr *sig_mr)
+{
+	struct ib_mr_status mr_status;
+	int ret;
+
+	ret = ib_check_mr_status(sig_mr, IB_MR_CHECK_SIG_STATUS, &mr_status);
+	if (ret) {
+		pr_err("ib_check_mr_status failed, ret %d\n", ret);
+		goto fail_mr_status;
+	}
+
+	if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
+		u64 sec_offset_err;
+		u32 block_size = se_cmd->se_dev->dev_attrib.block_size + 8;
+
+		switch (mr_status.sig_err.err_type) {
+		case IB_SIG_BAD_GUARD:
+			se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+			break;
+		case IB_SIG_BAD_REFTAG:
+			se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
+			break;
+		case IB_SIG_BAD_APPTAG:
+			se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
+			break;
+		}
+		sec_offset_err = mr_status.sig_err.sig_err_offset;
+		do_div(sec_offset_err, block_size);
+		se_cmd->bad_sector = sec_offset_err + se_cmd->t_task_lba;
+
+		pr_err("isert: PI error found type %d at sector 0x%llx "
+		       "expected 0x%x vs actual 0x%x\n",
+		       mr_status.sig_err.err_type,
+		       (unsigned long long)se_cmd->bad_sector,
+		       mr_status.sig_err.expected,
+		       mr_status.sig_err.actual);
+		ret = 1;
+	}
+
+fail_mr_status:
+	return ret;
+}
+
 static void
 isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
 			    struct isert_cmd *isert_cmd)
@@ -1666,44 +1710,14 @@ isert_completion_rdma_write(struct iser_tx_desc *tx_desc,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct isert_device *device = isert_conn->conn_device;
-	struct ib_mr_status mr_status;
 	int ret = 0;
 
 	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
-		ret = ib_check_mr_status(wr->fr_desc->pi_ctx->sig_mr,
-					 IB_MR_CHECK_SIG_STATUS, &mr_status);
-		if (ret) {
-			pr_err("ib_check_mr_status failed, ret %d\n", ret);
-			goto fail_mr_status;
-		}
-		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
-			u32 block_size = se_cmd->se_dev->dev_attrib.block_size + 8;
-
-			switch (mr_status.sig_err.err_type) {
-			case IB_SIG_BAD_GUARD:
-				se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-				break;
-			case IB_SIG_BAD_REFTAG:
-				se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
-				break;
-			case IB_SIG_BAD_APPTAG:
-				se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-				break;
-			}
-			se_cmd->bad_sector = mr_status.sig_err.sig_err_offset;
-			do_div(se_cmd->bad_sector, block_size);
-
-			pr_err("isert: PI error found type %d at sector 0x%llx "
-			       "expected 0x%x vs actual 0x%x\n",
-			       mr_status.sig_err.err_type,
-			       (unsigned long long)se_cmd->bad_sector,
-			       mr_status.sig_err.expected,
-			       mr_status.sig_err.actual);
-			ret = 1;
-		}
+		ret = isert_check_pi_status(se_cmd,
+					    wr->fr_desc->pi_ctx->sig_mr);
+		wr->fr_desc->ind &= ~ISERT_PROTECTED;
 	}
 
-fail_mr_status:
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
 	wr->send_wr_num = 0;
 	if (ret)
@@ -1722,43 +1736,14 @@ isert_completion_rdma_read(struct iser_tx_desc *tx_desc,
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 	struct isert_conn *isert_conn = isert_cmd->conn;
 	struct isert_device *device = isert_conn->conn_device;
-	struct ib_mr_status mr_status;
 	int ret;
 
 	if (wr->fr_desc && wr->fr_desc->ind & ISERT_PROTECTED) {
-		ret = ib_check_mr_status(wr->fr_desc->pi_ctx->sig_mr,
-					 IB_MR_CHECK_SIG_STATUS, &mr_status);
-		if (ret) {
-			pr_err("ib_check_mr_status failed, ret %d\n", ret);
-			goto fail_mr_status;
-		}
-		if (mr_status.fail_status & IB_MR_CHECK_SIG_STATUS) {
-			u32 block_size = se_cmd->se_dev->dev_attrib.block_size + 8;
-
-			switch (mr_status.sig_err.err_type) {
-			case IB_SIG_BAD_GUARD:
-				se_cmd->pi_err = TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
-				break;
-			case IB_SIG_BAD_REFTAG:
-				se_cmd->pi_err = TCM_LOGICAL_BLOCK_REF_TAG_CHECK_FAILED;
-				break;
-			case IB_SIG_BAD_APPTAG:
-				se_cmd->pi_err = TCM_LOGICAL_BLOCK_APP_TAG_CHECK_FAILED;
-				break;
-			}
-			se_cmd->bad_sector = mr_status.sig_err.sig_err_offset;
-			do_div(se_cmd->bad_sector, block_size);
-
-			pr_err("isert: PI error found type %d at sector 0x%llx "
-			       "expected 0x%x vs actual 0x%x\n",
-			       mr_status.sig_err.err_type,
-			       (unsigned long long)se_cmd->bad_sector,
-			       mr_status.sig_err.expected,
-			       mr_status.sig_err.actual);
-		}
+		ret = isert_check_pi_status(se_cmd,
+					    wr->fr_desc->pi_ctx->sig_mr);
+		wr->fr_desc->ind &= ~ISERT_PROTECTED;
 	}
 
-fail_mr_status:
 	iscsit_stop_dataout_timer(cmd);
 	device->unreg_rdma_mem(isert_cmd, isert_conn);
 	cmd->write_data_done = wr->data.len;
-- 
1.7.1
