Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7D549B21E;
	Fri, 16 Oct 2026 12:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154033; cv=none; b=t8Gef7GHhnZqWAZVbmYPeCy9/nftGJdZvbc/spcCwxSLI776Fn8//GiYW8SNDNILDRO8PP1qtziESxT+1mTjPi+KTp+5kdVxG9exlnvIQJyFh1Av/SVXTK7A+5XDJsXBoAvVfw4cevmpYD3ayoSE+1cAX7SwqmKisvC+KLkOu9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154033; c=relaxed/simple;
	bh=3mj9TO+vSBy2O1mVi9UgO8LJLq0MVi4u3w0cYcZO7NU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Lb2vtZhXG1xTEmIWXFslS7jtle2q7PLvQMGipoZ3oSqWPYP3eRf2L1flwJQ1gtcnjT8vSkVcclYQ3KSb1MStjmvvv19VurTyVHC86lW4k4ImiphnAlVU6OynVQ4FM9TcfRNWVXgIiewwPzyVY/6Cza27h5zn2DwqfNiwSUwYWk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=dDl05RXV; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="dDl05RXV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1792154029;
	bh=3mj9TO+vSBy2O1mVi9UgO8LJLq0MVi4u3w0cYcZO7NU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dDl05RXVQN4SNG/Z/I3V448ft68OXn1pjQMpdgLzbsXqyqDjSHjraWIZUkjwhEm2S
	 ITgcRGLKe5LOFdTXP9nqQOWhumfpRDMt46qJUULA60wpCbheOlBUdAKnSu4ADpwFiA
	 L/tGhZddaIAzq+tj9otcibUF6Aqt6/RJMgljRXts7RJ/uGV4f9tGXf+E/SaQaudiYC
	 II2LZb3f2oa2j7ATBdRQDPP55HIhdpDZxEq5ZvgWH67LRVDEGko7yVNx1IU0LlexPk
	 opysgPpOUqp/UsInjhJR221tSkzmU+mpJFviXPP3Aa7fDgPjcJa+Uu3ssN4puyPVQf
	 FINNvzZzLXnoQ==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8B97F17E0099;
	Fri, 16 Oct 2026 14:33:48 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 16 Oct 2026 14:33:09 +0200
Subject: [PATCH v14 17/23] scsi: ufs: mediatek: Clean up logging prints
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mt8196-ufs-v14-17-e8d565e0cd45@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792154009; l=9061;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=EuVOsLI1QdyCrtqhisEfI9rhUc3LIRc0N3FC1FQbscY=;
 b=yZCFah0Uhf6jeQn/kHjkF1S6WLIT2pVqBtiyHUg3FuSWhkk9zkzQDU+y2UojV4Sbl6hVVhMsk
 yXcTNiUrKj8DU0oqxA849aJGFGsnYg1isp/oRhWBmo9bs/HSJm1f0Ie
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The Linux kernel's log buffer provides many levels of verbosity,
associated with different semantic meanings. Care should be taken to
only log useful information to the info level, and log errors to the
error level.

The MediaTek UFS driver does not do this. It freely logs verbose debug
information to the info level, errors to the info level, and sometimes
errors to the warning level.

Adjust all the wrapped kprintf invocations to rectify this situation.
Use user-friendly %pe format codes for printing errors where possible.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 90 ++++++++++++++++++-----------------------
 1 file changed, 40 insertions(+), 50 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c370535dc341..49d8f0f17bf4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
+#include <linux/string_choices.h>
 
 #include <ufs/ufshcd.h>
 #include "ufshcd-pltfrm.h"
@@ -194,8 +195,8 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *hba)
 
 	ufs_mtk_crypto_ctrl(res, 1);
 	if (res.a0) {
-		dev_info(hba->dev, "%s: crypto enable failed, err: %lu\n",
-			 __func__, res.a0);
+		dev_err(hba->dev, "%s: crypto enable failed with error %lu, disabling\n",
+			__func__, res.a0);
 		hba->caps &= ~UFSHCD_CAP_CRYPTO;
 	}
 }
@@ -589,40 +590,38 @@ static void ufs_mtk_boost_crypt(struct ufs_hba *hba, bool boost)
 
 	ret = clk_prepare_enable(cfg->clk_crypt_mux);
 	if (ret) {
-		dev_info(hba->dev, "clk_prepare_enable(): %d\n",
-			 ret);
+		dev_err(hba->dev, "%s: Failed to enable clk_crypt_mux: %pe\n",
+			__func__, ERR_PTR(ret));
 		return;
 	}
 
 	if (boost) {
 		ret = regulator_set_voltage(reg, volt, INT_MAX);
 		if (ret) {
-			dev_info(hba->dev,
-				 "failed to set vcore to %d\n", volt);
+			dev_err(hba->dev, "%s: Failed to set vcore to %d: %pe\n",
+				__func__, volt, ERR_PTR(ret));
 			goto out;
 		}
 
-		ret = clk_set_parent(cfg->clk_crypt_mux,
-				     cfg->clk_crypt_perf);
+		ret = clk_set_parent(cfg->clk_crypt_mux, cfg->clk_crypt_perf);
 		if (ret) {
-			dev_info(hba->dev,
-				 "failed to set clk_crypt_perf\n");
+			dev_err(hba->dev, "%s: Failed to reparent clk_crypt_perf: %pe\n",
+				__func__, ERR_PTR(ret));
 			regulator_set_voltage(reg, 0, INT_MAX);
 			goto out;
 		}
 	} else {
-		ret = clk_set_parent(cfg->clk_crypt_mux,
-				     cfg->clk_crypt_lp);
+		ret = clk_set_parent(cfg->clk_crypt_mux, cfg->clk_crypt_lp);
 		if (ret) {
-			dev_info(hba->dev,
-				 "failed to set clk_crypt_lp\n");
+			dev_err(hba->dev, "%s: Failed to reparent clk_crypt_lp: %pe\n",
+				__func__, ERR_PTR(ret));
 			goto out;
 		}
 
 		ret = regulator_set_voltage(reg, 0, INT_MAX);
 		if (ret) {
-			dev_info(hba->dev,
-				 "failed to set vcore to MIN\n");
+			dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
+				__func__, ERR_PTR(ret));
 		}
 	}
 out:
@@ -812,10 +811,8 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
 		if (clk_pwr_off) {
 			ufs_mtk_pwr_ctrl(hba, false);
 		} else {
-			dev_warn(hba->dev, "Clock is not turned off, hba->ahit = 0x%x, AHIT = 0x%x\n",
-				hba->ahit,
-				ufshcd_readl(hba,
-					REG_AUTO_HIBERNATE_IDLE_TIMER));
+			dev_warn(hba->dev, "Clock isn't off, hba->ahit = 0x%x, AHIT = 0x%x\n",
+				 hba->ahit, ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER));
 		}
 		ufs_mtk_mcq_disable_irq(hba);
 	} else if (on && status == POST_CHANGE) {
@@ -859,11 +856,11 @@ static void ufs_mtk_mcq_set_irq_affinity(struct ufs_hba *hba, unsigned int cpu)
 	_cpu = (cpu == 0) ? 3 : cpu;
 	ret = irq_set_affinity(irq, cpumask_of(_cpu));
 	if (ret) {
-		dev_err(hba->dev, "set irq %d affinity to CPU %d failed\n",
+		dev_err(hba->dev, "setting irq %d affinity to CPU %d failed\n",
 			irq, _cpu);
 		return;
 	}
-	dev_info(hba->dev, "set irq %d affinity to CPU: %d\n", irq, _cpu);
+	dev_dbg(hba->dev, "set irq %d affinity to CPU %d\n", irq, _cpu);
 }
 
 static bool ufs_mtk_is_legacy_chipset(struct ufs_hba *hba, u32 hw_ip_ver)
@@ -879,7 +876,8 @@ static bool ufs_mtk_is_legacy_chipset(struct ufs_hba *hba, u32 hw_ip_ver)
 	default:
 		break;
 	}
-	dev_info(hba->dev, "legacy IP version - 0x%x, is legacy : %d", hw_ip_ver, is_legacy);
+	dev_dbg(hba->dev, "IP version 0x%x, legacy = %s", hw_ip_ver,
+		str_true_false(is_legacy));
 
 	return is_legacy;
 }
@@ -984,15 +982,12 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		}
 	}
 
-	list_for_each_entry(clki, head, list) {
-		dev_info(hba->dev, "clk \"%s\" present", clki->name);
-	}
+	list_for_each_entry(clki, head, list)
+		dev_dbg(hba->dev, "clk \"%s\" present", clki->name);
 
 	if (!ufs_mtk_is_clk_scale_ready(hba)) {
 		hba->caps &= ~UFSHCD_CAP_CLK_SCALING;
-		dev_info(hba->dev,
-			 "%s: Clk-scaling not ready. Feature disabled.",
-			 __func__);
+		dev_info(hba->dev, "%s: Clock scaling unavailable", __func__);
 		return;
 	}
 
@@ -1002,8 +997,8 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	 */
 	reg = devm_regulator_get_optional(dev, "dvfsrc-vcore");
 	if (IS_ERR(reg)) {
-		dev_info(dev, "failed to get dvfsrc-vcore: %ld",
-			 PTR_ERR(reg));
+		if (PTR_ERR(reg) != -ENODEV)
+			dev_err(dev, "Failed to get dvfsrc-vcore: %pe\n", reg);
 		return;
 	}
 
@@ -1017,12 +1012,9 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	host->mclk.vcore_volt = volt;
 
 	/* If default boot is max gear, request vcore */
-	if (reg && volt && host->clk_scale_up) {
-		if (regulator_set_voltage(reg, volt, INT_MAX)) {
-			dev_info(hba->dev,
-				"Failed to set vcore to %d\n", volt);
-		}
-	}
+	if (reg && volt && host->clk_scale_up)
+		if (regulator_set_voltage(reg, volt, INT_MAX))
+			dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 }
 
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
@@ -1109,7 +1101,7 @@ static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
 		}
 		host->mcq_intr_info[i].hba = hba;
 		host->mcq_intr_info[i].irq = irq;
-		dev_info(hba->dev, "get platform mcq irq: %d, %d\n", i, irq);
+		dev_dbg(hba->dev, "get platform mcq irq: %d, %d\n", i, irq);
 	}
 
 	return;
@@ -1421,10 +1413,9 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		ret = ufshcd_uic_change_pwr_mode(hba,
 					FASTAUTO_MODE << 4 | FASTAUTO_MODE);
 
-		if (ret) {
-			dev_err(hba->dev, "%s: HSG1B FASTAUTO failed ret=%d\n",
+		if (ret)
+			dev_err(hba->dev, "%s: HSG1B FASTAUTO failed: ret=%d\n",
 				__func__, ret);
-		}
 	}
 
 	/* if already configured to the requested pwr_mode, skip adapt */
@@ -1474,7 +1465,7 @@ static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 
 out:
 	if (ret) {
-		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
+		dev_err(hba->dev, "Failed to exit h8 state: %pe\n", ERR_PTR(ret));
 
 		ufshcd_force_error_recovery(hba);
 
@@ -1678,12 +1669,12 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 	/* Check link state to make sure exit h8 success */
 	err = ufs_mtk_wait_idle_state(hba, 5);
 	if (err) {
-		dev_warn(hba->dev, "wait idle fail, err=%d\n", err);
+		dev_err(hba->dev, "Failed to wait for idle: %pe\n", ERR_PTR(err));
 		return err;
 	}
 	err = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
 	if (err) {
-		dev_warn(hba->dev, "exit h8 state fail, err=%d\n", err);
+		dev_err(hba->dev, "Failed to wait for link to be up: %pe\n", ERR_PTR(err));
 		return err;
 	}
 	ufshcd_set_link_active(hba);
@@ -1987,20 +1978,19 @@ static void ufs_mtk_event_notify(struct ufs_hba *hba,
 
 	/* Print details of UIC Errors */
 	if (evt <= UFS_EVT_DME_ERR) {
-		dev_info(hba->dev,
-			 "Host UIC Error Code (%s): %08x\n",
-			 ufs_uic_err_str[evt], val);
+		dev_err(hba->dev, "Host UIC Error Code (%s): %08x\n",
+			ufs_uic_err_str[evt], val);
 		reg = val;
 	}
 
 	if (evt == UFS_EVT_PA_ERR) {
 		for_each_set_bit(bit, &reg, ARRAY_SIZE(ufs_uic_pa_err_str))
-			dev_info(hba->dev, "%s\n", ufs_uic_pa_err_str[bit]);
+			dev_err(hba->dev, "%s\n", ufs_uic_pa_err_str[bit]);
 	}
 
 	if (evt == UFS_EVT_DL_ERR) {
 		for_each_set_bit(bit, &reg, ARRAY_SIZE(ufs_uic_dl_err_str))
-			dev_info(hba->dev, "%s\n", ufs_uic_dl_err_str[bit]);
+			dev_err(hba->dev, "%s\n", ufs_uic_dl_err_str[bit]);
 	}
 }
 
@@ -2215,7 +2205,7 @@ static int ufs_mtk_mcq_config_resource(struct ufs_hba *hba)
 
 	/* fail mcq initialization if interrupt is not filled properly */
 	if (!host->mcq_nr_intr) {
-		dev_info(hba->dev, "IRQs not ready. MCQ disabled.");
+		dev_err(hba->dev, "IRQs not ready. MCQ disabled.");
 		return -EINVAL;
 	}
 

-- 
2.56.0

