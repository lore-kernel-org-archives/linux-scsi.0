Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC92A17BBF
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710491706; cv=none; b=tS61aLnUDC+fWhKiR6iUC+vzxMzVKxjiw1ALmlr1Tiaonx2t2PAlFWba/1nN0UAkqM+3b13XbnTnQFad0IJFhrb9v8p8CurH3qFZk3R8u5PpIlstOq7ENpf6QHgcjgcSP84ieZfjhjOut12mXoOOUkKKv7Mz9XATyneEVT267DY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710491706; c=relaxed/simple;
	bh=TvdjzYwD0RP/k/mqo38nlefZ2dW1lqs4nISzaTlOUwg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SXaSPF0eFPQLH7/mLfhqQ7MFRBemwOOnbN9PMRsCZVxWpeKzLyOFU42zf7FOqYzSHPpVSduAHnHjl4a7vw8EbzvE9bhLBTU/ixX2IB8XwJSMnqLoT8vmF2EsJTJCBJIPUCSjSN4PsjxlI7+r0v8HkKXOb0mWMwvcCkhoGjGpexA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=e3/AIe7d; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="e3/AIe7d"
X-UUID: e4acfba8e2a611eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=co97dusQYPEklPIpu86QgWV11cpjh4YHyUtI7SGFiQY=;
	b=e3/AIe7de8ofkTMjkkwM22aPB4S/giKh3SqmJSTBJBgvD8Vqn6KXkf++yLAtpXczLKrYZx1yeWNEIyjVWLFiCXd2UNItj2ZwZ37TUeeuFOrtGByPriF1lSzyqNwyIxSWw6/smoygUgEXFNrXv7oy2kR6Jb0NYpAhnZgQ1spjYWE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:da676b27-03e9-48bf-a5c8-28941aa1483a,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:54e68981-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e4acfba8e2a611eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1358295067; Fri, 15 Mar 2024 16:34:52 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 16:34:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 16:34:50 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: [PATCH v2 3/7] ufs: host: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ
Date: Fri, 15 Mar 2024 16:34:44 +0800
Message-ID: <20240315083448.7185-4-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240315083448.7185-1-peter.wang@mediatek.com>
References: <20240315083448.7185-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--9.664600-8.000000
X-TMASE-MatchedRID: Dz2rI8EJB2APRVepDWIjx7iMC5wdwKqdT2fFmw5H8VPI9EDAP/dptm/Y
	agJ/V3Z5L7y59K1QGD/G81sj4r28+AxAtdzYwZJsH5YQyOg71ZZMkOX0UoduuQqiCYa6w8tvlUN
	mxPSthYIULfbRmZ/onHhbWkjJzPSiFm2HuAZVgfZfwzQfOH01PDJcsSAcBZLamyiLZetSf8mfop
	0ytGwvXiq2rl3dzGQ1l3+bAt/YFVRLioE7CwaedVoA92s8DJ3qyWh+cGWvov7FbXKUXP6jRWgGZ
	NLBHGNe
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.664600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 9A9341DD883609E319E4AC0196D5F112CE51C50D14BDD4B24523ED0E53B8A8D42000:8
X-MTK: N

From: Po-Wen Kao <powen.kao@mediatek.com>

Add new mediatek host cap UFS_MTK_CAP_DISABLE_MCQ to allow disable
MCQ feature by assigning dts boolean property
"mediatek,ufs-disable-mcq""

Acked-by: Chun-Hung Wu <Chun-Hung.Wu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 12 ++++++++++++
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 13 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 25bf5a13cddd..2ee7881533ec 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -640,6 +640,9 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-tx-skew-fix"))
 		host->caps |= UFS_MTK_CAP_TX_SKEW_FIX;
 
+	if (of_property_read_bool(np, "mediatek,ufs-disable-mcq"))
+		host->caps |= UFS_MTK_CAP_DISABLE_MCQ;
+
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
@@ -874,6 +877,9 @@ static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
 	host->mcq_nr_intr = UFSHCD_MAX_Q_NR;
 	pdev = container_of(hba->dev, struct platform_device, dev);
 
+	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
+		goto failed;
+
 	for (i = 0; i < host->mcq_nr_intr; i++) {
 		/* irq index 0 is legacy irq, sq/cq irq start from index 1 */
 		irq = platform_get_irq(pdev, i + 1);
@@ -1585,6 +1591,12 @@ static int ufs_mtk_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 
 static int ufs_mtk_get_hba_mac(struct ufs_hba *hba)
 {
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	/* MCQ operation not permitted */
+	if (host->caps & UFS_MTK_CAP_DISABLE_MCQ)
+		return -EPERM;
+
 	return MAX_SUPP_MAC;
 }
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index c1acbfc5568f..3f698af5f5ac 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -144,6 +144,7 @@ enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_ALLOW_VCCQX_LPM            = 1 << 5,
 	UFS_MTK_CAP_PMC_VIA_FASTAUTO           = 1 << 6,
 	UFS_MTK_CAP_TX_SKEW_FIX                = 1 << 7,
+	UFS_MTK_CAP_DISABLE_MCQ                = 1 << 8,
 };
 
 struct ufs_mtk_crypt_cfg {
-- 
2.18.0

