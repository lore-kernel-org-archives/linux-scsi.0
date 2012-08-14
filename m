From: James Smart <james.smart@emulex.com>
Subject: [PATCH 02/12] lpfc 8.3.34: Add SLI-4 V1 Capacity and Resource
 Descriptor support
Date: Tue, 14 Aug 2012 14:25:29 -0400
Message-ID: <1344968729.4432.17.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:26692 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2HNSZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:25:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add SLI-4 V1 Capacity and Resource Descriptor support 


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |   17 ++++++++++++++++-
 lpfc_init.c |   25 +++++++++++++++----------
 2 files changed, 31 insertions(+), 11 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-08-11 12:18:40.442937168 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-08-11 12:24:51.631924276 -0400
@@ -2573,7 +2573,7 @@ struct lpfc_mbx_get_sli4_parameters {
 };
 
 struct lpfc_rscr_desc_generic {
-#define LPFC_RSRC_DESC_WSIZE			18
+#define LPFC_RSRC_DESC_WSIZE			22
 	uint32_t desc[LPFC_RSRC_DESC_WSIZE];
 };
 
@@ -2583,6 +2583,9 @@ struct lpfc_rsrc_desc_pcie {
 #define lpfc_rsrc_desc_pcie_type_MASK		0x000000ff
 #define lpfc_rsrc_desc_pcie_type_WORD		word0
 #define LPFC_RSRC_DESC_TYPE_PCIE		0x40
+#define lpfc_rsrc_desc_pcie_length_SHIFT	8
+#define lpfc_rsrc_desc_pcie_length_MASK		0x000000ff
+#define lpfc_rsrc_desc_pcie_length_WORD		word0
 	uint32_t word1;
 #define lpfc_rsrc_desc_pcie_pfnum_SHIFT		0
 #define lpfc_rsrc_desc_pcie_pfnum_MASK		0x000000ff
@@ -2610,6 +2613,12 @@ struct lpfc_rsrc_desc_fcfcoe {
 #define lpfc_rsrc_desc_fcfcoe_type_MASK		0x000000ff
 #define lpfc_rsrc_desc_fcfcoe_type_WORD		word0
 #define LPFC_RSRC_DESC_TYPE_FCFCOE		0x43
+#define lpfc_rsrc_desc_fcfcoe_length_SHIFT	8
+#define lpfc_rsrc_desc_fcfcoe_length_MASK	0x000000ff
+#define lpfc_rsrc_desc_fcfcoe_length_WORD	word0
+#define LPFC_RSRC_DESC_TYPE_FCFCOE_V0_RSVD	0
+#define LPFC_RSRC_DESC_TYPE_FCFCOE_V0_LENGTH	72
+#define LPFC_RSRC_DESC_TYPE_FCFCOE_V1_LENGTH	88
 	uint32_t word1;
 #define lpfc_rsrc_desc_fcfcoe_vfnum_SHIFT	0
 #define lpfc_rsrc_desc_fcfcoe_vfnum_MASK	0x000000ff
@@ -2668,6 +2677,12 @@ struct lpfc_rsrc_desc_fcfcoe {
 #define lpfc_rsrc_desc_fcfcoe_eq_cnt_SHIFT	16
 #define lpfc_rsrc_desc_fcfcoe_eq_cnt_MASK	0x0000ffff
 #define lpfc_rsrc_desc_fcfcoe_eq_cnt_WORD	word13
+/* extended FC/FCoE Resource Descriptor when length = 88 bytes */
+	uint32_t bw_min;
+	uint32_t bw_max;
+	uint32_t iops_min;
+	uint32_t iops_max;
+	uint32_t reserved[4];
 };
 
 struct lpfc_func_cfg {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-08-11 12:18:40.383937171 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-08-11 12:24:51.636924276 -0400
@@ -6299,8 +6299,9 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 	uint32_t shdr_status, shdr_add_status;
 	struct lpfc_mbx_get_func_cfg *get_func_cfg;
 	struct lpfc_rsrc_desc_fcfcoe *desc;
+	char *pdesc_0;
 	uint32_t desc_count;
-	int length, i, rc = 0;
+	int length, i, rc = 0, rc2;
 
 	pmb = (LPFC_MBOXQ_t *) mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	if (!pmb) {
@@ -6412,18 +6413,17 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 			 LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG,
 			 length, LPFC_SLI4_MBX_EMBED);
 
-	rc = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
+	rc2 = lpfc_sli_issue_mbox(phba, pmb, MBX_POLL);
 	shdr = (union lpfc_sli4_cfg_shdr *)
 				&pmb->u.mqe.un.sli4_config.header.cfg_shdr;
 	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
 	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
-	if (rc || shdr_status || shdr_add_status) {
+	if (rc2 || shdr_status || shdr_add_status) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"3026 Mailbox failed , mbxCmd x%x "
 				"GET_FUNCTION_CONFIG, mbxStatus x%x\n",
 				bf_get(lpfc_mqe_command, &pmb->u.mqe),
 				bf_get(lpfc_mqe_status, &pmb->u.mqe));
-		rc = -EIO;
 		goto read_cfg_out;
 	}
 
@@ -6431,11 +6431,18 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 	get_func_cfg = &pmb->u.mqe.un.get_func_cfg;
 	desc_count = get_func_cfg->func_cfg.rsrc_desc_count;
 
+	pdesc_0 = (char *)&get_func_cfg->func_cfg.desc[0];
+	desc = (struct lpfc_rsrc_desc_fcfcoe *)pdesc_0;
+	length = bf_get(lpfc_rsrc_desc_fcfcoe_length, desc);
+	if (length == LPFC_RSRC_DESC_TYPE_FCFCOE_V0_RSVD)
+		length = LPFC_RSRC_DESC_TYPE_FCFCOE_V0_LENGTH;
+	else if (length != LPFC_RSRC_DESC_TYPE_FCFCOE_V1_LENGTH)
+		goto read_cfg_out;
+
 	for (i = 0; i < LPFC_RSRC_DESC_MAX_NUM; i++) {
-		desc = (struct lpfc_rsrc_desc_fcfcoe *)
-			&get_func_cfg->func_cfg.desc[i];
+		desc = (struct lpfc_rsrc_desc_fcfcoe *)(pdesc_0 + length * i);
 		if (LPFC_RSRC_DESC_TYPE_FCFCOE ==
-		    bf_get(lpfc_rsrc_desc_pcie_type, desc)) {
+		    bf_get(lpfc_rsrc_desc_fcfcoe_type, desc)) {
 			phba->sli4_hba.iov.pf_number =
 				bf_get(lpfc_rsrc_desc_fcfcoe_pfnum, desc);
 			phba->sli4_hba.iov.vf_number =
@@ -6449,13 +6456,11 @@ lpfc_sli4_read_config(struct lpfc_hba *p
 				"3027 GET_FUNCTION_CONFIG: pf_number:%d, "
 				"vf_number:%d\n", phba->sli4_hba.iov.pf_number,
 				phba->sli4_hba.iov.vf_number);
-	else {
+	else
 		lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"3028 GET_FUNCTION_CONFIG: failed to find "
 				"Resrouce Descriptor:x%x\n",
 				LPFC_RSRC_DESC_TYPE_FCFCOE);
-		rc = -EIO;
-	}
 
 read_cfg_out:
 	mempool_free(pmb, phba->mbox_mem_pool);



