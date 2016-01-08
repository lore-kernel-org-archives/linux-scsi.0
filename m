From: John Garry <john.garry@huawei.com>
Subject: [PATCH 14/23] hisi_sas: add v2 channel interrupt handler
Date: Fri, 8 Jan 2016 22:15:33 +0800
Message-ID: <1452262542-64589-15-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

This also includes broadcast handler. Unlike v1 hw,
broadcast does not have its own dedicated interrupt.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 79 ++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index d70e5d7..f276d20 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -258,6 +258,7 @@ struct hisi_sas_complete_v2_hdr {
 
 enum {
 	HISI_SAS_PHY_PHY_UPDOWN,
+	HISI_SAS_PHY_CHNL_INT,
 	HISI_SAS_PHY_INT_NR
 };
 
@@ -782,8 +783,86 @@ end:
 	return res;
 }
 
+static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_ha_struct *sas_ha = &hisi_hba->sha;
+	unsigned long flags;
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 1);
+
+	spin_lock_irqsave(&hisi_hba->lock, flags);
+	sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+
+	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
+			     CHL_INT0_SL_RX_BCST_ACK_MSK);
+	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
+}
+
+static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
+{
+	struct hisi_hba *hisi_hba = p;
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 ent_msk, ent_tmp, irq_msk;
+	int phy_no = 0;
+
+	ent_msk = hisi_sas_read32(hisi_hba, ENT_INT_SRC_MSK3);
+	ent_tmp = ent_msk;
+	ent_msk |= ENT_INT_SRC_MSK3_ENT95_MSK_MSK;
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, ent_msk);
+
+	irq_msk = (hisi_sas_read32(hisi_hba, HGC_INVLD_DQE_INFO) >>
+			HGC_INVLD_DQE_INFO_FB_CH3_OFF) & 0x1ff;
+
+	while (irq_msk) {
+		if (irq_msk & (1 << phy_no)) {
+			u32 irq_value0 = hisi_sas_phy_read32(hisi_hba, phy_no,
+							     CHL_INT0);
+			u32 irq_value1 = hisi_sas_phy_read32(hisi_hba, phy_no,
+							     CHL_INT1);
+			u32 irq_value2 = hisi_sas_phy_read32(hisi_hba, phy_no,
+							     CHL_INT2);
+
+			if (irq_value1) {
+				if (irq_value1 & (CHL_INT1_DMAC_RX_ECC_ERR_MSK |
+						  CHL_INT1_DMAC_TX_ECC_ERR_MSK))
+					panic("%s: DMAC RX/TX ecc bad error! (0x%x)",
+						dev_name(dev), irq_value1);
+
+				hisi_sas_phy_write32(hisi_hba, phy_no,
+						     CHL_INT1, irq_value1);
+			}
+
+			if (irq_value2)
+				hisi_sas_phy_write32(hisi_hba, phy_no,
+						     CHL_INT2, irq_value2);
+
+
+			if (irq_value0) {
+				if (irq_value0 & CHL_INT0_SL_RX_BCST_ACK_MSK)
+					phy_bcast_v2_hw(phy_no, hisi_hba);
+
+				hisi_sas_phy_write32(hisi_hba, phy_no,
+						CHL_INT0, irq_value0
+						& (~CHL_INT0_HOTPLUG_TOUT_MSK)
+						& (~CHL_INT0_SL_PHY_ENABLE_MSK)
+						& (~CHL_INT0_NOT_RDY_MSK));
+			}
+		}
+		irq_msk &= ~(1 << phy_no);
+		phy_no++;
+	}
+
+	hisi_sas_write32(hisi_hba, ENT_INT_SRC_MSK3, ent_tmp);
+
+	return IRQ_HANDLED;
+}
+
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_phy_updown_v2_hw,
+	int_chnl_int_v2_hw,
 };
 
 /**
-- 
1.9.1
