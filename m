From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/5] lpfc 8.3.23: Miscellaneous fixes
Date: Sat, 16 Apr 2011 11:03:17 -0400
Message-ID: <1302966212.6245.27.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:15975 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754770Ab1DPPDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Apr 2011 11:03:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Miscellaneous fixes

- Do not limit RPI Count to a minimum of 64
- Fix FCFI incorrect on received unsolicited frames.
- Save the FCFI returned in the REG_FCFI mailbox command if it was successful.
- Fixed Vports not sending FDISC after lips.
- Align based on the SLI4_PAGE_SIZE.
- Fixed double byte swap on received RRQ.
- Fixed mask size for the wq_id mask from 0x7F to 0x7FFF.
- Clear FC_FABRIC flag when NPIV LOGO completes (and add a log message).
- Modified driver to skip round robin only when ulpStatus==LOCAL_REJECT
  and word4=SEQUENCE_TIMEOUT to prevent FLOGI to disconnected FCF.
- Don't add rport if driver unloading


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   27 +++++++++++++++++++++------
 lpfc_hbadisc.c |    6 +++++-
 lpfc_hw4.h     |    4 +++-
 lpfc_init.c    |    7 +++++--
 lpfc_mbox.c    |    2 +-
 lpfc_sli.c     |    7 ++++---
 6 files changed, 39 insertions(+), 14 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2011-04-16 08:29:50.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2011-04-16 09:36:49.000000000 -0400
@@ -670,6 +670,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_v
 			 * Driver needs to re-reg VPI in order for f/w
 			 * to update the MAC address.
 			 */
+			lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 			lpfc_register_new_vport(phba, vport, ndlp);
 			return 0;
 	}
@@ -869,8 +870,8 @@ lpfc_cmpl_els_flogi(struct lpfc_hba *phb
 		 */
 		if ((phba->hba_flag & HBA_FIP_SUPPORT) &&
 		    (phba->fcf.fcf_flag & FCF_DISCOVERY) &&
-		    (irsp->ulpStatus != IOSTAT_LOCAL_REJECT) &&
-		    (irsp->un.ulpWord[4] != IOERR_SLI_ABORTED)) {
+		    !((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
+		     (irsp->un.ulpWord[4] == IOERR_SLI_ABORTED))) {
 			lpfc_printf_log(phba, KERN_WARNING, LOG_FIP | LOG_ELS,
 					"2611 FLOGI failed on FCF (x%x), "
 					"status:x%x/x%x, tmo:x%x, perform "
@@ -4107,13 +4108,13 @@ lpfc_els_clear_rrq(struct lpfc_vport *vp
 	pcmd += sizeof(uint32_t);
 	rrq = (struct RRQ *)pcmd;
 	rrq->rrq_exchg = be32_to_cpu(rrq->rrq_exchg);
-	rxid = be16_to_cpu(bf_get(rrq_rxid, rrq));
+	rxid = bf_get(rrq_rxid, rrq);
 
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			"2883 Clear RRQ for SID:x%x OXID:x%x RXID:x%x"
 			" x%x x%x\n",
 			be32_to_cpu(bf_get(rrq_did, rrq)),
-			be16_to_cpu(bf_get(rrq_oxid, rrq)),
+			bf_get(rrq_oxid, rrq),
 			rxid,
 			iocb->iotag, iocb->iocb.ulpContext);
 
@@ -4121,7 +4122,7 @@ lpfc_els_clear_rrq(struct lpfc_vport *vp
 		"Clear RRQ:  did:x%x flg:x%x exchg:x%.08x",
 		ndlp->nlp_DID, ndlp->nlp_flag, rrq->rrq_exchg);
 	if (vport->fc_myDID == be32_to_cpu(bf_get(rrq_did, rrq)))
-		xri = be16_to_cpu(bf_get(rrq_oxid, rrq));
+		xri = bf_get(rrq_oxid, rrq);
 	else
 		xri = rxid;
 	prrq = lpfc_get_active_rrq(vport, xri, ndlp->nlp_DID);
@@ -7290,8 +7291,9 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba 
 	struct lpfc_vport *vport = cmdiocb->vport;
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
-	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
+	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
 
+	ndlp = (struct lpfc_nodelist *)cmdiocb->context1;
 	irsp = &rspiocb->iocb;
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 		"LOGO npiv cmpl:  status:x%x/x%x did:x%x",
@@ -7302,6 +7304,19 @@ lpfc_cmpl_els_npiv_logo(struct lpfc_hba 
 
 	/* Trigger the release of the ndlp after logo */
 	lpfc_nlp_put(ndlp);
+
+	/* NPIV LOGO completes to NPort <nlp_DID> */
+	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+			 "2928 NPIV LOGO completes to NPort x%x "
+			 "Data: x%x x%x x%x x%x\n",
+			 ndlp->nlp_DID, irsp->ulpStatus, irsp->un.ulpWord[4],
+			 irsp->ulpTimeout, vport->num_disc_nodes);
+
+	if (irsp->ulpStatus == IOSTAT_SUCCESS) {
+		spin_lock_irq(shost->host_lock);
+		vport->fc_flag &= ~FC_FABRIC;
+		spin_unlock_irq(shost->host_lock);
+	}
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-04-16 08:29:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2011-04-16 09:36:49.000000000 -0400
@@ -1,7 +1,7 @@
 /*******************************************************************
  * This file is part of the Emulex Linux Device Driver for         *
  * Fibre Channel Host Bus Adapters.                                *
- * Copyright (C) 2004-2009 Emulex.  All rights reserved.           *
+ * Copyright (C) 2004-2011 Emulex.  All rights reserved.           *
  * EMULEX and SLI are trademarks of Emulex.                        *
  * www.emulex.com                                                  *
  * Portions Copyright (C) 2004-2005 Christoph Hellwig              *
@@ -3569,6 +3569,10 @@ lpfc_register_remote_port(struct lpfc_vp
 		"rport add:       did:x%x flg:x%x type x%x",
 		ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_type);
 
+	/* Don't add the remote port if unloading. */
+	if (vport->load_flag & FC_UNLOADING)
+		return;
+
 	ndlp->rport = rport = fc_remote_port_add(shost, 0, &rport_ids);
 	if (!rport || !get_device(&rport->dev)) {
 		dev_printk(KERN_WARNING, &phba->pcidev->dev,
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-03-27 11:03:17.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-04-16 09:35:21.000000000 -0400
@@ -2108,6 +2108,8 @@ struct lpfc_mbx_pc_sli4_params {
 #define sgl_pp_align_WORD			word12
 	uint32_t rsvd_13_63[51];
 };
+#define SLI4_PAGE_ALIGN(addr) (((addr)+((SLI4_PAGE_SIZE)-1)) \
+			       &(~((SLI4_PAGE_SIZE)-1)))
 
 struct lpfc_sli4_parameters {
 	uint32_t word0;
@@ -2524,7 +2526,7 @@ struct wqe_common {
 #define wqe_wqes_WORD         word10
 /* Note that this field overlaps above fields */
 #define wqe_wqid_SHIFT        1
-#define wqe_wqid_MASK         0x0000007f
+#define wqe_wqid_MASK         0x00007fff
 #define wqe_wqid_WORD         word10
 #define wqe_pri_SHIFT         16
 #define wqe_pri_MASK          0x00000007
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-04-16 08:29:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-04-16 09:35:11.000000000 -0400
@@ -4906,6 +4906,7 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
 	uint16_t rpi_limit, curr_rpi_range;
 	struct lpfc_dmabuf *dmabuf;
 	struct lpfc_rpi_hdr *rpi_hdr;
+	uint32_t rpi_count;
 
 	rpi_limit = phba->sli4_hba.max_cfg_param.rpi_base +
 		    phba->sli4_hba.max_cfg_param.max_rpi - 1;
@@ -4920,7 +4921,9 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
 	 * and to allow the full max_rpi range per port.
 	 */
 	if ((curr_rpi_range + (LPFC_RPI_HDR_COUNT - 1)) > rpi_limit)
-		return NULL;
+		rpi_count = rpi_limit - curr_rpi_range;
+	else
+		rpi_count = LPFC_RPI_HDR_COUNT;
 
 	/*
 	 * First allocate the protocol header region for the port.  The
@@ -4961,7 +4964,7 @@ lpfc_sli4_create_rpi_hdr(struct lpfc_hba
 	 * The next_rpi stores the next module-64 rpi value to post
 	 * in any subsequent rpi memory region postings.
 	 */
-	phba->sli4_hba.next_rpi += LPFC_RPI_HDR_COUNT;
+	phba->sli4_hba.next_rpi += rpi_count;
 	spin_unlock_irq(&phba->hbalock);
 	return rpi_hdr;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
--- a/drivers/scsi/lpfc/lpfc_mbox.c	2011-04-16 08:29:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_mbox.c	2011-04-16 09:35:21.000000000 -0400
@@ -1736,7 +1736,7 @@ lpfc_sli4_config(struct lpfc_hba *phba, 
 	}
 
 	/* Setup for the none-embedded mbox command */
-	pcount = (PAGE_ALIGN(length))/SLI4_PAGE_SIZE;
+	pcount = (SLI4_PAGE_ALIGN(length))/SLI4_PAGE_SIZE;
 	pcount = (pcount > LPFC_SLI4_MBX_SGE_MAX_PAGES) ?
 				LPFC_SLI4_MBX_SGE_MAX_PAGES : pcount;
 	/* Allocate record for keeping SGE virtual addresses */
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-04-16 08:29:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-04-16 09:35:21.000000000 -0400
@@ -5018,10 +5018,11 @@ lpfc_sli4_hba_setup(struct lpfc_hba *phb
 		lpfc_reg_fcfi(phba, mboxq);
 		mboxq->vport = phba->pport;
 		rc = lpfc_sli_issue_mbox(phba, mboxq, MBX_POLL);
-		if (rc == MBX_SUCCESS)
-			rc = 0;
-		else
+		if (rc != MBX_SUCCESS)
 			goto out_unset_queue;
+		rc = 0;
+		phba->fcf.fcfi = bf_get(lpfc_reg_fcfi_fcfi,
+					&mboxq->u.mqe.un.reg_fcfi);
 	}
 	/*
 	 * The port is ready, set the host's link state to LINK_DOWN


