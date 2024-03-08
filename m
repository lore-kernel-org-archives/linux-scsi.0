Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7D64EB3C
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 07:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709881375; cv=none; b=too1VRQo+7MVnOyOJllXSgLYL85fsIB1Y4/Ne4QLTxscGcYxNplZWD3maD2vJkPnan27az3diJxa6YjjiSHc2sefLM0kWtkjT8+vYnYXBXveVQc0p00RJGkXOxkbeJZLGBVDfwoSsu8HOBzVIluTQsyx9q/tRvSZbLP8Oz4sZK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709881375; c=relaxed/simple;
	bh=/38y0AuLHzqEmnaQjlKLKAIePR1DEDQy2WGeq67bBtQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=i6mqc7pTziUJQYX63YKadrPkogqzl0mPl1Noa9WeykcznpqKOouGorDmKpBzVrLsgPELJ5snk48BK0vD25jb5Ua71v5KYraeVkDxZBBr4WeOwxCbGkzh/mceJhkPesPTYz/SqvJVnJt2AxdUOzfNORrx9oBeAeDsVlG3yrESzi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Hz+pQfpI; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Hz+pQfpI"
X-UUID: dd17ceaadd1911ee935d6952f98a51a9-20240308
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=35OV9bm/nJfNjbrb7yi/BB0BrjLFYQJ7Jo6Rx4Ol1pg=;
	b=Hz+pQfpIBBmRt3VRq8xBDvbQEj7d6dRAchxdt+KRnY5CGKIGjmfPnEdlzPAwtekxFKG6aPhnm1zdNlx8ojG78yHqTSdB+lAZ6Jf71BPQ/oMYZSQaK1j+zae+mzSEIkg1LRr/86xd7HjLmV6wSUdOMO+8XQXJ47giHuQ2JQlctkM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:2b2fc066-2f16-4e84-950b-80d9fd720733,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6f543d0,CLOUDID:3aa84381-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: dd17ceaadd1911ee935d6952f98a51a9-20240308
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 658427736; Fri, 08 Mar 2024 15:02:44 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 8 Mar 2024 15:02:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 8 Mar 2024 15:02:43 +0800
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
Subject: [PATCH v1 0/7] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Fri, 8 Mar 2024 15:02:34 +0800
Message-ID: <20240308070241.9163-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--7.753000-8.000000
X-TMASE-MatchedRID: sBypFcuOxUYMQLXc2MGSbDPDkSOzeDWWNNuh+5zmS680QmmUihPzrEI+
	GPbgg5kxzd7s/pivV7Ebeq8jPqXwbj95f95FaTdFP0HVIeixJdAraL2mh8ZVK0k7tZaD19NMo8W
	MkQWv6iUoTQl7wNH8Pg1fA1QHegDv3QfwsVk0UbuGrPnef/I+esSfI/a4Ki1CnfkRCpX3LDY2KU
	2TjSiKo14YemAKcq+3l5lPxc0kjNU=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.753000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: A66417B6A0862F3EBCC3F098BB2B814C3613DB32401881B33D6B87E704E73AC52000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This series fixes some defects and provide features in MediaTek UFS drivers.

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
 drivers/ufs/host/ufs-mediatek.h     |  89 +++----------------
 3 files changed, 219 insertions(+), 94 deletions(-)
 create mode 100755 drivers/ufs/host/ufs-mediatek-sip.h

-- 
2.18.0

