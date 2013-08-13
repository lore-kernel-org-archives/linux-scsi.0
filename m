From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 2/3] scsi: ufs: Add regulator enable support
Date: Tue, 13 Aug 2013 16:30:19 +0530
Message-ID: <1376391620-13840-3-git-send-email-sthumma@codeaurora.org>
References: <1376391620-13840-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1376391620-13840-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

UFS devices are powered by at most three external power supplies -
- VCC - The flash memory core power supply, 2.7V to 3.6V or 1.70V to 1.95V
- VCCQ - The controller and I/O power supply, 1.1V to 1.3V
- VCCQ2 - Secondary controller and/or I/O power supply, 1.65V to 1.95V

For some devices VCCQ or VCCQ2 are optional as they can be
generated using internal LDO inside the UFS device.

Add DT bindings for voltage regulators that can be controlled
from host driver.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |   18 ++
 drivers/scsi/ufs/ufs.h                             |   23 +++
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   89 +++++++++
 drivers/scsi/ufs/ufshcd.c                          |  194 +++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h                          |    3 +
 5 files changed, 325 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 20468b2..39ee11f 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -8,9 +8,27 @@ Required properties:
 - interrupts        : <interrupt mapping for UFS host controller IRQ>
 - reg               : <registers mapping>
 
+Optional properties:
+- vcc-supply            : phandle to VCC supply regulator node
+- vccq-supply           : phandle to VCCQ supply regulator node
+- vccq2-supply          : phandle to VCCQ2 supply regulator node
+- vcc-max-microamp      : specifies max. load that can be drawn from vcc supply
+- vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
+- vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply
+
+Note: If above properties are not defined it can be assumed that the supply
+regulators are always on.
+
 Example:
 	ufshc@0xfc598000 {
 		compatible = "jedec,ufs-1.1";
 		reg = <0xfc598000 0x800>;
 		interrupts = <0 28 0>;
+
+		vcc-supply = <&xxx_reg1>;
+		vccq-supply = <&xxx_reg2>;
+		vccq2-supply = <&xxx_reg3>;
+		vcc-max-microamp = 500000;
+		vccq-max-microamp = 200000;
+		vccq2-max-microamp = 200000;
 	};
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index bce09a6..f8e37bf 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -325,4 +325,27 @@ struct ufs_query_res {
 	struct utp_upiu_query upiu_res;
 };
 
+#define UFS_VREG_VCC_MIN	2700000 /* uV */
+#define UFS_VREG_VCC_MAX	3600000 /* uV */
+#define UFS_VREG_VCCQ_MIN	1150000 /* uV */
+#define UFS_VREG_VCCQ_MAX	1300000 /* uV */
+#define UFS_VREG_VCCQ2_MIN	1700000 /* uV */
+#define UFS_VREG_VCCQ2_MAX	1950000 /* uV */
+
+struct ufs_vreg {
+	struct regulator *reg;
+	const char *name;
+	bool enabled;
+	int min_uV;
+	int max_uV;
+	int min_uA;
+	int max_uA;
+};
+
+struct ufs_vreg_info {
+	struct ufs_vreg *vcc;
+	struct ufs_vreg *vccq;
+	struct ufs_vreg *vccq2;
+};
+
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 3e0a14f..1c5290d 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -51,6 +51,88 @@ static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
 	return NULL;
 }
 
+#define MAX_PROP_SIZE 32
+static int ufshcd_populate_vreg(struct device *dev, const char *name,
+		struct ufs_vreg **out_vreg)
+{
+	int ret = 0;
+	u32 temp = 0;
+	char prop_name[MAX_PROP_SIZE];
+	struct ufs_vreg *vreg = NULL;
+	struct device_node *np = dev->of_node;
+
+	if (!np) {
+		dev_err(dev, "%s: non DT initialization\n", __func__);
+		goto out;
+	}
+
+	snprintf(prop_name, MAX_PROP_SIZE, "%s-supply", name);
+	if (!of_parse_phandle(np, prop_name, 0)) {
+		dev_info(dev, "%s: Unable to find %s regulator, assuming enabled\n",
+				__func__, name);
+		goto out;
+	}
+
+	vreg = devm_kzalloc(dev, sizeof(*vreg), GFP_KERNEL);
+	if (!vreg) {
+		dev_err(dev, "No memory for %s regulator\n", name);
+		goto out;
+	}
+
+	vreg->name = kstrdup(name, GFP_KERNEL);
+
+	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
+	ret = of_property_read_u32_array(np, prop_name, &temp, 1);
+	if (!ret) {
+		vreg->max_uA = temp;
+	} else {
+		dev_err(dev, "%s: unable to find %s err %d\n",
+				__func__, prop_name, ret);
+		goto out_free;
+	}
+
+	vreg->min_uA = 0;
+	if (!strcmp(name, "vcc")) {
+		vreg->min_uV = UFS_VREG_VCC_MIN;
+		vreg->max_uV = UFS_VREG_VCC_MAX;
+	} else if (!strcmp(name, "vccq")) {
+		vreg->min_uV = UFS_VREG_VCCQ_MIN;
+		vreg->max_uV = UFS_VREG_VCCQ_MAX;
+	} else if (!strcmp(name, "vccq2")) {
+		vreg->min_uV = UFS_VREG_VCCQ2_MIN;
+		vreg->max_uV = UFS_VREG_VCCQ2_MAX;
+	}
+
+	goto out;
+
+out_free:
+	devm_kfree(dev, vreg);
+	vreg = NULL;
+out:
+	if (!ret)
+		*out_vreg = vreg;
+	return ret;
+}
+
+static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
+{
+	int err;
+	struct device *dev = hba->dev;
+	struct ufs_vreg_info *info = &hba->vreg_info;
+
+	err = ufshcd_populate_vreg(dev, "vcc", &info->vcc);
+	if (err)
+		goto out;
+
+	err = ufshcd_populate_vreg(dev, "vccq", &info->vccq);
+	if (err)
+		goto out;
+
+	err = ufshcd_populate_vreg(dev, "vccq2", &info->vccq2);
+out:
+	return err;
+}
+
 #ifdef CONFIG_PM
 /**
  * ufshcd_pltfrm_suspend - suspend power management function
@@ -171,6 +253,13 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 
 	hba->vops = get_variant_ops(&pdev->dev);
 
+	err = ufshcd_parse_regulator_info(hba);
+	if (err) {
+		dev_err(&pdev->dev, "%s: regulator init failed %d\n",
+				__func__, err);
+		goto out;
+	}
+
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c539347..ab7b943 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2826,6 +2826,166 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.can_queue		= UFSHCD_CAN_QUEUE,
 };
 
+static int ufshcd_config_vreg(struct device *dev,
+		struct ufs_vreg *vreg, bool on)
+{
+	int ret = 0;
+	struct regulator *reg = vreg->reg;
+	const char *name = vreg->name;
+	int min_uV, max_uV, uA_load;
+
+	BUG_ON(!vreg);
+
+	min_uV = vreg->min_uV;
+	max_uV = vreg->max_uV;
+
+	if (on)
+		uA_load = vreg->max_uA;
+	else
+		uA_load = 0;
+
+	if (regulator_count_voltages(reg) > 0) {
+		ret = regulator_set_voltage(reg, min_uV, max_uV);
+		if (ret) {
+			dev_err(dev, "%s: %s set voltage failed, err=%d\n",
+					__func__, name, ret);
+			goto out;
+		}
+
+		ret = regulator_set_optimum_mode(reg, uA_load);
+		if (ret < 0) {
+			dev_err(dev, "%s: %s set optimum mode(uA_load=%d) failed, err=%d\n",
+					__func__, name, uA_load, ret);
+			goto out;
+		} else {
+			/*
+			 * regulator_set_optimum_mode() can return non zero
+			 * value even for success case.
+			 */
+			ret = 0;
+		}
+	}
+out:
+	return ret;
+}
+
+static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
+{
+	int ret = 0;
+
+	if (!vreg || vreg->enabled)
+		goto out;
+
+	ret = ufshcd_config_vreg(dev, vreg, true);
+	if (!ret)
+		ret = regulator_enable(vreg->reg);
+
+	if (!ret)
+		vreg->enabled = true;
+	else
+		dev_err(dev, "%s: %s enable failed, err=%d\n",
+				__func__, vreg->name, ret);
+out:
+	return ret;
+}
+
+static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
+{
+	int ret = 0;
+
+	if (!vreg || !vreg->enabled)
+		goto out;
+
+	ret = regulator_disable(vreg->reg);
+
+	if (!ret) {
+		/* ignore errors on applying disable config */
+		ufshcd_config_vreg(dev, vreg, false);
+		vreg->enabled = false;
+	} else {
+		dev_err(dev, "%s: %s disable failed, err=%d\n",
+				__func__, vreg->name, ret);
+	}
+out:
+	return ret;
+}
+
+static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on)
+{
+	int ret = 0;
+	struct device *dev = hba->dev;
+	struct ufs_vreg_info *info = &hba->vreg_info;
+
+	if (!info)
+		goto out;
+
+	if (on) {
+		ret = ufshcd_enable_vreg(dev, info->vcc);
+		if (ret)
+			goto out;
+
+		ret = ufshcd_enable_vreg(dev, info->vccq);
+		if (ret)
+			goto out_disable_vcc;
+
+		ret = ufshcd_enable_vreg(dev, info->vccq2);
+		if (ret)
+			goto out_disable_vccq;
+	} else {
+		ufshcd_disable_vreg(dev, info->vcc);
+		ufshcd_disable_vreg(dev, info->vccq);
+		ufshcd_disable_vreg(dev, info->vccq2);
+	}
+
+	goto out;
+
+out_disable_vccq:
+	ufshcd_disable_vreg(dev, info->vccq);
+out_disable_vcc:
+	ufshcd_disable_vreg(dev, info->vcc);
+out:
+	return ret;
+}
+
+static int ufshcd_get_vreg(struct device *dev, struct ufs_vreg *vreg)
+{
+	int ret = 0;
+
+	if (!vreg)
+		goto out;
+
+	vreg->reg = devm_regulator_get(dev, vreg->name);
+	if (IS_ERR(vreg->reg)) {
+		ret = PTR_ERR(vreg->reg);
+		dev_err(dev, "%s: %s get failed, err=%d\n",
+				__func__, vreg->name, ret);
+	}
+out:
+	return ret;
+}
+
+static int ufshcd_init_vreg(struct ufs_hba *hba)
+{
+	int ret = 0;
+	struct device *dev = hba->dev;
+	struct ufs_vreg_info *info = &hba->vreg_info;
+
+	if (!info)
+		goto out;
+
+	ret = ufshcd_get_vreg(dev, info->vcc);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_get_vreg(dev, info->vccq);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_get_vreg(dev, info->vccq2);
+out:
+	return ret;
+}
+
 static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 {
 	int err = 0;
@@ -2881,6 +3041,36 @@ static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
 		hba->vops->exit(hba);
 }
 
+static int ufs_hba_init(struct ufs_hba *hba)
+{
+	int err;
+
+	err = ufshcd_init_vreg(hba);
+	if (err)
+		goto out;
+
+	err = ufshcd_setup_vreg(hba, true);
+	if (err)
+		goto out;
+
+	err = ufshcd_variant_hba_init(hba);
+	if (err)
+		goto out_disable_vreg;
+
+	goto out;
+
+out_disable_vreg:
+	ufshcd_setup_vreg(hba, false);
+out:
+	return err;
+}
+
+static void ufs_hba_exit(struct ufs_hba *hba)
+{
+	ufshcd_variant_hba_exit(hba);
+	ufshcd_setup_vreg(hba, false);
+}
+
 /**
  * ufshcd_suspend - suspend power management function
  * @hba: per adapter instance
@@ -2966,7 +3156,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 
 	scsi_host_put(hba->host);
 
-	ufshcd_variant_hba_exit(hba);
+	ufs_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
@@ -3029,7 +3219,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
 
-	err = ufshcd_variant_hba_init(hba);
+	err = ufs_hba_init(hba);
 	if (err)
 		goto out_disable;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 72acbc7..c137ca4 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -61,6 +61,7 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_eh.h>
+#include <linux/regulator/consumer.h>
 
 #include "ufs.h"
 #include "ufshci.h"
@@ -218,6 +219,7 @@ struct ufs_hba_variant_ops {
  * @saved_uic_err: sticky UIC error mask
  * @dev_cmd: ufs device management command information
  * @auto_bkops_enabled: to track whether bkops is enabled in device
+ * @vreg_info: UFS device voltage regulator information
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -276,6 +278,7 @@ struct ufs_hba {
 	struct ufs_dev_cmd dev_cmd;
 
 	bool auto_bkops_enabled;
+	struct ufs_vreg_info vreg_info;
 };
 
 #define ufshcd_writel(hba, val, reg)	\
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.
