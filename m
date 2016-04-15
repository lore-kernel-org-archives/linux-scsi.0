From: John Garry <john.garry@huawei.com>
Subject: [PATCH 2/3] hisi_sas: add slot_index_alloc_quirk_v2_hw()
Date: Fri, 15 Apr 2016 21:36:37 +0800
Message-ID: <1460727398-102091-3-git-send-email-john.garry@huawei.com>
References: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460727398-102091-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add v2 hw custom function slot_index_alloc_quirk_v2_hw().
SAS devices should have IPTT bit0 equal to 1.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 4276594..f2966d8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -465,6 +465,33 @@ static u32 hisi_sas_phy_read32(struct hisi_hba *hisi_hba,
 	return readl(regs);
 }
 
+/* This function needs to be protected from pre-emption. */
+static int
+slot_index_alloc_quirk_v2_hw(struct hisi_hba *hisi_hba, int *slot_idx,
+		       struct domain_device *device)
+{
+	unsigned int index = 0;
+	void *bitmap = hisi_hba->slot_index_tags;
+	int sata_dev = dev_is_sata(device);
+
+	while (1) {
+		index = find_next_zero_bit(bitmap, hisi_hba->slot_index_count,
+					   index);
+		if (index >= hisi_hba->slot_index_count)
+			return -SAS_QUEUE_FULL;
+		/*
+		 * SAS IPTT bit0 should be 1
+		 */
+		if (sata_dev || (index & 1))
+			break;
+		index++;
+	}
+
+	set_bit(index, bitmap);
+	*slot_idx = index;
+	return 0;
+}
+
 static void config_phy_opt_mode_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
@@ -2167,6 +2194,7 @@ static int hisi_sas_v2_init(struct hisi_hba *hisi_hba)
 static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.setup_itct = setup_itct_v2_hw,
+	.slot_index_alloc = slot_index_alloc_quirk_v2_hw,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
 	.free_device = free_device_v2_hw,
-- 
1.9.1
