From: James Smart <james.smart@emulex.com>
Subject: [PATCH 18/20] lpfc 8.3.31: Fix bug with driver using the wrong
 xritag when sending an els echo
Date: Wed, 9 May 2012 21:19:34 -0400
Message-ID: <1336612775.1996.47.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27901 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757239Ab2EJBTq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:19:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix bug with driver using the wrong xritag when sending an els echo.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |    1 +
 lpfc_sli.c |    8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2012-05-07 10:01:00.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2012-05-07 10:06:59.000000000 -0400
@@ -599,6 +599,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 
 	cmdiocbq->iocb_cmpl = lpfc_bsg_rport_els_cmp;
 	cmdiocbq->context1 = dd_data;
+	cmdiocbq->context_un.ndlp = ndlp;
 	cmdiocbq->context2 = rspiocbq;
 	dd_data->type = TYPE_IOCB;
 	dd_data->context_un.iocb.cmdiocbq = cmdiocbq;
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:01:26.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2012-05-07 10:06:59.000000000 -0400
@@ -877,6 +877,9 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phb
 	} else  if ((piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) &&
 			!(piocbq->iocb_flag & LPFC_IO_LIBDFC))
 		ndlp = piocbq->context_un.ndlp;
+	else  if ((piocbq->iocb.ulpCommand == CMD_ELS_REQUEST64_CR) &&
+			(piocbq->iocb_flag & LPFC_IO_LIBDFC))
+		ndlp = piocbq->context_un.ndlp;
 	else
 		ndlp = piocbq->context1;
 
@@ -7868,7 +7871,10 @@ lpfc_sli4_iocb2wqe(struct lpfc_hba *phba
 
 	switch (iocbq->iocb.ulpCommand) {
 	case CMD_ELS_REQUEST64_CR:
-		ndlp = (struct lpfc_nodelist *)iocbq->context1;
+		if (iocbq->iocb_flag & LPFC_IO_LIBDFC)
+			ndlp = iocbq->context_un.ndlp;
+		else
+			ndlp = (struct lpfc_nodelist *)iocbq->context1;
 		if (!iocbq->iocb.ulpLe) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_SLI,
 				"2007 Only Limited Edition cmd Format"



