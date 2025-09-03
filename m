Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFABA1E49F
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 02:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867601; cv=none; b=JQRiAlMZbgHvcTUf5Z0i6oOPFmZ041ze56BOKpBAMpQ9nUbaQkbhba5HTxHW//PMN9OPL/HjAZZBQUcgEIP3bhCZb0FsqOWUbxa44oC06jlQZJLNtChzGhKBFM9gsDUFdlTJyyv+jJnfU3FRjlZCBiFXQzouLb6RMw+amW1BS8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867601; c=relaxed/simple;
	bh=PZBfdiXyQS1QCmAjffjRccBx7SmJitvMBjeXv6mPQOE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CDIRnidxxG8ApBwnpJItTraxUgUcXyHAZhwiTzcAks96HM3BIzXo+ndGQ3YTxo5FR075VLKahUp/mT3Oh5j6TZWf3U7K1q5HUt5s/nJOxD2LvRLJB/9GKBK7yn9lpTMYTM23JNhr1ss9QgCPxDwoKs9MUlLUUtTNPCIUHzEUgIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uoaaB4Bk; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uoaaB4Bk"
X-UUID: 3452ba74887011f0b33aeb1e7f16c2b6-20250903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=OOA6fLQtjDLi4GfHGSY0aD2mwrJxWrMJsebe6gD/7Mk=;
	b=uoaaB4BkKHvc4MBK+b0DBE0vegWcr5hDTygV4KbFzk1h/jSgp3J+63NmFvrDsEo95yTA4rjpcNau2PznWCmeVmuzO6IRi1292DbAkd9Z+5gVK5QrWDUvCCtLgScWt6qht5IwUPzA/Lwf838V0ekQHgI7VEzNcUdtyEx4CehesbU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:29744f72-85f0-4b17-82e2-0a111a01dd07,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:f1326cf,CLOUDID:a03b236c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3452ba74887011f0b33aeb1e7f16c2b6-20250903
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1778213950; Wed, 03 Sep 2025 10:46:34 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 3 Sep 2025 10:46:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 3 Sep 2025 10:46:33 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v3 03/10] ufs: host: mediatek: Correct system PM flow
Date: Wed, 3 Sep 2025 10:44:39 +0800
Message-ID: <20250903024631.496693-4-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903024631.496693-1-peter.wang@mediatek.com>
References: <20250903024631.496693-1-peter.wang@mediatek.com>
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

Refine the system power management (PM) flow by skipping low
power mode (LPM) and MTCMOS settings if runtime PM is already
applied. Prevent redundant operations to ensure a more
efficient PM process.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6d25110c8cb8..d762f096e32e 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2304,27 +2304,38 @@ static int ufs_mtk_system_suspend(struct device *dev)
 
 	ret = ufshcd_system_suspend(dev);
 	if (ret)
-		return ret;
+		goto out;
+
+	if (pm_runtime_suspended(hba->dev))
+		goto out;
 
 	ufs_mtk_dev_vreg_set_lpm(hba, true);
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(false, res);
 
-	return 0;
+out:
+	return ret;
 }
 
 static int ufs_mtk_system_resume(struct device *dev)
 {
+	int ret = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 	struct arm_smccc_res res;
 
+	if (pm_runtime_suspended(hba->dev))
+		goto out;
+
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(true, res);
 
-	return ufshcd_system_resume(dev);
+out:
+	ret = ufshcd_system_resume(dev);
+
+	return ret;
 }
 #endif
 
-- 
2.45.2

