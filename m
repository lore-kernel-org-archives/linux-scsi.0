From: John Garry <john.garry@huawei.com>
Subject: [PATCH 16/19] scsi: hisi_sas: add phy_set_linkrate_v3_hw()
Date: Fri, 11 Aug 2017 00:09:41 +0800
Message-ID: <1502381384-219889-17-git-send-email-john.garry@huawei.com>
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

Add function to set linkrate for v3 hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 111e45c..8e4bfad 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1680,6 +1680,44 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 	return 0;
 }
 
+static void phy_set_linkrate_v3_hw(struct hisi_hba *hisi_hba, int phy_no,
+		struct sas_phy_linkrates *r)
+{
+	u32 prog_phy_link_rate =
+		hisi_sas_phy_read32(hisi_hba, phy_no, PROG_PHY_LINK_RATE);
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	int i;
+	enum sas_linkrate min, max;
+	u32 rate_mask = 0;
+
+	if (r->maximum_linkrate == SAS_LINK_RATE_UNKNOWN) {
+		max = sas_phy->phy->maximum_linkrate;
+		min = r->minimum_linkrate;
+	} else if (r->minimum_linkrate == SAS_LINK_RATE_UNKNOWN) {
+		max = r->maximum_linkrate;
+		min = sas_phy->phy->minimum_linkrate;
+	} else
+		return;
+
+	sas_phy->phy->maximum_linkrate = max;
+	sas_phy->phy->minimum_linkrate = min;
+
+	min -= SAS_LINK_RATE_1_5_GBPS;
+	max -= SAS_LINK_RATE_1_5_GBPS;
+
+	for (i = 0; i <= max; i++)
+		rate_mask |= 1 << (i * 2);
+
+	prog_phy_link_rate &= ~0xff;
+	prog_phy_link_rate |= rate_mask;
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, PROG_PHY_LINK_RATE,
+			prog_phy_link_rate);
+
+	phy_hard_reset_v3_hw(hisi_hba, phy_no);
+}
+
 static void interrupt_disable_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct pci_dev *pdev = hisi_hba->pci_dev;
@@ -1760,6 +1798,7 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 	.phy_disable = disable_phy_v3_hw,
 	.phy_hard_reset = phy_hard_reset_v3_hw,
 	.phy_get_max_linkrate = phy_get_max_linkrate_v3_hw,
+	.phy_set_linkrate = phy_set_linkrate_v3_hw,
 	.dereg_device = dereg_device_v3_hw,
 	.soft_reset = soft_reset_v3_hw,
 	.get_phys_state = get_phys_state_v3_hw,
-- 
1.9.1
