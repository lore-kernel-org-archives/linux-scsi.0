From: James.Smart@Emulex.Com
Subject: [PATCH 7 of 12] Update Emulex lpfc driver to rev 8.0.29
Date: Sat, 25 Jun 2005 10:34:27 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F414C@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44990 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261249AbVFYOe3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Jun 2005 10:34:29 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id j5PEYR9P008196
	for <linux-scsi@vger.kernel.org>; Sat, 25 Jun 2005 07:34:28 -0700 (PDT)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix LS_RJT never sent by lpfc_els_unsol_event()

lpfc_els_unsol_event() checks rjt_err to determine is LS_RJT should be
sent.  However, rjt_err was set to LSEXP_NOTHING_ELSE (which is 0) in
cases where an LS_RJT should be sent, so rjt_err was never true.
Change lpfc_els_unsol_event() to set rjt_err to 1 when LS_RJT should
be sent.

Signed-off-by: James Smart <James.Smart@emulex.com>

---

 scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_els.c |   16 ++++++-------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_els.c~lsrjt drivers/scsi/lpfc/lpfc_els.c
--- scsi-misc-2.6-20050620/drivers/scsi/lpfc/lpfc_els.c~lsrjt	2005-06-25 09:42:21.000000000 -0400
+++ scsi-misc-2.6-20050620-jsmart/drivers/scsi/lpfc/lpfc_els.c	2005-06-25 09:42:21.000000000 -0400
@@ -3139,7 +3139,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_PLOGI:
 		phba->fc_stat.elsRcvPLOGI++;
 		if (phba->hba_state < LPFC_DISC_AUTH) {
-			rjt_err = LSEXP_NOTHING_MORE;
+			rjt_err = 1;
 			break;
 		}
 		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_PLOGI);
@@ -3154,7 +3154,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_LOGO:
 		phba->fc_stat.elsRcvLOGO++;
 		if (phba->hba_state < LPFC_DISC_AUTH) {
-			rjt_err = LSEXP_NOTHING_MORE;
+			rjt_err = 1;
 			break;
 		}
 		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_LOGO);
@@ -3162,7 +3162,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_PRLO:
 		phba->fc_stat.elsRcvPRLO++;
 		if (phba->hba_state < LPFC_DISC_AUTH) {
-			rjt_err = LSEXP_NOTHING_MORE;
+			rjt_err = 1;
 			break;
 		}
 		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_PRLO);
@@ -3177,7 +3177,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_ADISC:
 		phba->fc_stat.elsRcvADISC++;
 		if (phba->hba_state < LPFC_DISC_AUTH) {
-			rjt_err = LSEXP_NOTHING_MORE;
+			rjt_err = 1;
 			break;
 		}
 		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_ADISC);
@@ -3185,7 +3185,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_PDISC:
 		phba->fc_stat.elsRcvPDISC++;
 		if (phba->hba_state < LPFC_DISC_AUTH) {
-			rjt_err = LSEXP_NOTHING_MORE;
+			rjt_err = 1;
 			break;
 		}
 		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_PDISC);
@@ -3209,7 +3209,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	case ELS_CMD_PRLI:
 		phba->fc_stat.elsRcvPRLI++;
 		if (phba->hba_state < LPFC_DISC_AUTH) {
-			rjt_err = LSEXP_NOTHING_MORE;
+			rjt_err = 1;
 			break;
 		}
 		lpfc_disc_state_machine(phba, ndlp, elsiocb, NLP_EVT_RCV_PRLI);
@@ -3220,7 +3220,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 		break;
 	default:
 		/* Unsupported ELS command, reject */
-		rjt_err = LSEXP_NOTHING_MORE;
+		rjt_err = 1;
 
 		/* Unknown ELS command <elsCmd> received from NPORT <did> */
 		lpfc_printf_log(phba, KERN_ERR, LOG_ELS,
@@ -3236,7 +3236,7 @@ lpfc_els_unsol_event(struct lpfc_hba * p
 	if (rjt_err) {
 		stat.un.b.lsRjtRsvd0 = 0;
 		stat.un.b.lsRjtRsnCode = LSRJT_UNABLE_TPC;
-		stat.un.b.lsRjtRsnCodeExp = rjt_err;
+		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
 		stat.un.b.vendorUnique = 0;
 		lpfc_els_rsp_reject(phba, stat.un.lsRjtError, elsiocb, ndlp);
 	}
_
