Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC90C158DB2
	for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2024 07:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725953452; cv=none; b=udSaOt82iAfF510z756Hkb7nQM1Sq2drPvwdq5L1KX4lxOPd8GlbgQw0zSmG5NM8nx/izJo5EdHp8LUX84yu08B5Q+7aJjqm3nYAcPdbygtNKJ4AfV4xSmbU3jZLSCYrU9Y9yc3hxbUCHGsXouFbexyHIjaUGT4ZrnLkp3iur0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725953452; c=relaxed/simple;
	bh=bKbzjDh7a86eq4xLtsT6YCCXPGW2w4RmAjjPOyVClKU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fM/6UV7bOwh1yZsFzxAgI2t9Vs+nEHvwvz1gwiGM77RHTrJ0xtXJZXv1vlX0369299qnR+HDpQLV2v6OiStznbXvevvSFf7Ei7kZKZt+DCDC+EfIkuVsRMt869FCtpe5D0SqMkv4F97mHrGWGfcTSyyJny8xuCI5icOVZL7Kp+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Woi3gxP7; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Woi3gxP7"
X-UUID: 93674d346f4611ef8b96093e013ec31c-20240910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=P3CSoIh0U5PPE0MOtVSsVaAq1Uk8q8zzSwhefISltnw=;
	b=Woi3gxP7WWAo5FoTgHEI8pyV1aN05jJU0htah9N9cDTBAGFWOv/RabVvu0ZSwe6EcLlS4iOKg8be6OK8CBlJcbXyHGD2yyLi97w7FSHIJdEBfgOEmNNAvOxvW4fpj0KnIUlOLs5TATLJxONND8osMZa9UbN662mbIty1TCbCrXg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:e9a150cf-2859-4358-8956-7a0f08d1e2c9,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:0be9b9bf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 93674d346f4611ef8b96093e013ec31c-20240910
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 873378117; Tue, 10 Sep 2024 15:30:38 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 10 Sep 2024 00:30:36 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 10 Sep 2024 15:30:36 +0800
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
Subject: [PATCH v4 0/2] fix abort defect
Date: Tue, 10 Sep 2024 15:30:33 +0800
Message-ID: <20240910073035.25974-1-peter.wang@mediatek.com>
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
 drivers/ufs/core/ufshcd.c  | 34 +++++++++++++++++++---------------
 include/ufs/ufshcd.h       |  3 +++
 3 files changed, 30 insertions(+), 22 deletions(-)

-- 
2.45.2

