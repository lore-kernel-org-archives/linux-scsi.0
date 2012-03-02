From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/21] lpfc 8.3.30: Fix driver handling of XRI Aborted CQE
 response
Date: Thu, 1 Mar 2012 22:34:36 -0500
Message-ID: <1330659278.18500.31.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38849 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753985Ab2CBDem (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Mar 2012 22:34:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix driver handling of XRI Aborted CQE response


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h |    6 ++++++
 lpfc_sli.c |   15 ++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2012-02-27 23:35:05.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2012-03-01 17:33:37.000000000 -0500
@@ -338,6 +338,12 @@ struct lpfc_cqe {
 #define CQE_CODE_XRI_ABORTED		0x5
 #define CQE_CODE_RECEIVE_V1		0x9
 
+/*
+ * Define mask value for xri_aborted and wcqe completed CQE extended status.
+ * Currently, extended status is limited to 9 bits (0x0 -> 0x103) .
+ */
+#define WCQE_PARAM_MASK		0x1FF;
+
 /* completion queue entry for wqe completions */
 struct lpfc_wcqe_complete {
 	uint32_t word0;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:36.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-03-01 17:33:37.000000000 -0500
@@ -8388,6 +8388,7 @@ lpfc_sli4_abts_err_handler(struct lpfc_h
 			   struct sli4_wcqe_xri_aborted *axri)
 {
 	struct lpfc_vport *vport;
+	uint32_t ext_status = 0;
 
 	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_SLI,
@@ -8399,12 +8400,20 @@ lpfc_sli4_abts_err_handler(struct lpfc_h
 	vport = ndlp->vport;
 	lpfc_printf_log(phba, KERN_WARNING, LOG_SLI,
 			"3116 Port generated FCP XRI ABORT event on "
-			"vpi %d rpi %d xri x%x status 0x%x\n",
+			"vpi %d rpi %d xri x%x status 0x%x parameter x%x\n",
 			ndlp->vport->vpi, ndlp->nlp_rpi,
 			bf_get(lpfc_wcqe_xa_xri, axri),
-			bf_get(lpfc_wcqe_xa_status, axri));
+			bf_get(lpfc_wcqe_xa_status, axri),
+			axri->parameter);
 
-	if (bf_get(lpfc_wcqe_xa_status, axri) == IOSTAT_LOCAL_REJECT)
+	/*
+	 * Catch the ABTS protocol failure case.  Older OCe FW releases returned
+	 * LOCAL_REJECT and 0 for a failed ABTS exchange and later OCe and
+	 * LPe FW releases returned LOCAL_REJECT and SEQUENCE_TIMEOUT.
+	 */
+	ext_status = axri->parameter & WCQE_PARAM_MASK;
+	if ((bf_get(lpfc_wcqe_xa_status, axri) == IOSTAT_LOCAL_REJECT) &&
+	    ((ext_status == IOERR_SEQUENCE_TIMEOUT) || (ext_status == 0)))
 		lpfc_sli_abts_recover_port(vport, ndlp);
 }
 



