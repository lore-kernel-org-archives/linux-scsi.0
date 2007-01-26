From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 5/7] libsas: Handle SCSI commands that complete with failure codes
Date: Fri, 26 Jan 2007 14:08:52 -0800
Message-ID: <20070126220852.20198.26085.stgit@elm3a70.beaverton.ibm.com>
References: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47535 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030201AbXAZWHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 17:07:50 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0QM7nMf026276
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:07:49 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l0QM6xp8221808
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:59 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0QM6x0T003120
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 17:06:59 -0500
In-Reply-To: <20070126220834.20198.21100.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


This patch moves the code that handles SAS failures out of the main EH
function and into a separate function.  It also detects commands that have
no sas_task (i.e. they completed, but with error data) and sends them into
scsi_error for processing.  This allows us to handle SCSI errors (and
enables auto-spinup as a side effect) instead of dropping them on the
floor and falling into an infinite loop.  It also requires the
implementation of a device reset function, which the SAS failure code has
been modified to employ for REQ_DEVICE_RESET.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |  148 +++++++++++++++++++++++++----------
 include/scsi/libsas.h               |    1 
 2 files changed, 105 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 9ffe760..eac1d2d 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -34,6 +34,7 @@ #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_sas.h>
 #include "../scsi_sas_internal.h"
 #include "../scsi_transport_api.h"
+#include "../scsi_priv.h"
 
 #include <linux/err.h>
 #include <linux/blkdev.h>
@@ -396,54 +397,80 @@ static int sas_recover_I_T(struct domain
 	return res;
 }
 
-static int eh_reset_phy_helper(struct sas_phy *phy)
+/* Find the sas_phy that's attached to this device */
+struct sas_phy *find_local_sas_phy(struct domain_device *dev)
 {
-	int tmf_resp;
+	struct domain_device *pdev = dev->parent;
+	struct ex_phy *exphy = NULL;
+	int i;
+
+	/* Directly attached device */
+	if (!pdev)
+		return dev->port->phy;
 
-	tmf_resp = sas_phy_reset(phy, 1);
-	if (tmf_resp)
-		SAS_DPRINTK("Hard reset of phy %d failed 0x%x\n",
-			    phy->identify.phy_identifier,
-			    tmf_resp);
+	/* Otherwise look in the expander */
+	for (i = 0; i < pdev->ex_dev.num_phys; i++)
+		if (!memcmp(dev->sas_addr,
+			    pdev->ex_dev.ex_phy[i].attached_sas_addr,
+			    SAS_ADDR_SIZE)) {
+			exphy = &pdev->ex_dev.ex_phy[i];
+			break;
+		}
 
-	return tmf_resp;
+	BUG_ON(!exphy);
+	return exphy->phy;
 }
 
-void sas_scsi_recover_host(struct Scsi_Host *shost)
+/* Attempt to send a target reset message to a device */
+int sas_eh_device_reset_handler(struct scsi_cmnd *cmd)
+{
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
+	struct sas_phy *phy = find_local_sas_phy(dev);
+	int res;
+
+	res = sas_phy_reset(phy, 1);
+	if (res)
+		SAS_DPRINTK("Device reset of %s failed 0x%x\n",
+			    phy->dev.kobj.k_name,
+			    res);
+	if (res == TMF_RESP_FUNC_SUCC || res == TMF_RESP_FUNC_COMPLETE)
+		return SUCCESS;
+
+	return FAILED;
+}
+
+/* Try to reset a device */
+static int try_to_reset_cmd_device(struct Scsi_Host *shost,
+				   struct scsi_cmnd *cmd)
+{
+	if (!shost->hostt->eh_device_reset_handler)
+		return FAILED;
+
+	return shost->hostt->eh_device_reset_handler(cmd);
+}
+
+static int sas_eh_handle_sas_errors(struct Scsi_Host *shost,
+				    struct list_head *work_q,
+				    struct list_head *done_q)
 {
-	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
-	unsigned long flags;
-	LIST_HEAD(error_q);
 	struct scsi_cmnd *cmd, *n;
 	enum task_disposition res = TASK_IS_DONE;
 	int tmf_resp, need_reset;
 	struct sas_internal *i = to_sas_internal(shost->transportt);
-	struct sas_phy *task_sas_phy = NULL;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	list_splice_init(&shost->eh_cmd_q, &error_q);
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	SAS_DPRINTK("Enter %s\n", __FUNCTION__);
+	unsigned long flags;
+	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
 
-	/* All tasks on this list were marked SAS_TASK_STATE_ABORTED
-	 * by sas_scsi_timed_out() callback.
-	 */
 Again:
-	SAS_DPRINTK("going over list...\n");
-	list_for_each_entry_safe(cmd, n, &error_q, eh_entry) {
+	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
 		struct sas_task *task = TO_SAS_TASK(cmd);
-		list_del_init(&cmd->eh_entry);
 
-		if (!task) {
-			SAS_DPRINTK("%s: taskless cmd?!\n", __FUNCTION__);
+		if (!task)
 			continue;
-		}
+
+		list_del_init(&cmd->eh_entry);
 
 		spin_lock_irqsave(&task->task_state_lock, flags);
 		need_reset = task->task_state_flags & SAS_TASK_NEED_DEV_RESET;
-		if (need_reset)
-			task_sas_phy = task->dev->port->phy;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 		SAS_DPRINTK("trying to find task 0x%p\n", task);
@@ -457,14 +484,14 @@ Again:
 				    task);
 			task->task_done(task);
 			if (need_reset)
-				eh_reset_phy_helper(task_sas_phy);
+				try_to_reset_cmd_device(shost, cmd);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
 				    __FUNCTION__, task);
 			task->task_done(task);
 			if (need_reset)
-				eh_reset_phy_helper(task_sas_phy);
+				try_to_reset_cmd_device(shost, cmd);
 			continue;
 		case TASK_IS_AT_LU:
 			SAS_DPRINTK("task 0x%p is at LU: lu recover\n", task);
@@ -476,8 +503,8 @@ Again:
 					    cmd->device->lun);
 				task->task_done(task);
 				if (need_reset)
-					eh_reset_phy_helper(task_sas_phy);
-				sas_scsi_clear_queue_lu(&error_q, cmd);
+					try_to_reset_cmd_device(shost, cmd);
+				sas_scsi_clear_queue_lu(work_q, cmd);
 				goto Again;
 			}
 			/* fallthrough */
@@ -491,8 +518,8 @@ Again:
 					    SAS_ADDR(task->dev->sas_addr));
 				task->task_done(task);
 				if (need_reset)
-					eh_reset_phy_helper(task_sas_phy);
-				sas_scsi_clear_queue_I_T(&error_q, task->dev);
+					try_to_reset_cmd_device(shost, cmd);
+				sas_scsi_clear_queue_I_T(work_q, task->dev);
 				goto Again;
 			}
 			/* Hammer time :-) */
@@ -506,8 +533,8 @@ Again:
 						    "succeeded\n", port->id);
 					task->task_done(task);
 					if (need_reset)
-						eh_reset_phy_helper(task_sas_phy);
-					sas_scsi_clear_queue_port(&error_q,
+						try_to_reset_cmd_device(shost, cmd);
+					sas_scsi_clear_queue_port(work_q,
 								  port);
 					goto Again;
 				}
@@ -520,7 +547,7 @@ Again:
 						    "succeeded\n");
 					task->task_done(task);
 					if (need_reset)
-						eh_reset_phy_helper(task_sas_phy);
+						try_to_reset_cmd_device(shost, cmd);
 					goto out;
 				}
 			}
@@ -535,21 +562,53 @@ Again:
 
 			task->task_done(task);
 			if (need_reset)
-				eh_reset_phy_helper(task_sas_phy);
+				try_to_reset_cmd_device(shost, cmd);
 			goto clear_q;
 		}
 	}
 out:
-	scsi_eh_flush_done_q(&ha->eh_done_q);
-	SAS_DPRINTK("--- Exit %s\n", __FUNCTION__);
-	return;
+	return list_empty(work_q);
 clear_q:
 	SAS_DPRINTK("--- Exit %s -- clear_q\n", __FUNCTION__);
-	list_for_each_entry_safe(cmd, n, &error_q, eh_entry) {
+	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
 		struct sas_task *task = TO_SAS_TASK(cmd);
 		list_del_init(&cmd->eh_entry);
 		task->task_done(task);
 	}
+	return list_empty(work_q);
+}
+
+void sas_scsi_recover_host(struct Scsi_Host *shost)
+{
+	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
+	unsigned long flags;
+	LIST_HEAD(eh_work_q);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	SAS_DPRINTK("Enter %s\n", __FUNCTION__);
+	/*
+	 * Deal with commands that still have SAS tasks (i.e. they didn't
+	 * complete via the normal sas_task completion mechanism)
+	 */
+	if (sas_eh_handle_sas_errors(shost, &eh_work_q, &ha->eh_done_q))
+		goto out;
+
+	/*
+	 * Now deal with SCSI commands that completed ok but have a an error
+	 * code (and hopefully sense data) attached.  This is roughly what
+	 * scsi_unjam_host does, but we skip scsi_eh_abort_cmds because any
+	 * command we see here has no sas_task and is thus unknown to the HA.
+	 */
+	if (!scsi_eh_get_sense(&eh_work_q, &ha->eh_done_q))
+		scsi_eh_ready_devs(shost, &eh_work_q, &ha->eh_done_q);
+
+out:
+	scsi_eh_flush_done_q(&ha->eh_done_q);
+	SAS_DPRINTK("--- Exit %s\n", __FUNCTION__);
+	return;
 }
 
 enum scsi_eh_timer_return sas_scsi_timed_out(struct scsi_cmnd *cmd)
@@ -914,3 +973,4 @@ EXPORT_SYMBOL_GPL(__sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_task_abort);
 EXPORT_SYMBOL_GPL(sas_phy_reset);
 EXPORT_SYMBOL_GPL(sas_phy_enable);
+EXPORT_SYMBOL_GPL(sas_eh_device_reset_handler);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index ca39392..b200233 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -660,5 +660,6 @@ void sas_init_dev(struct domain_device *
 
 void sas_task_abort(struct sas_task *);
 int __sas_task_abort(struct sas_task *);
+int sas_eh_device_reset_handler(struct scsi_cmnd *cmd);
 
 #endif /* _SASLIB_H_ */
