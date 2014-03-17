From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 1/4] Target/iser: Fix signature work requests accounting
Date: Mon, 17 Mar 2014 12:52:16 +0200
Message-ID: <1395053539-31314-2-git-send-email-sagig@mellanox.com>
References: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1395053539-31314-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: oren@mellanox.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As REG_SIG_MR work request and it's LOCAL_INVALIDATE are
not accounted in post_send_buf_count we must color these
with ISER_FASTREG_LI_WRID in order to process their error
completions when the QP flushes.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index f82fe3d..e4ebb4c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2610,6 +2610,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn, struct se_cmd *se_cmd,
 	if (!(fr_desc->ind & ISERT_SIG_KEY_VALID)) {
 		memset(&inv_wr, 0, sizeof(inv_wr));
 		inv_wr.opcode = IB_WR_LOCAL_INV;
+		inv_wr.wr_id = ISER_FASTREG_LI_WRID;
 		inv_wr.ex.invalidate_rkey = pi_ctx->sig_mr->rkey;
 		wr = &inv_wr;
 		/* Bump the key */
@@ -2619,6 +2620,7 @@ isert_reg_sig_mr(struct isert_conn *isert_conn, struct se_cmd *se_cmd,
 
 	memset(&sig_wr, 0, sizeof(sig_wr));
 	sig_wr.opcode = IB_WR_REG_SIG_MR;
+	sig_wr.wr_id = ISER_FASTREG_LI_WRID;
 	sig_wr.sg_list = data_sge;
 	sig_wr.num_sge = 1;
 	sig_wr.wr.sig_handover.access_flags = IB_ACCESS_LOCAL_WRITE;
-- 
1.7.1
