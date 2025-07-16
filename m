Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404472877EF
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 06:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752647330; cv=none; b=kwKOtW/ocBIjbkYy3q3M9RuVxDOEjqfj0eQyYatzP3PFr3UFSV1kMdYOa0Fp7tolatX0C8YSFx4EVWybYQ9ABbpcekItk3iBxdgH0dDK4GQUX4DSXKWg6HIpgr+vwPU3cKtfm1poh0xw4QlgV0W05S5znYm8jS5YiMIM4j+wuT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752647330; c=relaxed/simple;
	bh=MhKPSzQGOybFVEuwl8UwsoQ35ScFoSZxRf/m5FaAk/4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CVAg0+xlgmn32YFbsRF+MZNL6S8tcwH0VLp+I43ayFkAnxi7oiHTiv2cAFPHPiopb6E8V5+8A9A0BR1ZseyvXZySOzptSOXtagVThPkRu8G4CVxLggld/KgkyQ9T7M2nczl9wSusZSB69W9X11198FBVzl13A6UjyxEn+F6+8ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Vkp/DRo3; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Vkp/DRo3"
X-UUID: 19eceb24620e11f08b7dc59d57013e23-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8R9oxVbClGPPXG7bwll29LQXRONqsfRw/H5cpU/0Icc=;
	b=Vkp/DRo3pBsI9eRSSh7B3PUlG3A+Mdz2K9w+sVLbmGjB9y355OAq+lXvPzbVjzg+T94MQDIlOLxEARrDtCHoDR64QtGRCirR+pUxaCjnwqHyZ73JGgO4D/NPqJjO9J4U7Z0O87I4iNTzMYzvi3fLQzj6BJNRvzY4CuPyROuYDNs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:633bfdaf-01bc-4711-8df1-76059976f90b,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:72dcea49-3902-4ad6-a511-6378a8132fbf,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 19eceb24620e11f08b7dc59d57013e23-20250716
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1484865348; Wed, 16 Jul 2025 14:28:35 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 16 Jul 2025 14:28:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 16 Jul 2025 14:28:33 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v1 10/10] ufs: host: mediatek: Support FDE (AES) clock scaling
Date: Wed, 16 Jul 2025 14:25:35 +0800
Message-ID: <20250716062830.3712487-11-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250716062830.3712487-1-peter.wang@mediatek.com>
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
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

This patch adds support for scaling the FDE (AES) clock to achieve higher
performance, particularly for HS-G5. The implementation includes:
1. Parsing DTS settings for FDE min/max mux.
2. Scaling up the FDE clock when required for enhanced performance.

These changes ensure that the FDE clock can be dynamically adjusted
based on performance needs, leveraging DTS configurations.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 54 ++++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-mediatek.h |  3 ++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 28aba2f24dd3..bcebbd42baab 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -960,9 +960,23 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 			host->mclk.ufs_sel_min_clki = clki;
 			clk_disable_unprepare(clki->clk);
 			list_del(&clki->list);
+		} else if (!strcmp(clki->name, "ufs_fde")) {
+			host->mclk.ufs_fde_clki = clki;
+		} else if (!strcmp(clki->name, "ufs_fde_max_src")) {
+			host->mclk.ufs_fde_max_clki = clki;
+			clk_disable_unprepare(clki->clk);
+			list_del(&clki->list);
+		} else if (!strcmp(clki->name, "ufs_fde_min_src")) {
+			host->mclk.ufs_fde_min_clki = clki;
+			clk_disable_unprepare(clki->clk);
+			list_del(&clki->list);
 		}
 	}
 
+	list_for_each_entry(clki, head, list) {
+		dev_info(hba->dev, "clk \"%s\" present", clki->name);
+	}
+
 	if (!ufs_mtk_is_clk_scale_ready(hba)) {
 		hba->caps &= ~UFSHCD_CAP_CLK_SCALING;
 		dev_info(hba->dev,
@@ -1765,14 +1779,16 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki = mclk->ufs_sel_clki;
+	struct ufs_clk_info *fde_clki = mclk->ufs_fde_clki;
 	struct regulator *reg;
 	int volt, ret = 0;
 	bool clk_bind_vcore = false;
+	bool clk_fde_scale = false;
 
 	if (!hba->clk_scaling.is_initialized)
 		return;
 
-	if (!clki)
+	if (!clki || !fde_clki)
 		return;
 
 	reg = host->mclk.reg_vcore;
@@ -1780,6 +1796,9 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 	if (reg && volt != 0)
 		clk_bind_vcore = true;
 
+	if (mclk->ufs_fde_max_clki && mclk->ufs_fde_min_clki)
+		clk_fde_scale = true;
+
 	ret = clk_prepare_enable(clki->clk);
 	if (ret) {
 		dev_info(hba->dev,
@@ -1787,6 +1806,15 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 		return;
 	}
 
+	if (clk_fde_scale) {
+		ret = clk_prepare_enable(fde_clki->clk);
+		if (ret) {
+			dev_info(hba->dev,
+				 "fde clk_prepare_enable() fail, ret: %d\n", ret);
+			return;
+		}
+	}
+
 	if (scale_up) {
 		if (clk_bind_vcore) {
 			ret = regulator_set_voltage(reg, volt, INT_MAX);
@@ -1802,7 +1830,28 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
 				ret);
 		}
+
+		if (clk_fde_scale) {
+			ret = clk_set_parent(fde_clki->clk,
+				mclk->ufs_fde_max_clki->clk);
+			if (ret) {
+				dev_info(hba->dev,
+					"Failed to set fde clk mux, ret = %d\n",
+					ret);
+			}
+		}
 	} else {
+		if (clk_fde_scale) {
+			ret = clk_set_parent(fde_clki->clk,
+				mclk->ufs_fde_min_clki->clk);
+			if (ret) {
+				dev_info(hba->dev,
+					"Failed to set fde clk mux, ret = %d\n",
+					ret);
+				goto out;
+			}
+		}
+
 		ret = clk_set_parent(clki->clk, mclk->ufs_sel_min_clki->clk);
 		if (ret) {
 			dev_info(hba->dev, "Failed to set clk mux, ret = %d\n",
@@ -1821,6 +1870,9 @@ static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up)
 
 out:
 	clk_disable_unprepare(clki->clk);
+
+	if (clk_fde_scale)
+		clk_disable_unprepare(fde_clki->clk);
 }
 
 /**
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 1395c65b46fe..997da391d0a0 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -149,6 +149,9 @@ struct ufs_mtk_clk {
 	struct ufs_clk_info *ufs_sel_clki; /* Mux */
 	struct ufs_clk_info *ufs_sel_max_clki; /* Max src */
 	struct ufs_clk_info *ufs_sel_min_clki; /* Min src */
+	struct ufs_clk_info *ufs_fde_clki; /* Mux */
+	struct ufs_clk_info *ufs_fde_max_clki; /* Max src */
+	struct ufs_clk_info *ufs_fde_min_clki; /* Min src */
 	struct regulator *reg_vcore;
 	int vcore_volt;
 };
-- 
2.45.2

