Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E31C287503
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 08:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753086997; cv=none; b=kCTsBylE7cERseSqPIxGitTsFqpBMbXC7RnbfCcWaRLP0TRjwbB4vkceupcQIKfvm3CfvV5yNjvyB2SD8JplvRdsQti+9lOv8Pp3z9oQ5r7iiwsSuvsaoqqVdxheX2jSkge6huRaMObRsfouj7j8ajadsFNsLQYZbLub0XCQ5pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753086997; c=relaxed/simple;
	bh=BDjRm0OOoX8m1/dMvn+Bn58gxtXHUpfQA+XrngCN+G4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=r886SRPV+tvCwm99BHe7vA6VXkw2EL84UcvSeerl+2+9GwuFL1zlNRz32eeTUDOFPtbbZ9kqhw7UTVxh3T7TgoPzPZFethxYyaBzu0EKERBCMf6bJc/onf345d32VKnZEkuEib1PEK7OSksBWi+ql1Y6b2pt9qz92uMXd6iJBcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uxckixYy; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uxckixYy"
X-UUID: ccff4b3c660d11f0b33aeb1e7f16c2b6-20250721
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=DevNDz8BFw1anNLJvpEp1t+vYuylJ5UpZ56Fi6uRKas=;
	b=uxckixYyTO46NxLX4Uz/fkm/WT6spbdMkJ7jwbU9XYHc6Hx0isYfGafNtp+7o+J1InMrno4H9L8cGgi79FJG8KgysomDTwFjUjLwfudBIT/wwv5XShxwvIjjWT76k+M/TPyokYuVa/f1NE/UGBWFAUQozixGsHwCN88kyxCWbgw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:cf8b27ac-fda8-4f09-b1ed-690e17ed3ae6,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:04d7199a-32fc-44a3-90ac-aa371853f23f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ccff4b3c660d11f0b33aeb1e7f16c2b6-20250721
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 918243939; Mon, 21 Jul 2025 16:36:30 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 21 Jul 2025 16:36:29 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 21 Jul 2025 16:36:28 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v3 0/9] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Mon, 21 Jul 2025 16:35:09 +0800
Message-ID: <20250721083626.1801668-1-peter.wang@mediatek.com>
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

Changes since v2:
1. Remove unnecessary parentheses in patch:
  ufs: host: mediatek: Remove unnecessary boolean conversion and
    parentheses
2. Fix comment or patch description in patch:
  ufs: host: mediatek: Add DDR_EN setting
  ufs: host: mediatek: Set IRQ affinity policy for MCQ mode

Peter Wang (7):
  ufs: host: mediatek: Remove unnecessary boolean conversion and
    parentheses
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

