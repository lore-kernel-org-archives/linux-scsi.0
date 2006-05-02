From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH] lpfc 8.1.6 : Fix Data Corruption in Bus Reset Path
Date: Mon, 01 May 2006 21:50:40 -0400
Message-ID: <1146534640.18622.3.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48047 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932354AbWEBBuv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 May 2006 21:50:51 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k421ontK014970
	for <linux-scsi@vger.kernel.org>; Mon, 1 May 2006 18:50:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch updates the lpfc driver to revision 8.1.6, which includes
the following changes:

 - Fix data corruption in SCSI BUS reset path, due to reusing
   the same request structure for each target.
 - Change version number to 8.1.6

-- james s



Signed-off-by: James Smart <James.Smart@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -629,8 +629,7 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	struct lpfc_iocbq *piocbq;
 	IOCB_t *piocb;
 	struct fcp_cmnd *fcp_cmnd;
-	struct scsi_device *scsi_dev = lpfc_cmd->pCmd->device;
-	struct lpfc_rport_data *rdata = scsi_dev->hostdata;
+	struct lpfc_rport_data *rdata = lpfc_cmd->rdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
 
 	if ((ndlp == NULL) || (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
@@ -665,56 +664,18 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		piocb->ulpTimeout = lpfc_cmd->timeout;
 	}
 
-	lpfc_cmd->rdata = rdata;
-
-	switch (task_mgmt_cmd) {
-	case FCP_LUN_RESET:
-		/* Issue LUN Reset to TGT <num> LUN <num> */
-		lpfc_printf_log(phba,
-				KERN_INFO,
-				LOG_FCP,
-				"%d:0703 Issue LUN Reset to TGT %d LUN %d "
-				"Data: x%x x%x\n",
-				phba->brd_no,
-				scsi_dev->id, scsi_dev->lun,
-				ndlp->nlp_rpi, ndlp->nlp_flag);
-
-		break;
-	case FCP_ABORT_TASK_SET:
-		/* Issue Abort Task Set to TGT <num> LUN <num> */
-		lpfc_printf_log(phba,
-				KERN_INFO,
-				LOG_FCP,
-				"%d:0701 Issue Abort Task Set to TGT %d LUN %d "
-				"Data: x%x x%x\n",
-				phba->brd_no,
-				scsi_dev->id, scsi_dev->lun,
-				ndlp->nlp_rpi, ndlp->nlp_flag);
-
-		break;
-	case FCP_TARGET_RESET:
-		/* Issue Target Reset to TGT <num> */
-		lpfc_printf_log(phba,
-				KERN_INFO,
-				LOG_FCP,
-				"%d:0702 Issue Target Reset to TGT %d "
-				"Data: x%x x%x\n",
-				phba->brd_no,
-				scsi_dev->id, ndlp->nlp_rpi,
-				ndlp->nlp_flag);
-		break;
-	}
-
 	return (1);
 }
 
 static int
-lpfc_scsi_tgt_reset(struct lpfc_scsi_buf * lpfc_cmd, struct lpfc_hba * phba)
+lpfc_scsi_tgt_reset(struct lpfc_scsi_buf * lpfc_cmd, struct lpfc_hba * phba,
+		    unsigned  tgt_id, struct lpfc_rport_data *rdata)
 {
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *iocbqrsp;
 	int ret;
 
+	lpfc_cmd->rdata = rdata;
 	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, FCP_TARGET_RESET);
 	if (!ret)
 		return FAILED;
@@ -726,6 +687,13 @@ lpfc_scsi_tgt_reset(struct lpfc_scsi_buf
 	if (!iocbqrsp)
 		return FAILED;
 
+	/* Issue Target Reset to TGT <num> */
+	lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
+			"%d:0702 Issue Target Reset to TGT %d "
+			"Data: x%x x%x\n",
+			phba->brd_no, tgt_id, rdata->pnode->nlp_rpi,
+			rdata->pnode->nlp_flag);
+
 	ret = lpfc_sli_issue_iocb_wait(phba,
 				       &phba->sli.ring[phba->sli.fcp_ring],
 				       iocbq, iocbqrsp, lpfc_cmd->timeout);
@@ -1021,6 +989,7 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	lpfc_cmd->pCmd = cmnd;
 	lpfc_cmd->timeout = 60;
 	lpfc_cmd->scsi_hba = phba;
+	lpfc_cmd->rdata = rdata;
 
 	ret = lpfc_scsi_prep_task_mgmt_cmd(phba, lpfc_cmd, FCP_LUN_RESET);
 	if (!ret)
@@ -1033,6 +1002,11 @@ lpfc_reset_lun_handler(struct scsi_cmnd 
 	if (iocbqrsp == NULL)
 		goto out_free_scsi_buf;
 
+	lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
+			"%d:0703 Issue LUN Reset to TGT %d LUN %d "
+			"Data: x%x x%x\n", phba->brd_no, cmnd->device->id,
+			cmnd->device->lun, pnode->nlp_rpi, pnode->nlp_flag);
+
 	ret = lpfc_sli_issue_iocb_wait(phba,
 				       &phba->sli.ring[phba->sli.fcp_ring],
 				       iocbq, iocbqrsp, lpfc_cmd->timeout);
@@ -1104,7 +1078,6 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	int match;
 	int ret = FAILED, i, err_count = 0;
 	int cnt, loopcnt;
-	unsigned int midlayer_id = 0;
 	struct lpfc_scsi_buf * lpfc_cmd;
 
 	lpfc_block_requests(phba);
@@ -1124,7 +1097,6 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	 * targets known to the driver.  Should any target reset
 	 * fail, this routine returns failure to the midlayer.
 	 */
-	midlayer_id = cmnd->device->id;
 	for (i = 0; i < MAX_FCP_TARGET; i++) {
 		/* Search the mapped list for this target ID */
 		match = 0;
@@ -1137,9 +1109,8 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 		if (!match)
 			continue;
 
-		lpfc_cmd->pCmd->device->id = i;
-		lpfc_cmd->pCmd->device->hostdata = ndlp->rport->dd_data;
-		ret = lpfc_scsi_tgt_reset(lpfc_cmd, phba);
+		ret = lpfc_scsi_tgt_reset(lpfc_cmd, phba,
+					  i, ndlp->rport->dd_data);
 		if (ret != SUCCESS) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
 				"%d:0713 Bus Reset on target %d failed\n",
@@ -1158,7 +1129,6 @@ lpfc_reset_bus_handler(struct scsi_cmnd 
 	 * the targets.  Unfortunately, some targets do not abide by
 	 * this forcing the driver to double check.
 	 */
-	cmnd->device->id = midlayer_id;
 	cnt = lpfc_sli_sum_iocb(phba, &phba->sli.ring[phba->sli.fcp_ring],
 				0, 0, LPFC_CTX_HOST);
 	if (cnt)
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -18,7 +18,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "8.1.5"
+#define LPFC_DRIVER_VERSION "8.1.6"
 
 #define LPFC_DRIVER_NAME "lpfc"
 


