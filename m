From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 03/17 v2] lpfc: Fix sg_reset on SCSI device causing kernel crash
Date: Wed, 12 Oct 2016 13:14:06 -0700
Message-ID: <57fe998e.qbv3PDNFIL0gvh+R%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:59038 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755972AbcJLUOk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:40 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id 206C212098F
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix sg_reset on SCSI device causing kernel crash

Driver could reference stale node pointers in task mgmt call.
Changed to use resetting cmd and look up node pointer in task mgmt
function.

Modified per review:
Revised lpfc_send_taskmgmt() to check rdata

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index ca56f28..4c53149e 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4948,26 +4948,30 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd)
  *   0x2002 - Success.
  **/
 static int
-lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
-		    unsigned  tgt_id, uint64_t lun_id,
-		    uint8_t task_mgmt_cmd)
+lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
+		   unsigned int tgt_id, uint64_t lun_id,
+		   uint8_t task_mgmt_cmd)
 {
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_scsi_buf *lpfc_cmd;
 	struct lpfc_iocbq *iocbq;
 	struct lpfc_iocbq *iocbqrsp;
-	struct lpfc_nodelist *pnode = rdata->pnode;
+	struct lpfc_rport_data *rdata;
+	struct lpfc_nodelist *pnode;
 	int ret;
 	int status;
 
-	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
+	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	if (!rdata || !rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
 		return FAILED;
+	pnode = rdata->pnode;
 
-	lpfc_cmd = lpfc_get_scsi_buf(phba, rdata->pnode);
+	lpfc_cmd = lpfc_get_scsi_buf(phba, pnode);
 	if (lpfc_cmd == NULL)
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->rdata = rdata;
+	lpfc_cmd->pCmd = cmnd;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
 					   task_mgmt_cmd);
@@ -5174,7 +5178,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 						FCP_LUN_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5252,7 +5256,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 					FCP_TARGET_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5331,7 +5335,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 		if (!match)
 			continue;
 
-		status = lpfc_send_taskmgmt(vport, ndlp->rport->dd_data,
+		status = lpfc_send_taskmgmt(vport, cmnd,
 					i, 0, FCP_TARGET_RESET);
 
 		if (status != SUCCESS) {
-- 
2.5.0


