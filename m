From: John Garry <john.garry@huawei.com>
Subject: [PATCH 05/13] scsi: hisi_sas: Reset disks when discovered
Date: Mon, 21 May 2018 18:09:17 +0800
Message-ID: <1526897365-228549-6-git-send-email-john.garry@huawei.com>
References: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526897365-228549-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When a disk is discovered, it may be in an error state,
or there may be residual commands remaining in the disk.

To ensure any disk is in good state after discovery,
reset via TMF (for SAS disk) or softreset (for a SATA
disk).

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 50 ++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 04a3eb4..0596553 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -24,6 +24,9 @@ static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 static int hisi_sas_softreset_ata_disk(struct domain_device *device);
 static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 				void *funcdata);
+static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
+				  struct domain_device *device);
+static void hisi_sas_dev_gone(struct domain_device *device);
 
 u8 hisi_sas_get_ata_protocol(struct host_to_dev_fis *fis, int direction)
 {
@@ -624,12 +627,49 @@ static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
 	return sas_dev;
 }
 
+#define HISI_SAS_SRST_ATA_DISK_CNT 3
+static int hisi_sas_init_device(struct domain_device *device)
+{
+	int rc = TMF_RESP_FUNC_COMPLETE;
+	struct scsi_lun lun;
+	struct hisi_sas_tmf_task tmf_task;
+	int retry = HISI_SAS_SRST_ATA_DISK_CNT;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+
+	switch (device->dev_type) {
+	case SAS_END_DEVICE:
+		int_to_scsilun(0, &lun);
+
+		tmf_task.tmf = TMF_CLEAR_TASK_SET;
+		rc = hisi_sas_debug_issue_ssp_tmf(device, lun.scsi_lun,
+						  &tmf_task);
+		if (rc == TMF_RESP_FUNC_COMPLETE)
+			hisi_sas_release_task(hisi_hba, device);
+		break;
+	case SAS_SATA_DEV:
+	case SAS_SATA_PM:
+	case SAS_SATA_PM_PORT:
+	case SAS_SATA_PENDING:
+		while (retry-- > 0) {
+			rc = hisi_sas_softreset_ata_disk(device);
+			if (!rc)
+				break;
+		}
+		break;
+	default:
+		break;
+	}
+
+	return rc;
+}
+
 static int hisi_sas_dev_found(struct domain_device *device)
 {
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct domain_device *parent_dev = device->parent;
 	struct hisi_sas_device *sas_dev;
 	struct device *dev = hisi_hba->dev;
+	int rc;
 
 	if (hisi_hba->hw->alloc_dev)
 		sas_dev = hisi_hba->hw->alloc_dev(device);
@@ -661,14 +701,22 @@ static int hisi_sas_dev_found(struct domain_device *device)
 				 "dev:%016llx at ex:%016llx\n",
 				 SAS_ADDR(device->sas_addr),
 				 SAS_ADDR(parent_dev->sas_addr));
-			return -EINVAL;
+			rc = -EINVAL;
+			goto err_out;
 		}
 	}
 
 	dev_info(dev, "dev[%d:%x] found\n",
 		sas_dev->device_id, sas_dev->dev_type);
 
+	rc = hisi_sas_init_device(device);
+	if (rc)
+		goto err_out;
 	return 0;
+
+err_out:
+	hisi_sas_dev_gone(device);
+	return rc;
 }
 
 static int hisi_sas_slave_configure(struct scsi_device *sdev)
-- 
1.9.1
