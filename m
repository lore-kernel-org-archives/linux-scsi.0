From: John Garry <john.garry@huawei.com>
Subject: [PATCH 15/19] scsi: hisi_sas: add hisi_hba.rst_work init for v3 hw
Date: Tue, 24 Oct 2017 23:51:45 +0800
Message-ID: <1508860309-212397-16-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Add init code of hisi_hba->rst_work for v3 hw. Because v3
hw also need it to recover controller when some hw errors
occurs.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 3 ++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 58bc69e..00fefea 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -434,4 +434,5 @@ extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 				    struct sas_task *task,
 				    struct hisi_sas_slot *slot);
 extern void hisi_sas_init_mem(struct hisi_hba *hisi_hba);
+extern void hisi_sas_rst_work_handler(struct work_struct *work);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 6b4dabde..1d417a4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1785,13 +1785,14 @@ void hisi_sas_free(struct hisi_hba *hisi_hba)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_free);
 
-static void hisi_sas_rst_work_handler(struct work_struct *work)
+void hisi_sas_rst_work_handler(struct work_struct *work)
 {
 	struct hisi_hba *hisi_hba =
 		container_of(work, struct hisi_hba, rst_work);
 
 	hisi_sas_controller_reset(hisi_hba);
 }
+EXPORT_SYMBOL_GPL(hisi_sas_rst_work_handler);
 
 int hisi_sas_get_fw_info(struct hisi_hba *hisi_hba)
 {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 818bd575..1f8995b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1840,6 +1840,7 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 	}
 	hisi_hba = shost_priv(shost);
 
+	INIT_WORK(&hisi_hba->rst_work, hisi_sas_rst_work_handler);
 	hisi_hba->hw = &hisi_sas_v3_hw;
 	hisi_hba->pci_dev = pdev;
 	hisi_hba->dev = dev;
-- 
1.9.1
