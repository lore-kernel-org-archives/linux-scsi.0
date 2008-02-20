From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Tue, 19 Feb 2008 21:48:42 -0600
Message-ID: <1203479322.3103.53.camel@localhost.localdomain>
References: <479FB3ED.3080401@hopnet.net>
	 <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>
	 <20080130192947.GA21785@tree.beaverton.ibm.com>
	 <47B4682C.4020505@hopnet.net>
	 <1203089323.3058.20.camel@localhost.localdomain>
	 <47B9958A.8080104@hopnet.net>
	 <1203438140.3103.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42919 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751371AbYBTDst (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 22:48:49 -0500
In-Reply-To: <1203438140.3103.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Hopkins <vger@hopnet.net>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org

On Tue, 2008-02-19 at 10:22 -0600, James Bottomley wrote:
> I'll see if I can come up with patches to fix this ... or at least
> mitigate the problems it causes.

Darrick's working on the ascb sequencer use after free problem.

I looked into some of the error handling in libsas, and apparently
that's a bit of a huge screw up too.  There are a number of places where
we won't complete a task that is being errored out and thus causes
timeout errors.  This patch is actually for libsas to fix all of this.

I've managed to reproduce some of your problem by firing random resets
across a disk under load, and this recovers the protocol errors for me.
However, I can't reproduce the TMF timeout which caused the sequencer
screw up, so you still need to wait for Darrick's fix as well.

James

---

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
 


