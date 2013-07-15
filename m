From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/13] lpfc 8.3.41: Fixed SLI3 failing FCP write on
 check-condition no-sense with residual zero
Date: Mon, 15 Jul 2013 18:34:05 -0400
Message-ID: <1373927645.15647.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4550 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758156Ab3GOWeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:34:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed SLI3 failing FCP write on check-condition no-sense with residual zero


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-07-15 07:15:01.946055472 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-07-15 07:15:23.877055972 -0400
@@ -4386,12 +4386,7 @@ lpfc_scsi_prep_cmnd(struct lpfc_vport *v
 	if (scsi_sg_count(scsi_cmnd)) {
 		if (datadir == DMA_TO_DEVICE) {
 			iocb_cmd->ulpCommand = CMD_FCP_IWRITE64_CR;
-			if (sli4)
-				iocb_cmd->ulpPU = PARM_READ_CHECK;
-			else {
-				iocb_cmd->un.fcpi.fcpi_parm = 0;
-				iocb_cmd->ulpPU = 0;
-			}
+			iocb_cmd->ulpPU = PARM_READ_CHECK;
 			fcp_cmnd->fcpCntl3 = WRITE_DATA;
 			phba->fc4OutputRequests++;
 		} else {




