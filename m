From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 06/15] qla2xxx: Add fw_started flags to qpair
Date: Wed, 7 Jun 2017 14:43:24 -0700
Message-ID: <20170607214333.23110-7-himanshu.madhani@cavium.com>
References: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0051.outbound.protection.outlook.com ([104.47.32.51]:52384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751687AbdFGVn6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Jun 2017 17:43:58 -0400
In-Reply-To: <20170607214333.23110-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Add fw_started flag to qpair to reduce access to
qla_hw_data structure by each qpair.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    | 21 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c   |  4 ++--
 drivers/scsi/qla2xxx/qla_isr.c    |  4 ++--
 drivers/scsi/qla2xxx/qla_target.c |  6 ++----
 4 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 18b37c864250..0dec148a4580 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3262,6 +3262,7 @@ struct qla_qpair {
 	/* move vha->flags.difdix_supported here */
 	uint32_t difdix_supported:1;
 	uint32_t delete_in_progress:1;
+	uint32_t fw_started:1;
 
 	uint16_t id;			/* qp number used with FW */
 	uint16_t vp_idx;		/* vport ID */
@@ -4183,6 +4184,26 @@ struct qla2_sgx {
 	srb_t			*sp;
 };
 
+#define QLA_FW_STARTED(_ha) {			\
+	int i;					\
+	_ha->flags.fw_started = 1;		\
+	_ha->base_qpair->fw_started = 1;	\
+	for (i = 0; i < _ha->max_qpairs; i++) {	\
+	if (_ha->queue_pair_map[i])	\
+	_ha->queue_pair_map[i]->fw_started = 1;	\
+	}					\
+}
+
+#define QLA_FW_STOPPED(_ha) {			\
+	int i;					\
+	_ha->flags.fw_started = 0;		\
+	_ha->base_qpair->fw_started = 0;	\
+	for (i = 0; i < _ha->max_qpairs; i++) {	\
+	if (_ha->queue_pair_map[i])	\
+	_ha->queue_pair_map[i]->fw_started = 0;	\
+	}					\
+}
+
 /*
  * Macros to help code, maintain, etc.
  */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index dcc306121a3d..e6a1f9ca0e95 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3207,7 +3207,7 @@ qla2x00_init_rings(scsi_qla_host_t *vha)
 	} else {
 		ql_dbg(ql_dbg_init, vha, 0x00d3,
 		    "Init Firmware -- success.\n");
-		ha->flags.fw_started = 1;
+		QLA_FW_STARTED(ha);
 	}
 
 	return (rval);
@@ -6841,7 +6841,7 @@ qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 		ret = qla2x00_stop_firmware(vha);
 	}
 
-	ha->flags.fw_started = 0;
+	QLA_FW_STOPPED(ha);
 	ha->flags.fw_init_done = 0;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 3c9f9aa7f2c2..7ebd92ee94c3 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -710,7 +710,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 
 		ha->isp_ops->fw_dump(vha, 1);
 		ha->flags.fw_init_done = 0;
-		ha->flags.fw_started = 0;
+		QLA_FW_STOPPED(ha);
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			if (mb[1] == 0 && mb[2] == 0) {
@@ -2759,7 +2759,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 	struct sts_entry_24xx *pkt;
 	struct qla_hw_data *ha = vha->hw;
 
-	if (!ha->flags.fw_started)
+	if (!rsp->qpair->fw_started)
 		return;
 
 	if (rsp->qpair->cpuid != smp_processor_id())
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index cbe6ff9f663e..8e855093740c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3047,7 +3047,6 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	uint8_t scsi_status)
 {
 	struct scsi_qla_host *vha = cmd->vha;
-	struct qla_hw_data *ha = vha->hw;
 	struct qla_qpair *qpair = cmd->qpair;
 	struct ctio7_to_24xx *pkt;
 	struct qla_tgt_prm prm;
@@ -3086,7 +3085,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	else
 		vha->tgt_counters.core_qla_que_buf++;
 
-	if (!ha->flags.fw_started || cmd->reset_count != ha->chip_reset) {
+	if (!qpair->fw_started || cmd->reset_count != qpair->chip_reset) {
 		/*
 		 * Either the port is not online or this request was from
 		 * previous life, just abort the processing.
@@ -3206,7 +3205,6 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 {
 	struct ctio7_to_24xx *pkt;
 	struct scsi_qla_host *vha = cmd->vha;
-	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = cmd->tgt;
 	struct qla_tgt_prm prm;
 	unsigned long flags = 0;
@@ -3223,7 +3221,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	if (qlt_pci_map_calc_cnt(&prm) != 0)
 		return -EAGAIN;
 
-	if (!ha->flags.fw_started || (cmd->reset_count != ha->chip_reset) ||
+	if (!qpair->fw_started || (cmd->reset_count != qpair->chip_reset) ||
 	    (cmd->sess && cmd->sess->deleted)) {
 		/*
 		 * Either the port is not online or this request was from
-- 
2.12.0
