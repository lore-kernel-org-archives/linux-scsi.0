Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE871B3750
	for <linux-scsi@vger.kernel.org>; Mon,  9 Sep 2024 08:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725870072; cv=none; b=T+SHuzWuDc3HAdtGkdl6pAfnMX6SR0dt7wbJODdTe1WXbrrqjm6tn8JLGM4/bVfuqsGovZd3/xsRLHkBD7sYG48RbJ3teX/dB6+WzLMWdtUq462WyNI08R7FjLxZuKdqt8wrrNQcZ7q6UOcXM/8CL1gaJ/LH1OQ8rXBiUoU/8is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725870072; c=relaxed/simple;
	bh=pVg3DPuJGdNQn1mbhHFVI809OOmHzRXMtEr2DMG7SmU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dWpn41ILsmh6WNE/5KA6zMY+EOAuMlN+vQEVhErHll6DfkQosO/7K7UxdbvtqYhw5qVYl5t9lNtJspwBQenEOvZFhvqoQhXXvQjk99ULTc8sKJdUAMwxmPpNNLJmYEwY5tgzUKT+j4+nahna6+pvpOBcfnM4LF4D+CNUQruPTrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KPF8ix/0; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KPF8ix/0"
X-UUID: 7451fc4a6e8411efb66947d174671e26-20240909
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=yLu2KE+XrIvKi5ZvfVr6caNuFiiJdh0jYEYYVKb1huI=;
	b=KPF8ix/03BUazqUuPZWbHnq53h1oOg9cCae8atceiT2Zi47vqoFftZhcBZSDzkfACg4q33aXWLsUpZr/gEKGFXjwJLCtLR6JhuQdTEb9maSUJogWvISgkzaXtwQvvJwzIEJwwmt4V00zC1LP2OiyGjFmMg9H7KQ4a1AGE9qdmiE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:8d856e2a-cd2b-4a45-a683-18597504e2d0,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:eebeaabf-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 7451fc4a6e8411efb66947d174671e26-20240909
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1166372217; Mon, 09 Sep 2024 16:21:03 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Mon, 9 Sep 2024 01:21:02 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 9 Sep 2024 16:21:02 +0800
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
Subject: [PATCH v3 0/2] fix abort defect
Date: Mon, 9 Sep 2024 16:20:58 +0800
Message-ID: <20240909082100.24019-1-peter.wang@mediatek.com>
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

V3:
 - Change comment and use variable(rtc) for error print
 - Change flag name and move flag set before ufshcd_clear_cmd
 - Add SDB mode clear UTRLCLR tag receive OCS_ABORTED requeue

V2:
 - Fix mcq_enabled build error.

Peter Wang (2):
  ufs: core: fix the issue of ICU failure
  ufs: core: requeue aborted request

 drivers/ufs/core/ufs-mcq.c | 16 +++++++++-------
 drivers/ufs/core/ufshcd.c  | 29 +++++++++++++++--------------
 include/ufs/ufshcd.h       |  2 ++
 3 files changed, 26 insertions(+), 21 deletions(-)

-- 
2.45.2

