From: chenxiang <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: hisi_sas: fix a warning reported by sparse
Date: Tue, 19 Dec 2017 09:15:23 +0800
Message-ID: <1513646123-93775-1-git-send-email-chenxiang66@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, john.garry@huawei.com, chenxiang <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

The type of function pci_choose_state's return value is pci_power_t while we
define it as a u32. A warning will be reported by sparse. So change u32 
into pci_power_t.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 6a408d2..05fb291 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2309,7 +2309,8 @@ static int hisi_sas_v3_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct hisi_hba *hisi_hba = sha->lldd_ha;
 	struct device *dev = hisi_hba->dev;
 	struct Scsi_Host *shost = hisi_hba->shost;
-	u32 device_state, status;
+	u32 status;
+	pci_power_t device_state;
 	int rc;
 	u32 reg_val;
 	unsigned long flags;
@@ -2371,7 +2372,7 @@ static int hisi_sas_v3_resume(struct pci_dev *pdev)
 	struct Scsi_Host *shost = hisi_hba->shost;
 	struct device *dev = hisi_hba->dev;
 	unsigned int rc;
-	u32 device_state = pdev->current_state;
+	pci_power_t device_state = pdev->current_state;
 
 	dev_warn(dev, "resuming from operating state [D%d]\n",
 			device_state);
-- 
1.9.1
