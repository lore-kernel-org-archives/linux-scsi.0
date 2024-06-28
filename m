Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96480125AC
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 07:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719558043; cv=none; b=EMFBlYf2Tz6wLySotNEjd+X3BQXBA2Ph1MMHlqA7M0ODfr5i14o+6zcffaWqfA2A6n+2Hg4UxHWdeeJ7MYv71hO2nB1hqJ7xEKzQMjau/mtklmYyTFO9vkZSCSoePwaU7tIcVwCorNDjNd0vY8RMjWlS7MdYbbniFtRswRpJcHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719558043; c=relaxed/simple;
	bh=9RAH1BfZXCtDT3OzpLeqjAd9+mWzb+jQi9GAKrm6pCM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=N8IrK5zYG6/CuejJ+b0UZmLlfQFmRPESjd/Gn7u3CcWTNIwyb7e29toN6BqSwZHfeFZ6y0MUpL/2ahQANhS+FKuEc6477Oj5FUx+Ukdfyi+JzUps8fapHAK9sSWCIUyQZUtpGPPtUnHsx0Q8AqYL26guhZfrAoPuiCty4PzT06I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=gESS++xT; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="gESS++xT"
X-UUID: 1e7d1fe4351c11ef8b8f29950b90a568-20240628
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=irLaHCX2zHKTSIkKOfcy2lIsUrR7jXGz603EzNUAFxo=;
	b=gESS++xTlkNxY1r8WydCSW3b7XjbGuDnjAm2YgjqhUObQ42Td5Qw1C7B+9VVoce6Ma+8GE1y1fk894AY/K7VjNjqA52R/v39hcfEjn5ascisqCm0qArrXpleQYR7R5vCW9HxmJbe2wJCkRfGmplQjBV/4uMaQCq9zjiSP8p5Oeg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.39,REQID:ca962c98-453e-49eb-9fc7-6a57a10b1c9a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:393d96e,CLOUDID:095eaa44-a117-4f46-a956-71ffeac67bfa,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 1e7d1fe4351c11ef8b8f29950b90a568-20240628
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1168072136; Fri, 28 Jun 2024 15:00:35 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 28 Jun 2024 15:00:31 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 28 Jun 2024 15:00:31 +0800
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
Subject: [PATCH v3 0/2] ufs: core: fix ufshcd_abort_all racing issue
Date: Fri, 28 Jun 2024 15:00:28 +0800
Message-ID: <20240628070030.30929-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--7.428700-8.000000
X-TMASE-MatchedRID: lR9wedxBitsMQLXc2MGSbBes/RxhysDbFJFr2qlKix+7qpOHKudqc5as
	fA8Y/RCFiI8t/Y95trJix2NkmtuoxShlmALF5LHIjNvYZHpO13dKPIx+MJF9o5soi2XrUn/J8m+
	hzBStant2jkpctwKLBQtuKBGekqUpI/NGWt0UYPBkV0ySDuBhe6atgnJszNdSNvttFIXy+pKzdl
	k4phIsUlncShV1VSIi
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.428700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 07A7C2201B6794F2E8F3CC91F6D157BECF181419B27292004DFDF86857F7DD2C2000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This series fixes race condition KE in ufshcd_err_handler, which call 
ufshcd_abort_all abort an already completed request by ISR in MCQ mode.

V3:
 - Modify ufshcd_mcq_req_to_hwq to distinguish cmd is completed or not
 - Split two patches and add more race description.

V2:
 - Change patch description and add Fixes/Cc tag

Peter Wang (2):
  ufs: core: fix ufshcd_clear_cmd racing issue
  ufs: core: fix ufshcd_abort_one racing issue

 drivers/ufs/core/ufs-mcq.c | 11 ++++++-----
 drivers/ufs/core/ufshcd.c  |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.18.0

