From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/11] lpfc 8.3.37: Fixed ELS_REC received on the unsolicited
 receive queue
Date: Thu, 3 Jan 2013 15:43:11 -0500
Message-ID: <1357245791.2628.16.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:50071 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3ACUs5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jan 2013 15:48:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed not properly handle ELS_REC received on the unsolicited receive queue


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c |   18 ++++++++++++++++--
 lpfc_hw.h  |    2 ++
 2 files changed, 18 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-12-12 13:32:10.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2013-01-02 13:13:02.680087643 -0500
@@ -6517,7 +6517,8 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	struct lpfc_nodelist *ndlp;
 	struct ls_rjt stat;
 	uint32_t *payload;
-	uint32_t cmd, did, newnode, rjt_err = 0;
+	uint32_t cmd, did, newnode;
+	uint8_t rjt_exp, rjt_err = 0;
 	IOCB_t *icmd = &elsiocb->iocb;
 
 	if (!vport || !(elsiocb->context2))
@@ -6606,12 +6607,14 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		/* If Nport discovery is delayed, reject PLOGIs */
 		if (vport->fc_flag & FC_DISC_DELAYED) {
 			rjt_err = LSRJT_UNABLE_TPC;
+			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
 		}
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			if (!(phba->pport->fc_flag & FC_PT2PT) ||
 				(phba->pport->fc_flag & FC_PT2PT_PLOGI)) {
 				rjt_err = LSRJT_UNABLE_TPC;
+				rjt_exp = LSEXP_NOTHING_MORE;
 				break;
 			}
 			/* We get here, and drop thru, if we are PT2PT with
@@ -6648,6 +6651,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		lpfc_send_els_event(vport, ndlp, payload);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
+			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb, NLP_EVT_RCV_LOGO);
@@ -6661,6 +6665,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		lpfc_send_els_event(vport, ndlp, payload);
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
+			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb, NLP_EVT_RCV_PRLO);
@@ -6680,6 +6685,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		phba->fc_stat.elsRcvADISC++;
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
+			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb,
@@ -6693,6 +6699,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		phba->fc_stat.elsRcvPDISC++;
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
+			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb,
@@ -6730,6 +6737,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		phba->fc_stat.elsRcvPRLI++;
 		if (vport->port_state < LPFC_DISC_AUTH) {
 			rjt_err = LSRJT_UNABLE_TPC;
+			rjt_exp = LSEXP_NOTHING_MORE;
 			break;
 		}
 		lpfc_disc_state_machine(vport, ndlp, elsiocb, NLP_EVT_RCV_PRLI);
@@ -6813,6 +6821,11 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 		if (newnode)
 			lpfc_nlp_put(ndlp);
 		break;
+	case ELS_CMD_REC:
+			/* receive this due to exchange closed */
+			rjt_err = LSRJT_UNABLE_TPC;
+			rjt_exp = LSEXP_INVALID_OX_RX;
+		break;
 	default:
 		lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
 			"RCV ELS cmd:     cmd:x%x did:x%x/ste:x%x",
@@ -6820,6 +6833,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 
 		/* Unsupported ELS command, reject */
 		rjt_err = LSRJT_CMD_UNSUPPORTED;
+		rjt_exp = LSEXP_NOTHING_MORE;
 
 		/* Unknown ELS command <elsCmd> received from NPORT <did> */
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
@@ -6834,7 +6848,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *p
 	if (rjt_err) {
 		memset(&stat, 0, sizeof(stat));
 		stat.un.b.lsRjtRsnCode = rjt_err;
-		stat.un.b.lsRjtRsnCodeExp = LSEXP_NOTHING_MORE;
+		stat.un.b.lsRjtRsnCodeExp = rjt_exp;
 		lpfc_els_rsp_reject(vport, stat.un.lsRjtError, elsiocb, ndlp,
 			NULL);
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
--- a/drivers/scsi/lpfc/lpfc_hw.h	2012-09-26 20:19:47.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw.h	2013-01-02 13:13:02.688087642 -0500
@@ -538,6 +538,7 @@ struct fc_vft_header {
 #define ELS_CMD_ECHO      0x10000000
 #define ELS_CMD_TEST      0x11000000
 #define ELS_CMD_RRQ       0x12000000
+#define ELS_CMD_REC       0x13000000
 #define ELS_CMD_PRLI      0x20100014
 #define ELS_CMD_PRLO      0x21100014
 #define ELS_CMD_PRLO_ACC  0x02100014
@@ -574,6 +575,7 @@ struct fc_vft_header {
 #define ELS_CMD_ECHO      0x10
 #define ELS_CMD_TEST      0x11
 #define ELS_CMD_RRQ       0x12
+#define ELS_CMD_REC       0x13
 #define ELS_CMD_PRLI      0x14001020
 #define ELS_CMD_PRLO      0x14001021
 #define ELS_CMD_PRLO_ACC  0x14001002



