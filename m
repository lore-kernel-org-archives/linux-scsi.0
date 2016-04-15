From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] hisi_sas: add device and slot alloc hw methods
Date: Fri, 15 Apr 2016 21:36:36 +0800
Message-ID: <1460727398-102091-2-git-send-email-john.garry@huawei.com>
References: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add methods to use HW specific versions of
functions to allocate slot and device.
HW specific methods are permitted to workaround
device id vs IPTT collision issue in v2 hw.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 11 +++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 0978016..d7cab72 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -133,6 +133,9 @@ struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
 	void (*setup_itct)(struct hisi_hba *hisi_hba,
 			   struct hisi_sas_device *device);
+	int (*slot_index_alloc)(struct hisi_hba *hisi_hba, int *slot_idx,
+				struct domain_device *device);
+	struct hisi_sas_device *(*alloc_dev)(struct domain_device *device);
 	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
 	int (*get_free_slot)(struct hisi_hba *hisi_hba, int *q, int *s);
 	void (*start_delivery)(struct hisi_hba *hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 097ab4f..18dd5ea 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -227,7 +227,11 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	} else
 		n_elem = task->num_scatter;
 
-	rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
+	if (hisi_hba->hw->slot_index_alloc)
+		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, &slot_idx,
+						    device);
+	else
+		rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
 	if (rc)
 		goto err_out;
 	rc = hisi_hba->hw->get_free_slot(hisi_hba, &dlvry_queue,
@@ -417,7 +421,10 @@ static int hisi_sas_dev_found(struct domain_device *device)
 	struct hisi_sas_device *sas_dev;
 	struct device *dev = &hisi_hba->pdev->dev;
 
-	sas_dev = hisi_sas_alloc_dev(device);
+	if (hisi_hba->hw->alloc_dev)
+		sas_dev = hisi_hba->hw->alloc_dev(device);
+	else
+		sas_dev = hisi_sas_alloc_dev(device);
 	if (!sas_dev) {
 		dev_err(dev, "fail alloc dev: max support %d devices\n",
 			HISI_SAS_MAX_DEVICES);
-- 
1.9.1
