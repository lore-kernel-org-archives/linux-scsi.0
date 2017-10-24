From: John Garry <john.garry@huawei.com>
Subject: [PATCH 06/19] scsi: hisi_sas: us start_phy in PHY_FUNC_LINK_RESET
Date: Tue, 24 Oct 2017 23:51:36 +0800
Message-ID: <1508860309-212397-7-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When a PHY_FUNC_LINK_RESET is issued, we need to fill the
transport identify_frame to SAS controller before the
PHYs are enabled.

Without this, we may find that if a PHY which belonged to
a wideport before the reset may generate a new port id.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 07538cf..ea4b5d6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -198,7 +198,7 @@ struct hisi_sas_hw {
 	int (*slot_complete)(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_slot *slot);
 	void (*phys_init)(struct hisi_hba *hisi_hba);
-	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
+	void (*phy_start)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_disable)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*phy_hard_reset)(struct hisi_hba *hisi_hba, int phy_no);
 	void (*get_events)(struct hisi_hba *hisi_hba, int phy_no);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index f49a131..88d90dc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -765,7 +765,7 @@ static int hisi_sas_control_phy(struct asd_sas_phy *sas_phy, enum phy_func func,
 	case PHY_FUNC_LINK_RESET:
 		hisi_hba->hw->phy_disable(hisi_hba, phy_no);
 		msleep(100);
-		hisi_hba->hw->phy_enable(hisi_hba, phy_no);
+		hisi_hba->hw->phy_start(hisi_hba, phy_no);
 		break;
 
 	case PHY_FUNC_DISABLE:
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 08eca20..00b5ee4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1857,7 +1857,7 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 	.start_delivery = start_delivery_v1_hw,
 	.slot_complete = slot_complete_v1_hw,
 	.phys_init = phys_init_v1_hw,
-	.phy_enable = enable_phy_v1_hw,
+	.phy_start = start_phy_v1_hw,
 	.phy_disable = disable_phy_v1_hw,
 	.phy_hard_reset = phy_hard_reset_v1_hw,
 	.phy_set_linkrate = phy_set_linkrate_v1_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 3b2e5b5..50a0fc8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -3463,7 +3463,7 @@ static int soft_reset_v2_hw(struct hisi_hba *hisi_hba)
 	.start_delivery = start_delivery_v2_hw,
 	.slot_complete = slot_complete_v2_hw,
 	.phys_init = phys_init_v2_hw,
-	.phy_enable = enable_phy_v2_hw,
+	.phy_start = start_phy_v2_hw,
 	.phy_disable = disable_phy_v2_hw,
 	.phy_hard_reset = phy_hard_reset_v2_hw,
 	.get_events = phy_get_events_v2_hw,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index ac499e9..67ebd8f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1781,7 +1781,7 @@ static int soft_reset_v3_hw(struct hisi_hba *hisi_hba)
 	.start_delivery = start_delivery_v3_hw,
 	.slot_complete = slot_complete_v3_hw,
 	.phys_init = phys_init_v3_hw,
-	.phy_enable = enable_phy_v3_hw,
+	.phy_start = start_phy_v3_hw,
 	.phy_disable = disable_phy_v3_hw,
 	.phy_hard_reset = phy_hard_reset_v3_hw,
 	.phy_get_max_linkrate = phy_get_max_linkrate_v3_hw,
-- 
1.9.1
