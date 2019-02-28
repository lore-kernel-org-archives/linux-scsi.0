From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/6] scsi: hisi_sas: print PHY RX errors count for later revision of v3 hw
Date: Thu, 28 Feb 2019 22:50:59 +0800
Message-ID: <1551365462-128193-4-git-send-email-john.garry@huawei.com>
References: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1551365462-128193-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

The later revision of v3 hw has added an function of interrupt coalesce
according to time for PHY RX errors. We set the coalesce time to 1s.
Then we print PHY RX errors count when PHY RX errors happen, and don't
need to worry that there may be too much log prints.

Besides, we use hisi_sas_phy.lock to protect error count value. Because
we update them by calling phy_get_events_v3_hw(), which is also used by
core driver (for get PHY events function).

We relocate phy_get_events_v3_hw() to avoid a further declaration.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 84 ++++++++++++++++++--------
 2 files changed, 60 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 6c87bd34509a..515aee9318a4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -161,6 +161,7 @@ struct hisi_sas_phy {
 	u8		in_reset;
 	u8		reserved[2];
 	u32		phy_type;
+	u32		code_violation_err_count;
 	enum sas_linkrate	minimum_linkrate;
 	enum sas_linkrate	maximum_linkrate;
 };
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 151a102c4cc7..720721196b12 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -181,6 +181,8 @@
 #define CHL_INT1_DMAC_RX_AXI_RD_ERR_OFF	22
 #define CHL_INT2			(PORT_BASE + 0x1bc)
 #define CHL_INT2_SL_IDAF_TOUT_CONF_OFF	0
+#define CHL_INT2_RX_DISP_ERR_OFF	28
+#define CHL_INT2_RX_CODE_ERR_OFF	29
 #define CHL_INT2_RX_INVLD_DW_OFF	30
 #define CHL_INT2_STP_LINK_TIMEOUT_OFF	31
 #define CHL_INT0_MSK			(PORT_BASE + 0x1c0)
@@ -544,6 +546,8 @@ static void init_reg_v3_hw(struct hisi_hba *hisi_hba)
 		hisi_sas_phy_write32(hisi_hba, i, STP_LINK_TIMER, 0x7f7a120);
 		hisi_sas_phy_write32(hisi_hba, i, CON_CFG_DRIVER, 0x2a0a01);
 		hisi_sas_phy_write32(hisi_hba, i, SAS_SSP_CON_TIMER_CFG, 0x32);
+		hisi_sas_phy_write32(hisi_hba, i, SAS_EC_INT_COAL_TIME,
+				     0x30f4240);
 		/* used for 12G negotiate */
 		hisi_sas_phy_write32(hisi_hba, i, COARSETUNE_TIME, 0x1e);
 		hisi_sas_phy_write32(hisi_hba, i, AIP_LIMIT, 0x2ffff);
@@ -1576,6 +1580,39 @@ static void handle_chl_int1_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT1, irq_value);
 }
 
+static void phy_get_events_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_phy *sphy = sas_phy->phy;
+	unsigned long flags;
+	u32 reg_value;
+
+	spin_lock_irqsave(&phy->lock, flags);
+
+	/* loss dword sync */
+	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DWS_LOST);
+	sphy->loss_of_dword_sync_count += reg_value;
+
+	/* phy reset problem */
+	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_RESET_PROB);
+	sphy->phy_reset_problem_count += reg_value;
+
+	/* invalid dword */
+	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
+	sphy->invalid_dword_count += reg_value;
+
+	/* disparity err */
+	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
+	sphy->running_disparity_error_count += reg_value;
+
+	/* code violation error */
+	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_CODE_ERR);
+	phy->code_violation_err_count += reg_value;
+
+	spin_unlock_irqrestore(&phy->lock, flags);
+}
+
 static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 {
 	u32 irq_msk = hisi_sas_phy_read32(hisi_hba, phy_no, CHL_INT2_MSK);
@@ -1583,6 +1620,9 @@ static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct pci_dev *pci_dev = hisi_hba->pci_dev;
 	struct device *dev = hisi_hba->dev;
+	static const u32 msk = BIT(CHL_INT2_RX_DISP_ERR_OFF) |
+			BIT(CHL_INT2_RX_CODE_ERR_OFF) |
+			BIT(CHL_INT2_RX_INVLD_DW_OFF);
 
 	irq_value &= ~irq_msk;
 	if (!irq_value)
@@ -1603,6 +1643,25 @@ static void handle_chl_int2_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 			hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
 	}
 
+	if (pci_dev->revision > 0x20 && (irq_value & msk)) {
+		struct asd_sas_phy *sas_phy = &phy->sas_phy;
+		struct sas_phy *sphy = sas_phy->phy;
+
+		phy_get_events_v3_hw(hisi_hba, phy_no);
+
+		if (irq_value & BIT(CHL_INT2_RX_INVLD_DW_OFF))
+			dev_info(dev, "phy%d invalid dword cnt:   %u\n", phy_no,
+				 sphy->invalid_dword_count);
+
+		if (irq_value & BIT(CHL_INT2_RX_CODE_ERR_OFF))
+			dev_info(dev, "phy%d code violation cnt:  %u\n", phy_no,
+				 phy->code_violation_err_count);
+
+		if (irq_value & BIT(CHL_INT2_RX_DISP_ERR_OFF))
+			dev_info(dev, "phy%d disparity error cnt: %u\n", phy_no,
+				 sphy->running_disparity_error_count);
+	}
+
 	if ((irq_value & BIT(CHL_INT2_RX_INVLD_DW_OFF)) &&
 	    (pci_dev->revision == 0x20)) {
 		u32 reg_value;
@@ -2231,31 +2290,6 @@ static u32 get_phys_state_v3_hw(struct hisi_hba *hisi_hba)
 	return hisi_sas_read32(hisi_hba, PHY_STATE);
 }
 
-static void phy_get_events_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
-{
-	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
-	struct asd_sas_phy *sas_phy = &phy->sas_phy;
-	struct sas_phy *sphy = sas_phy->phy;
-	u32 reg_value;
-
-	/* loss dword sync */
-	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DWS_LOST);
-	sphy->loss_of_dword_sync_count += reg_value;
-
-	/* phy reset problem */
-	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_RESET_PROB);
-	sphy->phy_reset_problem_count += reg_value;
-
-	/* invalid dword */
-	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_INVLD_DW);
-	sphy->invalid_dword_count += reg_value;
-
-	/* disparity err */
-	reg_value = hisi_sas_phy_read32(hisi_hba, phy_no, ERR_CNT_DISP_ERR);
-	sphy->running_disparity_error_count += reg_value;
-
-}
-
 static int disable_host_v3_hw(struct hisi_hba *hisi_hba)
 {
 	struct device *dev = hisi_hba->dev;
-- 
2.17.1
