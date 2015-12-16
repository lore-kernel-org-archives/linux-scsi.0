From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 10/17] lpfc: Make write check error processing more
 resilient
Date: Wed, 16 Dec 2015 18:12:01 -0500
Message-ID: <5671efc1.gThEwyunCl95KJV4%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33339 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220AbbLPXMV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:21 -0500
Received: by mail-pa0-f54.google.com with SMTP id ur14so30973602pab.0
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:20 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id rz10sm11404361pac.29.2015.12.16.15.12.18
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Make write check error processing more resilient.

Checks to catch writes that fw reports weren't fully complete yet SCSI
status indicated fine needed correction.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3162469..b2414da 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -3676,6 +3676,7 @@ static void
 lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 		    struct lpfc_iocbq *rsp_iocb)
 {
+	struct lpfc_hba *phba = vport->phba;
 	struct scsi_cmnd *cmnd = lpfc_cmd->pCmd;
 	struct fcp_cmnd *fcpcmd = lpfc_cmd->fcp_cmnd;
 	struct fcp_rsp *fcprsp = lpfc_cmd->fcp_rsp;
@@ -3685,6 +3686,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	uint32_t *lp;
 	uint32_t host_status = DID_OK;
 	uint32_t rsplen = 0;
+	uint32_t fcpDl;
 	uint32_t logit = LOG_FCP | LOG_FCP_ERROR;
 
 
@@ -3755,13 +3757,14 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 			 fcprsp->rspInfo3);
 
 	scsi_set_resid(cmnd, 0);
+	fcpDl = be32_to_cpu(fcpcmd->fcpDl);
 	if (resp_info & RESID_UNDER) {
 		scsi_set_resid(cmnd, be32_to_cpu(fcprsp->rspResId));
 
 		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP_UNDER,
 				 "9025 FCP Read Underrun, expected %d, "
 				 "residual %d Data: x%x x%x x%x\n",
-				 be32_to_cpu(fcpcmd->fcpDl),
+				 fcpDl,
 				 scsi_get_resid(cmnd), fcpi_parm, cmnd->cmnd[0],
 				 cmnd->underflow);
 
@@ -3777,7 +3780,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 					 LOG_FCP | LOG_FCP_ERROR,
 					 "9026 FCP Read Check Error "
 					 "and Underrun Data: x%x x%x x%x x%x\n",
-					 be32_to_cpu(fcpcmd->fcpDl),
+					 fcpDl,
 					 scsi_get_resid(cmnd), fcpi_parm,
 					 cmnd->cmnd[0]);
 			scsi_set_resid(cmnd, scsi_bufflen(cmnd));
@@ -3812,13 +3815,25 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
 	 * Check SLI validation that all the transfer was actually done
 	 * (fcpi_parm should be zero). Apply check only to reads.
 	 */
-	} else if (fcpi_parm && (cmnd->sc_data_direction == DMA_FROM_DEVICE)) {
+	} else if (fcpi_parm) {
 		lpfc_printf_vlog(vport, KERN_WARNING, LOG_FCP | LOG_FCP_ERROR,
-				 "9029 FCP Read Check Error Data: "
+				 "9029 FCP %s Check Error xri x%x  Data: "
 				 "x%x x%x x%x x%x x%x\n",
-				 be32_to_cpu(fcpcmd->fcpDl),
-				 be32_to_cpu(fcprsp->rspResId),
+				 ((cmnd->sc_data_direction == DMA_FROM_DEVICE) ?
+				 "Read" : "Write"),
+				 ((phba->sli_rev == LPFC_SLI_REV4) ?
+				 lpfc_cmd->cur_iocbq.sli4_xritag :
+				 rsp_iocb->iocb.ulpContext),
+				 fcpDl, be32_to_cpu(fcprsp->rspResId),
 				 fcpi_parm, cmnd->cmnd[0], scsi_status);
+
+		/* There is some issue with the LPe12000 that causes it
+		 * to miscalculate the fcpi_parm and falsely trip this
+		 * recovery logic.  Detect this case and don't error when true.
+		 */
+		if (fcpi_parm > fcpDl)
+			goto out;
+
 		switch (scsi_status) {
 		case SAM_STAT_GOOD:
 		case SAM_STAT_CHECK_CONDITION:
-- 
1.7.11.7

