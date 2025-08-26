Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221762F6590
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2025 06:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756189415; cv=none; b=k8otR9VzEKGoJpOj8XzjBHqH3PCGPFoJx9Ds/GhIKuiWa5Lqx5NMFz+sSstYpwBaG+/XA0gmISFta0LU1zAqwCRILpUxxg2pHLkRoMHqp3GUD8NQV8gm3NuuVrgqLm7AAqStrFH8tQsr0tRD1PasZ8cdTC19ldqte7YV6JSBhZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756189415; c=relaxed/simple;
	bh=PfwLed/f4/CDK4LKLVvMWe9apNKsvCuPyDdyPG6ei1E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tz/V/rzfyEupRN3L6bel2nN4pW2C+Sc8+XMVwXq/rrA1WswYSUQAWdq4onGH6xXkphyKRshSk6it5104SfI25zJZFWgYdWJlrY9ocssxDxbgxeGYc6HhwNhkGjOrKVA/TjaFMP+XJAmsITDxxrPtTNFw9YavqMT0O3rd0JWRUhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dkKfcQUZ; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dkKfcQUZ"
X-UUID: 28a14046824511f0b2125946c7b33498-20250826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ijrT0jwd9zxSdfUaWVtis7trkc+f2nnBLIWNiEhbTHM=;
	b=dkKfcQUZ+1RyspQN2GkLpz2LvK1zNITaYnbYsOm7zt51fguxMk4sGvuyn/F8F2U5heOUA/z0NaYczbIjZgZ62iMvcjQXQ9Z3mGGoB+pjp/4BQijFQPQfhjKjaCtfCwFqbmtcdL8XiEsLUybHGyrSz4CAT80qf8HZhafXNXbzrjo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:f6727c44-04c9-4b3d-b8ed-79e5241330fb,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:365a8320-786d-4870-a017-e7b4f3839b3f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 28a14046824511f0b2125946c7b33498-20250826
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1922687517; Tue, 26 Aug 2025 14:23:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 26 Aug 2025 14:23:18 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 26 Aug 2025 14:23:18 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2 08/10] ufs: host: mediatek: Fix adapt issue after PA_Init
Date: Tue, 26 Aug 2025 14:22:22 +0800
Message-ID: <20250826062314.3070425-9-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250826062314.3070425-1-peter.wang@mediatek.com>
References: <20250826062314.3070425-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Alice Chao <alice.chao@mediatek.com>

This patch addresses the issue where the host does not send adapt
to the device after PA_Init success.
It ensures that the adapt process is correctly initiated for devices
with IP version MT6899 and above, resolving communication issues
between the host and device.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index a6f812713345..1342fe7d8e2b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1551,8 +1551,19 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
 
 	return ret;
 }
+
 static void ufs_mtk_post_link(struct ufs_hba *hba)
 {
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 tmp;
+
+	/* fix device PA_INIT no adapt */
+	if (host->ip_ver >= IP_VER_MT6899) {
+		ufshcd_dme_get(hba, UIC_ARG_MIB(VS_DEBUGOMC), &tmp);
+		tmp |= 0x100;
+		ufshcd_dme_set(hba, UIC_ARG_MIB(VS_DEBUGOMC), tmp);
+	}
+
 	/* enable unipro clock gating feature */
 	ufs_mtk_cfg_unipro_cg(hba, true);
 }
-- 
2.45.2

