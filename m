Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B25533987
	for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2024 07:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726040202; cv=none; b=Jkwzrh6TbV5toejCVcHgInhxKuwXSI5Jab/0UZCLHnp8U7FFMqQ3P5F7xb5uCYC2SSZdY0F/uaDY3XF/tvG3GGbq5v93Djfxg8MY6jCiiPnjo7DhnUCbf2jEl10P6reJViL28FSiWO+wUc6DF5Af8NDqBcprk5eZeQrHN4iK0V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726040202; c=relaxed/simple;
	bh=T2O3J9fUCB85/fzEMbhw580y+Y4n4CMpNscWkwwC6go=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OcTNdSIpGFeQJ3h7X9Lpa80R4UqBywSMkR/umynRXClZ3mTyN5Vr5CwLQVzApXRCHGiroUDKrIOn3QJqLrF38zKPy5UCtMw/TibLDeXUTtmSGB6Ow1miYpXcRQiEwrrwp6y8vFnoFuMavK4DrapGh0C0OGC5KLXokfOAd3I7Tn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=IxFKKllZ; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="IxFKKllZ"
X-UUID: 9268737a701011efb66947d174671e26-20240911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=o6Qkhr8Jgk+7BUP7pSeOIho3VJKsokqm72SmXuR0RjE=;
	b=IxFKKllZxeW1eIsX4KdJYG9k4QcT4TH1uw62el/P9Qd0IPEOqeqx+ScCFQhPtYFQM7ghVpYMTZoAXaw/GK7clBBAmAD5hX2CgUPZJ+NTVBq+KamRirCYsqShwMezlNU452Q1fAIh7GnS7TRKCCJODw2PYmqkZvv8RfpcsO5+yOc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:1cefb187-4c71-46d7-b72c-89847487c169,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:397dc9bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 9268737a701011efb66947d174671e26-20240911
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1201484565; Wed, 11 Sep 2024 15:36:34 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 11 Sep 2024 00:36:33 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 11 Sep 2024 15:36:33 +0800
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
Subject: [PATCH v5 0/2] fix abort defect
Date: Wed, 11 Sep 2024 15:36:29 +0800
Message-ID: <20240911073631.32410-1-peter.wang@mediatek.com>
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

V5:
 - Change flag name.
 - Add err handler check before set flag true.
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

