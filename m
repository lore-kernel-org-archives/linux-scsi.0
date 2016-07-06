From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 07/19] qla2xxx: Properly initialize IO statistics.
Date: Wed, 6 Jul 2016 11:14:23 -0400
Message-ID: <1467818075-15246-8-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:15950 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbcGFP7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:55 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Properly initialize IO statistics to avoid initial 0xFFFFFFF (-1) values.

Cleanup/simplify usage of pointer to statistics structure.

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   | 50 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_def.h    |  1 -
 drivers/scsi/qla2xxx/qla_init.c   |  3 +++
 drivers/scsi/qla2xxx/qla_target.c | 16 ++++++-------
 4 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index c9bcd82..e0256a4 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1811,10 +1811,9 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	int rval;
 	struct link_statistics *stats;
 	dma_addr_t stats_dma;
-	struct fc_host_statistics *pfc_host_stat;
+	struct fc_host_statistics *p = &vha->fc_host_stat;
 
-	pfc_host_stat = &vha->fc_host_stat;
-	memset(pfc_host_stat, -1, sizeof(struct fc_host_statistics));
+	memset(p, -1, sizeof(*p));
 
 	if (IS_QLAFX00(vha->hw))
 		goto done;
@@ -1850,37 +1849,37 @@ qla2x00_get_fc_host_stats(struct Scsi_Host *shost)
 	if (rval != QLA_SUCCESS)
 		goto done_free;
 
-	pfc_host_stat->link_failure_count = stats->link_fail_cnt;
-	pfc_host_stat->loss_of_sync_count = stats->loss_sync_cnt;
-	pfc_host_stat->loss_of_signal_count = stats->loss_sig_cnt;
-	pfc_host_stat->prim_seq_protocol_err_count = stats->prim_seq_err_cnt;
-	pfc_host_stat->invalid_tx_word_count = stats->inval_xmit_word_cnt;
-	pfc_host_stat->invalid_crc_count = stats->inval_crc_cnt;
+	p->link_failure_count = stats->link_fail_cnt;
+	p->loss_of_sync_count = stats->loss_sync_cnt;
+	p->loss_of_signal_count = stats->loss_sig_cnt;
+	p->prim_seq_protocol_err_count = stats->prim_seq_err_cnt;
+	p->invalid_tx_word_count = stats->inval_xmit_word_cnt;
+	p->invalid_crc_count = stats->inval_crc_cnt;
 	if (IS_FWI2_CAPABLE(ha)) {
-		pfc_host_stat->lip_count = stats->lip_cnt;
-		pfc_host_stat->tx_frames = stats->tx_frames;
-		pfc_host_stat->rx_frames = stats->rx_frames;
-		pfc_host_stat->dumped_frames = stats->discarded_frames;
-		pfc_host_stat->nos_count = stats->nos_rcvd;
-		pfc_host_stat->error_frames =
+		p->lip_count = stats->lip_cnt;
+		p->tx_frames = stats->tx_frames;
+		p->rx_frames = stats->rx_frames;
+		p->dumped_frames = stats->discarded_frames;
+		p->nos_count = stats->nos_rcvd;
+		p->error_frames =
 			stats->dropped_frames + stats->discarded_frames;
-		pfc_host_stat->rx_words = vha->qla_stats.input_bytes;
-		pfc_host_stat->tx_words = vha->qla_stats.output_bytes;
+		p->rx_words = vha->qla_stats.input_bytes;
+		p->tx_words = vha->qla_stats.output_bytes;
 	}
-	pfc_host_stat->fcp_control_requests = vha->qla_stats.control_requests;
-	pfc_host_stat->fcp_input_requests = vha->qla_stats.input_requests;
-	pfc_host_stat->fcp_output_requests = vha->qla_stats.output_requests;
-	pfc_host_stat->fcp_input_megabytes = vha->qla_stats.input_bytes >> 20;
-	pfc_host_stat->fcp_output_megabytes = vha->qla_stats.output_bytes >> 20;
-	pfc_host_stat->seconds_since_last_reset =
+	p->fcp_control_requests = vha->qla_stats.control_requests;
+	p->fcp_input_requests = vha->qla_stats.input_requests;
+	p->fcp_output_requests = vha->qla_stats.output_requests;
+	p->fcp_input_megabytes = vha->qla_stats.input_bytes >> 20;
+	p->fcp_output_megabytes = vha->qla_stats.output_bytes >> 20;
+	p->seconds_since_last_reset =
 		get_jiffies_64() - vha->qla_stats.jiffies_at_last_reset;
-	do_div(pfc_host_stat->seconds_since_last_reset, HZ);
+	do_div(p->seconds_since_last_reset, HZ);
 
 done_free:
 	dma_free_coherent(&ha->pdev->dev, sizeof(struct link_statistics),
 	    stats, stats_dma);
 done:
-	return pfc_host_stat;
+	return p;
 }
 
 static void
@@ -1888,6 +1887,7 @@ qla2x00_reset_host_stats(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *vha = shost_priv(shost);
 
+	memset(&vha->qla_stats, 0, sizeof(vha->qla_stats));
 	memset(&vha->fc_host_stat, 0, sizeof(vha->fc_host_stat));
 
 	vha->qla_stats.jiffies_at_last_reset = get_jiffies_64();
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2b7e4f5..a73ecc7 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3508,7 +3508,6 @@ struct qla_hw_data {
 	int             cur_vport_count;
 
 	struct qla_chip_state_84xx *cs84xx;
-	struct qla_statistics qla_stats;
 	struct isp_operations *isp_ops;
 	struct workqueue_struct *wq;
 	struct qlfc_fw fw_buf;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a3685b6..68e9309 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -624,6 +624,9 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
 
+	memset(&vha->qla_stats, 0, sizeof(vha->qla_stats));
+	memset(&vha->fc_host_stat, 0, sizeof(vha->fc_host_stat));
+
 	/* Clear adapter flags. */
 	vha->flags.online = 0;
 	ha->flags.chip_reset_done = 0;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index ca39deb..bff9689 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -215,8 +215,8 @@ static inline void qlt_incr_num_pend_cmds(struct scsi_qla_host *vha)
 	spin_lock_irqsave(&vha->hw->tgt.q_full_lock, flags);
 
 	vha->hw->tgt.num_pend_cmds++;
-	if (vha->hw->tgt.num_pend_cmds > vha->hw->qla_stats.stat_max_pend_cmds)
-		vha->hw->qla_stats.stat_max_pend_cmds =
+	if (vha->hw->tgt.num_pend_cmds > vha->qla_stats.stat_max_pend_cmds)
+		vha->qla_stats.stat_max_pend_cmds =
 			vha->hw->tgt.num_pend_cmds;
 	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
 }
@@ -5231,8 +5231,8 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	if ((vha->hw->tgt.num_qfull_cmds_alloc + 1) > MAX_QFULL_CMDS_ALLOC) {
 		vha->hw->tgt.num_qfull_cmds_dropped++;
 		if (vha->hw->tgt.num_qfull_cmds_dropped >
-			vha->hw->qla_stats.stat_max_qfull_cmds_dropped)
-			vha->hw->qla_stats.stat_max_qfull_cmds_dropped =
+			vha->qla_stats.stat_max_qfull_cmds_dropped)
+			vha->qla_stats.stat_max_qfull_cmds_dropped =
 				vha->hw->tgt.num_qfull_cmds_dropped;
 
 		ql_dbg(ql_dbg_io, vha, 0x3068,
@@ -5263,8 +5263,8 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 
 		vha->hw->tgt.num_qfull_cmds_dropped++;
 		if (vha->hw->tgt.num_qfull_cmds_dropped >
-			vha->hw->qla_stats.stat_max_qfull_cmds_dropped)
-			vha->hw->qla_stats.stat_max_qfull_cmds_dropped =
+			vha->qla_stats.stat_max_qfull_cmds_dropped)
+			vha->qla_stats.stat_max_qfull_cmds_dropped =
 				vha->hw->tgt.num_qfull_cmds_dropped;
 
 		qlt_chk_exch_leak_thresh_hold(vha);
@@ -5293,8 +5293,8 @@ qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 
 	vha->hw->tgt.num_qfull_cmds_alloc++;
 	if (vha->hw->tgt.num_qfull_cmds_alloc >
-		vha->hw->qla_stats.stat_max_qfull_cmds_alloc)
-		vha->hw->qla_stats.stat_max_qfull_cmds_alloc =
+		vha->qla_stats.stat_max_qfull_cmds_alloc)
+		vha->qla_stats.stat_max_qfull_cmds_alloc =
 			vha->hw->tgt.num_qfull_cmds_alloc;
 }
 
-- 
2.7.2

