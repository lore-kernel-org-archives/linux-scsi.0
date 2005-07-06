From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 5/17]  qla2xxx: Generalize SNS generic-services routines.
Date: Wed,  6 Jul 2005 10:30:47 -0700 (PDT)
Message-ID: <20050706173047.10568.3270.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:4433 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S261792AbVGFRas (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:30:48 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Generalize SNS generic-services routines.

Consolidate completion-status checking while adding support
for the ISP24xx.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_def.h |    3 -
 drivers/scsi/qla2xxx/qla_gbl.h |    4 -
 drivers/scsi/qla2xxx/qla_gs.c  |  181 +++++++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_mbx.c |    6 +
 4 files changed, 121 insertions(+), 73 deletions(-)

da11a5f4bce50e1db314b57ba5871e6efa538f33
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2032,8 +2032,7 @@ struct isp_operations {
 
 	uint16_t (*calc_req_entries) (uint16_t);
 	void (*build_iocbs) (srb_t *, cmd_entry_t *, uint16_t);
-	ms_iocb_entry_t * (*prep_ms_iocb) (struct scsi_qla_host *, uint32_t,
-	    uint32_t);
+	void * (*prep_ms_iocb) (struct scsi_qla_host *, uint32_t, uint32_t);
 
 	uint8_t * (*read_nvram) (struct scsi_qla_host *, uint8_t *,
 		uint32_t, uint32_t);
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -219,8 +219,8 @@ extern void qla2x00_dump_pkt(void *);
 /*
  * Global Function Prototypes in qla_gs.c source file.
  */
-extern ms_iocb_entry_t *qla2x00_prep_ms_iocb(scsi_qla_host_t *, uint32_t,
-    uint32_t);
+extern void *qla2x00_prep_ms_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
+extern void *qla24xx_prep_ms_iocb(scsi_qla_host_t *, uint32_t, uint32_t);
 extern int qla2x00_ga_nxt(scsi_qla_host_t *, fc_port_t *);
 extern int qla2x00_gid_pt(scsi_qla_host_t *, sw_info_t *);
 extern int qla2x00_gpn_id(scsi_qla_host_t *, sw_info_t *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -32,14 +32,14 @@ static int qla2x00_sns_rft_id(scsi_qla_h
 static int qla2x00_sns_rnn_id(scsi_qla_host_t *);
 
 /**
- * qla2x00_prep_ms_iocb() - Prepare common MS IOCB fields for SNS CT query.
+ * qla2x00_prep_ms_iocb() - Prepare common MS/CT IOCB fields for SNS CT query.
  * @ha: HA context
  * @req_size: request size in bytes
  * @rsp_size: response size in bytes
  *
  * Returns a pointer to the @ha's ms_iocb.
  */
-ms_iocb_entry_t *
+void *
 qla2x00_prep_ms_iocb(scsi_qla_host_t *ha, uint32_t req_size, uint32_t rsp_size)
 {
 	ms_iocb_entry_t *ms_pkt;
@@ -69,6 +69,42 @@ qla2x00_prep_ms_iocb(scsi_qla_host_t *ha
 }
 
 /**
+ * qla24xx_prep_ms_iocb() - Prepare common CT IOCB fields for SNS CT query.
+ * @ha: HA context
+ * @req_size: request size in bytes
+ * @rsp_size: response size in bytes
+ *
+ * Returns a pointer to the @ha's ms_iocb.
+ */
+void *
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
@@ -90,6 +126,47 @@ qla2x00_prep_ct_req(struct ct_sns_req *c
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
@@ -113,7 +190,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_p
 
 	/* Issue GA_NXT */
 	/* Prepare common MS IOCB */
-	ms_pkt = qla2x00_prep_ms_iocb(ha, GA_NXT_REQ_SIZE, GA_NXT_RSP_SIZE);
+	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GA_NXT_REQ_SIZE, GA_NXT_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GA_NXT_CMD,
@@ -132,12 +209,8 @@ qla2x00_ga_nxt(scsi_qla_host_t *ha, fc_p
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
@@ -203,7 +276,7 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_i
 
 	/* Issue GID_PT */
 	/* Prepare common MS IOCB */
-	ms_pkt = qla2x00_prep_ms_iocb(ha, GID_PT_REQ_SIZE, GID_PT_RSP_SIZE);
+	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GID_PT_REQ_SIZE, GID_PT_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, GID_PT_CMD,
@@ -220,12 +293,8 @@ qla2x00_gid_pt(scsi_qla_host_t *ha, sw_i
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
@@ -279,7 +348,7 @@ qla2x00_gpn_id(scsi_qla_host_t *ha, sw_i
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GPN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = qla2x00_prep_ms_iocb(ha, GPN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GPN_ID_REQ_SIZE,
 		    GPN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -299,12 +368,8 @@ qla2x00_gpn_id(scsi_qla_host_t *ha, sw_i
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
@@ -344,7 +409,7 @@ qla2x00_gnn_id(scsi_qla_host_t *ha, sw_i
 	for (i = 0; i < MAX_FIBRE_DEVICES; i++) {
 		/* Issue GNN_ID */
 		/* Prepare common MS IOCB */
-		ms_pkt = qla2x00_prep_ms_iocb(ha, GNN_ID_REQ_SIZE,
+		ms_pkt = ha->isp_ops.prep_ms_iocb(ha, GNN_ID_REQ_SIZE,
 		    GNN_ID_RSP_SIZE);
 
 		/* Prepare CT request */
@@ -364,12 +429,8 @@ qla2x00_gnn_id(scsi_qla_host_t *ha, sw_i
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
@@ -422,7 +483,7 @@ qla2x00_rft_id(scsi_qla_host_t *ha)
 
 	/* Issue RFT_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = qla2x00_prep_ms_iocb(ha, RFT_ID_REQ_SIZE, RFT_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, RFT_ID_REQ_SIZE, RFT_ID_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFT_ID_CMD,
@@ -443,12 +504,8 @@ qla2x00_rft_id(scsi_qla_host_t *ha)
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
@@ -481,7 +538,7 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
 
 	/* Issue RFF_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = qla2x00_prep_ms_iocb(ha, RFF_ID_REQ_SIZE, RFF_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, RFF_ID_REQ_SIZE, RFF_ID_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RFF_ID_CMD,
@@ -502,12 +559,8 @@ qla2x00_rff_id(scsi_qla_host_t *ha)
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
@@ -538,7 +591,7 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
 
 	/* Issue RNN_ID */
 	/* Prepare common MS IOCB */
-	ms_pkt = qla2x00_prep_ms_iocb(ha, RNN_ID_REQ_SIZE, RNN_ID_RSP_SIZE);
+	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, RNN_ID_REQ_SIZE, RNN_ID_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RNN_ID_CMD,
@@ -550,7 +603,7 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
 	ct_req->req.rnn_id.port_id[1] = ha->d_id.b.area;
 	ct_req->req.rnn_id.port_id[2] = ha->d_id.b.al_pa;
 
-	memcpy(ct_req->req.rnn_id.node_name, ha->init_cb->node_name, WWN_SIZE);
+	memcpy(ct_req->req.rnn_id.node_name, ha->node_name, WWN_SIZE);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(ha, ha->ms_iocb, ha->ms_iocb_dma,
@@ -559,12 +612,8 @@ qla2x00_rnn_id(scsi_qla_host_t *ha)
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
@@ -600,7 +649,7 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	/* Issue RSNN_NN */
 	/* Prepare common MS IOCB */
 	/*   Request size adjusted after CT preparation */
-	ms_pkt = qla2x00_prep_ms_iocb(ha, 0, RSNN_NN_RSP_SIZE);
+	ms_pkt = ha->isp_ops.prep_ms_iocb(ha, 0, RSNN_NN_RSP_SIZE);
 
 	/* Prepare CT request */
 	ct_req = qla2x00_prep_ct_req(&ha->ct_sns->p.req, RSNN_NN_CMD,
@@ -608,7 +657,7 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
 	ct_rsp = &ha->ct_sns->p.rsp;
 
 	/* Prepare CT arguments -- node_name, symbolic node_name, size */
-	memcpy(ct_req->req.rsnn_nn.node_name, ha->init_cb->node_name, WWN_SIZE);
+	memcpy(ct_req->req.rsnn_nn.node_name, ha->node_name, WWN_SIZE);
 	
 	/* Prepare the Symbolic Node Name */
 	/* Board type */
@@ -638,12 +687,8 @@ qla2x00_rsnn_nn(scsi_qla_host_t *ha)
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
@@ -1025,14 +1070,14 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
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
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -822,7 +822,11 @@ qla2x00_issue_iocb(scsi_qla_host_t *ha, 
 		DEBUG2(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x",
 		    ha->host_no,rval);)
 	} else {
-		/*EMPTY*/
+		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
+
+		/* Mask reserved bits. */
+		sts_entry->entry_status &=
+		    IS_QLA24XX(ha) || IS_QLA25XX(ha) ? RF_MASK_24XX :RF_MASK;
 	}
 
 	return rval;

-- 
Andrew Vasquez
