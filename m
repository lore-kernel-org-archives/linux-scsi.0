From: James Smart <james.smart@emulex.com>
Subject: [PATCH 07/12] lpfc 8.3.34: Streamline fcp underrun message printing
Date: Tue, 14 Aug 2012 14:26:06 -0400
Message-ID: <1344968766.4432.22.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:26703 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab2HNS03 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2012 14:26:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Streamline fcp underrun message printing


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:52.078924258 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-08-11 12:24:52.312924252 -0400
@@ -3476,9 +3476,15 @@ lpfc_handle_fcp_err(struct lpfc_vport *v
 	}
 	lp = (uint32_t *)cmnd->sense_buffer;
 
-	if (!scsi_status && (resp_info & RESID_UNDER) &&
-		vport->cfg_log_verbose & LOG_FCP_UNDER)
-		logit = LOG_FCP_UNDER;
+	/* special handling for under run conditions */
+	if (!scsi_status && (resp_info & RESID_UNDER)) {
+		/* don't log under runs if fcp set... */
+		if (vport->cfg_log_verbose & LOG_FCP)
+			logit = LOG_FCP_ERROR;
+		/* unless operator says so */
+		if (vport->cfg_log_verbose & LOG_FCP_UNDER)
+			logit = LOG_FCP_UNDER;
+	}
 
 	lpfc_printf_vlog(vport, KERN_WARNING, logit,
 			 "9024 FCP command x%x failed: x%x SNS x%x x%x "
@@ -3654,10 +3660,10 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba
 			lpfc_cmd->status = IOSTAT_DRIVER_REJECT;
 		else if (lpfc_cmd->status >= IOSTAT_CNT)
 			lpfc_cmd->status = IOSTAT_DEFAULT;
-		if (lpfc_cmd->status == IOSTAT_FCP_RSP_ERROR
-			&& !lpfc_cmd->fcp_rsp->rspStatus3
-			&& (lpfc_cmd->fcp_rsp->rspStatus2 & RESID_UNDER)
-			&& !(phba->cfg_log_verbose & LOG_FCP_UNDER))
+		if (lpfc_cmd->status == IOSTAT_FCP_RSP_ERROR &&
+		    !lpfc_cmd->fcp_rsp->rspStatus3 &&
+		    (lpfc_cmd->fcp_rsp->rspStatus2 & RESID_UNDER) &&
+		    !(vport->cfg_log_verbose & LOG_FCP_UNDER))
 			logit = 0;
 		else
 			logit = LOG_FCP | LOG_FCP_UNDER;



