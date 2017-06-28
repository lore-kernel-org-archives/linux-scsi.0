From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/47] lpfc: use rport as argument for lpfc_send_taskmgmt()
Date: Wed, 28 Jun 2017 10:32:52 +0200
Message-ID: <1498638793-44672-27-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53831 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751533AbdF1IdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:22 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Instead of passing in a scsi device we should be using the rport;
we already have the target and lun id as parameters, so there's
no need to pass the scsi device, too.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index db2716a..f100779 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4954,7 +4954,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 /**
  * lpfc_send_taskmgmt - Generic SCSI Task Mgmt Handler
  * @vport: The virtual port for which this call is being executed.
- * @rdata: Pointer to remote port local data
+ * @rport: Pointer to remote port
  * @tgt_id: Target ID of remote device.
  * @lun_id: Lun number for the TMF
  * @task_mgmt_cmd: type of TMF to send
@@ -4967,7 +4967,7 @@ void lpfc_poll_timeout(unsigned long ptr)
  *   0x2002 - Success.
  **/
 static int
-lpfc_send_taskmgmt(struct lpfc_vport *vport, struct scsi_cmnd *cmnd,
+lpfc_send_taskmgmt(struct lpfc_vport *vport, struct fc_rport *rport,
 		   unsigned int tgt_id, uint64_t lun_id,
 		   uint8_t task_mgmt_cmd)
 {
@@ -4980,7 +4980,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	int ret;
 	int status;
 
-	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
+	rdata = rport->dd_data;
 	if (!rdata || !rdata->pnode || !NLP_CHK_NODE_ACT(rdata->pnode))
 		return FAILED;
 	pnode = rdata->pnode;
@@ -4990,7 +4990,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 		return FAILED;
 	lpfc_cmd->timeout = phba->cfg_task_mgmt_tmo;
 	lpfc_cmd->rdata = rdata;
-	lpfc_cmd->pCmd = cmnd;
+	lpfc_cmd->pCmd = NULL;
 
 	status = lpfc_scsi_prep_task_mgmt_cmd(vport, lpfc_cmd, lun_id,
 					   task_mgmt_cmd);
@@ -5198,7 +5198,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 						FCP_LUN_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
@@ -5277,7 +5277,7 @@ void lpfc_poll_timeout(unsigned long ptr)
 	fc_host_post_vendor_event(shost, fc_get_event_number(),
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
-	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
+	status = lpfc_send_taskmgmt(vport, rport, tgt_id, lun_id,
 					FCP_TARGET_RESET);
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-- 
1.8.5.6
