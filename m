From: "Infante, Jon" <Jon.Infante@Emulex.Com>
Subject: DPC vs tasklet
Date: Thu, 20 May 2004 09:52:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8D43EFD7CCBDB24980134BE078C227E704E37AEB@xcm.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:37271 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265210AbUETQwn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 12:52:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, "Smart, James" <James.Smart@Emulex.Com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Christoph,

I was going to take your advice:
"usage of tasklet itself is questionable, you probably want a kernel-thread"

and redo our driver bottom half discovery handler to use a DPC. I just
wanted to get your opinion of why usage of a tasklet is questionable. Some
of the LINUX documentation I've read states "tasklets are the preferred
mechanism with which to implement your bottom half for a normal hardware
device". I can see, as you stated, being in user context will help with
things like allowing the use of GFP_KERNEL for memory allocations or safe
calling of del_timer_sync(); but its not real clear to me what all the
tradeoffs are and why some people think tasklets are the preferred
mechanism. Can you shed some more light on this or direct me to some URLs
with more info.

Jon Infante
Emulex


-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Tuesday, May 18, 2004 5:08 AM
To: Smart, James
Cc: 'linux-scsi@vger.kernel.org'
Subject: Re: [(re)Announce] Emulex LightPulse Device Driver


Okay, I took a look at the tasklet handling and have re-arranged it a litte:

 - unused member task_discq_cnt of lpfcHBA_t removed
 - lpfc_discq_tasklet merged into lpfc_discq_post_event and streamlined
 - splice the list in lpfc_tasklet to shorten lock holding (and irq
disabling)
   time
 - use list_for_each_entry to be readable
 - split into subfunctions

I'm still far less than happy with the whole tasklet code, though:

 - lpfc_discq_post_event allocates a structure for every event from irq
   kontext.  Look at qla2xxx how to embedd the lists into the actual
   object to solve this (OTOH qla2xxx is much much nicer in that respect
   anyway as there's only one type of object queued up from the isr to
   the dpc thread)
 - usage of tasklet itself is questionable, you probably want a
kernel-thread
   ala qla2xxx so it's always in usercontext, making your life much easier
   in many places
 - phba->tasklet_running is a mess.  You couldn't care less whether the
   tasklet is running but rather you want to know whether you're called from
   it.


diff -urp lpfcdriver-2.6-8.0.1/lpfc.h lpfcdriver-2.6-8.0.1.hch/lpfc.h
--- lpfcdriver-2.6-8.0.1/lpfc.h	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc.h	2004-05-18 13:23:37.491363504 +0200
@@ -399,7 +399,6 @@ typedef struct lpfcHBA {
 	spinlock_t            task_lock;
 	struct tasklet_struct task_run;
 	struct list_head      task_disc;
-	uint16_t              task_discq_cnt;
 	uint16_t	      tasklet_running;
 
 	atomic_t cmnds_in_flight;
diff -urp lpfcdriver-2.6-8.0.1/lpfc_fcp.c
lpfcdriver-2.6-8.0.1.hch/lpfc_fcp.c
--- lpfcdriver-2.6-8.0.1/lpfc_fcp.c	2004-05-16 20:03:37.000000000 +0200
+++ lpfcdriver-2.6-8.0.1.hch/lpfc_fcp.c	2004-05-18 13:55:23.843553920 +0200
@@ -2097,111 +2097,98 @@ lpfc_sleep(lpfcHBA_t * phba, void *wait_
 		return (ETIMEDOUT);
 }
 
-void
-lpfc_discq_tasklet(lpfcHBA_t * phba, LPFC_DISC_EVT_t * evtp)
+int
+lpfc_discq_post_event(lpfcHBA_t * phba, void *arg1, void *arg2, uint32_t
evt)
 {
-	unsigned long flags;
+	LPFC_DISC_EVT_t	*evtp;
+	unsigned long	flags;
+
+	/*
+	 * All Mailbox completions and LPFC_ELS_RING rcv ring events will be
+	 * queued to tasklet for processing
+	 */
+	evtp = kmalloc(sizeof(LPFC_DISC_EVT_t), GFP_ATOMIC);
+	if (unlikely(!evtp))
+		return 0;
+
+	evtp->evt_arg1  = arg1;
+	evtp->evt_arg2  = arg2;
+	evtp->evt       = evt;
 
-	/* Queue the cmnd to the iodone tasklet to be scheduled later */
 	spin_lock_irqsave(&phba->task_lock, flags);
 	list_add_tail(&evtp->evt_listp, &phba->task_disc);
-	phba->task_discq_cnt++;
 	spin_unlock_irqrestore(&phba->task_lock, flags);
+
 	tasklet_schedule(&phba->task_run);
-	return;
+	return 1;
 }
 
-int
-lpfc_discq_post_event(lpfcHBA_t * phba, void *arg1, void *arg2, uint32_t
evt)
+static void
+lpfc_process_evt_mbox(lpfcHBA_t *phba, LPFC_MBOXQ_t *pmb)
+{
+	pmb->mbox_cmpl(phba, pmb);
+}
+
+static void
+lpfc_process_evt_iocb(lpfcHBA_t *phba, LPFC_IOCBQ_t *cmdiocbp,
+		LPFC_RING_MASK_t *func, LPFC_IOCBQ_t *saveq)
 {
-	LPFC_DISC_EVT_t  *evtp;
+	LPFC_IOCBQ_t		*rspiocbp, *tmp;
 
-	/* All Mailbox completions and LPFC_ELS_RING rcv ring events will be
-	 * queued to tasklet for processing
-	 */
-	evtp = (LPFC_DISC_EVT_t *) kmalloc(sizeof(LPFC_DISC_EVT_t),
GFP_ATOMIC);
-	if(evtp == 0) {
-		return (0);
+	if (func) {
+		func->lpfc_sli_rcv_unsol_event(phba,
+				&phba->sli.ring[LPFC_ELS_RING], saveq);
+	} else {
+		cmdiocbp->iocb_cmpl(phba, cmdiocbp, saveq);
 	}
-	evtp->evt_arg1  = arg1;
-	evtp->evt_arg2  = arg2;
-	evtp->evt       = evt;
-	evtp->evt_listp.next = 0;
-	evtp->evt_listp.prev = 0;
-	lpfc_discq_tasklet(phba, evtp);
-	return (1);
+
+	/* free up iocb buffer chain for command just processed */
+	list_for_each_entry_safe(rspiocbp, tmp, &saveq->list, list) {
+		list_del(&rspiocbp->list);
+		mempool_free(rspiocbp, phba->iocb_mem_pool);
+	}
+
+	mempool_free(saveq, phba->iocb_mem_pool);
 }
 
 void
 lpfc_tasklet(unsigned long p)
 {
-	lpfcHBA_t        * phba = (lpfcHBA_t *)p;
-	LPFC_SLI_t       * psli;
-	LPFC_DISC_EVT_t  * evtp;
-	struct list_head * pos, * pos_tmp;
-	struct list_head * cur, * next;
-	LPFC_MBOXQ_t     * pmb;
-	LPFC_IOCBQ_t     * cmdiocbp;
-	LPFC_IOCBQ_t     * rspiocbp;
-	LPFC_IOCBQ_t     * saveq;
-	LPFC_RING_MASK_t * func;
-	unsigned long      flags;
+	lpfcHBA_t	*phba = (lpfcHBA_t *)p;
+	LPFC_DISC_EVT_t	*evtp, *evtp_tmp;
+	unsigned long	flags;
+	LIST_HEAD	(local_task_q);
 
-	psli = &phba->sli;
 	spin_lock_irqsave(&phba->task_lock, flags);
+	list_splice_init(&phba->task_disc, &local_task_q);
+	spin_unlock_irqrestore(&phba->task_lock, flags);
+
 	/* check discovery event list */
-	list_for_each_safe(pos, pos_tmp, &phba->task_disc) {
-		evtp = list_entry(pos, LPFC_DISC_EVT_t, evt_listp);
+	list_for_each_entry_safe(evtp, evtp_tmp, &local_task_q, evt_listp) {
 		list_del(&evtp->evt_listp);
-		phba->task_discq_cnt--;
-		spin_unlock_irqrestore(&phba->task_lock, flags);
 
-		spin_lock_irqsave(&(phba->drvrlock), flags);
-		phba->tasklet_running += 1;
-		switch(evtp->evt) {
+		spin_lock_irqsave(&phba->drvrlock, flags);
+		phba->tasklet_running++;
+		switch (evtp->evt) {
 		case LPFC_EVT_MBOX:
-			pmb = (LPFC_MBOXQ_t *)(evtp->evt_arg1);
-			(pmb->mbox_cmpl) (phba, pmb);
+			lpfc_process_evt_mbox(phba, evtp->evt_arg1);
 			break;
 		case LPFC_EVT_SOL_IOCB:
-			cmdiocbp = (LPFC_IOCBQ_t *)(evtp->evt_arg1);
-			saveq = (LPFC_IOCBQ_t *)(evtp->evt_arg2);
-			(cmdiocbp->iocb_cmpl) (phba, cmdiocbp, saveq);
-			/* Free up iocb buffer chain for command just
-			   processed */
-			list_for_each_safe(cur, next, &saveq->list) {
-				rspiocbp = list_entry(cur, LPFC_IOCBQ_t,
list);
-				list_del(&rspiocbp->list);
-				mempool_free( rspiocbp,
phba->iocb_mem_pool);
-			}
-			mempool_free( saveq, phba->iocb_mem_pool);
+			lpfc_process_evt_iocb(phba, evtp->evt_arg1,
+					NULL, evtp->evt_arg2);
 			break;
 		case LPFC_EVT_UNSOL_IOCB:
-			func = (LPFC_RING_MASK_t *)(evtp->evt_arg1);
-			saveq = (LPFC_IOCBQ_t *)(evtp->evt_arg2);
-			(func->lpfc_sli_rcv_unsol_event) (phba, 
-	 		&psli->ring[LPFC_ELS_RING], saveq);
-			/* Free up iocb buffer chain for command just
-			   processed */
-			list_for_each_safe(cur, next, &saveq->list) {
-				rspiocbp = list_entry(cur, LPFC_IOCBQ_t,
list);
-				list_del(&rspiocbp->list);
-				mempool_free( rspiocbp,
phba->iocb_mem_pool);
-			}
-			mempool_free( saveq, phba->iocb_mem_pool);
+			lpfc_process_evt_iocb(phba, NULL,
+					evtp->evt_arg1, evtp->evt_arg2);
 			break;
 		}
-		phba->tasklet_running -= 1;
-		spin_unlock_irqrestore(&(phba->drvrlock), flags);
+		phba->tasklet_running--;
+		spin_unlock_irqrestore(&phba->drvrlock, flags);
 
-		spin_lock_irqsave(&phba->task_lock, flags);
 		kfree(evtp);
 	}
-	spin_unlock_irqrestore(&phba->task_lock, flags);
-	return;
 }
 
-
 module_init(lpfc_init);
 module_exit(lpfc_exit);
 MODULE_LICENSE("GPL");
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
