From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 08/19] qla2xxx: Properly reset firmware statistics.
Date: Wed, 6 Jul 2016 11:14:24 -0400
Message-ID: <1467818075-15246-9-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:29337 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbcGFP7V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:21 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 28 ++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_bsg.c  |  2 +-
 drivers/scsi/qla2xxx/qla_dbg.c  |  2 +-
 drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  | 18 ++++++++----------
 5 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index e0256a4..8b06ce8 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1828,17 +1828,17 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 		goto done;
 
 	stats = dma_alloc_coherent(&ha->pdev->dev,
-	    sizeof(struct link_statistics), &stats_dma, GFP_KERNEL);
-	if (stats == NULL) {
+	    sizeof(*stats), &stats_dma, GFP_KERNEL);
+	if (!stats) {
 		ql_log(ql_log_warn, vha, 0x707d,
 		    "Failed to allocate memory for stats.\n");
 		goto done;
 	}
-	memset(stats, 0, DMA_POOL_SIZE);
+	memset(stats, 0, sizeof(*stats));
 
 	rval = QLA_FUNCTION_FAILED;
 	if (IS_FWI2_CAPABLE(ha)) {
-		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma);
+		rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, 0);
 	} else if (atomic_read(&base_vha->loop_state) == LOOP_READY &&
 	    !ha->dpc_active) {
 		/* Must be in a 'READY' state for statistics retrieval. */
@@ -1886,11 +1886,31 @@ static void
 qla2x00_reset_host_stats(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *vha = shost_priv(shost);
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	struct link_statistics *stats;
+	dma_addr_t stats_dma;
 
 	memset(&vha->qla_stats, 0, sizeof(vha->qla_stats));
 	memset(&vha->fc_host_stat, 0, sizeof(vha->fc_host_stat));
 
 	vha->qla_stats.jiffies_at_last_reset = get_jiffies_64();
+
+	if (IS_FWI2_CAPABLE(ha)) {
+		stats = dma_alloc_coherent(&ha->pdev->dev,
+		    sizeof(*stats), &stats_dma, GFP_KERNEL);
+		if (!stats) {
+			ql_log(ql_log_warn, vha, 0x70d7,
+			    "Failed to allocate memory for stats.\n");
+			return;
+		}
+
+		/* reset firmware statistics */
+		qla24xx_get_isp_stats(base_vha, stats, stats_dma, BIT_0);
+
+		dma_free_coherent(&ha->pdev->dev, sizeof(*stats),
+		    stats, stats_dma);
+	}
 }
 
 static void
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 392c147..8cadc4d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2270,7 +2270,7 @@ qla2x00_get_priv_stats(struct fc_bsg_job *bsg_job)
 
 	memset(stats, 0, sizeof(struct link_statistics));
 
-	rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma);
+	rval = qla24xx_get_isp_stats(base_vha, stats, stats_dma, 0);
 
 	if (rval != QLA_SUCCESS)
 		goto done_free;
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 589cd13..c6ccc8a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -41,7 +41,7 @@
  * |                              |                    | 0x70ad-0x70ae  |
  * |                              |                    | 0x70d0-0x70d6	|
  * |                              |                    | 0x70d7-0x70db  |
- * |                              |                    | 0x70de-0x70df  |
+ * |                              |                    | 0x70db		|
  * | Task Management              |       0x803d       | 0x8000,0x800b  |
  * |                              |                    | 0x8019         |
  * |                              |                    | 0x8025,0x8026  |
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index fe94377..be24e62 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -344,7 +344,7 @@ qla2x00_get_link_status(scsi_qla_host_t *, uint16_t, struct link_statistics *,
 
 extern int
 qla24xx_get_isp_stats(scsi_qla_host_t *, struct link_statistics *,
-    dma_addr_t);
+    dma_addr_t, uint);
 
 extern int qla24xx_abort_command(srb_t *);
 extern int qla24xx_async_abort_command(srb_t *);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9673a0b..583ad62 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2762,15 +2762,16 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
-	uint32_t *iter, dwords;
+	uint32_t *iter = (void *)stats;
+	ushort dwords = offsetof(typeof(*stats), link_up_cnt)/sizeof(*iter);
 	struct qla_hw_data *ha = vha->hw;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1084,
 	    "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_LINK_STATUS;
-	mcp->mb[2] = MSW(stats_dma);
-	mcp->mb[3] = LSW(stats_dma);
+	mcp->mb[2] = MSW(LSD(stats_dma));
+	mcp->mb[3] = LSW(LSD(stats_dma));
 	mcp->mb[6] = MSW(MSD(stats_dma));
 	mcp->mb[7] = LSW(MSD(stats_dma));
 	mcp->out_mb = MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
@@ -2799,12 +2800,9 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 			    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 			rval = QLA_FUNCTION_FAILED;
 		} else {
-			/* Copy over data -- firmware data is LE. */
+			/* Re-endianize - firmware data is le32. */
 			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1086,
 			    "Done %s.\n", __func__);
-			dwords = offsetof(struct link_statistics,
-					link_up_cnt) / 4;
-			iter = &stats->link_fail_cnt;
 			for ( ; dwords--; iter++)
 				le32_to_cpus(iter);
 		}
@@ -2818,7 +2816,7 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 
 int
 qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
-    dma_addr_t stats_dma)
+    dma_addr_t stats_dma, uint options)
 {
 	int rval;
 	mbx_cmd_t mc;
@@ -2835,7 +2833,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 	mcp->mb[7] = LSW(MSD(stats_dma));
 	mcp->mb[8] = sizeof(struct link_statistics) / 4;
 	mcp->mb[9] = vha->vp_idx;
-	mcp->mb[10] = 0;
+	mcp->mb[10] = options;
 	mcp->out_mb = MBX_10|MBX_9|MBX_8|MBX_7|MBX_6|MBX_3|MBX_2|MBX_0;
 	mcp->in_mb = MBX_2|MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
@@ -2850,7 +2848,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 		} else {
 			ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108a,
 			    "Done %s.\n", __func__);
-			/* Copy over data -- firmware data is LE. */
+			/* Re-endianize - firmware data is le32. */
 			dwords = sizeof(struct link_statistics) / 4;
 			iter = &stats->link_fail_cnt;
 			for ( ; dwords--; iter++)
-- 
2.7.2

