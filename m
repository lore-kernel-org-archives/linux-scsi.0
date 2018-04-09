From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 1/1] scsi/ufs: qcom: Don't enable PHY_QCOM_UFS by default
Date: Mon,  9 Apr 2018 18:54:04 +0530
Message-ID: <20180409132404.20876-1-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, kishon@ti.com
Cc: jejb@linux.vnet.ibm.com, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

While we try to transition from a separate ufs phy driver to a
more integrated qmp phy driver, don't let SCSI_UFS_QCOM to
enable PHY_QCOM_UFS config by default.
The users should enable this in their defconfigs.
Also add inline definitions for couple of functions -
a) ufs_qcom_phy_set_tx_lane_enable()
b) void ufs_qcom_phy_save_controller_version()
to enable clean build for SCSI_UFS_QCOM.

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
---
 drivers/scsi/ufs/Kconfig         |  1 -
 include/linux/phy/phy-qcom-ufs.h | 15 ++++++++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index e27b4d4e6ae2..7e8898b6eb67 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -91,7 +91,6 @@ config SCSI_UFS_DWC_TC_PLATFORM
 config SCSI_UFS_QCOM
 	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
-	select PHY_QCOM_UFS
 	help
 	  This selects the QCOM specific additions to UFSHCD platform driver.
 	  UFS host on QCOM needs some vendor specific configuration before
diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
index 0a2c18a9771d..1388c2a2965e 100644
--- a/include/linux/phy/phy-qcom-ufs.h
+++ b/include/linux/phy/phy-qcom-ufs.h
@@ -31,8 +31,21 @@ void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
  */
 void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
 
+#if IS_ENABLED(CONFIG_PHY_QCOM_UFS)
 int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
 void ufs_qcom_phy_save_controller_version(struct phy *phy,
-			u8 major, u16 minor, u16 step);
+					  u8 major, u16 minor, u16 step);
+#else
+static inline int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes)
+{
+	return -ENOSYS;
+}
+
+static inline void ufs_qcom_phy_save_controller_version(struct phy *phy,
+							u8 major, u16 minor,
+							u16 step)
+{
+}
+#endif /* PHY_QCOM_UFS */
 
 #endif /* PHY_QCOM_UFS_H_ */
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
