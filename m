Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C11285C96
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707144; cv=none; b=RJQmxrKhW6tzby5kSqugsFGBqodVjWtDjjerJgPT/yCwX06qv0cugXt+A7bfri6jcoOoI5E7UHfogRjGbPbgf5G1VxoThCAvxDtrs2xyVaCvkFWma84PSq9FUPWkyfgWfrk0lam3ri1BCKpM/fxczmC6C6vlPhDCaBJNDtN/IiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707144; c=relaxed/simple;
	bh=pJk6u/BiyTQqjOrtop89XU6GA6ynSvVJTpiAHgFJOEA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PyBNdrKJO1JkiQDPle96e84d0ReRVsZEUQKk0teG5iw/4Hn9ygTOBIMqzqcXW2UebSASMUYc94m/aAyawUsO8qfnW022aDl8eu7Bv0l4dvJI9uM3/h1ehJ04GPF4GF9DSLfG44mWjZQS9PXkNuubgEoXD1u+X0sHbtvMdBiRF9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=L5HvVvlD; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="L5HvVvlD"
X-UUID: 351cd50e992b11f0b33aeb1e7f16c2b6-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=drF1fdmkMoWlGNql8tAYPyTbYL9ZuOc9JcTmIddHJ9c=;
	b=L5HvVvlDLuWnT4r7LS2babqlB5U66a2NUslSbkSSCjpVsNEs9IiRLIvy/rUrJgUfa3s0A+Ce5/vi9Wvf4Xt4ap9Z/MddS/6mzyxYgodVbER8lHhWSdSncIdjJbVlJJ+voYFmcJ2znb2uVykSaV0KCrkta8+dvGIoyTQ2QYnYb90=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:63a51f9a-ab8b-485e-bcfa-334a9e4dc16b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:42ffa1e9-2ff9-4246-902c-2e3f7acb03c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|888|898,TC:-5,Content:0|15|5
	0,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 351cd50e992b11f0b33aeb1e7f16c2b6-20250924
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 85482903; Wed, 24 Sep 2025 17:45:30 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:45:28 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 24 Sep 2025 17:45:28 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 0/8] Enhance UFS Mediatek Driver
Date: Wed, 24 Sep 2025 17:43:22 +0800
Message-ID: <20250924094527.2992256-1-peter.wang@mediatek.com>
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

Improves the UFS Mediatek driver by correcting clock scaling 
with PM QoS, and adjusting power management flows. It addresses
shutdown/suspend race conditions, and removes redundant
functions. Support for new platforms is added with the 
MMIO_OTSD_CTRL register, and MT6991 performance is optimized
with MRTT and random improvements. These changes collectively 
enhance driver performance, stability, and compatibility.

Changes since v1:
1. Remove two patches that will be fixed in UFS core.
  ufs: host: mediatek: Fix runtime suspend error deadlock
  ufs: host: mediatek: Enable interrupts for MCQ mode
2. Use hba->shutting_down instead of ufshcd_is_user_access_allowed

Peter Wang (7):
  ufs: host: mediatek: Correct clock scaling with PM QoS flow
  ufs: host: mediatek: Adjust clock scaling for PM flow
  ufs: host: mediatek: Handle clock scaling for high gear in PM flow
  ufs: host: mediatek: Adjust sync length for FASTAUTO mode
  ufs: host: mediatek: Fix shutdown/suspend race condition
  ufs: host: mediatek: Remove duplicate function
  ufs: host: mediatek: Add support for new platform with MMIO_OTSD_CTR

Naomi Chu (1):
  ufs: host: mediatek: Support new feature for MT6991

 drivers/ufs/core/ufs-sysfs.c    |   3 +-
 drivers/ufs/core/ufshcd.c       |   3 +-
 drivers/ufs/host/ufs-mediatek.c | 119 ++++++++++++++++++++++++++------
 drivers/ufs/host/ufs-mediatek.h |   4 ++
 include/ufs/ufshcd.h            |   2 +
 include/ufs/unipro.h            |   7 +-
 6 files changed, 115 insertions(+), 23 deletions(-)

-- 
2.45.2

