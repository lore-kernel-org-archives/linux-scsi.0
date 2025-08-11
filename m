Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFB72DC321
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918077; cv=none; b=If0Pe83wKdKHYxXcSarcNjsk2UppN4WgUope6ViQL/yJ5SKRBVFiWcG4kBsEzEF78eXlX9bDGf8JCce4SXzK4XSeug2v9StYmiMF2TMJ7R4gSDdR3jDpSSd66FBp4IL/uz7avWjTAFl8laayVj/pb7bY9NuvO8lAhwHcj/7P1pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918077; c=relaxed/simple;
	bh=8DUptQiJ/GPkVr8WMBPkjAwWrR3+DO0H/hD6GTW1A2k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PIDL8w32UcKc7WauqlHw73ZiqjnoV8NY6SwPv0O2ZA+ZfORtC3oLsx0fTtz0z/ZAfd8Kl7qTyztXL6CdNkeiOHD4BAdMm8KLMpK2L/AOP4D3acWcLnTOZTAlMpW9+QMFMQVFc2/NkTduVQpDCPdjBmFpVg1QIsR9D7zKlUdFZ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=HKaFGuvv; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="HKaFGuvv"
X-UUID: 1abed77276b511f0b33aeb1e7f16c2b6-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ZgRwHyQQDqUue0qOYsSIGw8F6zqXxwNTuvYyNsIqQT0=;
	b=HKaFGuvvBiHR8PaGleh/di1wJfoYCDxlK0oSLWAPbCp9OpppG8bplI3gwJyZfO4dC6k2h1gv4WwBpFy3sGQ/9LwYCRZmeILaxJs/jEJ/3qD77ksRL08pcqyJ0dcM7jHsXxO8adzQpPfChOSblkjTr8l1DgiTndLsaYI/D3AXWnw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:69e73733-d2a3-4fb4-953c-858329268b66,IP:0,UR
	L:0,TC:0,Content:-5,EDM:-30,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-35
X-CID-META: VersionHash:f1326cf,CLOUDID:6ddb4fa1-1800-4e4f-b665-a3d622db32cf,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	2,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,A
	V:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1abed77276b511f0b33aeb1e7f16c2b6-20250811
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1756464591; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:24 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:24 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 01/10] ufs: host: mediatek: Simplify variable usage
Date: Mon, 11 Aug 2025 21:11:17 +0800
Message-ID: <20250811131423.3444014-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250811131423.3444014-1-peter.wang@mediatek.com>
References: <20250811131423.3444014-1-peter.wang@mediatek.com>
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

This patch simplifies the code by using 'info->vcc' instead
of 'hba->vreg_info.vcc', as they refer to the same value.
This change improves code readability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index f902ce08c95a..2be13b982281 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1018,7 +1018,7 @@ static int ufs_mtk_vreg_fix_vcc(struct ufs_hba *hba)
 	struct arm_smccc_res res;
 	int err, ver;
 
-	if (hba->vreg_info.vcc)
+	if (info->vcc)
 		return 0;
 
 	if (of_property_read_bool(np, "mediatek,ufs-vcc-by-num")) {
-- 
2.45.2

