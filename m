From: John Garry <john.garry@huawei.com>
Subject: [PATCH 23/23] scsi: hisi_sas: add is_sata_phy_v2_hw()
Date: Thu, 23 Mar 2017 01:25:39 +0800
Message-ID: <1490203539-228029-24-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Add helper function is_sata_phy_v2_hw() to judge whether
the attached device is SATA disk for a root PHY.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e9c7188..a3af380 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1075,6 +1075,17 @@ static void enable_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 }
 
+static bool is_sata_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	u32 context;
+
+	context = hisi_sas_read32(hisi_hba, PHY_CONTEXT);
+	if (context & (1 << phy_no))
+		return true;
+
+	return false;
+}
+
 static void disable_phy_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
@@ -2286,7 +2297,7 @@ static int prep_abort_v2_hw(struct hisi_hba *hisi_hba,
 static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = IRQ_HANDLED;
-	u32 context, port_id, link_rate, hard_phy_linkrate;
+	u32 port_id, link_rate, hard_phy_linkrate;
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
 	struct device *dev = &hisi_hba->pdev->dev;
@@ -2295,9 +2306,7 @@ static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_PHY_ENA_MSK, 1);
 
-	/* Check for SATA dev */
-	context = hisi_sas_read32(hisi_hba, PHY_CONTEXT);
-	if (context & (1 << phy_no))
+	if (is_sata_phy_v2_hw(hisi_hba, phy_no))
 		goto end;
 
 	if (phy_no == 8) {
-- 
1.9.1
