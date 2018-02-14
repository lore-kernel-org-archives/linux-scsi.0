From: Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH v2] scsi: qla2xxx: Use dma_pool_zalloc()
Date: Thu, 15 Feb 2018 01:40:38 +0530
Message-ID: <20180214201038.GA6578@jordon-HP-15-Notebook-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:42826 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031318AbeBNUJW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2018 15:09:22 -0500
Received: by mail-pl0-f68.google.com with SMTP id 31so3630155ple.9
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 12:09:21 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: linux-scsi@vger.kernel.org

Use dma_pool_zalloc() instead of dma_pool_alloc + memset

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
---

v2: Remove extra line and comment

 drivers/scsi/qla2xxx/qla_bsg.c    |  3 +--
 drivers/scsi/qla2xxx/qla_iocb.c   | 10 ++--------
 drivers/scsi/qla2xxx/qla_target.c |  7 +------
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index e2d5d3c..c11a89b 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1035,7 +1035,7 @@
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 		bsg_job->request_payload.sg_cnt, fw_buf, data_len);

-	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
+	mn = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (!mn) {
 		ql_log(ql_log_warn, vha, 0x7036,
 		    "DMA alloc failed for fw buffer.\n");
@@ -1046,7 +1046,6 @@
 	flag = bsg_request->rqst_data.h_vendor.vendor_cmd[1];
 	fw_ver = le32_to_cpu(*((uint32_t *)((uint32_t *)fw_buf + 2)));

-	memset(mn, 0, sizeof(struct access_chip_84xx));
 	mn->entry_type = VERIFY_CHIP_IOCB_TYPE;
 	mn->entry_count = 1;

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 1b62e94..1796866 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1203,7 +1203,6 @@ struct fw_dif_context {
 	uint32_t		dif_bytes;
 	uint8_t			bundling = 1;
 	uint16_t		blk_size;
-	uint8_t			*clr_ptr;
 	struct crc_context	*crc_ctx_pkt = NULL;
 	struct qla_hw_data	*ha;
 	uint8_t			additional_fcpcdb_len;
@@ -1245,15 +1244,11 @@ struct fw_dif_context {

 	/* Allocate CRC context from global pool */
 	crc_ctx_pkt = sp->u.scmd.ctx =
-	    dma_pool_alloc(ha->dl_dma_pool, GFP_ATOMIC, &crc_ctx_dma);
+	    dma_pool_zalloc(ha->dl_dma_pool, GFP_ATOMIC, &crc_ctx_dma);

 	if (!crc_ctx_pkt)
 		goto crc_queuing_error;

-	/* Zero out CTX area. */
-	clr_ptr = (uint8_t *)crc_ctx_pkt;
-	memset(clr_ptr, 0, sizeof(*crc_ctx_pkt));
-
 	crc_ctx_pkt->crc_ctx_dma = crc_ctx_dma;

 	sp->flags |= SRB_CRC_CTX_DMA_VALID;
@@ -3067,7 +3062,7 @@ struct fw_dif_context {
 		}

 		memset(ctx, 0, sizeof(struct ct6_dsd));
-		ctx->fcp_cmnd = dma_pool_alloc(ha->fcp_cmnd_dma_pool,
+		ctx->fcp_cmnd = dma_pool_zalloc(ha->fcp_cmnd_dma_pool,
 			GFP_ATOMIC, &ctx->fcp_cmnd_dma);
 		if (!ctx->fcp_cmnd) {
 			ql_log(ql_log_fatal, vha, 0x3011,
@@ -3120,7 +3115,6 @@ struct fw_dif_context {
 		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));

 		/* build FCP_CMND IU */
-		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
 		int_to_scsilun(cmd->device->lun, &ctx->fcp_cmnd->lun);
 		ctx->fcp_cmnd->additional_cdb_len = additional_cdb_len;

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fc89af8..3b52bcd 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2871,7 +2871,6 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,
 	uint32_t		data_bytes;
 	uint32_t		dif_bytes;
 	uint8_t			bundling = 1;
-	uint8_t			*clr_ptr;
 	struct crc_context	*crc_ctx_pkt = NULL;
 	struct qla_hw_data	*ha;
 	struct ctio_crc2_to_fw	*pkt;
@@ -3000,15 +2999,11 @@ static void qlt_24xx_init_ctio_to_isp(struct ctio7_to_24xx *ctio,

 	/* Allocate CRC context from global pool */
 	crc_ctx_pkt = cmd->ctx =
-	    dma_pool_alloc(ha->dl_dma_pool, GFP_ATOMIC, &crc_ctx_dma);
+	    dma_pool_zalloc(ha->dl_dma_pool, GFP_ATOMIC, &crc_ctx_dma);

 	if (!crc_ctx_pkt)
 		goto crc_queuing_error;

-	/* Zero out CTX area. */
-	clr_ptr = (uint8_t *)crc_ctx_pkt;
-	memset(clr_ptr, 0, sizeof(*crc_ctx_pkt));
-
 	crc_ctx_pkt->crc_ctx_dma = crc_ctx_dma;
 	INIT_LIST_HEAD(&crc_ctx_pkt->dsd_list);

--
1.9.1
