From: Dolev Raviv <draviv@codeaurora.org>
Subject: [RFC 02/10] scsi: ufs: Add regulator enable support
Date: Mon, 11 Aug 2014 15:40:30 +0300
Message-ID: <1407760838-6406-3-git-send-email-draviv@codeaurora.org>
References: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57307 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbaHKMlm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Aug 2014 08:41:42 -0400
In-Reply-To: <1407760838-6406-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

UFS devices are powered by at most three external power supplies -
- VCC - The flash memory core power supply, 2.7V to 3.6V or 1.70V to 1.95V
- VCCQ - The controller and I/O power supply, 1.1V to 1.3V
- VCCQ2 - Secondary controller and/or I/O power supply, 1.65V to 1.95V

For some devices VCCQ or VCCQ2 are optional as they can be
generated using internal LDO inside the UFS device.

Add DT bindings for voltage regulators that can be controlled
from host driver.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 20468b2..65e3117 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -8,9 +8,33 @@ Required properties:
 - interrupts        : <interrupt mapping for UFS host controller IRQ>
 - reg               : <registers mapping>
 
+Optional properties:
+- vcc-supply            : phandle to VCC supply regulator node
+- vccq-supply           : phandle to VCCQ supply regulator node
+- vccq2-supply          : phandle to VCCQ2 supply regulator node
+- vcc-supply-1p8        : For embedded UFS devices, valid VCC range is 1.7-1.95V
+                          or 2.7-3.6V. This boolean property when set, specifies
+			  to use low voltage range of 1.7-1.95V. Note for external
+			  UFS cards this property is invalid and valid VCC range is
+			  always 2.7-3.6V.
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
+		vcc-supply-1p8;
+		vccq-supply = <&xxx_reg2>;
+		vccq2-supply = <&xxx_reg3>;
+		vcc-max-microamp = 500000;
+		vccq-max-microamp = 200000;
+		vccq2-max-microamp = 200000;
 	};
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index fafcf5e..729ce7d 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -362,4 +362,29 @@ struct ufs_query_res {
 	struct utp_upiu_query upiu_res;
 };
 
+#define UFS_VREG_VCC_MIN_UV	   2700000 /* uV */
+#define UFS_VREG_VCC_MAX_UV	   3600000 /* uV */
+#define UFS_VREG_VCC_1P8_MIN_UV    1700000 /* uV */
+#define UFS_VREG_VCC_1P8_MAX_UV    1950000 /* uV */
+#define UFS_VREG_VCCQ_MIN_UV	   1100000 /* uV */
+#define UFS_VREG_VCCQ_MAX_UV	   1300000 /* uV */
+#define UFS_VREG_VCCQ2_MIN_UV	   1650000 /* uV */
+#define UFS_VREG_VCCQ2_MAX_UV	   1950000 /* uV */
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
index d727b1a..51e47c4 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -53,6 +53,99 @@ static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
 	return NULL;
 }
 
+#define MAX_PROP_SIZE 32
+static int ufshcd_populate_vreg(struct device *dev, const char *name,
+		struct ufs_vreg **out_vreg)
+{
+	int ret = 0;
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
+				__func__, prop_name);
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
+	ret = of_property_read_u32(np, prop_name, &vreg->max_uA);
+	if (ret) {
+		dev_err(dev, "%s: unable to find %s err %d\n",
+				__func__, prop_name, ret);
+		goto out_free;
+	}
+
+	vreg->min_uA = 0;
+	if (!strcmp(name, "vcc")) {
+		if (of_property_read_bool(np, "vcc-supply-1p8")) {
+			vreg->min_uV = UFS_VREG_VCC_1P8_MIN_UV;
+			vreg->max_uV = UFS_VREG_VCC_1P8_MAX_UV;
+		} else {
+			vreg->min_uV = UFS_VREG_VCC_MIN_UV;
+			vreg->max_uV = UFS_VREG_VCC_MAX_UV;
+		}
+	} else if (!strcmp(name, "vccq")) {
+		vreg->min_uV = UFS_VREG_VCCQ_MIN_UV;
+		vreg->max_uV = UFS_VREG_VCCQ_MAX_UV;
+	} else if (!strcmp(name, "vccq2")) {
+		vreg->min_uV = UFS_VREG_VCCQ2_MIN_UV;
+		vreg->max_uV = UFS_VREG_VCCQ2_MAX_UV;
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
+/**
+ * ufshcd_parse_regulator_info - get regulator info from device tree
+ * @hba: per adapter instance
+ *
+ * Get regulator info from device tree for vcc, vccq, vccq2 power supplies.
+ * If any of the supplies are not defined it is assumed that they are always-on
+ * and hence return zero. If the property is defined but parsing is failed
+ * then return corresponding error.
+ */
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
@@ -173,6 +266,13 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 
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
index d0565b0..ef8519e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -68,6 +68,16 @@
 /* Interrupt aggregation default timeout, unit: 40us */
 #define INT_AGGR_DEF_TO	0x02
 
+#define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
+	({                                                              \
+		int _ret;                                               \
+		if (_on)                                                \
+			_ret = ufshcd_enable_vreg(_dev, _vreg);         \
+		else                                                    \
+			_ret = ufshcd_disable_vreg(_dev, _vreg);        \
+		_ret;                                                   \
+	})
+
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
@@ -3193,6 +3203,153 @@ static struct scsi_host_template ufshcd_driver_template = {
 	.can_queue		= UFSHCD_CAN_QUEUE,
 };
 
+static int ufshcd_config_vreg(struct device *dev,
+		struct ufs_vreg *vreg, bool on)
+{
+	int ret = 0;
+	struct regulator *reg = vreg->reg;
+	const char *name = vreg->name;
+	int min_uV, uA_load;
+
+	BUG_ON(!vreg);
+
+	if (regulator_count_voltages(reg) > 0) {
+		min_uV = on ? vreg->min_uV : 0;
+		ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
+		if (ret) {
+			dev_err(dev, "%s: %s set voltage failed, err=%d\n",
+					__func__, name, ret);
+			goto out;
+		}
+
+		uA_load = on ? vreg->max_uA : 0;
+		ret = regulator_set_optimum_mode(reg, uA_load);
+		if (ret >= 0) {
+			/*
+			 * regulator_set_optimum_mode() returns new regulator
+			 * mode upon success.
+			 */
+			ret = 0;
+		} else {
+			dev_err(dev, "%s: %s set optimum mode(uA_load=%d) failed, err=%d\n",
+					__func__, name, uA_load, ret);
+			goto out;
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
+	ret = ufshcd_toggle_vreg(dev, info->vcc, on);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_toggle_vreg(dev, info->vccq, on);
+	if (ret)
+		goto out;
+
+	ret = ufshcd_toggle_vreg(dev, info->vccq2, on);
+	if (ret)
+		goto out;
+
+out:
+	if (ret) {
+		ufshcd_toggle_vreg(dev, info->vccq2, false);
+		ufshcd_toggle_vreg(dev, info->vccq, false);
+		ufshcd_toggle_vreg(dev, info->vcc, false);
+	}
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
@@ -3248,6 +3405,36 @@ static void ufshcd_variant_hba_exit(struct ufs_hba *hba)
 		hba->vops->exit(hba);
 }
 
+static int ufshcd_hba_init(struct ufs_hba *hba)
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
+static void ufshcd_hba_exit(struct ufs_hba *hba)
+{
+	ufshcd_variant_hba_exit(hba);
+	ufshcd_setup_vreg(hba, false);
+}
+
 /**
  * ufshcd_suspend - suspend power management function
  * @hba: per adapter instance
@@ -3333,7 +3520,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 
 	scsi_host_put(hba->host);
 
-	ufshcd_variant_hba_exit(hba);
+	ufshcd_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
 
@@ -3412,7 +3599,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	hba->mmio_base = mmio_base;
 	hba->irq = irq;
 
-	err = ufshcd_variant_hba_init(hba);
+	err = ufshcd_hba_init(hba);
 	if (err)
 		goto out_error;
 
@@ -3504,7 +3691,7 @@ out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 out_disable:
 	scsi_host_put(host);
-	ufshcd_variant_hba_exit(hba);
+	ufshcd_hba_exit(hba);
 out_error:
 	return err;
 }
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8c6bec0..c0232f9 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -52,6 +52,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/regulator/consumer.h>
 
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -219,6 +220,7 @@ struct ufs_hba_variant_ops {
  * @saved_uic_err: sticky UIC error mask
  * @dev_cmd: ufs device management command information
  * @auto_bkops_enabled: to track whether bkops is enabled in device
+ * @vreg_info: UFS device voltage regulator information
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -279,6 +281,7 @@ struct ufs_hba {
 	struct ufs_dev_cmd dev_cmd;
 
 	bool auto_bkops_enabled;
+	struct ufs_vreg_info vreg_info;
 };
 
 #define ufshcd_writel(hba, val, reg)	\
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
