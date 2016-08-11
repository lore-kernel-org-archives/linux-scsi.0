From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 02/14] lpfc: Fix sg_reset on SCSI device causing kernel
 crash
Date: Thu, 11 Aug 2016 11:35:49 -0700
Message-ID: <57acc585.HP3iyAK6go/SCR18%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f179.google.com ([209.85.220.179]:36468 "EHLO
	mail-qk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbcHKSfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 14:35:52 -0400
Received: by mail-qk0-f179.google.com with SMTP id l2so4043877qkf.3
        for <linux-scsi@vger.kernel.org>; Thu, 11 Aug 2016 11:35:52 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id k20sm976924qkl.2.2016.08.11.11.35.50
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Aug 2016 11:35:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix sg_reset on SCSI device causing kernel crash

Driver could reference stale node pointers in task mgmt call.
Changed to use resetting cmd and look up node pointer in task mgmt
function.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d197aa1..c100477 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4945,18 +4945,21 @@ lpfc_check_fcp_rsp(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd)
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
 
+	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	pnode = rdata->pnode;
 	if (!pnode || !NLP_CHK_NODE_ACT(pnode))
 		return FAILED;
 
@@ -4965,6 +4968,7 @@ lpfc_send_taskmgmt(struct lpfc_vport *vport, struct lpfc_rport_data *rdata,
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->rdata = rdata;
+	lpfc_cmd->pCmd = cmnd;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
 					   task_mgmt_cmd);
@@ -5171,7 +5175,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 						FCP_LUN_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5249,7 +5253,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, rdata, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 					FCP_TARGET_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5328,7 +5332,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 		if (!match)
 			continue;
 
-		status = lpfc_send_taskmgmt(vport, ndlp->rport->dd_data,
+		status = lpfc_send_taskmgmt(vport, cmnd,
 					i, 0, FCP_TARGET_RESET);
 
 		if (status != SUCCESS) {
-- 
2.5.0

