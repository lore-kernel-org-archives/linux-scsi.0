From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 11/21] libsas: Enable the EH strategy handler to reset a phy after a command
Date: Thu, 11 Jan 2007 14:15:17 -0800
Message-ID: <20070111221517.3543.21459.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39919 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbXAKWO6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:14:58 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMEvU5015304
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:58 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMEvw1307374
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:57 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMEvsa017657
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:14:57 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


When a SAS LLDD needs to request a device port reset, it needs to have all
commands aborted before it can reset the port.  Since commands are put on
the EH's list in the order that they were queued, the LLDD can set a "need
reset" flag in the last task to be aborted so that the EH can reset the
port after all commands are aborted.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/libsas/sas_scsi_host.c |   37 ++++++++++++++++++++++++++++++++++-
 include/scsi/libsas.h               |    1 +
 2 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index f90c332..d0c04eb 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -389,6 +389,19 @@ static int sas_recover_I_T(struct domain
 	return res;
 }
 
+static int eh_reset_phy_helper(struct sas_phy *phy)
+{
+	int tmf_resp;
+
+	tmf_resp = sas_phy_reset(phy, 1);
+	if (tmf_resp)
+		SAS_DPRINTK("Hard reset of phy %d failed 0x%x\n",
+			    phy->identify.phy_identifier,
+			    tmf_resp);
+
+	return tmf_resp;
+}
+
 void sas_scsi_recover_host(struct Scsi_Host *shost)
 {
 	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
@@ -396,8 +409,9 @@ void sas_scsi_recover_host(struct Scsi_H
 	LIST_HEAD(error_q);
 	struct scsi_cmnd *cmd, *n;
 	enum task_disposition res = TASK_IS_DONE;
-	int tmf_resp;
+	int tmf_resp, need_reset;
 	struct sas_internal *i = to_sas_internal(shost->transportt);
+	struct sas_phy *task_sas_phy = NULL;
 
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_splice_init(&shost->eh_cmd_q, &error_q);
@@ -418,6 +432,13 @@ Again:
 			SAS_DPRINTK("%s: taskless cmd?!\n", __FUNCTION__);
 			continue;
 		}
+
+		spin_lock_irqsave(&task->task_state_lock, flags);
+		need_reset = task->task_state_flags & SAS_TASK_NEED_DEV_RESET;
+		if (need_reset)
+			task_sas_phy = task->dev->port->phy;
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+
 		SAS_DPRINTK("trying to find task 0x%p\n", task);
 		res = sas_scsi_find_task(task);
 
@@ -428,11 +449,15 @@ Again:
 			SAS_DPRINTK("%s: task 0x%p is done\n", __FUNCTION__,
 				    task);
 			task->task_done(task);
+			if (need_reset)
+				eh_reset_phy_helper(task_sas_phy);
 			continue;
 		case TASK_IS_ABORTED:
 			SAS_DPRINTK("%s: task 0x%p is aborted\n",
 				    __FUNCTION__, task);
 			task->task_done(task);
+			if (need_reset)
+				eh_reset_phy_helper(task_sas_phy);
 			continue;
 		case TASK_IS_AT_LU:
 			SAS_DPRINTK("task 0x%p is at LU: lu recover\n", task);
@@ -443,6 +468,8 @@ Again:
 					    SAS_ADDR(task->dev),
 					    cmd->device->lun);
 				task->task_done(task);
+				if (need_reset)
+					eh_reset_phy_helper(task_sas_phy);
 				sas_scsi_clear_queue_lu(&error_q, cmd);
 				goto Again;
 			}
@@ -455,6 +482,8 @@ Again:
 				SAS_DPRINTK("I_T %016llx recovered\n",
 					    SAS_ADDR(task->dev->sas_addr));
 				task->task_done(task);
+				if (need_reset)
+					eh_reset_phy_helper(task_sas_phy);
 				sas_scsi_clear_queue_I_T(&error_q, task->dev);
 				goto Again;
 			}
@@ -468,6 +497,8 @@ Again:
 					SAS_DPRINTK("clear nexus port:%d "
 						    "succeeded\n", port->id);
 					task->task_done(task);
+					if (need_reset)
+						eh_reset_phy_helper(task_sas_phy);
 					sas_scsi_clear_queue_port(&error_q,
 								  port);
 					goto Again;
@@ -480,6 +511,8 @@ Again:
 					SAS_DPRINTK("clear nexus ha "
 						    "succeeded\n");
 					task->task_done(task);
+					if (need_reset)
+						eh_reset_phy_helper(task_sas_phy);
 					goto out;
 				}
 			}
@@ -493,6 +526,8 @@ Again:
 				    cmd->device->lun);
 
 			task->task_done(task);
+			if (need_reset)
+				eh_reset_phy_helper(task_sas_phy);
 			goto clear_q;
 		}
 	}
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 1d39485..75df71f 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -553,6 +553,7 @@ struct sas_task {
 #define SAS_TASK_STATE_PENDING      1
 #define SAS_TASK_STATE_DONE         2
 #define SAS_TASK_STATE_ABORTED      4
+#define SAS_TASK_NEED_DEV_RESET     8
 #define SAS_TASK_AT_INITIATOR       16
 
 static inline struct sas_task *sas_alloc_task(gfp_t flags)
