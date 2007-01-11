From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 12/21] libsas: Delay issuing ABORT TASK TMF until the error handler
Date: Thu, 11 Jan 2007 14:15:20 -0800
Message-ID: <20070111221520.3543.15883.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46017 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbXAKWPC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:02 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFYXh020877
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:34 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMF0ti304064
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:00 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMF0o8010885
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:00 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


sas_task_abort() should simply abort the upper-level SCSI command and wait
until the error handler to send the actual ABORT TASK command.  By
deferring things to the EH we simplify the concurrency coordination and
eliminate some race conditions.  Note that sas_task_abort has a few hooks
to handle libsas internal commands properly too.

Also rename do_sas_task_abort to __sas_task_abort just in case we really
want to abort the task *right now* and we don't have a scsi_cmnd attached
to the command.  This is a hook for libata internal commands to abort.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   51 ++++++++++++++++++++---------------
 include/scsi/libsas.h               |    3 +-
 2 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index d0c04eb..f867455 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -560,6 +560,7 @@ enum scsi_eh_timer_return sas_scsi_timed
 	}
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
+	BUG_ON(task->task_state_flags & SAS_TASK_STATE_ABORTED);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		SAS_DPRINTK("command 0x%p, task 0x%p, timed out: EH_HANDLED\n",
@@ -830,44 +831,42 @@ void sas_shutdown_queue(struct sas_ha_st
 	spin_unlock_irqrestore(&core->task_queue_lock, flags);
 }
 
-static int do_sas_task_abort(struct sas_task *task)
+/*
+ * Call the LLDD task abort routine directly.  This function is intended for
+ * use by upper layers that need to tell the LLDD to abort a task.
+ */
+int __sas_task_abort(struct sas_task *task)
 {
-	struct scsi_cmnd *sc = task->uldd_task;
 	struct sas_internal *si =
 		to_sas_internal(task->dev->port->ha->core.shost->transportt);
 	unsigned long flags;
 	int res;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+	if (task->task_state_flags & SAS_TASK_STATE_ABORTED ||
+	    task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		SAS_DPRINTK("%s: Task %p already aborted.\n", __FUNCTION__,
+		SAS_DPRINTK("%s: Task %p already finished.\n", __FUNCTION__,
 			    task);
 		return 0;
 	}
-
-	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
-		task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	if (!si->dft->lldd_abort_task)
 		return -ENODEV;
 
 	res = si->dft->lldd_abort_task(task);
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
 	if ((task->task_state_flags & SAS_TASK_STATE_DONE) ||
 	    (res == TMF_RESP_FUNC_COMPLETE))
 	{
-		/* SMP commands don't have scsi_cmds(?) */
-		if (!sc) {
-			task->task_done(task);
-			return 0;
-		}
-		scsi_req_abort_cmd(sc);
-		scsi_schedule_eh(sc->device->host);
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		task->task_done(task);
 		return 0;
 	}
 
-	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (!(task->task_state_flags & SAS_TASK_STATE_DONE))
 		task->task_state_flags &= ~SAS_TASK_STATE_ABORTED;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -875,17 +874,24 @@ static int do_sas_task_abort(struct sas_
 	return -EAGAIN;
 }
 
-void sas_task_abort(struct work_struct *work)
+/*
+ * Tell an upper layer that it needs to initiate an abort for a given task.
+ * This should only ever be called by an LLDD.
+ */
+void sas_task_abort(struct sas_task *task)
 {
-	struct sas_task *task =
-		container_of(work, struct sas_task, abort_work);
-	int i;
+	struct scsi_cmnd *sc = task->uldd_task;
 
-	for (i = 0; i < 5; i++)
-		if (!do_sas_task_abort(task))
+	/* Escape for libsas internal commands */
+	if (!sc) {
+		if (!del_timer(&task->timer))
 			return;
+		task->timer.function(task->timer.data);
+		return;
+	}
 
-	SAS_DPRINTK("%s: Could not kill task!\n", __FUNCTION__);
+	scsi_req_abort_cmd(sc);
+	scsi_schedule_eh(sc->device->host);
 }
 
 EXPORT_SYMBOL_GPL(sas_queuecommand);
@@ -895,6 +901,7 @@ EXPORT_SYMBOL_GPL(sas_slave_destroy);
 EXPORT_SYMBOL_GPL(sas_change_queue_depth);
 EXPORT_SYMBOL_GPL(sas_change_queue_type);
 EXPORT_SYMBOL_GPL(sas_bios_param);
+EXPORT_SYMBOL_GPL(__sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
 EXPORT_SYMBOL_GPL(sas_phy_enable);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 75df71f..c834263 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -650,6 +650,7 @@ void sas_unregister_dev(struct domain_de
 
 void sas_init_dev(struct domain_device *);
 
-void sas_task_abort(struct work_struct *);
+void sas_task_abort(struct sas_task *);
+int __sas_task_abort(struct sas_task *);
 
 #endif /* _SASLIB_H_ */
