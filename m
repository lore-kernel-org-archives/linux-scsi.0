Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12215179A8
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710491705; cv=none; b=kkWQPajlErbgHjHeNpaz/CpFlv235gU/GtpYv6IhnUres3Ia5JLXC7LciGJzARVmd2aMnchIv5Lg1uLBC4VsCXL/ZLZnmwXzlR71ldO0TjUv5mbCaxCeTCqPaDuiDtRWl4OSg9c6eWhWnhFImE0oAVpgcjA3q2Xic1x63PPO5LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710491705; c=relaxed/simple;
	bh=5b5pdNy8RboDob+2xYXJSL5hsyaJESCngdwPzuLLT6U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyjeBxsxA2iliUoBkHZjoADUxk9LFlgsnFSUqZip+eCbPZYpKhrvjtFlxXeZHm8NUF3XsmebDyX2nh/KvsAm5TKnLY4mcTyFnq9dtAWb2v0C7Dz4+y8FzaPmpBbHAtmI5rUBzGxzG89b7PlQp8KhWhBs0V27ndUbtkzm+nGMtCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Cg2Yya2k; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Cg2Yya2k"
X-UUID: e49ad5fee2a611eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=kIq4WDamNAejLOlLbfTnowDxoUNzQaKvxhfTroNW3B4=;
	b=Cg2Yya2kgBcLzFaYWHlupA0NxLaMN9lkAr3de2qDy3yxpwAbRQOG/sZh1O6nB02dFYRQO2R8viLQA3TiZrgu6a7sWXmQ7btUiIbN0E279Jx4uxfKJk9L/9gsUhbo0pz/AZKKDstHn9WIzAsSrD4EiOQDxMUv/HYGkb/7mlBUKmI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:49d4db54-3dcf-4ba9-a5ce-0e76473e0f64,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:07d0eeff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: e49ad5fee2a611eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1515022597; Fri, 15 Mar 2024 16:34:52 +0800
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
Subject: [PATCH v2 1/7] ufs: host: mediatek: fix vsx/vccqx control logic
Date: Fri, 15 Mar 2024 16:34:42 +0800
Message-ID: <20240315083448.7185-2-peter.wang@mediatek.com>
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
X-TM-AS-Result: No-10--6.435800-8.000000
X-TMASE-MatchedRID: pO+4S45NqGgMQLXc2MGSbO7KTDtx8CgguftX4oH7dy7I9EDAP/dptnzK
	3Q9zSFL709NQNrxIpFYBtjkcfRMmqe3NIrNSYNRX4RtSDjG+z7DoatYL/ATKmL/A+0D1to6P9Gb
	SSaq0f4MRsHN+CG+OBlY5wOHo2QlHj2hRzH1UwuAURSScn+QSXt0H8LFZNFG73Yq8RVaZivVXBl
	d66gU5uBkSdfES7f3hGCZJhkKb/b/kxfO2+4tQJnvTu24Jt2HH
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.435800-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: B88309B41904768C1A60F4D39D39C4D5043DE9CE936F6FE1B5441FA846FEB74E2000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

VSX(the upper layer of VCCQ/VCCQ2) should
1. Always set to hpm mode if ufs device is active.
2. Enter lpm mode only if ufs device is not active.

VCCQX should
1. Keep hpm mode if vccq and vccq2 not set in dts.
2. Keep hpm mode if vcc not set in dts keep vcc always on.
3. Keep hpm if broken vcc keep vcc always on and not allow vccq lpm.
4. Except upper case, can enter lpm mode if ufs device is not active.

Acked-by: Chun-Hung Wu <Chun-Hung.Wu@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 41 +++++++++++++++++++++++----------
 drivers/ufs/host/ufs-mediatek.h |  6 +++++
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 776bca4f70c8..147b5286ec98 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -119,6 +119,13 @@ static bool ufs_mtk_is_pmc_via_fastauto(struct ufs_hba *hba)
 	return !!(host->caps & UFS_MTK_CAP_PMC_VIA_FASTAUTO);
 }
 
+static bool ufs_mtk_is_allow_vccqx_lpm(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+
+	return (host->caps & UFS_MTK_CAP_ALLOW_VCCQX_LPM);
+}
+
 static void ufs_mtk_cfg_unipro_cg(struct ufs_hba *hba, bool enable)
 {
 	u32 tmp;
@@ -1271,27 +1278,37 @@ static void ufs_mtk_vsx_set_lpm(struct ufs_hba *hba, bool lpm)
 
 static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 {
-	if (!hba->vreg_info.vccq && !hba->vreg_info.vccq2)
-		return;
+	bool skip_vccqx = false;
 
-	/* Skip if VCC is assumed always-on */
-	if (!hba->vreg_info.vcc)
-		return;
-
-	/* Bypass LPM when device is still active */
+	/* Prevent entering LPM when device is still active */
 	if (lpm && ufshcd_is_ufs_dev_active(hba))
 		return;
 
-	/* Bypass LPM if VCC is enabled */
-	if (lpm && hba->vreg_info.vcc->enabled)
-		return;
+	/* Skip vccqx lpm control and control vsx only */
+	if (!hba->vreg_info.vccq && !hba->vreg_info.vccq2)
+		skip_vccqx = true;
+
+	/* VCC is always-on, control vsx only */
+	if (!hba->vreg_info.vcc)
+		skip_vccqx = true;
+
+	/* Broken vcc keep vcc always on, most case control vsx only */
+	if (lpm && hba->vreg_info.vcc && hba->vreg_info.vcc->enabled) {
+		/* Some device vccqx/vsx can enter lpm */
+		if (ufs_mtk_is_allow_vccqx_lpm(hba))
+			skip_vccqx = false;
+		else /* control vsx only */
+			skip_vccqx = true;
+	}
 
 	if (lpm) {
-		ufs_mtk_vccqx_set_lpm(hba, lpm);
+		if (!skip_vccqx)
+			ufs_mtk_vccqx_set_lpm(hba, lpm);
 		ufs_mtk_vsx_set_lpm(hba, lpm);
 	} else {
 		ufs_mtk_vsx_set_lpm(hba, lpm);
-		ufs_mtk_vccqx_set_lpm(hba, lpm);
+		if (!skip_vccqx)
+			ufs_mtk_vccqx_set_lpm(hba, lpm);
 	}
 }
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index f76e80d91729..d0a5ab17860a 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -136,6 +136,12 @@ enum ufs_mtk_host_caps {
 	UFS_MTK_CAP_VA09_PWR_CTRL              = 1 << 1,
 	UFS_MTK_CAP_DISABLE_AH8                = 1 << 2,
 	UFS_MTK_CAP_BROKEN_VCC                 = 1 << 3,
+
+	/*
+	 * Override UFS_MTK_CAP_BROKEN_VCC's behavior to
+	 * allow vccqx upstream to enter LPM
+	 */
+	UFS_MTK_CAP_ALLOW_VCCQX_LPM            = 1 << 5,
 	UFS_MTK_CAP_PMC_VIA_FASTAUTO           = 1 << 6,
 };
 
-- 
2.18.0

