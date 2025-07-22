Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0AF1876
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153741; cv=none; b=EC4NV6GZNfzMB0rowUoKqb3xWGEC9viyvc/x5eIvREd3c5Fm1hIMA2+1N/egIi51g3rF0bkAlwfxMwB90no9XfPL993l98Ye+DDHA7Nnp3662pJYRxSH8o8BzXLdChshqc6nscQyj/1w2RiPh8OqcyTcsXE26zj/5TZOatZvJnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153741; c=relaxed/simple;
	bh=czoJJ16J/iSJxz4DTScMJEe91u0cDv11npmDmBq7ZZU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YdnHB4CYiXDpvvI3Zq5On8o1zWWeLw9uLRbNdqHq/kurSi7O0GLZ+O4ULQhgrEkswGXHaUXbcPUYUQMf8Wku3UyYygbICc48GFGGx96GfVBvkcFWJH/cFWldCrwkf14qycgQzW4g9ufRwCAeD1KK7RiuZkEEhlgOI6Zc3zSPDeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dkgTBkqB; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dkgTBkqB"
X-UUID: 2e998e7a66a911f0b33aeb1e7f16c2b6-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=eT5G26it2LoWLpqBvVCXM8qF2bBmdhGjdsCmJd3WkD8=;
	b=dkgTBkqBomZFJ5IP3AyZIcwDVov3ZaVn/7eMFLhY55XrZ7DXSNV9dU84dkoJKMA7chfYRd/yx5WxeB389OyoZRK6GqtLL9zKyA2jb96SHTCgbSXVH5ITARb9DQPDxrP/mPK8gqahvWExHI5T8p3QS7qflEIc79pTTitePb0gvGw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:7af94c56-ef7b-4dec-a699-4dac127cde6f,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:68ce1b50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2e998e7a66a911f0b33aeb1e7f16c2b6-20250722
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 963423223; Tue, 22 Jul 2025 11:08:46 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 11:08:42 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 11:08:42 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v4 1/9] ufs: host: mediatek: Simplify boolean conversion
Date: Tue, 22 Jul 2025 11:07:16 +0800
Message-ID: <20250722030841.1998783-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250722030841.1998783-1-peter.wang@mediatek.com>
References: <20250722030841.1998783-1-peter.wang@mediatek.com>
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

This patch simplifies the conversion from unsigned int to boolean
by removing explicit conversions and parentheses, relying on implicit
conversion instead. This change ensures consistency with other
usages in ufs-mediatek.c and streamlines the code.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 182f58d0c9db..744efcde1fff 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -96,49 +96,49 @@ static bool ufs_mtk_is_boost_crypt_enabled(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
+	return host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE;
 }
 
 static bool ufs_mtk_is_va09_supported(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
+	return host->caps & UFS_MTK_CAP_VA09_PWR_CTRL;
 }
 
 static bool ufs_mtk_is_broken_vcc(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
+	return host->caps & UFS_MTK_CAP_BROKEN_VCC;
 }
 
 static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
+	return host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO;
 }
 
 static bool ufs_mtk_is_tx_skew_fix(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return (host->caps & UFS_MTK_CAP_TX_SKEW_FIX);
+	return host->caps & UFS_MTK_CAP_TX_SKEW_FIX;
 }
 
 static bool ufs_mtk_is_rtff_mtcmos(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return (host->caps & UFS_MTK_CAP_RTFF_MTCMOS);
+	return host->caps & UFS_MTK_CAP_RTFF_MTCMOS;
 }
 
 static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return (host->caps & UFS_MTK_CAP_ALLOW_VCCQX_LPM);
+	return host->caps & UFS_MTK_CAP_ALLOW_VCCQX_LPM;
 }
 
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
-- 
2.45.2

