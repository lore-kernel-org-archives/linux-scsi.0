From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/19] scsi: hisi_sas: improve int_chnl_int_v2_hw() consistency with v3 hw
Date: Sat, 9 Dec 2017 01:16:42 +0800
Message-ID: <1512753410-50924-12-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2230 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754362AbdLHQbH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Dec 2017 11:31:07 -0500
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>

From: Xiaofei Tan <tanxiaofei@huawei.com>

Change code format of int_chnl_int_v2_hw() to be consistent with
v3 hw to reduce an tag indent.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 58 ++++++++++++++++------------------
 1 file changed, 28 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8d6886a..4c4a000 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2848,40 +2848,38 @@ static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
 			HGC_INVLD_DQE_INFO_FB_CH3_OFF) & 0x1ff;
 
 	while (irq_msk) {
-		if (irq_msk & (1 << phy_no)) {
-			u32 irq_value0 = hisi_sas_phy_read32(hisi_hba, phy_no,
-							     CHL_INT0);
-			u32 irq_value1 = hisi_sas_phy_read32(hisi_hba, phy_no,
-							     CHL_INT1);
-			u32 irq_value2 = hisi_sas_phy_read32(hisi_hba, phy_no,
-							     CHL_INT2);
-
-			if (irq_value1) {
-				if (irq_value1 & (CHL_INT1_DMAC_RX_ECC_ERR_MSK |
-						  CHL_INT1_DMAC_TX_ECC_ERR_MSK))
-					panic("%s: DMAC RX/TX ecc bad error!\
-					       (0x%x)",
-					      dev_name(dev), irq_value1);
-
-				hisi_sas_phy_write32(hisi_hba, phy_no,
-						     CHL_INT1, irq_value1);
-			}
+		u32 irq_value0 = hisi_sas_phy_read32(hisi_hba, phy_no,
+						     CHL_INT0);
+		u32 irq_value1 = hisi_sas_phy_read32(hisi_hba, phy_no,
+						     CHL_INT1);
+		u32 irq_value2 = hisi_sas_phy_read32(hisi_hba, phy_no,
+						     CHL_INT2);
+
+		if ((irq_msk & (1 << phy_no)) && irq_value1) {
+			if (irq_value1 & (CHL_INT1_DMAC_RX_ECC_ERR_MSK |
+					  CHL_INT1_DMAC_TX_ECC_ERR_MSK))
+				panic("%s: DMAC RX/TX ecc bad error!\
+				       (0x%x)",
+				      dev_name(dev), irq_value1);
 
-			if (irq_value2)
-				hisi_sas_phy_write32(hisi_hba, phy_no,
-						     CHL_INT2, irq_value2);
+			hisi_sas_phy_write32(hisi_hba, phy_no,
+					     CHL_INT1, irq_value1);
+		}
 
+		if ((irq_msk & (1 << phy_no)) && irq_value2)
+			hisi_sas_phy_write32(hisi_hba, phy_no,
+					     CHL_INT2, irq_value2);
 
-			if (irq_value0) {
-				if (irq_value0 & CHL_INT0_SL_RX_BCST_ACK_MSK)
-					phy_bcast_v2_hw(phy_no, hisi_hba);
 
-				hisi_sas_phy_write32(hisi_hba, phy_no,
-						CHL_INT0, irq_value0
-						& (~CHL_INT0_HOTPLUG_TOUT_MSK)
-						& (~CHL_INT0_SL_PHY_ENABLE_MSK)
-						& (~CHL_INT0_NOT_RDY_MSK));
-			}
+		if ((irq_msk & (1 << phy_no)) && irq_value0) {
+			if (irq_value0 & CHL_INT0_SL_RX_BCST_ACK_MSK)
+				phy_bcast_v2_hw(phy_no, hisi_hba);
+
+			hisi_sas_phy_write32(hisi_hba, phy_no,
+					CHL_INT0, irq_value0
+					& (~CHL_INT0_HOTPLUG_TOUT_MSK)
+					& (~CHL_INT0_SL_PHY_ENABLE_MSK)
+					& (~CHL_INT0_NOT_RDY_MSK));
 		}
 		irq_msk &= ~(1 << phy_no);
 		phy_no++;
-- 
1.9.1
