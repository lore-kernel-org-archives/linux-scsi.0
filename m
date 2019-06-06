From: Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v2 2/3] scsi: ufs: Allow resetting the UFS device
Date: Wed,  5 Jun 2019 18:02:48 -0700
Message-ID: <20190606010249.3538-3-bjorn.andersson@linaro.org>
References: <20190606010249.3538-1-bjorn.andersson@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190606010249.3538-1-bjorn.andersson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andy Gross <agross@kernel.org>, Linus Walleij <linus.walleij@linaro.org>, Evan Green <evgreen@chromium.org>, linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acquire the device-reset GPIO and toggle this to reset the UFS device
during initialization and host reset.

Based on downstream support implemented by Subhash Jadavani
<subhashj@codeaurora.org>.

Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
---

Changes since v1:
- Added gpio to DT binding document
- Fixed spelling of UFS

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt |  2 +
 drivers/scsi/ufs/ufshcd.c                     | 44 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h                     |  4 ++
 3 files changed, 50 insertions(+)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index a74720486ee2..d562d8b4919c 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -54,6 +54,8 @@ Optional properties:
 			  PHY reset from the UFS controller.
 - resets            : reset node register
 - reset-names       : describe reset node register, the "rst" corresponds to reset the whole UFS IP.
+- device-reset-gpios	: A phandle and gpio specifier denoting the GPIO connected
+			  to the RESET pin of the UFS memory device.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a208589426b1..eaa384d67684 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -42,6 +42,7 @@
 #include <linux/nls.h>
 #include <linux/of.h>
 #include <linux/bitfield.h>
+#include <linux/gpio/consumer.h>
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -6135,6 +6136,25 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	return err;
 }
 
+/**
+ * ufshcd_device_reset() - toggle the (optional) device reset line
+ * @hba: per-adapter instance
+ *
+ * Toggles the (optional) reset line to reset the attached device.
+ */
+static void ufshcd_device_reset(struct ufs_hba *hba)
+{
+	/*
+	 * The UFS device shall detect reset pulses of 1us, sleep for 10us to
+	 * be on the safe side.
+	 */
+	gpiod_set_value_cansleep(hba->device_reset, 1);
+	usleep_range(10, 15);
+
+	gpiod_set_value_cansleep(hba->device_reset, 0);
+	usleep_range(10, 15);
+}
+
 /**
  * ufshcd_host_reset_and_restore - reset and restore host controller
  * @hba: per-adapter instance
@@ -6190,6 +6210,9 @@ static int ufshcd_reset_and_restore(struct ufs_hba *hba)
 	int retries = MAX_HOST_RESET_RETRIES;
 
 	do {
+		/* Reset the attached device */
+		ufshcd_device_reset(hba);
+
 		err = ufshcd_host_reset_and_restore(hba);
 	} while (err && --retries);
 
@@ -7386,6 +7409,18 @@ static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
 	ufshcd_vops_exit(hba);
 }
 
+static int ufshcd_init_device_reset(struct ufs_hba *hba)
+{
+	hba->device_reset = devm_gpiod_get_optional(hba->dev, "device-reset",
+						    GPIOD_OUT_HIGH);
+	if (IS_ERR(hba->device_reset)) {
+		dev_err(hba->dev, "failed to acquire reset gpio: %ld\n",
+			PTR_ERR(hba->device_reset));
+	}
+
+	return PTR_ERR_OR_ZERO(hba->device_reset);
+}
+
 static int ufshcd_hba_init(struct ufs_hba *hba)
 {
 	int err;
@@ -7425,9 +7460,15 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_vreg;
 
+	err = ufshcd_init_device_reset(hba);
+	if (err)
+		goto out_disable_variant;
+
 	hba->is_powered = true;
 	goto out;
 
+out_disable_variant:
+	ufshcd_vops_setup_regulators(hba, false);
 out_disable_vreg:
 	ufshcd_setup_vreg(hba, false);
 out_disable_clks:
@@ -8321,6 +8362,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto exit_gating;
 	}
 
+	/* Reset the attached device */
+	ufshcd_device_reset(hba);
+
 	/* Host controller enable */
 	err = ufshcd_hba_enable(hba);
 	if (err) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 994d73d03207..4443928ba7d2 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -72,6 +72,8 @@
 #define UFSHCD "ufshcd"
 #define UFSHCD_DRIVER_VERSION "0.2"
 
+struct gpio_desc;
+
 struct ufs_hba;
 
 enum dev_cmd_type {
@@ -706,6 +708,8 @@ struct ufs_hba {
 
 	struct device		bsg_dev;
 	struct request_queue	*bsg_queue;
+
+	struct gpio_desc *device_reset;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
2.18.0
