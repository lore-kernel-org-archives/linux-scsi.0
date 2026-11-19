Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100782;
	b=OjoCVp+DHkB5wySN3Jx0HjruSt1P8NbW/JxGJ8HztK5awPCG6552c9jibfIElzq6PiHu
	 SaFIWLscvN+J8g3gYSuqO9UvUgCSE/a1l9RpvA/vWx7pRMmV1EugYHdui3iSdSsVlY90q
	 y7ecCgmYE9GduMhfW6U3nBdU8YDYDsKAG18pZEFwc6c+9QXCo70JTmAlcrAw6FbrgIw8a
	 msBIYvbdxMkaUVNdbbRGF85NJeqvodIDEREYS1sslSfJyjAAsRJ90616bn0aDLOn3QZMt
	 hEPmmYtYg37Kh9qPxvBo194KWtOqWOSzwsPVGFsGsuRj6CDY7sz8iHcPoT+9JMGW5TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100782;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=pLnHP2sSL2Ayd5vdm+IJQYw65szjvJF1Z/xHPJkLud8=;
	b=Kt7Y5xXLpfWHF9E/b0kSg/y60SnUbSA31jX+gl9/XYHViGsnj5sC4IwbbFmAKVtqSmxL
	 RycEkGXTAy2HcG1QRwQS2SpYsH4Jwu9JhL4N/AN2Y+9vjCWTEID0sLXV4DrVxgomSp+xm
	 arX9pFc1TcF+K+nFJnc5zMlM31P7lYEFDFO4p4x23DCkRCp8eDIQvbtkjbQXc3Fqca5nW
	 CFpCesUGmwAI8G/mNLe3csj65lxLCWS5PJEv7Oxc99gk5hk8QQ9EB1JOG/b3R5REff7DC
	 MwSeWYROXk6+DXw9jRBBf/yQPj6k7u7kT1M3H+PdmaXlq48FCqIQYw8vrgRgP+yq0vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=qftLAHhH;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538C960A2628;
	Thu, 19 Nov 2026 15:06:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 538C960A2628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=qftLAHhH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795100781;
	bh=kaNEy/j2T5LlELnKXNbkuDqDKRS7Cia/k+vvRxgCMBw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=qftLAHhHcaXToZDac/VbmvNgiFek1iJS99HbZ47zJ8ZpvlkBCklmfwAygqLxpP6pc
	 W372vEGStrPh7MvDGiJAmrTUaQdewQUOoLWDSTByUj+0eBsaeuVEkfSPVJ7TOtBtyl
	 yrRMRrJo4VjPVTN48kVON+BOdXunnBpbpThsqtw6n5V/Ve34HUtumZw7rN1wLAyVXA
	 wyaERQ6y3W2nSRZKDOwp/yT2/ilZPw+xzKk3ZB/k+h41PA0+bqBGEDceB/lH7b+Pse
	 M64r1c0Fy+vsdkn864xSSiLyesYJpmqUASiRvIKXXuKJVBp4NPPzjbq/PhIHJXqNFE
	 KL2jtqFaRhIRw==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C689917E0DF7;
	Thu, 19 Nov 2026 16:06:19 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 19 Nov 2026 16:05:53 +0100
Subject: [PATCH v15 05/23] phy: mediatek: ufs: Add support for resets
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
Message-Id: <20261119-mt8196-ufs-v15-5-aae1eb0382e8@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795100772; l=4189;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=Xiam/osGtxwhAktccgjDDFTyNPIgL14W489k6VlIrPg=;
 b=yA13gRHEJrm+bTHImdeCZ+Xr7Vf7WRJLEv9c+Giq3kN0D1zidyywrKJm3esjJKzcRwco/V4CU
 x8zAufoKGwXBQ8hlxacBqNbxyjkHCpMQaLezALLH/0K6H9D0JXPu/Wg
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
 drivers/phy/mediatek/phy-mtk-ufs.c | 72 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/drivers/phy/mediatek/phy-mtk-ufs.c b/drivers/phy/mediatek/phy-mtk-ufs.c
index 8acd5bb1d916..487a21f42ff3 100644
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
 
@@ -140,9 +151,60 @@ static int ufs_mtk_phy_power_off(struct phy *generic_phy)
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
+	case SMCCC_RET_SUCCESS:
+		return 0;
+	case SMCCC_RET_INVALID_PARAMETER:
+	default:
+		return -EINVAL;
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
 
@@ -162,8 +224,18 @@ static int ufs_mtk_phy_probe(struct platform_device *pdev)
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
2.56.1

