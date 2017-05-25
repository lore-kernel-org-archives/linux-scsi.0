From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 7/7] qla2xxx: Fix crash due to NULL pointer dereference of ctx.
Date: Wed, 24 May 2017 18:06:24 -0700
Message-ID: <20170525010624.8886-8-himanshu.madhani@cavium.com>
References: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0083.outbound.protection.outlook.com ([104.47.42.83]:43452
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1162417AbdEYBGo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 21:06:44 -0400
In-Reply-To: <20170525010624.8886-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Fixes following signature in the stack trace:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000374
IP: [<ffffffffa06ec8eb>] qla2x00_sp_free_dma+0xeb/0x2a0 [qla2xxx]

Cc: <stable@vger.kernel.org> # 4.10
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_inline.h | 26 +++++++-------------------
 drivers/scsi/qla2xxx/qla_os.c     | 30 +++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_target.c |  8 +++++---
 3 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 66df6cec59da..c61a6a871c8e 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -129,28 +129,16 @@ qla2x00_clear_loop_id(fc_port_t *fcport) {
 }
 
 static inline void
-qla2x00_clean_dsd_pool(struct qla_hw_data *ha, srb_t *sp,
-	struct qla_tgt_cmd *tc)
+qla2x00_clean_dsd_pool(struct qla_hw_data *ha, struct crc_context *ctx)
 {
-	struct dsd_dma *dsd_ptr, *tdsd_ptr;
-	struct crc_context *ctx;
-
-	if (sp)
-		ctx = (struct crc_context *)GET_CMD_CTX_SP(sp);
-	else if (tc)
-		ctx = (struct crc_context *)tc->ctx;
-	else {
-		BUG();
-		return;
-	}
+	struct dsd_dma *dsd, *tdsd;
 
 	/* clean up allocated prev pool */
-	list_for_each_entry_safe(dsd_ptr, tdsd_ptr,
-	    &ctx->dsd_list, list) {
-		dma_pool_free(ha->dl_dma_pool, dsd_ptr->dsd_addr,
-		    dsd_ptr->dsd_list_dma);
-		list_del(&dsd_ptr->list);
-		kfree(dsd_ptr);
+	list_for_each_entry_safe(dsd, tdsd, &ctx->dsd_list, list) {
+		dma_pool_free(ha->dl_dma_pool, dsd->dsd_addr,
+		    dsd->dsd_list_dma);
+		list_del(&dsd->list);
+		kfree(dsd);
 	}
 	INIT_LIST_HEAD(&ctx->dsd_list);
 }
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1c7957903283..c8282a1ab6dc 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -630,29 +630,34 @@ qla2x00_sp_free_dma(void *ptr)
 		sp->flags &= ~SRB_CRC_PROT_DMA_VALID;
 	}
 
+	if (!ctx)
+		goto end;
+
 	if (sp->flags & SRB_CRC_CTX_DSD_VALID) {
 		/* List assured to be having elements */
-		qla2x00_clean_dsd_pool(ha, sp, NULL);
+		qla2x00_clean_dsd_pool(ha, ctx);
 		sp->flags &= ~SRB_CRC_CTX_DSD_VALID;
 	}
 
 	if (sp->flags & SRB_CRC_CTX_DMA_VALID) {
-		dma_pool_free(ha->dl_dma_pool, ctx,
-		    ((struct crc_context *)ctx)->crc_ctx_dma);
+		struct crc_context *ctx0 = ctx;
+
+		dma_pool_free(ha->dl_dma_pool, ctx0, ctx0->crc_ctx_dma);
 		sp->flags &= ~SRB_CRC_CTX_DMA_VALID;
 	}
 
 	if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
-		struct ct6_dsd *ctx1 = (struct ct6_dsd *)ctx;
+		struct ct6_dsd *ctx1 = ctx;
 
 		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
-			ctx1->fcp_cmnd_dma);
+		    ctx1->fcp_cmnd_dma);
 		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
 		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
 		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
 		mempool_free(ctx1, ha->ctx_mempool);
 	}
 
+end:
 	CMD_SP(cmd) = NULL;
 	qla2x00_rel_sp(sp);
 }
@@ -699,21 +704,24 @@ qla2xxx_qpair_sp_free_dma(void *ptr)
 		sp->flags &= ~SRB_CRC_PROT_DMA_VALID;
 	}
 
+	if (!ctx)
+		goto end;
+
 	if (sp->flags & SRB_CRC_CTX_DSD_VALID) {
 		/* List assured to be having elements */
-		qla2x00_clean_dsd_pool(ha, sp, NULL);
+		qla2x00_clean_dsd_pool(ha, ctx);
 		sp->flags &= ~SRB_CRC_CTX_DSD_VALID;
 	}
 
 	if (sp->flags & SRB_CRC_CTX_DMA_VALID) {
-		dma_pool_free(ha->dl_dma_pool, ctx,
-		    ((struct crc_context *)ctx)->crc_ctx_dma);
+		struct crc_context *ctx0 = ctx;
+
+		dma_pool_free(ha->dl_dma_pool, ctx, ctx0->crc_ctx_dma);
 		sp->flags &= ~SRB_CRC_CTX_DMA_VALID;
 	}
 
 	if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
-		struct ct6_dsd *ctx1 = (struct ct6_dsd *)ctx;
-
+		struct ct6_dsd *ctx1 = ctx;
 		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
 		    ctx1->fcp_cmnd_dma);
 		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
@@ -721,7 +729,7 @@ qla2xxx_qpair_sp_free_dma(void *ptr)
 		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
 		mempool_free(ctx1, ha->ctx_mempool);
 	}
-
+end:
 	CMD_SP(cmd) = NULL;
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0e03ca2ab3e5..e766d8412384 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2245,11 +2245,13 @@ static void qlt_unmap_sg(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 		pci_unmap_sg(ha->pdev, cmd->prot_sg, cmd->prot_sg_cnt,
 			cmd->dma_data_direction);
 
+	if (!cmd->ctx)
+		return;
+
 	if (cmd->ctx_dsd_alloced)
-		qla2x00_clean_dsd_pool(ha, NULL, cmd);
+		qla2x00_clean_dsd_pool(ha, cmd->ctx);
 
-	if (cmd->ctx)
-		dma_pool_free(ha->dl_dma_pool, cmd->ctx, cmd->ctx->crc_ctx_dma);
+	dma_pool_free(ha->dl_dma_pool, cmd->ctx, cmd->ctx->crc_ctx_dma);
 }
 
 static int qlt_check_reserve_free_req(struct scsi_qla_host *vha,
-- 
2.12.0
