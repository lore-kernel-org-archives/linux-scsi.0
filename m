From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH/RESEND V6 06/18] scsi: ufs: add voting support for host controller power
Date: Thu, 25 Sep 2014 15:32:24 +0300
Message-ID: <1411648356-3883-7-git-send-email-draviv@codeaurora.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:52656 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaIYMdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Sep 2014 08:33:07 -0400
In-Reply-To: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Raviv Shvili <rshvili@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Raviv Shvili <rshvili@codeaurora.org>

Add the support for voting of the regulator powering the
host controller logic.

Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index b0f791a..fb1234e 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -9,6 +9,7 @@ Required properties:
 - reg               : <registers mapping>
 
 Optional properties:
+- vdd-hba-supply        : phandle to UFS host controller supply regulator node
 - vcc-supply            : phandle to VCC supply regulator node
 - vccq-supply           : phandle to VCCQ supply regulator node
 - vccq2-supply          : phandle to VCCQ2 supply regulator node
@@ -20,6 +21,7 @@ Optional properties:
 - vcc-max-microamp      : specifies max. load that can be drawn from vcc supply
 - vccq-max-microamp     : specifies max. load that can be drawn from vccq supply
 - vccq2-max-microamp    : specifies max. load that can be drawn from vccq2 supply
+- <name>-fixed-regulator : boolean property specifying that <name>-supply is a fixed regulator
 
 - clocks                : List of phandle and clock specifier pairs
 - clock-names           : List of clock input name strings sorted in the same
@@ -39,6 +41,8 @@ Example:
 		reg = <0xfc598000 0x800>;
 		interrupts = <0 28 0>;
 
+		vdd-hba-supply = <&xxx_reg0>;
+		vdd-hba-fixed-regulator;
 		vcc-supply = <&xxx_reg1>;
 		vcc-supply-1p8;
 		vccq-supply = <&xxx_reg2>;
diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 729ce7d..9bb6919 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -385,6 +385,7 @@ struct ufs_vreg_info {
 	struct ufs_vreg *vcc;
 	struct ufs_vreg *vccq;
 	struct ufs_vreg *vccq2;
+	struct ufs_vreg *vdd_hba;
 };
 
 #endif /* End of Header */
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 642d80f..dde4e6e 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -147,6 +147,11 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 
 	vreg->name = kstrdup(name, GFP_KERNEL);
 
+	/* if fixed regulator no need further initialization */
+	snprintf(prop_name, MAX_PROP_SIZE, "%s-fixed-regulator", name);
+	if (of_property_read_bool(np, prop_name))
+		goto out;
+
 	snprintf(prop_name, MAX_PROP_SIZE, "%s-max-microamp", name);
 	ret = of_property_read_u32(np, prop_name, &vreg->max_uA);
 	if (ret) {
@@ -198,6 +203,10 @@ static int ufshcd_parse_regulator_info(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	struct ufs_vreg_info *info = &hba->vreg_info;
 
+	err = ufshcd_populate_vreg(dev, "vdd-hba", &info->vdd_hba);
+	if (err)
+		goto out;
+
 	err = ufshcd_populate_vreg(dev, "vcc", &info->vcc);
 	if (err)
 		goto out;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b033702..26301b8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3311,6 +3311,16 @@ out:
 	return ret;
 }
 
+static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on)
+{
+	struct ufs_vreg_info *info = &hba->vreg_info;
+
+	if (info)
+		return ufshcd_toggle_vreg(hba->dev, info->vdd_hba, on);
+
+	return 0;
+}
+
 static int ufshcd_get_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;
@@ -3350,6 +3360,16 @@ out:
 	return ret;
 }
 
+static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
+{
+	struct ufs_vreg_info *info = &hba->vreg_info;
+
+	if (info)
+		return ufshcd_get_vreg(hba->dev, info->vdd_hba);
+
+	return 0;
+}
+
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
 {
 	int ret = 0;
@@ -3483,14 +3503,29 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 {
 	int err;
 
-	err = ufshcd_init_clocks(hba);
+	/*
+	 * Handle host controller power separately from the UFS device power
+	 * rails as it will help controlling the UFS host controller power
+	 * collapse easily which is different than UFS device power collapse.
+	 * Also, enable the host controller power before we go ahead with rest
+	 * of the initialization here.
+	 */
+	err = ufshcd_init_hba_vreg(hba);
 	if (err)
 		goto out;
 
-	err = ufshcd_setup_clocks(hba, true);
+	err = ufshcd_setup_hba_vreg(hba, true);
 	if (err)
 		goto out;
 
+	err = ufshcd_init_clocks(hba);
+	if (err)
+		goto out_disable_hba_vreg;
+
+	err = ufshcd_setup_clocks(hba, true);
+	if (err)
+		goto out_disable_hba_vreg;
+
 	err = ufshcd_init_vreg(hba);
 	if (err)
 		goto out_disable_clks;
@@ -3509,6 +3544,8 @@ out_disable_vreg:
 	ufshcd_setup_vreg(hba, false);
 out_disable_clks:
 	ufshcd_setup_clocks(hba, false);
+out_disable_hba_vreg:
+	ufshcd_setup_hba_vreg(hba, false);
 out:
 	return err;
 }
@@ -3518,6 +3555,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	ufshcd_variant_hba_exit(hba);
 	ufshcd_setup_vreg(hba, false);
 	ufshcd_setup_clocks(hba, false);
+	ufshcd_setup_hba_vreg(hba, false);
 }
 
 /**
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

