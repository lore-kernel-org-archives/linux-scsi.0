Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDADC166F08
	for <linux-scsi@vger.kernel.org>; Fri, 30 Aug 2024 07:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725003878; cv=none; b=k4jh0S6pbUbi77F9dW4wLAENoe8Tv1Md8QtpleP45s0DW9ZIgigq17JBgLjJ7S10LB1pIb7/YuWrlTN+7+rqDmiygddMV42MZaKKT9NI1q+HpoWRaWSWEgVuNslZyJKAMyTZzfgLoVm4KQIojMfHA9V/KQSkfOi+1iEkz9VUnN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725003878; c=relaxed/simple;
	bh=A/kILLfFTBx3fK4z176akvKosKSLU6Ap2M9826wFqHI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OMcyo5EWCdw52eOtMmG0FEDQOHGxJsCTrld7KzEDAAuVSVQYuAQHUr3MQEcNSNKng1yosQudM2PiawieFCFCKtcrigdccAoshZ7aU+4YZhF9AATfMLAO90MnJbKlryLBT0LklTN4YIN7WIvI530cnBfoJ+JFgDmMkNvikkxvMpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=pD2sWegE; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="pD2sWegE"
X-UUID: aebd981e66a311ef8593d301e5c8a9c0-20240830
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=QCbZZ+HLARh/+zhHKGYSQ1ZKICknsRWOTY5EOhqpK0s=;
	b=pD2sWegElDxnMkKLqSxyb3t/KdziKoM0eLDpblUPPiJKEhzWDklibSJE86+uCe7VJe1ZWtaJJ9bMZAAL9gtSX3OjoQCwAWV7GnVgDVhqBMSDS291St7kXKwCgX99duKyrBUntoDUXtS8qJ+OK2KS1UTVq9WKA2O3OOndwvlN304=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:071fa113-8e1a-465e-aa7c-1319bcaad3ed,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:d98c0a15-737d-40b3-9394-11d4ad6e91a1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: aebd981e66a311ef8593d301e5c8a9c0-20240830
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 278110808; Fri, 30 Aug 2024 15:44:26 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 30 Aug 2024 15:44:28 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 30 Aug 2024 15:44:28 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 0/2] fix MCQ abort defect
Date: Fri, 30 Aug 2024 15:44:24 +0800
Message-ID: <20240830074426.21968-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This series fixes MCQ abort defect.

Peter Wang (2):
  ufs: core: fix the issue of ICU failure
  ufs: core: requeue MCQ abort request

 drivers/ufs/core/ufs-mcq.c | 10 ++++++----
 drivers/ufs/core/ufshcd.c  | 21 ++++++++-------------
 include/ufs/ufshcd.h       |  2 ++
 3 files changed, 16 insertions(+), 17 deletions(-)

-- 
2.45.2

