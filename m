From: John Garry <john.garry@huawei.com>
Subject: [PATCH 05/11] scsi: hisi_sas: check sas_dev gone earlier in hisi_sas_abort_task()
Date: Wed, 2 May 2018 23:56:28 +0800
Message-ID: <1525276594-92173-6-git-send-email-john.garry@huawei.com>
References: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

It is possible to dereference a NULL-pointer in hisi_sas_abort_task()
in special scenario when the device has been removed.

If an SMP task times-out, it will call hisi_sas_abort_task() to
recover. And currently there is a check in hisi_sas_abort_task() to
avoid the situation of processing the abort for the removed device.

However we have an ordering problem, in that we may reference
a task for the removed device before checking if the device has
been removed.

Fix this by only referencing the sas_dev after we know it is still
present.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8f8e642..24416bb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1166,15 +1166,16 @@ static int hisi_sas_abort_task(struct sas_task *task)
 	struct hisi_sas_tmf_task tmf_task;
 	struct domain_device *device = task->dev;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
-	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
-	struct device *dev = hisi_hba->dev;
+	struct hisi_hba *hisi_hba;
+	struct device *dev;
 	int rc = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
 
-	if (!sas_dev) {
-		dev_warn(dev, "Device has been removed\n");
+	if (!sas_dev)
 		return TMF_RESP_FUNC_FAILED;
-	}
+
+	hisi_hba = dev_to_hisi_hba(task->dev);
+	dev = hisi_hba->dev;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
-- 
1.9.1
