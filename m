From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/6] lpfc 8.3.9: SLI enhancments to support new hardware.
Date: Fri, 12 Feb 2010 14:42:03 -0500
Message-ID: <1266003743.2939.16.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:49972 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757181Ab0BLTmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2010 14:42:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


- Add support for the INTF (Interface) PCI register.
- Add support for greater than 2 page SGLs.
- Add support for up to 32 bit BDE lengths.
- Implement the Port Capabilities Mailbox command.
- Stop checking the Minor Code in the EQE structure.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h |    3 
 lpfc_hw4.h  |  242 ++++++++++++++++++++++++++++++++++++++++++++++++++----------
 lpfc_init.c |  189 ++++++++++++++++++++++++++++++++++++----------
 lpfc_mbox.c |   38 +++++++++
 lpfc_scsi.c |    9 --
 lpfc_sli.c  |   27 ++----
 lpfc_sli4.h |   45 ++++++++++-
 7 files changed, 452 insertions(+), 101 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-12 10:52:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2010-02-12 10:53:08.000000000 -0500
@@ -49,6 +49,9 @@ void lpfc_register_new_vport(struct lpfc
 void lpfc_unreg_vpi(struct lpfc_hba *, uint16_t, LPFC_MBOXQ_t *);
 void lpfc_init_link(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t, uint32_t);
 void lpfc_request_features(struct lpfc_hba *, struct lpfcMboxq *);
+void lpfc_supported_pages(struct lpfcMboxq *);
+void lpfc_sli4_params(struct lpfcMboxq *);
+int lpfc_pc_sli4_params_get(struct lpfc_hba *, LPFC_MBOXQ_t *);
 
 struct lpfc_vport *lpfc_find_vport_by_did(struct lpfc_hba *, uint32_t);
 void lpfc_cleanup_rcv_buffers(struct lpfc_vport *);
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2010-02-12 10:52:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2010-02-12 10:53:08.000000000 -0500
@@ -52,29 +52,35 @@ struct dma_address {
 	uint32_t addr_hi;
 };
 
-#define LPFC_SLIREV_CONF_WORD	0x58
 struct lpfc_sli_intf {
 	uint32_t word0;
-#define lpfc_sli_intf_iftype_MASK 	0x00000007
-#define lpfc_sli_intf_iftype_SHIFT	0
-#define lpfc_sli_intf_iftype_WORD	word0
-#define lpfc_sli_intf_rev_MASK 		0x0000000f
-#define lpfc_sli_intf_rev_SHIFT		4
-#define lpfc_sli_intf_rev_WORD		word0
-#define LPFC_SLIREV_CONF_SLI4	4
-#define lpfc_sli_intf_family_MASK 	0x000000ff
-#define lpfc_sli_intf_family_SHIFT	8
-#define lpfc_sli_intf_family_WORD	word0
-#define lpfc_sli_intf_feat1_MASK 	0x000000ff
-#define lpfc_sli_intf_feat1_SHIFT	16
-#define lpfc_sli_intf_feat1_WORD	word0
-#define lpfc_sli_intf_feat2_MASK 	0x0000001f
-#define lpfc_sli_intf_feat2_SHIFT	24
-#define lpfc_sli_intf_feat2_WORD	word0
-#define lpfc_sli_intf_valid_MASK 	0x00000007
-#define lpfc_sli_intf_valid_SHIFT	29
-#define lpfc_sli_intf_valid_WORD	word0
+#define lpfc_sli_intf_valid_SHIFT		29
+#define lpfc_sli_intf_valid_MASK		0x00000007
+#define lpfc_sli_intf_valid_WORD		word0
 #define LPFC_SLI_INTF_VALID		6
+#define lpfc_sli_intf_featurelevel2_SHIFT	24
+#define lpfc_sli_intf_featurelevel2_MASK	0x0000001F
+#define lpfc_sli_intf_featurelevel2_WORD	word0
+#define lpfc_sli_intf_featurelevel1_SHIFT	16
+#define lpfc_sli_intf_featurelevel1_MASK	0x000000FF
+#define lpfc_sli_intf_featurelevel1_WORD	word0
+#define LPFC_SLI_INTF_FEATURELEVEL1_1	1
+#define LPFC_SLI_INTF_FEATURELEVEL1_2	2
+#define lpfc_sli_intf_sli_family_SHIFT		8
+#define lpfc_sli_intf_sli_family_MASK		0x000000FF
+#define lpfc_sli_intf_sli_family_WORD		word0
+#define LPFC_SLI_INTF_FAMILY_BE2	0
+#define LPFC_SLI_INTF_FAMILY_BE3	1
+#define lpfc_sli_intf_slirev_SHIFT		4
+#define lpfc_sli_intf_slirev_MASK		0x0000000F
+#define lpfc_sli_intf_slirev_WORD		word0
+#define LPFC_SLI_INTF_REV_SLI3		3
+#define LPFC_SLI_INTF_REV_SLI4		4
+#define lpfc_sli_intf_if_type_SHIFT		0
+#define lpfc_sli_intf_if_type_MASK		0x00000007
+#define lpfc_sli_intf_if_type_WORD		word0
+#define LPFC_SLI_INTF_IF_TYPE_0		0
+#define LPFC_SLI_INTF_IF_TYPE_1		1
 };
 
 #define LPFC_SLI4_MBX_EMBED	true
@@ -157,6 +163,9 @@ struct lpfc_sli_intf {
 #define LPFC_FP_DEF_IMAX       10000
 #define LPFC_SP_DEF_IMAX       10000
 
+/* PORT_CAPABILITIES constants. */
+#define LPFC_MAX_SUPPORTED_PAGES	8
+
 struct ulp_bde64 {
 	union ULP_BDE_TUS {
 		uint32_t w;
@@ -512,7 +521,7 @@ struct lpfc_register {
 #define LPFC_UERR_STATUS_LO		0x00A0
 #define LPFC_UE_MASK_HI			0x00AC
 #define LPFC_UE_MASK_LO			0x00A8
-#define LPFC_SCRATCHPAD			0x0058
+#define LPFC_SLI_INTF			0x0058
 
 /* BAR0 Registers */
 #define LPFC_HST_STATE			0x00AC
@@ -572,19 +581,6 @@ struct lpfc_register {
 #define LPFC_POST_STAGE_ARMFW_READY			0xC000
 #define LPFC_POST_STAGE_ARMFW_UE 			0xF000
 
-#define lpfc_scratchpad_slirev_SHIFT			4
-#define lpfc_scratchpad_slirev_MASK			0xF
-#define lpfc_scratchpad_slirev_WORD			word0
-#define lpfc_scratchpad_chiptype_SHIFT			8
-#define lpfc_scratchpad_chiptype_MASK			0xFF
-#define lpfc_scratchpad_chiptype_WORD			word0
-#define lpfc_scratchpad_featurelevel1_SHIFT		16
-#define lpfc_scratchpad_featurelevel1_MASK		0xFF
-#define lpfc_scratchpad_featurelevel1_WORD		word0
-#define lpfc_scratchpad_featurelevel2_SHIFT		24
-#define lpfc_scratchpad_featurelevel2_MASK		0xFF
-#define lpfc_scratchpad_featurelevel2_WORD		word0
-
 /* BAR1 Registers */
 #define LPFC_IMR_MASK_ALL	0xFFFFFFFF
 #define LPFC_ISCR_CLEAR_ALL	0xFFFFFFFF
@@ -1146,10 +1142,7 @@ struct sli4_sge {	/* SLI-4 */
 						this  flag !! */
 #define lpfc_sli4_sge_last_MASK		0x00000001
 #define lpfc_sli4_sge_last_WORD		word2
-	uint32_t word3;
-#define lpfc_sli4_sge_len_SHIFT		0
-#define lpfc_sli4_sge_len_MASK		0x0001FFFF
-#define lpfc_sli4_sge_len_WORD		word3
+	uint32_t sge_len;
 };
 
 struct fcf_record {
@@ -1844,6 +1837,177 @@ struct lpfc_mbx_request_features {
 #define lpfc_mbx_rq_ftr_rsp_ifip_WORD		word3
 };
 
+struct lpfc_mbx_supp_pages {
+	uint32_t word1;
+#define qs_SHIFT 				0
+#define qs_MASK					0x00000001
+#define qs_WORD					word1
+#define wr_SHIFT				1
+#define wr_MASK 				0x00000001
+#define wr_WORD					word1
+#define pf_SHIFT				8
+#define pf_MASK					0x000000ff
+#define pf_WORD					word1
+#define cpn_SHIFT				16
+#define cpn_MASK				0x000000ff
+#define cpn_WORD				word1
+	uint32_t word2;
+#define list_offset_SHIFT 			0
+#define list_offset_MASK			0x000000ff
+#define list_offset_WORD			word2
+#define next_offset_SHIFT			8
+#define next_offset_MASK			0x000000ff
+#define next_offset_WORD			word2
+#define elem_cnt_SHIFT				16
+#define elem_cnt_MASK				0x000000ff
+#define elem_cnt_WORD				word2
+	uint32_t word3;
+#define pn_0_SHIFT				24
+#define pn_0_MASK  				0x000000ff
+#define pn_0_WORD				word3
+#define pn_1_SHIFT				16
+#define pn_1_MASK				0x000000ff
+#define pn_1_WORD				word3
+#define pn_2_SHIFT				8
+#define pn_2_MASK				0x000000ff
+#define pn_2_WORD				word3
+#define pn_3_SHIFT				0
+#define pn_3_MASK				0x000000ff
+#define pn_3_WORD				word3
+	uint32_t word4;
+#define pn_4_SHIFT				24
+#define pn_4_MASK				0x000000ff
+#define pn_4_WORD				word4
+#define pn_5_SHIFT				16
+#define pn_5_MASK				0x000000ff
+#define pn_5_WORD				word4
+#define pn_6_SHIFT				8
+#define pn_6_MASK				0x000000ff
+#define pn_6_WORD				word4
+#define pn_7_SHIFT				0
+#define pn_7_MASK				0x000000ff
+#define pn_7_WORD				word4
+	uint32_t rsvd[27];
+#define LPFC_SUPP_PAGES			0
+#define LPFC_BLOCK_GUARD_PROFILES	1
+#define LPFC_SLI4_PARAMETERS		2
+};
+
+struct lpfc_mbx_sli4_params {
+	uint32_t word1;
+#define qs_SHIFT				0
+#define qs_MASK					0x00000001
+#define qs_WORD					word1
+#define wr_SHIFT				1
+#define wr_MASK					0x00000001
+#define wr_WORD					word1
+#define pf_SHIFT				8
+#define pf_MASK					0x000000ff
+#define pf_WORD					word1
+#define cpn_SHIFT				16
+#define cpn_MASK				0x000000ff
+#define cpn_WORD				word1
+	uint32_t word2;
+#define if_type_SHIFT				0
+#define if_type_MASK				0x00000007
+#define if_type_WORD				word2
+#define sli_rev_SHIFT				4
+#define sli_rev_MASK				0x0000000f
+#define sli_rev_WORD				word2
+#define sli_family_SHIFT			8
+#define sli_family_MASK				0x000000ff
+#define sli_family_WORD				word2
+#define featurelevel_1_SHIFT			16
+#define featurelevel_1_MASK			0x000000ff
+#define featurelevel_1_WORD			word2
+#define featurelevel_2_SHIFT			24
+#define featurelevel_2_MASK			0x0000001f
+#define featurelevel_2_WORD			word2
+	uint32_t word3;
+#define fcoe_SHIFT 				0
+#define fcoe_MASK				0x00000001
+#define fcoe_WORD				word3
+#define fc_SHIFT				1
+#define fc_MASK					0x00000001
+#define fc_WORD					word3
+#define nic_SHIFT				2
+#define nic_MASK				0x00000001
+#define nic_WORD				word3
+#define iscsi_SHIFT				3
+#define iscsi_MASK				0x00000001
+#define iscsi_WORD				word3
+#define rdma_SHIFT				4
+#define rdma_MASK				0x00000001
+#define rdma_WORD				word3
+	uint32_t sge_supp_len;
+	uint32_t word5;
+#define if_page_sz_SHIFT			0
+#define if_page_sz_MASK				0x0000ffff
+#define if_page_sz_WORD				word5
+#define loopbk_scope_SHIFT			24
+#define loopbk_scope_MASK			0x0000000f
+#define loopbk_scope_WORD			word5
+#define rq_db_window_SHIFT			28
+#define rq_db_window_MASK			0x0000000f
+#define rq_db_window_WORD			word5
+	uint32_t word6;
+#define eq_pages_SHIFT				0
+#define eq_pages_MASK				0x0000000f
+#define eq_pages_WORD				word6
+#define eqe_size_SHIFT				8
+#define eqe_size_MASK				0x000000ff
+#define eqe_size_WORD				word6
+	uint32_t word7;
+#define cq_pages_SHIFT				0
+#define cq_pages_MASK				0x0000000f
+#define cq_pages_WORD				word7
+#define cqe_size_SHIFT				8
+#define cqe_size_MASK				0x000000ff
+#define cqe_size_WORD				word7
+	uint32_t word8;
+#define mq_pages_SHIFT				0
+#define mq_pages_MASK				0x0000000f
+#define mq_pages_WORD				word8
+#define mqe_size_SHIFT				8
+#define mqe_size_MASK				0x000000ff
+#define mqe_size_WORD				word8
+#define mq_elem_cnt_SHIFT			16
+#define mq_elem_cnt_MASK			0x000000ff
+#define mq_elem_cnt_WORD			word8
+	uint32_t word9;
+#define wq_pages_SHIFT				0
+#define wq_pages_MASK				0x0000ffff
+#define wq_pages_WORD				word9
+#define wqe_size_SHIFT				8
+#define wqe_size_MASK				0x000000ff
+#define wqe_size_WORD				word9
+	uint32_t word10;
+#define rq_pages_SHIFT				0
+#define rq_pages_MASK				0x0000ffff
+#define rq_pages_WORD				word10
+#define rqe_size_SHIFT				8
+#define rqe_size_MASK				0x000000ff
+#define rqe_size_WORD				word10
+	uint32_t word11;
+#define hdr_pages_SHIFT				0
+#define hdr_pages_MASK				0x0000000f
+#define hdr_pages_WORD				word11
+#define hdr_size_SHIFT				8
+#define hdr_size_MASK				0x0000000f
+#define hdr_size_WORD				word11
+#define hdr_pp_align_SHIFT			16
+#define hdr_pp_align_MASK			0x0000ffff
+#define hdr_pp_align_WORD			word11
+	uint32_t word12;
+#define sgl_pages_SHIFT				0
+#define sgl_pages_MASK				0x0000000f
+#define sgl_pages_WORD				word12
+#define sgl_pp_align_SHIFT			16
+#define sgl_pp_align_MASK			0x0000ffff
+#define sgl_pp_align_WORD			word12
+	uint32_t rsvd_13_63[51];
+};
+
 /* Mailbox Completion Queue Error Messages */
 #define MB_CQE_STATUS_SUCCESS 			0x0
 #define MB_CQE_STATUS_INSUFFICIENT_PRIVILEGES	0x1
@@ -1894,6 +2058,8 @@ struct lpfc_mqe {
 		struct lpfc_mbx_request_features req_ftrs;
 		struct lpfc_mbx_post_hdr_tmpl hdr_tmpl;
 		struct lpfc_mbx_query_fw_cfg query_fw_cfg;
+		struct lpfc_mbx_supp_pages supp_pages;
+		struct lpfc_mbx_sli4_params sli4_params;
 		struct lpfc_mbx_nop nop;
 	} un;
 };
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:52:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2010-02-12 10:53:08.000000000 -0500
@@ -2443,7 +2443,8 @@ lpfc_create_port(struct lpfc_hba *phba, 
 	shost->this_id = -1;
 	shost->max_cmd_len = 16;
 	if (phba->sli_rev == LPFC_SLI_REV4) {
-		shost->dma_boundary = LPFC_SLI4_MAX_SEGMENT_SIZE;
+		shost->dma_boundary =
+			phba->sli4_hba.pc_sli4_params.sge_supp_len;
 		shost->sg_tablesize = phba->cfg_sg_seg_cnt;
 	}
 
@@ -3621,8 +3622,10 @@ static int
 lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 {
 	struct lpfc_sli *psli;
-	int rc;
-	int i, hbq_count;
+	LPFC_MBOXQ_t *mboxq;
+	int rc, i, hbq_count, buf_size, dma_buf_size, max_buf_size;
+	uint8_t pn_page[LPFC_MAX_SUPPORTED_PAGES] = {0};
+	struct lpfc_mqe *mqe;
 
 	/* Before proceed, wait for POST done and device ready */
 	rc = lpfc_sli4_post_status_check(phba);
@@ -3680,31 +3683,26 @@ lpfc_sli4_driver_resource_setup(struct l
 	 * used to create the sg_dma_buf_pool must be dynamically calculated.
 	 * 2 segments are added since the IOCB needs a command and response bde.
 	 * To insure that the scsi sgl does not cross a 4k page boundary only
-	 * sgl sizes of 1k, 2k, 4k, and 8k are supported.
-	 * Table of sgl sizes and seg_cnt:
-	 * sgl size, 	sg_seg_cnt	total seg
-	 * 1k		50		52
-	 * 2k		114		116
-	 * 4k		242		244
-	 * 8k		498		500
-	 * cmd(32) + rsp(160) + (52 * sizeof(sli4_sge)) = 1024
-	 * cmd(32) + rsp(160) + (116 * sizeof(sli4_sge)) = 2048
-	 * cmd(32) + rsp(160) + (244 * sizeof(sli4_sge)) = 4096
-	 * cmd(32) + rsp(160) + (500 * sizeof(sli4_sge)) = 8192
-	 */
-	if (phba->cfg_sg_seg_cnt <= LPFC_DEFAULT_SG_SEG_CNT)
-		phba->cfg_sg_seg_cnt = 50;
-	else if (phba->cfg_sg_seg_cnt <= 114)
-		phba->cfg_sg_seg_cnt = 114;
-	else if (phba->cfg_sg_seg_cnt <= 242)
-		phba->cfg_sg_seg_cnt = 242;
+	 * sgl sizes of must be a power of 2.
+	 */
+	buf_size = (sizeof(struct fcp_cmnd) + sizeof(struct fcp_rsp) +
+		    ((phba->cfg_sg_seg_cnt + 2) * sizeof(struct sli4_sge)));
+	/* Feature Level 1 hardware is limited to 2 pages */
+	if ((bf_get(lpfc_sli_intf_featurelevel1, &phba->sli4_hba.sli_intf) ==
+	     LPFC_SLI_INTF_FEATURELEVEL1_1))
+		max_buf_size = LPFC_SLI4_FL1_MAX_BUF_SIZE;
 	else
-		phba->cfg_sg_seg_cnt = 498;
-
-	phba->cfg_sg_dma_buf_size = sizeof(struct fcp_cmnd)
-					+ sizeof(struct fcp_rsp);
-	phba->cfg_sg_dma_buf_size +=
-		((phba->cfg_sg_seg_cnt + 2) * sizeof(struct sli4_sge));
+		max_buf_size = LPFC_SLI4_MAX_BUF_SIZE;
+	for (dma_buf_size = LPFC_SLI4_MIN_BUF_SIZE;
+	     dma_buf_size < max_buf_size && buf_size > dma_buf_size;
+	     dma_buf_size = dma_buf_size << 1)
+		;
+	if (dma_buf_size == max_buf_size)
+		phba->cfg_sg_seg_cnt = (dma_buf_size -
+			sizeof(struct fcp_cmnd) - sizeof(struct fcp_rsp) -
+			(2 * sizeof(struct sli4_sge))) /
+				sizeof(struct sli4_sge);
+	phba->cfg_sg_dma_buf_size = dma_buf_size;
 
 	/* Initialize buffer queue management fields */
 	hbq_count = lpfc_sli_hbq_count();
@@ -3822,6 +3820,43 @@ lpfc_sli4_driver_resource_setup(struct l
 		goto out_free_fcp_eq_hdl;
 	}
 
+	mboxq = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool,
+						       GFP_KERNEL);
+	if (!mboxq) {
+		rc = -ENOMEM;
+		goto out_free_fcp_eq_hdl;
+	}
+
+	/* Get the Supported Pages. It is always available. */
+	lpfc_supported_pages(mboxq);
+	rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	if (unlikely(rc)) {
+		rc = -EIO;
+		mempool_free(mboxq, phba->mbox_mem_pool);
+		goto out_free_fcp_eq_hdl;
+	}
+
+	mqe = &mboxq->u.mqe;
+	memcpy(&pn_page[0], ((uint8_t *)&mqe->un.supp_pages.word3),
+	       LPFC_MAX_SUPPORTED_PAGES);
+	for (i = 0; i < LPFC_MAX_SUPPORTED_PAGES; i++) {
+		switch (pn_page[i]) {
+		case LPFC_SLI4_PARAMETERS:
+			phba->sli4_hba.pc_sli4_params.supported = 1;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* Read the port's SLI4 Parameters capabilities if supported. */
+	if (phba->sli4_hba.pc_sli4_params.supported)
+		rc = lpfc_pc_sli4_params_get(phba, mboxq);
+	mempool_free(mboxq, phba->mbox_mem_pool);
+	if (rc) {
+		rc = -EIO;
+		goto out_free_fcp_eq_hdl;
+	}
 	return rc;
 
 out_free_fcp_eq_hdl:
@@ -4825,7 +4860,7 @@ lpfc_sli_pci_mem_unset(struct lpfc_hba *
 int
 lpfc_sli4_post_status_check(struct lpfc_hba *phba)
 {
-	struct lpfc_register sta_reg, uerrlo_reg, uerrhi_reg, scratchpad;
+	struct lpfc_register sta_reg, uerrlo_reg, uerrhi_reg;
 	int i, port_error = -ENODEV;
 
 	if (!phba->sli4_hba.STAregaddr)
@@ -4861,14 +4896,21 @@ lpfc_sli4_post_status_check(struct lpfc_
 			bf_get(lpfc_hst_state_port_status, &sta_reg));
 
 	/* Log device information */
-	scratchpad.word0 =  readl(phba->sli4_hba.SCRATCHPADregaddr);
-	lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
-			"2534 Device Info: ChipType=0x%x, SliRev=0x%x, "
-			"FeatureL1=0x%x, FeatureL2=0x%x\n",
-			bf_get(lpfc_scratchpad_chiptype, &scratchpad),
-			bf_get(lpfc_scratchpad_slirev, &scratchpad),
-			bf_get(lpfc_scratchpad_featurelevel1, &scratchpad),
-			bf_get(lpfc_scratchpad_featurelevel2, &scratchpad));
+	phba->sli4_hba.sli_intf.word0 = readl(phba->sli4_hba.SLIINTFregaddr);
+	if (bf_get(lpfc_sli_intf_valid,
+		   &phba->sli4_hba.sli_intf) == LPFC_SLI_INTF_VALID) {
+		lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+				"2534 Device Info: ChipType=0x%x, SliRev=0x%x, "
+				"FeatureL1=0x%x, FeatureL2=0x%x\n",
+				bf_get(lpfc_sli_intf_sli_family,
+				       &phba->sli4_hba.sli_intf),
+				bf_get(lpfc_sli_intf_slirev,
+				       &phba->sli4_hba.sli_intf),
+				bf_get(lpfc_sli_intf_featurelevel1,
+				       &phba->sli4_hba.sli_intf),
+				bf_get(lpfc_sli_intf_featurelevel2,
+				       &phba->sli4_hba.sli_intf));
+	}
 	phba->sli4_hba.ue_mask_lo = readl(phba->sli4_hba.UEMASKLOregaddr);
 	phba->sli4_hba.ue_mask_hi = readl(phba->sli4_hba.UEMASKHIregaddr);
 	/* With uncoverable error, log the error message and return error */
@@ -4907,8 +4949,8 @@ lpfc_sli4_bar0_register_memmap(struct lp
 					LPFC_UE_MASK_LO;
 	phba->sli4_hba.UEMASKHIregaddr = phba->sli4_hba.conf_regs_memmap_p +
 					LPFC_UE_MASK_HI;
-	phba->sli4_hba.SCRATCHPADregaddr = phba->sli4_hba.conf_regs_memmap_p +
-					LPFC_SCRATCHPAD;
+	phba->sli4_hba.SLIINTFregaddr = phba->sli4_hba.conf_regs_memmap_p +
+					LPFC_SLI_INTF;
 }
 
 /**
@@ -6981,6 +7023,73 @@ lpfc_sli4_hba_unset(struct lpfc_hba *phb
 	phba->pport->work_port_events = 0;
 }
 
+ /**
+ * lpfc_pc_sli4_params_get - Get the SLI4_PARAMS port capabilities.
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
+lpfc_pc_sli4_params_get(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
+{
+	int rc;
+	struct lpfc_mqe *mqe;
+	struct lpfc_pc_sli4_params *sli4_params;
+	uint32_t mbox_tmo;
+
+	rc = 0;
+	mqe = &mboxq->u.mqe;
+
+	/* Read the port's SLI4 Parameters port capabilities */
+	lpfc_sli4_params(mboxq);
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_PORT_CAPABILITIES);
+		rc = lpfc_sli_issue_mbox_wait(phba, mboxq, mbox_tmo);
+	}
+
+	if (unlikely(rc))
+		return 1;
+
+	sli4_params = &phba->sli4_hba.pc_sli4_params;
+	sli4_params->if_type = bf_get(if_type, &mqe->un.sli4_params);
+	sli4_params->sli_rev = bf_get(sli_rev, &mqe->un.sli4_params);
+	sli4_params->sli_family = bf_get(sli_family, &mqe->un.sli4_params);
+	sli4_params->featurelevel_1 = bf_get(featurelevel_1,
+					     &mqe->un.sli4_params);
+	sli4_params->featurelevel_2 = bf_get(featurelevel_2,
+					     &mqe->un.sli4_params);
+	sli4_params->proto_types = mqe->un.sli4_params.word3;
+	sli4_params->sge_supp_len = mqe->un.sli4_params.sge_supp_len;
+	sli4_params->if_page_sz = bf_get(if_page_sz, &mqe->un.sli4_params);
+	sli4_params->rq_db_window = bf_get(rq_db_window, &mqe->un.sli4_params);
+	sli4_params->loopbk_scope = bf_get(loopbk_scope, &mqe->un.sli4_params);
+	sli4_params->eq_pages_max = bf_get(eq_pages, &mqe->un.sli4_params);
+	sli4_params->eqe_size = bf_get(eqe_size, &mqe->un.sli4_params);
+	sli4_params->cq_pages_max = bf_get(cq_pages, &mqe->un.sli4_params);
+	sli4_params->cqe_size = bf_get(cqe_size, &mqe->un.sli4_params);
+	sli4_params->mq_pages_max = bf_get(mq_pages, &mqe->un.sli4_params);
+	sli4_params->mqe_size = bf_get(mqe_size, &mqe->un.sli4_params);
+	sli4_params->mq_elem_cnt = bf_get(mq_elem_cnt, &mqe->un.sli4_params);
+	sli4_params->wq_pages_max = bf_get(wq_pages, &mqe->un.sli4_params);
+	sli4_params->wqe_size = bf_get(wqe_size, &mqe->un.sli4_params);
+	sli4_params->rq_pages_max = bf_get(rq_pages, &mqe->un.sli4_params);
+	sli4_params->rqe_size = bf_get(rqe_size, &mqe->un.sli4_params);
+	sli4_params->hdr_pages_max = bf_get(hdr_pages, &mqe->un.sli4_params);
+	sli4_params->hdr_size = bf_get(hdr_size, &mqe->un.sli4_params);
+	sli4_params->hdr_pp_align = bf_get(hdr_pp_align, &mqe->un.sli4_params);
+	sli4_params->sgl_pages_max = bf_get(sgl_pages, &mqe->un.sli4_params);
+	sli4_params->sgl_pp_align = bf_get(sgl_pp_align, &mqe->un.sli4_params);
+	return rc;
+}
+
 /**
  * lpfc_pci_probe_one_s3 - PCI probe func to reg SLI-3 device to PCI subsystem.
  * @pdev: pointer to PCI device
@@ -8053,11 +8162,11 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	int rc;
 	struct lpfc_sli_intf intf;
 
-	if (pci_read_config_dword(pdev, LPFC_SLIREV_CONF_WORD, &intf.word0))
+	if (pci_read_config_dword(pdev, LPFC_SLI_INTF, &intf.word0))
 		return -ENODEV;
 
 	if ((bf_get(lpfc_sli_intf_valid, &intf) == LPFC_SLI_INTF_VALID) &&
-		(bf_get(lpfc_sli_intf_rev, &intf) == LPFC_SLIREV_CONF_SLI4))
+	    (bf_get(lpfc_sli_intf_slirev, &intf) == LPFC_SLI_INTF_REV_SLI4))
 		rc = lpfc_pci_probe_one_s4(pdev, pid);
 	else
 		rc = lpfc_pci_probe_one_s3(pdev, pid);
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2010-02-12 10:52:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2010-02-12 10:53:08.000000000 -0500
@@ -2052,3 +2052,41 @@ lpfc_resume_rpi(struct lpfcMboxq *mbox, 
 	bf_set(lpfc_resume_rpi_ii, resume_rpi, RESUME_INDEX_RPI);
 	resume_rpi->event_tag = ndlp->phba->fc_eventTag;
 }
+
+/**
+ * lpfc_supported_pages - Initialize the PORT_CAPABILITIES supported pages
+ *                        mailbox command.
+ * @mbox: pointer to lpfc mbox command to initialize.
+ *
+ * The PORT_CAPABILITIES supported pages mailbox command is issued to
+ * retrieve the particular feature pages supported by the port.
+ **/
+void
+lpfc_supported_pages(struct lpfcMboxq *mbox)
+{
+	struct lpfc_mbx_supp_pages *supp_pages;
+
+	memset(mbox, 0, sizeof(*mbox));
+	supp_pages = &mbox->u.mqe.un.supp_pages;
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_PORT_CAPABILITIES);
+	bf_set(cpn, supp_pages, LPFC_SUPP_PAGES);
+}
+
+/**
+ * lpfc_sli4_params - Initialize the PORT_CAPABILITIES SLI4 Params
+ *                    mailbox command.
+ * @mbox: pointer to lpfc mbox command to initialize.
+ *
+ * The PORT_CAPABILITIES SLI4 parameters mailbox command is issued to
+ * retrieve the particular SLI4 features supported by the port.
+ **/
+void
+lpfc_sli4_params(struct lpfcMboxq *mbox)
+{
+	struct lpfc_mbx_sli4_params *sli4_params;
+
+	memset(mbox, 0, sizeof(*mbox));
+	sli4_params = &mbox->u.mqe.un.sli4_params;
+	bf_set(lpfc_mqe_command, &mbox->u.mqe, MBX_PORT_CAPABILITIES);
+	bf_set(cpn, sli4_params, LPFC_SLI4_PARAMETERS);
+}
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-11 17:26:54.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2010-02-12 10:53:08.000000000 -0500
@@ -798,19 +798,17 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *
 		 */
 		sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_cmd));
 		sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_cmd));
-		bf_set(lpfc_sli4_sge_len, sgl, sizeof(struct fcp_cmnd));
 		bf_set(lpfc_sli4_sge_last, sgl, 0);
 		sgl->word2 = cpu_to_le32(sgl->word2);
-		sgl->word3 = cpu_to_le32(sgl->word3);
+		sgl->sge_len = cpu_to_le32(sizeof(struct fcp_cmnd));
 		sgl++;
 
 		/* Setup the physical region for the FCP RSP */
 		sgl->addr_hi = cpu_to_le32(putPaddrHigh(pdma_phys_fcp_rsp));
 		sgl->addr_lo = cpu_to_le32(putPaddrLow(pdma_phys_fcp_rsp));
-		bf_set(lpfc_sli4_sge_len, sgl, sizeof(struct fcp_rsp));
 		bf_set(lpfc_sli4_sge_last, sgl, 1);
 		sgl->word2 = cpu_to_le32(sgl->word2);
-		sgl->word3 = cpu_to_le32(sgl->word3);
+		sgl->sge_len = cpu_to_le32(sizeof(struct fcp_rsp));
 
 		/*
 		 * Since the IOCB for the FCP I/O is built into this
@@ -1872,7 +1870,6 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 		scsi_for_each_sg(scsi_cmnd, sgel, nseg, num_bde) {
 			physaddr = sg_dma_address(sgel);
 			dma_len = sg_dma_len(sgel);
-			bf_set(lpfc_sli4_sge_len, sgl, sg_dma_len(sgel));
 			sgl->addr_lo = cpu_to_le32(putPaddrLow(physaddr));
 			sgl->addr_hi = cpu_to_le32(putPaddrHigh(physaddr));
 			if ((num_bde + 1) == nseg)
@@ -1881,7 +1878,7 @@ lpfc_scsi_prep_dma_buf_s4(struct lpfc_hb
 				bf_set(lpfc_sli4_sge_last, sgl, 0);
 			bf_set(lpfc_sli4_sge_offset, sgl, dma_offset);
 			sgl->word2 = cpu_to_le32(sgl->word2);
-			sgl->word3 = cpu_to_le32(sgl->word3);
+			sgl->sge_len = cpu_to_le32(dma_len);
 			dma_offset += dma_len;
 			sgl++;
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli4.h b/drivers/scsi/lpfc/lpfc_sli4.h
--- a/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-12 10:52:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli4.h	2010-02-12 10:53:08.000000000 -0500
@@ -264,7 +264,10 @@ struct lpfc_bmbx {
 #define SLI4_CT_VFI 2
 #define SLI4_CT_FCFI 3
 
-#define LPFC_SLI4_MAX_SEGMENT_SIZE 0x10000
+#define LPFC_SLI4_FL1_MAX_SEGMENT_SIZE	0x10000
+#define LPFC_SLI4_FL1_MAX_BUF_SIZE	0X2000
+#define LPFC_SLI4_MIN_BUF_SIZE		0x400
+#define LPFC_SLI4_MAX_BUF_SIZE		0x20000
 
 /*
  * SLI4 specific data structures
@@ -298,6 +301,42 @@ struct lpfc_fcp_eq_hdl {
 	struct lpfc_hba *phba;
 };
 
+/* Port Capabilities for SLI4 Parameters */
+struct lpfc_pc_sli4_params {
+	uint32_t supported;
+	uint32_t if_type;
+	uint32_t sli_rev;
+	uint32_t sli_family;
+	uint32_t featurelevel_1;
+	uint32_t featurelevel_2;
+	uint32_t proto_types;
+#define LPFC_SLI4_PROTO_FCOE	0x0000001
+#define LPFC_SLI4_PROTO_FC	0x0000002
+#define LPFC_SLI4_PROTO_NIC	0x0000004
+#define LPFC_SLI4_PROTO_ISCSI	0x0000008
+#define LPFC_SLI4_PROTO_RDMA	0x0000010
+	uint32_t sge_supp_len;
+	uint32_t if_page_sz;
+	uint32_t rq_db_window;
+	uint32_t loopbk_scope;
+	uint32_t eq_pages_max;
+	uint32_t eqe_size;
+	uint32_t cq_pages_max;
+	uint32_t cqe_size;
+	uint32_t mq_pages_max;
+	uint32_t mqe_size;
+	uint32_t mq_elem_cnt;
+	uint32_t wq_pages_max;
+	uint32_t wqe_size;
+	uint32_t rq_pages_max;
+	uint32_t rqe_size;
+	uint32_t hdr_pages_max;
+	uint32_t hdr_size;
+	uint32_t hdr_pp_align;
+	uint32_t sgl_pages_max;
+	uint32_t sgl_pp_align;
+};
+
 /* SLI4 HBA data structure entries */
 struct lpfc_sli4_hba {
 	void __iomem *conf_regs_memmap_p; /* Kernel memory mapped address for
@@ -311,7 +350,7 @@ struct lpfc_sli4_hba {
 	void __iomem *UERRHIregaddr; /* Address to UERR_STATUS_HI register */
 	void __iomem *UEMASKLOregaddr; /* Address to UE_MASK_LO register */
 	void __iomem *UEMASKHIregaddr; /* Address to UE_MASK_HI register */
-	void __iomem *SCRATCHPADregaddr; /* Address to scratchpad register */
+	void __iomem *SLIINTFregaddr; /* Address to SLI_INTF register */
 	/* BAR1 FCoE function CSR register memory map */
 	void __iomem *STAregaddr;    /* Address to HST_STATE register */
 	void __iomem *ISRregaddr;    /* Address to HST_ISR register */
@@ -326,6 +365,8 @@ struct lpfc_sli4_hba {
 
 	uint32_t ue_mask_lo;
 	uint32_t ue_mask_hi;
+	struct lpfc_register sli_intf;
+	struct lpfc_pc_sli4_params pc_sli4_params;
 	struct msix_entry *msix_entries;
 	uint32_t cfg_eqn;
 	struct lpfc_fcp_eq_hdl *fcp_eq_hdl; /* FCP per-WQ handle */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2010-02-12 10:52:43.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2010-02-12 10:53:08.000000000 -0500
@@ -5739,19 +5739,19 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 
 		for (i = 0; i < numBdes; i++) {
 			/* Should already be byte swapped. */
-			sgl->addr_hi =  bpl->addrHigh;
-			sgl->addr_lo =  bpl->addrLow;
-			/* swap the size field back to the cpu so we
-			 * can assign it to the sgl.
-			 */
-			bde.tus.w  = le32_to_cpu(bpl->tus.w);
-			bf_set(lpfc_sli4_sge_len, sgl, bde.tus.f.bdeSize);
+			sgl->addr_hi = bpl->addrHigh;
+			sgl->addr_lo = bpl->addrLow;
+
 			if ((i+1) == numBdes)
 				bf_set(lpfc_sli4_sge_last, sgl, 1);
 			else
 				bf_set(lpfc_sli4_sge_last, sgl, 0);
 			sgl->word2 = cpu_to_le32(sgl->word2);
-			sgl->word3 = cpu_to_le32(sgl->word3);
+			/* swap the size field back to the cpu so we
+			 * can assign it to the sgl.
+			 */
+			bde.tus.w = le32_to_cpu(bpl->tus.w);
+			sgl->sge_len = cpu_to_le32(bde.tus.f.bdeSize);
 			bpl++;
 			sgl++;
 		}
@@ -5764,11 +5764,10 @@ lpfc_sli4_bpl2sgl(struct lpfc_hba *phba,
 				cpu_to_le32(icmd->un.genreq64.bdl.addrHigh);
 			sgl->addr_lo =
 				cpu_to_le32(icmd->un.genreq64.bdl.addrLow);
-			bf_set(lpfc_sli4_sge_len, sgl,
-				icmd->un.genreq64.bdl.bdeSize);
 			bf_set(lpfc_sli4_sge_last, sgl, 1);
 			sgl->word2 = cpu_to_le32(sgl->word2);
-			sgl->word3 = cpu_to_le32(sgl->word3);
+			sgl->sge_len =
+				cpu_to_le32(icmd->un.genreq64.bdl.bdeSize);
 	}
 	return sglq->sli4_xritag;
 }
@@ -8934,8 +8933,7 @@ lpfc_sli4_sp_handle_eqe(struct lpfc_hba 
 	int ecount = 0;
 	uint16_t cqid;
 
-	if (bf_get(lpfc_eqe_major_code, eqe) != 0 ||
-	    bf_get(lpfc_eqe_minor_code, eqe) != 0) {
+	if (bf_get(lpfc_eqe_major_code, eqe) != 0) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0359 Not a valid slow-path completion "
 				"event: majorcode=x%x, minorcode=x%x\n",
@@ -9167,8 +9165,7 @@ lpfc_sli4_fp_handle_eqe(struct lpfc_hba 
 	uint16_t cqid;
 	int ecount = 0;
 
-	if (unlikely(bf_get(lpfc_eqe_major_code, eqe) != 0) ||
-	    unlikely(bf_get(lpfc_eqe_minor_code, eqe) != 0)) {
+	if (unlikely(bf_get(lpfc_eqe_major_code, eqe) != 0)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"0366 Not a valid fast-path completion "
 				"event: majorcode=x%x, minorcode=x%x\n",


