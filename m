From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/8] lpfc 8.3.45: Fixed missing initialization for task
 management IOCBs
Date: Thu, 20 Feb 2014 09:57:28 -0500
Message-ID: <1392908248.31081.17.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:16712 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbaBTO5c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 09:57:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed missing initialization for task management IOCBs


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    2 ++
 1 file changed, 2 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2014-02-19 15:29:32.386023811 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2014-02-19 15:29:36.097023895 -0500
@@ -4423,6 +4423,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	}
 	piocb->ulpFCP2Rcvy = (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE) ? 1 : 0;
 	piocb->ulpClass = (ndlp->nlp_fcp_info & 0x0f);
+	piocb->ulpPU = 0;
+	piocb->un.fcpi.fcpi_parm = 0;
 
 	/* ulpTimeout is only one byte */
 	if (lpfc_cmd->timeout > 0xff) {



