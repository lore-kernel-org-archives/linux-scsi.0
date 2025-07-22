Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBB328B7E7
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153729; cv=none; b=omGl961nJ+N9gupLQyd+3Td7C5bUmxqdo1ZtK1ccLdix7TDnaulIlEbkkdlx/OEMhPkhuny53GtVBp/pnvKMcuqDU/iaMvAjXrhiRrnIpqJL7EjJdMJpPOGn/w42cGVNXg2W+UAIaPNZd5LC1/L3kIj/kptje9ac2420w0ilO2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153729; c=relaxed/simple;
	bh=7hceeehtu73p5Nq3VCXv/cATIE8wXlTpXHADdDz3jdk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EnQWdyL8B3+ql4K0EGQUBtddHvUlxAdN6MmtY0bbXdUHZDSDd/czioRjZmyTUHhiW+RDSvrz+kv4pvO/0tpEld8URTE6s7vq90aJM1Pi8OUUFlxxSDob5wUO6rYtVkTm7cVMqK6OkCHDrBdNk0zxJZumS7aLxZEnCsVW4/6mgH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=RQ8eYkhu; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RQ8eYkhu"
X-UUID: 2d358d0e66a911f08b7dc59d57013e23-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=jpp0D6ahLCY9ZcROn41fc2M+etc1qjW0yfnCgAab/W4=;
	b=RQ8eYkhuIqQgl8BLIWWZT3zLU0J2rZmuynyqlh8d8vvQ2wWDlG3ziNfOnFHvSEPnbmqFmy0qFmDRgUbwTqg70AvU/XujLImflz77H9JLxf1WT8vldnGp0aLwOylC5UZT8ew9JnWspLoQ3NL/7ZAZVqez4Yn3q3d6YoInpH4pKJ4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:dda01152-ed26-4be6-9edc-1c4375644af1,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:0b93b184-a7ec-4748-8ac1-dca5703e241f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2d358d0e66a911f08b7dc59d57013e23-20250722
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1790337710; Tue, 22 Jul 2025 11:08:44 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 11:08:42 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 11:08:42 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v4 0/9] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Tue, 22 Jul 2025 11:07:15 +0800
Message-ID: <20250722030841.1998783-1-peter.wang@mediatek.com>
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

This series fixes some defects and provide features in MediaTek UFS drivers.

Changes since v3:
1. Fix comment message in patch:
  ufs: host: mediatek: Simplify boolean conversion

Peter Wang (7):
  ufs: host: mediatek: Simplify boolean conversion
  ufs: host: mediatek: Change ref-clk timeout policy
  ufs: host: mediatek: Handle broken RTC based on DTS setting
  ufs: host: mediatek: Set IRQ affinity policy for MCQ mode
  ufs: host: mediatek: Add clock scaling query function
  ufs: host: mediatek: Support clock scaling with Vcore binding
  ufs: host: mediatek: Support FDE (AES) clock scaling

Naomi Chu (1):
  ufs: host: mediatek: Add DDR_EN setting

Alice Chao (1):
  ufs: host: mediatek: Add more UFSCHI hardware versions

 drivers/ufs/host/ufs-mediatek.c | 329 ++++++++++++++++++++++++++++----
 drivers/ufs/host/ufs-mediatek.h |  32 ++++
 2 files changed, 328 insertions(+), 33 deletions(-)

-- 
2.45.2

