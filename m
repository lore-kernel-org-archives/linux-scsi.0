Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44B517BB9
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710491705; cv=none; b=lnFK6aQdD2dlZPgNQm8xMYat/B0cvfym/vCIjEJq0otMHNe2oD4lxWKktaDKRghauVDsbW4V6fRvEzHtGAypt/Fz+Y8X0B7X+G2RrqFekRJ5d7jQoIiuoHtT2FCRp6V0vVICOZ4jeqEulvu0ebmJ/3YA6pCc2bsgzi8LQWwjTvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710491705; c=relaxed/simple;
	bh=5vUwtcbFHl3j5evxTY6HAgAUfr0td4h4NOOpHnXFDrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k8ykFQfvOTIiqtFlDkUDRAYmXp9Om9aJKPWPBqJ5E+/SNE0cqZnRY2TJUJVu6VyppObILTljAG3WEKqg3mHN1PvxyWO7nXREinSOI5YscpMNkULO6PmmYPqK+BjLDRboQRh62XQ08Co/EiMNWYQ13fc7XaEMRCRQHYZJeQag8o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=BQwlOg/v; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="BQwlOg/v"
X-UUID: e4b27a88e2a611eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=oeAzBoL9EBJWz2qwI3onG0bmYDXNeq0oJ9wAQA83NiU=;
	b=BQwlOg/vzUrx94EIV+M8Xy3K9V0Zz/NZ1+oKlxHL/7FFGAosTB1tESfH4e/eaUnQMtWDZpt2jN3cRIMRofmoofxFnKPEqe5WtzjkPqWJ52iNSnhjmjWWLjoggKcoIosQUJWMBewI9bNC+HpsAc31dYM5MxFlW27i1c8Zic6FsLc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:b4a80c6a-15eb-408b-bf7a-f66d39ef2104,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:11047190-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e4b27a88e2a611eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1913406672; Fri, 15 Mar 2024 16:34:52 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 16:34:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 16:34:51 +0800
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
Subject: [PATCH v2 6/7] ufs: host: mediatek: support mphy reset
Date: Fri, 15 Mar 2024 16:34:47 +0800
Message-ID: <20240315083448.7185-7-peter.wang@mediatek.com>
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
X-TM-AS-Result: No-10--3.982300-8.000000
X-TMASE-MatchedRID: pO+4S45NqGgMQLXc2MGSbHTnOygHVQpOKx5ICGp/WtE1LB46LFAAklO4
	BD7nLMxnlTJXKqh1ne0FNz4MVU+iBPDZOKmFLlvIVU3yVpaj3Qz0O7M3lSnTWxqB+wKK9uZeQmZ
	9+1UBYL38s+61e4dE7OM+w5me8ld4HxPMjOKY7A81yT2WGspnOMRB0bsfrpPI34T9cYMsdwyovi
	qi0Ulcpy5jTX93RJHTezxWo31ggUESo09hC/CfsnPSd/w3TEtqlekI0xnK/LEfJy08VBayAmYo2
	UxAR0dC/jgY96F76fmOh+wyNBrFXDJiNuKohDcKzKSG3JdyKAPqtV2AGMNPaiHWPYzouJUy
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.982300-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 868B550B241EF93FD85E393556C72F669E959B90092E606A820678E1BB2C1F762000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This patch will reset mphy when host reset.
Backup mphy setting after mphy reset control get.
Restore mphy setting after mphy reset.

Acked-by: Chun-Hung Wu <Chun-Hung.Wu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h |  9 ++++++++-
 drivers/ufs/host/ufs-mediatek.c     | 14 ++++++++++++++
 drivers/ufs/host/ufs-mediatek.h     |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
index c26513aedee3..caeb70a6ae83 100755
--- a/drivers/ufs/host/ufs-mediatek-sip.h
+++ b/drivers/ufs/host/ufs-mediatek-sip.h
@@ -19,7 +19,7 @@
 #define UFS_MTK_SIP_SRAM_PWR_CTRL         BIT(5)
 #define UFS_MTK_SIP_GET_VCC_NUM           BIT(6)
 #define UFS_MTK_SIP_DEVICE_PWR_CTRL       BIT(7)
-
+#define UFS_MTK_SIP_MPHY_CTRL             BIT(8)
 
 /*
  * Multi-VCC by Numbering
@@ -31,6 +31,10 @@ enum ufs_mtk_vcc_num {
 	UFS_VCC_MAX
 };
 
+enum ufs_mtk_mphy_op {
+	UFS_MPHY_BACKUP = 0,
+	UFS_MPHY_RESTORE
+};
 
 /*
  * SMC call wrapper function
@@ -80,4 +84,7 @@ static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg s)
 #define ufs_mtk_device_pwr_ctrl(on, ufs_version, res) \
 	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_PWR_CTRL, &(res), on, ufs_version)
 
+#define ufs_mtk_mphy_ctrl(op, res) \
+	ufs_mtk_smc(UFS_MTK_SIP_MPHY_CTRL, &(res), op)
+
 #endif /* !_UFS_MEDIATEK_SIP_H */
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 90523652a6fb..a18978060c77 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -185,16 +185,23 @@ static void ufs_mtk_crypto_enable(struct ufs_hba *hba)
 static void ufs_mtk_host_reset(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	struct arm_smccc_res res;
 
 	reset_control_assert(host->hci_reset);
 	reset_control_assert(host->crypto_reset);
 	reset_control_assert(host->unipro_reset);
+	reset_control_assert(host->mphy_reset);
 
 	usleep_range(100, 110);
 
 	reset_control_deassert(host->unipro_reset);
 	reset_control_deassert(host->crypto_reset);
 	reset_control_deassert(host->hci_reset);
+	reset_control_deassert(host->mphy_reset);
+
+	/* restore mphy setting aftre mphy reset */
+	if (host->mphy_reset)
+		ufs_mtk_mphy_ctrl(UFS_MPHY_RESTORE, res);
 }
 
 static void ufs_mtk_init_reset_control(struct ufs_hba *hba,
@@ -219,6 +226,8 @@ static void ufs_mtk_init_reset(struct ufs_hba *hba)
 				   "unipro_rst");
 	ufs_mtk_init_reset_control(hba, &host->crypto_reset,
 				   "crypto_rst");
+	ufs_mtk_init_reset_control(hba, &host->mphy_reset,
+				   "mphy_rst");
 }
 
 static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
@@ -918,6 +927,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	struct device *dev = hba->dev;
 	struct ufs_mtk_host *host;
 	int err = 0;
+	struct arm_smccc_res res;
 
 	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
 	if (!host) {
@@ -946,6 +956,10 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_init_reset(hba);
 
+	/* backup mphy setting if mphy can reset */
+	if (host->mphy_reset)
+		ufs_mtk_mphy_ctrl(UFS_MPHY_BACKUP, res);
+
 	/* Enable runtime autosuspend */
 	hba->caps |= UFSHCD_CAP_RPM_AUTOSUSPEND;
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 9226e95c4a60..eb3744ae3a42 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -167,6 +167,7 @@ struct ufs_mtk_host {
 	struct reset_control *hci_reset;
 	struct reset_control *unipro_reset;
 	struct reset_control *crypto_reset;
+	struct reset_control *mphy_reset;
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;
 	struct ufs_mtk_clk mclk;
-- 
2.18.0

