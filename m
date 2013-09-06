From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/18] lpfc 8.3.42: Fix ramdom errors using first burst
Date: Fri, 6 Sep 2013 12:18:45 -0400
Message-ID: <1378484325.14051.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22771 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab3IFQTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:19:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix ramdom errors using first burst


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-04 13:18:04.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:03.734058299 -0400
@@ -4342,6 +4342,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	char tag[2];
 	uint8_t *ptr;
 	bool sli4;
+	uint32_t fcpdl;
 
 	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 		return;
@@ -4389,8 +4390,12 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 			iocb_cmd->ulpPU = PARM_READ_CHECK;
 			if (vport->cfg_first_burst_size &&
 			    (pnode->nlp_flag & NLP_FIRSTBURST)) {
-				piocbq->iocb.un.fcpi.fcpi_XRdy =
-					vport->cfg_first_burst_size;
+				fcpdl = scsi_bufflen(scsi_cmnd);
+				if (fcpdl < vport->cfg_first_burst_size)
+					piocbq->iocb.un.fcpi.fcpi_XRdy = fcpdl;
+				else
+					piocbq->iocb.un.fcpi.fcpi_XRdy =
+						vport->cfg_first_burst_size;
 			}
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
 			phba->fc4OutputRequests++;



