From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/4] lpfc 8.2.6 : Miscellaneous Fixes
Date: Mon, 07 Apr 2008 10:16:05 -0400
Message-ID: <1207577765.28169.14.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33298 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbYDGOQH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2008 10:16:07 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m37EG5rg010295
	for <linux-scsi@vger.kernel.org>; Mon, 7 Apr 2008 07:16:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Miscellaneous Fixes
- Allow WRITE_VPARAM command when the virtual port is in a stopped state
- Fixed handling of our queue depth max that was unconditionally raising
  the depth on all vports, rather than just the vport affected.
- Fix race in interrupt handler for mailbox processing that did not take
  out the host lock.
- Removed unused functions: find_node, findnode_rpi, and fabric_abort_flogi
- Correct misspelled word unsolicited in message 0146
- Correct HW-error 5 handling - it should not reset the adapter
- Correct handling of IOCBs, which did not null out our pCmd field before
  invoking the midlayer io done function.
- Changed our maximum supported target id to 4096


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |    2 +-
 lpfc_attr.c    |    4 +++-
 lpfc_ct.c      |    2 +-
 lpfc_els.c     |   36 ------------------------------------
 lpfc_hbadisc.c |   32 --------------------------------
 lpfc_init.c    |    3 +--
 lpfc_scsi.c    |    8 ++++++--
 lpfc_sli.c     |   20 +++++++++-----------
 8 files changed, 21 insertions(+), 86 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2008-04-07 09:15:29.000000000 -0400
@@ -1954,7 +1954,9 @@ sysfs_mbox_read(struct kobject *kobj, st
 			(phba->sysfs_mbox.mbox->mb.mbxCommand !=
 				MBX_DUMP_MEMORY &&
 			 phba->sysfs_mbox.mbox->mb.mbxCommand !=
-				MBX_RESTART)) {
+				MBX_RESTART &&
+			 phba->sysfs_mbox.mbox->mb.mbxCommand !=
+				MBX_WRITE_VPARMS)) {
 			sysfs_mbox_idle(phba);
 			spin_unlock_irq(&phba->hbalock);
 			return -EPERM;
diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-04-07 09:15:34.000000000 -0400
@@ -63,7 +63,7 @@ lpfc_ct_ignore_hbq_buffer(struct lpfc_hb
 {
 	if (!mp) {
 		lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-				"0146 Ignoring unsolicted CT No HBQ "
+				"0146 Ignoring unsolicited CT No HBQ "
 				"status = x%x\n",
 				piocbq->iocb.ulpStatus);
 	}
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-04-07 09:15:33.000000000 -0400
@@ -5097,39 +5097,3 @@ void lpfc_fabric_abort_hba(struct lpfc_h
 		(piocb->iocb_cmpl) (phba, piocb, piocb);
 	}
 }
-
-
-#if 0
-void lpfc_fabric_abort_flogi(struct lpfc_hba *phba)
-{
-	LIST_HEAD(completions);
-	struct lpfc_iocbq *tmp_iocb, *piocb;
-	IOCB_t *cmd;
-	struct lpfc_nodelist *ndlp;
-
-	spin_lock_irq(&phba->hbalock);
-	list_for_each_entry_safe(piocb, tmp_iocb, &phba->fabric_iocb_list,
-				 list) {
-
-		cmd = &piocb->iocb;
-		ndlp = (struct lpfc_nodelist *) piocb->context1;
-		if (cmd->ulpCommand == CMD_ELS_REQUEST64_CR &&
-		    ndlp != NULL &&
-		    ndlp->nlp_DID == Fabric_DID)
-			list_move_tail(&piocb->list, &completions);
-	}
-	spin_unlock_irq(&phba->hbalock);
-
-	while (!list_empty(&completions)) {
-		piocb = list_get_first(&completions, struct lpfc_iocbq, list);
-		list_del_init(&piocb->list);
-
-		cmd = &piocb->iocb;
-		cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
-		cmd->un.ulpWord[4] = IOERR_SLI_ABORTED;
-		(piocb->iocb_cmpl) (phba, piocb, piocb);
-	}
-}
-#endif  /*  0  */
-
-
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-04-07 09:15:38.000000000 -0400
@@ -23,7 +23,7 @@
 
 struct lpfc_sli2_slim;
 
-#define LPFC_MAX_TARGET		256	/* max number of targets supported */
+#define LPFC_MAX_TARGET		4096	/* max number of targets supported */
 #define LPFC_MAX_DISC_THREADS	64	/* max outstanding discovery els
 					   requests */
 #define LPFC_MAX_NS_RETRY	3	/* Number of retry attempts to contact
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-04-07 09:15:33.000000000 -0400
@@ -2948,24 +2948,6 @@ __lpfc_find_node(struct lpfc_vport *vpor
 	return NULL;
 }
 
-#if 0
-/*
- * Search node lists for a remote port matching filter criteria
- * Caller needs to hold host_lock before calling this routine.
- */
-struct lpfc_nodelist *
-lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
-{
-	struct Scsi_Host     *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_nodelist *ndlp;
-
-	spin_lock_irq(shost->host_lock);
-	ndlp = __lpfc_find_node(vport, filter, param);
-	spin_unlock_irq(shost->host_lock);
-	return ndlp;
-}
-#endif  /*  0  */
-
 /*
  * This routine looks up the ndlp lists for the given RPI. If rpi found it
  * returns the node list element pointer else return NULL.
@@ -2976,20 +2958,6 @@ __lpfc_findnode_rpi(struct lpfc_vport *v
 	return __lpfc_find_node(vport, lpfc_filter_by_rpi, &rpi);
 }
 
-#if 0
-struct lpfc_nodelist *
-lpfc_findnode_rpi(struct lpfc_vport *vport, uint16_t rpi)
-{
-	struct Scsi_Host *shost = lpfc_shost_from_vport(vport);
-	struct lpfc_nodelist *ndlp;
-
-	spin_lock_irq(shost->host_lock);
-	ndlp = __lpfc_findnode_rpi(vport, rpi);
-	spin_unlock_irq(shost->host_lock);
-	return ndlp;
-}
-#endif  /*  0  */
-
 /*
  * This routine looks up the ndlp lists for the given WWPN. If WWPN found it
  * returns the node element list pointer else return NULL.
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-04-07 09:15:06.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-04-07 09:15:36.000000000 -0400
@@ -729,8 +729,7 @@ lpfc_handle_eratt(struct lpfc_hba *phba)
 	if (!phba->cfg_enable_hba_reset)
 		return;
 
-	if (phba->work_hs & HS_FFER6 ||
-	    phba->work_hs & HS_FFER5) {
+	if (phba->work_hs & HS_FFER6) {
 		/* Re-establishing Link */
 		lpfc_printf_log(phba, KERN_INFO, LOG_LINK_EVENT,
 				"1301 Re-establishing Link "
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-04-07 09:12:12.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-04-07 09:15:37.000000000 -0400
@@ -169,6 +169,9 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 		for(i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
 			shost = lpfc_shost_from_vport(vports[i]);
 			shost_for_each_device(sdev, shost) {
+				if (vports[i]->cfg_lun_queue_depth <=
+				    sdev->queue_depth)
+					continue;
 				if (sdev->ordered_tags)
 					scsi_adjust_queue_depth(sdev,
 							MSG_ORDERED_TAG,
@@ -606,6 +609,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	result = cmd->result;
 	sdev = cmd->device;
 	lpfc_scsi_unprep_dma_buf(phba, lpfc_cmd);
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	lpfc_cmd->pCmd = NULL;	/* This must be done before scsi_done */
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
 	cmd->scsi_done(cmd);
 
 	if (phba->cfg_poll & ENABLE_FCP_RING_POLLING) {
@@ -614,7 +620,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		 * wake up the thread.
 		 */
 		spin_lock_irqsave(sdev->host->host_lock, flags);
-		lpfc_cmd->pCmd = NULL;
 		if (lpfc_cmd->waitq)
 			wake_up(lpfc_cmd->waitq);
 		spin_unlock_irqrestore(sdev->host->host_lock, flags);
@@ -685,7 +690,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	 * wake up the thread.
 	 */
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	lpfc_cmd->pCmd = NULL;
 	if (lpfc_cmd->waitq)
 		wake_up(lpfc_cmd->waitq);
 	spin_unlock_irqrestore(sdev->host->host_lock, flags);
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-04-07 09:12:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-04-07 09:15:31.000000000 -0400
@@ -3481,26 +3481,21 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	phba->pport->work_port_events &= ~WORKER_MBOX_TMO;
 	spin_unlock(&phba->pport->work_port_lock);
 
+	/* Return any pending or completed mbox cmds */
+	list_splice_init(&phba->sli.mboxq, &completions);
 	if (psli->mbox_active) {
 		list_add_tail(&psli->mbox_active->list, &completions);
 		psli->mbox_active = NULL;
 		psli->sli_flag &= ~LPFC_SLI_MBOX_ACTIVE;
 	}
-
-	/* Return any pending or completed mbox cmds */
-	list_splice_init(&phba->sli.mboxq, &completions);
 	list_splice_init(&phba->sli.mboxq_cmpl, &completions);
-	INIT_LIST_HEAD(&psli->mboxq);
-	INIT_LIST_HEAD(&psli->mboxq_cmpl);
-
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	while (!list_empty(&completions)) {
 		list_remove_head(&completions, pmb, LPFC_MBOXQ_t, list);
 		pmb->mb.mbxStatus = MBX_NOT_FINISHED;
-		if (pmb->mbox_cmpl) {
+		if (pmb->mbox_cmpl)
 			pmb->mbox_cmpl(phba,pmb);
-		}
 	}
 	return 1;
 }
@@ -4201,6 +4196,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 			phba->pport->stopped = 1;
 		}
 
+		spin_lock(&phba->hbalock);
 		if ((work_ha_copy & HA_MBATT) &&
 		    (phba->sli.mbox_active)) {
 			pmb = phba->sli.mbox_active;
@@ -4211,6 +4207,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 			/* First check out the status word */
 			lpfc_sli_pcimem_bcopy(mbox, pmbox, sizeof(uint32_t));
 			if (pmbox->mbxOwner != OWN_HOST) {
+				spin_unlock(&phba->hbalock);
 				/*
 				 * Stray Mailbox Interrupt, mbxCommand <cmd>
 				 * mbxStatus <status>
@@ -4226,10 +4223,10 @@ lpfc_intr_handler(int irq, void *dev_id)
 				/* clear mailbox attention bit */
 				work_ha_copy &= ~HA_MBATT;
 			} else {
+				phba->sli.mbox_active = NULL;
+				spin_unlock(&phba->hbalock);
 				phba->last_completion_time = jiffies;
 				del_timer(&phba->sli.mbox_tmo);
-
-				phba->sli.mbox_active = NULL;
 				if (pmb->mbox_cmpl) {
 					lpfc_sli_pcimem_bcopy(mbox, pmbox,
 							MAILBOX_CMD_SIZE);
@@ -4282,7 +4279,8 @@ lpfc_intr_handler(int irq, void *dev_id)
 				spin_unlock(&phba->pport->work_port_lock);
 				lpfc_mbox_cmpl_put(phba, pmb);
 			}
-		}
+		} else
+			spin_unlock(&phba->hbalock);
 		if ((work_ha_copy & HA_MBATT) &&
 		    (phba->sli.mbox_active == NULL)) {
 send_current_mbox:


