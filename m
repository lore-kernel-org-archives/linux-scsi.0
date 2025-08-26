Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB972F6182
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2025 06:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756189413; cv=none; b=ZBeZYw+hL0k/ETbXX6Yta6y/YP6GvuAFOXyszOITXFBfhLybhdh2/fKxhvKmiraZmy17fr+ao64UtD8I/UNtpcCStumG9RHttX3MYus2Th6I4PoKidhjpZutmk63Ts4wiZuXPu7ScdFTpnPQ7w0GJfBYEzoCI/vGSyeiJUuWOtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756189413; c=relaxed/simple;
	bh=1RBSiMQan+BdYQay8veCiytq9Ia/iZmWpSv51dFkcP4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pzZhLTz7uXDAAkGWqSAy3yFzdNhgb8dJhaNdm3XxfgypO77cpcpy3rK7A7si2dKNo5vu3rMbDAdHkWYfJDATf0Vgcy8Y2jTfDDP5mMIj9Z7CVh6blhLQV319IkaELEw5M+5jgoqrpygBJMX/6nSQfnlYrUw+c8NiAsHQ/y6z2Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=NlWjIceO; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="NlWjIceO"
X-UUID: 27a51d3e824511f0b2125946c7b33498-20250826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=1em0vrPBXCDCO+JKx7CdRCabqWK3JCLYNCGTZdY4mVk=;
	b=NlWjIceOeQ+jCiAVaG+fa1RCBEAAUC/c8ksXbIhrHvAXQ3OsUhrxmqjXLQZIWAeeCR81MIjSfjY53T3/onJtU4ECmRy+AD/w+Dj31dddf3GvpYY5m9M1dR5xL1+kUoBUNSNsvh2ToY/HtnBWh3sdyJrQnXoqpfTPNdar5Gwh6QI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:caaf38b6-0390-4f4c-9c99-ffc7afd3f520,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:73c7877a-966c-41bd-96b5-7d0b3c22e782,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:-5,Content:0|15|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 27a51d3e824511f0b2125946c7b33498-20250826
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1887628928; Tue, 26 Aug 2025 14:23:17 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 26 Aug 2025 14:23:16 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 26 Aug 2025 14:23:16 +0800
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
Subject: [PATCH v2 00/10] ufs: host: mediatek: Power Management and Stability Enhancements
Date: Tue, 26 Aug 2025 14:22:14 +0800
Message-ID: <20250826062314.3070425-1-peter.wang@mediatek.com>
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

These patches collectively enhance the UFS host driver's reliability,
power management efficiency, and error recovery mechanisms on MediaTek
platforms. They address critical issues and introduce optimizations
that improve system stability and performance.

Changes since v1:
1. Export ufshcd_force_error_recovery instead use force_reset
  ufs: host: mediatek: Enhance recovery on hibernation exit failure

Peter Wang (7):
  ufs: host: mediatek: Enhance recovery on hibernation exit failure
  ufs: host: mediatek: Enhance recovery on resume failure
  ufs: host: mediatek: Correct system PM flow
  ufs: host: mediatek: Support UFS PHY runtime PM and correct sequence
  ufs: host: mediatek: Disable auto-hibern8 during power mode changes
  ufs: host: mediatek: Fix unbalanced IRQ enable issue
  ufs: host: mediatek: Fix device power control

Alice Chao (2):
  ufs: host: mediatek: Correct resume flow for LPM and MTCMOS
  ufs: host: mediatek: Fix adapt issue after PA_Init

Sanjeev Y (1):
  ufs: host: mediatek: Return error directly on idle wait timeout

 drivers/ufs/core/ufshcd.c       |   3 +-
 drivers/ufs/host/ufs-mediatek.c | 171 ++++++++++++++++++++++++++------
 drivers/ufs/host/ufs-mediatek.h |   1 +
 include/ufs/ufshcd.h            |   1 +
 4 files changed, 145 insertions(+), 31 deletions(-)

-- 
2.45.2

