Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100785;
	b=QBv7EMFGDnaxu6vxwkb9xYZreA3WApsGITioLnW/C4pD9PGuPyrsCib2tdndex9IHh3/
	 Epa/824MZrbqMYAVkMMFe+MUQ9hUkNxIJI0gbnjjFGEJKBgQ/qYq2Hle9gTbZjGKm3Vjp
	 tpJnjmf6aKLM31/7PhEjAtp2z53D33NT9PMo0KqJRnlNItytLZ44gSsrDi69JZAwSOJ2R
	 XJ3BOMrjQf2TLJYmxcs60exiYO3aLpWyi0kKBhawrzBaZ+Eizn6QouR1j8MBkzjGcq6Ev
	 Ewo47XJyfxNMOa0fwtbOpNCLXf6fz+o1JaisPsEapcWiTY6hwIpAUXjRMnPINKU+xlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100785;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=9bt0gI1gwpSIywqYZ2LifE7Kh08BwsrLhySNyoxWqO0=;
	b=E+n0ePzdKnSHYFmLWVYXDZQBn8vrvloCELI6ZrQ0SgPeMD9WVAT23G8gh+QVc0vqBJrR
	 Tn67JOOMCfdDeJhwbJI+qpSM0HBqRB0FhOCuHdKR6VxyfYlWBPl8J+uhxrjon3ZX51k16
	 Mda/28qjYt54NIHnTkLvXNXKqGae1LuQCJHu+Vy5yFJ6eOnQdPoicYGrnGzwyouhXVJ/m
	 vn1L3sNcD7qIacG+tbt7LyDuHN3a4vAUdKLxSCEe6l8hiMSl4kesVWvrl5L1L/kYXQ5Gf
	 JjpEiz5HBqATUEVX+hCmJG4HLDvMWeIeSxJ2lk81kebSGNXB9n1r5mXnh1W9eYmA2tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=htuQu9dG;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A1360A382E;
	Thu, 19 Nov 2026 15:06:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21A1360A382E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=htuQu9dG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795100783;
	bh=Z+bD07enEDkv46dAD4tJ7t3d/aLWePmUV5RVR+PPgaU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=htuQu9dGjMYG65H/wOqI/CUneoA+1ZvKa2AhUxW1UEFLNwRST3xIH9iIXa4dWm/ox
	 YU+VGAEyqgB0dDS2Cm97KsF0wCedUunDFTY+141CggvjfFvzKLQN/iWaqj5bcVXu95
	 f3b+Bx1ArKftRuTv0HEeqSsTxd0ip2xrs1Zn713ql2XhqYVX8MNtHiuyni/V6CnfRX
	 aARaYDB8FRIfn8WdCuxw6dDwt4x4AwMsiG1EvWcd11J+SOV6m2pr3Gm9bIX0NLVMz2
	 kmmsH1NRRA8qYiR38rFiuLtQ2E/W/Gt1ks0UkYmthIoLaRnylmTtF7M11qnbaBTMAX
	 X296o5Ypbojbw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 70D4017E0E2B;
	Thu, 19 Nov 2026 16:06:22 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 19 Nov 2026 16:05:55 +0100
Subject: [PATCH v15 07/23] scsi: ufs: mediatek: Rework 0.9V regulator
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-mt8196-ufs-v15-7-aae1eb0382e8@collabora.com>
References: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
In-Reply-To: <20261119-mt8196-ufs-v15-0-aae1eb0382e8@collabora.com>
To: Chunfeng Yun <chunfeng.yun@mediatek.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Peter Wang <peter.wang@mediatek.com>, 
 Chaotian Jing <chaotian.jing@mediatek.com>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Stanley Jhu <chu.stanley@gmail.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795100772; l=8136;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=YhZVv3gz/u4zpJQE77bKJSA/BbrO5doTQsDgRaBxSf4=;
 b=+qQ0yd4/o0bh1a4wAgicC9ZIRwGjJ/8n7/TKDW16mMoymPlu9TEs9cnXYHLSOLqvAk9DomRvI
 dNZwLpE0nV+DKEBhu1cRmTgsnb5a8yxUaDBtPEJPP84oTkOjkVTI/P9
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
 drivers/ufs/host/ufs-mediatek.c | 153 ++++++++++++++++++++++++++--------------
 drivers/ufs/host/ufs-mediatek.h |   3 +-
 2 files changed, 100 insertions(+), 56 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 1c16c11ae20d..ac04b4145b02 100644
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
@@ -508,56 +510,79 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 	return -ETIMEDOUT;
 }
 
+static int ufs_mtk_09v_off(struct ufs_mtk_host *host, bool allow_pwr_on)
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
+		if (allow_pwr_on)
+			ufs_mtk_va09_pwr_ctrl(res, 1);
+
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
-	int err;
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
 		ret = phy_power_on(mphy);
 		if (ret) {
-			if (ufs_mtk_is_va09_supported(hba)) {
-				ufs_mtk_va09_pwr_ctrl(res, 0);
-				err = regulator_disable(host->reg_va09);
-				if (err)
-					dev_err(hba->dev,
-						"failed to unwind va09: %d\n", err);
-			}
 			dev_err(hba->dev, "failed to enable mphy: %d\n", ret);
+			ufs_mtk_09v_off(host, false);
 			return ret;
 		}
 	} else {
 		phy_power_off(mphy);
-		if (ufs_mtk_is_va09_supported(hba)) {
-			ufs_mtk_va09_pwr_ctrl(res, 0);
-			ret = regulator_disable(host->reg_va09);
+		ret = ufs_mtk_09v_off(host, true);
+		if (ret) {
+			phy_power_on(mphy);
+			return ret;
 		}
 	}
-out:
-	if (ret) {
-		dev_info(hba->dev,
-			 "failed to %s va09: %d\n",
-			 on ? "enable" : "disable",
-			 ret);
-	} else {
-		host->mphy_powered_on = on;
-	}
 
-	return ret;
+	host->mphy_powered_on = on;
+
+	return 0;
 }
 
 static int ufs_mtk_get_host_clk(struct device *dev, const char *name,
@@ -691,17 +716,6 @@ static void ufs_mtk_init_boost_crypt(struct ufs_hba *hba)
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
@@ -710,9 +724,6 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-boost-crypt"))
 		ufs_mtk_init_boost_crypt(hba);
 
-	if (of_property_read_bool(np, "mediatek,ufs-support-va09"))
-		ufs_mtk_init_va09_pwr_ctrl(hba);
-
 	if (of_property_read_bool(np, "mediatek,ufs-disable-ah8"))
 		host->caps |= UFS_MTK_CAP_DISABLE_AH8;
 
@@ -1218,6 +1229,36 @@ static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
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
@@ -1301,6 +1342,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
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
2.56.1

