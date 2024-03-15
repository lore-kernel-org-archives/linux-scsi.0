Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277171798A
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710491703; cv=none; b=pBuPP0y1a9M+vwK10pcOBkUZb3Tgc/cDxZWzTMvV+/sohlUqpC5k7RYcEcWPB2Vfev2UuX7MRUcFGNaTeDZSM2pFPxPx0u59LJB4+fUaz8+43ZkeodEXM9sh778YSKSuIYsLxeRgqWex78hwQdQq2pHfuVaIEr1qLZKkS+p0uZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710491703; c=relaxed/simple;
	bh=5osx3Pr0tLfKJ1bDNpmYUx2iELC03I3xvDvjNERmLLA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZTJq37NGU38JuKxhOMmzrjcY7I1hiY21XnSBF+dF9Hdl4zhVM7/4g4mGjgD20l7HoiBnEHgbuNbFeKin44aUpdl2I7U5dRRklSlcEDBsJSqD+hzb3CyY1ffvsH71xCBUk5AxM04xWvSLP3832R+yvnQLVDhKRlF3Uevxo/OACmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=A58ctQlK; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="A58ctQlK"
X-UUID: e4992fb0e2a611eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=uGMXrYi4YYk2oO+1rHTixLpzrViU6sTS8OtZxl3LaJg=;
	b=A58ctQlK34Yke0UrVDV8N2Y5FaRn/E32cYJQMjydBq8dw7f+cV+K+Te385V9ob0qSWDpL22N4dIcFkji2GVg6cYqYyfNLaogPPVJP/9gsA9l74pvwNZSjjxy/6hpRyYh8oBNdvrQIQJBPN3trZlDvJAAn5HX0ci1PirYXQqwRkw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:65c13f14-ad41-4fa7-a6b3-479781c29b9e,IP:0,U
	RL:0,TC:0,Content:-5,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:20
X-CID-META: VersionHash:6f543d0,CLOUDID:06d0eeff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:5,IP:nil,UR
	L:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:
	1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e4992fb0e2a611eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1819250835; Fri, 15 Mar 2024 16:34:52 +0800
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
Subject: [PATCH v2 0/7] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Fri, 15 Mar 2024 16:34:41 +0800
Message-ID: <20240315083448.7185-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--9.666600-8.000000
X-TMASE-MatchedRID: BPqRySCXgbcMQLXc2MGSbDPDkSOzeDWWkZs6eeBnIM1UjspoiX02F80U
	/azwU24yldfHsj3+ZpRJA2NzGyeAU/2PG17cgWyQP0HVIeixJdCxIYWToTws93O+ZmsO1h7REct
	wVVwptQsrIhHNwiG1WXATsg8MODVIHxPMjOKY7A8LbigRnpKlKTpcQTtiHDgW3UT84tBOoB65tU
	1gK/spum+VOFU1oMkKGNlDATRRDjEM1mXw2ZmBS0MMprcbiest
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--9.666600-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: D35BB8CBDC66BB90B42695C6C42DE5695E2BA2B75AF040F0EB5499AD9A2740812000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This series fixes some defects and provide features in MediaTek UFS drivers.

Changes since v1:
Remove unnecessary "!!"" in patch:
ufs: host: mediatek: fix vsx/vccqx control logic
ufs: host: mediatek: tx skew fix
Add some comment and patch description in patch:
ufs: host: mediatek: fix vsx/vccqx control logic
ufs: host: mediatek: ufs mtk sip command reconstruct
ufs: host: mediatek: rename host power control API
ufs: host: mediatek: support rtff in PM flow

Peter Wang (3):
  ufs: host: mediatek: fix vsx/vccqx control logic
  ufs: host: mediatek: tx skew fix
  ufs: host: mediatek: support mphy reset

Po-Wen Kao  (3):
  ufs: host: mediatek: Add UFS_MTK_CAP_DISABLE_MCQ
  ufs: host: mediatek: ufs mtk sip command reconstruct
  ufs: host: mediatek: rename host power control API

Alice Chao (1):
  ufs: host: mediatek: support rtff in PM flow

 drivers/ufs/host/ufs-mediatek-sip.h |  94 ++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.c     | 130 ++++++++++++++++++++++++----
 drivers/ufs/host/ufs-mediatek.h     |  90 +++----------------
 3 files changed, 220 insertions(+), 94 deletions(-)
 create mode 100755 drivers/ufs/host/ufs-mediatek-sip.h

-- 
2.18.0

