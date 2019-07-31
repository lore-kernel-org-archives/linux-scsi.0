From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: pm80xx: remove redundant assignments to variable rc
Date: Wed, 31 Jul 2019 23:22:14 +0100
Message-ID: <20190731222214.15720-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@cloud.ionos.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are several occasions where variable rc is being initialized
with a value that is never read and error is being re-assigned a
little later on.  Clean up the code by removing rc entirely and
just returning the return value from the call to pm8001_issue_ssp_tmf

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 9453705f643a..7e48154e11c3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -1308,28 +1308,22 @@ int pm8001_abort_task(struct sas_task *task)
 
 int pm8001_abort_task_set(struct domain_device *dev, u8 *lun)
 {
-	int rc = TMF_RESP_FUNC_FAILED;
 	struct pm8001_tmf_task tmf_task;
 
 	tmf_task.tmf = TMF_ABORT_TASK_SET;
-	rc = pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
-	return rc;
+	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
 
 int pm8001_clear_aca(struct domain_device *dev, u8 *lun)
 {
-	int rc = TMF_RESP_FUNC_FAILED;
 	struct pm8001_tmf_task tmf_task;
 
 	tmf_task.tmf = TMF_CLEAR_ACA;
-	rc = pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
-
-	return rc;
+	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
 
 int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 {
-	int rc = TMF_RESP_FUNC_FAILED;
 	struct pm8001_tmf_task tmf_task;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 	struct pm8001_hba_info *pm8001_ha = pm8001_find_ha_by_dev(dev);
@@ -1338,7 +1332,6 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 		pm8001_printk("I_T_L_Q clear task set[%x]\n",
 		pm8001_dev->device_id));
 	tmf_task.tmf = TMF_CLEAR_TASK_SET;
-	rc = pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
-	return rc;
+	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
 
-- 
2.20.1
