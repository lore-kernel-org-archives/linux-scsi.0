Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795100805;
	b=Y9WKrK9dHy+hL60B6NL+Ox0OO57R0RP8SJnx+PNL1Z/B8MEglnnkML8Qbybiqg5QsLUZ
	 jH/PAvQOouvFrDTeRVus8uHrItK17W2u/5D2fXTLzJ8gSsPSmMBHO3Pbfr/GjIBadfwDL
	 EzahtaP9mpfgH4AOg/I61ToG1LMImGzWeohYhp2TkmVGKNuUAFyrlOMsKYyjLiZZjwvjJ
	 6SGzvV1g8g1Ry8F8sAOR9QsTgap2amUqZFpIKZtXYMSUaEX7yST/kW8YIppHctI5s9tnX
	 dFZHzCOWzL84r4QBuNme/hO0OO8tV+f/9bSu9+Wu7XwoSDdC1t5T/DXIE3wbcSLcd+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795100805;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=uWwyhxJth3S5v2nakFbfAMtoG7G0wtvsBUXsNPSOuJ0=;
	b=Gch00H+cEmxbdNSy8dblL5fhO9ObSvIJgaFDL7EQPF/IDY3FKDBmO0EAqmWSd+eW6wsC
	 XVOdYyIKjZqK66WmWrX0oKEnlwyvaizH0Erh1iiz9wkkijrMyvDldPX4v9eQkNdqKNhpV
	 cUQDhTqKOZgvaKlThnE8SxwetELaZJwUtYLUA63hYEgxsZsFilTtDx5Qz7xAiFs6LVzpe
	 8YYITqSf8Kgn4hH4Bjmzz9STngPpu1foaF/FBfZ4Vgvljx2pMUYpJqHtuHVbWv7dKTF3R
	 MUSIb0AGccKNplBb91zDBHO4y2BZuY6jZKN2Xds1lSFzSiWW9zvKzwdnCVjOdvqkXSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=bAZfw6R9;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0019B606C022;
	Thu, 19 Nov 2026 15:06:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0019B606C022
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=bAZfw6R9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795100803;
	bh=qGZAVnOV1lBHXfSEBYN+9HkaDejMKBBl6iuxTdC6tNk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=bAZfw6R9pgTQyLw7ZXo0OA6enDF9aIYMJahWeK7EboZaBgFXvbGVWIE8+OG9l3VjI
	 GJGExeMa8aFbMsrkL93Dv5JqBKLi6A2O1eQec1DNbMsIGfrlcLFYbDpgkChkkf/oqs
	 Ga1hCns+BoJzCJCu0XaaHcBSV+PwFyo6K53MmvGTX9260CDhwRsykY0ixyp7Xm+Jd1
	 kFjKAOrw7tiVV4I9wNmORRgy18+0Izni09rVxup+qSwukAEm/XglIUcmB+Q3A2n6Bb
	 kuR0/zowBpPa42yMF0w4aizXwE2g4or/jOgzXyyj4aTvNTrHWJy8xuZLNozkmZ4f/U
	 0L0EB21u735vg==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4AFFA17E0BCD;
	Thu, 19 Nov 2026 16:06:42 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Thu, 19 Nov 2026 16:06:10 +0100
Subject: [PATCH v15 22/23] scsi: ufs: mediatek: Remove undocumented
 "clk-scale-up-vcore-min"
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
Message-Id: <20261119-mt8196-ufs-v15-22-aae1eb0382e8@collabora.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795100772; l=4256;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=jwYRNfp30WItBR8fXOeyeeEqAQr8S6YgxX1KwbALJaI=;
 b=6sbVG63QqhbB6Ik9vFSefzVVNv6Tjss3R8QCYuCpCwScmyUs1NvonL6SSZWIlrscT+xDEc5Ib
 V6vgnJXHuhLDilEqNOKeJX2+ehF7+2LjyCz4Xd1PDNsWAH5WHBym8Nz
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

The MediaTek UFS driver contains support for an undocumented,
non-vendor-prefixed u32 property named "clk-scale-up-vcore-min".

Since it is not part of any binding, and would not pass a bindings
review in its current form, remove it.

To return this functionality, it needs to be resubmitted in a series
that also introduces it to the binding, and justifies what it is used
for. Compatibility with downstream device trees is not a valid
justification for its existence.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 42 +----------------------------------------
 drivers/ufs/host/ufs-mediatek.h |  1 -
 2 files changed, 1 insertion(+), 42 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index da5383387c8f..adf73dda4190 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -932,8 +932,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki, *clki_tmp;
-	struct device *dev = hba->dev;
-	u32 volt;
 
 	/*
 	 * Find private clocks and store them in struct ufs_mtk_clk.
@@ -970,24 +968,7 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	if (!ufs_mtk_is_clk_scale_ready(hba)) {
 		hba->caps &= ~UFSHCD_CAP_CLK_SCALING;
 		dev_info(hba->dev, "%s: Clock scaling unavailable", __func__);
-		return;
-	}
-
-	if (!host->reg_vcore)
-		return;
-
-	if (of_property_read_u32(dev->of_node, "clk-scale-up-vcore-min",
-				 &volt)) {
-		dev_info(dev, "failed to get clk-scale-up-vcore-min");
-		return;
 	}
-
-	host->mclk.vcore_volt = volt;
-
-	/* If default boot is max gear, request vcore */
-	if (volt && host->clk_scale_up)
-		if (regulator_set_voltage(host->reg_vcore, volt, INT_MAX))
-			dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 }
 
 static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
@@ -1994,8 +1975,7 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
 	struct ufs_clk_info *fde_clki = mclk->ufs_fde_clki;
-	int volt, ret = 0;
-	bool clk_bind_vcore = false;
+	int ret = 0;
 	bool clk_fde_scale = false;
 
 	if (!hba->clk_scaling.is_initialized)
@@ -2004,10 +1984,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (!clki || !fde_clki)
 		return;
 
-	volt = host->mclk.vcore_volt;
-	if (host->reg_vcore && volt)
-		clk_bind_vcore = true;
-
 	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
 		clk_fde_scale = true;
 
@@ -2028,14 +2004,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	if (scale_up) {
-		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(host->reg_vcore, volt, INT_MAX);
-			if (ret) {
-				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
-				goto out;
-			}
-		}
-
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_max_clki->clk);
 		if (ret) {
 			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
@@ -2067,14 +2035,6 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 				__func__, ERR_PTR(ret));
 			goto out;
 		}
-
-		if (clk_bind_vcore) {
-			ret = regulator_set_voltage(host->reg_vcore, 0, INT_MAX);
-			if (ret) {
-				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
-					__func__, ERR_PTR(ret));
-			}
-		}
 	}
 
 out:
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 6b81c8f76201..5415b6419379 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -154,7 +154,6 @@ struct ufs_mtk_clk {
 	struct ufs_clk_info *ufs_fde_clki; /* Mux */
 	struct ufs_clk_info *ufs_fde_max_clki; /* Max src */
 	struct ufs_clk_info *ufs_fde_min_clki; /* Min src */
-	int vcore_volt;
 };
 
 struct ufs_mtk_hw_ver {

-- 
2.56.1

