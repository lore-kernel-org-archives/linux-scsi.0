Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC884F21F
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 07:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709881377; cv=none; b=aoVcXkbRyVYJKJ5/vbdI7EuVkVreDzngzZjvBRoOnIMOTTO+7WJTQ91MQX9D3PAK1QaME6ax6+wG4NWuXP0yyj8FMiK0WJCPPy1oyKIGgfcCNUAIkN1nxa45BhMWKEOH+6HTrVItjXXSACBY7TK/5/HIGErgkTgAQB86ootf1tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709881377; c=relaxed/simple;
	bh=5D9DjjXkfdaaj2rNclylkxCCHxViLQsOHbDgvgQCcPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=peredl+C75i640PXThT/XgvMPavhfgDvKzqN+GilCiuElRhtnG7Ldc/EH1I85INVHTuo75OH3NPoWC/s9N1+/NPB/46J7fqzhit9FFAoBbXzgmFDefM83PHGpzYY9oiNa0N3gEb1Mu2X38vv/70+IFOE0fJ4stssfzz+/+8HrX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=urw0WApy; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="urw0WApy"
X-UUID: dd1956a8dd1911ee935d6952f98a51a9-20240308
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=gRvFJTE87XolmTA17FRPsWDtMyq5k7pFzOf1KSJh+sQ=;
	b=urw0WApytIkNGtBgHhZwf4c5yG7kLJC0U0NY38L0RAI1RT2l0cELsBPZt55wzLFZ8Bwz3hOR63tUecrHg/5TKB6k8RIsgZI1lmfRjUb1GoEuw8T8WJgDu+LHIUkcv2Fm6PMY/wEKclSQIdtMhTimG3STGAORJQO2SfWvSUOMN/w=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:d3ff6e26-e627-4f53-81be-4cc9391e4f9f,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:6beec384-8d4f-477b-89d2-1e3bdbef96d1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: dd1956a8dd1911ee935d6952f98a51a9-20240308
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1220995791; Fri, 08 Mar 2024 15:02:44 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 8 Mar 2024 15:02:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 8 Mar 2024 15:02:43 +0800
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
Subject: [PATCH v1 2/7] ufs: host: mediatek: tx skew fix
Date: Fri, 8 Mar 2024 15:02:36 +0800
Message-ID: <20240308070241.9163-3-peter.wang@mediatek.com>
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
X-TM-AS-Result: No-10--5.311800-8.000000
X-TMASE-MatchedRID: lR9wedxBitsMQLXc2MGSbIzb2GR6Ttd39Nx/wC/5BIDfc2Xd6VJ+ytoz
	beODnXpl09NQNrxIpFYBtjkcfRMmqe+c5IL6OTgO4RtSDjG+z7DKi5Jqc8KFNBqhK4nm9OcKNkf
	UjJS6Xszi8zVgXoAltsIJ+4gwXrEtIAcCikR3vq/ml/GwKJX8pke8pSYa1RYLU4AcjuzCka1q49
	6rsm52bOKtWn1dFJSx
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.311800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 333B9FAA4FAD749E22D88A49E36412FBFDE5C817EA0E25F6C0475BC3A60BA9582000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Mediatek tx skew issue fix by check dts setting and vendor/model.
Then set PA_TACTIVATE set 8

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 21 +++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 6fc6fa2ea5bd..0262e8994236 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -119,6 +119,13 @@ static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
 	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
 }
 
+static bool ufs_mtk_is_tx_skew_fix(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	return !!(host->caps & UFS_MTK_CAP_TX_SKEW_FIX);
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
index 0720da2f1402..146c25080599 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -142,6 +142,7 @@ enum ufs_mtk_host_caps {
 	 */
 	UFS_MTK_CAP_ALLOW_VCCQX_LPM            = 1 << 5,
 	UFS_MTK_CAP_PMC_VIA_FASTAUTO           = 1 << 6,
+	UFS_MTK_CAP_TX_SKEW_FIX                = 1 << 7,
 };
 
 struct ufs_mtk_crypt_cfg {
-- 
2.18.0

