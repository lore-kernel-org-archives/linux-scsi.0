Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C54488D8F;
	Thu,  1 Oct 2026 08:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790842944; cv=none; b=A2ZUMRkd28/JjNpxqJTGYnzD0r5Mrbi++h9+0MT9p+uODOz374i6GcuNDuGp1fI2az6aqh2FVxXw4vNLxavd41H0imCT4Xnnn5ZQP+OZFIpclhocI1MqbgLYC+LpLh88gX1VUp+Y96fRiMvSjUx/zHRoeKhtOGWiUtbdB9vMlXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790842944; c=relaxed/simple;
	bh=aChdjRNQm/Rb8A7YPd0irB5+nCDfmyw9bmdxUuUjtmA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=J7eN4mvY3JjXVsR+oGSdW7iUzojoZ9RTSoa9rQ/hAvHMtHu8EP6a0x4TBLDbU3OfULfB2wU2Yyj+aU9wJT/MAjWgAPwDEMoaGQv0w7BnbfTWxeE0D+vcmab9duKTH/BeBrnxoje9/ZH6olOG1QQL0XFtqhxGJdjbz01pT93zLj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Ka0CHcpF; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Ka0CHcpF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1790842926;
	bh=aChdjRNQm/Rb8A7YPd0irB5+nCDfmyw9bmdxUuUjtmA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Ka0CHcpFlaHdS7Qi4syDdZ6gVDNq1F0EIiIbzaFp0txhYc/YV1JdHB1ts2Me0RWmK
	 Bq4bDNNi82DO8gIDZqvBMpneGUBzG1CGjQMZz1Gq36hehLPcly/SvCcflr9xP3mQrZ
	 NYZb418DPtcY0mHSpU1lgYefCEPW+eGCgRHRKNuDuFJiQH7XYc7lsxTYSJ2PR65Hpp
	 VnsVLJiMfq2iizu6dQ7vIouuox5nO0Pz34oDsTyGrDoRafSlBLq4JpwOmPrvWhZfST
	 UVrDS5SqyIeyYZhtproHt5yscw2Gwf/4g0JHqkW4cMuxbsLnGuIOkzGKbZ0UzjxL/Z
	 Y6dUwqi4CUz2Q==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 02B8317E0928;
	Thu, 01 Oct 2026 10:22:05 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 01 Oct 2026 10:21:39 +0200
Subject: [PATCH v13 07/24] scsi: ufs: mediatek: Rework 0.9V regulator
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261001-mt8196-ufs-v13-7-60854adab6d9@collabora.com>
References: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
In-Reply-To: <20261001-mt8196-ufs-v13-0-60854adab6d9@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, 
 Avri Altman <avri.altman@sandisk.com>, Bart Van Assche <bvanassche@acm.org>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 "Martin K. Petersen" <mkp@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790842918; l=7687;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=BerazSHvlZZCBrQcTN1Ugtbg589EmjctN74cY1FV0uQ=;
 b=QMgCmXR1zrRt7jgw1koejWyP9sboMCxhxzgdtZJ2S0/DPi07Q/ZDLs3qNj6dKZrKznb9YgSGi
 1Cj3JSP5Oy6AbaA9IkF6TIbYoidlNDVdQgDSXXy/AQ3EvDgZmlhSz8U
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

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

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 142 +++++++++++++++++++++++++++-------------
 drivers/ufs/host/ufs-mediatek.h |   3 +-
 2 files changed, 96 insertions(+), 49 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 4737a7a8acfc..f43bee50adb2 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -39,6 +39,10 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up);
 #define MAX_SUPP_MAC 64
 #define MCQ_QUEUE_OFFSET(c) ((((c) >> 16) & 0xFF) * 0x200)
 
+struct ufs_mtk_soc_data {
+	bool has_avdd09;
+};
+
 static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{ .wmanufacturerid = UFS_ANY_VENDOR,
 	  .model = UFS_ANY_MODEL,
@@ -49,8 +53,13 @@ static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{}
 };
 
+static const struct ufs_mtk_soc_data mt8183_data = {
+	.has_avdd09 = true,
+};
+
 static const struct of_device_id ufs_mtk_of_match[] = {
-	{ .compatible = "mediatek,mt8183-ufshci" },
+	{ .compatible = "mediatek,mt8183-ufshci", .data = &mt8183_data },
+	{ .compatible = "mediatek,mt8192-ufshci" },
 	{ .compatible = "mediatek,mt8195-ufshci" },
 	{},
 };
@@ -107,13 +116,6 @@ static bool ufs_mtk_is_boost_crypt_enabled(struct ufs_hba *hba)
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
@@ -508,44 +510,70 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
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
@@ -680,17 +708,6 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
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
@@ -699,9 +716,6 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-boost-crypt"))
 		ufs_mtk_init_boost_crypt(hba);
 
-	if (of_property_read_bool(np, "mediatek,ufs-support-va09"))
-		ufs_mtk_init_va09_pwr_ctrl(hba);
-
 	if (of_property_read_bool(np, "mediatek,ufs-disable-ah8"))
 		host->caps |= UFS_MTK_CAP_DISABLE_AH8;
 
@@ -1207,6 +1221,36 @@ static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
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
+		return dev_err_probe(dev,
+				     PTR_ERR(host->reg_avdd09),
+				     "Failed to get avdd09 regulator: %pe\n",
+				     host->reg_avdd09);
+	}
+
+	return 0;
+}
+
 /**
  * ufs_mtk_init - find other essential mmio bases
  * @hba: host controller instance
@@ -1290,6 +1334,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_init_clocks(hba);
 
+	err = ufs_mtk_get_supplies(host);
+	if (err)
+		goto out_variant_clear;
+
 	/*
 	 * ufshcd_vops_init() is invoked after
 	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index f95f12eb9926..c63740b98e85 100644
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
2.55.0

