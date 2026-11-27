Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=148.251.105.195
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795247;
	b=hw/mIJn/zFKZejO87eriGc58QLnLU0geJYWSDlDhKyQSVh4uzQXbFeQUyXurbgHUsMMO
	 Q5SBaXPelzAbaY3DZqmkQwcdT7+X7kkx7FQfKfNqBw3uZ5Ex/BwKmyrcf7sx26ym2lqAN
	 d32ELhXy1lTzuyBXPCjpu0gniHMSt0Rr94KmTn8X76rq07OyzasCryo+PxhtD3UDsRK2b
	 HdLmbASFH1KqUMbWX2e/PuWT9qeld1Kb2ppF3IvYyVmgtweDNvpStXJ4vNJt422w0ANE9
	 FWL05KsizZDLz1rTAyDVhUWBv+I32tuLs61Msx5vouZZhKWXVOqqK3K4WrI9uFUyAAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795247;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=gMl7AaxtOSwe8BZAn283gZ71jrQoddC+n/44PuG4fqA=;
	b=oSy8UqNJxZejrV8kNfk8zyBTj27vexspQlh1BGJ4O8a7838nija30FDj4PrA7Q5MwSYC
	 YgDOUN5Jdz1C+TLaBwuwNqUUvSycBnpdDIYYM762V18zv/F3Bj93zdqfEXYC4/I/gAup6
	 Vrp3XLpnCoTuz5tRJtXWvOOvOv44CtF53ukBJoQStqTqJmEWeZBlOvcFCRTgLJxTTK5lh
	 e9wKpkozKB/q+9dQWqq+R3vS4BoI1he877WycOMRZPeFNxLLgDhkmEP2JExkUowcPBfNZ
	 ++X/RO7QWxyClDetIK/W76dv6sU0D245mxVVtgv+guvmc5+BaHuDGO+2Dpv2KXs+utA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=collabora.com;
	spf=pass smtp.mailfrom=collabora.com;
	dkim=pass header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=VhjdRJGG;
	arc=none smtp.remote-ip=148.251.105.195
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC69B606A323;
	Fri, 27 Nov 2026 16:00:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC69B606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.a=rsa-sha256 header.s=mail header.b=VhjdRJGG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1795795245;
	bh=KJVceFNGs+LIjckYujBmFoIgb+VAC1qnY7oDszTjkpo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=VhjdRJGGsNsTDJd0pWmQZD2bYRsvaS83oYz6XlVtkMlOAO7ewdRNNZpFcizdArt5Q
	 dBDTRXhf6VcEU3B1QfxZBm76bhkQLjgzQskAfnk6xefOCLwoQHmTjwj2t8dUSX3Iej
	 oG8i1BUcKo/u1qVmPCk1FNZZO6wNxm7owf4h3qnYm3N9Zda91XRCRvlCgzqMrXEKnC
	 v1LixsCnaDB6qtdgAXW9o+v2+SegUymZW6OqaYCEQMLRg5cNZswcgAhWcPb6X/7KoM
	 l1hPJlahQrTLdoZ5vDUlGLQg883VodKSi6E/MoYskAxyg4pziTFDOulVnJipDHd14b
	 JMHWWhtlVO/4g==
Received: from yukiji.home (unknown [100.64.0.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: laeyraud)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 314CA17E0DF7;
	Fri, 27 Nov 2026 17:00:44 +0100 (CET)
From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Date: Fri, 27 Nov 2026 17:00:19 +0100
Subject: [PATCH v16 16/23] scsi: ufs: mediatek: Rework _ufs_mtk_clk_scale
 error paths
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
Message-Id: <20261127-mt8196-ufs-v16-16-6f2568f7c119@collabora.com>
References: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
In-Reply-To: <20261127-mt8196-ufs-v16-0-6f2568f7c119@collabora.com>
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
 Mark Brown <broonie@kernel.org>, Chun-Hung Wu <chun-hung.wu@mediatek.com>
Cc: kernel@collabora.com, linux-arm-kernel@lists.infradead.org, 
 linux-mediatek@lists.infradead.org, linux-phy@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, 
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795795222; l=3676;
 i=louisalexis.eyraud@collabora.com; s=20250113; h=from:subject:message-id;
 bh=VnRpJ32vDNuktqh8gwq5xlu94/+r0WaDJPvDfVWHrDU=;
 b=s7lePaaN29M7Wy0Orgv1+B5OaQFrfTSW+P7WL9dwRviiGSRsBnEZOxD4JhYyBb4+x5QC9Vk5O
 iw8BmJV4j+hC6fkwiVv1pnwCsldIIZpIqqrTZxqTQgKsRKNouAGGplp
X-Developer-Key: i=louisalexis.eyraud@collabora.com; a=ed25519;
 pk=CHFBDB2Kqh4EHc6JIqFn69GhxJJAzc0Zr4e8QxtumuM=

From: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Errors should be printed at the correct log level. Additionally, it
looks like some "goto out"'s were omitted in the scale up case, which
looks like a mistake, as the scale down branch of the code does use
them.

Rework the error messages to make them nicer and at the correct
verbosity, and add the missing gotos.

Fixes: 5e5976f5242d ("scsi: ufs: host: mediatek: Support FDE (AES) clock scaling")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
---
 drivers/ufs/host/ufs-mediatek.c | 41 +++++++++++++++++++----------------------
 1 file changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 8fa0bd4442ac..b20ecd9c698d 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2056,16 +2056,16 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
 	ret = clk_prepare_enable(clki->clk);
 	if (ret) {
-		dev_info(hba->dev,
-			 "clk_prepare_enable() fail, ret: %d\n", ret);
+		dev_err(hba->dev, "%s: Failed to enable clock: %pe\n", __func__, ERR_PTR(ret));
 		return;
 	}
 
 	if (clk_fde_scale) {
 		ret = clk_prepare_enable(fde_clki->clk);
 		if (ret) {
-			dev_info(hba->dev,
-				 "fde clk_prepare_enable() fail, ret: %d\n", ret);
+			dev_err(hba->dev, "%s: Failed to enable FDE clock: %pe\n",
+				__func__, ERR_PTR(ret));
+			clk_disable_unprepare(clki->clk);
 			return;
 		}
 	}
@@ -2074,51 +2074,48 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 		if (clk_bind_vcore) {
 			ret = regulator_set_voltage(reg, volt, INT_MAX);
 			if (ret) {
-				dev_info(hba->dev,
-					"Failed to set vcore to %d\n", volt);
+				dev_err(hba->dev, "Failed to set vcore to %d\n", volt);
 				goto out;
 			}
 		}
 
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_max_clki->clk);
 		if (ret) {
-			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
-				ret);
+			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
+				__func__, ERR_PTR(ret));
+			goto out;
 		}
 
 		if (clk_fde_scale) {
-			ret = clk_set_parent(fde_clki->clk,
-				mclk->ufs_fde_max_clki->clk);
+			ret = clk_set_parent(fde_clki->clk, mclk->ufs_fde_max_clki->clk);
 			if (ret) {
-				dev_info(hba->dev,
-					"Failed to set fde clk mux, ret = %d\n",
-					ret);
+				dev_err(hba->dev, "%s: Failed to set fde clock mux: %pe\n",
+					__func__, ERR_PTR(ret));
+				goto out;
 			}
 		}
 	} else {
 		if (clk_fde_scale) {
-			ret = clk_set_parent(fde_clki->clk,
-				mclk->ufs_fde_min_clki->clk);
+			ret = clk_set_parent(fde_clki->clk, mclk->ufs_fde_min_clki->clk);
 			if (ret) {
-				dev_info(hba->dev,
-					"Failed to set fde clk mux, ret = %d\n",
-					ret);
+				dev_err(hba->dev, "%s: Failed to set fde clock mux: %pe\n",
+					__func__, ERR_PTR(ret));
 				goto out;
 			}
 		}
 
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_min_clki->clk);
 		if (ret) {
-			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
-				ret);
+			dev_err(hba->dev, "%s: Failed to set clock mux: %pe\n",
+				__func__, ERR_PTR(ret));
 			goto out;
 		}
 
 		if (clk_bind_vcore) {
 			ret = regulator_set_voltage(reg, 0, INT_MAX);
 			if (ret) {
-				dev_info(hba->dev,
-					"failed to set vcore to MIN\n");
+				dev_err(hba->dev, "%s: Failed to set vcore to minimum: %pe\n",
+					__func__, ERR_PTR(ret));
 			}
 		}
 	}

-- 
2.56.1

