From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 1/6] lpfc 8.3.6 : FCoE Protocol Fixes
Date: Wed, 18 Nov 2009 15:39:16 -0500
Message-ID: <1258576787.29086.14.camel@wookie>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50799 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506AbZKRUkF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 15:40:05 -0500
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id nAIKeBLn012609
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2009 12:40:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


FCoE Protocol fixes.
 - Fixed FIP frame designation for ELS commands.
 - Fix CVL received on Port 1 not processed by driver.
 - Fix Zeroed frame on wire after FLOGI
 - Fix vport keep-alive does not contain the correct WWN.


 Signed-off-by: James Smart <james.smart@emulex.com>

---

 drivers/scsi/lpfc/lpfc.h         |    4 ++--
 drivers/scsi/lpfc/lpfc_els.c     |   21 +++++++++++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c |    8 +++++---
 drivers/scsi/lpfc/lpfc_hw.h      |    6 ++----
 drivers/scsi/lpfc/lpfc_hw4.h     |   10 ++++++++--
 drivers/scsi/lpfc/lpfc_init.c    |    4 ++--
 drivers/scsi/lpfc/lpfc_mbox.c    |    7 +++++++
 drivers/scsi/lpfc/lpfc_sli.c     |   12 ++++++++++--
 drivers/scsi/lpfc/lpfc_sli.h     |    3 ++-
 drivers/scsi/lpfc/lpfc_vport.c   |    2 +-
 10 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index ebeddbe..2fd3e45 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -290,8 +290,8 @@ struct lpfc_vport {
 
 	uint16_t vpi;
 	uint16_t vfi;
-	uint8_t vfi_state;
-#define LPFC_VFI_REGISTERED	0x1
+	uint8_t vpi_state;
+#define LPFC_VPI_REGISTERED	0x1
 
 	uint32_t fc_flag;	/* FC flags */
 /* Several of these flags are HBA centric and should be moved to
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fe0a33c..e9e423f 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -177,9 +177,22 @@ lpfc_prep_els_iocb(struct lpfc_vport *vport, uint8_t expectRsp,
 		((elscmd == ELS_CMD_FLOGI) ||
 		 (elscmd == ELS_CMD_FDISC) ||
 		 (elscmd == ELS_CMD_LOGO)))
-		elsiocb->iocb_flag |= LPFC_FIP_ELS;
+		switch (elscmd) {
+		case ELS_CMD_FLOGI:
+		elsiocb->iocb_flag |= ((ELS_ID_FLOGI << LPFC_FIP_ELS_ID_SHIFT)
+					& LPFC_FIP_ELS_ID_MASK);
+		break;
+		case ELS_CMD_FDISC:
+		elsiocb->iocb_flag |= ((ELS_ID_FDISC << LPFC_FIP_ELS_ID_SHIFT)
+					& LPFC_FIP_ELS_ID_MASK);
+		break;
+		case ELS_CMD_LOGO:
+		elsiocb->iocb_flag |= ((ELS_ID_LOGO << LPFC_FIP_ELS_ID_SHIFT)
+					& LPFC_FIP_ELS_ID_MASK);
+		break;
+		}
 	else
-		elsiocb->iocb_flag &= ~LPFC_FIP_ELS;
+		elsiocb->iocb_flag &= ~LPFC_FIP_ELS_ID_MASK;
 
 	icmd = &elsiocb->iocb;
 
@@ -591,7 +604,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	} else {
 		ndlp->nlp_type |= NLP_FABRIC;
 		lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
-		if (vport->vfi_state & LPFC_VFI_REGISTERED) {
+		if (vport->vpi_state & LPFC_VPI_REGISTERED) {
 			lpfc_start_fdiscs(phba);
 			lpfc_do_scr_ns_plogi(phba, vport);
 		} else
@@ -5401,7 +5414,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 	if (lpfc_els_chk_latt(vport))
 		goto dropit;
 
-	/* Ignore traffic recevied during vport shutdown. */
+	/* Ignore traffic received during vport shutdown. */
 	if (vport->load_flag & FC_UNLOADING)
 		goto dropit;
 
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 20fca3f..3c06aa5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -1798,8 +1798,8 @@ lpfc_mbx_cmpl_reg_vfi(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq)
 		lpfc_vport_set_state(vport, FC_VPORT_FAILED);
 		goto fail_free_mem;
 	}
-	/* Mark the vport has registered with its VFI */
-	vport->vfi_state |= LPFC_VFI_REGISTERED;
+	/* The VPI is implicitly registered when the VFI is registered */
+	vport->vpi_state |= LPFC_VPI_REGISTERED;
 
 	if (vport->port_state == LPFC_FABRIC_CFG_LINK) {
 		lpfc_start_fdiscs(phba);
@@ -2257,6 +2257,7 @@ lpfc_mbx_cmpl_unreg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 				 mb->mbxStatus);
 		break;
 	}
+	vport->vpi_state &= ~LPFC_VPI_REGISTERED;
 	vport->unreg_vpi_cmpl = VPORT_OK;
 	mempool_free(pmb, phba->mbox_mem_pool);
 	/*
@@ -2314,6 +2315,7 @@ lpfc_mbx_cmpl_reg_vpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 		goto out;
 	}
 
+	vport->vpi_state |= LPFC_VPI_REGISTERED;
 	vport->num_disc_nodes = 0;
 	/* go thru NPR list and issue ELS PLOGIs */
 	if (vport->fc_npr_cnt)
@@ -4464,7 +4466,7 @@ lpfc_unregister_unused_fcf(struct lpfc_hba *phba)
 		for (i = 0; i <= phba->max_vports && vports[i] != NULL; i++) {
 			lpfc_mbx_unreg_vpi(vports[i]);
 			vports[i]->fc_flag |= FC_VPORT_NEEDS_REG_VPI;
-			vports[i]->vfi_state &= ~LPFC_VFI_REGISTERED;
+			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
 		}
 	lpfc_destroy_vport_work_array(phba, vports);
 
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 8274f99..7070c77 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -2293,8 +2293,7 @@ typedef struct {
 	uint32_t rsvd1;
 	uint32_t rsvd2:8;
 	uint32_t sid:24;
-	uint32_t rsvd3;
-	uint32_t rsvd4;
+	uint32_t wwn[2];
 	uint32_t rsvd5;
 	uint16_t vfi;
 	uint16_t vpi;
@@ -2302,8 +2301,7 @@ typedef struct {
 	uint32_t rsvd1;
 	uint32_t sid:24;
 	uint32_t rsvd2:8;
-	uint32_t rsvd3;
-	uint32_t rsvd4;
+	uint32_t wwn[2];
 	uint32_t rsvd5;
 	uint16_t vpi;
 	uint16_t vfi;
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 4f03f1d..95f8b4e 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -453,6 +453,13 @@ struct lpfc_wqe_generic{
 #define lpfc_wqe_gen_wqec_SHIFT		7
 #define lpfc_wqe_gen_wqec_MASK		0x00000001
 #define lpfc_wqe_gen_wqec_WORD		word11
+#define ELS_ID_FLOGI 3
+#define ELS_ID_FDISC 2
+#define ELS_ID_LOGO  1
+#define ELS_ID_DEFAULT 0
+#define lpfc_wqe_gen_els_id_SHIFT	4
+#define lpfc_wqe_gen_els_id_MASK	0x00000003
+#define lpfc_wqe_gen_els_id_WORD	word11
 #define lpfc_wqe_gen_cmd_type_SHIFT	0
 #define lpfc_wqe_gen_cmd_type_MASK	0x0000000F
 #define lpfc_wqe_gen_cmd_type_WORD	word11
@@ -1395,8 +1402,7 @@ struct lpfc_mbx_reg_vfi {
 #define lpfc_reg_vfi_fcfi_SHIFT		0
 #define lpfc_reg_vfi_fcfi_MASK		0x0000FFFF
 #define lpfc_reg_vfi_fcfi_WORD		word2
-	uint32_t word3_rsvd;
-	uint32_t word4_rsvd;
+	uint32_t wwn[2];
 	struct ulp_bde64 bde;
 	uint32_t word8_rsvd;
 	uint32_t word9_rsvd;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a6400a3..d0c4030 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -2229,7 +2229,7 @@ lpfc_offline_prep(struct lpfc_hba * phba)
 
 			if (vports[i]->load_flag & FC_UNLOADING)
 				continue;
-			vports[i]->vfi_state &= ~LPFC_VFI_REGISTERED;
+			vports[i]->vpi_state &= ~LPFC_VPI_REGISTERED;
 			shost =	lpfc_shost_from_vport(vports[i]);
 			list_for_each_entry_safe(ndlp, next_ndlp,
 						 &vports[i]->fc_nodes,
@@ -3047,7 +3047,7 @@ lpfc_sli4_async_fcoe_evt(struct lpfc_hba *phba,
 			"2718 Clear Virtual Link Received for VPI 0x%x"
 			" tag 0x%x\n", acqe_fcoe->index, acqe_fcoe->event_tag);
 		vport = lpfc_find_vport_by_vpid(phba,
-				acqe_fcoe->index /*- phba->vpi_base*/);
+				acqe_fcoe->index - phba->vpi_base);
 		if (!vport)
 			break;
 		ndlp = lpfc_findnode_did(vport, Fabric_DID);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 51c9a1f..a9afd8b 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -820,6 +820,10 @@ lpfc_reg_vpi(struct lpfc_vport *vport, LPFC_MBOXQ_t *pmb)
 	mb->un.varRegVpi.vpi = vport->vpi + vport->phba->vpi_base;
 	mb->un.varRegVpi.sid = vport->fc_myDID;
 	mb->un.varRegVpi.vfi = vport->vfi + vport->phba->vfi_base;
+	memcpy(mb->un.varRegVpi.wwn, &vport->fc_portname,
+	       sizeof(struct lpfc_name));
+	mb->un.varRegVpi.wwn[0] = cpu_to_le32(mb->un.varRegVpi.wwn[0]);
+	mb->un.varRegVpi.wwn[1] = cpu_to_le32(mb->un.varRegVpi.wwn[1]);
 
 	mb->mbxCommand = MBX_REG_VPI;
 	mb->mbxOwner = OWN_HOST;
@@ -1818,6 +1822,9 @@ lpfc_reg_vfi(struct lpfcMboxq *mbox, struct lpfc_vport *vport, dma_addr_t phys)
 	bf_set(lpfc_reg_vfi_vfi, reg_vfi, vport->vfi + vport->phba->vfi_base);
 	bf_set(lpfc_reg_vfi_fcfi, reg_vfi, vport->phba->fcf.fcfi);
 	bf_set(lpfc_reg_vfi_vpi, reg_vfi, vport->vpi + vport->phba->vpi_base);
+	memcpy(reg_vfi->wwn, &vport->fc_portname, sizeof(struct lpfc_name));
+	reg_vfi->wwn[0] = cpu_to_le32(reg_vfi->wwn[0]);
+	reg_vfi->wwn[1] = cpu_to_le32(reg_vfi->wwn[1]);
 	reg_vfi->bde.addrHigh = putPaddrHigh(phys);
 	reg_vfi->bde.addrLow = putPaddrLow(phys);
 	reg_vfi->bde.tus.f.bdeSize = sizeof(vport->fc_sparam);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c4b19d0..ce0a1a1 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -5756,12 +5756,13 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 	uint8_t cmnd;
 	uint16_t xritag;
 	struct ulp_bde64 *bpl = NULL;
+	uint32_t els_id = ELS_ID_DEFAULT;
 
 	fip = phba->hba_flag & HBA_FIP_SUPPORT;
 	/* The fcp commands will set command type */
 	if (iocbq->iocb_flag &  LPFC_IO_FCP)
 		command_type = FCP_COMMAND;
-	else if (fip && (iocbq->iocb_flag & LPFC_FIP_ELS))
+	else if (fip && (iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK))
 		command_type = ELS_COMMAND_FIP;
 	else
 		command_type = ELS_COMMAND_NON_FIP;
@@ -5822,6 +5823,13 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba, struct lpfc_iocbq *iocbq,
 		bf_set(lpfc_wqe_gen_ct, &wqe->generic, ct);
 		bf_set(lpfc_wqe_gen_pu, &wqe->generic, 0);
 		/* CCP CCPE PV PRI in word10 were set in the memcpy */
+
+		if (command_type == ELS_COMMAND_FIP) {
+			els_id = ((iocbq->iocb_flag & LPFC_FIP_ELS_ID_MASK)
+					>> LPFC_FIP_ELS_ID_SHIFT);
+		}
+		bf_set(lpfc_wqe_gen_els_id, &wqe->generic, els_id);
+
 	break;
 	case CMD_XMIT_SEQUENCE64_CR:
 		/* word3 iocb=io_tag32 wqe=payload_offset */
@@ -11282,7 +11290,7 @@ lpfc_sli4_handle_received_buffer(struct lpfc_hba *phba,
 	}
 	fcfi = bf_get(lpfc_rcqe_fcf_id, &dmabuf->cq_event.cqe.rcqe_cmpl);
 	vport = lpfc_fc_frame_to_vport(phba, fc_hdr, fcfi);
-	if (!vport) {
+	if (!vport || !(vport->vpi_state & LPFC_VPI_REGISTERED)) {
 		/* throw out the frame */
 		lpfc_in_buf_free(phba, &dmabuf->dbuf);
 		return;
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 7b12663..174dcda 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -60,7 +60,8 @@ struct lpfc_iocbq {
 #define LPFC_DRIVER_ABORTED	8	/* driver aborted this request */
 #define LPFC_IO_FABRIC		0x10	/* Iocb send using fabric scheduler */
 #define LPFC_DELAY_MEM_FREE	0x20    /* Defer free'ing of FC data */
-#define LPFC_FIP_ELS		0x40
+#define LPFC_FIP_ELS_ID_MASK	0xc0	/* ELS_ID range 0-3 */
+#define LPFC_FIP_ELS_ID_SHIFT	6
 
 	uint8_t abort_count;
 	uint8_t rsvd2;
diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index 606efa7..096d178 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -389,7 +389,7 @@ lpfc_vport_create(struct fc_vport *fc_vport, bool disable)
 	 * by the port.
 	 */
 	if ((phba->sli_rev == LPFC_SLI_REV4) &&
-		(pport->vfi_state & LPFC_VFI_REGISTERED)) {
+	    (pport->vpi_state & LPFC_VPI_REGISTERED)) {
 		rc = lpfc_sli4_init_vpi(phba, vpi);
 		if (rc) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_VPORT,
-- 
1.6.0.6



