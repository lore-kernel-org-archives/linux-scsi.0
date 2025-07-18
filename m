Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8251EEA55
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 09:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752832535; cv=none; b=R7zldr6iKGniiskQMWHJVUaSdyxQnXuoc0PkWOvIodF62tELQ5d62PjbvNJcpckOjIVp55SofUdVQvEcgXW2vifb4pMXXi99jFwOfpeMYkktn8hZqM44r5TQIk1zDhCsFzXb6wZ22K5NjzGZjCmjWVpAX5Fw35kLjhMvE0yLfSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752832535; c=relaxed/simple;
	bh=pG79oPQVuQUP4sXaK11YrQUy6cM0FBVMluqJWt3Fkgk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xip9vMx0KCMPTszUB2yID5H+z2CPf8g67Pvcydgbygbty/S/cG0J8lfO4oTsbeWH1HoLZ/K20DAbw/RyWAOV+fkqvnJmc+fRrrxjzg5Hn5sBCT3hZgjSaO/FYqRdtRBG7tA0qFhpCgw6B8hlx+dHG+/XfxqRWlauoNmlzuBjTDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=k8mR9eAA; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="k8mR9eAA"
X-UUID: 5546479663bd11f0b33aeb1e7f16c2b6-20250718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=B4LU5ee59xbi0gP8ZOQc4XgfhNEmLH0wOblWiJzYESI=;
	b=k8mR9eAAUEQXrLmnC5zsVnh+TdSbzuKtSqrsfwK5+GommRk1ciLWBMpbgbah8itG/+73aOlPZitBSYSHD4dcC+yOUDyuIWnRhoc4wLMIfFcchspJl9aoHek6XSBEptc1b+nyxAiGJsWzWHhzA+IT/NxIp33cnBWTDU2DMUHwX2E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:ce94bf5c-9b09-4bb0-aee4-a6ad57424a7f,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:c6de9584-a7ec-4748-8ac1-dca5703e241f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5546479663bd11f0b33aeb1e7f16c2b6-20250718
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1478997029; Fri, 18 Jul 2025 17:55:27 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 18 Jul 2025 17:55:26 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 18 Jul 2025 17:55:26 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 1/9] ufs: host: mediatek: Remove unnecessary boolean conversion
Date: Fri, 18 Jul 2025 17:51:44 +0800
Message-ID: <20250718095524.682599-2-peter.wang@mediatek.com>
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

This patch removes unnecessary boolean conversions to ensure consistency
with other usages in ufs-mediatek.c. The changes simplify the code by
directly returning the result of bitwise operations without converting
them to boolean values.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 182f58d0c9db..14f0130da653 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -96,28 +96,28 @@ static bool ufs_mtk_is_boost_crypt_enabled(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
+	return (host->caps & UFS_MTK_CAP_BOOST_CRYPT_ENGINE);
 }
 
 static bool ufs_mtk_is_va09_supported(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
+	return (host->caps & UFS_MTK_CAP_VA09_PWR_CTRL);
 }
 
 static bool ufs_mtk_is_broken_vcc(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_BROKEN_VCC);
+	return (host->caps & UFS_MTK_CAP_BROKEN_VCC);
 }
 
 static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
+	return (host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
 }
 
 static bool ufs_mtk_is_tx_skew_fix(struct ufs_hba *hba)
-- 
2.45.2

