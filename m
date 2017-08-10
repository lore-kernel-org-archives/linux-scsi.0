From: John Garry <john.garry@huawei.com>
Subject: [PATCH 04/19] scsi: hisi_sas: add v2 hw DFX feature
Date: Fri, 11 Aug 2017 00:09:29 +0800
Message-ID: <1502381384-219889-5-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Add DFX feature for v2 hw. We are adding support for
the following errors:
- loss_of_dword_sync_count
- invalid_dword_count
- phy_reset_problem_count
- running_disparity_error_count

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  7 ++++++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 22 ++++++++++++++++++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 3c4defa..ef2238c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -193,6 +193,7 @@ struct hisi_sas_hw {
 	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_disable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_hard_reset)(struct hisi_hba *hisi_hba, int phy_no);
+	void (*get_events)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_set_linkrate)(struct hisi_hba *hisi_hba, int phy_no,
 			struct sas_phy_linkrates *linkrates);
 	enum sas_linkrate (*phy_get_max_linkrate)(void);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index bd1d619..aaa7296 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -764,7 +764,12 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 	case PHY_FUNC_SET_LINK_RATE:
 		hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, funcdata);
 		break;
-
+	case PHY_FUNC_GET_EVENTS:
+		if (hisi_hba->hw->get_events) {
+			hisi_hba->hw->get_events(hisi_hba, phy_no);
+			break;
+		}
+		/* fallthru */
 	case PHY_FUNC_RELEASE_SPINUP_HOLD:
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a762b25..41e8033 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -256,6 +256,8 @@
 #define LINK_DFX2_RCVR_HOLD_STS_MSK	(0x1 << LINK_DFX2_RCVR_HOLD_STS_OFF)
 #define LINK_DFX2_SEND_HOLD_STS_OFF	10
 #define LINK_DFX2_SEND_HOLD_STS_MSK	(0x1 << LINK_DFX2_SEND_HOLD_STS_OFF)
+#define SAS_ERR_CNT4_REG		(PORT_BASE + 0x290)
+#define SAS_ERR_CNT6_REG		(PORT_BASE + 0x298)
 #define PHY_CTRL_RDY_MSK		(PORT_BASE + 0x2b0)
 #define PHYCTRL_NOT_RDY_MSK		(PORT_BASE + 0x2b4)
 #define PHYCTRL_DWS_RESET_MSK		(PORT_BASE + 0x2b8)
@@ -1360,6 +1362,25 @@ static void phy_hard_reset_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
 	start_phy_v2_hw(hisi_hba, phy_no);
 }
 
+static void phy_get_events_v2_hw(struct hisi_hba *hisi_hba, int phy_no)
+{
+	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+	struct asd_sas_phy *sas_phy = &phy->sas_phy;
+	struct sas_phy *sphy = sas_phy->phy;
+	u32 err4_reg_val, err6_reg_val;
+
+	/* loss dword syn, phy reset problem */
+	err4_reg_val = hisi_sas_phy_read32(hisi_hba, phy_no, SAS_ERR_CNT4_REG);
+
+	/* disparity err, invalid dword */
+	err6_reg_val = hisi_sas_phy_read32(hisi_hba, phy_no, SAS_ERR_CNT6_REG);
+
+	sphy->loss_of_dword_sync_count += (err4_reg_val >> 16) & 0xFFFF;
+	sphy->phy_reset_problem_count += err4_reg_val & 0xFFFF;
+	sphy->invalid_dword_count += (err6_reg_val & 0xFF0000) >> 16;
+	sphy->running_disparity_error_count += err6_reg_val & 0xFF;
+}
+
 static void start_phys_v2_hw(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -3457,6 +3478,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 	.phy_enable = enable_phy_v2_hw,
 	.phy_disable = disable_phy_v2_hw,
 	.phy_hard_reset = phy_hard_reset_v2_hw,
+	.get_events = phy_get_events_v2_hw,
 	.phy_set_linkrate = phy_set_linkrate_v2_hw,
 	.phy_get_max_linkrate = phy_get_max_linkrate_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
-- 
1.9.1
