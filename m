Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8501D2D3EDC
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918076; cv=none; b=pN6cb9IdZSottmWdVDxr10L3fVKnedeyj78msfOyNuAPXzqAici238l8gx+FZJWOdHIIttSFJ4R8eqvKqBYay2GBhyGM9zX4F6hz0Ta0QD8qGxawsN7igBN3rHMmiqtHUHBhVHaqJ6EODSle89DrqXKTNRMqNDbtYgiLCbWd21I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918076; c=relaxed/simple;
	bh=d9pUKIO/Fk88UQH3pY4VcgYFHSC2sWfDVRPH2YN6oBE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aK3WAzoIJt9fu0/YJ6TinxyrqsVbTgEAxbUzRfMbXM/ddQoPQCIDfhSCMJEK4HiqUidbaQNgk25mINVumSp1t6jW6GFE3deQE6ihigVCnxuN9UltZr7LX5pBTAibUQC7x/q/DMOiUc8aPK8KcLtJ/h3uFZkC2kE7Y725kKI8CcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=sy1OLdjq; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="sy1OLdjq"
X-UUID: 1ac2299076b511f0b33aeb1e7f16c2b6-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=UYVRL+Q54O3ikko3Y3stnHRSlb2QeuVLkh3yc1eQ9pw=;
	b=sy1OLdjq6VWOzL1dRd61+8mfs7Ra/ior7hD/VUdB2jfGdSngG+b/qKZu4I5w5TeBu5ww/Oy6n3qkEeQZ7SNAt0UOw4I6ZXeuAFqraYR79QDh/KzVFPr3zOY0YJmfv1lRnUlhRYx9cmve2JJgxK8i9jaKQcm0EyZL6OSh6J5w3hs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:4ac25091-8754-4228-ae2e-1fd858f73348,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:f3484951-d89a-4c27-9e37-f7ccfcbebd5b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ac2299076b511f0b33aeb1e7f16c2b6-20250811
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1023657906; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:25 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 04/10] ufs: host: mediatek: Fine-tune clock scaling
Date: Mon, 11 Aug 2025 21:11:20 +0800
Message-ID: <20250811131423.3444014-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250811131423.3444014-1-peter.wang@mediatek.com>
References: <20250811131423.3444014-1-peter.wang@mediatek.com>
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

This patch disables clock scaling for UFS versions below 4.0.
Clock scaling is unnecessary for these versions, and this
change ensures that the feature is only enabled for compatible
UFS versions.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3d50cd3a01b3..31fe8efa5778 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -29,6 +29,7 @@
 #include "ufs-mediatek-sip.h"
 
 static int  ufs_mtk_config_mcq(struct ufs_hba *hba, bool irq);
+static void _ufs_mtk_clk_scale(struct ufs_hba *hba, bool scale_up);
 
 #define CREATE_TRACE_POINTS
 #include "ufs-mediatek-trace.h"
@@ -1144,6 +1145,17 @@ static void ufs_mtk_fix_ahit(struct ufs_hba *hba)
 	ufs_mtk_setup_clk_gating(hba);
 }
 
+static void ufs_mtk_fix_clock_scaling(struct ufs_hba *hba)
+{
+	/* UFS version is below 4.0, clock scaling is not necessary */
+	if ((hba->dev_info.wspecversion < 0x0400)  &&
+		ufs_mtk_is_clk_scale_ready(hba)) {
+		hba->caps &= ~UFSHCD_CAP_CLK_SCALING;
+
+		_ufs_mtk_clk_scale(hba, false);
+	}
+}
+
 static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -1774,6 +1786,7 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 	ufs_mtk_vreg_fix_vcc(hba);
 	ufs_mtk_vreg_fix_vccqx(hba);
 	ufs_mtk_fix_ahit(hba);
+	ufs_mtk_fix_clock_scaling(hba);
 }
 
 static void ufs_mtk_event_notify(struct ufs_hba *hba,
-- 
2.45.2

