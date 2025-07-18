Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80C629B776
	for <linux-scsi@vger.kernel.org>; Fri, 18 Jul 2025 09:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752832537; cv=none; b=kpPySiL2sQu1HngFCvOp4XOg8o3qYNLu4hqRBIMvfgtlP0t44ZJIkNNcj8OvIatRdi9qNSjpZJ2dgDAkgu9W59dSDxHsHGbZtXh0eanS6nykE9hRXKzizO1LgkGFIPEif7RayEeKLscQ8x05eacEqntuhIiR3H2iwJL/sws8yC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752832537; c=relaxed/simple;
	bh=YYiR3PQZdhsiJWBoYXx+lhvEQ8dHZX8qT+bZubeTo60=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ig6F4RNfgH3RNJJ9fKiTKSeNSAYSGTMohFMJEuR3zDfKjSmW5oz+9e0JgGr1bJKsksfE1S1r6Y3SBwpqjubfMeBzc6XIY7hpLo0c8nbMq8mXdG7PY6QSY7RmG7JZE2rKXRf9s7GB2TQ6eS2wzlwTJjbqcPql+PclsF/ww8GJ8tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XWbQg2uh; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XWbQg2uh"
X-UUID: 5544f65263bd11f0b33aeb1e7f16c2b6-20250718
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=ft5Atbw62VBXz2JRzCcT00+h6DNH1l60+hYyeZWpvlc=;
	b=XWbQg2uhv8+sjIr8bti1rOmqR4EVizPimtPaDb4CSUQox6CQsJDLJBIEi+a8eW2bkksO+zM4oqFLF1BeI7fhT0Jrfl6wjpY8xtgh93KrHmqtkOf0CqeyzysIY6jkMYXpMLXXXe3+OyajVvbr+3h/YttM7ecnrYVrITymv7l0MfA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:6e35d33d-b8dd-4f9c-bac6-1c0f1b028d72,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:d8692773-f565-4a89-86be-304708e7ad47,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5544f65263bd11f0b33aeb1e7f16c2b6-20250718
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1798215958; Fri, 18 Jul 2025 17:55:27 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Fri, 18 Jul 2025 17:55:26 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Fri, 18 Jul 2025 17:55:26 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 0/9] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Fri, 18 Jul 2025 17:51:43 +0800
Message-ID: <20250718095524.682599-1-peter.wang@mediatek.com>
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

Changes since v1:
1. Remove unnecessary "!!"" in patch:
  ufs: host: mediatek: Remove unnecessary boolean conversion
2. Remove memory barrier patch
3. Add some comment and patch description in patch:
  ufs: host: mediatek: Add DDR_EN setting
  ufs: host: mediatek: Set IRQ affinity policy for MCQ mode
4. Fix build warning in patch:
  ufs: host: mediatek: Add clock scaling query function

Peter Wang (7):
  ufs: host: mediatek: Remove unnecessary boolean conversion
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

 drivers/ufs/host/ufs-mediatek.c | 323 +++++++++++++++++++++++++++++---
 drivers/ufs/host/ufs-mediatek.h |  32 ++++
 2 files changed, 325 insertions(+), 30 deletions(-)

-- 
2.45.2

