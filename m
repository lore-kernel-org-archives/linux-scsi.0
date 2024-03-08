Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E0C84F1E1
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 07:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709881376; cv=none; b=Nm/55SLORU3kJ8soTb7OqUYHC3QN4RYP/YTqQhTSvjt5DBPkimBDYONQLCAsUWZEhYAhhpj3XjKE2nCz7mB5Ljjb9Rk3EfdfOD0x2qDlJcOhX2cV+X1qRXT4kA2MIC/Mq3izOXp7OpGIzPxzLyy8AzROhgPe46Y3261fTuVKbGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709881376; c=relaxed/simple;
	bh=ZpC8VgPf1AshNA9eMfz/4uyRsZ5OSvD7Rl6m0l8JCFE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ybf+/LApWf60AGVIdhexlub7e89yYNas1dwxm+v1DtZFUIOoSXQApEat3Ag1WeTHDD4vImsJx6btkVvrjYZBEcEbwoxmVI1exhrTaN8lZoGvqEuy8LO1DvDkx+d05M0KqPorP53sopgoGCW46TyXuJrSFNtY5kyHwcGMMpuVkR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=T/9HGnRF; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="T/9HGnRF"
X-UUID: deb0bbf0dd1911ee935d6952f98a51a9-20240308
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=N778AJpRMgve8cWD/XrKvFFXVXW0C9lfolM4GaK/MX8=;
	b=T/9HGnRFhXHVhIiQRnHCGQkMlM4nl4PhvKYTUeUJM8cZXyJ1CsLui7CMbBKI7lTbZFZ49Qf3aElefOYL2QVjRO3feSjYHHS9AT+6PD6ymqgKYvxgghKgtr+/0Lq8wsd/mbeEI504s8LGo1M4W0LxItBxoGPJBPSMJBf0SGe6WK8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:cfceccac-2a48-4749-b8da-5637056b001c,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:68a84381-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: deb0bbf0dd1911ee935d6952f98a51a9-20240308
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1540100591; Fri, 08 Mar 2024 15:02:47 +0800
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
Subject: [PATCH v1 6/7] ufs: host: mediatek: support mphy reset
Date: Fri, 8 Mar 2024 15:02:40 +0800
Message-ID: <20240308070241.9163-7-peter.wang@mediatek.com>
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
X-TM-AS-Result: No-10--3.972300-8.000000
X-TMASE-MatchedRID: n/G9Jfep/EYMQLXc2MGSbHTnOygHVQpOKx5ICGp/WtE1LB46LFAAklO4
	BD7nLMxnlTJXKqh1ne0FNz4MVU+iBPDZOKmFLlvIVU3yVpaj3Qz0O7M3lSnTWxqB+wKK9uZeQmZ
	9+1UBYL38s+61e4dE7OM+w5me8ld4HxPMjOKY7A8LbigRnpKlKZx+7GyJjhAU6u76WgiZPDHnj2
	S4Kzfr7xOslDYg/c8V/LdKyN68cgGJNS65aPKWYGRgKB1mKomnyr4tqBPPwhgAhj6bO2eSuLmOX
	U+S9eQVSZrfNhP3sgUBh9AgBSEFrJm+YJspVvj2xkvrHlT8euI+kK598Yf3Mg==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.972300-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 95417DEAAD097AF72C600FC3E193712D468A8B8A415A8C72E32EAE204B3EC4372000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This patch will reset mphy when host reset.
Backup mphy setting after mphy reset control get.
Restore mphy setting after mphy reset.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h |  9 ++++++++-
 drivers/ufs/host/ufs-mediatek.c     | 14 ++++++++++++++
 drivers/ufs/host/ufs-mediatek.h     |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
index fd640846910a..64f48ecc54c7 100755
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
index 2caf0c1d4e17..c4aae031b694 100644
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
index 17be3f748fa0..6129ab59e5f5 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -166,6 +166,7 @@ struct ufs_mtk_host {
 	struct reset_control *hci_reset;
 	struct reset_control *unipro_reset;
 	struct reset_control *crypto_reset;
+	struct reset_control *mphy_reset;
 	struct ufs_hba *hba;
 	struct ufs_mtk_crypt_cfg *crypt;
 	struct ufs_mtk_clk mclk;
-- 
2.18.0

