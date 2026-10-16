Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0DA25B0BD;
	Fri, 16 Oct 2026 12:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154022; cv=none; b=QGxaXA/GLeDa2RWHu8k4cGZlXJ7h8B/0ZkRW5BfQtj5sZeUNPCODF37ZXoqUyuTXjtSCK03qlKeiDSgKZK/LrZGqJwc337j5vQUuJtIZqcLLEge7p/tNyLhOdUo8oNQzsZdlwDOcEnD9W96m8Dqq0YRLhnxm7RoD4o+CTu2ncV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154022; c=relaxed/simple;
	bh=3OjaJ0Jwue4KIRgb+NR+YYZzAVgjAUo5mirg5t33LtI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=tpWTgrvILRYdABx6B5LFUQU+WbcFIReeHPTRJJJa7PkLRvGE3oG5eRhFdLuY8XJCq7E5pbHrYl9lqWKVmzHB5fHovg8n1Ka05R++gSRVemNUKf/IWbBxjMl20z9jJ/2EqqegciwRIZLK7S7NnXWSPiNcX+7hJV5zTYG1Q15gm5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=eGW5hF4T; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="eGW5hF4T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154019;
	bh=3OjaJ0Jwue4KIRgb+NR+YYZzAVgjAUo5mirg5t33LtI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=eGW5hF4TsCOq9DJ98GbC6D2MDUEGMx7cbqHXjm5iOraDe2cn15HuqHEuTriNZMkR0
	 DjDTIMbGFFxjQP437eNjM55i4Oo+C+Ypf3Pynq6x/91l8jcrZUlW+Lbu5JkrzlRfrv
	 iu+6++X5q5lWHrO2MkXquqnnfHqKR9vv1kSF5t5nacNfKphOWbueh29CNa7StBc/uj
	 6B3rXB++3Ruy+NmOWwhnwsL+6fIpIQ3DHuwi8KKPlda61JGm4ppsPgS+Rh3fbBhlos
	 M7j5wWLclp+Rdoixkth68xhIVTKtqOTenV1K0Meuth8mv26blMEaMr2Y+91KbQg806
	 EDH6IzSSs/KjQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9F9A817E011B;
	Fri, 16 Oct 2026 14:33:38 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:33:00 +0200
Subject: [PATCH v14 08/23] scsi: ufs: mediatek: Add dual 0.9V supply
 support
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-8-e8d565e0cd45@collabora.com>
References: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
In-Reply-To: <20261016-mt8196-ufs-v14-0-e8d565e0cd45@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=5198;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=3OjaJ0Jwue4KIRgb+NR+YYZzAVgjAUo5mirg5t33LtI=;
 b=Aw680jt/R+7NSxt93XTUo1GFnWGnqUyqyIyTxakq1Hu/hYyrd/jEeN4h3C3Uv1yRZQB0scwvu
 QTnT52ivcuDD7GgLBFhJFoQqdygqbQafTHyxq4x19vaYn67KConq9ps
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

The MT8196 SoC has an additional pin in comparison of the MT8183 SoC,
that is used to feed the host controller with a 0.9V supply.

In preparation of this SoC support, add in platform data and
driver the management a second optional 0.9V regulator named
"avdd09-1".

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 99 +++++++++++++++++++++++++++++++----------
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 76 insertions(+), 24 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index bcb7f350984c..c8c5f85507af 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -41,6 +41,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up);
 
 struct ufs_mtk_soc_data {
 	bool has_avdd09;
+	bool has_avdd09_1;
 };
 
 static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
@@ -513,20 +514,43 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 static int ufs_mtk_09v_off(struct ufs_mtk_host *host, bool allow_pwr_on)
 {
 	struct arm_smccc_res res;
-	int ret;
+	int ret, ret2;
 
-	if (!host->reg_avdd09)
+	if (!host->reg_avdd09 && !host->reg_avdd09_1)
 		return 0;
 
 	ufs_mtk_va09_pwr_ctrl(res, 0);
-	ret = regulator_disable(host->reg_avdd09);
-	if (ret) {
-		dev_err(host->hba->dev, "Failed to disable avdd09-supply: %pe\n",
-			ERR_PTR(ret));
-		if (allow_pwr_on)
-			ufs_mtk_va09_pwr_ctrl(res, 1);
 
-		return ret;
+	if (host->reg_avdd09) {
+		ret = regulator_disable(host->reg_avdd09);
+		if (ret) {
+			dev_err(host->hba->dev, "Failed to disable avdd09-supply: %pe\n",
+				ERR_PTR(ret));
+			if (allow_pwr_on)
+				ufs_mtk_va09_pwr_ctrl(res, 1);
+
+			return ret;
+		}
+	}
+
+	if (host->reg_avdd09_1) {
+		ret = regulator_disable(host->reg_avdd09_1);
+		if (ret) {
+			dev_err(host->hba->dev, "Failed to disable avdd09-1-supply: %pe\n",
+				ERR_PTR(ret));
+
+			if (host->reg_avdd09) {
+				ret2 = regulator_enable(host->reg_avdd09);
+				if (ret2)
+					dev_err(host->hba->dev,
+						"Failed to re-enable avdd09-supply: %pe\n",
+						ERR_PTR(ret2));
+			}
+			if (allow_pwr_on)
+				ufs_mtk_va09_pwr_ctrl(res, 1);
+
+			return ret;
+		}
 	}
 
 	return 0;
@@ -537,14 +561,28 @@ static int ufs_mtk_09v_on(struct ufs_mtk_host *host)
 	struct arm_smccc_res res;
 	int ret;
 
-	if (!host->reg_avdd09)
+	if (!host->reg_avdd09 && !host->reg_avdd09_1)
 		return 0;
 
-	ret = regulator_enable(host->reg_avdd09);
-	if (ret) {
-		dev_err(host->hba->dev, "Failed to enable avdd09-supply: %pe\n",
-			ERR_PTR(ret));
-		return ret;
+	if (host->reg_avdd09) {
+		ret = regulator_enable(host->reg_avdd09);
+		if (ret) {
+			dev_err(host->hba->dev, "Failed to enable avdd09-supply: %pe\n",
+				ERR_PTR(ret));
+			return ret;
+		}
+	}
+
+	if (host->reg_avdd09_1) {
+		ret = regulator_enable(host->reg_avdd09_1);
+		if (ret) {
+			dev_err(host->hba->dev, "Failed to enable avdd09-1-supply: %pe\n",
+				ERR_PTR(ret));
+			if (host->reg_avdd09)
+				regulator_disable(host->reg_avdd09);
+
+			return ret;
+		}
 	}
 
 	ufs_mtk_va09_pwr_ctrl(res, 1);
@@ -1239,20 +1277,33 @@ static int ufs_mtk_get_supplies(struct ufs_mtk_host *host)
 	struct device *dev = host->hba->dev;
 	const struct ufs_mtk_soc_data *data = of_device_get_match_data(dev);
 
-	if (!data || !data->has_avdd09)
+	if (!data)
 		return 0;
 
-	host->reg_avdd09 = devm_regulator_get_optional(dev, "avdd09");
-	if (IS_ERR(host->reg_avdd09)) {
-		if (PTR_ERR(host->reg_avdd09) == -ENODEV) {
+	if (data->has_avdd09) {
+		host->reg_avdd09 = devm_regulator_get_optional(dev, "avdd09");
+		if (IS_ERR(host->reg_avdd09)) {
+			if (PTR_ERR(host->reg_avdd09) != -ENODEV) {
+				return dev_err_probe(dev,
+						     PTR_ERR(host->reg_avdd09),
+						     "Failed to get avdd09 regulator: %pe\n",
+						     host->reg_avdd09);
+			}
 			host->reg_avdd09 = NULL;
-			return 0;
 		}
+	}
 
-		return dev_err_probe(dev,
-				     PTR_ERR(host->reg_avdd09),
-				     "Failed to get avdd09 regulator: %pe\n",
-				     host->reg_avdd09);
+	if (data->has_avdd09_1) {
+		host->reg_avdd09_1 = devm_regulator_get_optional(dev, "avdd09-1");
+		if (IS_ERR(host->reg_avdd09_1)) {
+			if (PTR_ERR(host->reg_avdd09_1) != -ENODEV) {
+				return dev_err_probe(dev,
+						     PTR_ERR(host->reg_avdd09_1),
+						     "Failed to get avdd09-1 regulator: %pe\n",
+						     host->reg_avdd09_1);
+			}
+			host->reg_avdd09_1 = NULL;
+		}
 	}
 
 	return 0;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index c63740b98e85..477fb9e36555 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -176,6 +176,7 @@ struct ufs_mtk_mcq_intr_info {
 struct ufs_mtk_host {
 	struct phy *mphy;
 	struct regulator *reg_avdd09;
+	struct regulator *reg_avdd09_1;
 	struct reset_control_bulk_data resets[MTK_UFS_NUM_RESETS];
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;

-- 
2.56.0

