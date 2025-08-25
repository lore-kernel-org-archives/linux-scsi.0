Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073AB2C08B2
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 10:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756117110; cv=none; b=ErjtrMYEPi6i6BCxMas5+5qGfw4u9H7v0piNF44xcveHyqa/7C8bbV46z37+/wF7HPTAFX68rEjdJRhwttYqe8T9SiQTkwGGCDhJlLC8Va8oSkyxVaHJpD+TIEiUji7w+chE2ANpNgvgYfnJPq8Z5LMbs9M4+bi1ypKWSM0R0vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756117110; c=relaxed/simple;
	bh=gGqcQROseC4nfbdY4y7OUGmwxnMxECWa+Wu1eiZugJk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FX4E/8b7eP6r6sckWi0/C0Ag3qtEgD3WRu9LyqY3K8T1c8uRElBi7OZhHfn8pn4/EjjSMTJ09C6fOuvyfQOR5VBDmoi3U/cmW5Ee5H0/T/E4X7qA7HoHhWSHaXQW2QCphQF5mMbHrlXx8xQDlynC5wyq3d4m01iK5VFBrsv6VKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=OA++nGd+; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="OA++nGd+"
X-UUID: d22e3910819c11f0b33aeb1e7f16c2b6-20250825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=IwqsQxoM2llm13jGh65iNykZUVz7RHZyDWmronE9rRk=;
	b=OA++nGd+KE0D/y57jMZj6vRvaILeJyu9J5QTPj5ydVK3dg2avrG7zkgABLfAO2qM/3rfHdWgmXQWPctmw5jBenQb5JqLLCc/z+4DGo1OEJA4RBz14hYTlcPo3fyxJfXq3XWn1VhlkwHiJrtBP9mNjJAydoE3Iis4HNGtUiitLnk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:e514fc78-68db-4311-b056-8c77798a7bd1,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:0ee47f7a-966c-41bd-96b5-7d0b3c22e782,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d22e3910819c11f0b33aeb1e7f16c2b6-20250825
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 519647942; Mon, 25 Aug 2025 18:18:18 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 25 Aug 2025 18:18:17 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 25 Aug 2025 18:18:17 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>
Subject: [PATCH v1 04/10] ufs: host: mediatek: Correct resume flow for LPM and MTCMOS
Date: Mon, 25 Aug 2025 18:10:12 +0800
Message-ID: <20250825101815.2891905-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250825101815.2891905-1-peter.wang@mediatek.com>
References: <20250825101815.2891905-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Alice Chao <alice.chao@mediatek.com>

This patch corrects the system resume flow by ensuring that MTCMOS
is turned on before setting LPM to false.
During system suspend, LPM is set to true and MTCMOS is turned off.
The updated resume sequence ensures proper power management and
system stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 1a8848246611..9c90d804aaa0 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2332,11 +2332,11 @@ static int ufs_mtk_system_resume(struct device *dev)
 	if (pm_runtime_suspended(hba->dev))
 		goto out;
 
-	ufs_mtk_dev_vreg_set_lpm(hba, false);
-
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(true, res);
 
+	ufs_mtk_dev_vreg_set_lpm(hba, false);
+
 out:
 	ret = ufshcd_system_resume(dev);
 
-- 
2.45.2

