Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969052D640E
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 10:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756117110; cv=none; b=mclllrTzyJFjiKHgJxgrASh9FBNblxnMhRWZOixpQKWvupfdpc42GHModQ5cbrtzt8nDyA1Mahi0AcJKMaOHBZ905Uyc32kiNgMRmJ7td6zeQ8JHEag8HeAU6xfXIaLLHPS4wByKv4C6CW7AZABBQDdnKapWt32uB7B+p4oJdrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756117110; c=relaxed/simple;
	bh=hUI4Gl0qGXqFLtyFfZbbXgjHUMkfEuTU2tRTgoaNUkA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KSbo9e1FcwatCQna790jU85hnHJkMRmoTPdKGCS7cmytHrOFD+3Q/Kg0yP+xA4ASJpmHVi9OMdx4tQNlooOvABBLbDi9TYUKEN/zY10oXpOCrFmQdYYgGxVhXyNNUr9GP3YzWJaknb4nqHwzh8H+gPUGTHRnVayLNyfEihAGG7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=taVfUWL6; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="taVfUWL6"
X-UUID: d2307bda819c11f0b33aeb1e7f16c2b6-20250825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=O/hnpd7fxbTStHYbp7cMBE2k26KaUCYsUqW8t10N6uI=;
	b=taVfUWL6d9Iydkrk14HT6gIB+mdSi83jOCteeNoqpYo3MnbRi9ysQdNMeUrV2jWxVpNNHcUeIDaX4kIe0eFVH5a8l/4Ll+UKv14XXj8OZksSpa46JjeYAJHVvIEUYXcLu5eIg+oyjntlxMv3oR55P2CgLwA2genVgLxRx8a5ZYg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:b028f937-909e-4ca8-ad6b-eecab17d29f6,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:f1326cf,CLOUDID:70f8956d-c2f4-47a6-876f-59a53e9ecc6e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d2307bda819c11f0b33aeb1e7f16c2b6-20250825
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 703772079; Mon, 25 Aug 2025 18:18:18 +0800
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
Subject: [PATCH v1 05/10] ufs: host: mediatek: Support UFS PHY runtime PM and correct sequence
Date: Mon, 25 Aug 2025 18:10:13 +0800
Message-ID: <20250825101815.2891905-6-peter.wang@mediatek.com>
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

This patch adds support for UFS PHY runtime power management by
probing the PHY device and enabling its runtime PM. It ensures the
correct sequence of operations during suspend and resume:
PHY suspend -> UFS suspend -> UFS resume -> PHY resume.
This enhancement improves power management efficiency and system
stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 53 +++++++++++++++++++++++++++++----
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 9c90d804aaa0..f9def0b68921 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2248,10 +2248,12 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 static int ufs_mtk_probe(struct platform_device *pdev)
 {
 	int err;
-	struct device *dev = &pdev->dev;
-	struct device_node *reset_node;
-	struct platform_device *reset_pdev;
+	struct device *dev = &pdev->dev, *phy_dev = NULL;
+	struct device_node *reset_node, *phy_node = NULL;
+	struct platform_device *reset_pdev, *phy_pdev = NULL;
 	struct device_link *link;
+	struct ufs_hba *hba;
+	struct ufs_mtk_host *host;
 
 	reset_node = of_find_compatible_node(NULL, NULL,
 					     "ti,syscon-reset");
@@ -2278,13 +2280,44 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 	}
 
 skip_reset:
+	/* find phy node */
+	phy_node = of_parse_phandle(dev->of_node, "phys", 0);
+
+	if (phy_node) {
+		phy_pdev = of_find_device_by_node(phy_node);
+		if (!phy_pdev)
+			goto skip_phy;
+		phy_dev = &phy_pdev->dev;
+
+		pm_runtime_set_active(phy_dev);
+		pm_runtime_enable(phy_dev);
+		pm_runtime_get_sync(phy_dev);
+
+		put_device(phy_dev);
+		dev_info(dev, "phys node found\n");
+	} else {
+		dev_notice(dev, "phys node not found\n");
+	}
+
+skip_phy:
 	/* perform generic probe */
 	err = ufshcd_pltfrm_init(pdev, &ufs_hba_mtk_vops);
-
-out:
-	if (err)
+	if (err) {
 		dev_err(dev, "probe failed %d\n", err);
+		goto out;
+	}
+
+	hba = platform_get_drvdata(pdev);
+	if (!hba)
+		goto out;
+
+	if (phy_node && phy_dev) {
+		host = ufshcd_get_variant(hba);
+		host->phy_dev = phy_dev;
+	}
 
+out:
+	of_node_put(phy_node);
 	of_node_put(reset_node);
 	return err;
 }
@@ -2348,6 +2381,7 @@ static int ufs_mtk_system_resume(struct device *dev)
 static int ufs_mtk_runtime_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct arm_smccc_res res;
 	int ret = 0;
 
@@ -2360,17 +2394,24 @@ static int ufs_mtk_runtime_suspend(struct device *dev)
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(false, res);
 
+	if (host->phy_dev)
+		pm_runtime_put_sync(host->phy_dev);
+
 	return 0;
 }
 
 static int ufs_mtk_runtime_resume(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 	struct arm_smccc_res res;
 
 	if (ufs_mtk_is_rtff_mtcmos(hba))
 		ufs_mtk_mtcmos_ctrl(true, res);
 
+	if (host->phy_dev)
+		pm_runtime_get_sync(host->phy_dev);
+
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
 	return ufshcd_runtime_resume(dev);
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index e46dc5fa209d..dfbf78bd8664 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -193,6 +193,7 @@ struct ufs_mtk_host {
 	bool is_mcq_intr_enabled;
 	int mcq_nr_intr;
 	struct ufs_mtk_mcq_intr_info mcq_intr_info[UFSHCD_MAX_Q_NR];
+	struct device *phy_dev;
 };
 
 /* MTK delay of autosuspend: 500 ms */
-- 
2.45.2

