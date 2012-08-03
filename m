From: James Smart <james.smart@emulex.com>
Subject: [PATCH 09/21] lpfc 8.3.33: Convert to no SCSI host lock in
 queuecommand
Date: Fri, 3 Aug 2012 12:35:24 -0400
Message-ID: <1344011724.6110.34.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:44821 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab2HCQfa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:35:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Convert to no SCSI host lock in queuecommand


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 12:44:35.540487541 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 13:07:03.723440712 -0400
@@ -4241,9 +4241,8 @@ void lpfc_poll_timeout(unsigned long ptr
  *   SCSI_MLQUEUE_HOST_BUSY - Block all devices served by this host temporarily.
  **/
 static int
-lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
+lpfc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmnd)
 {
-	struct Scsi_Host  *shost = cmnd->device->host;
 	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_rport_data *rdata = cmnd->device->hostdata;
@@ -4299,7 +4298,6 @@ lpfc_queuecommand_lck(struct scsi_cmnd *
 	lpfc_cmd->timeout = 0;
 	lpfc_cmd->start_time = jiffies;
 	cmnd->host_scribble = (unsigned char *)lpfc_cmd;
-	cmnd->scsi_done = done;
 
 	if (scsi_get_prot_op(cmnd) != SCSI_PROT_NORMAL) {
 		if (vport->phba->cfg_enable_bg) {
@@ -4363,11 +4361,9 @@ lpfc_queuecommand_lck(struct scsi_cmnd *
 		goto out_host_busy_free_buf;
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
-		spin_unlock(shost->host_lock);
 		lpfc_sli_handle_fast_ring_event(phba,
 			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
 
-		spin_lock(shost->host_lock);
 		if (phba->cfg_poll & DISABLE_FCP_RING_INT)
 			lpfc_poll_rearm_timer(phba);
 	}
@@ -4384,11 +4380,10 @@ lpfc_queuecommand_lck(struct scsi_cmnd *
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
  out_fail_command:
-	done(cmnd);
+	cmnd->scsi_done(cmnd);
 	return 0;
 }
 
-static DEF_SCSI_QCMD(lpfc_queuecommand)
 
 /**
  * lpfc_abort_handler - scsi_host_template eh_abort_handler entry point



