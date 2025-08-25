Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964322DCBFB
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 10:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756117113; cv=none; b=j3F9636dLEK0zLpeRXUpoDLrybmb+6n5pfpvoi+AMDPT2kKXEy+JwczOzZ7xGoBo8IsAKQEyFaOBriKjM3paJyAI5lNeBGbhRXk9dXauthchOeqkwzGiFG0mzvy36D0JwJsbIqGjmP2A/w/9nQscUbanw8QLgvhC7HrcoKclhSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756117113; c=relaxed/simple;
	bh=Tq7NarJHGJVv5APxJ9uE62W2FD2LTw8zC9fG5avugrk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AIS20zM6l1UtGv2rnVxWLLUC3PFKZXj2/6BKGeReeIoftYJALGZyC8ZVVPlsnjIaOLWI1+54D9cHVoKmDgnVlurfYs2Y0EzqksmERjCz9i3TtgykzWIrpblZOtPQCxA+MFhNeGH9pSEw9R1aTn8BOyNebgTvGm+n6bEPADb7pFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Y09ClY0z; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Y09ClY0z"
X-UUID: d22f638a819c11f0b33aeb1e7f16c2b6-20250825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/Cdfl6LElLDCLLPb15UyLi25cyuIPUN10hhcFe+SLg8=;
	b=Y09ClY0z9R8GqPmXS86vXgw49ftAwF3OzKx0tXBP6HFls5k6AIdQQeZSg/QvpYCrfDadQ5SSRovOzorNfxA7p6eHYTy9jYIOOjkaulO+YIbVcxDiPo9U3lm5FsjFS+iYWCfSDrM3lSjj1vOUumB/XZGBqlGU3Gj9EcYyYgZSgko=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:50425c8b-9d67-44c6-ab89-998c85a35bf8,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:f1326cf,CLOUDID:048bd744-18c5-4075-a135-4c0afe29f9d6,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d22f638a819c11f0b33aeb1e7f16c2b6-20250825
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2051603125; Mon, 25 Aug 2025 18:18:18 +0800
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
Subject: [PATCH v1 03/10] ufs: host: mediatek: Correct system PM flow
Date: Mon, 25 Aug 2025 18:10:11 +0800
Message-ID: <20250825101815.2891905-4-peter.wang@mediatek.com>
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

From: Peter Wang <peter.wang@mediatek.com>

This patch refines the system power management (PM) flow by
skipping low power mode (LPM) and MTCMOS settings if runtime PM
has already been applied. This optimization prevents redundant
operations, ensuring a more efficient PM process.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index d396878cc9a4..1a8848246611 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2309,27 +2309,38 @@ static int ufs_mtk_system_suspend(struct device *dev)
 
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

