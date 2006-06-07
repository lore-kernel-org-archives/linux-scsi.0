From: Brian King <brking@us.ibm.com>
Subject: [PATCH 2/6] libata: Add host lock to struct ata_port
Date: Wed, 07 Jun 2006 11:25:39 -0500
Message-ID: <200606071625.k57GPeTc014015@d01av01.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Prepare for changes required to support SATA devices
attached to SAS HBAs. For these devices we don't want to
use host_set at all, since libata will not be the owner
of struct scsi_host.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-bmdma.c |    5 +-
 libata-dev-bjking1/drivers/scsi/libata-core.c  |   35 +++++++++--------
 libata-dev-bjking1/drivers/scsi/libata-eh.c    |   49 ++++++++++++-------------
 libata-dev-bjking1/drivers/scsi/libata-scsi.c  |    4 +-
 libata-dev-bjking1/include/linux/libata.h      |    1 
 5 files changed, 47 insertions(+), 47 deletions(-)

diff -puN include/linux/libata.h~libata_port_lock include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_port_lock	2006-06-06 08:55:39.000000000 -0500
+++ libata-dev-bjking1/include/linux/libata.h	2006-06-06 08:55:39.000000000 -0500
@@ -445,6 +445,7 @@ struct ata_eh_context {
 struct ata_port {
 	struct Scsi_Host	*host;	/* our co-allocated scsi host */
 	const struct ata_port_operations *ops;
+	spinlock_t		*lock;
 	unsigned long		flags;	/* ATA_FLAG_xxx */
 	unsigned int		id;	/* unique id req'd by scsi midlyr */
 	unsigned int		port_no; /* unique port #; from zero */
diff -puN drivers/scsi/libata-core.c~libata_port_lock drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_port_lock	2006-06-06 08:55:39.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-06 08:55:39.000000000 -0500
@@ -926,9 +926,9 @@ void ata_port_flush_task(struct ata_port
 
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags |= ATA_FLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
 	flush_workqueue(ata_wq);
@@ -943,9 +943,9 @@ void ata_port_flush_task(struct ata_port
 		flush_workqueue(ata_wq);
 	}
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags &= ~ATA_FLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("EXIT\n");
 }
@@ -990,11 +990,11 @@ unsigned ata_exec_internal(struct ata_de
 	unsigned int err_mask;
 	int rc;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	/* no internal command while frozen */
 	if (ap->flags & ATA_FLAG_FROZEN) {
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 		return AC_ERR_SYSTEM;
 	}
 
@@ -1043,14 +1043,14 @@ unsigned ata_exec_internal(struct ata_de
 
 	ata_qc_issue(qc);
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	rc = wait_for_completion_timeout(&wait, ATA_TMOUT_INTERNAL);
 
 	ata_port_flush_task(ap);
 
 	if (!rc) {
-		spin_lock_irqsave(&ap->host_set->lock, flags);
+		spin_lock_irqsave(ap->lock, flags);
 
 		/* We're racing with irq here.  If we lose, the
 		 * following test prevents us from completing the qc
@@ -1069,7 +1069,7 @@ unsigned ata_exec_internal(struct ata_de
 				       "qc timeout (cmd 0x%x)\n", command);
 		}
 
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 	}
 
 	/* do post_internal_cmd */
@@ -1083,7 +1083,7 @@ unsigned ata_exec_internal(struct ata_de
 	}
 
 	/* finish up */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	*tf = qc->result_tf;
 	err_mask = qc->err_mask;
@@ -1109,7 +1109,7 @@ unsigned ata_exec_internal(struct ata_de
 		ata_port_probe(ap);
 	}
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	return err_mask;
 }
@@ -3945,7 +3945,7 @@ static void ata_hsm_qc_complete(struct a
 
 	if (ap->ops->error_handler) {
 		if (in_wq) {
-			spin_lock_irqsave(&ap->host_set->lock, flags);
+			spin_lock_irqsave(ap->lock, flags);
 
 			/* EH might have kicked in while host_set lock
 			 * is released.
@@ -3959,7 +3959,7 @@ static void ata_hsm_qc_complete(struct a
 					ata_port_freeze(ap);
 			}
 
-			spin_unlock_irqrestore(&ap->host_set->lock, flags);
+			spin_unlock_irqrestore(ap->lock, flags);
 		} else {
 			if (likely(!(qc->err_mask & AC_ERR_HSM)))
 				ata_qc_complete(qc);
@@ -3968,10 +3968,10 @@ static void ata_hsm_qc_complete(struct a
 		}
 	} else {
 		if (in_wq) {
-			spin_lock_irqsave(&ap->host_set->lock, flags);
+			spin_lock_irqsave(ap->lock, flags);
 			ata_irq_on(ap);
 			ata_qc_complete(qc);
-			spin_unlock_irqrestore(&ap->host_set->lock, flags);
+			spin_unlock_irqrestore(ap->lock, flags);
 		} else
 			ata_qc_complete(qc);
 	}
@@ -4052,7 +4052,7 @@ fsm_start:
 		 * hsm_task_state is changed. Hence, the following locking.
 		 */
 		if (in_wq)
-			spin_lock_irqsave(&ap->host_set->lock, flags);
+			spin_lock_irqsave(ap->lock, flags);
 
 		if (qc->tf.protocol == ATA_PROT_PIO) {
 			/* PIO data out protocol.
@@ -4071,7 +4071,7 @@ fsm_start:
 			atapi_send_cdb(ap, qc);
 
 		if (in_wq)
-			spin_unlock_irqrestore(&ap->host_set->lock, flags);
+			spin_unlock_irqrestore(ap->lock, flags);
 
 		/* if polling, ata_pio_task() handles the rest.
 		 * otherwise, interrupt handler takes over from here.
@@ -5169,6 +5169,7 @@ static void ata_host_init(struct ata_por
 	host->unique_id = ata_unique_id++;
 	host->max_cmd_len = 12;
 
+	ap->lock = &host_set->lock;
 	ap->flags = ATA_FLAG_DISABLED;
 	ap->id = host->unique_id;
 	ap->host = host;
diff -puN drivers/scsi/libata-scsi.c~libata_port_lock drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_port_lock	2006-06-06 08:55:39.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-06-06 08:55:39.000000000 -0500
@@ -2630,7 +2630,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 	ap = ata_shost_to_port(shost);
 
 	spin_unlock(shost->host_lock);
-	spin_lock(&ap->host_set->lock);
+	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
 
@@ -2642,7 +2642,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 		done(cmd);
 	}
 
-	spin_unlock(&ap->host_set->lock);
+	spin_unlock(ap->lock);
 	spin_lock(shost->host_lock);
 	return rc;
 }
diff -puN drivers/scsi/libata-eh.c~libata_port_lock drivers/scsi/libata-eh.c
--- libata-dev/drivers/scsi/libata-eh.c~libata_port_lock	2006-06-06 08:55:39.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-eh.c	2006-06-06 08:55:39.000000000 -0500
@@ -127,7 +127,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 	}
 
 	ret = EH_HANDLED;
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	qc = ata_qc_from_tag(ap, ap->active_tag);
 	if (qc) {
 		WARN_ON(qc->scsicmd != cmd);
@@ -135,7 +135,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 		qc->err_mask |= AC_ERR_TIMEOUT;
 		ret = EH_NOT_HANDLED;
 	}
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
  out:
 	DPRINTK("EXIT, ret=%d\n", ret);
@@ -157,7 +157,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 void ata_scsi_error(struct Scsi_Host *host)
 {
 	struct ata_port *ap = ata_shost_to_port(host);
-	spinlock_t *hs_lock = &ap->host_set->lock;
+	spinlock_t *ap_lock = ap->lock;
 	int i, repeat_cnt = ATA_EH_MAX_REPEAT;
 	unsigned long flags;
 
@@ -184,7 +184,7 @@ void ata_scsi_error(struct Scsi_Host *ho
 		struct scsi_cmnd *scmd, *tmp;
 		int nr_timedout = 0;
 
-		spin_lock_irqsave(hs_lock, flags);
+		spin_lock_irqsave(ap_lock, flags);
 
 		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
 			struct ata_queued_cmd *qc;
@@ -223,15 +223,15 @@ void ata_scsi_error(struct Scsi_Host *ho
 		if (nr_timedout)
 			__ata_port_freeze(ap);
 
-		spin_unlock_irqrestore(hs_lock, flags);
+		spin_unlock_irqrestore(ap_lock, flags);
 	} else
-		spin_unlock_wait(hs_lock);
+		spin_unlock_wait(ap_lock);
 
  repeat:
 	/* invoke error handler */
 	if (ap->ops->error_handler) {
 		/* fetch & clear EH info */
-		spin_lock_irqsave(hs_lock, flags);
+		spin_lock_irqsave(ap_lock, flags);
 
 		memset(&ap->eh_context, 0, sizeof(ap->eh_context));
 		ap->eh_context.i = ap->eh_info;
@@ -239,7 +239,7 @@ void ata_scsi_error(struct Scsi_Host *ho
 
 		ap->flags &= ~ATA_FLAG_EH_PENDING;
 
-		spin_unlock_irqrestore(hs_lock, flags);
+		spin_unlock_irqrestore(ap_lock, flags);
 
 		/* invoke EH */
 		ap->ops->error_handler(ap);
@@ -248,14 +248,14 @@ void ata_scsi_error(struct Scsi_Host *ho
 		 * recovered the port but before this point.  Repeat
 		 * EH in such case.
 		 */
-		spin_lock_irqsave(hs_lock, flags);
+		spin_lock_irqsave(ap_lock, flags);
 
 		if (ap->flags & ATA_FLAG_EH_PENDING) {
 			if (--repeat_cnt) {
 				ata_port_printk(ap, KERN_INFO,
 					"EH pending after completion, "
 					"repeating EH (cnt=%d)\n", repeat_cnt);
-				spin_unlock_irqrestore(hs_lock, flags);
+				spin_unlock_irqrestore(ap_lock, flags);
 				goto repeat;
 			}
 			ata_port_printk(ap, KERN_ERR, "EH pending after %d "
@@ -265,14 +265,14 @@ void ata_scsi_error(struct Scsi_Host *ho
 		/* this run is complete, make sure EH info is clear */
 		memset(&ap->eh_info, 0, sizeof(ap->eh_info));
 
-		/* Clear host_eh_scheduled while holding hs_lock such
+		/* Clear host_eh_scheduled while holding ap_lock such
 		 * that if exception occurs after this point but
 		 * before EH completion, SCSI midlayer will
 		 * re-initiate EH.
 		 */
 		host->host_eh_scheduled = 0;
 
-		spin_unlock_irqrestore(hs_lock, flags);
+		spin_unlock_irqrestore(ap_lock, flags);
 	} else {
 		WARN_ON(ata_qc_from_tag(ap, ap->active_tag) == NULL);
 		ap->ops->eng_timeout(ap);
@@ -284,13 +284,13 @@ void ata_scsi_error(struct Scsi_Host *ho
 	scsi_eh_flush_done_q(&ap->eh_done_q);
 
 	/* clean up */
-	spin_lock_irqsave(hs_lock, flags);
+	spin_lock_irqsave(ap_lock, flags);
 
 	if (ap->flags & ATA_FLAG_RECOVERED)
 		ata_port_printk(ap, KERN_INFO, "EH complete\n");
 	ap->flags &= ~ATA_FLAG_RECOVERED;
 
-	spin_unlock_irqrestore(hs_lock, flags);
+	spin_unlock_irqrestore(ap_lock, flags);
 
 	DPRINTK("EXIT\n");
 }
@@ -318,7 +318,6 @@ void ata_scsi_error(struct Scsi_Host *ho
 static void ata_qc_timeout(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct ata_host_set *host_set = ap->host_set;
 	u8 host_stat = 0, drv_stat;
 	unsigned long flags;
 
@@ -326,7 +325,7 @@ static void ata_qc_timeout(struct ata_qu
 
 	ap->hsm_task_state = HSM_ST_IDLE;
 
-	spin_lock_irqsave(&host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	switch (qc->tf.protocol) {
 
@@ -355,7 +354,7 @@ static void ata_qc_timeout(struct ata_qu
 		break;
 	}
 
-	spin_unlock_irqrestore(&host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_eh_qc_complete(qc);
 
@@ -542,9 +541,9 @@ void ata_eh_freeze_port(struct ata_port 
 	if (!ap->ops->error_handler)
 		return;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	__ata_port_freeze(ap);
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 /**
@@ -563,14 +562,14 @@ void ata_eh_thaw_port(struct ata_port *a
 	if (!ap->ops->error_handler)
 		return;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	ap->flags &= ~ATA_FLAG_FROZEN;
 
 	if (ap->ops->thaw)
 		ap->ops->thaw(ap);
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("ata%u port thawed\n", ap->id);
 }
@@ -586,11 +585,11 @@ static void __ata_eh_qc_complete(struct 
 	struct scsi_cmnd *scmd = qc->scsicmd;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	qc->scsidone = ata_eh_scsidone;
 	__ata_qc_complete(qc);
 	WARN_ON(ata_tag_valid(qc->tag));
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
 }
@@ -644,10 +643,10 @@ static void ata_eh_about_to_do(struct at
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->eh_info.action &= ~action;
 	ap->flags |= ATA_FLAG_RECOVERED;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 /**
diff -puN drivers/scsi/libata-bmdma.c~libata_port_lock drivers/scsi/libata-bmdma.c
--- libata-dev/drivers/scsi/libata-bmdma.c~libata_port_lock	2006-06-06 08:55:39.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-bmdma.c	2006-06-06 08:55:39.000000000 -0500
@@ -713,7 +713,6 @@ void ata_bmdma_thaw(struct ata_port *ap)
 void ata_bmdma_drive_eh(struct ata_port *ap, ata_reset_fn_t softreset,
 			ata_reset_fn_t hardreset, ata_postreset_fn_t postreset)
 {
-	struct ata_host_set *host_set = ap->host_set;
 	struct ata_eh_context *ehc = &ap->eh_context;
 	struct ata_queued_cmd *qc;
 	unsigned long flags;
@@ -724,7 +723,7 @@ void ata_bmdma_drive_eh(struct ata_port 
 		qc = NULL;
 
 	/* reset PIO HSM and stop DMA engine */
-	spin_lock_irqsave(&host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	ap->hsm_task_state = HSM_ST_IDLE;
 
@@ -753,7 +752,7 @@ void ata_bmdma_drive_eh(struct ata_port 
 	ata_chk_status(ap);
 	ap->ops->irq_clear(ap);
 
-	spin_unlock_irqrestore(&host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	if (thaw)
 		ata_eh_thaw_port(ap);
_
