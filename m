From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: [PATCH] pm8001: panics/lockups from asynchronous device removal.
Date: Tue, 17 Jan 2012 13:29:10 -0500
Message-ID: <09A902B5-56B8-46CB-82B7-0DF81E7BBC12@xyratex.com>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex197.xyratex.com ([194.131.166.197]:60511 "EHLO
	XY01EX21.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753377Ab2AQS3U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2012 13:29:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: jack_wang Wang <jack_wang@usish.com>, crystal_yu <crystal_yu@usish.com>, lindar_liu <lindar_liu@usish.com>, James Bottomley <JBottomley@parallels.com>

pm8001_query_task() and pm8001_abort_task() panic kernel when devices asynchronously disappear, a possible scenario since these functions are generally called when errors are mounting. Some of the panics are a direct result of a failure to NULL check some of the structure variables that are in certain states of teardown. One of the lockups was a direct result of returning an unexpected code to libsas' sas_scsi_find_task() function (creating a tight loop of an unexpected code 138 upstream to the scsi layer queue function).

Signed-off-by: mark_salyzyn@xyratex.com
Cc: jack_wang@usish.com
Cc: JBottomley@parallels.com
Cc: crystal_yu@usish.com
Cc: john_gong@usish.com
Cc: lindar_liu <lindar_liu@usish.com>

 drivers/scsi/pm8001/pm8001_sas.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index fb3dc99..1cac756 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -940,6 +940,8 @@ int pm8001_query_task(struct sas_task *task)
 		struct pm8001_hba_info *pm8001_ha =
 			pm8001_find_ha_by_dev(dev);
 
+		if (unlikely(!cmnd || !cmnd->device))
+			return rc;
 		int_to_scsilun(cmnd->device->lun, &lun);
 		rc = pm8001_find_tag(task, &tag);
 		if (rc == 0) {
@@ -947,9 +949,11 @@ int pm8001_query_task(struct sas_task *task)
 			return rc;
 		}
 		PM8001_EH_DBG(pm8001_ha, pm8001_printk("Query:["));
-		for (i = 0; i < 16; i++)
-			printk(KERN_INFO "%02x ", cmnd->cmnd[i]);
-		printk(KERN_INFO "]\n");
+		if (pm8001_ha->logging_level & PM8001_EH_LOGGING) {
+			for (i = 0; i < 16; i++)
+				printk(KERN_LEVEL "%02x ", cmnd->cmnd[i]);
+			printk(KERN_LEVEL "]\n");
+		}
 		tmf_task.tmf = 	TMF_QUERY_TASK;
 		tmf_task.tag_of_task_to_be_managed = tag;
 
@@ -960,6 +964,13 @@ int pm8001_query_task(struct sas_task *task)
 			PM8001_EH_DBG(pm8001_ha,
 				pm8001_printk("The task is still in Lun\n"));
 			break;
+
+		/* libsas can not handle any other error code than this list */
+		default:
+			/* rc is likely something like SAS_OPEN_REJECT etc */
+			pm8001_printk("pm8001_issue_ssp_tmf()=0x%x\n", rc);
+			rc = TMF_RESP_FUNC_FAILED;
+			/* FALLTHRU */
 		/* The task is not in Lun or failed, reset the phy */
 		case TMF_RESP_FUNC_FAILED:
 		case TMF_RESP_FUNC_COMPLETE:
@@ -986,7 +997,8 @@ int pm8001_abort_task(struct sas_task *task)
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_tmf_task tmf_task;
 	int rc = TMF_RESP_FUNC_FAILED;
-	if (unlikely(!task || !task->lldd_task || !task->dev))
+	if (unlikely(!task || !task->lldd_task
+	 || !task->dev || !task->dev->lldd_dev))
 		return rc;
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
@@ -1001,6 +1013,8 @@ int pm8001_abort_task(struct sas_task *task)
 		ccb = task->lldd_task;
 		pm8001_dev = dev->lldd_dev;
 		pm8001_ha = pm8001_find_ha_by_dev(dev);
+		if (unlikely(!cmnd || !cmnd->device))
+			return rc;
 		int_to_scsilun(cmnd->device->lun, &lun);
 		rc = pm8001_find_tag(task, &tag);
 		if (rc == 0) {

Sincerely -- Mark Salyzyn

