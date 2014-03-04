From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 5/6] iser-target: Ignore completions for FRWRs in isert_cq_tx_work
Date: Tue,  4 Mar 2014 00:01:04 +0000
Message-ID: <1393891265-22910-6-git-send-email-nab@daterainc.com>
References: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1393891265-22910-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes IB_WR_FAST_REG_MR + IB_WR_LOCAL_INV related
work requests to include a ISER_FRWR_LI_WRID value in order to
signal isert_cq_tx_work() that these requests should be ignored.

This is necessary because even though IB_SEND_SIGNALED is not
set for either work request, during a QP failure event the work
requests will be returned with exception status from the TX
completion queue.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    8 ++++++--
 drivers/infiniband/ulp/isert/ib_isert.h |    1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index c9d488f..003b5d0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1738,8 +1738,10 @@ isert_cq_tx_work(struct work_struct *work)
 			pr_debug("TX wc.status: 0x%08x\n", wc.status);
 			pr_debug("TX wc.vendor_err: 0x%08x\n", wc.vendor_err);
 
-			atomic_dec(&isert_conn->post_send_buf_count);
-			isert_cq_tx_comp_err(tx_desc, isert_conn);
+			if (wc.wr_id != ISER_FRWR_LI_WRID) {
+				atomic_dec(&isert_conn->post_send_buf_count);
+				isert_cq_tx_comp_err(tx_desc, isert_conn);
+			}
 		}
 	}
 
@@ -2202,6 +2204,7 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 
 	if (!fr_desc->valid) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
+		inv_wr.wr_id = ISER_FRWR_LI_WRID;
 		inv_wr.opcode = IB_WR_LOCAL_INV;
 		inv_wr.ex.invalidate_rkey = fr_desc->data_mr->rkey;
 		wr = &inv_wr;
@@ -2212,6 +2215,7 @@ isert_fast_reg_mr(struct fast_reg_descriptor *fr_desc,
 
 	/* Prepare FASTREG WR */
 	memset(&fr_wr, 0, sizeof(fr_wr));
+	fr_wr.wr_id = ISER_FRWR_LI_WRID;
 	fr_wr.opcode = IB_WR_FAST_REG_MR;
 	fr_wr.wr.fast_reg.iova_start =
 		fr_desc->data_frpl->page_list[0] + page_off;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 41e799f..599b4e2 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -6,6 +6,7 @@
 
 #define ISERT_RDMA_LISTEN_BACKLOG	10
 #define ISCSI_ISER_SG_TABLESIZE		256
+#define ISER_FRWR_LI_WRID		0xffffffffffffffffULL
 
 enum isert_desc_type {
 	ISCSI_TX_CONTROL,
-- 
1.7.10.4
