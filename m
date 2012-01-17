From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v4 09/10] libsas: pre-clean commands that won the eh vs
 completion race
Date: Mon, 16 Jan 2012 21:11:48 -0800
Message-ID: <20120117051148.22344.90576.stgit@localhost6.localdomain6>
References: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38218 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab2AQFLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2012 00:11:48 -0500
In-Reply-To: <20120117050847.22344.4961.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

When scrolling forward through the eh list (in a clear_q scenario) it is
possible to encounter commands that won the completion vs eh race.  Rather
than sprinkle more "if (!task)" throughout the handler just make a pass
through the list and delete the race winners before handling the rest.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |   25 ++++++++++++++++---------
 1 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index 94ef763..731c892 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -249,8 +249,8 @@ out_done:
 
 static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 {
-	struct sas_task *task = TO_SAS_TASK(cmd);
 	struct sas_ha_struct *sas_ha = SHOST_TO_SAS_HA(cmd->device->host);
+	struct sas_task *task = TO_SAS_TASK(cmd);
 
 	/* At this point, we only get called following an actual abort
 	 * of the task, so we should be guaranteed not to be racing with
@@ -267,9 +267,9 @@ static void sas_eh_finish_cmd(struct scsi_cmnd *cmd)
 
 static void sas_eh_defer_cmd(struct scsi_cmnd *cmd)
 {
-	struct sas_task *task = TO_SAS_TASK(cmd);
-	struct domain_device *dev = task->dev;
+	struct domain_device *dev = cmd_to_domain_dev(cmd);
 	struct sas_ha_struct *ha = dev->port->ha;
+	struct sas_task *task = TO_SAS_TASK(cmd);
 
 	if (!dev_is_sata(dev)) {
 		sas_eh_finish_cmd(cmd);
@@ -530,8 +530,9 @@ static int sas_eh_handle_sas_errors(struct Scsi_Host *shost,
 	struct sas_internal *i = to_sas_internal(shost->transportt);
 	unsigned long flags;
 	struct sas_ha_struct *ha = SHOST_TO_SAS_HA(shost);
+	LIST_HEAD(done);
 
-Again:
+	/* clean out any commands that won the completion vs eh race */
 	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
 		struct domain_device *dev = cmd_to_domain_dev(cmd);
 		struct sas_task *task;
@@ -545,7 +546,12 @@ Again:
 		spin_unlock_irqrestore(&dev->done_lock, flags);
 
 		if (!task)
-			continue;
+			list_move_tail(&cmd->eh_entry, &done);
+	}
+
+ Again:
+	list_for_each_entry_safe(cmd, n, work_q, eh_entry) {
+		struct sas_task *task = TO_SAS_TASK(cmd);
 
 		list_del_init(&cmd->eh_entry);
 
@@ -649,15 +655,16 @@ Again:
 			goto clear_q;
 		}
 	}
+ out:
+	list_splice_tail(&done, work_q);
 	list_splice_tail_init(&ha->eh_ata_q, work_q);
 	return list_empty(work_q);
-clear_q:
+
+ clear_q:
 	SAS_DPRINTK("--- Exit %s -- clear_q\n", __func__);
 	list_for_each_entry_safe(cmd, n, work_q, eh_entry)
 		sas_eh_finish_cmd(cmd);
-
-	list_splice_tail_init(&ha->eh_ata_q, work_q);
-	return list_empty(work_q);
+	goto out;
 }
 
 void sas_scsi_recover_host(struct Scsi_Host *shost)

