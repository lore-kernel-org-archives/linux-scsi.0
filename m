From: James Smart <james.smart@emulex.com>
Subject: [PATCH 7/8] lpfc 8.3.45: Fixed crash during driver unload.
Date: Thu, 20 Feb 2014 09:57:57 -0500
Message-ID: <1392908277.31081.19.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:8745 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaBTO57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Feb 2014 09:57:59 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed crash during driver unload.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c  |   18 ++++++++++++++----
 lpfc_init.c |    9 +++++++--
 lpfc_sli.c  |   10 +++++++---
 3 files changed, 28 insertions(+), 9 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2014-02-12 11:38:01.389067311 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2014-02-19 15:29:38.234023944 -0500
@@ -6223,11 +6223,11 @@ lpfc_els_timeout(unsigned long ptr)
 
 	spin_lock_irqsave(&vport->work_port_lock, iflag);
 	tmo_posted = vport->work_port_events & WORKER_ELS_TMO;
-	if (!tmo_posted)
+	if ((!tmo_posted) && (!(vport->load_flag & FC_UNLOADING)))
 		vport->work_port_events |= WORKER_ELS_TMO;
 	spin_unlock_irqrestore(&vport->work_port_lock, iflag);
 
-	if (!tmo_posted)
+	if ((!tmo_posted) && (!(vport->load_flag & FC_UNLOADING)))
 		lpfc_worker_wake_up(phba);
 	return;
 }
@@ -6259,10 +6259,19 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 	timeout = (uint32_t)(phba->fc_ratov << 1);
 
 	pring = &phba->sli.ring[LPFC_ELS_RING];
+	if ((phba->pport->load_flag & FC_UNLOADING))
+		return;
 	spin_lock_irq(&phba->hbalock);
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 
+	if ((phba->pport->load_flag & FC_UNLOADING)) {
+		if (phba->sli_rev == LPFC_SLI_REV4)
+			spin_unlock(&pring->ring_lock);
+		spin_unlock_irq(&phba->hbalock);
+		return;
+	}
+
 	list_for_each_entry_safe(piocb, tmp_iocb, &pring->txcmplq, list) {
 		cmd = &piocb->iocb;
 
@@ -6319,8 +6328,9 @@ lpfc_els_timeout_handler(struct lpfc_vpo
 	}
 
 	if (!list_empty(&phba->sli.ring[LPFC_ELS_RING].txcmplq))
-		mod_timer(&vport->els_tmofunc,
-			  jiffies + msecs_to_jiffies(1000 * timeout));
+		if (!(phba->pport->load_flag & FC_UNLOADING))
+			mod_timer(&vport->els_tmofunc,
+				  jiffies + msecs_to_jiffies(1000 * timeout));
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2014-02-19 15:29:37.302023923 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2014-02-19 15:29:38.242023944 -0500
@@ -1006,9 +1006,14 @@ lpfc_rrq_timeout(unsigned long ptr)
 
 	phba = (struct lpfc_hba *)ptr;
 	spin_lock_irqsave(&phba->pport->work_port_lock, iflag);
-	phba->hba_flag |= HBA_RRQ_ACTIVE;
+	if (!(phba->pport->load_flag & FC_UNLOADING))
+		phba->hba_flag |= HBA_RRQ_ACTIVE;
+	else
+		phba->hba_flag &= ~HBA_RRQ_ACTIVE;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
-	lpfc_worker_wake_up(phba);
+
+	if (!(phba->pport->load_flag & FC_UNLOADING))
+		lpfc_worker_wake_up(phba);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2014-02-19 15:29:28.714023727 -0500
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2014-02-19 15:29:38.260023944 -0500
@@ -678,7 +678,8 @@ lpfc_handle_rrq_active(struct lpfc_hba *
 			next_time = rrq->rrq_stop_time;
 	}
 	spin_unlock_irqrestore(&phba->hbalock, iflags);
-	if (!list_empty(&phba->active_rrq_list))
+	if ((!list_empty(&phba->active_rrq_list)) &&
+	    (!(phba->pport->load_flag & FC_UNLOADING)))
 		mod_timer(&phba->rrq_tmr, next_time);
 	list_for_each_entry_safe(rrq, nextrrq, &send_rrq, list) {
 		list_del(&rrq->list);
@@ -792,7 +793,9 @@ lpfc_cleanup_wt_rrqs(struct lpfc_hba *ph
 		list_del(&rrq->list);
 		lpfc_clr_rrq_active(phba, rrq->xritag, rrq);
 	}
-	if (!list_empty(&phba->active_rrq_list))
+	if ((!list_empty(&phba->active_rrq_list)) &&
+	    (!(phba->pport->load_flag & FC_UNLOADING)))
+
 		mod_timer(&phba->rrq_tmr, next_time);
 }
 
@@ -1323,7 +1326,8 @@ lpfc_sli_ringtxcmpl_put(struct lpfc_hba
 
 	if ((unlikely(pring->ringno == LPFC_ELS_RING)) &&
 	   (piocb->iocb.ulpCommand != CMD_ABORT_XRI_CN) &&
-	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN)) {
+	   (piocb->iocb.ulpCommand != CMD_CLOSE_XRI_CN) &&
+	 (!(piocb->vport->load_flag & FC_UNLOADING))) {
 		if (!piocb->vport)
 			BUG();
 		else



