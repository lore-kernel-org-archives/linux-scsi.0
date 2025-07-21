Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C543288C2A
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 08:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753087001; cv=none; b=KWPra9dFZAHThQVNXWGceLkcA699aGaGrTR2cEzQ6O6deVwe/QSL6FazXm42NbIOKvbgFoMfeeUw+InEvPEa7HMWR5YPaLSgpSWQlzJD+04ylcW6NstnSD4jAc5+8EtGOKzuXJBrfrXWZ41Zue621mPMKVWKCDJChfGLlaWIprk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753087001; c=relaxed/simple;
	bh=ky5xOMns7EFvJC+sxgKTEeLkTHtC5HfBj3SV04m2wLs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XR+u1GqbplfcQTd2LUijj4cEzMnp0FaK6nr6ebAZ2D1Ceiid6mnnPROGpFZ+WWPE4II6mtuSpPcfoF/lmk+IO7xYsOhWUTjYKDmLerlWe8ByE3hcLRJYDqthHl3OINaL8plQ9AuoPrHQ3PN/RDTg0TO23Anq0OYJUwsWinP5INM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NkwuZz3q; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NkwuZz3q"
X-UUID: cd00c142660d11f0b33aeb1e7f16c2b6-20250721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=zifuw8NbogES0WA/zEFlmx90CZGoe2xrhqThYehacbs=;
	b=NkwuZz3qoabE6w8/oP/rcKHqgJ/8uj1zkXZlfkm4RiMB4JdhyYsMfL8IVLjHwXCjna6kwiGYfh3YP7QFKJdxQgJRkjsNdkwXF+C19FeTK1vTGG36rsisQy3R5Pa8bzTcEDcbUMaRL1rw6ZvTDqds3EBbsm7tQUyVYOlL3t5s0Q0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:986e6757-9f0c-4c5d-85ef-9eae19f1d53b,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:3f4c010f-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cd00c142660d11f0b33aeb1e7f16c2b6-20250721
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 832037883; Mon, 21 Jul 2025 16:36:30 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 21 Jul 2025 16:36:29 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 21 Jul 2025 16:36:28 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v3 1/9] ufs: host: mediatek: Remove unnecessary boolean conversion and parentheses
Date: Mon, 21 Jul 2025 16:35:10 +0800
Message-ID: <20250721083626.1801668-2-peter.wang@mediatek.com>
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

This patch removes unnecessary boolean conversions and parentheses
to ensure consistency with other usages in ufs-mediatek.c. The changes
simplify the code by directly returning the result of bitwise operations
without converting them to boolean values or using extra parentheses.

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

