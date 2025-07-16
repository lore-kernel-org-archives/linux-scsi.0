Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6560F287519
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 06:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752647327; cv=none; b=SsCj1xcu68gums9cHCAK7M5HrNu2ZXvd+IP4/Ck1w9g0ocOxzOdqd02ergFUhN7AUrz+kAGc7MzrCdrQNoMvZBAsOdKnbK2Cd1qGbOjt+qj1D1VLzO7IzJXNDeAnCX/ShrLd1VY1awUgZcLQ9RPRNtgEFsA7OR5PUGcJLVgWVfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752647327; c=relaxed/simple;
	bh=paVU4Itn7U7Ddnzcy4AGAfLDcAiafP2vRcpXZAbQ4FU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rbTrVElatOrs6v9GHm43L6NrhUJkgeZ+DIfQ9Y4LqcVFBSEXQwM863+qVpHubc54Xi6xOHDi08mJFBJjlZpAe2+rCaLr8dufaSZbEe4LeKfeSxBVqQ/q3lQLSj3rTFMyWt3PUzrBiuD+h2LJXcpWwJlF92UQWx1/7zvlG8S3bmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=WQWj4Pz0; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="WQWj4Pz0"
X-UUID: 189e4f06620e11f08b7dc59d57013e23-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=2k3yhHuCowWQeEwHsnZ12PUlGHVmtVZaGWsU/gHaeNI=;
	b=WQWj4Pz0jhG1+jLx0WddKTiDcg0rh/5NZDuAzuJ/H9kOH+235ZgvYuJaz3lpDVBTm1w/9nVpPqywd9Sy2eFDsevagR7jTc5ugsMUxk8/Pxd7lKbx6sAy4O012+3b1oGmKzNCMPW02kEKEZsmnCqa6fYe9iv8zYw/u1H5bl4sJSc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:6a483ea8-1840-4f10-99ad-4f4ce0559a10,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:6840fabc-a91d-4696-b3f4-d8815e4c200b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 189e4f06620e11f08b7dc59d57013e23-20250716
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1466595189; Wed, 16 Jul 2025 14:28:33 +0800
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
Subject: [PATCH v1 03/10] ufs: host: mediatek: Add memory barrier for ref-clk control
Date: Wed, 16 Jul 2025 14:25:28 +0800
Message-ID: <20250716062830.3712487-4-peter.wang@mediatek.com>
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

From: Peter Wang <peter.wang@mediatek.com>

This patch adds a memory barrier to ensure that the ref-clk on/off control
register is fully written before it is read. This change is necessary to
maintain proper synchronization and prevent potential issues with register
access.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3b3c3a1b2c42..1e5cc88127b4 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -336,6 +336,12 @@ static int ufs_mtk_setup_ref_clk(struct ufs_hba *hba, bool on)
 		ufshcd_writel(hba, REFCLK_RELEASE, REG_UFS_REFCLK_CTRL);
 	}
 
+	/*
+	 * Make sure that ref-clk on/off control register
+	 * is writed done before read it.
+	 */
+	mb();
+
 	/* Wait for ack */
 	timeout = ktime_add_us(ktime_get(), REFCLK_REQ_TIMEOUT_US);
 	do {
-- 
2.45.2

