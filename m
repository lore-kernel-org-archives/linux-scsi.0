From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/7] lpfc 8.1.5 : Fixed FC protocol violation in handling
	of PRLO.
Date: Sat, 15 Apr 2006 11:53:05 -0400
Message-ID: <1145116385.3795.2.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:39859 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030276AbWDOPxI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 11:53:08 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3FFr7rf011037
	for <linux-scsi@vger.kernel.org>; Sat, 15 Apr 2006 08:53:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed FC protocol violation in handling of PRLO.

Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -465,14 +465,18 @@ lpfc_rcv_padisc(struct lpfc_hba * phba,
 static int
 lpfc_rcv_logo(struct lpfc_hba * phba,
 		      struct lpfc_nodelist * ndlp,
-		      struct lpfc_iocbq *cmdiocb)
+		      struct lpfc_iocbq *cmdiocb,
+		      uint32_t els_cmd)
 {
 	/* Put ndlp on NPR list with 1 sec timeout for plogi, ACC logo */
 	/* Only call LOGO ACC for first LOGO, this avoids sending unnecessary
 	 * PLOGIs during LOGO storms from a device.
 	 */
 	ndlp->nlp_flag |= NLP_LOGO_ACC;
-	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	if (els_cmd == ELS_CMD_PRLO)
+		lpfc_els_rsp_acc(phba, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
+	else
+		lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
 
 	if (!(ndlp->nlp_type & NLP_FABRIC) ||
 		(ndlp->nlp_state == NLP_STE_ADISC_ISSUE)) {
@@ -681,7 +685,7 @@ lpfc_rcv_logo_plogi_issue(struct lpfc_hb
 	/* software abort outstanding PLOGI */
 	lpfc_els_abort(phba, ndlp, 1);
 
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
 
@@ -907,7 +911,7 @@ lpfc_rcv_logo_adisc_issue(struct lpfc_hb
 	/* software abort outstanding ADISC */
 	lpfc_els_abort(phba, ndlp, 0);
 
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
 
@@ -934,7 +938,7 @@ lpfc_rcv_prlo_adisc_issue(struct lpfc_hb
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
 	/* Treat like rcv logo */
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_PRLO);
 	return ndlp->nlp_state;
 }
 
@@ -1056,7 +1060,7 @@ lpfc_rcv_logo_reglogin_issue(struct lpfc
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
 
@@ -1081,7 +1085,7 @@ lpfc_rcv_prlo_reglogin_issue(struct lpfc
 	struct lpfc_iocbq *cmdiocb;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(phba, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
 	return ndlp->nlp_state;
 }
 
@@ -1200,7 +1204,7 @@ lpfc_rcv_logo_prli_issue(struct lpfc_hba
 	/* Software abort outstanding PRLI before sending acc */
 	lpfc_els_abort(phba, ndlp, 1);
 
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
 
@@ -1228,7 +1232,7 @@ lpfc_rcv_prlo_prli_issue(struct lpfc_hba
 	struct lpfc_iocbq *cmdiocb;
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
-	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(phba, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
 	return ndlp->nlp_state;
 }
 
@@ -1371,7 +1375,7 @@ lpfc_rcv_logo_unmap_node(struct lpfc_hba
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
 
@@ -1395,7 +1399,7 @@ lpfc_rcv_prlo_unmap_node(struct lpfc_hba
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
-	lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL, 0);
+	lpfc_els_rsp_acc(phba, ELS_CMD_PRLO, cmdiocb, ndlp, NULL, 0);
 	return ndlp->nlp_state;
 }
 
@@ -1444,7 +1448,7 @@ lpfc_rcv_logo_mapped_node(struct lpfc_hb
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
 
@@ -1476,7 +1480,7 @@ lpfc_rcv_prlo_mapped_node(struct lpfc_hb
 	spin_unlock_irq(phba->host->host_lock);
 
 	/* Treat like rcv logo */
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_PRLO);
 	return ndlp->nlp_state;
 }
 
@@ -1571,7 +1575,7 @@ lpfc_rcv_logo_npr_node(struct lpfc_hba *
 
 	cmdiocb = (struct lpfc_iocbq *) arg;
 
-	lpfc_rcv_logo(phba, ndlp, cmdiocb);
+	lpfc_rcv_logo(phba, ndlp, cmdiocb, ELS_CMD_LOGO);
 	return ndlp->nlp_state;
 }
 
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -449,6 +449,7 @@ struct serv_parm {	/* Structure is in Bi
 #define ELS_CMD_RRQ       0x12000000
 #define ELS_CMD_PRLI      0x20100014
 #define ELS_CMD_PRLO      0x21100014
+#define ELS_CMD_PRLO_ACC  0x02100014
 #define ELS_CMD_PDISC     0x50000000
 #define ELS_CMD_FDISC     0x51000000
 #define ELS_CMD_ADISC     0x52000000
@@ -484,6 +485,7 @@ struct serv_parm {	/* Structure is in Bi
 #define ELS_CMD_RRQ       0x12
 #define ELS_CMD_PRLI      0x14001020
 #define ELS_CMD_PRLO      0x14001021
+#define ELS_CMD_PRLO_ACC  0x14001002
 #define ELS_CMD_PDISC     0x50
 #define ELS_CMD_FDISC     0x51
 #define ELS_CMD_ADISC     0x52
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1913,6 +1913,7 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 	uint8_t *pcmd;
 	uint16_t cmdsize;
 	int rc;
+	ELS_PKT *els_pkt_ptr;
 
 	psli = &phba->sli;
 	pring = &psli->ring[LPFC_ELS_RING];	/* ELS ring */
@@ -1951,6 +1952,23 @@ lpfc_els_rsp_acc(struct lpfc_hba * phba,
 		pcmd += sizeof (uint32_t);
 		memcpy(pcmd, &phba->fc_sparam, sizeof (struct serv_parm));
 		break;
+	case ELS_CMD_PRLO:
+		cmdsize = sizeof (uint32_t) + sizeof (PRLO);
+		elsiocb = lpfc_prep_els_iocb(phba, 0, cmdsize, oldiocb->retry,
+					     ndlp, ndlp->nlp_DID, ELS_CMD_PRLO);
+		if (!elsiocb)
+			return 1;
+
+		icmd = &elsiocb->iocb;
+		icmd->ulpContext = oldcmd->ulpContext; /* Xri */
+		pcmd = (((struct lpfc_dmabuf *) elsiocb->context2)->virt);
+
+		memcpy(pcmd, ((struct lpfc_dmabuf *) oldiocb->context2)->virt,
+		       sizeof (uint32_t) + sizeof (PRLO));
+		*((uint32_t *) (pcmd)) = ELS_CMD_PRLO_ACC;
+		els_pkt_ptr = (ELS_PKT *) pcmd;
+		els_pkt_ptr->un.prlo.acceptRspCode = PRLO_REQ_EXECUTED;
+		break;
 	default:
 		return 1;
 	}


