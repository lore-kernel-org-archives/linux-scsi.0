Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5C5288C2D
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 08:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753087001; cv=none; b=Zsid0sdv191Bip5glHjuO7TBxeUUhN9CY6V9g0CzkLd4f1PuYl9/OGN7C+0DL2x4yLssvCnUMbFoD74hXn/QVZmR6EXS8TC6DOMAU2UB94BlD0Y3CuVoVJ5d+2qzpIfxO7N5s846aUVN1tDvOiO+q9aEWKd6XFC0+yUYSBK563k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753087001; c=relaxed/simple;
	bh=FhzVvZ9NSL5ldhpB5A3JG51RFgQ6GHo8pNNtk4v6GEA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VpygRWgw4T0BzWJGjXbgDS9LpALPA/MafXbzSRijZJQmZrXH3Tp18XnQWShoZ4oeShjn/na5rBTf20xBsPZXC89QLlPDaiXJszrNAq7ywNrUNPoRE5bRSt/GiGyEkNXuLorUHIFkFBjxriBB5c38bP30vnAsFplGAlKO0kBneqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BRTNv+F8; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BRTNv+F8"
X-UUID: cd087b30660d11f0b33aeb1e7f16c2b6-20250721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=5Pi5P+FwZFfw7EkZYdI0mOEEfVb9ihzQxwHeoxEl064=;
	b=BRTNv+F86gcmbFOzWDmzWPVsoX+TlYA5pCqJHPUQjmhgjOodPdaCarhA+6JjvRNz63UzGa9UzXF8M75LvelRb7RR49KY9B7PkTa2cb1mgQJ7yUteF+q9u/qf/jtbPpFtuuXC6xOxu/NV7w2FJgnnni+YpPA8t1BfxGVlw292HDE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:afcacb25-b1ee-4456-bf8b-1a4be4a7f0de,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:9eb4ff7,CLOUDID:6d5caa84-a7ec-4748-8ac1-dca5703e241f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cd087b30660d11f0b33aeb1e7f16c2b6-20250721
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1626611813; Mon, 21 Jul 2025 16:36:30 +0800
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
Subject: [PATCH v3 7/9] ufs: host: mediatek: Add clock scaling query function
Date: Mon, 21 Jul 2025 16:35:16 +0800
Message-ID: <20250721083626.1801668-8-peter.wang@mediatek.com>
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

This patch introduces a clock scaling readiness query function to
streamline the process of checking clock scaling parameters.
This function simplifies the code by encapsulating the logic
for determining if clock scaling is ready.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 28aba44068da..0b3cce8d9787 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -141,6 +141,16 @@ static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)
 	return host->caps & UFS_MTK_CAP_ALLOW_VCCQX_LPM;
 }
 
+static bool ufs_mtk_is_clk_scale_ready(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	struct ufs_mtk_clk *mclk = &host->mclk;
+
+	return mclk->ufs_sel_clki &&
+		mclk->ufs_sel_max_clki &&
+		mclk->ufs_sel_min_clki;
+}
+
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
 {
 	u32 tmp;
@@ -922,7 +932,6 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct list_head *head = &hba->clk_list_head;
-	struct ufs_mtk_clk *mclk = &host->mclk;
 	struct ufs_clk_info *clki, *clki_tmp;
 
 	/*
@@ -944,8 +953,7 @@ static void ufs_mtk_init_clocks(struct ufs_hba *hba)
 		}
 	}
 
-	if (!mclk->ufs_sel_clki || !mclk->ufs_sel_max_clki ||
-	    !mclk->ufs_sel_min_clki) {
+	if (!ufs_mtk_is_clk_scale_ready(hba)) {
 		hba->caps &= ~UFSHCD_CAP_CLK_SCALING;
 		dev_info(hba->dev,
 			 "%s: Clk-scaling not ready. Feature disabled.",
-- 
2.45.2

