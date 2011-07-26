From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH RESEND 06/11] bnx2fc: HSI changes for tape
Date: Tue, 26 Jul 2011 14:51:44 -0700
Message-ID: <1311717109-14077-7-git-send-email-bprakash@broadcom.com>
References: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2751 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab1GZVwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jul 2011 17:52:07 -0400
In-Reply-To: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Program the firmware task structure with init_flags indicating the device is
'sequence level error recovery' capable.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c |   30 ++++++++++++++++++++++++++----
 1 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 764c452..9f38c57 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -1564,7 +1564,12 @@ void bnx2fc_init_cleanup_task(struct bnx2fc_cmd *io_req,
 				FCOE_TCE_TX_WR_RX_RD_CONST_TASK_TYPE_SHIFT;
 	task->txwr_rxrd.const_ctx.init_flags |= FCOE_TASK_CLASS_TYPE_3 <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_CLASS_TYPE_SHIFT;
-	task->txwr_rxrd.const_ctx.init_flags |=
+	if (tgt->dev_type == TYPE_TAPE)
+		task->txwr_rxrd.const_ctx.init_flags |=
+				FCOE_TASK_DEV_TYPE_TAPE <<
+				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
+	else
+		task->txwr_rxrd.const_ctx.init_flags |=
 				FCOE_TASK_DEV_TYPE_DISK <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
 	task->txwr_rxrd.union_ctx.cleanup.ctx.cleaned_task_id = orig_xid;
@@ -1624,7 +1629,12 @@ void bnx2fc_init_mp_task(struct bnx2fc_cmd *io_req,
 	/* init flags */
 	task->txwr_rxrd.const_ctx.init_flags = task_type <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_TASK_TYPE_SHIFT;
-	task->txwr_rxrd.const_ctx.init_flags |=
+	if (tgt->dev_type == TYPE_TAPE)
+		task->txwr_rxrd.const_ctx.init_flags |=
+				FCOE_TASK_DEV_TYPE_TAPE <<
+				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
+	else
+		task->txwr_rxrd.const_ctx.init_flags |=
 				FCOE_TASK_DEV_TYPE_DISK <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
 	task->txwr_rxrd.const_ctx.init_flags |= FCOE_TASK_CLASS_TYPE_3 <<
@@ -1681,6 +1691,7 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 	struct bnx2fc_rport *tgt = io_req->tgt;
 	struct fcoe_cached_sge_ctx *cached_sge;
 	struct fcoe_ext_mul_sges_ctx *sgl;
+	int dev_type = tgt->dev_type;
 	u64 *fcp_cmnd;
 	u64 tmp_fcp_cmnd[4];
 	u32 context_id;
@@ -1711,7 +1722,12 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 	/* Init state to NORMAL */
 	task->txwr_rxrd.const_ctx.init_flags = task_type <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_TASK_TYPE_SHIFT;
-	task->txwr_rxrd.const_ctx.init_flags |=
+	if (dev_type == TYPE_TAPE)
+		task->txwr_rxrd.const_ctx.init_flags |=
+				FCOE_TASK_DEV_TYPE_TAPE <<
+				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
+	else
+		task->txwr_rxrd.const_ctx.init_flags |=
 				FCOE_TASK_DEV_TYPE_DISK <<
 				FCOE_TCE_TX_WR_RX_RD_CONST_DEV_TYPE_SHIFT;
 	task->txwr_rxrd.const_ctx.init_flags |= FCOE_TASK_CLASS_TYPE_3 <<
@@ -1754,7 +1770,8 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 	cached_sge = &task->rxwr_only.union_ctx.read_info.sgl_ctx.cached_sge;
 	sgl = &task->rxwr_only.union_ctx.read_info.sgl_ctx.sgl;
 	bd_count = bd_tbl->bd_valid;
-	if (task_type == FCOE_TASK_TYPE_READ) {
+	if (task_type == FCOE_TASK_TYPE_READ &&
+	    dev_type == TYPE_DISK) {
 		if (bd_count == 1) {
 
 			struct fcoe_bd_ctx *fcoe_bd_tbl = bd_tbl->bd_tbl;
@@ -1786,6 +1803,11 @@ void bnx2fc_init_task(struct bnx2fc_cmd *io_req,
 					(u32)((u64)bd_tbl->bd_tbl_dma >> 32);
 			sgl->mul_sgl.sgl_size = bd_count;
 		}
+	} else {
+		sgl->mul_sgl.cur_sge_addr.lo = (u32)bd_tbl->bd_tbl_dma;
+		sgl->mul_sgl.cur_sge_addr.hi =
+				(u32)((u64)bd_tbl->bd_tbl_dma >> 32);
+		sgl->mul_sgl.sgl_size = bd_count;
 	}
 }
 
-- 
1.7.0.6


