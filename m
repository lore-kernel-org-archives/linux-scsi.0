Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D6029C338
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 09:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752832539; cv=none; b=ovCapK31xHMNhio4r4Ck3HgdKciLCy4sEnsjeeT9K8V3gSmYLGEOzRRaVeg0EEBuzBXHQv987ELrMSGtQDih4RR2DXSy9dAAeGeiJ4b7CclimKb3YyfQLQpSPJetnyOxMu9Xqw189Rug39MBs1rNMCVIQAi16a3pI3KImvdXxtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752832539; c=relaxed/simple;
	bh=INwVGLQI5dNF/ebS5BTVEOtWzcH0N+8qw0dfyv6/WD8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSbTTwcU1jV9FiAg4ZEOLtQBvJCI907zH8uTNcdSIJcmDEK156i7J+AKNEhvh0XDDykEME35o7SIRdOdUxxl1PJpn5fIYrGKLE87R/osPGVQD2fm5nPlWO/EaIud3fDlrPzMD+6O23+44L4YqR04A2bkwIm+gLwKC31B3SM5t2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=oS14DiyG; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="oS14DiyG"
X-UUID: 55fb93ee63bd11f08b7dc59d57013e23-20250718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=kvu0Nr0baRFXO0NQem0K8Pf/6CkY+vqcO6HhTOxR8P8=;
	b=oS14DiyGaGmX05/I/renr+95pmWm1l1XDu42CHEQFOOgYVOyvOLgHGq7GqtxqDy2rx6dk3tqaOMZe9gYvzhg5hMyVY4QL/WlpbOy64fRMLqiNUT5R+vlMgsEHGVfA+zPIngUklZAFAIp58wXBnuwXsT36uJLchh6IFr+TxxZaDc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:e86399af-ecd1-4916-ac09-2bf79f7d0015,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:e95f059a-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 55fb93ee63bd11f08b7dc59d57013e23-20250718
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 786326879; Fri, 18 Jul 2025 17:55:29 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 18 Jul 2025 17:55:27 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 18 Jul 2025 17:55:27 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 7/9] ufs: host: mediatek: Add clock scaling query function
Date: Fri, 18 Jul 2025 17:51:50 +0800
Message-ID: <20250718095524.682599-8-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250718095524.682599-1-peter.wang@mediatek.com>
References: <20250718095524.682599-1-peter.wang@mediatek.com>
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
---
 drivers/ufs/host/ufs-mediatek.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 0e5859bdd919..2bcf126e0693 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -141,6 +141,16 @@ static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)
 	return (host->caps & UFS_MTK_CAP_ALLOW_VCCQX_LPM);
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

