From: John Garry <john.garry@huawei.com>
Subject: [PATCH 06/19] scsi: hisi_sas: remove repeated device config in v2 hw
Date: Fri, 11 Aug 2017 00:09:31 +0800
Message-ID: <1502381384-219889-7-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This patch removes some repeated configurations:
(1) The device id of the device is already set in the
alloc function, so we don't need to modify in free
device function.
(2) Field dev_type and dev_status are configured in
hisi_sas_dev_gone(), so there is no need for repeated
config in free_device_v3_hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index aaa7296..81ad6cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -716,7 +716,6 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = hisi_hba->dev;
-	int dev_id = sas_dev->device_id;
 
 	dev_info(dev, "found dev[%d:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
@@ -729,9 +728,7 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	hisi_hba->hw->free_device(hisi_hba, sas_dev);
 	device->lldd_dev = NULL;
 	memset(sas_dev, 0, sizeof(*sas_dev));
-	sas_dev->device_id = dev_id;
 	sas_dev->dev_type = SAS_PHY_UNUSED;
-	sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
 }
 
 static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 83d2dca..dc5c551 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -578,8 +578,6 @@ static void free_device_v3_hw(struct hisi_hba *hisi_hba,
 		memset(itct, 0, sizeof(struct hisi_sas_itct));
 		hisi_sas_write32(hisi_hba, ENT_INT_SRC3,
 				 ENT_INT_SRC3_ITC_INT_MSK);
-		hisi_hba->devices[dev_id].dev_type = SAS_PHY_UNUSED;
-		hisi_hba->devices[dev_id].dev_status = HISI_SAS_DEV_NORMAL;
 
 		/* clear the itct */
 		hisi_sas_write32(hisi_hba, ITCT_CLR, 0);
-- 
1.9.1
