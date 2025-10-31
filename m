Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CFD27A12C
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 11:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761911646; cv=none; b=tKibNtEoTVe/lbE07/SZ3s9Pn+X1Tgc3FbvgDY7BQ3ah9Kxz+wCv/HpfUVnn+x8ex6TkUSuBKpuod9TWPfSo7R0teDVczKfjVDDQ579uANAeI1BVoQ8eB+NFUZN9M69LpzlICphqtOlDoX+JisARnKuQJCOXbo6B137cjjy5AzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761911646; c=relaxed/simple;
	bh=dEdFRorPDdl8Vg7yPc6DDms5IWc/bhE3C6eUCvz3Gls=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FQALpKddtXE3qlUOHZHXj5e1+3SLQKnjdO6zIr042pZb/wgUNa9YusZLZsm+Ryly/9vKaThsINBdDaBgmmgiB3Z0OU4ZGvSDaLq5nuOYMJF+gpkHAdSNY5A5tnX2zqXmUFrCNyTUKM49i/SKz/0c34ZOfJXHNN2ZSzlZS7SqmAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=L3aME/MA; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="L3aME/MA"
X-UUID: 4931396cb65011f0b33aeb1e7f16c2b6-20251031
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=vOpMHC61iHHRdCiiGDnlcSBan7YOvNFY9u/O4lacD04=;
	b=L3aME/MAMboYfBBeOQwcGmMf3ESDjjGC/ybXIgoTcHmzN1BDo3eTCgEw2vVjZc/b2hZ/PT8x4Gfk1573z4QaktijV3LQ3lQHQp4pljdoDB6wXU1bBcBeyOT8qxZGyzrK+BF31+5hXU2V6FaxIgR2PAsMMlUsk3PRjP6C1ZX5HKg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:2d484963-84b6-41ac-9019-c8009572b281,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:12b87826-cfd6-4a1d-a1a8-72ac3fdb69c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
	0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4931396cb65011f0b33aeb1e7f16c2b6-20251031
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 460896439; Fri, 31 Oct 2025 19:53:59 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 31 Oct 2025 19:53:57 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.26 via Frontend Transport; Fri, 31 Oct 2025 19:53:57 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <jejb@linux.ibm.com>,
	<martin.petersen@oracle.com>, <alim.akhtar@samsung.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>, <chaotian.jing@mediatek.com>
CC: <matthias.bgg@gmail.com>, <angelogioacchino.delregno@collabora.com>,
	<chu.stanley@gmail.com>, <chun-hung.wu@mediatek.com>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v1] ufs: mediatek: Add the maintainer for MediaTek UFS hooks
Date: Fri, 31 Oct 2025 19:53:16 +0800
Message-ID: <20251031115356.1501765-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

Add Chaotian Jing as the maintainer of the MediaTek UFS hooks.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3da2c26a796b..6e5e204f1e09 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26381,6 +26381,7 @@ F:	drivers/ufs/host/ufs-exynos*
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER MEDIATEK HOOKS
 M:	Peter Wang <peter.wang@mediatek.com>
+M:	Chaotian Jing <chaotian.jing@mediatek.com>
 R:	Stanley Jhu <chu.stanley@gmail.com>
 L:	linux-scsi@vger.kernel.org
 L:	linux-mediatek@lists.infradead.org (moderated for non-subscribers)
-- 
2.45.2

