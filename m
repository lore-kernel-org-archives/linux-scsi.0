Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3D241167E;
	Thu, 30 Jul 2026 09:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405025; cv=none; b=JMHHLUQR+/++4jq6bFGO69mIxUNBsuLkFPokPr82yLEDWtVKGu9Rrll4iBUByiaNyow4QAglK79vt/E+YqLaQpzuxApMsuAlR2JkyHfZ5RqzLZQkxl5prLMPCngxnb3gxkvdkCL89QKNs7AdZ77yFLGofMfmqP77tfgq4MK8pcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405025; c=relaxed/simple;
	bh=PldlQ0KDDrj7Pp2nJ0tTvE40PVJeyn7nxxcvV6YgwG0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BwlR5dk1Nj4+aBW7+dRl1EBODBYvdO7EMapsu8jAdZOsJ1xRc7Q5puA+BA0pfAyPkfnTpXK9yBS8HbFYmtXAoTzjQpa0cuWl6oUEPkjS1bD5AIpkSgLp4hpFbXHWLneGyFL/cJNV7j9eKtW/j8qeTLlXwaOq5IdZTMnNRb68uLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=BI3UqSgS; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="BI3UqSgS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1785405021;
	bh=PldlQ0KDDrj7Pp2nJ0tTvE40PVJeyn7nxxcvV6YgwG0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BI3UqSgSKckSQkNfBIc2SghPXtBWzMkNxewXVzCH9/ERMAyxuZEkXAL5XcYoTVd01
	 7ueX3KPMPavNveOy1WeiU2pyCatKmVTvDCproQcfbSizya+l2L/wj8rthwoITPFk57
	 ukWxVM49Ds8jo3hsrSIiMip11LzizjXSyj55NxLOU23Ti5yENZrDSUOpG0z2hFeBw7
	 pu14nU3JDuqxKBf0wf3FlxBaSwE14qVvKNkFzky28D9E5NJMPbZByaDW5HaaD144AH
	 12EdDjK9LqU2JVDhmkEQx0vQdS/kLi2IAZoznSHgDAaC822jEFIMjEmxCSpgoRGdZe
	 6s7BUkxClL3Ww==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id CE64717E095D;
	Thu, 30 Jul 2026 11:50:19 +0200 (CEST)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 30 Jul 2026 11:49:13 +0200
Subject: [PATCH v10 17/26] scsi: ufs: mediatek: Rework
 ufs_mtk_wait_idle_state
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-mt8196-ufs-v10-17-bc5ecef202dc@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785404993; l=4342;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=KOF7838plKaZV9k9BZBCNC4SR0msgY3QdpkMzk5+TjQ=;
 b=H2ekgPewVzoNWpvXzlqvwdWdsjFsuJJJVdkMEoPqL0i20veXE67dqBmJ99tqeqXCb29bJoD2t
 PUj06YiMP6QD3uYTwD5d6GHdkvrqOAChmYP9NwZuaEIeY27UGVoYRiX
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

While ufs_mtk_wait_idle state has some code smells for me (the
VS_HCE_BASE early exit seems racey at best), it can still benefit from
some general cleanup to make the code flow less convoluted.

Use the iopoll helpers, for one, and specifically the one that sleeps
and does not busy delay, as it's being done for up to 5ms.

The register read is split out to a helper function that branches
between new and old style flow.

Every called uses the same 5ms timeout value, so there is no point in
making this a parameter. Just assume a 5ms timeout in the function.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 71 +++++++++++++++++------------------------
 1 file changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 33917c345b29..0821de5b8a8f 100644
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
@@ -380,51 +381,39 @@ static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
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
+	/* If the device isn't in a hibernate state after 10us, don't wait. */
+	udelay(10);
+	val = ufs_mtk_read_state(hba, old_style);
+	if (val < VS_HIB_ENTER || val > VS_HIB_EXIT)
+		return 0;
 
-	if (wait_idle && sm != VS_HCE_BASE) {
-		dev_info(hba->dev, "wait idle tmo: 0x%x\n", val);
-		return -ETIMEDOUT;
+	/* Poll to wait for idle */
+	ret = read_poll_timeout(ufs_mtk_read_state, val, (val == VS_HCE_BASE),
+				50, 5 * USEC_PER_MSEC, false, hba, old_style);
+	if (ret) {
+		dev_err(hba->dev, "Timed out waiting for idle state, val = 0x%x\n", val);
+		return ret;
 	}
 
 	return 0;
@@ -1392,7 +1381,7 @@ static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
 
 	/* wait host return to idle state when auto-hibern8 off */
-	ret = ufs_mtk_wait_idle_state(hba, 5);
+	ret = ufs_mtk_wait_idle_state(hba);
 	if (ret)
 		goto out;
 
@@ -1594,7 +1583,7 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 		return err;
 
 	/* Check link state to make sure exit h8 success */
-	err = ufs_mtk_wait_idle_state(hba, 5);
+	err = ufs_mtk_wait_idle_state(hba);
 	if (err) {
 		dev_err(hba->dev, "Failed to wait for idle: %pe\n", ERR_PTR(err));
 		return err;

-- 
2.55.0

