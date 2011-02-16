From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/6] lpfc 8.3.21: Critical Errors and Bug Fixes
Date: Wed, 16 Feb 2011 12:39:24 -0500
Message-ID: <1297877964.1492.20.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:7544 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753591Ab1BPRjm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2011 12:39:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Critical Errors:
- Correctly handle non-zero return lpfc_workq_post_event and return ENOMEM
- Save the irq level when locking the host_lock in lpfc_findnode_did

Bug Fixes:
- Adjust payload_length and request_length for sli4_config mailbox commands.
- Add the freed sgl/XRI to the tail of the list rather than to the head.
- Set the FC_VPORT_NEEDS_INIT_VPI on vport deletes and check it before
  issuing a fdisc on an els retry.
- Only call lpfc_hba_init_link() if phba->cfg_suppress_link_up
  is LPFC_INITIALIZE_LINK.
- Add support for SLI-4 Performance Hints 

 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    2 +
 lpfc_attr.c    |   29 ++++++++++++--
 lpfc_crtn.h    |    4 +-
 lpfc_els.c     |    3 +
 lpfc_hbadisc.c |    5 +-
 lpfc_hw4.h     |  104 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 lpfc_init.c    |  113 +++++++++++++++++++++++++++++++++++++++++++--------------
 lpfc_mbox.c    |   16 ++++----
 lpfc_scsi.c    |   15 +++++++
 lpfc_sli.c     |   21 +++++++---
 lpfc_sli4.h    |    4 ++
 lpfc_vport.c   |    4 ++
 12 files changed, 264 insertions(+), 56 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-02-16 11:23:50.000000000 -0500
@@ -623,10 +623,14 @@ lpfc_do_offline(struct lpfc_hba *phba, u
 	int status = 0;
 	int cnt = 0;
 	int i;
+	int rc;
 
 	init_completion(&online_compl);
-	lpfc_workq_post_event(phba, &status, &online_compl,
+	rc = lpfc_workq_post_event(phba, &status, &online_compl,
 			      LPFC_EVT_OFFLINE_PREP);
+	if (rc == 0)
+		return -ENOMEM;
+
 	wait_for_completion(&online_compl);
 
 	if (status != 0)
@@ -652,7 +656,10 @@ lpfc_do_offline(struct lpfc_hba *phba, u
 	}
 
 	init_completion(&online_compl);
-	lpfc_workq_post_event(phba, &status, &online_compl, type);
+	rc = lpfc_workq_post_event(phba, &status, &online_compl, type);
+	if (rc == 0)
+		return -ENOMEM;
+
 	wait_for_completion(&online_compl);
 
 	if (status != 0)
@@ -682,6 +689,7 @@ lpfc_selective_reset(struct lpfc_hba *ph
 {
 	struct completion online_compl;
 	int status = 0;
+	int rc;
 
 	if (!phba->cfg_enable_hba_reset)
 		return -EIO;
@@ -692,8 +700,11 @@ lpfc_selective_reset(struct lpfc_hba *ph
 		return status;
 
 	init_completion(&online_compl);
-	lpfc_workq_post_event(phba, &status, &online_compl,
+	rc = lpfc_workq_post_event(phba, &status, &online_compl,
 			      LPFC_EVT_ONLINE);
+	if (rc == 0)
+		return -ENOMEM;
+
 	wait_for_completion(&online_compl);
 
 	if (status != 0)
@@ -812,14 +823,17 @@ lpfc_board_mode_store(struct device *dev
 	struct lpfc_hba   *phba = vport->phba;
 	struct completion online_compl;
 	int status=0;
+	int rc;
 
 	if (!phba->cfg_enable_hba_reset)
 		return -EACCES;
 	init_completion(&online_compl);
 
 	if(strncmp(buf, "online", sizeof("online") - 1) == 0) {
-		lpfc_workq_post_event(phba, &status, &online_compl,
+		rc = lpfc_workq_post_event(phba, &status, &online_compl,
 				      LPFC_EVT_ONLINE);
+		if (rc == 0)
+			return -ENOMEM;
 		wait_for_completion(&online_compl);
 	} else if (strncmp(buf, "offline", sizeof("offline") - 1) == 0)
 		status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
@@ -1813,6 +1827,7 @@ lpfc_soft_wwpn_store(struct device *dev,
 	int stat1=0, stat2=0;
 	unsigned int i, j, cnt=count;
 	u8 wwpn[8];
+	int rc;
 
 	if (!phba->cfg_enable_hba_reset)
 		return -EACCES;
@@ -1863,7 +1878,11 @@ lpfc_soft_wwpn_store(struct device *dev,
 				"0463 lpfc_soft_wwpn attribute set failed to "
 				"reinit adapter - %d\n", stat1);
 	init_completion(&online_compl);
-	lpfc_workq_post_event(phba, &stat2, &online_compl, LPFC_EVT_ONLINE);
+	rc = lpfc_workq_post_event(phba, &stat2, &online_compl,
+				   LPFC_EVT_ONLINE);
+	if (rc == 0)
+		return -ENOMEM;
+
 	wait_for_completion(&online_compl);
 	if (stat2)
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-02-16 11:23:37.000000000 -0500
@@ -53,9 +53,9 @@ void lpfc_unreg_vpi(struct lpfc_hba *, u
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
 void lpfc_supported_pages(struct lpfcMboxq *);
-void lpfc_sli4_params(struct lpfcMboxq *);
+void lpfc_pc_sli4_params(struct lpfcMboxq *);
 int lpfc_pc_sli4_params_get(struct lpfc_hba *, LPFC_MBOXQ_t *);
-
+int lpfc_get_sli4_parameters(struct lpfc_hba *, LPFC_MBOXQ_t *);
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
 void lpfc_cleanup_rcv_buffers(struct lpfc_vport *);
 void lpfc_rcv_seq_check_edtov(struct lpfc_vport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-02-16 11:23:37.000000000 -0500
@@ -2745,7 +2745,8 @@ lpfc_els_retry_delay_handler(struct lpfc
 		}
 		break;
 	case ELS_CMD_FDISC:
-		lpfc_issue_els_fdisc(vport, ndlp, retry);
+		if (!(vport->fc_flag & FC_VPORT_NEEDS_INIT_VPI))
+			lpfc_issue_els_fdisc(vport, ndlp, retry);
 		break;
 	}
 	return;
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc.h	2011-02-16 11:23:37.000000000 -0500
@@ -548,6 +548,8 @@ struct lpfc_hba {
 #define LPFC_SLI3_CRP_ENABLED		0x08
 #define LPFC_SLI3_BG_ENABLED		0x20
 #define LPFC_SLI3_DSS_ENABLED		0x40
+#define LPFC_SLI4_PERFH_ENABLED		0x80
+#define LPFC_SLI4_PHWQ_ENABLED		0x100
 	uint32_t iocb_cmd_size;
 	uint32_t iocb_rsp_size;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-02-16 11:23:50.000000000 -0500
@@ -4426,10 +4426,11 @@ lpfc_findnode_did(struct lpfc_vport *vpo
 {
 	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_nodelist *ndlp;
+	unsigned long iflags;
 
-	spin_lock_irq(shost->host_lock);
+	spin_lock_irqsave(shost->host_lock, iflags);
 	ndlp = __lpfc_findnode_did(vport, did);
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock_irqrestore(shost->host_lock, iflags);
 	return ndlp;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-02-16 11:23:37.000000000 -0500
@@ -778,6 +778,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_QUERY_FW_CFG		0x3A
 #define LPFC_MBOX_OPCODE_FUNCTION_RESET		0x3D
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT		0x5A
+#define LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS	0xB5
 
 /* FCoE Opcodes */
 #define LPFC_MBOX_OPCODE_FCOE_WQ_CREATE			0x01
@@ -1852,6 +1853,9 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rq_ifip_SHIFT		7
 #define lpfc_mbx_rq_ftr_rq_ifip_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rq_ifip_WORD		word2
+#define lpfc_mbx_rq_ftr_rq_perfh_SHIFT		11
+#define lpfc_mbx_rq_ftr_rq_perfh_MASK		0x00000001
+#define lpfc_mbx_rq_ftr_rq_perfh_WORD		word2
 	uint32_t word3;
 #define lpfc_mbx_rq_ftr_rsp_iaab_SHIFT		0
 #define lpfc_mbx_rq_ftr_rsp_iaab_MASK		0x00000001
@@ -1877,6 +1881,9 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rsp_ifip_SHIFT		7
 #define lpfc_mbx_rq_ftr_rsp_ifip_MASK		0x00000001
 #define lpfc_mbx_rq_ftr_rsp_ifip_WORD		word3
+#define lpfc_mbx_rq_ftr_rsp_perfh_SHIFT		11
+#define lpfc_mbx_rq_ftr_rsp_perfh_MASK		0x00000001
+#define lpfc_mbx_rq_ftr_rsp_perfh_WORD		word3
 };
 
 struct lpfc_mbx_supp_pages {
@@ -1935,7 +1942,7 @@ struct lpfc_mbx_supp_pages {
 #define LPFC_SLI4_PARAMETERS		2
 };
 
-struct lpfc_mbx_sli4_params {
+struct lpfc_mbx_pc_sli4_params {
 	uint32_t word1;
 #define qs_SHIFT				0
 #define qs_MASK					0x00000001
@@ -2051,6 +2058,88 @@ struct lpfc_mbx_sli4_params {
 	uint32_t rsvd_13_63[51];
 };
 
+struct lpfc_sli4_parameters {
+	uint32_t word0;
+#define cfg_prot_type_SHIFT			0
+#define cfg_prot_type_MASK			0x000000FF
+#define cfg_prot_type_WORD			word0
+	uint32_t word1;
+#define cfg_ft_SHIFT				0
+#define cfg_ft_MASK				0x00000001
+#define cfg_ft_WORD				word1
+#define cfg_sli_rev_SHIFT			4
+#define cfg_sli_rev_MASK			0x0000000f
+#define cfg_sli_rev_WORD			word1
+#define cfg_sli_family_SHIFT			8
+#define cfg_sli_family_MASK			0x0000000f
+#define cfg_sli_family_WORD			word1
+#define cfg_if_type_SHIFT			12
+#define cfg_if_type_MASK			0x0000000f
+#define cfg_if_type_WORD			word1
+#define cfg_sli_hint_1_SHIFT			16
+#define cfg_sli_hint_1_MASK			0x000000ff
+#define cfg_sli_hint_1_WORD			word1
+#define cfg_sli_hint_2_SHIFT			24
+#define cfg_sli_hint_2_MASK			0x0000001f
+#define cfg_sli_hint_2_WORD			word1
+	uint32_t word2;
+	uint32_t word3;
+	uint32_t word4;
+#define cfg_cqv_SHIFT				14
+#define cfg_cqv_MASK				0x00000003
+#define cfg_cqv_WORD				word4
+	uint32_t word5;
+	uint32_t word6;
+#define cfg_mqv_SHIFT				14
+#define cfg_mqv_MASK				0x00000003
+#define cfg_mqv_WORD				word6
+	uint32_t word7;
+	uint32_t word8;
+#define cfg_wqv_SHIFT				14
+#define cfg_wqv_MASK				0x00000003
+#define cfg_wqv_WORD				word8
+	uint32_t word9;
+	uint32_t word10;
+#define cfg_rqv_SHIFT				14
+#define cfg_rqv_MASK				0x00000003
+#define cfg_rqv_WORD				word10
+	uint32_t word11;
+#define cfg_rq_db_window_SHIFT			28
+#define cfg_rq_db_window_MASK			0x0000000f
+#define cfg_rq_db_window_WORD			word11
+	uint32_t word12;
+#define cfg_fcoe_SHIFT 				0
+#define cfg_fcoe_MASK				0x00000001
+#define cfg_fcoe_WORD				word12
+#define cfg_phwq_SHIFT 				15
+#define cfg_phwq_MASK				0x00000001
+#define cfg_phwq_WORD				word12
+#define cfg_loopbk_scope_SHIFT			28
+#define cfg_loopbk_scope_MASK			0x0000000f
+#define cfg_loopbk_scope_WORD			word12
+	uint32_t sge_supp_len;
+	uint32_t word14;
+#define cfg_sgl_page_cnt_SHIFT			0
+#define cfg_sgl_page_cnt_MASK			0x0000000f
+#define cfg_sgl_page_cnt_WORD			word14
+#define cfg_sgl_page_size_SHIFT			8
+#define cfg_sgl_page_size_MASK			0x000000ff
+#define cfg_sgl_page_size_WORD			word14
+#define cfg_sgl_pp_align_SHIFT			16
+#define cfg_sgl_pp_align_MASK			0x000000ff
+#define cfg_sgl_pp_align_WORD			word14
+	uint32_t word15;
+	uint32_t word16;
+	uint32_t word17;
+	uint32_t word18;
+	uint32_t word19;
+};
+
+struct lpfc_mbx_get_sli4_parameters {
+	struct mbox_header header;
+	struct lpfc_sli4_parameters sli4_parameters;
+};
+
 /* Mailbox Completion Queue Error Messages */
 #define MB_CQE_STATUS_SUCCESS 			0x0
 #define MB_CQE_STATUS_INSUFFICIENT_PRIVILEGES	0x1
@@ -2103,7 +2192,8 @@ struct lpfc_mqe {
 		struct lpfc_mbx_post_hdr_tmpl hdr_tmpl;
 		struct lpfc_mbx_query_fw_cfg query_fw_cfg;
 		struct lpfc_mbx_supp_pages supp_pages;
-		struct lpfc_mbx_sli4_params sli4_params;
+		struct lpfc_mbx_pc_sli4_params sli4_params;
+		struct lpfc_mbx_get_sli4_parameters get_sli4_parameters;
 		struct lpfc_mbx_nop nop;
 	} un;
 };
@@ -2381,6 +2471,10 @@ struct wqe_common {
 #define wqe_wqes_SHIFT        15
 #define wqe_wqes_MASK         0x00000001
 #define wqe_wqes_WORD         word10
+/* Note that this field overlaps above fields */
+#define wqe_wqid_SHIFT        1
+#define wqe_wqid_MASK         0x0000007f
+#define wqe_wqid_WORD         word10
 #define wqe_pri_SHIFT         16
 #define wqe_pri_MASK          0x00000007
 #define wqe_pri_WORD          word10
@@ -2599,7 +2693,8 @@ struct fcp_iwrite64_wqe {
 	uint32_t total_xfer_len;
 	uint32_t initial_xfer_len;
 	struct wqe_common wqe_com;     /* words 6-11 */
-	uint32_t rsvd_12_15[4];         /* word 12-15 */
+	uint32_t rsrvd12;
+	struct ulp_bde64 ph_bde;       /* words 13-15 */
 };
 
 struct fcp_iread64_wqe {
@@ -2608,7 +2703,8 @@ struct fcp_iread64_wqe {
 	uint32_t total_xfer_len;       /* word 4 */
 	uint32_t rsrvd5;               /* word 5 */
 	struct wqe_common wqe_com;     /* words 6-11 */
-	uint32_t rsvd_12_15[4];         /* word 12-15 */
+	uint32_t rsrvd12;
+	struct ulp_bde64 ph_bde;       /* words 13-15 */
 };
 
 struct fcp_icmnd64_wqe {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-02-16 11:23:37.000000000 -0500
@@ -4283,36 +4283,37 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_bsmbx;
 	}
 
-	/* Get the Supported Pages. It is always available. */
+	/* Get the Supported Pages if PORT_CAPABILITIES is supported by port. */
 	lpfc_supported_pages(mboxq);
 	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-	if (unlikely(rc)) {
-		rc = -EIO;
-		mempool_free(mboxq, phba->mbox_mem_pool);
-		goto out_free_bsmbx;
-	}
-
-	mqe = &mboxq->u.mqe;
-	memcpy(&pn_page[0], ((uint8_t *)&mqe->un.supp_pages.word3),
-	       LPFC_MAX_SUPPORTED_PAGES);
-	for (i = 0; i < LPFC_MAX_SUPPORTED_PAGES; i++) {
-		switch (pn_page[i]) {
-		case LPFC_SLI4_PARAMETERS:
-			phba->sli4_hba.pc_sli4_params.supported = 1;
-			break;
-		default:
-			break;
+	if (!rc) {
+		mqe = &mboxq->u.mqe;
+		memcpy(&pn_page[0], ((uint8_t *)&mqe->un.supp_pages.word3),
+		       LPFC_MAX_SUPPORTED_PAGES);
+		for (i = 0; i < LPFC_MAX_SUPPORTED_PAGES; i++) {
+			switch (pn_page[i]) {
+			case LPFC_SLI4_PARAMETERS:
+				phba->sli4_hba.pc_sli4_params.supported = 1;
+				break;
+			default:
+				break;
+			}
+		}
+		/* Read the port's SLI4 Parameters capabilities if supported. */
+		if (phba->sli4_hba.pc_sli4_params.supported)
+			rc = lpfc_pc_sli4_params_get(phba, mboxq);
+		if (rc) {
+			mempool_free(mboxq, phba->mbox_mem_pool);
+			rc = -EIO;
+			goto out_free_bsmbx;
 		}
 	}
-
-	/* Read the port's SLI4 Parameters capabilities if supported. */
-	if (phba->sli4_hba.pc_sli4_params.supported)
-		rc = lpfc_pc_sli4_params_get(phba, mboxq);
+	/*
+	 * Get sli4 parameters that override parameters from Port capabilities.
+	 * If this call fails it is not a critical error so continue loading.
+	 */
+	lpfc_get_sli4_parameters(phba, mboxq);
 	mempool_free(mboxq, phba->mbox_mem_pool);
-	if (rc) {
-		rc = -EIO;
-		goto out_free_bsmbx;
-	}
 	/* Create all the SLI4 queues */
 	rc = lpfc_sli4_queue_create(phba);
 	if (rc)
@@ -7810,7 +7811,7 @@ lpfc_pc_sli4_params_get(struct lpfc_hba 
 	mqe = &mboxq->u.mqe;
 
 	/* Read the port's SLI4 Parameters port capabilities */
-	lpfc_sli4_params(mboxq);
+	lpfc_pc_sli4_params(mboxq);
 	if (!phba->sli4_hba.intr_enable)
 		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
 	else {
@@ -7854,6 +7855,66 @@ lpfc_pc_sli4_params_get(struct lpfc_hba 
 }
 
 /**
+ * lpfc_get_sli4_parameters - Get the SLI4 Config PARAMETERS.
+ * @phba: Pointer to HBA context object.
+ * @mboxq: Pointer to the mailboxq memory for the mailbox command response.
+ *
+ * This function is called in the SLI4 code path to read the port's
+ * sli4 capabilities.
+ *
+ * This function may be be called from any context that can block-wait
+ * for the completion.  The expectation is that this routine is called
+ * typically from probe_one or from the online routine.
+ **/
+int
+lpfc_get_sli4_parameters(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	int rc;
+	struct lpfc_mqe *mqe = &mboxq->u.mqe;
+	struct lpfc_pc_sli4_params *sli4_params;
+	int length;
+	struct lpfc_sli4_parameters *mbx_sli4_parameters;
+
+	/* Read the port's SLI4 Config Parameters */
+	length = (sizeof(struct lpfc_mbx_get_sli4_parameters) -
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
+	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_COMMON,
+			 LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS,
+			 length, LPFC_SLI4_MBX_EMBED);
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	else
+		rc = lpfc_sli_issue_mbox_wait(phba, mboxq,
+			lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG));
+	if (unlikely(rc))
+		return rc;
+	sli4_params = &phba->sli4_hba.pc_sli4_params;
+	mbx_sli4_parameters = &mqe->un.get_sli4_parameters.sli4_parameters;
+	sli4_params->if_type = bf_get(cfg_if_type, mbx_sli4_parameters);
+	sli4_params->sli_rev = bf_get(cfg_sli_rev, mbx_sli4_parameters);
+	sli4_params->sli_family = bf_get(cfg_sli_family, mbx_sli4_parameters);
+	sli4_params->featurelevel_1 = bf_get(cfg_sli_hint_1,
+					     mbx_sli4_parameters);
+	sli4_params->featurelevel_2 = bf_get(cfg_sli_hint_2,
+					     mbx_sli4_parameters);
+	if (bf_get(cfg_phwq, mbx_sli4_parameters))
+		phba->sli3_options |= LPFC_SLI4_PHWQ_ENABLED;
+	else
+		phba->sli3_options &= ~LPFC_SLI4_PHWQ_ENABLED;
+	sli4_params->sge_supp_len = mbx_sli4_parameters->sge_supp_len;
+	sli4_params->loopbk_scope = bf_get(loopbk_scope, mbx_sli4_parameters);
+	sli4_params->cqv = bf_get(cfg_cqv, mbx_sli4_parameters);
+	sli4_params->mqv = bf_get(cfg_mqv, mbx_sli4_parameters);
+	sli4_params->wqv = bf_get(cfg_wqv, mbx_sli4_parameters);
+	sli4_params->rqv = bf_get(cfg_rqv, mbx_sli4_parameters);
+	sli4_params->sgl_pages_max = bf_get(cfg_sgl_page_cnt,
+					    mbx_sli4_parameters);
+	sli4_params->sgl_pp_align = bf_get(cfg_sgl_pp_align,
+					   mbx_sli4_parameters);
+	return 0;
+}
+
+/**
  * lpfc_pci_probe_one_s3 - PCI probe func to reg SLI-3 device to PCI subsystem.
  * @pdev: pointer to PCI device
  * @pid: pointer to PCI device identifier
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2011-02-16 11:23:37.000000000 -0500
@@ -1692,7 +1692,7 @@ lpfc_sli4_mbox_cmd_free(struct lpfc_hba 
  * @mbox: pointer to lpfc mbox command.
  * @subsystem: The sli4 config sub mailbox subsystem.
  * @opcode: The sli4 config sub mailbox command opcode.
- * @length: Length of the sli4 config mailbox command.
+ * @length: Length of the sli4 config mailbox command (including sub-header).
  *
  * This routine sets up the header fields of SLI4 specific mailbox command
  * for sending IOCTL command.
@@ -1723,14 +1723,14 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 	if (emb) {
 		/* Set up main header fields */
 		bf_set(lpfc_mbox_hdr_emb, &sli4_config->header.cfg_mhdr, 1);
-		sli4_config->header.cfg_mhdr.payload_length =
-					LPFC_MBX_CMD_HDR_LENGTH + length;
+		sli4_config->header.cfg_mhdr.payload_length = length;
 		/* Set up sub-header fields following main header */
 		bf_set(lpfc_mbox_hdr_opcode,
 			&sli4_config->header.cfg_shdr.request, opcode);
 		bf_set(lpfc_mbox_hdr_subsystem,
 			&sli4_config->header.cfg_shdr.request, subsystem);
-		sli4_config->header.cfg_shdr.request.request_length = length;
+		sli4_config->header.cfg_shdr.request.request_length =
+			length - LPFC_MBX_CMD_HDR_LENGTH;
 		return length;
 	}
 
@@ -1902,6 +1902,7 @@ lpfc_request_features(struct lpfc_hba *p
 
 	/* Set up host requested features. */
 	bf_set(lpfc_mbx_rq_ftr_rq_fcpi, &mboxq->u.mqe.un.req_ftrs, 1);
+	bf_set(lpfc_mbx_rq_ftr_rq_perfh, &mboxq->u.mqe.un.req_ftrs, 1);
 
 	/* Enable DIF (block guard) only if configured to do so. */
 	if (phba->cfg_enable_bg)
@@ -2159,17 +2160,16 @@ lpfc_supported_pages(struct lpfcMboxq *m
 }
 
 /**
- * lpfc_sli4_params - Initialize the PORT_CAPABILITIES SLI4 Params
- *                    mailbox command.
+ * lpfc_pc_sli4_params - Initialize the PORT_CAPABILITIES SLI4 Params mbox cmd.
  * @mbox: pointer to lpfc mbox command to initialize.
  *
  * The PORT_CAPABILITIES SLI4 parameters mailbox command is issued to
  * retrieve the particular SLI4 features supported by the port.
  **/
 void
-lpfc_sli4_params(struct lpfcMboxq *mbox)
+lpfc_pc_sli4_params(struct lpfcMboxq *mbox)
 {
-	struct lpfc_mbx_sli4_params *sli4_params;
+	struct lpfc_mbx_pc_sli4_params *sli4_params;
 
 	memset(mbox, 0, sizeof(*mbox));
 	sli4_params = &mbox->u.mqe.un.sli4_params;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-12-11 21:56:16.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2011-02-16 11:23:37.000000000 -0500
@@ -1981,12 +1981,14 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 	struct scatterlist *sgel = NULL;
 	struct fcp_cmnd *fcp_cmnd = lpfc_cmd->fcp_cmnd;
 	struct sli4_sge *sgl = (struct sli4_sge *)lpfc_cmd->fcp_bpl;
+	struct sli4_sge *first_data_sgl;
 	IOCB_t *iocb_cmd = &lpfc_cmd->cur_iocbq.iocb;
 	dma_addr_t physaddr;
 	uint32_t num_bde = 0;
 	uint32_t dma_len;
 	uint32_t dma_offset = 0;
 	int nseg;
+	struct ulp_bde64 *bde;
 
 	/*
 	 * There are three possibilities here - use scatter-gather segment, use
@@ -2011,7 +2013,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 		bf_set(lpfc_sli4_sge_last, sgl, 0);
 		sgl->word2 = cpu_to_le32(sgl->word2);
 		sgl += 1;
-
+		first_data_sgl = sgl;
 		lpfc_cmd->seg_cnt = nseg;
 		if (lpfc_cmd->seg_cnt > phba->cfg_sg_seg_cnt) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_BG, "9074 BLKGRD:"
@@ -2047,6 +2049,17 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 			dma_offset += dma_len;
 			sgl++;
 		}
+		/* setup the performance hint (first data BDE) if enabled */
+		if (phba->sli3_options & LPFC_SLI4_PERFH_ENABLED) {
+			bde = (struct ulp_bde64 *)
+					&(iocb_cmd->unsli3.sli3Words[5]);
+			bde->addrLow = first_data_sgl->addr_lo;
+			bde->addrHigh = first_data_sgl->addr_hi;
+			bde->tus.f.bdeSize =
+					le32_to_cpu(first_data_sgl->sge_len);
+			bde->tus.f.bdeFlags = BUFF_TYPE_BDE_64;
+			bde->tus.w = cpu_to_le32(bde->tus.w);
+		}
 	} else {
 		sgl += 1;
 		/* clear the last flag in the fcp_rsp map entry */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2011-02-16 11:23:37.000000000 -0500
@@ -359,6 +359,10 @@ struct lpfc_pc_sli4_params {
 	uint32_t hdr_pp_align;
 	uint32_t sgl_pages_max;
 	uint32_t sgl_pp_align;
+	uint8_t cqv;
+	uint8_t mqv;
+	uint8_t wqv;
+	uint8_t rqv;
 };
 
 /* SLI4 HBA data structure entries */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-02-15 10:03:48.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-02-16 11:23:37.000000000 -0500
@@ -96,7 +96,8 @@ lpfc_sli4_wq_put(struct lpfc_queue *q, u
 	/* set consumption flag every once in a while */
 	if (!((q->host_index + 1) % LPFC_RELEASE_NOTIFICATION_INTERVAL))
 		bf_set(wqe_wqec, &wqe->generic.wqe_com, 1);
-
+	if (q->phba->sli3_options & LPFC_SLI4_PHWQ_ENABLED)
+		bf_set(wqe_wqid, &wqe->generic.wqe_com, q->queue_id);
 	lpfc_sli_pcimem_bcopy(wqe, temp_wqe, q->entry_size);
 
 	/* Update the host index before invoking device */
@@ -969,7 +970,8 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 		} else {
 			sglq->state = SGL_FREED;
 			sglq->ndlp = NULL;
-			list_add(&sglq->list, &phba->sli4_hba.lpfc_sgl_list);
+			list_add_tail(&sglq->list,
+				&phba->sli4_hba.lpfc_sgl_list);
 
 			/* Check if TXQ queue needs to be serviced */
 			if (pring->txq_cnt)
@@ -4817,7 +4819,10 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 				"0378 No support for fcpi mode.\n");
 		ftr_rsp++;
 	}
-
+	if (bf_get(lpfc_mbx_rq_ftr_rsp_perfh, &mqe->un.req_ftrs))
+		phba->sli3_options |= LPFC_SLI4_PERFH_ENABLED;
+	else
+		phba->sli3_options &= ~LPFC_SLI4_PERFH_ENABLED;
 	/*
 	 * If the port cannot support the host's requested features
 	 * then turn off the global config parameters to disable the
@@ -5004,7 +5009,8 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	spin_lock_irq(&phba->hbalock);
 	phba->link_state = LPFC_LINK_DOWN;
 	spin_unlock_irq(&phba->hbalock);
-	rc = phba->lpfc_hba_init_link(phba, MBX_NOWAIT);
+	if (phba->cfg_suppress_link_up == LPFC_INITIALIZE_LINK)
+		rc = phba->lpfc_hba_init_link(phba, MBX_NOWAIT);
 out_unset_queue:
 	/* Unset all the queues set up in this routine when error out */
 	if (rc)
@@ -11189,7 +11195,7 @@ lpfc_rq_destroy(struct lpfc_hba *phba, s
 	if (!mbox)
 		return -ENOMEM;
 	length = (sizeof(struct lpfc_mbx_rq_destroy) -
-		  sizeof(struct mbox_header));
+		  sizeof(struct lpfc_sli4_cfg_mhdr));
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
 			 LPFC_MBOX_OPCODE_FCOE_RQ_DESTROY,
 			 length, LPFC_SLI4_MBX_EMBED);
@@ -11279,7 +11285,7 @@ lpfc_sli4_post_sgl(struct lpfc_hba *phba
 	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_FCOE,
 			LPFC_MBOX_OPCODE_FCOE_POST_SGL_PAGES,
 			sizeof(struct lpfc_mbx_post_sgl_pages) -
-			sizeof(struct mbox_header), LPFC_SLI4_MBX_EMBED);
+			sizeof(struct lpfc_sli4_cfg_mhdr), LPFC_SLI4_MBX_EMBED);
 
 	post_sgl_pages = (struct lpfc_mbx_post_sgl_pages *)
 				&mbox->u.mqe.un.post_sgl_pages;
@@ -12402,7 +12408,8 @@ lpfc_sli4_post_rpi_hdr(struct lpfc_hba *
 	lpfc_sli4_config(phba, mboxq, LPFC_MBOX_SUBSYSTEM_FCOE,
 			 LPFC_MBOX_OPCODE_FCOE_POST_HDR_TEMPLATE,
 			 sizeof(struct lpfc_mbx_post_hdr_tmpl) -
-			 sizeof(struct mbox_header), LPFC_SLI4_MBX_EMBED);
+			 sizeof(struct lpfc_sli4_cfg_mhdr),
+			 LPFC_SLI4_MBX_EMBED);
 	bf_set(lpfc_mbx_post_hdr_tmpl_page_cnt,
 	       hdr_tmpl, rpi_page->page_count);
 	bf_set(lpfc_mbx_post_hdr_tmpl_rpi_offset, hdr_tmpl,
diff -upNr a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
--- a/drivers/scsi/lpfc/lpfc_vport.c	2010-12-11 21:56:17.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_vport.c	2011-02-16 11:23:37.000000000 -0500
@@ -464,6 +464,7 @@ disable_vport(struct fc_vport *fc_vport)
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_nodelist *ndlp = NULL, *next_ndlp = NULL;
 	long timeout;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
 	ndlp = lpfc_findnode_did(vport, Fabric_DID);
 	if (ndlp && NLP_CHK_NODE_ACT(ndlp)
@@ -498,6 +499,9 @@ disable_vport(struct fc_vport *fc_vport)
 	 * scsi_host_put() to release the vport.
 	 */
 	lpfc_mbx_unreg_vpi(vport);
+	spin_lock_irq(shost->host_lock);
+	vport->fc_flag |= FC_VPORT_NEEDS_INIT_VPI;
+	spin_unlock_irq(shost->host_lock);
 
 	lpfc_vport_set_state(vport, FC_VPORT_DISABLED);
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_VPORT,


