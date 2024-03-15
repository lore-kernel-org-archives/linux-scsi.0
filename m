Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7634817BA7
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710491705; cv=none; b=XfhHJSbpb/wTSwt0jdCx0HK2uuz3UB4xmkuuoCOsdFMU9FobiA+t7Jqh1jtpTmTgDZfynVURWYhbxROylRxHMGIEQT95q0LEYFgdWHbDlbzn8YEAeBEn2/L+K1cWOVHCLAGKtHBX2l64cqVowCigwrhR5qB5e5RArdi8Mknxkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710491705; c=relaxed/simple;
	bh=Z7eRhlmC8Ex4vQhSMSWNA5M/BKFDKl9KU/EyIAI4xAM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8T8B0BtnfT4WZLl6N3pZdS3qfaBzKsx0hagKzKAekpvhoOxC4lHOKx+UsDd11y+Pj43wgTZWurGbRM4ypTbILB/E/ZlieTBQyQN5ou8B7M+A4wyb0ZQ3gGG82s9cWLmqYlVo4FnJVRxyjXZhQhq0tvwRzKXKKTBhubQXs5hpDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Kt3dzgX1; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Kt3dzgX1"
X-UUID: e49c2cbae2a611eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ATX7DE3pf+GNEBqDAhFhJVT5DKLBcrGcVoJ0/mRV3gQ=;
	b=Kt3dzgX1TG+4Ny8HNgZIwKTeu9lvEIElIxvE6R0hj+ZHGK86IkcZb/ZVq0HnqwefbffJ7xYhzFLy6aLcGh/i1i/qWplbrlOXYvazRCj+O2nmU58vBpLZk2s4A1bXJ7tfqrxBI8uW5y/nAuXSX5hOx0fLyCr+LGAsLL8BmNzlBgc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:fac63976-2077-4787-9066-10ff22775b9a,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:56e68981-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e49c2cbae2a611eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2021348007; Fri, 15 Mar 2024 16:34:52 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
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
Subject: [PATCH v2 2/7] ufs: host: mediatek: tx skew fix
Date: Fri, 15 Mar 2024 16:34:43 +0800
Message-ID: <20240315083448.7185-3-peter.wang@mediatek.com>
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
X-TM-AS-Result: No-10--4.857300-8.000000
X-TMASE-MatchedRID: n/G9Jfep/EYMQLXc2MGSbIzb2GR6Ttd39Nx/wC/5BIDfc2Xd6VJ+yqE9
	PHeVbwLZeeTK1AUftLLijpjet3oGSJCoy9iDotiwjoyKzEmtrEdYN1akkye0qOkviQKjlVkeoBf
	JbWQaw4Pc3nKzIYoy4oAy6p60ZV62fJ5/bZ6npdjKayT/BQTiGtJaX40YooekqswO62qermAz8M
	fXufKgqBRTidULKtoa/IaBPoZPwlUXpWXAorqW3pG7NytUycyAZ30APAmfP3O0PdybCyoACq/XF
	oPK0hZ9dATQdtPksR+3/JiWOe6GXXSWgQ2GpXdZbxffl9hhCBw=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.857300-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: EC9D5EAE5EE4ED939A91AD8637D2DB819933FAB94736ED65F7E0D3C9A9A73D432000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Mediatek tx skew issue fix by check dts setting and vendor/model.
Then set PA_TACTIVATE set 8

Acked-by: Chun-Hung Wu <Chun-Hung.Wu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 21 +++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 147b5286ec98..25bf5a13cddd 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -119,6 +119,13 @@ static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
 	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
 }
 
+static bool ufs_mtk_is_tx_skew_fix(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	return (host->caps & UFS_MTK_CAP_TX_SKEW_FIX);
+}
+
 static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -630,6 +637,9 @@ static void ufs_mtk_init_host_caps(struct ufs_hba *hba)
 	if (of_property_read_bool(np, "mediatek,ufs-pmc-via-fastauto"))
 		host->caps |= UFS_MTK_CAP_PMC_VIA_FASTAUTO;
 
+	if (of_property_read_bool(np, "mediatek,ufs-tx-skew-fix"))
+		host->caps |= UFS_MTK_CAP_TX_SKEW_FIX;
+
 	dev_info(hba->dev, "caps: 0x%x", host->caps);
 }
 
@@ -1423,6 +1433,17 @@ static int ufs_mtk_apply_dev_quirks(struct ufs_hba *hba)
 	if (mid == UFS_VENDOR_SAMSUNG) {
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 6);
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HIBERN8TIME), 10);
+	} else if (mid == UFS_VENDOR_MICRON) {
+		/* Only for the host which have TX skew issue */
+		if (ufs_mtk_is_tx_skew_fix(hba) &&
+			(STR_PRFX_EQUAL("MT128GBCAV2U31", dev_info->model) ||
+			STR_PRFX_EQUAL("MT256GBCAV4U31", dev_info->model) ||
+			STR_PRFX_EQUAL("MT512GBCAV8U31", dev_info->model) ||
+			STR_PRFX_EQUAL("MT256GBEAX4U40", dev_info->model) ||
+			STR_PRFX_EQUAL("MT512GAYAX4U40", dev_info->model) ||
+			STR_PRFX_EQUAL("MT001TAYAX8U40", dev_info->model))) {
+			ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TACTIVATE), 8);
+		}
 	}
 
 	/*
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index d0a5ab17860a..c1acbfc5568f 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -143,6 +143,7 @@ enum ufs_mtk_host_caps {
 	 */
 	UFS_MTK_CAP_ALLOW_VCCQX_LPM            = 1 << 5,
 	UFS_MTK_CAP_PMC_VIA_FASTAUTO           = 1 << 6,
+	UFS_MTK_CAP_TX_SKEW_FIX                = 1 << 7,
 };
 
 struct ufs_mtk_crypt_cfg {
-- 
2.18.0

