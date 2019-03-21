From: Evan Green <evgreen@chromium.org>
Subject: [PATCH v5 6/8] scsi: ufs: qcom: Expose the reset controller for PHY
Date: Thu, 21 Mar 2019 10:17:58 -0700
Message-ID: <20190321171800.104681-7-evgreen@chromium.org>
References: <20190321171800.104681-1-evgreen@chromium.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321171800.104681-1-evgreen@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Stephen Boyd <swboyd@chromium.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Can Guo <cang@codeaurora.org>, Vivek Gautam <vivek.gautam@codeaurora.org>, Douglas Anderson <dianders@chromium.org>, Asutosh Das <asutoshd@codeaurora.org>, Evan Green <evgreen@chromium.org>, Pedro Sousa <pedrom.sousa@synopsys.com>, liwei <liwei213@huawei.com>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>, linux-kernel@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, Andy Gross <andy.gross@linaro.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Avri Altman <avri.altman@wdc.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Janek Kotas <jank@cadence.com>, David Brown <david.brown@linaro.org>
List-Id: linux-scsi@vger.kernel.org

Expose a reset controller that the phy will later use to control its
own PHY reset in the UFS controller. This will enable the combining
of PHY init functionality into a single function.

Signed-off-by: Evan Green <evgreen@chromium.org>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>

---
Note: The remaining changes in this series need this change, since
the PHYs now depend on getting the reset controller.

Changes in v5: None
Changes in v4: None
Changes in v3:
- Refactor to only expose the reset controller in one change (Stephen).
- Add period to comment (Stephen).
- Reset err to 0 in ignored error case (Stephen).
- Add include of reset-controller.h (Stephen)

Changes in v2:
- Remove include of reset.h (Stephen)
- Fix error print of phy_power_on (Stephen)
- Comment for reset controller warnings on id != 0 (Stephen)
- Add static to ufs_qcom_reset_ops (Stephen).

 drivers/scsi/ufs/Kconfig    |  1 +
 drivers/scsi/ufs/ufs-qcom.c | 52 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h |  4 +++
 3 files changed, 57 insertions(+)

diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
index 6db37cf306b0..179bda374544 100644
--- a/drivers/scsi/ufs/Kconfig
+++ b/drivers/scsi/ufs/Kconfig
@@ -99,6 +99,7 @@ config SCSI_UFS_DWC_TC_PLATFORM
 config SCSI_UFS_QCOM
 	tristate "QCOM specific hooks to UFS controller platform driver"
 	depends on SCSI_UFSHCD_PLATFORM && ARCH_QCOM
+	select RESET_CONTROLLER
 	help
 	  This selects the QCOM specific additions to UFSHCD platform driver.
 	  UFS host on QCOM needs some vendor specific configuration before
diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3aeadb14aae1..ab05ef5cfdcd 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -16,6 +16,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/phy/phy.h>
+#include <linux/reset-controller.h>
 
 #include "ufshcd.h"
 #include "ufshcd-pltfrm.h"
@@ -49,6 +50,11 @@ static void ufs_qcom_get_default_testbus_cfg(struct ufs_qcom_host *host);
 static int ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(struct ufs_hba *hba,
 						       u32 clk_cycles);
 
+static struct ufs_qcom_host *rcdev_to_ufs_host(struct reset_controller_dev *rcd)
+{
+	return container_of(rcd, struct ufs_qcom_host, rcdev);
+}
+
 static void ufs_qcom_dump_regs_wrapper(struct ufs_hba *hba, int offset, int len,
 				       const char *prefix, void *priv)
 {
@@ -1147,6 +1153,41 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 	return err;
 }
 
+static int
+ufs_qcom_reset_assert(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
+
+	/* Currently this code only knows about a single reset. */
+	WARN_ON(id);
+	ufs_qcom_assert_reset(host->hba);
+	/* provide 1ms delay to let the reset pulse propagate. */
+	usleep_range(1000, 1100);
+	return 0;
+}
+
+static int
+ufs_qcom_reset_deassert(struct reset_controller_dev *rcdev, unsigned long id)
+{
+	struct ufs_qcom_host *host = rcdev_to_ufs_host(rcdev);
+
+	/* Currently this code only knows about a single reset. */
+	WARN_ON(id);
+	ufs_qcom_deassert_reset(host->hba);
+
+	/*
+	 * after reset deassertion, phy will need all ref clocks,
+	 * voltage, current to settle down before starting serdes.
+	 */
+	usleep_range(1000, 1100);
+	return 0;
+}
+
+static const struct reset_control_ops ufs_qcom_reset_ops = {
+	.assert = ufs_qcom_reset_assert,
+	.deassert = ufs_qcom_reset_deassert,
+};
+
 #define	ANDROID_BOOT_DEV_MAX	30
 static char android_boot_dev[ANDROID_BOOT_DEV_MAX];
 
@@ -1191,6 +1232,17 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
+	/* Fire up the reset controller. Failure here is non-fatal. */
+	host->rcdev.of_node = dev->of_node;
+	host->rcdev.ops = &ufs_qcom_reset_ops;
+	host->rcdev.owner = dev->driver->owner;
+	host->rcdev.nr_resets = 1;
+	err = devm_reset_controller_register(dev, &host->rcdev);
+	if (err) {
+		dev_warn(dev, "Failed to register reset controller\n");
+		err = 0;
+	}
+
 	/*
 	 * voting/devoting device ref_clk source is time consuming hence
 	 * skip devoting it during aggressive clock gating. This clock
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index c114826316eb..68a880185752 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -14,6 +14,8 @@
 #ifndef UFS_QCOM_H_
 #define UFS_QCOM_H_
 
+#include <linux/reset-controller.h>
+
 #define MAX_UFS_QCOM_HOSTS	1
 #define MAX_U32                 (~(u32)0)
 #define MPHY_TX_FSM_STATE       0x41
@@ -237,6 +239,8 @@ struct ufs_qcom_host {
 	/* Bitmask for enabling debug prints */
 	u32 dbg_print_en;
 	struct ufs_qcom_testbus testbus;
+
+	struct reset_controller_dev rcdev;
 };
 
 static inline u32
-- 
2.20.1
