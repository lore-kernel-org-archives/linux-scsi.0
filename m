From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 12/15] qla2xxx: Remove datasegs_per_cmd and datasegs_per_cont field
Date: Wed, 7 Jun 2017 14:43:30 -0700
Message-ID: <20170607214333.23110-13-himanshu.madhani@cavium.com>
References: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

These fields only hold one set of value. Replace it with macros.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 +++++-------
 drivers/scsi/qla2xxx/qla_target.h |  2 +-
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 411c1799c6e3..48d82c67e223 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2228,10 +2228,10 @@ static int qlt_pci_map_calc_cnt(struct qla_tgt_prm *prm)
 		 * If greater than four sg entries then we need to allocate
 		 * the continuation entries
 		 */
-		if (prm->seg_cnt > prm->tgt->datasegs_per_cmd)
+		if (prm->seg_cnt > QLA_TGT_DATASEGS_PER_CMD_24XX)
 			prm->req_cnt += DIV_ROUND_UP(prm->seg_cnt -
-			prm->tgt->datasegs_per_cmd,
-			prm->tgt->datasegs_per_cont);
+			QLA_TGT_DATASEGS_PER_CMD_24XX,
+			QLA_TGT_DATASEGS_PER_CONT_24XX);
 	} else {
 		/* DIF */
 		if ((cmd->se_cmd.prot_op == TARGET_PROT_DIN_INSERT) ||
@@ -2448,7 +2448,7 @@ static void qlt_load_cont_data_segments(struct qla_tgt_prm *prm)
 
 		/* Load continuation entry data segments */
 		for (cnt = 0;
-		    cnt < prm->tgt->datasegs_per_cont && prm->seg_cnt;
+		    cnt < QLA_TGT_DATASEGS_PER_CONT_24XX && prm->seg_cnt;
 		    cnt++, prm->seg_cnt--) {
 			*dword_ptr++ =
 			    cpu_to_le32(pci_dma_lo32
@@ -2492,7 +2492,7 @@ static void qlt_load_data_segments(struct qla_tgt_prm *prm)
 
 	/* Load command entry data segments */
 	for (cnt = 0;
-	    (cnt < prm->tgt->datasegs_per_cmd) && prm->seg_cnt;
+	    (cnt < QLA_TGT_DATASEGS_PER_CMD_24XX) && prm->seg_cnt;
 	    cnt++, prm->seg_cnt--) {
 		*dword_ptr++ =
 		    cpu_to_le32(pci_dma_lo32(sg_dma_address(prm->sg)));
@@ -6170,8 +6170,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 		base_vha->vp_idx);
 	/* 3 is reserved */
 	tgt->sg_tablesize = QLA_TGT_MAX_SG_24XX(base_vha->req->length - 3);
-	tgt->datasegs_per_cmd = QLA_TGT_DATASEGS_PER_CMD_24XX;
-	tgt->datasegs_per_cont = QLA_TGT_DATASEGS_PER_CONT_24XX;
 
 	mutex_lock(&qla_tgt_mutex);
 	list_add_tail(&tgt->tgt_list_entry, &qla_tgt_glist);
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 902685f85506..7fe02d036bdf 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -806,7 +806,7 @@ struct qla_tgt {
 	 */
 	int atio_irq_cmd_count;
 
-	int datasegs_per_cmd, datasegs_per_cont, sg_tablesize;
+	int sg_tablesize;
 
 	/* Target's flags, serialized by pha->hardware_lock */
 	unsigned int link_reinit_iocb_pending:1;
-- 
2.12.0
