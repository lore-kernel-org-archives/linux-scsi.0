Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073B63563D7;
	Thu, 23 Oct 2025 19:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249328; cv=pass; b=dJLvLr9q9/vr17XKydbFuOGmgf1zly2VweNLNVs30/yMOOgv+iTw6RiQkSMF7t+rrFGTMgbj47FJ87aRGd53frfQUhnvh8pZdfbus7wX2kocS8B7yN05k0YcZCeSeS/n8RA/0b7aBtea9ycRMxSUajkGzO0FHuuWaUTUfK7B0OQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249328; c=relaxed/simple;
	bh=Chp+FVyfYwYc2pCkjMzbUePfNFuc7lAdHtZjkYvKfe8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XrAaSvAIv1ITuR7XQhkPR+EO+o9G9K/4dyIhMEtuhBES1irf1nXQ+/9bWzrJAgpI3YY2OQf3UmMOkIBogDI5iC8sQ/vWUTz+csIFxuuK9oiKDLY8ZPkCMkZJnxNACnNMTwQ1fqXAENRgdB41bWAboLYpbSGe5InC5bcuyK9prVM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=MegzhrEE; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="MegzhrEE"
ARC-Seal: i=1; a=rsa-sha256; t=1761249058; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=X4tocBXG/7jqrSImV4nCl1b+TnG+nn7YXVRB9FFoVqA8hGkKloVoBlAjUzya1dhXfXl6JEzNYrWx9EDEJm7TJY5n7vPmULjVcP9vR2B3A3h9UCrdeUyCiGdX2Fe8EtDCutkQBEViTQvz69aQtqVkFymOY7ruQBV0Oc4/5NQDHJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249058; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0kIGMob+OEIkZfhaj9y+NdgFWCk9HuVGtLZiB5CfsDI=; 
	b=b5QS8eUTGF92P6ILDggfP/O0zDMsoPmDR14aJl0wTzaKPUaxFRHKf53FFoTVmcidXiirA0zBvVeZJR2PhDJYKJWtb/MtOqGns5vmmlwvAO2XMyUg7zWmVR5NYAO5zeh/HujduozA7Xbjcr6iqiQbQaDsVE0+tDApGYUJnix2x5M=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249058;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=0kIGMob+OEIkZfhaj9y+NdgFWCk9HuVGtLZiB5CfsDI=;
	b=MegzhrEE/O0Q8AUoGogPYpKWb9CUItbbauyUUy2ZAxP60lG4Io5jAChOMrZgkOo2
	pZr1rxCUq+IwLxV43xeINoBroNoxPItpJYfQcVrsDdbcqq04CuQLYurObKDD3ml0h/x
	F5wHoZiB2B8hyoshIdZS76jJWoSVNVDjYc4sKVZM=
Received: by mx.zohomail.com with SMTPS id 17612490567821001.940221176592;
	Thu, 23 Oct 2025 12:50:56 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:25 +0200
Subject: [PATCH v3 07/24] scsi: ufs: mediatek: Rework 0.9V regulator
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-7-0f04b4a795ff@collabora.com>
References: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
In-Reply-To: <20251023-mt8196-ufs-v3-0-0f04b4a795ff@collabora.com>
To: Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Kishon Vijay Abraham I <kishon@kernel.org>, 
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 kernel@collabora.com, linux-scsi@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, 
 linux-phy@lists.infradead.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
X-Mailer: b4 0.14.3

The mediatek UFS host driver does some pretty bad stuff with regards to
the 0.9V regulator. Instead of just checking for the presence of the
regulator, it adds a cap if it's there, and then checks for the cap. It
also sleeps to stabilise the supply after enabling the regulator, which
is something that should be done by the regulator framework with the
appropriate delay properties in the DTS instead of random sleeps in the
driver code.

Rework this code and rename it to the avdd09 name I've chosen in the
binding for this supply name, instead of the downstream "va09" name that
isn't used by the datasheets for any of these chips.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 153 ++++++++++++++++++++++++++--------------
 drivers/ufs/host/ufs-mediatek.h |   3 +-
 2 files changed, 101 insertions(+), 55 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index d1554701793e..a7aab2332ef2 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -38,6 +38,10 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up);
 #define MAX_SUPP_MAC 64
 #define MCQ_QUEUE_OFFSET(c) ((((c) >> 16) & 0xFF) * 0x200)
 
+struct ufs_mtk_soc_data {
+	bool has_avdd09;
+};
+
 static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{ .wmanufacturerid = UFS_ANY_VENDOR,
 	  .model = UFS_ANY_MODEL,
@@ -48,13 +52,6 @@ static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{}
 };
 
-static const struct of_device_id ufs_mtk_of_match[] = {
-	{ .compatible = "mediatek,mt8183-ufshci" },
-	{ .compatible = "mediatek,mt8195-ufshci" },
-	{},
-};
-MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
-
 /*
  * Details of UIC Errors
  */
@@ -106,13 +103,6 @@ static bool ufs_mtk_is_boost_crypt_enabled(struct ufs_hba *hba)
 	return host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE;
 }
 
-static bool ufs_mtk_is_va09_supported(struct ufs_hba *hba)
-{
-	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-
-	return host->caps & UFS_MTK_CAP_VA09_PWR_CTRL;
-}
-
 static bool ufs_mtk_is_broken_vcc(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -506,44 +496,70 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 	return -ETIMEDOUT;
 }
 
+static int ufs_mtk_09v_off(struct ufs_mtk_host *host)
+{
+	struct arm_smccc_res res;
+	int ret;
+
+	if (!host->reg_avdd09)
+		return 0;
+
+	ufs_mtk_va09_pwr_ctrl(res, 0);
+	ret = regulator_disable(host->reg_avdd09);
+	if (ret) {
+		dev_err(host->hba->dev, "Failed to disable avdd09-supply: %pe\n",
+			ERR_PTR(ret));
+		ufs_mtk_va09_pwr_ctrl(res, 1);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ufs_mtk_09v_on(struct ufs_mtk_host *host)
+{
+	struct arm_smccc_res res;
+	int ret;
+
+	if (!host->reg_avdd09)
+		return 0;
+
+	ret = regulator_enable(host->reg_avdd09);
+	if (ret) {
+		dev_err(host->hba->dev, "Failed to enable avdd09-supply: %pe\n",
+			ERR_PTR(ret));
+		return ret;
+	}
+
+	ufs_mtk_va09_pwr_ctrl(res, 1);
+
+	return 0;
+}
+
 static int ufs_mtk_mphy_power_on(struct ufs_hba *hba, bool on)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct phy *mphy = host->mphy;
-	struct arm_smccc_res res;
-	int ret = 0;
+	int ret;
 
-	if (!mphy || !(on ^ host->mphy_powered_on))
+	if (!mphy || on == host->mphy_powered_on)
 		return 0;
 
 	if (on) {
-		if (ufs_mtk_is_va09_supported(hba)) {
-			ret = regulator_enable(host->reg_va09);
-			if (ret < 0)
-				goto out;
-			/* wait 200 us to stablize VA09 */
-			usleep_range(200, 210);
-			ufs_mtk_va09_pwr_ctrl(res, 1);
-		}
+		ret = ufs_mtk_09v_on(host);
+		if (ret)
+			return ret;
 		phy_power_on(mphy);
 	} else {
 		phy_power_off(mphy);
-		if (ufs_mtk_is_va09_supported(hba)) {
-			ufs_mtk_va09_pwr_ctrl(res, 0);
-			ret = regulator_disable(host->reg_va09);
-		}
-	}
-out:
-	if (ret) {
-		dev_info(hba->dev,
-			 "failed to %s va09: %d\n",
-			 on ? "enable" : "disable",
-			 ret);
-	} else {
-		host->mphy_powered_on = on;
+		ret = ufs_mtk_09v_off(host);
+		if (ret)
+			return ret;
 	}
 
-	return ret;
+	host->mphy_powered_on = on;
+
+	return 0;
 }
 
 static int ufs_mtk_get_host_clk(struct device *dev, const char *name,
@@ -678,17 +694,6 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
 	return;
 }
 
-static void ufs_mtk_init_va09_pwr_ctrl(struct ufs_hba *hba)
-{
-	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-
-	host->reg_va09 = regulator_get(hba->dev, "va09");
-	if (IS_ERR(host->reg_va09))
-		dev_info(hba->dev, "failed to get va09");
-	else
-		host->caps |= UFS_MTK_CAP_VA09_PWR_CTRL;
-}
-
 static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -697,9 +702,6 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-boost-crypt"))
 		ufs_mtk_init_boost_crypt(hba);
 
-	if (of_property_read_bool(np, "mediatek,ufs-support-va09"))
-		ufs_mtk_init_va09_pwr_ctrl(hba);
-
 	if (of_property_read_bool(np, "mediatek,ufs-disable-ah8"))
 		host->caps |= UFS_MTK_CAP_DISABLE_AH8;
 
@@ -1205,6 +1207,35 @@ static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
 	host->mcq_nr_intr = 0;
 }
 
+/**
+ * ufs_mtk_get_supplies - acquire variant-specific supplies
+ * @host: pointer to driver's private &struct ufs_mtk_host instance
+ *
+ * Returns 0 on success, negative errno on error.
+ */
+static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
+{
+	struct device *dev = host->hba->dev;
+	const struct ufs_mtk_soc_data *data = of_device_get_match_data(dev);
+
+	if (!data || !data->has_avdd09)
+		return 0;
+
+	host->reg_avdd09 = devm_regulator_get_optional(dev, "avdd09");
+	if (IS_ERR(host->reg_avdd09)) {
+		if (PTR_ERR(host->reg_avdd09) == -ENODEV) {
+			host->reg_avdd09 = NULL;
+			return 0;
+		}
+
+		dev_err(dev, "Failed to get avdd09 regulator: %pe\n",
+			host->reg_avdd09);
+		return PTR_ERR(host->reg_avdd09);
+	}
+
+	return 0;
+}
+
 /**
  * ufs_mtk_init - find other essential mmio bases
  * @hba: host controller instance
@@ -1288,6 +1319,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_init_clocks(hba);
 
+	err = ufs_mtk_get_supplies(host);
+	if (err)
+		goto out_variant_clear;
+
 	/*
 	 * ufshcd_vops_init() is invoked after
 	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
@@ -2336,6 +2371,18 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.config_scsi_dev     = ufs_mtk_config_scsi_dev,
 };
 
+static const struct ufs_mtk_soc_data mt8183_data = {
+	.has_avdd09 = true,
+};
+
+static const struct of_device_id ufs_mtk_of_match[] = {
+	{ .compatible = "mediatek,mt8183-ufshci", .data = &mt8183_data },
+	{ .compatible = "mediatek,mt8192-ufshci" },
+	{ .compatible = "mediatek,mt8195-ufshci" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, ufs_mtk_of_match);
+
 /**
  * ufs_mtk_probe - probe routine of the driver
  * @pdev: pointer to Platform device handle
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 4fce29d131d1..24c8941f6b86 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -125,7 +125,6 @@ enum {
  */
 enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_BOOST_CRYPT_ENGINE         = 1 << 0,
-	UFS_MTK_CAP_VA09_PWR_CTRL              = 1 << 1,
 	UFS_MTK_CAP_DISABLE_AH8                = 1 << 2,
 	UFS_MTK_CAP_BROKEN_VCC                 = 1 << 3,
 
@@ -176,7 +175,7 @@ struct ufs_mtk_mcq_intr_info {
 
 struct ufs_mtk_host {
 	struct phy *mphy;
-	struct regulator *reg_va09;
+	struct regulator *reg_avdd09;
 	struct reset_control_bulk_data resets[MTK_UFS_NUM_RESETS];
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;

-- 
2.51.1.dirty

