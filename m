From: John Garry <john.garry@huawei.com>
Subject: [PATCH 17/23] scsi: hisi_sas: handle PHY UP+DOWN simultaneous irq
Date: Thu, 23 Mar 2017 01:25:33 +0800
Message-ID: <1490203539-228029-18-git-send-email-john.garry@huawei.com>
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

Handle the situation that PHY UP and DOWN irq happen simultaneously.
There is no mechanism of SoC HW to ensure this situation will never
happen. So, we add this handle just in case.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 56 +++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8e869d9..45bd69d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2285,7 +2285,7 @@ static int prep_abort_v2_hw(struct hisi_hba *hisi_hba,
 
 static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
-	int i, res = 0;
+	int i, res = IRQ_HANDLED;
 	u32 context, port_id, link_rate, hard_phy_linkrate;
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -2373,7 +2373,6 @@ static bool check_any_wideports_v2_hw(struct hisi_hba *hisi_hba)
 
 static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
-	int res = 0;
 	u32 phy_state, sl_ctrl, txid_auto;
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct hisi_sas_port *port = phy->port;
@@ -2398,7 +2397,7 @@ static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0, CHL_INT0_NOT_RDY_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, PHYCTRL_NOT_RDY_MSK, 0);
 
-	return res;
+	return IRQ_HANDLED;
 }
 
 static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
@@ -2406,35 +2405,58 @@ static irqreturn_t int_phy_updown_v2_hw(int irq_no, void *p)
 	struct hisi_hba *hisi_hba = p;
 	u32 irq_msk;
 	int phy_no = 0;
-	irqreturn_t res = IRQ_HANDLED;
 
 	irq_msk = (hisi_sas_read32(hisi_hba, HGC_INVLD_DQE_INFO)
 		   >> HGC_INVLD_DQE_INFO_FB_CH0_OFF) & 0x1ff;
 	while (irq_msk) {
 		if (irq_msk  & 1) {
-			u32 irq_value = hisi_sas_phy_read32(hisi_hba, phy_no,
-							    CHL_INT0);
+			u32 reg_value = hisi_sas_phy_read32(hisi_hba, phy_no,
+					    CHL_INT0);
+
+			switch (reg_value & (CHL_INT0_NOT_RDY_MSK |
+					CHL_INT0_SL_PHY_ENABLE_MSK)) {
 
-			if (irq_value & CHL_INT0_SL_PHY_ENABLE_MSK)
+			case CHL_INT0_SL_PHY_ENABLE_MSK:
 				/* phy up */
-				if (phy_up_v2_hw(phy_no, hisi_hba)) {
-					res = IRQ_NONE;
-					goto end;
-				}
+				if (phy_up_v2_hw(phy_no, hisi_hba) ==
+				    IRQ_NONE)
+					return IRQ_NONE;
+				break;
 
-			if (irq_value & CHL_INT0_NOT_RDY_MSK)
+			case CHL_INT0_NOT_RDY_MSK:
 				/* phy down */
-				if (phy_down_v2_hw(phy_no, hisi_hba)) {
-					res = IRQ_NONE;
-					goto end;
+				if (phy_down_v2_hw(phy_no, hisi_hba) ==
+				    IRQ_NONE)
+					return IRQ_NONE;
+				break;
+
+			case (CHL_INT0_NOT_RDY_MSK |
+					CHL_INT0_SL_PHY_ENABLE_MSK):
+				reg_value = hisi_sas_read32(hisi_hba,
+						PHY_STATE);
+				if (reg_value & BIT(phy_no)) {
+					/* phy up */
+					if (phy_up_v2_hw(phy_no, hisi_hba) ==
+					    IRQ_NONE)
+						return IRQ_NONE;
+				} else {
+					/* phy down */
+					if (phy_down_v2_hw(phy_no, hisi_hba) ==
+					    IRQ_NONE)
+						return IRQ_NONE;
 				}
+				break;
+
+			default:
+				break;
+			}
+
 		}
 		irq_msk >>= 1;
 		phy_no++;
 	}
 
-end:
-	return res;
+	return IRQ_HANDLED;
 }
 
 static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
-- 
1.9.1
