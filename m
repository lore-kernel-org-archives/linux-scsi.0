From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/6] libata: Add host lock to struct ata_port
Date: Mon, 12 Jun 2006 14:54:10 -0500
Message-ID: <200606121954.k5CJsBSv010980@d03av02.boulder.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Prepare for changes required to support SATA devices
attached to SAS HBAs. For these devices we don't want to
use host_set at all, since libata will not be the owner
of struct scsi_host.

Acked-by: Jeff Garzik <jgarzik@pobox.com>

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-bmdma.c |    5 -
 libata-dev-bjking1/drivers/scsi/libata-core.c  |   55 ++++++++++-----------
 libata-dev-bjking1/drivers/scsi/libata-eh.c    |   65 ++++++++++++-------------
 libata-dev-bjking1/drivers/scsi/libata-scsi.c  |   20 +++----
 libata-dev-bjking1/include/linux/libata.h      |    1 
 5 files changed, 73 insertions(+), 73 deletions(-)

diff -puN include/linux/libata.h~libata_port_lock include/linux/libata.h
--- libata-dev/include/linux/libata.h~libata_port_lock	2006-06-12 11:23:37.000000000 -0500
+++ libata-dev-bjking1/include/linux/libata.h	2006-06-12 14:38:46.000000000 -0500
@@ -481,6 +481,7 @@ struct ata_eh_context {
 struct ata_port {
 	struct Scsi_Host	*host;	/* our co-allocated scsi host */
 	const struct ata_port_operations *ops;
+	spinlock_t		*lock;
 	unsigned long		flags;	/* ATA_FLAG_xxx */
 	unsigned int		id;	/* unique id req'd by scsi midlyr */
 	unsigned int		port_no; /* unique port #; from zero */
diff -puN drivers/scsi/libata-core.c~libata_port_lock drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_port_lock	2006-06-12 11:23:37.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-06-12 14:38:46.000000000 -0500
@@ -933,9 +933,9 @@ void ata_port_flush_task(struct ata_port
 
 	DPRINTK("ENTER\n");
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags |= ATA_FLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("flush #1\n");
 	flush_workqueue(ata_wq);
@@ -950,9 +950,9 @@ void ata_port_flush_task(struct ata_port
 		flush_workqueue(ata_wq);
 	}
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags &= ~ATA_FLAG_FLUSH_PORT_TASK;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	DPRINTK("EXIT\n");
 }
@@ -999,11 +999,11 @@ unsigned ata_exec_internal(struct ata_de
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
 
@@ -1052,14 +1052,14 @@ unsigned ata_exec_internal(struct ata_de
 
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
@@ -1078,7 +1078,7 @@ unsigned ata_exec_internal(struct ata_de
 				       "qc timeout (cmd 0x%x)\n", command);
 		}
 
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 	}
 
 	/* do post_internal_cmd */
@@ -1092,7 +1092,7 @@ unsigned ata_exec_internal(struct ata_de
 	}
 
 	/* finish up */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	*tf = qc->result_tf;
 	err_mask = qc->err_mask;
@@ -1118,7 +1118,7 @@ unsigned ata_exec_internal(struct ata_de
 		ata_port_probe(ap);
 	}
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	return err_mask;
 }
@@ -3913,7 +3913,7 @@ static void ata_hsm_qc_complete(struct a
 
 	if (ap->ops->error_handler) {
 		if (in_wq) {
-			spin_lock_irqsave(&ap->host_set->lock, flags);
+			spin_lock_irqsave(ap->lock, flags);
 
 			/* EH might have kicked in while host_set lock
 			 * is released.
@@ -3927,7 +3927,7 @@ static void ata_hsm_qc_complete(struct a
 					ata_port_freeze(ap);
 			}
 
-			spin_unlock_irqrestore(&ap->host_set->lock, flags);
+			spin_unlock_irqrestore(ap->lock, flags);
 		} else {
 			if (likely(!(qc->err_mask & AC_ERR_HSM)))
 				ata_qc_complete(qc);
@@ -3936,10 +3936,10 @@ static void ata_hsm_qc_complete(struct a
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
@@ -4019,7 +4019,7 @@ fsm_start:
 		 * hsm_task_state is changed. Hence, the following locking.
 		 */
 		if (in_wq)
-			spin_lock_irqsave(&ap->host_set->lock, flags);
+			spin_lock_irqsave(ap->lock, flags);
 
 		if (qc->tf.protocol == ATA_PROT_PIO) {
 			/* PIO data out protocol.
@@ -4038,7 +4038,7 @@ fsm_start:
 			atapi_send_cdb(ap, qc);
 
 		if (in_wq)
-			spin_unlock_irqrestore(&ap->host_set->lock, flags);
+			spin_unlock_irqrestore(ap->lock, flags);
 
 		/* if polling, ata_pio_task() handles the rest.
 		 * otherwise, interrupt handler takes over from here.
@@ -5130,9 +5130,9 @@ void ata_dev_init(struct ata_device *dev
 	 * requests which occur asynchronously.  Synchronize using
 	 * host_set lock.
 	 */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	dev->flags &= ~ATA_DFLAG_INIT_MASK;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	memset((void *)dev + ATA_DEVICE_CLEAR_OFFSET, 0,
 	       sizeof(*dev) - ATA_DEVICE_CLEAR_OFFSET);
@@ -5167,6 +5167,7 @@ static void ata_host_init(struct ata_por
 	host->unique_id = ata_unique_id++;
 	host->max_cmd_len = 12;
 
+	ap->lock = &host_set->lock;
 	ap->flags = ATA_FLAG_DISABLED;
 	ap->id = host->unique_id;
 	ap->host = host;
@@ -5388,7 +5389,7 @@ int ata_device_add(const struct ata_prob
 			ata_port_probe(ap);
 
 			/* kick EH for boot probing */
-			spin_lock_irqsave(&ap->host_set->lock, flags);
+			spin_lock_irqsave(ap->lock, flags);
 
 			ap->eh_info.probe_mask = (1 << ATA_MAX_DEVICES) - 1;
 			ap->eh_info.action |= ATA_EH_SOFTRESET;
@@ -5396,7 +5397,7 @@ int ata_device_add(const struct ata_prob
 			ap->flags |= ATA_FLAG_LOADING;
 			ata_port_schedule_eh(ap);
 
-			spin_unlock_irqrestore(&ap->host_set->lock, flags);
+			spin_unlock_irqrestore(ap->lock, flags);
 
 			/* wait for EH to finish */
 			ata_port_wait_eh(ap);
@@ -5460,29 +5461,29 @@ void ata_port_detach(struct ata_port *ap
 		return;
 
 	/* tell EH we're leaving & flush EH */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ap->flags |= ATA_FLAG_UNLOADING;
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_port_wait_eh(ap);
 
 	/* EH is now guaranteed to see UNLOADING, so no new device
 	 * will be attached.  Disable all existing devices.
 	 */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	for (i = 0; i < ATA_MAX_DEVICES; i++)
 		ata_dev_disable(&ap->device[i]);
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* Final freeze & EH.  All in-flight commands are aborted.  EH
 	 * will be skipped and retrials will be terminated with bad
 	 * target.
 	 */
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	ata_port_freeze(ap);	/* won't be thawed */
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_port_wait_eh(ap);
 
diff -puN drivers/scsi/libata-scsi.c~libata_port_lock drivers/scsi/libata-scsi.c
--- libata-dev/drivers/scsi/libata-scsi.c~libata_port_lock	2006-06-12 11:23:37.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-scsi.c	2006-06-12 14:38:46.000000000 -0500
@@ -752,7 +752,7 @@ void ata_scsi_slave_destroy(struct scsi_
 	if (!ap->ops->error_handler)
 		return;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	dev = __ata_scsi_find_dev(ap, sdev);
 	if (dev && dev->sdev) {
 		/* SCSI device already in CANCEL state, no need to offline it */
@@ -760,7 +760,7 @@ void ata_scsi_slave_destroy(struct scsi_
 		dev->flags |= ATA_DFLAG_DETACH;
 		ata_port_schedule_eh(ap);
 	}
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 /**
@@ -2684,7 +2684,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 	ap = ata_shost_to_port(shost);
 
 	spin_unlock(shost->host_lock);
-	spin_lock(&ap->host_set->lock);
+	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
 
@@ -2696,7 +2696,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *
 		done(cmd);
 	}
 
-	spin_unlock(&ap->host_set->lock);
+	spin_unlock(ap->lock);
 	spin_lock(shost->host_lock);
 	return rc;
 }
@@ -2858,7 +2858,7 @@ static void ata_scsi_remove_dev(struct a
 	 * increments reference counts regardless of device state.
 	 */
 	mutex_lock(&ap->host->scan_mutex);
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	/* clearing dev->sdev is protected by host_set lock */
 	sdev = dev->sdev;
@@ -2882,7 +2882,7 @@ static void ata_scsi_remove_dev(struct a
 		}
 	}
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 	mutex_unlock(&ap->host->scan_mutex);
 
 	if (sdev) {
@@ -2926,9 +2926,9 @@ void ata_scsi_hotplug(void *data)
 		if (!(dev->flags & ATA_DFLAG_DETACHED))
 			continue;
 
-		spin_lock_irqsave(&ap->host_set->lock, flags);
+		spin_lock_irqsave(ap->lock, flags);
 		dev->flags &= ~ATA_DFLAG_DETACHED;
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 
 		ata_scsi_remove_dev(dev);
 	}
@@ -2981,7 +2981,7 @@ static int ata_scsi_user_scan(struct Scs
 	    (lun != SCAN_WILD_CARD && lun != 0))
 		return -EINVAL;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	if (id == SCAN_WILD_CARD) {
 		ap->eh_info.probe_mask |= (1 << ATA_MAX_DEVICES) - 1;
@@ -2999,7 +2999,7 @@ static int ata_scsi_user_scan(struct Scs
 	if (rc == 0)
 		ata_port_schedule_eh(ap);
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	return rc;
 }
diff -puN drivers/scsi/libata-eh.c~libata_port_lock drivers/scsi/libata-eh.c
--- libata-dev/drivers/scsi/libata-eh.c~libata_port_lock	2006-06-12 11:23:37.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-eh.c	2006-06-12 11:23:37.000000000 -0500
@@ -128,7 +128,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 	}
 
 	ret = EH_HANDLED;
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	qc = ata_qc_from_tag(ap, ap->active_tag);
 	if (qc) {
 		WARN_ON(qc->scsicmd != cmd);
@@ -136,7 +136,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 		qc->err_mask |= AC_ERR_TIMEOUT;
 		ret = EH_NOT_HANDLED;
 	}
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
  out:
 	DPRINTK("EXIT, ret=%d\n", ret);
@@ -158,7 +158,7 @@ enum scsi_eh_timer_return ata_scsi_timed
 void ata_scsi_error(struct Scsi_Host *host)
 {
 	struct ata_port *ap = ata_shost_to_port(host);
-	spinlock_t *hs_lock = &ap->host_set->lock;
+	spinlock_t *ap_lock = ap->lock;
 	int i, repeat_cnt = ATA_EH_MAX_REPEAT;
 	unsigned long flags;
 
@@ -185,7 +185,7 @@ void ata_scsi_error(struct Scsi_Host *ho
 		struct scsi_cmnd *scmd, *tmp;
 		int nr_timedout = 0;
 
-		spin_lock_irqsave(hs_lock, flags);
+		spin_lock_irqsave(ap_lock, flags);
 
 		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
 			struct ata_queued_cmd *qc;
@@ -224,15 +224,15 @@ void ata_scsi_error(struct Scsi_Host *ho
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
@@ -241,7 +241,7 @@ void ata_scsi_error(struct Scsi_Host *ho
 		ap->flags |= ATA_FLAG_EH_IN_PROGRESS;
 		ap->flags &= ~ATA_FLAG_EH_PENDING;
 
-		spin_unlock_irqrestore(hs_lock, flags);
+		spin_unlock_irqrestore(ap_lock, flags);
 
 		/* invoke EH.  if unloading, just finish failed qcs */
 		if (!(ap->flags & ATA_FLAG_UNLOADING))
@@ -253,14 +253,14 @@ void ata_scsi_error(struct Scsi_Host *ho
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
@@ -270,14 +270,14 @@ void ata_scsi_error(struct Scsi_Host *ho
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
@@ -289,7 +289,7 @@ void ata_scsi_error(struct Scsi_Host *ho
 	scsi_eh_flush_done_q(&ap->eh_done_q);
 
 	/* clean up */
-	spin_lock_irqsave(hs_lock, flags);
+	spin_lock_irqsave(ap_lock, flags);
 
 	if (ap->flags & ATA_FLAG_LOADING) {
 		ap->flags &= ~ATA_FLAG_LOADING;
@@ -306,7 +306,7 @@ void ata_scsi_error(struct Scsi_Host *ho
 	ap->flags &= ~ATA_FLAG_EH_IN_PROGRESS;
 	wake_up_all(&ap->eh_wait_q);
 
-	spin_unlock_irqrestore(hs_lock, flags);
+	spin_unlock_irqrestore(ap_lock, flags);
 
 	DPRINTK("EXIT\n");
 }
@@ -326,17 +326,17 @@ void ata_port_wait_eh(struct ata_port *a
 	DEFINE_WAIT(wait);
 
  retry:
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	while (ap->flags & (ATA_FLAG_EH_PENDING | ATA_FLAG_EH_IN_PROGRESS)) {
 		prepare_to_wait(&ap->eh_wait_q, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock_irqrestore(&ap->host_set->lock, flags);
+		spin_unlock_irqrestore(ap->lock, flags);
 		schedule();
-		spin_lock_irqsave(&ap->host_set->lock, flags);
+		spin_lock_irqsave(ap->lock, flags);
 	}
 	finish_wait(&ap->eh_wait_q, &wait);
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	/* make sure SCSI EH is complete */
 	if (scsi_host_in_recovery(ap->host)) {
@@ -368,7 +368,6 @@ void ata_port_wait_eh(struct ata_port *a
 static void ata_qc_timeout(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
-	struct ata_host_set *host_set = ap->host_set;
 	u8 host_stat = 0, drv_stat;
 	unsigned long flags;
 
@@ -376,7 +375,7 @@ static void ata_qc_timeout(struct ata_qu
 
 	ap->hsm_task_state = HSM_ST_IDLE;
 
-	spin_lock_irqsave(&host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	switch (qc->tf.protocol) {
 
@@ -405,7 +404,7 @@ static void ata_qc_timeout(struct ata_qu
 		break;
 	}
 
-	spin_unlock_irqrestore(&host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	ata_eh_qc_complete(qc);
 
@@ -592,9 +591,9 @@ void ata_eh_freeze_port(struct ata_port 
 	if (!ap->ops->error_handler)
 		return;
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 	__ata_port_freeze(ap);
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 /**
@@ -613,14 +612,14 @@ void ata_eh_thaw_port(struct ata_port *a
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
@@ -636,11 +635,11 @@ static void __ata_eh_qc_complete(struct 
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
@@ -694,7 +693,7 @@ static void ata_eh_detach_dev(struct ata
 
 	ata_dev_disable(dev);
 
-	spin_lock_irqsave(&ap->host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	dev->flags &= ~ATA_DFLAG_DETACH;
 
@@ -703,7 +702,7 @@ static void ata_eh_detach_dev(struct ata
 		ap->flags |= ATA_FLAG_SCSI_HOTPLUG;
 	}
 
-	spin_unlock_irqrestore(&ap->host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 }
 
 /**
@@ -722,10 +721,10 @@ static void ata_eh_about_to_do(struct at
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
@@ -1570,9 +1569,9 @@ static int ata_eh_revalidate_and_attach(
 				break;
 			}
 
-			spin_lock_irqsave(&ap->host_set->lock, flags);
+			spin_lock_irqsave(ap->lock, flags);
 			ap->flags |= ATA_FLAG_SCSI_HOTPLUG;
-			spin_unlock_irqrestore(&ap->host_set->lock, flags);
+			spin_unlock_irqrestore(ap->lock, flags);
 		}
 	}
 
diff -puN drivers/scsi/libata-bmdma.c~libata_port_lock drivers/scsi/libata-bmdma.c
--- libata-dev/drivers/scsi/libata-bmdma.c~libata_port_lock	2006-06-12 11:23:37.000000000 -0500
+++ libata-dev-bjking1/drivers/scsi/libata-bmdma.c	2006-06-12 11:23:37.000000000 -0500
@@ -715,7 +715,6 @@ void ata_bmdma_drive_eh(struct ata_port 
 			ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
 			ata_postreset_fn_t postreset)
 {
-	struct ata_host_set *host_set = ap->host_set;
 	struct ata_eh_context *ehc = &ap->eh_context;
 	struct ata_queued_cmd *qc;
 	unsigned long flags;
@@ -726,7 +725,7 @@ void ata_bmdma_drive_eh(struct ata_port 
 		qc = NULL;
 
 	/* reset PIO HSM and stop DMA engine */
-	spin_lock_irqsave(&host_set->lock, flags);
+	spin_lock_irqsave(ap->lock, flags);
 
 	ap->hsm_task_state = HSM_ST_IDLE;
 
@@ -755,7 +754,7 @@ void ata_bmdma_drive_eh(struct ata_port 
 	ata_chk_status(ap);
 	ap->ops->irq_clear(ap);
 
-	spin_unlock_irqrestore(&host_set->lock, flags);
+	spin_unlock_irqrestore(ap->lock, flags);
 
 	if (thaw)
 		ata_eh_thaw_port(ap);
_
