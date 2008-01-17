From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH] qla2xxx: Retrieve additional HBA port statistics from recent ISPs.
Date: Thu, 17 Jan 2008 09:02:08 -0800
Message-ID: <1200589340-19499-2-git-send-email-andrew.vasquez@qlogic.com>
References: <20080117165940.GA19033@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20849 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbYAQRCc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 12:02:32 -0500
In-Reply-To: <20080117165940.GA19033@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

HBAs supporting these additional counters include ISP24xx and
ISP25xx type boards.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c |   44 ++++++++++++------
 drivers/scsi/qla2xxx/qla_def.h  |   22 ++++++---
 drivers/scsi/qla2xxx/qla_gbl.h  |    7 ++-
 drivers/scsi/qla2xxx/qla_mbx.c  |   99 ++++++++++----------------------------
 4 files changed, 74 insertions(+), 98 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 745283f..e3bda8f 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -967,35 +967,51 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *ha = shost_priv(shost);
 	int rval;
-	uint16_t mb_stat[1];
-	link_stat_t stat_buf;
+	struct link_statistics *stats;
+	dma_addr_t stats_dma;
 	struct fc_host_statistics *pfc_host_stat;
 
-	rval = QLA_FUNCTION_FAILED;
 	pfc_host_stat = &ha->fc_host_stat;
 	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
 
+	stats = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &stats_dma);
+	if (stats == NULL) {
+		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
+		    __func__, ha->host_no));
+		goto done;
+	}
+	memset(stats, 0, DMA_POOL_SIZE);
+
+	rval = QLA_FUNCTION_FAILED;
 	if (IS_FWI2_CAPABLE(ha)) {
-		rval = qla24xx_get_isp_stats(ha, (uint32_t *)&stat_buf,
-		    sizeof(stat_buf) / 4, mb_stat);
+		rval = qla24xx_get_isp_stats(ha, stats, stats_dma);
 	} else if (atomic_read(&ha->loop_state) == LOOP_READY &&
 		    !test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags) &&
 		    !test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) &&
 		    !ha->dpc_active) {
 		/* Must be in a 'READY' state for statistics retrieval. */
-		rval = qla2x00_get_link_status(ha, ha->loop_id, &stat_buf,
-		    mb_stat);
+		rval = qla2x00_get_link_status(ha, ha->loop_id, stats,
+		    stats_dma);
 	}
 
 	if (rval != QLA_SUCCESS)
-		goto done;
+		goto done_free;
+
+	pfc_host_stat->link_failure_count = stats->link_fail_cnt;
+	pfc_host_stat->loss_of_sync_count = stats->loss_sync_cnt;
+	pfc_host_stat->loss_of_signal_count = stats->loss_sig_cnt;
+	pfc_host_stat->prim_seq_protocol_err_count = stats->prim_seq_err_cnt;
+	pfc_host_stat->invalid_tx_word_count = stats->inval_xmit_word_cnt;
+	pfc_host_stat->invalid_crc_count = stats->inval_crc_cnt;
+	if (IS_FWI2_CAPABLE(ha)) {
+		pfc_host_stat->tx_frames = stats->tx_frames;
+		pfc_host_stat->rx_frames = stats->rx_frames;
+		pfc_host_stat->dumped_frames = stats->dumped_frames;
+		pfc_host_stat->nos_count = stats->nos_rcvd;
+	}
 
-	pfc_host_stat->link_failure_count = stat_buf.link_fail_cnt;
-	pfc_host_stat->loss_of_sync_count = stat_buf.loss_sync_cnt;
-	pfc_host_stat->loss_of_signal_count = stat_buf.loss_sig_cnt;
-	pfc_host_stat->prim_seq_protocol_err_count = stat_buf.prim_seq_err_cnt;
-	pfc_host_stat->invalid_tx_word_count = stat_buf.inval_xmit_word_cnt;
-	pfc_host_stat->invalid_crc_count = stat_buf.inval_crc_cnt;
+done_free:
+        dma_pool_free(ha->s_dma_pool, stats, stats_dma);
 done:
 	return pfc_host_stat;
 }
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index fe8f782..a33d3d5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -862,14 +862,20 @@ typedef struct {
 #define GLSO_SEND_RPS	BIT_0
 #define GLSO_USE_DID	BIT_3
 
-typedef struct {
-	uint32_t	link_fail_cnt;
-	uint32_t	loss_sync_cnt;
-	uint32_t	loss_sig_cnt;
-	uint32_t	prim_seq_err_cnt;
-	uint32_t	inval_xmit_word_cnt;
-	uint32_t	inval_crc_cnt;
-} link_stat_t;
+struct link_statistics {
+	uint32_t link_fail_cnt;
+	uint32_t loss_sync_cnt;
+	uint32_t loss_sig_cnt;
+	uint32_t prim_seq_err_cnt;
+	uint32_t inval_xmit_word_cnt;
+	uint32_t inval_crc_cnt;
+	uint32_t unused1[0x1b];
+	uint32_t tx_frames;
+	uint32_t rx_frames;
+	uint32_t dumped_frames;
+	uint32_t unused2[2];
+	uint32_t nos_rcvd;
+};
 
 /*
  * NVRAM Command values.
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 09cb2a9..5b381dc 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -222,11 +222,12 @@ extern int
 qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map);
 
 extern int
-qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, link_stat_t *,
-    uint16_t *);
+qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, struct link_statistics *,
+    dma_addr_t);
 
 extern int
-qla24xx_get_isp_stats(scsi_qla_host_t *, uint32_t *, uint32_t, uint16_t *);
+qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
+    dma_addr_t);
 
 extern int qla24xx_abort_command(scsi_qla_host_t *, srb_t *);
 extern int qla24xx_abort_target(fc_port_t *);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 031f269..0fc1652 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2042,29 +2042,20 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *ha, char *pos_map)
  */
 int
 qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
-    link_stat_t *ret_buf, uint16_t *status)
+    struct link_statistics *stats, dma_addr_t stats_dma)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	link_stat_t *stat_buf;
-	dma_addr_t stat_buf_dma;
+	uint32_t *siter, *diter, dwords;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	stat_buf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &stat_buf_dma);
-	if (stat_buf == NULL) {
-		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
-		    __func__, ha->host_no));
-		return BIT_0;
-	}
-	memset(stat_buf, 0, sizeof(link_stat_t));
-
 	mcp->mb[0] = MBC_GET_LINK_STATUS;
-	mcp->mb[2] = MSW(stat_buf_dma);
-	mcp->mb[3] = LSW(stat_buf_dma);
-	mcp->mb[6] = MSW(MSD(stat_buf_dma));
-	mcp->mb[7] = LSW(MSD(stat_buf_dma));
+	mcp->mb[2] = MSW(stats_dma);
+	mcp->mb[3] = LSW(stats_dma);
+	mcp->mb[6] = MSW(MSD(stats_dma));
+	mcp->mb[7] = LSW(MSD(stats_dma));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(ha)) {
@@ -2089,78 +2080,43 @@ qla2x00_get_link_status(scsi_qla_host_t *ha, uint16_t loop_id,
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
 			    __func__, ha->host_no, mcp->mb[0]));
-			status[0] = mcp->mb[0];
-			rval = BIT_1;
+			rval = QLA_FUNCTION_FAILED;
 		} else {
-			/* copy over data -- firmware data is LE. */
-			ret_buf->link_fail_cnt =
-			    le32_to_cpu(stat_buf->link_fail_cnt);
-			ret_buf->loss_sync_cnt =
-			    le32_to_cpu(stat_buf->loss_sync_cnt);
-			ret_buf->loss_sig_cnt =
-			    le32_to_cpu(stat_buf->loss_sig_cnt);
-			ret_buf->prim_seq_err_cnt =
-			    le32_to_cpu(stat_buf->prim_seq_err_cnt);
-			ret_buf->inval_xmit_word_cnt =
-			    le32_to_cpu(stat_buf->inval_xmit_word_cnt);
-			ret_buf->inval_crc_cnt =
-			    le32_to_cpu(stat_buf->inval_crc_cnt);
-
-			DEBUG11(printk("%s(%ld): stat dump: fail_cnt=%d "
-			    "loss_sync=%d loss_sig=%d seq_err=%d "
-			    "inval_xmt_word=%d inval_crc=%d.\n", __func__,
-			    ha->host_no, stat_buf->link_fail_cnt,
-			    stat_buf->loss_sync_cnt, stat_buf->loss_sig_cnt,
-			    stat_buf->prim_seq_err_cnt,
-			    stat_buf->inval_xmit_word_cnt,
-			    stat_buf->inval_crc_cnt));
+			/* Copy over data -- firmware data is LE. */
+			dwords = offsetof(struct link_statistics, unused1) / 4;
+			siter = diter = &stats->link_fail_cnt;
+			while (dwords--)
+				*diter++ = le32_to_cpu(*siter++);
 		}
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
 		    ha->host_no, rval));
-		rval = BIT_1;
 	}
 
-	dma_pool_free(ha->s_dma_pool, stat_buf, stat_buf_dma);
-
 	return rval;
 }
 
 int
-qla24xx_get_isp_stats(scsi_qla_host_t *ha, uint32_t *dwbuf, uint32_t dwords,
-    uint16_t *status)
+qla24xx_get_isp_stats(scsi_qla_host_t *ha, struct link_statistics *stats,
+    dma_addr_t stats_dma)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t *sbuf, *siter;
-	dma_addr_t sbuf_dma;
+	uint32_t *siter, *diter, dwords;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, ha->host_no));
 
-	if (dwords > (DMA_POOL_SIZE / 4)) {
-		DEBUG2_3_11(printk("%s(%ld): Unabled to retrieve %d DWORDs "
-		    "(max %d).\n", __func__, ha->host_no, dwords,
-		    DMA_POOL_SIZE / 4));
-		return BIT_0;
-	}
-	sbuf = dma_pool_alloc(ha->s_dma_pool, GFP_ATOMIC, &sbuf_dma);
-	if (sbuf == NULL) {
-		DEBUG2_3_11(printk("%s(%ld): Failed to allocate memory.\n",
-		    __func__, ha->host_no));
-		return BIT_0;
-	}
-	memset(sbuf, 0, DMA_POOL_SIZE);
-
 	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
-	mcp->mb[2] = MSW(sbuf_dma);
-	mcp->mb[3] = LSW(sbuf_dma);
-	mcp->mb[6] = MSW(MSD(sbuf_dma));
-	mcp->mb[7] = LSW(MSD(sbuf_dma));
-	mcp->mb[8] = dwords;
+	mcp->mb[2] = MSW(stats_dma);
+	mcp->mb[3] = LSW(stats_dma);
+	mcp->mb[6] = MSW(MSD(stats_dma));
+	mcp->mb[7] = LSW(MSD(stats_dma));
+	mcp->mb[8] = sizeof(struct link_statistics) / 4;
+	mcp->mb[9] = ha->vp_idx;
 	mcp->mb[10] = 0;
-	mcp->out_mb = MBX_10|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
+	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	mcp->tov = 30;
 	mcp->flags = IOCTL_CMD;
@@ -2170,23 +2126,20 @@ qla24xx_get_isp_stats(scsi_qla_host_t *ha, uint32_t *dwbuf, uint32_t dwords,
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
 			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
 			    __func__, ha->host_no, mcp->mb[0]));
-			status[0] = mcp->mb[0];
-			rval = BIT_1;
+			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Copy over data -- firmware data is LE. */
-			siter = sbuf;
+			dwords = sizeof(struct link_statistics) / 4;
+			siter = diter = &stats->link_fail_cnt;
 			while (dwords--)
-				*dwbuf++ = le32_to_cpu(*siter++);
+				*diter++ = le32_to_cpu(*siter++);
 		}
 	} else {
 		/* Failed. */
 		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
 		    ha->host_no, rval));
-		rval = BIT_1;
 	}
 
-	dma_pool_free(ha->s_dma_pool, sbuf, sbuf_dma);
-
 	return rval;
 }
 
-- 
1.5.4.rc3.14.g44397

