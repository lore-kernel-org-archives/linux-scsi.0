From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 02/23] scsi: hisi_sas: define hisi_sas_device.device_id as int
Date: Wed, 31 May 2017 22:32:54 +0800
Message-ID: <1496241195-217678-3-git-send-email-john.garry@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Currently hisi_sas_device.device_id is a u64. This can create a
problem in selecting the queue for a device, in that this code
does a 64b division on device id. For some 32b systems, 64b division
is slow and the lib reference must be explicitly included.

The device id does not need to be 64b in size, so, as a solution,
just make as an int.

Also, struct hisi_sas_device elements are re-ordered to improve
packing efficiency.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  8 ++++----
 drivers/scsi/hisi_sas/hisi_sas_main.c | 10 +++++-----
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4e28f32..b4e96fa9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -107,15 +107,15 @@ struct hisi_sas_dq {
 };
 
 struct hisi_sas_device {
-	enum sas_device_type	dev_type;
 	struct hisi_hba		*hisi_hba;
 	struct domain_device	*sas_device;
+	struct list_head	list;
 	u64 attached_phy;
-	u64 device_id;
 	atomic64_t running_req;
-	struct list_head	list;
-	u8 dev_status;
+	enum sas_device_type	dev_type;
+	int device_id;
 	int sata_idx;
+	u8 dev_status;
 };
 
 struct hisi_sas_slot {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3605d28..54e0cf2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -209,7 +209,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 
 	if (DEV_IS_GONE(sas_dev)) {
 		if (sas_dev)
-			dev_info(dev, "task prep: device %llu not ready\n",
+			dev_info(dev, "task prep: device %d not ready\n",
 				 sas_dev->device_id);
 		else
 			dev_info(dev, "task prep: device %016llx not ready\n",
@@ -627,9 +627,9 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = &hisi_hba->pdev->dev;
-	u64 dev_id = sas_dev->device_id;
+	int dev_id = sas_dev->device_id;
 
-	dev_info(dev, "found dev[%lld:%x] is gone\n",
+	dev_info(dev, "found dev[%d:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
 
 	hisi_sas_internal_task_abort(hisi_hba, device,
@@ -1082,7 +1082,7 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 	}
 out:
 	if (rc != TMF_RESP_FUNC_COMPLETE)
-		dev_err(dev, "lu_reset: for device[%llx]:rc= %d\n",
+		dev_err(dev, "lu_reset: for device[%d]:rc= %d\n",
 			     sas_dev->device_id, rc);
 	return rc;
 }
@@ -1129,7 +1129,7 @@ static int hisi_sas_query_task(struct sas_task *task)
 }
 
 static int
-hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, u64 device_id,
+hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, int device_id,
 				  struct sas_task *task, int abort_flag,
 				  int task_tag)
 {
-- 
1.9.1
