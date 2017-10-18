From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V4 5/9] pm80xx : cleanup in pm8001_abort_task function.
Date: Wed, 18 Oct 2017 11:39:11 +0530
Message-ID: <20171018060915.8549-6-Viswas.G@microsemi.com>
References: <20171018060915.8549-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0058.outbound.protection.outlook.com ([104.47.40.58]:32263
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933437AbdJRGJf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Oct 2017 02:09:35 -0400
In-Reply-To: <20171018060915.8549-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

v4:
	-Removed the unused variable ccb in
	 pm8001_abort_task.
	-Removed the unused label out which
	 is not used

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>

Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 51 ++++++++++------------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index ce584c31d36e..a7626a851b62 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1159,40 +1159,34 @@ int pm8001_query_task(struct sas_task *task)
 int pm8001_abort_task(struct sas_task *task)
 {
 	unsigned long flags;
-	u32 tag = 0xdeadbeef;
+	u32 tag;
 	u32 device_id;
 	struct domain_device *dev ;
-	struct pm8001_hba_info *pm8001_ha = NULL;
-	struct pm8001_ccb_info *ccb;
+	struct pm8001_hba_info *pm8001_ha;
 	struct scsi_lun lun;
 	struct pm8001_device *pm8001_dev;
 	struct pm8001_tmf_task tmf_task;
 	int rc = TMF_RESP_FUNC_FAILED;
 	if (unlikely(!task || !task->lldd_task || !task->dev))
-		return rc;
+		return TMF_RESP_FUNC_FAILED;
+	dev = task->dev;
+	pm8001_dev = dev->lldd_dev;
+	pm8001_ha = pm8001_find_ha_by_dev(dev);
+	device_id = pm8001_dev->device_id;
+	rc = pm8001_find_tag(task, &tag);
+	if (rc == 0) {
+		pm8001_printk("no tag for task:%p\n", task);
+		return TMF_RESP_FUNC_FAILED;
+	}
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		rc = TMF_RESP_FUNC_COMPLETE;
-		goto out;
+		return TMF_RESP_FUNC_COMPLETE;
 	}
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 	if (task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd *cmnd = task->uldd_task;
-		dev = task->dev;
-		ccb = task->lldd_task;
-		pm8001_dev = dev->lldd_dev;
-		pm8001_ha = pm8001_find_ha_by_dev(dev);
 		int_to_scsilun(cmnd->device->lun, &lun);
-		rc = pm8001_find_tag(task, &tag);
-		if (rc == 0) {
-			printk(KERN_INFO "No such tag in %s\n", __func__);
-			rc = TMF_RESP_FUNC_FAILED;
-			return rc;
-		}
-		device_id = pm8001_dev->device_id;
-		PM8001_EH_DBG(pm8001_ha,
-			pm8001_printk("abort io to deviceid= %d\n", device_id));
 		tmf_task.tmf = TMF_ABORT_TASK;
 		tmf_task.tag_of_task_to_be_managed = tag;
 		rc = pm8001_issue_ssp_tmf(dev, lun.scsi_lun, &tmf_task);
@@ -1200,33 +1194,14 @@ int pm8001_abort_task(struct sas_task *task)
 			pm8001_dev->sas_device, 0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
-		dev = task->dev;
-		pm8001_dev = dev->lldd_dev;
-		pm8001_ha = pm8001_find_ha_by_dev(dev);
-		rc = pm8001_find_tag(task, &tag);
-		if (rc == 0) {
-			printk(KERN_INFO "No such tag in %s\n", __func__);
-			rc = TMF_RESP_FUNC_FAILED;
-			return rc;
-		}
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
 			pm8001_dev->sas_device, 0, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SMP) {
 		/* SMP */
-		dev = task->dev;
-		pm8001_dev = dev->lldd_dev;
-		pm8001_ha = pm8001_find_ha_by_dev(dev);
-		rc = pm8001_find_tag(task, &tag);
-		if (rc == 0) {
-			printk(KERN_INFO "No such tag in %s\n", __func__);
-			rc = TMF_RESP_FUNC_FAILED;
-			return rc;
-		}
 		rc = pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev,
 			pm8001_dev->sas_device, 0, tag);
 
 	}
-out:
 	if (rc != TMF_RESP_FUNC_COMPLETE)
 		pm8001_printk("rc= %d\n", rc);
 	return rc;
-- 
2.12.3
