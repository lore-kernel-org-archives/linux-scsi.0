From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 3/11]  qla2xxx: Generalize SNS generic-services routines.
Date: Mon, 13 Jun 2005 22:31:51 -0700 (PDT)
Message-ID: <20050614053151.12127.52950.sendpatchset@plap.qlogic.com>
References: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:43926 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261200AbVFNFbx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2005 01:31:53 -0400
In-Reply-To: <20050614053136.12127.506.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Generalize SNS generic-services routines.

Consolidate completion-status checking while adding support
for the ISP24xx.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_gs.c |  174 +++++++++++++++++++++++++++--------------
 1 files changed, 115 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -21,12 +21,19 @@
 static inline ms_iocb_entry_t *
 qla2x00_prep_ms_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
 
+static inline void *
+qla24xx_prep_ms_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
+
 static inline struct ct_sns_req *
 qla2x00_prep_ct_req(struct ct_sns_req *, uint16_t, uint16_t);
 
 static inline struct sns_cmd_pkt *
 qla2x00_prep_sns_cmd(scsi_qla_host_t *, uint16_t, uint16_t, uint16_t);
 
+static int
+qla2x00_chk_ms_status(scsi_qla_host_t *, ms_iocb_entry_t *, struct ct_sns_rsp *,
+    const char *);
+
 static int qla2x00_sns_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 static int qla2x00_sns_gid_pt(scsi_qla_host_t *, sw_info_t *);
 static int qla2x00_sns_gpn_id(scsi_qla_host_t *, sw_info_t *);
@@ -34,8 +41,9 @@ static int qla2x00_sns_gnn_id(scsi_qla_h
 static int qla2x00_sns_rft_id(scsi_qla_host_t *);
 static int qla2x00_sns_rnn_id(scsi_qla_host_t *);
 
+
 /**
- * qla2x00_prep_ms_iocb() - Prepare common MS IOCB fields for SNS CT query.
+ * qla2x00_prep_ms_iocb() - Prepare common MS/CT IOCB fields for SNS CT query.
  * @ha: HA context
  * @req_size: request size in bytes
  * @rsp_size: response size in bytes
@@ -47,6 +55,9 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *ha
 {
 	ms_iocb_entry_t *ms_pkt;
 
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+		return qla24xx_prep_ms_iocb(ha, req_size, rsp_size);
+
 	ms_pkt = ha->ms_iocb;
 	memset(ms_pkt, 0, sizeof(ms_iocb_entry_t));
 
@@ -72,6 +83,42 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *ha
 }
 
 /**
+ * qla24xx_prep_ms_iocb() - Prepare common CT IOCB fields for SNS CT query.
+ * @ha: HA context
+ * @req_size: request size in bytes
+ * @rsp_size: response size in bytes
+ *
+ * Returns a pointer to the @ha's ms_iocb.
+ */
+static inline void *
+qla24xx_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
+{
+	struct ct_entry_24xx *ct_pkt;
+
+	ct_pkt = (struct ct_entry_24xx *)ha->ms_iocb;
+	memset(ct_pkt, 0, sizeof(struct ct_entry_24xx));
+
+	ct_pkt->entry_type = CT_IOCB_TYPE;
+	ct_pkt->entry_count = 1;
+	ct_pkt->nport_handle = __constant_cpu_to_le16(NPH_SNS);
+	ct_pkt->timeout = __constant_cpu_to_le16(25);
+	ct_pkt->cmd_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->rsp_dsd_count = __constant_cpu_to_le16(1);
+	ct_pkt->rsp_byte_count = cpu_to_le32(rsp_size);
+	ct_pkt->cmd_byte_count = cpu_to_le32(req_size);
+
+	ct_pkt->dseg_0_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
+	ct_pkt->dseg_0_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ct_pkt->dseg_0_len = ct_pkt->cmd_byte_count;
+
+	ct_pkt->dseg_1_address[0] = cpu_to_le32(LSD(ha->ct_sns_dma));
+	ct_pkt->dseg_1_address[1] = cpu_to_le32(MSD(ha->ct_sns_dma));
+	ct_pkt->dseg_1_len = ct_pkt->rsp_byte_count;
+
+	return (ct_pkt);
+}
+
+/**
  * qla2x00_prep_ct_req() - Prepare common CT request fields for SNS query.
  * @ct_req: CT request buffer
  * @cmd: GS command
@@ -93,6 +140,47 @@ qla2x00_prep_ct_req(struct ct_sns_req *c
 	return (ct_req);
 }
 
+static int
+qla2x00_chk_ms_status(scsi_qla_host_t *ha, ms_iocb_entry_t *ms_pkt,
+    struct ct_sns_rsp *ct_rsp, const char *routine)
+{
+	int rval;
+	uint16_t comp_status;
+
+	rval = QLA_FUNCTION_FAILED;
+	if (ms_pkt->entry_status != 0) {
+		DEBUG2_3(printk("scsi(%ld): %s failed, error status (%x).\n",
+		    ha->host_no, routine, ms_pkt->entry_status));
+	} else {
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+			comp_status =
+			    ((struct ct_entry_24xx *)ms_pkt)->comp_status;
+		else
+			comp_status = le16_to_cpu(ms_pkt->status);
+		switch (comp_status) {
+		case CS_COMPLETE:
+		case CS_DATA_UNDERRUN:
+		case CS_DATA_OVERRUN:		/* Overrun? */
+			if (ct_rsp->header.response !=
+			    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
+				DEBUG2_3(printk("scsi(%ld): %s failed, "
+				    "rejected request:\n", ha->host_no,
+				    routine));
+				DEBUG2_3(qla2x00_dump_buffer(
+				    (uint8_t *)&ct_rsp->header,
+				    sizeof(struct ct_rsp_hdr)));
+			} else
+				rval = QLA_SUCCESS;
+			break;
+		default:
+			DEBUG2_3(printk("scsi(%ld): %s failed, completion "
+			    "status (%x).\n", ha->host_no, routine,
+			    comp_status));
+			break;
+		}
+	}
+	return rval;
+}
 
 /**
  * qla2x00_ga_nxt() - SNS scan for fabric devices via GA_NXT command.
@@ -135,12 +223,8 @@ qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_p
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): GA_NXT issue IOCB failed (%d).\n",
 		    ha->host_no, rval));
-	} else if (ct_rsp->header.response !=
-	    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-		DEBUG2_3(printk("scsi(%ld): GA_NXT failed, rejected request, "
-		    "ga_nxt_rsp:\n", ha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-		    sizeof(struct ct_rsp_hdr)));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "GA_NXT") !=
+	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		/* Populate fc_port_t entry. */
@@ -223,12 +307,8 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_i
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): GID_PT issue IOCB failed (%d).\n",
 		    ha->host_no, rval));
-	} else if (ct_rsp->header.response !=
-	    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-		DEBUG2_3(printk("scsi(%ld): GID_PT failed, rejected request, "
-		    "gid_pt_rsp:\n", ha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-		    sizeof(struct ct_rsp_hdr)));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "GID_PT") !=
+	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		/* Set port IDs in switch info list. */
@@ -302,12 +382,8 @@ qla2x00_gpn_id(scsi_qla_host_t *ha, sw_i
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GPN_ID issue IOCB failed "
 			    "(%d).\n", ha->host_no, rval));
-		} else if (ct_rsp->header.response !=
-		    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-			DEBUG2_3(printk("scsi(%ld): GPN_ID failed, rejected "
-			    "request, gpn_id_rsp:\n", ha->host_no));
-			DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-			    sizeof(struct ct_rsp_hdr)));
+		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+		    "GPN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Save portname */
@@ -367,12 +443,8 @@ qla2x00_gnn_id(scsi_qla_host_t *ha, sw_i
 			/*EMPTY*/
 			DEBUG2_3(printk("scsi(%ld): GNN_ID issue IOCB failed "
 			    "(%d).\n", ha->host_no, rval));
-		} else if (ct_rsp->header.response !=
-		    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-			DEBUG2_3(printk("scsi(%ld): GNN_ID failed, rejected "
-			    "request, gnn_id_rsp:\n", ha->host_no));
-			DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-			    sizeof(struct ct_rsp_hdr)));
+		} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp,
+		    "GNN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Save nodename */
@@ -446,12 +518,8 @@ qla2x00_rft_id(scsi_qla_host_t *ha)
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RFT_ID issue IOCB failed (%d).\n",
 		    ha->host_no, rval));
-	} else if (ct_rsp->header.response !=
-	    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-		DEBUG2_3(printk("scsi(%ld): RFT_ID failed, rejected "
-		    "request, rft_id_rsp:\n", ha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-		    sizeof(struct ct_rsp_hdr)));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RFT_ID") !=
+	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RFT_ID exiting normally.\n",
@@ -505,12 +573,8 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RFF_ID issue IOCB failed (%d).\n",
 		    ha->host_no, rval));
-	} else if (ct_rsp->header.response !=
-	    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-		DEBUG2_3(printk("scsi(%ld): RFF_ID failed, rejected "
-		    "request, rff_id_rsp:\n", ha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-		    sizeof(struct ct_rsp_hdr)));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RFF_ID") !=
+	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RFF_ID exiting normally.\n",
@@ -553,7 +617,7 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
 	ct_req->req.rnn_id.port_id[1] = ha->d_id.b.area;
 	ct_req->req.rnn_id.port_id[2] = ha->d_id.b.al_pa;
 
-	memcpy(ct_req->req.rnn_id.node_name, ha->init_cb->node_name, WWN_SIZE);
+	memcpy(ct_req->req.rnn_id.node_name, ha->node_name, WWN_SIZE);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
@@ -562,12 +626,8 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RNN_ID issue IOCB failed (%d).\n",
 		    ha->host_no, rval));
-	} else if (ct_rsp->header.response !=
-	    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-		DEBUG2_3(printk("scsi(%ld): RNN_ID failed, rejected "
-		    "request, rnn_id_rsp:\n", ha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-		    sizeof(struct ct_rsp_hdr)));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RNN_ID") !=
+	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RNN_ID exiting normally.\n",
@@ -611,7 +671,7 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- node_name, symbolic node_name, size */
-	memcpy(ct_req->req.rsnn_nn.node_name, ha->init_cb->node_name, WWN_SIZE);
+	memcpy(ct_req->req.rsnn_nn.node_name, ha->node_name, WWN_SIZE);
 	
 	/* Prepare the Symbolic Node Name */
 	/* Board type */
@@ -641,12 +701,8 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 		/*EMPTY*/
 		DEBUG2_3(printk("scsi(%ld): RSNN_NN issue IOCB failed (%d).\n",
 		    ha->host_no, rval));
-	} else if (ct_rsp->header.response !=
-	    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-		DEBUG2_3(printk("scsi(%ld): RSNN_NN failed, rejected "
-		    "request, rsnn_id_rsp:\n", ha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer((uint8_t *)&ct_rsp->header,
-		    sizeof(struct ct_rsp_hdr)));
+	} else if (qla2x00_chk_ms_status(ha, ms_pkt, ct_rsp, "RSNN_NN") !=
+	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		DEBUG2(printk("scsi(%ld): RSNN_NN exiting normally.\n",
@@ -1028,14 +1084,14 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
 	sns_cmd->p.cmd.param[1] = ha->d_id.b.area;
 	sns_cmd->p.cmd.param[2] = ha->d_id.b.domain;
 
-	sns_cmd->p.cmd.param[4] = ha->init_cb->node_name[7];
-	sns_cmd->p.cmd.param[5] = ha->init_cb->node_name[6];
-	sns_cmd->p.cmd.param[6] = ha->init_cb->node_name[5];
-	sns_cmd->p.cmd.param[7] = ha->init_cb->node_name[4];
-	sns_cmd->p.cmd.param[8] = ha->init_cb->node_name[3];
-	sns_cmd->p.cmd.param[9] = ha->init_cb->node_name[2];
-	sns_cmd->p.cmd.param[10] = ha->init_cb->node_name[1];
-	sns_cmd->p.cmd.param[11] = ha->init_cb->node_name[0];
+	sns_cmd->p.cmd.param[4] = ha->node_name[7];
+	sns_cmd->p.cmd.param[5] = ha->node_name[6];
+	sns_cmd->p.cmd.param[6] = ha->node_name[5];
+	sns_cmd->p.cmd.param[7] = ha->node_name[4];
+	sns_cmd->p.cmd.param[8] = ha->node_name[3];
+	sns_cmd->p.cmd.param[9] = ha->node_name[2];
+	sns_cmd->p.cmd.param[10] = ha->node_name[1];
+	sns_cmd->p.cmd.param[11] = ha->node_name[0];
 
 	/* Execute SNS command. */
 	rval = qla2x00_send_sns(ha, ha->sns_cmd_dma, RNN_ID_SNS_CMD_SIZE / 2,
------------

-- 
Andrew Vasquez
