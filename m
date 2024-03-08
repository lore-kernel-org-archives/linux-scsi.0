Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A16E2231A
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 07:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709881372; cv=none; b=gVXCK6mRTwvVoytSYJ83fUej1yLBsN0Wfe9nc1zJRqGL0AZ/BC/fJzdMCoQVb5ZNIHgiH3qaV5vN5H7n7ERkweTN+I22kqX1mObJSN6gnAaYVzE1y/Yn3z80AeQg5bevGO93HskvDEbONOxqx4qPH0La62eTJjAUcsX2Y6wy+Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709881372; c=relaxed/simple;
	bh=739p/jjNzNAeIE3gjiZiLY5Ai4I7GdQmCYEghLII8o8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oVLdUGdyfW87l/vOV8DbIgBPRt/7ygZRlG/t5/OTlq/AVnLtmK4vZrLTGn/82bcEKe9W6RiVHQZHINFZyBp17dhsQxcqi9yyDsN5DGCNHrgrIcrmB/KroCv1Oj6M5YfXMgOxLG9ekGYjJI0AvNp1+FMwmCv15/9BpMIVxZ2lPsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=jyMTQqI+; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jyMTQqI+"
X-UUID: dd5be9bedd1911eeb8927bc1f75efef4-20240308
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=K3+eVW7UrCWJd53pqwBxlu5CPji2yc0HfbLA/egCflE=;
	b=jyMTQqI+n4Yy149fXqRj0e0mqlwOan+d5toilng+4/TDi0g9V5mud/+HUzVgQv989anLCfKGT0c6WWeSiUbq/XqQYgK7O+x/SjyMrUKPxWyI2AKkvPAkrFP4bAxgLoOiP7R9QvY7ewNJ5VMG8VjY78hsXSYvZTsEJx+B6+Sozhk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:af7b3293-3d30-43dc-b164-76d8bb59d84f,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:b5bc2a90-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: dd5be9bedd1911eeb8927bc1f75efef4-20240308
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 521649016; Fri, 08 Mar 2024 15:02:45 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 8 Mar 2024 15:02:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 8 Mar 2024 15:02:44 +0800
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
Subject: [PATCH v1 7/7] ufs: host: mediatek: support rtff in PM flow
Date: Fri, 8 Mar 2024 15:02:41 +0800
Message-ID: <20240308070241.9163-8-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240308070241.9163-1-peter.wang@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--5.519200-8.000000
X-TMASE-MatchedRID: eim6YYjnci0MQLXc2MGSbGNW0DAjL5p+SjyMfjCRfaPfUZT83lbkEGTv
	8eaKHragprhPLBzR/tFbzVVgo9RtXgtgJ854eHwODko+EYiDQxFYN1akkye0qJfgq3BB/7AR8z7
	0XDTUjsambXJ3qljBkDAYnDoLfAffCYQihzr905ltPeYaZY+k1zJcsSAcBZLamyiLZetSf8mfop
	0ytGwvXiq2rl3dzGQ1IZo0/v96l/PMJZQUJ7rDtOCW8JlUvyoZO1uDNHVbXZYHpdn+EzNueA==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.519200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: AB0B564F26B92D1CEB7B71E4D26BA7F2A0AF3B56CCDB2F7C858938EF136668912000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

From: Alice Chao <alice.chao@mediatek.com>

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h |  4 ++++
 drivers/ufs/host/ufs-mediatek.c     | 35 +++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.h     |  2 ++
 3 files changed, 41 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
index 64f48ecc54c7..eeab0f93146e 100755
--- a/drivers/ufs/host/ufs-mediatek-sip.h
+++ b/drivers/ufs/host/ufs-mediatek-sip.h
@@ -20,6 +20,7 @@
 #define UFS_MTK_SIP_GET_VCC_NUM           BIT(6)
 #define UFS_MTK_SIP_DEVICE_PWR_CTRL       BIT(7)
 #define UFS_MTK_SIP_MPHY_CTRL             BIT(8)
+#define UFS_MTK_SIP_MTCMOS_CTRL           BIT(9)
 
 /*
  * Multi-VCC by Numbering
@@ -87,4 +88,7 @@ static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg s)
 #define ufs_mtk_mphy_ctrl(op, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_MPHY_CTRL, &(res), op)
 
+#define ufs_mtk_mtcmos_ctrl(op, res) \
+	ufs_mtk_smc(UFS_MTK_SIP_MTCMOS_CTRL, &(res), op)
+
 #endif /* !_UFS_MEDIATEK_SIP_H */
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c4aae031b694..2f191525c308 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -127,6 +127,13 @@ static bool ufs_mtk_is_tx_skew_fix(struct ufs_hba *hba)
 	return !!(host->caps & UFS_MTK_CAP_TX_SKEW_FIX);
 }
 
+static bool ufs_mtk_is_rtff_mtcmos(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	return !!(host->caps & UFS_MTK_CAP_RTFF_MTCMOS);
+}
+
 static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -653,6 +660,9 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-disable-mcq"))
 		host->caps |= UFS_MTK_CAP_DISABLE_MCQ;
 
+	if (of_property_read_bool(np, "mediatek,ufs-rtff-mtcmos"))
+		host->caps |= UFS_MTK_CAP_RTFF_MTCMOS;
+
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
@@ -993,6 +1003,15 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	 * Enable phy clocks specifically here.
 	 */
 	ufs_mtk_mphy_power_on(hba, true);
+
+	if (ufs_mtk_is_rtff_mtcmos(hba)) {
+		/* First Restore here, to avoid backup unexpected value */
+		ufs_mtk_mtcmos_ctrl(false, res);
+
+		/* Power on to init */
+		ufs_mtk_mtcmos_ctrl(true, res);
+	}
+
 	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
 
 	host->ip_ver = ufshcd_readl(hba, REG_UFS_MTK_IP_VER);
@@ -1823,6 +1842,7 @@ static void ufs_mtk_remove(struct platform_device *pdev)
 static int ufs_mtk_system_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct arm_smccc_res res;
 	int ret;
 
 	ret = ufshcd_system_suspend(dev);
@@ -1831,15 +1851,22 @@ static int ufs_mtk_system_suspend(struct device *dev)
 
 	ufs_mtk_dev_vreg_set_lpm(hba, true);
 
+	if (ufs_mtk_is_rtff_mtcmos(hba))
+		ufs_mtk_mtcmos_ctrl(false, res);
+
 	return 0;
 }
 
 static int ufs_mtk_system_resume(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct arm_smccc_res res;
 
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
+	if (ufs_mtk_is_rtff_mtcmos(hba))
+		ufs_mtk_mtcmos_ctrl(true, res);
+
 	return ufshcd_system_resume(dev);
 }
 #endif
@@ -1848,6 +1875,7 @@ static int ufs_mtk_system_resume(struct device *dev)
 static int ufs_mtk_runtime_suspend(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct arm_smccc_res res;
 	int ret = 0;
 
 	ret = ufshcd_runtime_suspend(dev);
@@ -1856,12 +1884,19 @@ static int ufs_mtk_runtime_suspend(struct device *dev)
 
 	ufs_mtk_dev_vreg_set_lpm(hba, true);
 
+	if (ufs_mtk_is_rtff_mtcmos(hba))
+		ufs_mtk_mtcmos_ctrl(false, res);
+
 	return 0;
 }
 
 static int ufs_mtk_runtime_resume(struct device *dev)
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	struct arm_smccc_res res;
+
+	if (ufs_mtk_is_rtff_mtcmos(hba))
+		ufs_mtk_mtcmos_ctrl(true, res);
 
 	ufs_mtk_dev_vreg_set_lpm(hba, false);
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 6129ab59e5f5..599fea66663b 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -131,6 +131,8 @@ enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_PMC_VIA_FASTAUTO           = 1 << 6,
 	UFS_MTK_CAP_TX_SKEW_FIX                = 1 << 7,
 	UFS_MTK_CAP_DISABLE_MCQ                = 1 << 8,
+	/* Control MTCMOS with RTFF */
+	UFS_MTK_CAP_RTFF_MTCMOS                = 1 << 9,
 };
 
 struct ufs_mtk_crypt_cfg {
-- 
2.18.0

