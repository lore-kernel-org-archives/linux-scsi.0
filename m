From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 03/15] lpfc: Add support for ELS LCB.
Date: Thu, 21 May 2015 13:55:18 -0400
Message-ID: <555e1c06.2WPAB9vE6mCM5B9Z%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33232 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249AbbEURzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:24 -0400
Received: by qgfa63 with SMTP id a63so25674450qgf.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:24 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id t32sm13696211qgd.21.2015.05.21.10.55.23
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add support for ELS LCB.

Also has a little whitespace fixing.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc.h      |   1 +
 drivers/scsi/lpfc/lpfc_els.c  | 239 +++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hw.h   |  32 ++++++
 drivers/scsi/lpfc/lpfc_hw4.h  |  27 ++++-
 drivers/scsi/lpfc/lpfc_init.c |   2 +
 drivers/scsi/lpfc/lpfc_sli4.h |  11 ++
 6 files changed, 306 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 9b81a34..3246d09 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -230,6 +230,7 @@ struct lpfc_stats {
 	uint32_t elsRcvRRQ;
 	uint32_t elsRcvRTV;
 	uint32_t elsRcvECHO;
+	uint32_t elsRcvLCB;
 	uint32_t elsXmitFLOGI;
 	uint32_t elsXmitFDISC;
 	uint32_t elsXmitPLOGI;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 851e8ef..3975276 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4587,16 +4587,16 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
 		if (!NLP_CHK_NODE_ACT(ndlp))
 			continue;
 		if (ndlp->nlp_state == NLP_STE_NPR_NODE &&
-		    (ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
-		    (ndlp->nlp_flag & NLP_DELAY_TMO) == 0 &&
-		    (ndlp->nlp_flag & NLP_NPR_ADISC) == 0) {
+				(ndlp->nlp_flag & NLP_NPR_2B_DISC) != 0 &&
+				(ndlp->nlp_flag & NLP_DELAY_TMO) == 0 &&
+				(ndlp->nlp_flag & NLP_NPR_ADISC) == 0) {
 			ndlp->nlp_prev_state = ndlp->nlp_state;
 			lpfc_nlp_set_state(vport, ndlp, NLP_STE_PLOGI_ISSUE);
 			lpfc_issue_els_plogi(vport, ndlp->nlp_DID, 0);
 			sentplogi++;
 			vport->num_disc_nodes++;
 			if (vport->num_disc_nodes >=
-			    vport->cfg_discovery_threads) {
+					vport->cfg_discovery_threads) {
 				spin_lock_irq(shost->host_lock);
 				vport->fc_flag |= FC_NLP_MORE;
 				spin_unlock_irq(shost->host_lock);
@@ -4615,6 +4615,233 @@ lpfc_els_disc_plogi(struct lpfc_vport *vport)
 	return sentplogi;
 }
 
+static void
+lpfc_els_lcb_rsp(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
+{
+	MAILBOX_t *mb;
+	IOCB_t *icmd;
+	uint8_t *pcmd;
+	struct lpfc_iocbq *elsiocb;
+	struct lpfc_nodelist *ndlp;
+	struct ls_rjt *stat;
+	struct lpfc_lcb_context *lcb_context;
+	struct fc_lcb_res_frame *lcb_res;
+	uint32_t cmdsize;
+	int rc;
+
+	mb = &pmb->u.mb;
+
+	lcb_context = (struct lpfc_lcb_context *)pmb->context1;
+	ndlp = lcb_context->ndlp;
+	pmb->context1 = NULL;
+	pmb->context2 = NULL;
+
+	if (mb->mbxStatus) {
+		mempool_free(pmb, phba->mbox_mem_pool);
+		goto error;
+	}
+
+	mempool_free(pmb, phba->mbox_mem_pool);
+
+	cmdsize = sizeof(struct fc_lcb_res_frame);
+	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
+			lpfc_max_els_tries, ndlp,
+			ndlp->nlp_DID, ELS_CMD_ACC);
+
+	/* Decrement the ndlp reference count from previous mbox command */
+	lpfc_nlp_put(ndlp);
+
+	if (!elsiocb)
+		goto free_lcb_context;
+
+	lcb_res = (struct fc_lcb_res_frame *)
+		(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+
+	icmd = &elsiocb->iocb;
+	icmd->ulpContext = lcb_context->rx_id;
+	icmd->unsli3.rcvsli3.ox_id = lcb_context->ox_id;
+
+	pcmd = (uint8_t *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+	*((uint32_t *)(pcmd)) = ELS_CMD_ACC;
+	lcb_res->lcb_sub_command = lcb_context->sub_command;
+	lcb_res->lcb_type = lcb_context->type;
+	lcb_res->lcb_frequency = lcb_context->frequency;
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
+	phba->fc_stat.elsXmitACC++;
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
+	if (rc == IOCB_ERROR)
+		lpfc_els_free_iocb(phba, elsiocb);
+
+	kfree(lcb_context);
+	return;
+
+error:
+	cmdsize = sizeof(struct fc_lcb_res_frame);
+	elsiocb = lpfc_prep_els_iocb(phba->pport, 0, cmdsize,
+			lpfc_max_els_tries, ndlp,
+			ndlp->nlp_DID, ELS_CMD_LS_RJT);
+	lpfc_nlp_put(ndlp);
+	if (!elsiocb)
+		goto free_lcb_context;
+
+	icmd = &elsiocb->iocb;
+	icmd->ulpContext = lcb_context->rx_id;
+	icmd->unsli3.rcvsli3.ox_id = lcb_context->ox_id;
+	pcmd = (uint8_t *)(((struct lpfc_dmabuf *)elsiocb->context2)->virt);
+
+	*((uint32_t *)(pcmd)) = ELS_CMD_LS_RJT;
+	stat = (struct ls_rjt *)(pcmd + sizeof(uint32_t));
+	stat->un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
+
+	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
+	phba->fc_stat.elsXmitLSRJT++;
+	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
+	if (rc == IOCB_ERROR)
+		lpfc_els_free_iocb(phba, elsiocb);
+free_lcb_context:
+	kfree(lcb_context);
+}
+
+static int
+lpfc_sli4_set_beacon(struct lpfc_vport *vport,
+		     struct lpfc_lcb_context *lcb_context,
+		     uint32_t beacon_state)
+{
+	struct lpfc_hba *phba = vport->phba;
+	LPFC_MBOXQ_t *mbox = NULL;
+	uint32_t len;
+	int rc;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return 1;
+
+	len = sizeof(struct lpfc_mbx_set_beacon_config) -
+		sizeof(struct lpfc_sli4_cfg_mhdr);
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_SET_BEACON_CONFIG, len,
+			 LPFC_SLI4_MBX_EMBED);
+	mbox->context1 = (void *)lcb_context;
+	mbox->vport = phba->pport;
+	mbox->mbox_cmpl = lpfc_els_lcb_rsp;
+	bf_set(lpfc_mbx_set_beacon_port_num, &mbox->u.mqe.un.beacon_config,
+	       phba->sli4_hba.physical_port);
+	bf_set(lpfc_mbx_set_beacon_state, &mbox->u.mqe.un.beacon_config,
+	       beacon_state);
+	bf_set(lpfc_mbx_set_beacon_port_type, &mbox->u.mqe.un.beacon_config, 1);
+	bf_set(lpfc_mbx_set_beacon_duration, &mbox->u.mqe.un.beacon_config, 0);
+	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+	if (rc == MBX_NOT_FINISHED) {
+		mempool_free(mbox, phba->mbox_mem_pool);
+		return 1;
+	}
+
+	return 0;
+}
+
+
+/**
+ * lpfc_els_rcv_lcb - Process an unsolicited LCB
+ * @vport: pointer to a host virtual N_Port data structure.
+ * @cmdiocb: pointer to lpfc command iocb data structure.
+ * @ndlp: pointer to a node-list data structure.
+ *
+ * This routine processes an unsolicited LCB(LINK CABLE BEACON) IOCB.
+ * First, the payload of the unsolicited LCB is checked.
+ * Then based on Subcommand beacon will either turn on or off.
+ *
+ * Return code
+ * 0 - Sent the acc response
+ * 1 - Sent the reject response.
+ **/
+static int
+lpfc_els_rcv_lcb(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
+		 struct lpfc_nodelist *ndlp)
+{
+	struct lpfc_hba *phba = vport->phba;
+	struct lpfc_dmabuf *pcmd;
+	IOCB_t *icmd;
+	uint8_t *lp;
+	struct fc_lcb_request_frame *beacon;
+	struct lpfc_lcb_context *lcb_context;
+	uint8_t state, rjt_err;
+	struct ls_rjt stat;
+
+	icmd = &cmdiocb->iocb;
+	pcmd = (struct lpfc_dmabuf *)cmdiocb->context2;
+	lp = (uint8_t *)pcmd->virt;
+	beacon = (struct fc_lcb_request_frame *)pcmd->virt;
+
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			"0192 ELS LCB Data x%x x%x x%x x%x sub x%x "
+			"type x%x frequency %x duration x%x\n",
+			lp[0], lp[1], lp[2],
+			beacon->lcb_command,
+			beacon->lcb_sub_command,
+			beacon->lcb_type,
+			beacon->lcb_frequency,
+			be16_to_cpu(beacon->lcb_duration));
+
+	if (phba->sli_rev < LPFC_SLI_REV4 ||
+	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	    LPFC_SLI_INTF_IF_TYPE_2)) {
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		goto rjt;
+	}
+	lcb_context = kmalloc(sizeof(struct lpfc_lcb_context), GFP_KERNEL);
+
+	if (phba->hba_flag & HBA_FCOE_MODE) {
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		goto rjt;
+	}
+	if (beacon->lcb_frequency == 0) {
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		goto rjt;
+	}
+	if ((beacon->lcb_type != LPFC_LCB_GREEN) &&
+	    (beacon->lcb_type != LPFC_LCB_AMBER)) {
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		goto rjt;
+	}
+	if ((beacon->lcb_sub_command != LPFC_LCB_ON) &&
+	    (beacon->lcb_sub_command != LPFC_LCB_OFF)) {
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		goto rjt;
+	}
+	if ((beacon->lcb_sub_command == LPFC_LCB_ON) &&
+	    (beacon->lcb_type != LPFC_LCB_GREEN) &&
+	    (beacon->lcb_type != LPFC_LCB_AMBER)) {
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		goto rjt;
+	}
+	if (be16_to_cpu(beacon->lcb_duration) != 0) {
+		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		goto rjt;
+	}
+
+	state = (beacon->lcb_sub_command == LPFC_LCB_ON) ? 1 : 0;
+	lcb_context->sub_command = beacon->lcb_sub_command;
+	lcb_context->type = beacon->lcb_type;
+	lcb_context->frequency = beacon->lcb_frequency;
+	lcb_context->ox_id = cmdiocb->iocb.unsli3.rcvsli3.ox_id;
+	lcb_context->rx_id = cmdiocb->iocb.ulpContext;
+	lcb_context->ndlp = lpfc_nlp_get(ndlp);
+	if (lpfc_sli4_set_beacon(vport, lcb_context, state)) {
+		lpfc_printf_vlog(ndlp->vport, KERN_ERR,
+				 LOG_ELS, "0193 failed to send mail box");
+		lpfc_nlp_put(ndlp);
+		rjt_err = LSRJT_UNABLE_TPC;
+		goto rjt;
+	}
+	return 0;
+rjt:
+	memset(&stat, 0, sizeof(stat));
+	stat.un.b.lsRjtRsnCode = rjt_err;
+	lpfc_els_rsp_reject(vport, stat.un.lsRjtError, cmdiocb, ndlp, NULL);
+	return 1;
+}
+
+
 /**
  * lpfc_els_flush_rscn - Clean up any rscn activities with a vport
  * @vport: pointer to a host virtual N_Port data structure.
@@ -6821,6 +7048,10 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb, NLP_EVT_RCV_PRLO);
 		break;
+	case ELS_CMD_LCB:
+		phba->fc_stat.elsRcvLCB++;
+		lpfc_els_rcv_lcb(vport, elsiocb, ndlp);
+		break;
 	case ELS_CMD_RSCN:
 		phba->fc_stat.elsRcvRSCN++;
 		lpfc_els_rcv_rscn(vport, elsiocb, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 37beb9d..6ad0a6f 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -558,6 +558,7 @@ struct fc_vft_header {
 #define ELS_CMD_SCR       0x62000000
 #define ELS_CMD_RNID      0x78000000
 #define ELS_CMD_LIRR      0x7A000000
+#define ELS_CMD_LCB	  0x81000000
 #else	/*  __LITTLE_ENDIAN_BITFIELD */
 #define ELS_CMD_MASK      0xffff
 #define ELS_RSP_MASK      0xff
@@ -595,6 +596,7 @@ struct fc_vft_header {
 #define ELS_CMD_SCR       0x62
 #define ELS_CMD_RNID      0x78
 #define ELS_CMD_LIRR      0x7A
+#define ELS_CMD_LCB	  0x81
 #endif
 
 /*
@@ -1010,6 +1012,36 @@ typedef struct _ELS_PKT {	/* Structure is in Big Endian format */
 	} un;
 } ELS_PKT;
 
+/*
+ * Link Cable Beacon (LCB) ELS Frame
+ */
+
+struct fc_lcb_request_frame {
+	uint32_t      lcb_command;      /* ELS command opcode (0x81)     */
+	uint8_t       lcb_sub_command;/* LCB Payload Word 1, bit 24:31 */
+#define LPFC_LCB_ON    0x1
+#define LPFC_LCB_OFF   0x2
+	uint8_t       reserved[3];
+
+	uint8_t       lcb_type; /* LCB Payload Word 2, bit 24:31 */
+#define LPFC_LCB_GREEN 0x1
+#define LPFC_LCB_AMBER 0x2
+	uint8_t       lcb_frequency;    /* LCB Payload Word 2, bit 16:23 */
+	uint16_t      lcb_duration;     /* LCB Payload Word 2, bit 15:0  */
+};
+
+/*
+ * Link Cable Beacon (LCB) ELS Response Frame
+ */
+struct fc_lcb_res_frame {
+	uint32_t      lcb_ls_acc;       /* Acceptance of LCB request (0x02) */
+	uint8_t       lcb_sub_command;/* LCB Payload Word 1, bit 24:31 */
+	uint8_t       reserved[3];
+	uint8_t       lcb_type; /* LCB Payload Word 2, bit 24:31 */
+	uint8_t       lcb_frequency;    /* LCB Payload Word 2, bit 16:23 */
+	uint16_t      lcb_duration;     /* LCB Payload Word 2, bit 15:0  */
+};
+
 /******** FDMI ********/
 
 /* lpfc_sli_ct_request defines the CT_IU preamble for FDMI commands */
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 1813c45..9f2bfcc 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -914,6 +914,8 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET			0x3D
 #define LPFC_MBOX_OPCODE_SET_PHYSICAL_LINK_CONFIG	0x3E
 #define LPFC_MBOX_OPCODE_SET_BOOT_CONFIG		0x43
+#define LPFC_MBOX_OPCODE_SET_BEACON_CONFIG              0x45
+#define LPFC_MBOX_OPCODE_GET_BEACON_CONFIG              0x46
 #define LPFC_MBOX_OPCODE_GET_PORT_NAME			0x4D
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT			0x5A
 #define LPFC_MBOX_OPCODE_GET_VPD_DATA			0x5B
@@ -1479,6 +1481,26 @@ struct lpfc_mbx_query_fw_config {
 	} rsp;
 };
 
+struct lpfc_mbx_set_beacon_config {
+	struct mbox_header header;
+	uint32_t word4;
+#define lpfc_mbx_set_beacon_port_num_SHIFT		0
+#define lpfc_mbx_set_beacon_port_num_MASK		0x0000003F
+#define lpfc_mbx_set_beacon_port_num_WORD		word4
+#define lpfc_mbx_set_beacon_port_type_SHIFT		6
+#define lpfc_mbx_set_beacon_port_type_MASK		0x00000003
+#define lpfc_mbx_set_beacon_port_type_WORD		word4
+#define lpfc_mbx_set_beacon_state_SHIFT			8
+#define lpfc_mbx_set_beacon_state_MASK			0x000000FF
+#define lpfc_mbx_set_beacon_state_WORD			word4
+#define lpfc_mbx_set_beacon_duration_SHIFT		16
+#define lpfc_mbx_set_beacon_duration_MASK		0x000000FF
+#define lpfc_mbx_set_beacon_duration_WORD		word4
+#define lpfc_mbx_set_beacon_status_duration_SHIFT	24
+#define lpfc_mbx_set_beacon_status_duration_MASK	0x000000FF
+#define lpfc_mbx_set_beacon_status_duration_WORD	word4
+};
+
 struct lpfc_id_range {
 	uint32_t word5;
 #define lpfc_mbx_rsrc_id_word4_0_SHIFT	0
@@ -3021,6 +3043,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_request_features req_ftrs;
 		struct lpfc_mbx_post_hdr_tmpl hdr_tmpl;
 		struct lpfc_mbx_query_fw_config query_fw_cfg;
+		struct lpfc_mbx_set_beacon_config beacon_config;
 		struct lpfc_mbx_supp_pages supp_pages;
 		struct lpfc_mbx_pc_sli4_params sli4_params;
 		struct lpfc_mbx_get_sli4_parameters get_sli4_parameters;
@@ -3041,8 +3064,8 @@ struct lpfc_mcqe {
 #define lpfc_mcqe_status_MASK		0x0000FFFF
 #define lpfc_mcqe_status_WORD		word0
 #define lpfc_mcqe_ext_status_SHIFT	16
-#define lpfc_mcqe_ext_status_MASK  	0x0000FFFF
-#define lpfc_mcqe_ext_status_WORD 	word0
+#define lpfc_mcqe_ext_status_MASK	0x0000FFFF
+#define lpfc_mcqe_ext_status_WORD	word0
 	uint32_t mcqe_tag0;
 	uint32_t mcqe_tag1;
 	uint32_t trailer;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index e8c8c1e..15825f6 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -7500,6 +7500,8 @@ lpfc_sli4_queue_setup(struct lpfc_hba *phba)
 			mboxq->u.mqe.un.query_fw_cfg.rsp.function_mode;
 	phba->sli4_hba.ulp0_mode = mboxq->u.mqe.un.query_fw_cfg.rsp.ulp0_mode;
 	phba->sli4_hba.ulp1_mode = mboxq->u.mqe.un.query_fw_cfg.rsp.ulp1_mode;
+	phba->sli4_hba.physical_port =
+			mboxq->u.mqe.un.query_fw_cfg.rsp.physical_port;
 	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
 			"3251 QUERY_FW_CFG: func_mode:x%x, ulp0_mode:x%x, "
 			"ulp1_mode:x%x\n", phba->sli4_hba.fw_func_mode,
diff --git a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
index 6eca3b8..2ce6cb5 100644
--- a/drivers/scsi/lpfc/lpfc_sli4.h
+++ b/drivers/scsi/lpfc/lpfc_sli4.h
@@ -602,6 +602,7 @@ struct lpfc_sli4_hba {
 	struct lpfc_iov iov;
 	spinlock_t abts_scsi_buf_list_lock; /* list of aborted SCSI IOs */
 	spinlock_t abts_sgl_list_lock; /* list of aborted els IOs */
+	uint32_t physical_port;
 
 	/* CPU to vector mapping information */
 	struct lpfc_vector_map_info *cpu_map;
@@ -651,6 +652,16 @@ struct lpfc_rsrc_blks {
 	uint16_t rsrc_used;
 };
 
+struct lpfc_lcb_context {
+	uint8_t  sub_command;
+	uint8_t  type;
+	uint8_t  frequency;
+	uint16_t ox_id;
+	uint16_t rx_id;
+	struct lpfc_nodelist *ndlp;
+};
+
+
 /*
  * SLI4 specific function prototypes
  */
-- 
1.7.11.7

