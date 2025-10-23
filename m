Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E979C357703;
	Thu, 23 Oct 2025 19:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761249336; cv=pass; b=Yt3qZxGSFGpNT9G9jyJsbHmdcZCJ1aqBhjsMzfOqmi0XHGU/mf1mheu8W9epVou3VaHp/+BfTl6z5PkvMDMbNdlGPzxSly3QCUUt8Gq+zTJEvf/+56N1wD9OAZqacgKXx2wq128x/wkobKw9S4oaPgXuuXwc8Vch6XXFj3dj62E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761249336; c=relaxed/simple;
	bh=MnJWG18RRa67QqdbetDiy+khAJG52ZvEmsUdhpWPtsE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=q8/ENk3EcMSbgZF8+f/6ePEdoW13jVW2KDnxtBOzajdSyl0PEu4hyhv+gZc8MGs2SSBKMKYlaqlp95PlKElCeRBedzc/x6rsIoRxZgeBNkVBmOXs1oU0h4B/BO6XOO0Xm/KqSyBh9zMJepXvdYQnFoguybD5Z6scxNHV143s84w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b=Zl4+4Xkw; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nicolas.frattaroli@collabora.com header.b="Zl4+4Xkw"
ARC-Seal: i=1; a=rsa-sha256; t=1761249126; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=CGgWIi5NTStIbMo2YalBFykuxCsZEEoYK/w4yG+8eLFlhgGhv/xfixmIo0Zix9G9V9M18sa0u5113VP7oWtovKaA6cpZ22ly8FRt3IP8HPV3ZdVWPTJ1X+DrXiXjXIbmB40yVJSJsw19nNm1w3/xrvYEsSgtS5aimZQDNTdofRg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1761249126; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=WGh+e+ydXOPl0kDzx7JCFzdk1cPdHmuqmV738jlvtlg=; 
	b=lthpAoqaszzBNZ8H7H9sF1sffTM1istsD16NV/CZ+0XbK+6FRiNrgZPM9orDpX7/bewP5EGmeciuWLvjDOlev17/yGq/5vo8hnkxuP/9dLGOFXyw+WTRWidxWpdQJTPaUEqCdYfxkbmYrH0nZ3pGEQopmZCHkI3KjuMhc9FAgB8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nicolas.frattaroli@collabora.com;
	dmarc=pass header.from=<nicolas.frattaroli@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1761249126;
	s=zohomail; d=collabora.com; i=nicolas.frattaroli@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=WGh+e+ydXOPl0kDzx7JCFzdk1cPdHmuqmV738jlvtlg=;
	b=Zl4+4XkwaOdrT026I0Y4r/PZonH34kDAp4+n4U7hsjuCz/eLN3p420kPKc5nK6Vp
	cM2MbYgW/KIeGc/lOLGZf9LqGabkMAvno1VuznezMuVekq3dLnPIgZZMSnVF7dMToOz
	A2+rkKfWzTbdL75FJiFW6hPXYPWz5y6WCw9MIGbI=
Received: by mx.zohomail.com with SMTPS id 1761249124749281.2417224628439;
	Thu, 23 Oct 2025 12:52:04 -0700 (PDT)
From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Date: Thu, 23 Oct 2025 21:49:36 +0200
Subject: [PATCH v3 18/24] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-mt8196-ufs-v3-18-0f04b4a795ff@collabora.com>
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

While ufs_mtk_wait_idle state has some code smells for me (the
VS_HCE_BASE early exit seems racey at best), it can still benefit from
some general cleanup to make the code flow less convoluted.

Use the iopoll helpers, for one, and specifically the one that sleeps
and does not busy delay, as it's being done for up to 5ms.

The register read is split out to a helper function that branches
between new and old style flow.

Every called uses the same 5ms timeout value, so there is no point in
making this a parameter. Just assume a 5ms timeout in the function.

Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 71 +++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0c5bc6f19e83..a2e5c2cdafe1 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -10,6 +10,7 @@
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/delay.h>
+#include <linux/iopoll.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
@@ -378,51 +379,39 @@ static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
 	}
 }
 
-static int ufs_mtk_wait_idle_state(struct ufs_hba *hba,
-			    unsigned long retry_ms)
+static u32 ufs_mtk_read_state(struct ufs_hba *hba, bool old_style)
 {
-	u64 timeout, time_checked;
-	u32 val, sm;
-	bool wait_idle;
-	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-
-	/* cannot use plain ktime_get() in suspend */
-	timeout = ktime_get_mono_fast_ns() + retry_ms * 1000000UL;
-
-	/* wait a specific time after check base */
-	udelay(10);
-	wait_idle = false;
+	u32 val;
 
-	do {
-		time_checked = ktime_get_mono_fast_ns();
-		if (host->legacy_ip_ver || host->ip_ver < IP_VER_MT6899) {
-			ufs_mtk_dbg_sel(hba);
-			val = ufshcd_readl(hba, REG_UFS_PROBE);
-		} else {
-			val = ufshcd_readl(hba, REG_UFS_UFS_MMIO_OTSD_CTRL);
-			val = val >> 16;
-		}
+	if (old_style) {
+		ufs_mtk_dbg_sel(hba);
+		val = ufshcd_readl(hba, REG_UFS_PROBE);
+	} else {
+		val = ufshcd_readl(hba, REG_UFS_UFS_MMIO_OTSD_CTRL) >> 16;
+	}
 
-		sm = val & 0x1f;
+	return FIELD_GET(0x1f, val);
+}
 
-		/*
-		 * if state is in H8 enter and H8 enter confirm
-		 * wait until return to idle state.
-		 */
-		if ((sm >= VS_HIB_ENTER) && (sm <= VS_HIB_EXIT)) {
-			wait_idle = true;
-			udelay(50);
-			continue;
-		} else if (!wait_idle)
-			break;
+static int ufs_mtk_wait_idle_state(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	bool old_style = (host->legacy_ip_ver || host->ip_ver < IP_VER_MT6899);
+	u32 val;
+	int ret;
 
-		if (wait_idle && (sm == VS_HCE_BASE))
-			break;
-	} while (time_checked < timeout);
+	/* If the device is already in the base state after 10us, don't wait. */
+	udelay(10);
+	if (ufs_mtk_read_state(hba, old_style) == VS_HCE_BASE)
+		return 0;
 
-	if (wait_idle && sm != VS_HCE_BASE) {
-		dev_info(hba->dev, "wait idle tmo: 0x%x\n", val);
-		return -ETIMEDOUT;
+	/* Poll to wait for idle */
+	ret = read_poll_timeout(ufs_mtk_read_state, val,
+				(val < VS_HIB_ENTER || val > VS_HIB_EXIT), 50,
+				5 * USEC_PER_MSEC, false, hba, old_style);
+	if (ret) {
+		dev_err(hba->dev, "Timed out waiting for idle state, val = 0x%x\n", val);
+		return ret;
 	}
 
 	return 0;
@@ -1376,7 +1365,7 @@ static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
 
 	/* wait host return to idle state when auto-hibern8 off */
-	ret = ufs_mtk_wait_idle_state(hba, 5);
+	ret = ufs_mtk_wait_idle_state(hba);
 	if (ret)
 		goto out;
 
@@ -1580,7 +1569,7 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 		return err;
 
 	/* Check link state to make sure exit h8 success */
-	err = ufs_mtk_wait_idle_state(hba, 5);
+	err = ufs_mtk_wait_idle_state(hba);
 	if (err) {
 		dev_err(hba->dev, "Failed to wait for idle: %pe\n", ERR_PTR(err));
 		return err;

-- 
2.51.1.dirty

