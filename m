Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EC33FBB7D;
	Thu, 30 Jul 2026 09:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405008; cv=none; b=klHVowIc/dztEQ2GMDV5w4eXIPax1RCFX8prDsj+yPXA8s+5zbTjuYrmbbR6gZXBGmei4aanIf+pLsUay9vMyGTHqypxjl6JYrot+eRsy1ft5FCJ1QAxhB29Ulu5w7SnFeBr6LjQh5e/AGDt8DyMlncHYPqh0bOmAwpj8tPh0CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405008; c=relaxed/simple;
	bh=bWpqNA2w/lzQwaLDZK22KciiLovKewpkb+MzEY+uZ6Y=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YqaY0QWhbvQNkbaXI/0KJ4sbKdne97BuT3RWwG6qbF/0Si/eCNxsa8C6Z9yqNpWiQi7nGAB4NEEbpoMIB3edpDYb/eVaDq7h/putv/wPDp6u5R+DlGDoLJgjijnSGfHyGJVmgNCnuCRL9a+HeZ2HSuLDr7s1Asa1ZXrgojJc5xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=bho99ltg; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="bho99ltg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405002;
	bh=bWpqNA2w/lzQwaLDZK22KciiLovKewpkb+MzEY+uZ6Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bho99ltg6bq3IB8jKvivbYRf8wsHSVziLbUGq6Fvgix4rkV+tFpYHeuHoJElu/aFC
	 mO/oX299M7mEd53coFe7j9+TF81SJa12FP5rNIVPjoQYvJOdRRBPuHUBPHDgtQcsfF
	 jMnbwgpmyU52SWsXzUXtyZlLoRIHNc9HtawWezXY0yxlLr2e/2QskRlWSQYc2lqjEU
	 /aC4gc8VGtIZqFbKQnBM8/k3x4ZlFK1Xh4RrZtO+qSGJmrl5ZAbEoNQ1nG85bPBK6Q
	 DDwFM5SOwAiWbXXkywuF/HGtRwV8IyAeKHYnK0gLU5HGXIWM35r6Nq0HIgGlrxYI0S
	 pefdJa8gen0gA==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 90A3A17E08EB;
	Thu, 30 Jul 2026 11:50:01 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:01 +0200
Subject: [PATCH v10 05/26] phy: mediatek: ufs: Add support for resets
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-5-bc5ecef202dc@collabora.com>
References: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
In-Reply-To: <20260730-mt8196-ufs-v10-0-bc5ecef202dc@collabora.com>
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
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, Liam Girdwood <lgirdwood@gmail.com>, 
 Mark Brown <broonie@kernel.org>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=4162;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=2rm7VAJlRoymYlJ4TRbEdX+nNHudWfCFJbmQirU4tfo=;
 b=uygfidaWjSxMInIlsFe5MX92CP4mU1jVQHjtSLa3NnTwCGlf+abxbqPCJ4hqpEMgW0yi29Qah
 5DY3+eCfkwXAOCf8W2geRcygrrT3Ez0q4WDrDEhfhLgjzf50AELYVzv
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The MediaTek UFS PHY supports PHY resets. Until now, they've been
implemented in the UFS host driver. Since they were never documented in
the UFS HCI node's DT bindings, and no mainline DT uses it, it's fine if
it's moved to the correct location, which is the PHY driver.

Implement the MPHY reset logic in this driver and expose it through the
phy subsystem's reset op. The reset itself is optional, as judging by
other mainline devices that use this hardware, it's not required for the
device to function.

If no reset is present, the reset op returns -EOPNOTSUPP, which means
that the ufshci driver can detect it's present and not double sleep in
its own reset function, where it will call the phy reset.

Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/phy/mediatek/phy-mtk-ufs.c | 71 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/drivers/phy/mediatek/phy-mtk-ufs.c b/drivers/phy/mediatek/phy-mtk-ufs.c
index fc19e0fa8ed5..4439a9eb6b7a 100644
--- a/drivers/phy/mediatek/phy-mtk-ufs.c
+++ b/drivers/phy/mediatek/phy-mtk-ufs.c
@@ -4,12 +4,15 @@
  * Author: Stanley Chu <stanley.chu@mediatek.com>
  */
 
+#include <linux/arm-smccc.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
 #include <linux/phy/phy.h>
 #include <linux/platform_device.h>
+#include <linux/reset.h>
+#include <linux/soc/mediatek/mtk_sip_svc.h>
 
 #include "phy-mtk-io.h"
 
@@ -35,9 +38,17 @@
 
 #define UFSPHY_CLKS_CNT    2
 
+#define UFS_MTK_SIP_MPHY_CTRL       BIT(8)
+
+enum ufs_mtk_mphy_op {
+	UFS_MPHY_BACKUP = 0,
+	UFS_MPHY_RESTORE
+};
+
 struct ufs_mtk_phy {
 	struct device *dev;
 	void __iomem *mmio;
+	struct reset_control *reset;
 	struct clk_bulk_data clks[UFSPHY_CLKS_CNT];
 };
 
@@ -140,9 +151,59 @@ static int ufs_mtk_phy_power_off(struct phy *generic_phy)
 	return 0;
 }
 
+static int ufs_mtk_phy_ctrl(struct ufs_mtk_phy *phy, enum ufs_mtk_mphy_op op)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_smc(MTK_SIP_UFS_CONTROL, UFS_MTK_SIP_MPHY_CTRL, op,
+		      0, 0, 0, 0, 0, &res);
+
+	switch (res.a0) {
+	case SMCCC_RET_NOT_SUPPORTED:
+		return -EOPNOTSUPP;
+	case SMCCC_RET_INVALID_PARAMETER:
+		return -EINVAL;
+	default:
+		return 0;
+	}
+}
+
+static int ufs_mtk_phy_reset(struct phy *generic_phy)
+{
+	struct ufs_mtk_phy *phy = get_ufs_mtk_phy(generic_phy);
+	int ret;
+
+	if (!phy->reset)
+		return -EOPNOTSUPP;
+
+	ret = reset_control_assert(phy->reset);
+	if (ret)
+		return ret;
+
+	usleep_range(100, 110);
+
+	ret = reset_control_deassert(phy->reset);
+	if (ret)
+		return ret;
+
+	/*
+	 * To avoid double-sleep and other unintended side-effects in the ufshci
+	 * driver, don't return the phy_ctrl retval here, but just return -EPROTO.
+	 */
+	ret = ufs_mtk_phy_ctrl(phy, UFS_MPHY_RESTORE);
+	if (ret) {
+		dev_err(phy->dev, "UFS_MPHY_RESTORE SMC command failed: %pe\n",
+			ERR_PTR(ret));
+		return -EPROTO;
+	}
+
+	return 0;
+}
+
 static const struct phy_ops ufs_mtk_phy_ops = {
 	.power_on       = ufs_mtk_phy_power_on,
 	.power_off      = ufs_mtk_phy_power_off,
+	.reset          = ufs_mtk_phy_reset,
 	.owner          = THIS_MODULE,
 };
 
@@ -162,8 +223,18 @@ static int ufs_mtk_phy_probe(struct platform_device *pdev)
 	if (IS_ERR(phy->mmio))
 		return PTR_ERR(phy->mmio);
 
+	phy->reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	if (IS_ERR(phy->reset))
+		return dev_err_probe(dev, PTR_ERR(phy->reset), "Failed to get reset\n");
+
 	phy->dev = dev;
 
+	if (phy->reset) {
+		ret = ufs_mtk_phy_ctrl(phy, UFS_MPHY_BACKUP);
+		if (ret)
+			return dev_err_probe(dev, ret, "Failed to back up MPHY\n");
+	}
+
 	ret = ufs_mtk_phy_clk_init(phy);
 	if (ret)
 		return ret;

-- 
2.55.0

