From: James Smart <james.smart@emulex.com>
Subject: [PATCH 1/7 V2] lpfc 8.3.44: Fixed IO hang when in msi mode.
Date: Tue, 17 Dec 2013 20:29:01 -0500
Message-ID: <1387330141.1011.9.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:41162 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab3LRB3E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 20:29:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed IO hang when in msi mode.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |   18 ++++++++++++++++++
 lpfc_sli.c  |    3 ++-
 2 files changed, 20 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-12-02 11:52:02.443241833 -0500
@@ -4782,6 +4782,24 @@ lpfc_queuecommand(struct Scsi_Host *shos
 				  &lpfc_cmd->cur_iocbq, SLI_IOCB_RET_IOCB);
 	if (err) {
 		atomic_dec(&ndlp->cmd_pending);
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_FCP,
+				 "3376 FCP could not issue IOCB err %x"
+				 "FCP cmd x%x <%d/%d> "
+				 "sid: x%x did: x%x oxid: x%x "
+				 "Data: x%x x%x x%x x%x\n",
+				 err, cmnd->cmnd[0],
+				 cmnd->device ? cmnd->device->id : 0xffff,
+				 cmnd->device ? cmnd->device->lun : 0xffff,
+				 vport->fc_myDID, ndlp->nlp_DID,
+				 phba->sli_rev == LPFC_SLI_REV4 ?
+				 lpfc_cmd->cur_iocbq.sli4_xritag : 0xffff,
+				 lpfc_cmd->cur_iocbq.iocb.ulpContext,
+				 lpfc_cmd->cur_iocbq.iocb.ulpIoTag,
+				 lpfc_cmd->cur_iocbq.iocb.ulpTimeout,
+				 (uint32_t)
+				 (cmnd->request->timeout / 1000));
+
+
 		goto out_host_busy_free_buf;
 	}
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-11-26 21:45:44.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-12-02 11:52:02.485241835 -0500
@@ -8032,7 +8032,8 @@ lpfc_sli4_scmd_to_wqidx_distr(struct lpf
 	struct lpfc_vector_map_info *cpup;
 	int chann, cpu;
 
-	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU) {
+	if (phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_CPU
+	    && phba->cfg_fcp_io_channel > 1) {
 		cpu = smp_processor_id();
 		if (cpu < phba->sli4_hba.num_present_cpu) {
 			cpup = phba->sli4_hba.cpu_map;


