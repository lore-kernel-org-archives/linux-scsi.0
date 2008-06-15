From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/5] lpfc 8.2.7 : Rework the worker thread
Date: Sat, 14 Jun 2008 22:52:53 -0400
Message-ID: <1213498373.10002.12.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:33080 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbYFOCw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Jun 2008 22:52:56 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m5F2qt7Z018791
	for <linux-scsi@vger.kernel.org>; Sat, 14 Jun 2008 19:52:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Rework of the worker thread to make it more efficient. 
  Make a finer-grain notfication of pending work so less time is
  spent checking conditions. Also made other general cleanups.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h         |   20 +++++++++---
 lpfc_ct.c      |   16 ++++-----
 lpfc_els.c     |   33 ++++++++------------
 lpfc_hbadisc.c |   93 ++++++++++++++-------------------------------------------
 lpfc_init.c    |   13 ++++---
 lpfc_scsi.c    |   26 ++++++---------
 lpfc_sli.c     |   36 +++++++++++-----------
 7 files changed, 97 insertions(+), 140 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
--- a/drivers/scsi/lpfc/lpfc_ct.c	2008-04-10 17:07:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_ct.c	2008-06-14 22:23:56.000000000 -0400
@@ -1679,20 +1679,18 @@ lpfc_fdmi_tmo(unsigned long ptr)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *)ptr;
 	struct lpfc_hba   *phba = vport->phba;
+	uint32_t tmo_posted;
 	unsigned long iflag;
 
 	spin_lock_irqsave(&vport->work_port_lock, iflag);
-	if (!(vport->work_port_events & WORKER_FDMI_TMO)) {
+	tmo_posted = vport->work_port_events & WORKER_FDMI_TMO;
+	if (!tmo_posted)
 		vport->work_port_events |= WORKER_FDMI_TMO;
-		spin_unlock_irqrestore(&vport->work_port_lock, iflag);
+	spin_unlock_irqrestore(&vport->work_port_lock, iflag);
 
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		if (phba->work_wait)
-			lpfc_worker_wake_up(phba);
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-	}
-	else
-		spin_unlock_irqrestore(&vport->work_port_lock, iflag);
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
+	return;
 }
 
 void
diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2008-06-14 22:19:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2008-06-14 22:23:56.000000000 -0400
@@ -1813,11 +1813,11 @@ lpfc_els_retry_delay(unsigned long ptr)
 	 * count until the queued work is done
 	 */
 	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
-	evtp->evt       = LPFC_EVT_ELS_RETRY;
-	list_add_tail(&evtp->evt_listp, &phba->work_list);
-	if (phba->work_wait)
+	if (evtp->evt_arg1) {
+		evtp->evt = LPFC_EVT_ELS_RETRY;
+		list_add_tail(&evtp->evt_listp, &phba->work_list);
 		lpfc_worker_wake_up(phba);
-
+	}
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	return;
 }
@@ -3802,20 +3802,17 @@ lpfc_els_timeout(unsigned long ptr)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) ptr;
 	struct lpfc_hba   *phba = vport->phba;
+	uint32_t tmo_posted;
 	unsigned long iflag;
 
 	spin_lock_irqsave(&vport->work_port_lock, iflag);
-	if ((vport->work_port_events & WORKER_ELS_TMO) == 0) {
+	tmo_posted = vport->work_port_events & WORKER_ELS_TMO;
+	if (!tmo_posted)
 		vport->work_port_events |= WORKER_ELS_TMO;
-		spin_unlock_irqrestore(&vport->work_port_lock, iflag);
+	spin_unlock_irqrestore(&vport->work_port_lock, iflag);
 
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		if (phba->work_wait)
-			lpfc_worker_wake_up(phba);
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-	}
-	else
-		spin_unlock_irqrestore(&vport->work_port_lock, iflag);
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
 	return;
 }
 
@@ -4769,18 +4766,16 @@ lpfc_fabric_block_timeout(unsigned long 
 	struct lpfc_hba  *phba = (struct lpfc_hba *) ptr;
 	unsigned long iflags;
 	uint32_t tmo_posted;
+
 	spin_lock_irqsave(&phba->pport->work_port_lock, iflags);
 	tmo_posted = phba->pport->work_port_events & WORKER_FABRIC_BLOCK_TMO;
 	if (!tmo_posted)
 		phba->pport->work_port_events |= WORKER_FABRIC_BLOCK_TMO;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflags);
 
-	if (!tmo_posted) {
-		spin_lock_irqsave(&phba->hbalock, iflags);
-		if (phba->work_wait)
-			lpfc_worker_wake_up(phba);
-		spin_unlock_irqrestore(&phba->hbalock, iflags);
-	}
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
+	return;
 }
 
 static void
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2008-04-10 17:07:57.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2008-06-14 22:23:56.000000000 -0400
@@ -59,6 +59,9 @@ struct lpfc_sli2_slim;
 
 #define MAX_HBAEVT	32
 
+/* lpfc wait event data ready flag */
+#define LPFC_DATA_READY		(1<<0)
+
 enum lpfc_polling_flags {
 	ENABLE_FCP_RING_POLLING = 0x1,
 	DISABLE_FCP_RING_INT    = 0x2
@@ -425,9 +428,6 @@ struct lpfc_hba {
 
 	uint16_t pci_cfg_value;
 
-	uint8_t work_found;
-#define LPFC_MAX_WORKER_ITERATION  4
-
 	uint8_t fc_linkspeed;	/* Link speed after last READ_LA */
 
 	uint32_t fc_eventTag;	/* event tag for link attention */
@@ -489,8 +489,9 @@ struct lpfc_hba {
 	uint32_t              work_hs;      /* HS stored in case of ERRAT */
 	uint32_t              work_status[2]; /* Extra status from SLIM */
 
-	wait_queue_head_t    *work_wait;
+	wait_queue_head_t    work_waitq;
 	struct task_struct   *worker_thread;
+	long data_flags;
 
 	uint32_t hbq_in_use;		/* HBQs in use flag */
 	struct list_head hbqbuf_in_list;  /* in-fly hbq buffer list */
@@ -637,6 +638,17 @@ lpfc_is_link_up(struct lpfc_hba *phba)
 		phba->link_state == LPFC_HBA_READY;
 }
 
+static inline void
+lpfc_worker_wake_up(struct lpfc_hba *phba)
+{
+	/* Set the lpfc data pending flag */
+	set_bit(LPFC_DATA_READY, &phba->data_flags);
+
+	/* Wake up worker thread */
+	wake_up(&phba->work_waitq);
+	return;
+}
+
 #define FC_REG_DUMP_EVENT		0x10	/* Register for Dump events */
 #define FC_REG_TEMPERATURE_EVENT	0x20    /* Register for temperature
 						   event */
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-06-14 22:19:37.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-06-14 22:23:56.000000000 -0400
@@ -153,11 +153,11 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport
 	 * count until this queued work is done
 	 */
 	evtp->evt_arg1  = lpfc_nlp_get(ndlp);
-	evtp->evt       = LPFC_EVT_DEV_LOSS;
-	list_add_tail(&evtp->evt_listp, &phba->work_list);
-	if (phba->work_wait)
-		wake_up(phba->work_wait);
-
+	if (evtp->evt_arg1) {
+		evtp->evt = LPFC_EVT_DEV_LOSS;
+		list_add_tail(&evtp->evt_listp, &phba->work_list);
+		lpfc_worker_wake_up(phba);
+	}
 	spin_unlock_irq(&phba->hbalock);
 
 	return;
@@ -276,14 +276,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 		lpfc_disc_state_machine(vport, ndlp, NULL, NLP_EVT_DEVICE_RM);
 }
 
-
-void
-lpfc_worker_wake_up(struct lpfc_hba *phba)
-{
-	wake_up(phba->work_wait);
-	return;
-}
-
 static void
 lpfc_work_list_done(struct lpfc_hba *phba)
 {
@@ -429,6 +421,8 @@ lpfc_work_done(struct lpfc_hba *phba)
 		|| (pring->flag & LPFC_DEFERRED_RING_EVENT)) {
 		if (pring->flag & LPFC_STOP_IOCB_EVENT) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
+			/* Set the lpfc data pending flag */
+			set_bit(LPFC_DATA_READY, &phba->data_flags);
 		} else {
 			pring->flag &= ~LPFC_DEFERRED_RING_EVENT;
 			lpfc_sli_handle_slow_ring_event(phba, pring,
@@ -459,69 +453,29 @@ lpfc_work_done(struct lpfc_hba *phba)
 	lpfc_work_list_done(phba);
 }
 
-static int
-check_work_wait_done(struct lpfc_hba *phba)
-{
-	struct lpfc_vport *vport;
-	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
-	int rc = 0;
-
-	spin_lock_irq(&phba->hbalock);
-	list_for_each_entry(vport, &phba->port_list, listentry) {
-		if (vport->work_port_events) {
-			rc = 1;
-			break;
-		}
-	}
-	if (rc || phba->work_ha || (!list_empty(&phba->work_list)) ||
-	    kthread_should_stop() || pring->flag & LPFC_DEFERRED_RING_EVENT) {
-		rc = 1;
-		phba->work_found++;
-	} else
-		phba->work_found = 0;
-	spin_unlock_irq(&phba->hbalock);
-	return rc;
-}
-
-
 int
 lpfc_do_work(void *p)
 {
 	struct lpfc_hba *phba = p;
 	int rc;
-	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(work_waitq);
 
 	set_user_nice(current, -20);
-	phba->work_wait = &work_waitq;
-	phba->work_found = 0;
+	phba->data_flags = 0;
 
 	while (1) {
-
-		rc = wait_event_interruptible(work_waitq,
-					      check_work_wait_done(phba));
-
+		/* wait and check worker queue activities */
+		rc = wait_event_interruptible(phba->work_waitq,
+					(test_and_clear_bit(LPFC_DATA_READY,
+							    &phba->data_flags)
+					 || kthread_should_stop()));
 		BUG_ON(rc);
 
 		if (kthread_should_stop())
 			break;
 
+		/* Attend pending lpfc data processing */
 		lpfc_work_done(phba);
-
-		/* If there is alot of slow ring work, like during link up
-		 * check_work_wait_done() may cause this thread to not give
-		 * up the CPU for very long periods of time. This may cause
-		 * soft lockups or other problems. To avoid these situations
-		 * give up the CPU here after LPFC_MAX_WORKER_ITERATION
-		 * consecutive iterations.
-		 */
-		if (phba->work_found >= LPFC_MAX_WORKER_ITERATION) {
-			phba->work_found = 0;
-			schedule();
-		}
 	}
-	spin_lock_irq(&phba->hbalock);
-	phba->work_wait = NULL;
-	spin_unlock_irq(&phba->hbalock);
 	return 0;
 }
 
@@ -551,10 +505,10 @@ lpfc_workq_post_event(struct lpfc_hba *p
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	list_add_tail(&evtp->evt_listp, &phba->work_list);
-	if (phba->work_wait)
-		lpfc_worker_wake_up(phba);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
+	lpfc_worker_wake_up(phba);
+
 	return 1;
 }
 
@@ -2636,21 +2590,20 @@ lpfc_disc_timeout(unsigned long ptr)
 {
 	struct lpfc_vport *vport = (struct lpfc_vport *) ptr;
 	struct lpfc_hba   *phba = vport->phba;
+	uint32_t tmo_posted;
 	unsigned long flags = 0;
 
 	if (unlikely(!phba))
 		return;
 
-	if ((vport->work_port_events & WORKER_DISC_TMO) == 0) {
-		spin_lock_irqsave(&vport->work_port_lock, flags);
+	spin_lock_irqsave(&vport->work_port_lock, flags);
+	tmo_posted = vport->work_port_events & WORKER_DISC_TMO;
+	if (!tmo_posted)
 		vport->work_port_events |= WORKER_DISC_TMO;
-		spin_unlock_irqrestore(&vport->work_port_lock, flags);
+	spin_unlock_irqrestore(&vport->work_port_lock, flags);
 
-		spin_lock_irqsave(&phba->hbalock, flags);
-		if (phba->work_wait)
-			lpfc_worker_wake_up(phba);
-		spin_unlock_irqrestore(&phba->hbalock, flags);
-	}
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
 	return;
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-06-14 22:19:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-06-14 22:23:56.000000000 -0400
@@ -551,18 +551,18 @@ static void
 lpfc_hb_timeout(unsigned long ptr)
 {
 	struct lpfc_hba *phba;
+	uint32_t tmo_posted;
 	unsigned long iflag;
 
 	phba = (struct lpfc_hba *)ptr;
 	spin_lock_irqsave(&phba->pport->work_port_lock, iflag);
-	if (!(phba->pport->work_port_events & WORKER_HB_TMO))
+	tmo_posted = phba->pport->work_port_events & WORKER_HB_TMO;
+	if (!tmo_posted)
 		phba->pport->work_port_events |= WORKER_HB_TMO;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
 
-	spin_lock_irqsave(&phba->hbalock, iflag);
-	if (phba->work_wait)
-		wake_up(phba->work_wait);
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
 	return;
 }
 
@@ -2104,6 +2104,9 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	phba->work_ha_mask = (HA_ERATT|HA_MBATT|HA_LATT);
 	phba->work_ha_mask |= (HA_RXMASK << (LPFC_ELS_RING * 4));
 
+	/* Initialize the wait queue head for the kernel thread */
+	init_waitqueue_head(&phba->work_waitq);
+
 	/* Startup the kernel thread for this host adapter. */
 	phba->worker_thread = kthread_run(lpfc_do_work, phba,
 				       "lpfc_worker_%d", phba->brd_no);
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-06-14 22:16:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-06-14 22:23:56.000000000 -0400
@@ -50,6 +50,7 @@ void
 lpfc_adjust_queue_depth(struct lpfc_hba *phba)
 {
 	unsigned long flags;
+	uint32_t evt_posted;
 
 	spin_lock_irqsave(&phba->hbalock, flags);
 	atomic_inc(&phba->num_rsrc_err);
@@ -65,17 +66,13 @@ lpfc_adjust_queue_depth(struct lpfc_hba 
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	spin_lock_irqsave(&phba->pport->work_port_lock, flags);
-	if ((phba->pport->work_port_events &
-		WORKER_RAMP_DOWN_QUEUE) == 0) {
+	evt_posted = phba->pport->work_port_events & WORKER_RAMP_DOWN_QUEUE;
+	if (!evt_posted)
 		phba->pport->work_port_events |= WORKER_RAMP_DOWN_QUEUE;
-	}
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, flags);
 
-	spin_lock_irqsave(&phba->hbalock, flags);
-	if (phba->work_wait)
-		wake_up(phba->work_wait);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
-
+	if (!evt_posted)
+		lpfc_worker_wake_up(phba);
 	return;
 }
 
@@ -89,6 +86,7 @@ lpfc_rampup_queue_depth(struct lpfc_vpor
 {
 	unsigned long flags;
 	struct lpfc_hba *phba = vport->phba;
+	uint32_t evt_posted;
 	atomic_inc(&phba->num_cmd_success);
 
 	if (vport->cfg_lun_queue_depth <= sdev->queue_depth)
@@ -103,16 +101,14 @@ lpfc_rampup_queue_depth(struct lpfc_vpor
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	spin_lock_irqsave(&phba->pport->work_port_lock, flags);
-	if ((phba->pport->work_port_events &
-		WORKER_RAMP_UP_QUEUE) == 0) {
+	evt_posted = phba->pport->work_port_events & WORKER_RAMP_UP_QUEUE;
+	if (!evt_posted)
 		phba->pport->work_port_events |= WORKER_RAMP_UP_QUEUE;
-	}
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, flags);
 
-	spin_lock_irqsave(&phba->hbalock, flags);
-	if (phba->work_wait)
-		wake_up(phba->work_wait);
-	spin_unlock_irqrestore(&phba->hbalock, flags);
+	if (!evt_posted)
+		lpfc_worker_wake_up(phba);
+	return;
 }
 
 void
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-04-10 17:07:58.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-06-14 22:23:56.000000000 -0400
@@ -324,9 +324,7 @@ lpfc_sli_next_iocb_slot (struct lpfc_hba
 			phba->work_ha |= HA_ERATT;
 			phba->work_hs = HS_FFER3;
 
-			/* hbalock should already be held */
-			if (phba->work_wait)
-				lpfc_worker_wake_up(phba);
+			lpfc_worker_wake_up(phba);
 
 			return NULL;
 		}
@@ -1309,9 +1307,7 @@ lpfc_sli_rsp_pointers_error(struct lpfc_
 	phba->work_ha |= HA_ERATT;
 	phba->work_hs = HS_FFER3;
 
-	/* hbalock should already be held */
-	if (phba->work_wait)
-		lpfc_worker_wake_up(phba);
+	lpfc_worker_wake_up(phba);
 
 	return;
 }
@@ -2611,12 +2607,9 @@ lpfc_mbox_timeout(unsigned long ptr)
 		phba->pport->work_port_events |= WORKER_MBOX_TMO;
 	spin_unlock_irqrestore(&phba->pport->work_port_lock, iflag);
 
-	if (!tmo_posted) {
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		if (phba->work_wait)
-			lpfc_worker_wake_up(phba);
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
-	}
+	if (!tmo_posted)
+		lpfc_worker_wake_up(phba);
+	return;
 }
 
 void
@@ -3374,8 +3367,12 @@ lpfc_sli_host_down(struct lpfc_vport *vp
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
 		prev_pring_flag = pring->flag;
-		if (pring->ringno == LPFC_ELS_RING) /* Only slow rings */
+		/* Only slow rings */
+		if (pring->ringno == LPFC_ELS_RING) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
+			/* Set the lpfc data pending flag */
+			set_bit(LPFC_DATA_READY, &phba->data_flags);
+		}
 		/*
 		 * Error everything on the txq since these iocbs have not been
 		 * given to the FW yet.
@@ -3434,8 +3431,12 @@ lpfc_sli_hba_down(struct lpfc_hba *phba)
 	spin_lock_irqsave(&phba->hbalock, flags);
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
-		if (pring->ringno == LPFC_ELS_RING) /* Only slow rings */
+		/* Only slow rings */
+		if (pring->ringno == LPFC_ELS_RING) {
 			pring->flag |= LPFC_DEFERRED_RING_EVENT;
+			/* Set the lpfc data pending flag */
+			set_bit(LPFC_DATA_READY, &phba->data_flags);
+		}
 
 		/*
 		 * Error everything on the txq since these iocbs have not been
@@ -4159,7 +4160,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 						"pwork:x%x hawork:x%x wait:x%x",
 						phba->work_ha, work_ha_copy,
 						(uint32_t)((unsigned long)
-						phba->work_wait));
+						&phba->work_waitq));
 
 					control &=
 					    ~(HC_R0INT_ENA << LPFC_ELS_RING);
@@ -4172,7 +4173,7 @@ lpfc_intr_handler(int irq, void *dev_id)
 						"x%x hawork:x%x wait:x%x",
 						phba->work_ha, work_ha_copy,
 						(uint32_t)((unsigned long)
-						phba->work_wait));
+						&phba->work_waitq));
 				}
 				spin_unlock(&phba->hbalock);
 			}
@@ -4297,9 +4298,8 @@ send_current_mbox:
 
 		spin_lock(&phba->hbalock);
 		phba->work_ha |= work_ha_copy;
-		if (phba->work_wait)
-			lpfc_worker_wake_up(phba);
 		spin_unlock(&phba->hbalock);
+		lpfc_worker_wake_up(phba);
 	}
 
 	ha_copy &= ~(phba->work_ha_mask);


