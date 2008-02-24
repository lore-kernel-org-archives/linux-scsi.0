From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 4/5] libsas: misc fixes to the eh path
Date: Sat, 23 Feb 2008 23:39:59 -0600
Message-ID: <1203831599.3139.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59769 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbYBXFkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 24 Feb 2008 00:40:03 -0500
Received: from localhost (localhost [127.0.0.1])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id CBE938426
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:40:01 -0600 (CST)
Received: from accolon.hansenpartnership.com ([127.0.0.1])
	by localhost (redscar.int.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fqAElqiqZxit for <linux-scsi@vger.kernel.org>;
	Sat, 23 Feb 2008 23:40:01 -0600 (CST)
Received: from [153.66.150.222] (mulgrave-w.int.hansenpartnership.com [153.66.150.222])
	by accolon.hansenpartnership.com (Postfix) with ESMTP id 5364A8112
	for <linux-scsi@vger.kernel.org>; Sat, 23 Feb 2008 23:39:59 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

- Correct one use after free of the sas task
- update the reset required path to move straight to LUN reset
- make the bigger hammer actually reset something instead of just trying
  to clear all the tasks.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f3706f4..1f82415 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -498,10 +498,10 @@ int sas_eh_bus_reset_handler(struct scsi_cmnd *cmd)
 }
 
 /* Try to reset a device */
-static int try_to_reset_cmd_device(struct Scsi_Host *shost,
-				   struct scsi_cmnd *cmd)
+static int try_to_reset_cmd_device(struct scsi_cmnd *cmd)
 {
 	int res;
+	struct Scsi_Host *shost = cmd->device->host;
 
 	if (!shost->hostt->eh_device_reset_handler)
 		goto try_bus_reset;
@@ -541,6 +541,12 @@ Again:
 		need_reset = task->task_state_flags & SAS_TASK_NEED_DEV_RESET;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 
+		if (need_reset) {
+			SAS_DPRINTK("%s: task 0x%p requests reset\n",
+				    __FUNCTION__, task);
+			goto reset;
+		}
+
 		SAS_DPRINTK("trying to find task 0x%p\n", task);
 		res = sas_scsi_find_task(task);
 
@@ -551,18 +557,15 @@ Again:
 			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
 				    task);
 			sas_eh_finish_cmd(cmd);
-			if (need_reset)
-				try_to_reset_cmd_device(shost, cmd);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
 				    __FUNCTION__, task);
 			sas_eh_finish_cmd(cmd);
-			if (need_reset)
-				try_to_reset_cmd_device(shost, cmd);
 			continue;
 		case TASK_IS_AT_LU:
 			SAS_DPRINTK("task 0x%p is at LU: lu recover\n", task);
+ reset:
 			tmf_resp = sas_recover_lu(task->dev, cmd);
 			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
 				SAS_DPRINTK("dev %016llx LU %x is "
@@ -570,8 +573,6 @@ Again:
 					    SAS_ADDR(task->dev),
 					    cmd->device->lun);
 				sas_eh_finish_cmd(cmd);
-				if (need_reset)
-					try_to_reset_cmd_device(shost, cmd);
 				sas_scsi_clear_queue_lu(work_q, cmd);
 				goto Again;
 			}
@@ -582,15 +583,15 @@ Again:
 				    task);
 			tmf_resp = sas_recover_I_T(task->dev);
 			if (tmf_resp == TMF_RESP_FUNC_COMPLETE) {
+				struct domain_device *dev = task->dev;
 				SAS_DPRINTK("I_T %016llx recovered\n",
 					    SAS_ADDR(task->dev->sas_addr));
 				sas_eh_finish_cmd(cmd);
-				if (need_reset)
-					try_to_reset_cmd_device(shost, cmd);
-				sas_scsi_clear_queue_I_T(work_q, task->dev);
+				sas_scsi_clear_queue_I_T(work_q, dev);
 				goto Again;
 			}
 			/* Hammer time :-) */
+			try_to_reset_cmd_device(cmd);
 			if (i->dft->lldd_clear_nexus_port) {
 				struct asd_sas_port *port = task->dev->port;
 				SAS_DPRINTK("clearing nexus for port:%d\n",
@@ -600,8 +601,6 @@ Again:
 					SAS_DPRINTK("clear nexus port:%d "
 						    "succeeded\n", port->id);
 					sas_eh_finish_cmd(cmd);
-					if (need_reset)
-						try_to_reset_cmd_device(shost, cmd);
 					sas_scsi_clear_queue_port(work_q,
 								  port);
 					goto Again;
@@ -614,8 +613,6 @@ Again:
 					SAS_DPRINTK("clear nexus ha "
 						    "succeeded\n");
 					sas_eh_finish_cmd(cmd);
-					if (need_reset)
-						try_to_reset_cmd_device(shost, cmd);
 					goto clear_q;
 				}
 			}
@@ -629,8 +626,6 @@ Again:
 				    cmd->device->lun);
 
 			sas_eh_finish_cmd(cmd);
-			if (need_reset)
-				try_to_reset_cmd_device(shost, cmd);
 			goto clear_q;
 		}
 	}
-- 
1.5.4.1



