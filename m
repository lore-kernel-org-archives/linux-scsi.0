From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/35] lpfc: drop lpfc_no_handler and lpfc_bus_reset_handler()
Date: Fri, 23 Jun 2017 15:02:28 +0200
Message-ID: <1498222975-71858-9-git-send-email-hare@suse.de>
References: <1498222975-71858-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32836 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752066AbdFWND0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 09:03:26 -0400
In-Reply-To: <1498222975-71858-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

lpfc_bus_reset_handler() is really just a loop calling
lpfc_target_reset_handler() over all targets, which is what
the error handler will be doing anyway.
And lpfc_no_handler() will return FAILED, just like SCSI EH
does if no handler is present.

So drop both.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 99 -------------------------------------------
 1 file changed, 99 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index cfe1d01..19b1202 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5294,93 +5294,6 @@ void lpfc_poll_timeout(unsigned long ptr)
 }
 
 /**
- * lpfc_bus_reset_handler - scsi_host_template eh_bus_reset_handler entry point
- * @cmnd: Pointer to scsi_cmnd data structure.
- *
- * This routine does target reset to all targets on @cmnd->device->host.
- * This emulates Parallel SCSI Bus Reset Semantics.
- *
- * Return code :
- *  0x2003 - Error
- *  0x2002 - Success
- **/
-static int
-lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
-{
-	struct Scsi_Host  *shost = cmnd->device->host;
-	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
-	struct lpfc_nodelist *ndlp = NULL;
-	struct lpfc_scsi_event_header scsi_event;
-	int match;
-	int ret = SUCCESS, status, i;
-
-	scsi_event.event_type = FC_REG_SCSI_EVENT;
-	scsi_event.subcategory = LPFC_EVENT_BUSRESET;
-	scsi_event.lun = 0;
-	memcpy(scsi_event.wwpn, &vport->fc_portname, sizeof(struct lpfc_name));
-	memcpy(scsi_event.wwnn, &vport->fc_nodename, sizeof(struct lpfc_name));
-
-	fc_host_post_vendor_event(shost, fc_get_event_number(),
-		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
-
-	status = fc_block_scsi_eh(cmnd);
-	if (status != 0 && status != SUCCESS)
-		return status;
-
-	/*
-	 * Since the driver manages a single bus device, reset all
-	 * targets known to the driver.  Should any target reset
-	 * fail, this routine returns failure to the midlayer.
-	 */
-	for (i = 0; i < LPFC_MAX_TARGET; i++) {
-		/* Search for mapped node by target ID */
-		match = 0;
-		spin_lock_irq(shost->host_lock);
-		list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
-			if (!NLP_CHK_NODE_ACT(ndlp))
-				continue;
-			if (vport->phba->cfg_fcp2_no_tgt_reset &&
-			    (ndlp->nlp_fcp_info & NLP_FCP_2_DEVICE))
-				continue;
-			if (ndlp->nlp_state == NLP_STE_MAPPED_NODE &&
-			    ndlp->nlp_sid == i &&
-			    ndlp->rport &&
-			    ndlp->nlp_type & NLP_FCP_TARGET) {
-				match = 1;
-				break;
-			}
-		}
-		spin_unlock_irq(shost->host_lock);
-		if (!match)
-			continue;
-
-		status = lpfc_send_taskmgmt(vport, cmnd,
-					i, 0, FCP_TARGET_RESET);
-
-		if (status != SUCCESS) {
-			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-					 "0700 Bus Reset on target %d failed\n",
-					 i);
-			ret = FAILED;
-		}
-	}
-	/*
-	 * We have to clean up i/o as : they may be orphaned by the TMFs
-	 * above; or if any of the TMFs failed, they may be in an
-	 * indeterminate state.
-	 * We will report success if all the i/o aborts successfully.
-	 */
-
-	status = lpfc_reset_flush_io_context(vport, 0, 0, LPFC_CTX_HOST);
-	if (status != SUCCESS)
-		ret = FAILED;
-
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "0714 SCSI layer issued Bus Reset Data: x%x\n", ret);
-	return ret;
-}
-
-/**
  * lpfc_host_reset_handler - scsi_host_template eh_host_reset_handler entry pt
  * @cmnd: Pointer to scsi_cmnd data structure.
  *
@@ -5926,11 +5839,6 @@ struct lpfc_device_data*
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static int
-lpfc_no_handler(struct scsi_cmnd *cmnd)
-{
-	return FAILED;
-}
 
 static int
 lpfc_no_slave(struct scsi_device *sdev)
@@ -5944,11 +5852,6 @@ struct scsi_host_template lpfc_template_nvme = {
 	.proc_name		= LPFC_DRIVER_NAME,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_no_command,
-	.eh_abort_handler	= lpfc_no_handler,
-	.eh_device_reset_handler = lpfc_no_handler,
-	.eh_target_reset_handler = lpfc_no_handler,
-	.eh_bus_reset_handler	= lpfc_no_handler,
-	.eh_host_reset_handler  = lpfc_no_handler,
 	.slave_alloc		= lpfc_no_slave,
 	.slave_configure	= lpfc_no_slave,
 	.scan_finished		= lpfc_scan_finished,
@@ -5972,7 +5875,6 @@ struct scsi_host_template lpfc_template_no_hr = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
 	.slave_destroy		= lpfc_slave_destroy,
@@ -5998,7 +5900,6 @@ struct scsi_host_template lpfc_template = {
 	.eh_abort_handler	= lpfc_abort_handler,
 	.eh_device_reset_handler = lpfc_device_reset_handler,
 	.eh_target_reset_handler = lpfc_target_reset_handler,
-	.eh_bus_reset_handler	= lpfc_bus_reset_handler,
 	.eh_host_reset_handler  = lpfc_host_reset_handler,
 	.slave_alloc		= lpfc_slave_alloc,
 	.slave_configure	= lpfc_slave_configure,
-- 
1.8.5.6
