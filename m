Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F9313C67E
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 09:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726048598; cv=none; b=BChJIkoLIi0KkonwOLMFNpRvcFQ/CX3CDOGMSFimzAhjNeIS87zFJ0kYMa/qJBynpEp+trqWSEIjrxkb3dty2L190lfc9uXEvh8Ie82UvhazN64OuVNzDAGlfZn9c7YbeVd9C1VXMGf2uMNwPvMQRZjIFN0UdcAsM7L1MVsIKTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726048598; c=relaxed/simple;
	bh=fP6xNlQIGpckeNcMivXDv1DUwB7eAreec4jXSDHeasA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bbdcNo3MpGb409RtP1kKFKdd3kK4377kX1888+FXrm/5fNqhfJo4iN3U/BZnexAupOlbXkKMyiUrb2WpkrAL6YY07qimCv8t9yoxDylm6XeYsFPiEES2O3lHgN9gLZkNCzp/xLNz4+rdYdhI5/eUtjo8Yit9gI2x4Q2a6YvvirI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Bzr4aUX2; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Bzr4aUX2"
X-UUID: 1b158dee702411ef8b96093e013ec31c-20240911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=2a5ZLW56DkDhz9qmAEJxaF5QWpnkHwGAip2BA/dq1eI=;
	b=Bzr4aUX2RlkGg1sd1HwMsUbNpipN/89NJ80GTGbixWo2/mqsVh9ahaJbeddtStJ3g/4TPrt4YZSdTVyTj33zde4C9sIvGpnRb1HKyv5Xow2t8Q/CJ/LA+wo9VvEHrmqVWicwSunB4nYSPtsodqpi6WCunkJpeqOVklhIrgQ+vRw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:569eee79-10ac-4197-913b-874e6fa0833f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:b0480ad0-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 1b158dee702411ef8b96093e013ec31c-20240911
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1674349998; Wed, 11 Sep 2024 17:56:24 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 11 Sep 2024 17:56:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 11 Sep 2024 17:56:24 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<quic_nguyenb@quicinc.com>
Subject: [PATCH v6 0/2] fix abort defect
Date: Wed, 11 Sep 2024 17:56:20 +0800
Message-ID: <20240911095622.19225-1-peter.wang@mediatek.com>
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

This series fixes MCQ and SDB abort defect.

V6:
 - Add err handler check before set flag true.

V5:
 - Change flag name.
 - Amend comment and patch description.

V4:
 - Remove nullify SQ entry abort requeue.
 - Add more comment for flag usage and set description.
 - Fix build warning.

V3:
 - Change comment and use variable(rtc) for error print
 - Change flag name and move flag set before ufshcd_clear_cmd
 - Add SDB mode clear UTRLCLR tag receive OCS_ABORTED requeue

V2:
 - Fix mcq_enabled build error.

Peter Wang (2):
  ufs: core: fix the issue of ICU failure
  ufs: core: requeue aborted request

 drivers/ufs/core/ufs-mcq.c | 15 ++++++++-------
 drivers/ufs/core/ufshcd.c  | 35 ++++++++++++++++++++---------------
 include/ufs/ufshcd.h       |  3 +++
 3 files changed, 31 insertions(+), 22 deletions(-)

-- 
2.45.2

