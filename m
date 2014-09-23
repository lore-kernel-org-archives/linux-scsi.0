From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V4 14/17] scsi: ufs: Add freq-table-hz property for UFS device
Date: Tue, 23 Sep 2014 10:31:36 +0300
Message-ID: <1411457499-8074-15-git-send-email-draviv@codeaurora.org>
References: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:40429 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754818AbaIWHcg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2014 03:32:36 -0400
In-Reply-To: <1411457499-8074-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Sahitya Tummala <stummala@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Sahitya Tummala <stummala@codeaurora.org>

Add freq-table-hz propery for UFS device to keep track of
<min max> frequencies supported by UFS clocks.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index fb1234e..5357919 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -26,11 +26,11 @@ Optional properties:
 - clocks                : List of phandle and clock specifier pairs
 - clock-names           : List of clock input name strings sorted in the same
                           order as the clocks property.
-- max-clock-frequency-hz : List of maximum operating frequency stored in the same
-                           order as the clocks property. If this property is not
-			   defined or a value in the array is "0" then it is assumed
-			   that the frequency is set by the parent clock or a
-			   fixed rate clock source.
+- freq-table-hz		: Array of <min max> operating frequencies stored in the same
+                          order as the clocks property. If this property is not
+			  defined or a value in the array is "0" then it is assumed
+			  that the frequency is set by the parent clock or a
+			  fixed rate clock source.
 
 Note: If above properties are not defined it can be assumed that the supply
 regulators or clocks are always on.
@@ -53,5 +53,5 @@ Example:
 
 		clocks = <&core 0>, <&ref 0>, <&iface 0>;
 		clock-names = "core_clk", "ref_clk", "iface_clk";
-		max-clock-frequency-hz = <100000000 19200000 0>;
+		freq-table-hz = <100000000 200000000>, <0 0>, <0 0>;
 	};
diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 2482bba..8adf067 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -63,6 +63,8 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	char *name;
 	u32 *clkfreq = NULL;
 	struct ufs_clk_info *clki;
+	int len = 0;
+	size_t sz = 0;
 
 	if (!np)
 		goto out;
@@ -82,39 +84,59 @@ static int ufshcd_parse_clock_info(struct ufs_hba *hba)
 	if (cnt <= 0)
 		goto out;
 
-	clkfreq = kzalloc(cnt * sizeof(*clkfreq), GFP_KERNEL);
+	if (!of_get_property(np, "freq-table-hz", &len)) {
+		dev_info(dev, "freq-table-hz property not specified\n");
+		goto out;
+	}
+
+	if (len <= 0)
+		goto out;
+
+	sz = len / sizeof(*clkfreq);
+	if (sz != 2 * cnt) {
+		dev_err(dev, "%s len mismatch\n", "freq-table-hz");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	clkfreq = devm_kzalloc(dev, sz * sizeof(*clkfreq),
+			GFP_KERNEL);
 	if (!clkfreq) {
+		dev_err(dev, "%s: no memory\n", "freq-table-hz");
 		ret = -ENOMEM;
-		dev_err(dev, "%s: memory alloc failed\n", __func__);
 		goto out;
 	}
 
-	ret = of_property_read_u32_array(np,
-			"max-clock-frequency-hz", clkfreq, cnt);
+	ret = of_property_read_u32_array(np, "freq-table-hz",
+			clkfreq, sz);
 	if (ret && (ret != -EINVAL)) {
-		dev_err(dev, "%s: invalid max-clock-frequency-hz property, %d\n",
-				__func__, ret);
-		goto out;
+		dev_err(dev, "%s: error reading array %d\n",
+				"freq-table-hz", ret);
+		goto free_clkfreq;
 	}
 
-	for (i = 0; i < cnt; i++) {
+	for (i = 0; i < sz; i += 2) {
 		ret = of_property_read_string_index(np,
-				"clock-names", i, (const char **)&name);
+				"clock-names", i/2, (const char **)&name);
 		if (ret)
-			goto out;
+			goto free_clkfreq;
 
 		clki = devm_kzalloc(dev, sizeof(*clki), GFP_KERNEL);
 		if (!clki) {
 			ret = -ENOMEM;
-			goto out;
+			goto free_clkfreq;
 		}
 
-		clki->max_freq = clkfreq[i];
+		clki->min_freq = clkfreq[i];
+		clki->max_freq = clkfreq[i+1];
 		clki->name = kstrdup(name, GFP_KERNEL);
+		dev_dbg(dev, "%s: min %u max %u name %s\n", "freq-table-hz",
+				clki->min_freq, clki->max_freq, clki->name);
 		list_add_tail(&clki->list, &hba->clk_list_head);
 	}
-out:
+free_clkfreq:
 	kfree(clkfreq);
+out:
 	return ret;
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 93c7c82..2caa27e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -209,6 +209,7 @@ struct ufs_dev_cmd {
  * @clk: clock node
  * @name: clock name
  * @max_freq: maximum frequency supported by the clock
+ * @min_freq: min frequency that can be used for clock scaling
  * @enabled: variable to check against multiple enable/disable
  */
 struct ufs_clk_info {
@@ -216,6 +217,7 @@ struct ufs_clk_info {
 	struct clk *clk;
 	const char *name;
 	u32 max_freq;
+	u32 min_freq;
 	bool enabled;
 };
 
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

