From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V2 5/9] pm80xx : cleanup in pm8001_abort_task function.
Date: Wed, 18 Feb 2015 05:06:46 +0530
Message-ID: <20150217233650.9091-6-Viswas.G@microsemi.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01hn0214.outbound.protection.outlook.com ([104.47.32.214]:45408
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751705AbdIMKmP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 06:42:15 -0400
In-Reply-To: <20150217233650.9091-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 49 +++++++++++-----------------------------
 1 file changed, 13 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index ce584c31d36e..e80b0542a67f 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1159,40 +1159,35 @@ int pm8001_query_task(struct sas_task *task)
 int pm8001_abort_task(struct sas_task *task)
 {
 	unsigned long flags;
-	u32 tag = 0xdeadbeef;
+	u32 tag;
 	u32 device_id;
 	struct domain_device *dev ;
-	struct pm8001_hba_info *pm8001_ha = NULL;
+	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_ccb_info *ccb;
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
@@ -1200,28 +1195,10 @@ int pm8001_abort_task(struct sas_task *task)
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
 
-- 
2.12.3
