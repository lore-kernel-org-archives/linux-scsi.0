Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669EA288C21
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 06:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752647329; cv=none; b=r4ly6lkStikIv+kitIyC7QuQi4q0/x5h1HdOpK1NmOefkJ71emKP+cmnQEboWvxcG2gQpDIuXl/8zT0Kp9Ky7tZTZFHkvunt8NjHc/UMYrNATY6ooREjKu/EFp2Y+R8WYs1aiaLU1P0Aa8Vs1gR7zTG9xOxj/h8wADlmThXoF/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752647329; c=relaxed/simple;
	bh=5Cg1qnGSsS4YRdfU5HrpBwuis9E8SugsyhRSXRmfxlA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y0FnPiBQRX+5avdaTIWTNCGJVxB+tPDTgXQEhCyt6qLRpXXzPXT1aABgdTZOVycufjxZpq8CQRKZnUEIxxmZigym0HRCu2+Uj0qMSVBrlCG+znkimP2LjnWc3P3rn4ltHr7JrcSro2ok8qygj6iRU7CsASlsbYOiKpejbmI5bq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rDwgPRmN; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rDwgPRmN"
X-UUID: 189aaffe620e11f08b7dc59d57013e23-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=/6opa5VHoi/8dBhUbwTxbnzr9aM//a3CTpfIYwAArHU=;
	b=rDwgPRmNfjQ7kr7ez9w0bBCtC/PrJ9v10n78bUaPystKByr50q/OCIsAsjr1jZIKmNM0V6VNQ8Gm6+QJh9CrRlPT1NxRE05/2rx7B19VVCW3Y7tIxNZgiX1iTPGif73xaXRFgDdjPH0UeNKC5+ybq6m8E8DF3QqevV68kijncXc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:846b1c83-4636-436e-b275-105adee5cd2a,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:6a40fabc-a91d-4696-b3f4-d8815e4c200b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 189aaffe620e11f08b7dc59d57013e23-20250716
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1371244325; Wed, 16 Jul 2025 14:28:33 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 16 Jul 2025 14:28:31 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 16 Jul 2025 14:28:31 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v1 02/10] ufs: host: mediatek: Add DDR_EN setting
Date: Wed, 16 Jul 2025 14:25:27 +0800
Message-ID: <20250716062830.3712487-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250716062830.3712487-1-peter.wang@mediatek.com>
References: <20250716062830.3712487-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Naomi Chu <naomi.chu@mediatek.com>

On MT6989 and later platforms, control of DDR_EN has been switched from
SPM to EMI. To prevent abnormal access to DRAM, it is necessary to wait
for 'ddren_ack' or assert 'ddren_urgent' after sending 'ddren_req'.

This patch introduces the DDR_EN configuration in the UFS initialization
flow, utilizing the assertion of 'ddren_urgent' to maintain performance.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Naomi Chu <naomi.chu@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c |  7 +++++++
 drivers/ufs/host/ufs-mediatek.h | 12 ++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index e56763e6c650..3b3c3a1b2c42 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -267,6 +267,13 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
 		ufshcd_writel(hba,
 			      ufshcd_readl(hba, REG_UFS_XOUFS_CTRL) | 0x80,
 			      REG_UFS_XOUFS_CTRL);
+
+		/* DDR_EN setting */
+		if (host->ip_ver >= IP_VER_MT6989) {
+			ufshcd_rmwl(hba, UFS_MASK(0x7FFF, 8),
+				0x453000, REG_UFS_MMIO_OPT_CTRL_0);
+		}
+
 	}
 
 	return 0;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 05d76a6bd772..e854801a00e8 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -192,4 +192,16 @@ struct ufs_mtk_host {
 /* MTK RTT support number */
 #define MTK_MAX_NUM_RTT 2
 
+/* UFS MTK ip version value */
+enum {
+	/* UFS 3.1 */
+	IP_VER_MT6878    = 0x10420200,
+
+	/* UFS 4.0 */
+	IP_VER_MT6897    = 0x10440000,
+	IP_VER_MT6989    = 0x10450000,
+
+	IP_VER_NONE      = 0xFFFFFFFF
+};
+
 #endif /* !_UFS_MEDIATEK_H */
-- 
2.45.2

