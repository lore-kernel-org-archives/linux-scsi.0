From: John Garry <john.garry@huawei.com>
Subject: [PATCH 5/6] scsi: hisi_sas: Ignore the error code between phy down to phy up
Date: Wed, 29 May 2019 17:58:46 +0800
Message-ID: <1559123927-160502-6-git-send-email-john.garry@huawei.com>
References: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1559123927-160502-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Luo Jiaxing <luojiaxing@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

Several error code will be generated between PHY down to up.

This issue was introduced by HW design, so the designers come to
a conclusion that we should ignore these several error code.

Signed-off-by: Jiaxing Luo <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 492ada65d41a..fbf0a1e9c8c2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -911,8 +911,14 @@ static void enable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 cfg = hisi_sas_phy_read32(hisi_hba, phy_no, PHY_CFG);
+	u32 irq_msk = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2_MSK);
+	static const u32 msk = BIT(CHL_INT2_RX_DISP_ERR_OFF) |
+			       BIT(CHL_INT2_RX_CODE_ERR_OFF) |
+			       BIT(CHL_INT2_RX_INVLD_DW_OFF);
 	u32 state;
 
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, msk | irq_msk);
+
 	cfg &= ~PHY_CFG_ENA_MSK;
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 
@@ -923,6 +929,15 @@ static void disable_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 		cfg |= PHY_CFG_PHY_RST_MSK;
 		hisi_sas_phy_write32(hisi_hba, phy_no, PHY_CFG, cfg);
 	}
+
+	udelay(1);
+
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
+	hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2, msk);
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2_MSK, irq_msk);
 }
 
 static void start_phy_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
-- 
2.17.1
