From: John Garry <john.garry@huawei.com>
Subject: [PATCH 06/19] scsi: hisi_sas: modify hisi_sas_dev_gone() for reset
Date: Sat, 9 Dec 2017 01:16:37 +0800
Message-ID: <1512753410-50924-7-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Do a couple of changes for when HISI_SAS_RESET_BIT is
set for HBA:
- Clearing ITCT is not necessary
- Remove internal abort as it will fail during reset

Flag sas_dev->dev_type is kept as SAS_PHY_UNUSED.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 64d51a8..e4b3092 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -738,17 +738,19 @@ static void hisi_sas_dev_gone(struct domain_device *device)
 	dev_info(dev, "found dev[%d:%x] is gone\n",
 		 sas_dev->device_id, sas_dev->dev_type);
 
-	hisi_sas_internal_task_abort(hisi_hba, device,
+	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)) {
+		hisi_sas_internal_task_abort(hisi_hba, device,
 				     HISI_SAS_INT_ABT_DEV, 0);
 
-	hisi_sas_dereg_device(hisi_hba, device);
+		hisi_sas_dereg_device(hisi_hba, device);
+
+		hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
+		device->lldd_dev = NULL;
+		memset(sas_dev, 0, sizeof(*sas_dev));
+	}
 
-	hisi_hba->hw->clear_itct(hisi_hba, sas_dev);
 	if (hisi_hba->hw->free_device)
 		hisi_hba->hw->free_device(sas_dev);
-
-	device->lldd_dev = NULL;
-	memset(sas_dev, 0, sizeof(*sas_dev));
 	sas_dev->dev_type = SAS_PHY_UNUSED;
 }
 
-- 
1.9.1
