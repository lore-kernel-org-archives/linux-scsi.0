From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/21] lpfc: Fix to handle PLOGI when already logged in
Date: Fri, 3 Apr 2015 17:11:12 -0400
Message-ID: <1428095472.6933.32.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:1259 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbbDCVLf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Apr 2015 17:11:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix to handle PLOGI when already logged in

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 5cc1103..3d93363 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -276,6 +276,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	struct Scsi_Host   *shost = lpfc_shost_from_vport(vport);
 	struct lpfc_hba    *phba = vport->phba;
 	struct lpfc_dmabuf *pcmd;
+	uint64_t nlp_portwwn = 0;
 	uint32_t *lp;
 	IOCB_t *icmd;
 	struct serv_parm *sp;
@@ -332,6 +333,8 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 			NULL);
 		return 0;
 	}
+
+	nlp_portwwn = wwn_to_u64(ndlp->nlp_portname.u.wwn);
 	if ((lpfc_check_sparm(vport, ndlp, sp, CLASS3, 0) == 0)) {
 		/* Reject this request because invalid parameters */
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
@@ -367,7 +370,7 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	ndlp->nlp_maxframe =
 		((sp->cmn.bbRcvSizeMsb & 0x0F) << 8) | sp->cmn.bbRcvSizeLsb;
 
-	/* no need to reg_login if we are already in one of these states */
+	/* if already logged in, do implicit logout */
 	switch (ndlp->nlp_state) {
 	case  NLP_STE_NPR_NODE:
 		if (!(ndlp->nlp_flag & NLP_NPR_ADISC))
@@ -376,8 +379,26 @@ lpfc_rcv_plogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	case  NLP_STE_PRLI_ISSUE:
 	case  NLP_STE_UNMAPPED_NODE:
 	case  NLP_STE_MAPPED_NODE:
-		lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
-		return 1;
+		/* lpfc_plogi_confirm_nport skips fabric did, handle it here */
+		if (!(ndlp->nlp_type & NLP_FABRIC)) {
+			lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb,
+					 ndlp, NULL);
+			return 1;
+		}
+		if (nlp_portwwn != 0 &&
+		    nlp_portwwn != wwn_to_u64(sp->portName.u.wwn))
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
+					 "0143 PLOGI recv'd from DID: x%x "
+					 "WWPN changed: old %llx new %llx\n",
+					 ndlp->nlp_DID,
+					 (unsigned long long)nlp_portwwn,
+					 (unsigned long long)
+					 wwn_to_u64(sp->portName.u.wwn));
+
+		ndlp->nlp_prev_state = ndlp->nlp_state;
+		/* rport needs to be unregistered first */
+		lpfc_nlp_set_state(vport, ndlp, NLP_STE_NPR_NODE);
+		break;
 	}
 
 	/* Check for Nport to NPort pt2pt protocol */
-- 
1.7.11.7




