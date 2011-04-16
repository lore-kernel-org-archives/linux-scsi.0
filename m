From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/5] lpfc 8.3.23: Fixes related to new hardware
Date: Sat, 16 Apr 2011 11:03:33 -0400
Message-ID: <1302966215.6245.28.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15975 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751811Ab1DPPD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2011 11:03:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixes related to new hardware

- Restrict driver to look at BAR2 or BAR4 only for if_type 0.
- Allow SLI4 with FCOE_MODE not set for new SLI4 FC adapters.
- Add Temporary RPI field to the ELS request WQE.
- Do not override CT field in issue_els_flogi for SLI4 IF type 2
- For RQ_CREATE_V2 mbx cmd: fill in the rqe_size and page_size for RQ_CREATE.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c  |   17 +++++++++--------
 lpfc_hw4.h  |   14 +++++++++++++-
 lpfc_init.c |   12 +++++++-----
 lpfc_sli.c  |   25 +++++++++++++++++++------
 4 files changed, 48 insertions(+), 20 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-04-16 09:36:49.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-04-16 09:37:46.000000000 -0400
@@ -1086,14 +1086,15 @@ lpfc_issue_els_flogi(struct lpfc_vport *
 	if (sp->cmn.fcphHigh < FC_PH3)
 		sp->cmn.fcphHigh = FC_PH3;
 
-	if  ((phba->sli_rev == LPFC_SLI_REV4) &&
-	     (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
-	      LPFC_SLI_INTF_IF_TYPE_0)) {
-		elsiocb->iocb.ulpCt_h = ((SLI4_CT_FCFI >> 1) & 1);
-		elsiocb->iocb.ulpCt_l = (SLI4_CT_FCFI & 1);
-		/* FLOGI needs to be 3 for WQE FCFI */
-		/* Set the fcfi to the fcfi we registered with */
-		elsiocb->iocb.ulpContext = phba->fcf.fcfi;
+	if  (phba->sli_rev == LPFC_SLI_REV4) {
+		if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
+		    LPFC_SLI_INTF_IF_TYPE_0) {
+			elsiocb->iocb.ulpCt_h = ((SLI4_CT_FCFI >> 1) & 1);
+			elsiocb->iocb.ulpCt_l = (SLI4_CT_FCFI & 1);
+			/* FLOGI needs to be 3 for WQE FCFI */
+			/* Set the fcfi to the fcfi we registered with */
+			elsiocb->iocb.ulpContext = phba->fcf.fcfi;
+		}
 	} else if (phba->sli3_options & LPFC_SLI3_NPIV_ENABLED) {
 		sp->cmn.request_multiple_Nport = 1;
 		/* For FLOGI, Let FLOGI rsp set the NPortID for VPI 0 */
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-04-16 09:35:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-04-16 09:38:05.000000000 -0400
@@ -1059,6 +1059,11 @@ struct rq_context {
 #define lpfc_rq_context_rqe_size_SHIFT	8		/* Version 1 Only */
 #define lpfc_rq_context_rqe_size_MASK	0x0000000F
 #define lpfc_rq_context_rqe_size_WORD	word0
+#define LPFC_RQE_SIZE_8		2
+#define LPFC_RQE_SIZE_16	3
+#define LPFC_RQE_SIZE_32	4
+#define LPFC_RQE_SIZE_64	5
+#define LPFC_RQE_SIZE_128	6
 #define lpfc_rq_context_page_size_SHIFT	0		/* Version 1 Only */
 #define lpfc_rq_context_page_size_MASK	0x000000FF
 #define lpfc_rq_context_page_size_WORD	word0
@@ -2493,6 +2498,9 @@ struct wqe_common {
 #define wqe_reqtag_SHIFT      0
 #define wqe_reqtag_MASK       0x0000FFFF
 #define wqe_reqtag_WORD       word9
+#define wqe_temp_rpi_SHIFT    16
+#define wqe_temp_rpi_MASK     0x0000FFFF
+#define wqe_temp_rpi_WORD     word9
 #define wqe_rcvoxid_SHIFT     16
 #define wqe_rcvoxid_MASK      0x0000FFFF
 #define wqe_rcvoxid_WORD      word9
@@ -2623,7 +2631,11 @@ struct xmit_els_rsp64_wqe {
 	uint32_t rsvd4;
 	struct wqe_did wqe_dest;
 	struct wqe_common wqe_com; /* words 6-11 */
-	uint32_t rsvd_12_15[4];
+	uint32_t word12;
+#define wqe_rsp_temp_rpi_SHIFT    0
+#define wqe_rsp_temp_rpi_MASK     0x0000FFFF
+#define wqe_rsp_temp_rpi_WORD     word12
+	uint32_t rsvd_13_15[3];
 };
 
 struct xmit_bls_rsp64_wqe {
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-04-16 09:35:11.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-04-16 09:37:46.000000000 -0400
@@ -3209,9 +3209,9 @@ lpfc_sli4_async_link_evt(struct lpfc_hba
 	phba->sli4_hba.link_state.logical_speed =
 			bf_get(lpfc_acqe_logical_link_speed, acqe_link);
 	lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
-			"2900 Async FCoE Link event - Speed:%dGBit duplex:x%x "
-			"LA Type:x%x Port Type:%d Port Number:%d Logical "
-			"speed:%dMbps Fault:%d\n",
+			"2900 Async FC/FCoE Link event - Speed:%dGBit "
+			"duplex:x%x LA Type:x%x Port Type:%d Port Number:%d "
+			"Logical speed:%dMbps Fault:%d\n",
 			phba->sli4_hba.link_state.speed,
 			phba->sli4_hba.link_state.topology,
 			phba->sli4_hba.link_state.status,
@@ -7007,7 +7007,8 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba 
 		lpfc_sli4_bar0_register_memmap(phba, if_type);
 	}
 
-	if (pci_resource_start(pdev, 2)) {
+	if ((if_type == LPFC_SLI_INTF_IF_TYPE_0) &&
+	    (pci_resource_start(pdev, 2))) {
 		/*
 		 * Map SLI4 if type 0 HBA Control Register base to a kernel
 		 * virtual address and setup the registers.
@@ -7024,7 +7025,8 @@ lpfc_sli4_pci_mem_setup(struct lpfc_hba 
 		lpfc_sli4_bar1_register_memmap(phba);
 	}
 
-	if (pci_resource_start(pdev, 4)) {
+	if ((if_type == LPFC_SLI_INTF_IF_TYPE_0) &&
+	    (pci_resource_start(pdev, 4))) {
 		/*
 		 * Map SLI4 if type 0 HBA Doorbell Register base to a kernel
 		 * virtual address and setup the registers.
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-04-16 09:35:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-04-16 09:38:05.000000000 -0400
@@ -4769,8 +4769,7 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 	else
 		phba->hba_flag &= ~HBA_FIP_SUPPORT;
 
-	if (phba->sli_rev != LPFC_SLI_REV4 ||
-	    !(phba->hba_flag & HBA_FCOE_MODE)) {
+	if (phba->sli_rev != LPFC_SLI_REV4) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_MBOX | LOG_SLI,
 			"0376 READ_REV Error. SLI Level %d "
 			"FCoE enabled %d\n",
@@ -6403,6 +6402,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 	uint32_t els_id = LPFC_ELS_ID_DEFAULT;
 	int numBdes, i;
 	struct ulp_bde64 bde;
+	struct lpfc_nodelist *ndlp;
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
@@ -6448,6 +6448,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 
 	switch (iocbq->iocb.ulpCommand) {
 	case CMD_ELS_REQUEST64_CR:
+		ndlp = (struct lpfc_nodelist *)iocbq->context1;
 		if (!iocbq->iocb.ulpLe) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2007 Only Limited Edition cmd Format"
@@ -6473,6 +6474,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 			els_id = ((iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK)
 					>> LPFC_FIP_ELS_ID_SHIFT);
 		}
+		bf_set(wqe_temp_rpi, &wqe->els_req.wqe_com, ndlp->nlp_rpi);
 		bf_set(wqe_els_id, &wqe->els_req.wqe_com, els_id);
 		bf_set(wqe_dbde, &wqe->els_req.wqe_com, 1);
 		bf_set(wqe_iod, &wqe->els_req.wqe_com, LPFC_WQE_IOD_READ);
@@ -6605,6 +6607,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		command_type = OTHER_COMMAND;
 	break;
 	case CMD_XMIT_ELS_RSP64_CX:
+		ndlp = (struct lpfc_nodelist *)iocbq->context1;
 		/* words0-2 BDE memcpy */
 		/* word3 iocb=iotag32 wqe=response_payload_len */
 		wqe->xmit_els_rsp.response_payload_len = xmit_len;
@@ -6627,6 +6630,7 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 		bf_set(wqe_lenloc, &wqe->xmit_els_rsp.wqe_com,
 		       LPFC_WQE_LENLOC_WORD3);
 		bf_set(wqe_ebde_cnt, &wqe->xmit_els_rsp.wqe_com, 0);
+		bf_set(wqe_rsp_temp_rpi, &wqe->xmit_els_rsp, ndlp->nlp_rpi);
 		command_type = OTHER_COMMAND;
 	break;
 	case CMD_CLOSE_XRI_CN:
@@ -10523,8 +10527,8 @@ lpfc_cq_create(struct lpfc_hba *phba, st
 	bf_set(lpfc_mbox_hdr_version, &shdr->request,
 	       phba->sli4_hba.pc_sli4_params.cqv);
 	if (phba->sli4_hba.pc_sli4_params.cqv == LPFC_Q_CREATE_VERSION_2) {
-		bf_set(lpfc_mbx_cq_create_page_size, &cq_create->u.request,
-		       (PAGE_SIZE/SLI4_PAGE_SIZE));
+		/* FW only supports 1. Should be PAGE_SIZE/SLI4_PAGE_SIZE */
+		bf_set(lpfc_mbx_cq_create_page_size, &cq_create->u.request, 1);
 		bf_set(lpfc_cq_eq_id_2, &cq_create->u.request.context,
 		       eq->queue_id);
 	} else {
@@ -10968,6 +10972,12 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 		       &rq_create->u.request.context,
 		       hrq->entry_count);
 		rq_create->u.request.context.buffer_size = LPFC_HDR_BUF_SIZE;
+		bf_set(lpfc_rq_context_rqe_size,
+		       &rq_create->u.request.context,
+		       LPFC_RQE_SIZE_8);
+		bf_set(lpfc_rq_context_page_size,
+		       &rq_create->u.request.context,
+		       (PAGE_SIZE/SLI4_PAGE_SIZE));
 	} else {
 		switch (hrq->entry_count) {
 		default:
@@ -11043,9 +11053,12 @@ lpfc_rq_create(struct lpfc_hba *phba, st
 	       phba->sli4_hba.pc_sli4_params.rqv);
 	if (phba->sli4_hba.pc_sli4_params.rqv == LPFC_Q_CREATE_VERSION_1) {
 		bf_set(lpfc_rq_context_rqe_count_1,
-		       &rq_create->u.request.context,
-		       hrq->entry_count);
+		       &rq_create->u.request.context, hrq->entry_count);
 		rq_create->u.request.context.buffer_size = LPFC_DATA_BUF_SIZE;
+		bf_set(lpfc_rq_context_rqe_size, &rq_create->u.request.context,
+		       LPFC_RQE_SIZE_8);
+		bf_set(lpfc_rq_context_page_size, &rq_create->u.request.context,
+		       (PAGE_SIZE/SLI4_PAGE_SIZE));
 	} else {
 		switch (drq->entry_count) {
 		default:


