From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/3] hisi_sas: add alloc_dev_quirk_v2_hw()
Date: Fri, 15 Apr 2016 21:36:38 +0800
Message-ID: <1460727398-102091-4-git-send-email-john.garry@huawei.com>
References: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add custom version of function to allocate
device, alloc_dev_quirk_v2_hw().
For sata devices the device id bit0 should be
0.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f2966d8..bbe98ec 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -492,6 +492,35 @@ slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba, int *slot_idx,
 	return 0;
 }
 
+static struct
+hisi_sas_device *alloc_dev_quirk_v2_hw(struct domain_device *device)
+{
+	struct hisi_hba *hisi_hba = device->port->ha->lldd_ha;
+	struct hisi_sas_device *sas_dev = NULL;
+	int i, sata_dev = dev_is_sata(device);
+
+	spin_lock(&hisi_hba->lock);
+	for (i = 0; i < HISI_SAS_MAX_DEVICES; i++) {
+		/*
+		 * SATA device id bit0 should be 0
+		 */
+		if (sata_dev && (i & 1))
+			continue;
+		if (hisi_hba->devices[i].dev_type == SAS_PHY_UNUSED) {
+			hisi_hba->devices[i].device_id = i;
+			sas_dev = &hisi_hba->devices[i];
+			sas_dev->dev_status = HISI_SAS_DEV_NORMAL;
+			sas_dev->dev_type = device->dev_type;
+			sas_dev->hisi_hba = hisi_hba;
+			sas_dev->sas_device = device;
+			break;
+		}
+	}
+	spin_unlock(&hisi_hba->lock);
+
+	return sas_dev;
+}
+
 static void config_phy_opt_mode_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
@@ -2195,6 +2224,7 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.setup_itct = setup_itct_v2_hw,
 	.slot_index_alloc = slot_index_alloc_quirk_v2_hw,
+	.alloc_dev = alloc_dev_quirk_v2_hw,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
 	.free_device = free_device_v2_hw,
-- 
1.9.1
