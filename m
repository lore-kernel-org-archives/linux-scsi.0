From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] libsas: fix error handling
Date: Wed, 20 Feb 2008 10:07:50 -0600
Message-ID: <1203523670.3109.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33979 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbYBTQH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 11:07:57 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 4605690E1
	for <linux-scsi@vger.kernel.org>; Wed, 20 Feb 2008 10:07:52 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IZ2lcwutxy00 for <linux-scsi@vger.kernel.org>;
	Wed, 20 Feb 2008 10:07:51 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 0AFDF8035
	for <linux-scsi@vger.kernel.org>; Wed, 20 Feb 2008 10:07:51 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The libsas error handler has two fairly fatal bugs

1. scsi_sas_task_done calls scsi_eh_finish_cmd() too early.  This
   happens if the task completes after it has been aborted but before
   the error handler starts up.  Because scsi_eh_finish_cmd()
   decrements host_failed and adds the task to the done list, the
   error handler start check (host_failed == host_busy) never passes
   and the eh never starts.

2. The multiple task completion paths sas_scsi_clear_queue_... all
   simply delete the task from the error queue.  This causes it to
   disappear into the ether, since a command must be placed on the
   done queue to be finished off by the error handler.  This behaviour
   causes the HBA to hang on pending commands.

Fix 1. by removing the SAS_TASK_STATE_ABORTED check and calling
->scsi_done() unconditionally (it is a nop if the timer has fired).
This keeps the task in the error handling queue until the eh starts.

Fix 2. by making sure every task goes through task complete followed
by scsi_eh_finish_cmd().

Tested this by firing resets across a disk running a hammer test (now
it actually survives without hanging the system)

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   53 +++++++++++++++++++----------------
 1 files changed, 29 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f869fba..b656e29 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -51,8 +51,6 @@ static void sas_scsi_task_done(struct sas_task *task)
 {
 	struct task_status_struct *ts = &task->task_status;
 	struct scsi_cmnd *sc = task->uldd_task;
-	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(sc->device->host);
-	unsigned ts_flags = task->task_state_flags;
 	int hs = 0, stat = 0;
 
 	if (unlikely(!sc)) {
@@ -120,11 +118,7 @@ static void sas_scsi_task_done(struct sas_task *task)
 	sc->result = (hs << 16) | stat;
 	list_del_init(&task->list);
 	sas_free_task(task);
-	/* This is very ugly but this is how SCSI Core works. */
-	if (ts_flags & SAS_TASK_STATE_ABORTED)
-		scsi_eh_finish_cmd(sc, &sas_ha->eh_done_q);
-	else
-		sc->scsi_done(sc);
+	sc->scsi_done(sc);
 }
 
 static enum task_attribute sas_scsi_get_task_attr(struct scsi_cmnd *cmd)
@@ -255,13 +249,27 @@ out:
 	return res;
 }
 
+static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
+{
+	struct sas_task *task = TO_SAS_TASK(cmd);
+	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(cmd->device->host);
+
+	/* First off call task_done.  However, task will
+	 * be free'd after this */
+	task->task_done(task);
+	/* now finish the command and move it on to the error
+	 * handler done list, this also takes it off the
+	 * error handler pending list */
+	scsi_eh_finish_cmd(cmd, &sas_ha->eh_done_q);
+}
+
 static void sas_scsi_clear_queue_lu(struct list_head *error_q, struct scsi_cmnd *my_cmd)
 {
 	struct scsi_cmnd *cmd, *n;
 
 	list_for_each_entry_safe(cmd, n, error_q, eh_entry) {
 		if (cmd == my_cmd)
-			list_del_init(&cmd->eh_entry);
+			sas_eh_finish_cmd(cmd);
 	}
 }
 
@@ -274,7 +282,7 @@ static void sas_scsi_clear_queue_I_T(struct list_head *error_q,
 		struct domain_device *x = cmd_to_domain_dev(cmd);
 
 		if (x == dev)
-			list_del_init(&cmd->eh_entry);
+			sas_eh_finish_cmd(cmd);
 	}
 }
 
@@ -288,7 +296,7 @@ static void sas_scsi_clear_queue_port(struct list_head *error_q,
 		struct asd_sas_port *x = dev->port;
 
 		if (x == port)
-			list_del_init(&cmd->eh_entry);
+			sas_eh_finish_cmd(cmd);
 	}
 }
 
@@ -528,14 +536,14 @@ Again:
 		case TASK_IS_DONE:
 			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
 				    task);
-			task->task_done(task);
+			sas_eh_finish_cmd(cmd);
 			if (need_reset)
 				try_to_reset_cmd_device(shost, cmd);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
 				    __FUNCTION__, task);
-			task->task_done(task);
+			sas_eh_finish_cmd(cmd);
 			if (need_reset)
 				try_to_reset_cmd_device(shost, cmd);
 			continue;
@@ -547,7 +555,7 @@ Again:
 					    "recovered\n",
 					    SAS_ADDR(task->dev),
 					    cmd->device->lun);
-				task->task_done(task);
+				sas_eh_finish_cmd(cmd);
 				if (need_reset)
 					try_to_reset_cmd_device(shost, cmd);
 				sas_scsi_clear_queue_lu(work_q, cmd);
@@ -562,7 +570,7 @@ Again:
 			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
 				SAS_DPRINTK("I_T %016llx recovered\n",
 					    SAS_ADDR(task->dev->sas_addr));
-				task->task_done(task);
+				sas_eh_finish_cmd(cmd);
 				if (need_reset)
 					try_to_reset_cmd_device(shost, cmd);
 				sas_scsi_clear_queue_I_T(work_q, task->dev);
@@ -577,7 +585,7 @@ Again:
 				if (res == TMF_RESP_FUNC_COMPLETE) {
 					SAS_DPRINTK("clear nexus port:%d "
 						    "succeeded\n", port->id);
-					task->task_done(task);
+					sas_eh_finish_cmd(cmd);
 					if (need_reset)
 						try_to_reset_cmd_device(shost, cmd);
 					sas_scsi_clear_queue_port(work_q,
@@ -591,10 +599,10 @@ Again:
 				if (res == TMF_RESP_FUNC_COMPLETE) {
 					SAS_DPRINTK("clear nexus ha "
 						    "succeeded\n");
-					task->task_done(task);
+					sas_eh_finish_cmd(cmd);
 					if (need_reset)
 						try_to_reset_cmd_device(shost, cmd);
-					goto out;
+					goto clear_q;
 				}
 			}
 			/* If we are here -- this means that no amount
@@ -606,21 +614,18 @@ Again:
 				    SAS_ADDR(task->dev->sas_addr),
 				    cmd->device->lun);
 
-			task->task_done(task);
+			sas_eh_finish_cmd(cmd);
 			if (need_reset)
 				try_to_reset_cmd_device(shost, cmd);
 			goto clear_q;
 		}
 	}
-out:
 	return list_empty(work_q);
 clear_q:
 	SAS_DPRINTK("--- Exit %s -- clear_q\n", __FUNCTION__);
-	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
-		struct sas_task *task = TO_SAS_TASK(cmd);
-		list_del_init(&cmd->eh_entry);
-		task->task_done(task);
-	}
+	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
+		sas_eh_finish_cmd(cmd);
+
 	return list_empty(work_q);
 }
 
-- 
1.5.4.1



