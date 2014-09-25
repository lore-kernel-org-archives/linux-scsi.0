From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RESEND V6 05/18] scsi: ufs: Add clock initialization support
Date: Thu, 25 Sep 2014 15:32:23 +0300
Message-ID: <1411648356-3883-6-git-send-email-draviv@codeaurora.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Add generic clock initialization support for UFSHCD platform
driver. The clock info is read from device tree using standard
clock bindings. A generic max-clock-frequency-hz property is
defined to save information on maximum operating clock frequency
the h/w supports.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 65e3117..b0f791a 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -21,8 +21,17 @@ Optional properties:
 - vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
 - vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply
 
+- clocks                : List of phandle and clock specifier pairs
+- clock-names           : List of clock input name strings sorted in the same
+                          order as the clocks property.
+- max-clock-frequency-hz : List of maximum operating frequency stored in the same
+                           order as the clocks property. If this property is not
+			   defined or a value in the array is "0" then it is assumed
+			   that the frequency is set by the parent clock or a
+			   fixed rate clock source.
+
 Note: If above properties are not defined it can be assumed that the supply
-regulators are always on.
+regulators or clocks are always on.
 
 Example:
 	ufshc@0xfc598000 {
@@ -37,4 +46,8 @@ Example:
 		vcc-max-microamp = 500000;
 		vccq-max-microamp = 200000;
 		vccq2-max-microamp = 200000;
+
+		clocks = <&core 0>, <&ref 0>, <&iface 0>;
+		clock-names = "core_clk", "ref_clk", "iface_clk";
+		max-clock-frequency-hz = <100000000 19200000 0>;
 	};
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index 7a6edbc..2a26faa 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -170,6 +170,8 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		return err;
 	}
 
+	INIT_LIST_HEAD(&hba->clk_list_head);
+
 	err = ufshcd_init(hba, mmio_base, pdev->irq);
 	if (err) {
 		dev_err(&pdev->dev, "Initialization failed\n");
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 51e47c4..642d80f 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -53,6 +53,71 @@ static struct ufs_hba_variant_ops *get_variant_ops(struct device *dev)
 	return NULL;
 }
 
+static int ufshcd_parse_clock_info(struct ufs_hba *hba)
+{
+	int ret = 0;
+	int cnt;
+	int i;
+	struct device *dev = hba->dev;
+	struct device_node *np = dev->of_node;
+	char *name;
+	u32 *clkfreq = NULL;
+	struct ufs_clk_info *clki;
+
+	if (!np)
+		goto out;
+
+	INIT_LIST_HEAD(&hba->clk_list_head);
+
+	cnt = of_property_count_strings(np, "clock-names");
+	if (!cnt || (cnt == -EINVAL)) {
+		dev_info(dev, "%s: Unable to find clocks, assuming enabled\n",
+				__func__);
+	} else if (cnt < 0) {
+		dev_err(dev, "%s: count clock strings failed, err %d\n",
+				__func__, cnt);
+		ret = cnt;
+	}
+
+	if (cnt <= 0)
+		goto out;
+
+	clkfreq = kzalloc(cnt * sizeof(*clkfreq), GFP_KERNEL);
+	if (!clkfreq) {
+		ret = -ENOMEM;
+		dev_err(dev, "%s: memory alloc failed\n", __func__);
+		goto out;
+	}
+
+	ret = of_property_read_u32_array(np,
+			"max-clock-frequency-hz", clkfreq, cnt);
+	if (ret && (ret != -EINVAL)) {
+		dev_err(dev, "%s: invalid max-clock-frequency-hz property, %d\n",
+				__func__, ret);
+		goto out;
+	}
+
+	for (i = 0; i < cnt; i++) {
+		ret = of_property_read_string_index(np,
+				"clock-names", i, (const char **)&name);
+		if (ret)
+			goto out;
+
+		clki = devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
+		if (!clki) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		clki->max_freq = clkfreq[i];
+		clki->name = kstrdup(name, GFP_KERNEL);
+		list_add_tail(&clki->list, &hba->clk_list_head);
+	}
+out:
+	kfree(clkfreq);
+	return ret;
+}
+
 #define MAX_PROP_SIZE 32
 static int ufshcd_populate_vreg(struct device *dev, const char *name,
 		struct ufs_vreg **out_vreg)
@@ -266,6 +331,12 @@ static int ufshcd_pltfrm_probe(struct platform_device *pdev)
 
 	hba->vops = get_variant_ops(&pdev->dev);
 
+	err = ufshcd_parse_clock_info(hba);
+	if (err) {
+		dev_err(&pdev->dev, "%s: clock parse failed %d\n",
+				__func__, err);
+		goto out;
+	}
 	err = ufshcd_parse_regulator_info(hba);
 	if (err) {
 		dev_err(&pdev->dev, "%s: regulator init failed %d\n",
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ef8519e..b033702 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3350,6 +3350,80 @@ out:
 	return ret;
 }
 
+static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
+{
+	int ret = 0;
+	struct ufs_clk_info *clki;
+	struct list_head *head = &hba->clk_list_head;
+
+	if (!head || list_empty(head))
+		goto out;
+
+	list_for_each_entry(clki, head, list) {
+		if (!IS_ERR_OR_NULL(clki->clk)) {
+			if (on && !clki->enabled) {
+				ret = clk_prepare_enable(clki->clk);
+				if (ret) {
+					dev_err(hba->dev, "%s: %s prepare enable failed, %d\n",
+						__func__, clki->name, ret);
+					goto out;
+				}
+			} else if (!on && clki->enabled) {
+				clk_disable_unprepare(clki->clk);
+			}
+			clki->enabled = on;
+			dev_dbg(hba->dev, "%s: clk: %s %sabled\n", __func__,
+					clki->name, on ? "en" : "dis");
+		}
+	}
+out:
+	if (ret) {
+		list_for_each_entry(clki, head, list) {
+			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
+				clk_disable_unprepare(clki->clk);
+		}
+	}
+	return ret;
+}
+
+static int ufshcd_init_clocks(struct ufs_hba *hba)
+{
+	int ret = 0;
+	struct ufs_clk_info *clki;
+	struct device *dev = hba->dev;
+	struct list_head *head = &hba->clk_list_head;
+
+	if (!head || list_empty(head))
+		goto out;
+
+	list_for_each_entry(clki, head, list) {
+		if (!clki->name)
+			continue;
+
+		clki->clk = devm_clk_get(dev, clki->name);
+		if (IS_ERR(clki->clk)) {
+			ret = PTR_ERR(clki->clk);
+			dev_err(dev, "%s: %s clk get failed, %d\n",
+					__func__, clki->name, ret);
+			goto out;
+		}
+
+		if (clki->max_freq) {
+			ret = clk_set_rate(clki->clk, clki->max_freq);
+			if (ret) {
+				dev_err(hba->dev, "%s: %s clk set rate(%dHz) failed, %d\n",
+					__func__, clki->name,
+					clki->max_freq, ret);
+				goto out;
+			}
+		}
+		dev_dbg(dev, "%s: clk: %s, rate: %lu\n", __func__,
+				clki->name, clk_get_rate(clki->clk));
+	}
+out:
+	return ret;
+}
+
 static int ufshcd_variant_hba_init(struct ufs_hba *hba)
 {
 	int err = 0;
@@ -3409,14 +3483,22 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 {
 	int err;
 
-	err = ufshcd_init_vreg(hba);
+	err = ufshcd_init_clocks(hba);
 	if (err)
 		goto out;
 
-	err = ufshcd_setup_vreg(hba, true);
+	err = ufshcd_setup_clocks(hba, true);
 	if (err)
 		goto out;
 
+	err = ufshcd_init_vreg(hba);
+	if (err)
+		goto out_disable_clks;
+
+	err = ufshcd_setup_vreg(hba, true);
+	if (err)
+		goto out_disable_clks;
+
 	err = ufshcd_variant_hba_init(hba);
 	if (err)
 		goto out_disable_vreg;
@@ -3425,6 +3507,8 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 
 out_disable_vreg:
 	ufshcd_setup_vreg(hba, false);
+out_disable_clks:
+	ufshcd_setup_clocks(hba, false);
 out:
 	return err;
 }
@@ -3433,6 +3517,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 {
 	ufshcd_variant_hba_exit(hba);
 	ufshcd_setup_vreg(hba, false);
+	ufshcd_setup_clocks(hba, false);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index c0232f9..bc0f7ed 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -155,6 +155,22 @@ struct ufs_dev_cmd {
 	struct ufs_query query;
 };
 
+/**
+ * struct ufs_clk_info - UFS clock related info
+ * @list: list headed by hba->clk_list_head
+ * @clk: clock node
+ * @name: clock name
+ * @max_freq: maximum frequency supported by the clock
+ * @enabled: variable to check against multiple enable/disable
+ */
+struct ufs_clk_info {
+	struct list_head list;
+	struct clk *clk;
+	const char *name;
+	u32 max_freq;
+	bool enabled;
+};
+
 #define PRE_CHANGE      0
 #define POST_CHANGE     1
 /**
@@ -221,6 +237,7 @@ struct ufs_hba_variant_ops {
  * @dev_cmd: ufs device management command information
  * @auto_bkops_enabled: to track whether bkops is enabled in device
  * @vreg_info: UFS device voltage regulator information
+ * @clk_list_head: UFS host controller clocks list node head
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -282,6 +299,7 @@ struct ufs_hba {
 
 	bool auto_bkops_enabled;
 	struct ufs_vreg_info vreg_info;
+	struct list_head clk_list_head;
 };
 
 #define ufshcd_writel(hba, val, reg)	\
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
