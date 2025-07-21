Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA84288518
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 08:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753086999; cv=none; b=Ucuyv3BhgEpYdNiewtIfG+WCAgj8HtYTRgsYp0O17umLS8tX+3tcZbMsv7O+2N6hT+Lfa99gK5eZaNRaxDyZfiQSvHSBVXNdJB78QTns1SIX5bU6RmJPsPWKbqDlXgybvgNr21DbGngUjlLD+7CyZPGvofxR67byZoyp53vDXdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753086999; c=relaxed/simple;
	bh=JO+Mz3dVP7DOG3soGBRroKTcIYDoD/Vgy6RyLxEcjwo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQTwap+MaTu/KlsW44PJMcvL8Ejq4rTnjP1D33qNSqYLxzpMNkQheQpSvO0yZRFaxWehl3L0LSwM/RPAERf6yuabKHHQb7kBA5O+f7evkpDAzBVI1wQfdLKQxFPfrlBZEF5MFeDdNw1fQqSsk6pe2OlAi4hBVvjf9raizh2DPhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=O/oZYWT9; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="O/oZYWT9"
X-UUID: cdb6e36e660d11f08b7dc59d57013e23-20250721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=0dIA5IsR/ojKODFms6Iv6dpQZ1BF9srlqwTzpsrIy88=;
	b=O/oZYWT9oZScm8LnOeMYPgw88rAJ+vLbyu+dH6FrXrGCyPdP5M6ZYNeM8Ccm8IjZMf8H9KWrwBmN8Dg/esF7boSKof6iJg685ee3+M2dRKmh207oXwOZ9a8ZsisdLPF//b+kKSquy+BO/sYqu0CAjSeCnoPqaeTQdKHHt5Q/Jbg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:7b6cff75-164d-48c6-95b7-16a66c239b5a,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:9eb4ff7,CLOUDID:594c010f-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cdb6e36e660d11f08b7dc59d57013e23-20250721
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1495643960; Mon, 21 Jul 2025 16:36:32 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 21 Jul 2025 16:36:30 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 21 Jul 2025 16:36:29 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v3 8/9] ufs: host: mediatek: Support clock scaling with Vcore binding
Date: Mon, 21 Jul 2025 16:35:17 +0800
Message-ID: <20250721083626.1801668-9-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250721083626.1801668-1-peter.wang@mediatek.com>
References: <20250721083626.1801668-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This patch adds support for clock scaling with Vcore binding.
It includes the following changes:
1. Parses the DTS setting for Vcore voltage.
2. Sets the Vcore voltage to the DTS-specified value before scaling up.
3. Resets the Vcore voltage to the default setting after scaling down.

These changes ensure that the Vcore voltage is appropriately managed
during clock scaling operations to maintain system stability and
performance.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 129 +++++++++++++++++++++++++++-----
 drivers/ufs/host/ufs-mediatek.h |   3 +
 2 files changed, 112 insertions(+), 20 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0b3cce8d9787..a0c53d796a60 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -933,6 +933,9 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
 	struct ufs_clk_info *clki, *clki_tmp;
+	struct device *dev = hba->dev;
+	struct regulator *reg;
+	u32 volt;
 
 	/*
 	 * Find private clocks and store them in struct ufs_mtk_clk.
@@ -958,6 +961,35 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		dev_info(hba->dev,
 			 "%s: Clk-scaling not ready. Feature disabled.",
 			 __func__);
+		return;
+	}
+
+	/*
+	 * Default get vcore if dts have these settings.
+	 * No matter clock scaling support or not. (may disable by customer)
+	 */
+	reg = devm_regulator_get_optional(dev, "dvfsrc-vcore");
+	if (IS_ERR(reg)) {
+		dev_info(dev, "failed to get dvfsrc-vcore: %ld",
+			 PTR_ERR(reg));
+		return;
+	}
+
+	if (of_property_read_u32(dev->of_node, "clk-scale-up-vcore-min",
+				 &volt)) {
+		dev_info(dev, "failed to get clk-scale-up-vcore-min");
+		return;
+	}
+
+	host->mclk.reg_vcore = reg;
+	host->mclk.vcore_volt = volt;
+
+	/* If default boot is max gear, request vcore */
+	if (reg && volt && host->clk_scale_up) {
+		if (regulator_set_voltage(reg, volt, INT_MAX)) {
+			dev_info(hba->dev,
+				"Failed to set vcore to %d\n", volt);
+		}
 	}
 }
 
@@ -1126,6 +1158,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	/* Enable clk scaling*/
 	hba->caps |= UFSHCD_CAP_CLK_SCALING;
+	host->clk_scale_up = true; /* default is max freq */
 
 	/* Set runtime pm delay to replace default */
 	shost->rpm_autosuspend_delay = MTK_RPM_AUTOSUSPEND_DELAY_MS;
@@ -1720,24 +1753,25 @@ static void ufs_mtk_config_scaling_param(struct ufs_hba *hba,
 	hba->vps->ondemand_data.downdifferential = 20;
 }
 
-/**
- * ufs_mtk_clk_scale - Internal clk scaling operation
- *
- * MTK platform supports clk scaling by switching parent of ufs_sel(mux).
- * The ufs_sel downstream to ufs_ck which feeds directly to UFS hardware.
- * Max and min clocks rate of ufs_sel defined in dts should match rate of
- * "ufs_sel_max_src" and "ufs_sel_min_src" respectively.
- * This prevent changing rate of pll clock that is shared between modules.
- *
- * @hba: per adapter instance
- * @scale_up: True for scaling up and false for scaling down
- */
-static void ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
+static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
-	int ret = 0;
+	struct regulator *reg;
+	int volt, ret = 0;
+	bool clk_bind_vcore = false;
+
+	if (!hba->clk_scaling.is_initialized)
+		return;
+
+	if (!clki)
+		return;
+
+	reg = host->mclk.reg_vcore;
+	volt = host->mclk.vcore_volt;
+	if (reg && volt != 0)
+		clk_bind_vcore = true;
 
 	ret = clk_prepare_enable(clki->clk);
 	if (ret) {
@@ -1747,20 +1781,75 @@ static void ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	}
 
 	if (scale_up) {
+		if (clk_bind_vcore) {
+			ret = regulator_set_voltage(reg, volt, INT_MAX);
+			if (ret) {
+				dev_info(hba->dev,
+					"Failed to set vcore to %d\n", volt);
+				goto out;
+			}
+		}
+
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_max_clki->clk);
-		clki->curr_freq = clki->max_freq;
+		if (ret) {
+			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
+				ret);
+		}
 	} else {
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_min_clki->clk);
-		clki->curr_freq = clki->min_freq;
-	}
+		if (ret) {
+			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
+				ret);
+			goto out;
+		}
 
-	if (ret) {
-		dev_info(hba->dev,
-			 "Failed to set ufs_sel_clki, ret: %d\n", ret);
+		if (clk_bind_vcore) {
+			ret = regulator_set_voltage(reg, 0, INT_MAX);
+			if (ret) {
+				dev_info(hba->dev,
+					"failed to set vcore to MIN\n");
+			}
+		}
 	}
 
+out:
 	clk_disable_unprepare(clki->clk);
+}
+
+/**
+ * ufs_mtk_clk_scale - Internal clk scaling operation
+ *
+ * MTK platform supports clk scaling by switching parent of ufs_sel(mux).
+ * The ufs_sel downstream to ufs_ck which feeds directly to UFS hardware.
+ * Max and min clocks rate of ufs_sel defined in dts should match rate of
+ * "ufs_sel_max_src" and "ufs_sel_min_src" respectively.
+ * This prevent changing rate of pll clock that is shared between modules.
+ *
+ * @hba: per adapter instance
+ * @scale_up: True for scaling up and false for scaling down
+ */
+static void ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	struct ufs_mtk_clk *mclk = &host->mclk;
+	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
+
+	if (host->clk_scale_up == scale_up)
+		goto out;
+
+	if (scale_up)
+		_ufs_mtk_clk_scale(hba, true);
+	else
+		_ufs_mtk_clk_scale(hba, false);
 
+	host->clk_scale_up = scale_up;
+
+	/* Must always set before clk_set_rate() */
+	if (scale_up)
+		clki->curr_freq = clki->max_freq;
+	else
+		clki->curr_freq = clki->min_freq;
+out:
 	trace_ufs_mtk_clk_scale(clki->name, scale_up, clk_get_rate(clki->clk));
 }
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index fd229514384e..0b25ce5aa836 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -149,6 +149,8 @@ struct ufs_mtk_clk {
 	struct ufs_clk_info *ufs_sel_clki; /* Mux */
 	struct ufs_clk_info *ufs_sel_max_clki; /* Max src */
 	struct ufs_clk_info *ufs_sel_min_clki; /* Min src */
+	struct regulator *reg_vcore;
+	int vcore_volt;
 };
 
 struct ufs_mtk_hw_ver {
@@ -178,6 +180,7 @@ struct ufs_mtk_host {
 	bool mphy_powered_on;
 	bool unipro_lpm;
 	bool ref_clk_enabled;
+	bool clk_scale_up;
 	u16 ref_clk_ungating_wait_us;
 	u16 ref_clk_gating_wait_us;
 	u32 ip_ver;
-- 
2.45.2

