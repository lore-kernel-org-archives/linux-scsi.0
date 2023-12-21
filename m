Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D6A6A32D
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Ies/gdVP"
X-UUID: b09f01a69ff011eea5db2bebc7c28f94-20231221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=jC0sXjCnIhbt918CnedQVH2uV5YUh3c631Te5mtBE6A=;
	b=Ies/gdVPPBq4WlcybG4s7ik1c3OYhpuIBrQHP74TacFR96sFrxIn1Fmq9HqlZ+vB4q4kVpQodTAcrWGV3J6T0nZ+a821ctHGmHTv9H45icpsbc2YrrXODeaoPlLMd6P+VsEaLVxCEgWUFxKIYXOJGr505D4+BKKh64n6zW2wrwQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:3ac56bc7-0f23-4734-bc89-8af4454daf41,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:2929572e-1ab8-4133-9780-81938111c800,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: b09f01a69ff011eea5db2bebc7c28f94-20231221
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1641810907; Thu, 21 Dec 2023 19:04:19 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 21 Dec 2023 19:04:18 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 21 Dec 2023 19:04:17 +0800
From: <peter.wang@mediatek.com>
To: <chun-hung.wu@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <avri.altman@wdc.com>,
	<alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: [PATCH v1 0/3] ufs: host: mediatek: Provide fixes in MediaTek platforms
Date: Thu, 21 Dec 2023 19:04:13 +0800
Message-ID: <20231221110416.16176-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--4.376000-8.000000
X-TMASE-MatchedRID: oS9YGR9UQY0MQLXc2MGSbJdc7I2df+msBGvINcfHqhe7qpOHKudqc0as
	gt8eEZ2k2Bzgv79yUtegVbxI8zQaQh8TzIzimOwP0C1sQRfQzEHEQdG7H66TyMdRT5TQAJnA/O1
	sc2r+KcGSLJ3M/MszziBrI7cC63na+4yKBglQj0jBkGBTIlURuXoXDz8+lMxFpW+aIDJ4DaRzkx
	J+SIkUjmncuUSUEdOX
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.376000-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 86ADD0A0C4021EACE501C0B6233AE3A0C0134712D9E0241B417570C86B3773B52000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This patch fix MediaTek platform exit hibern8 and mcq related error.

Peter Wang (3):
  ufs: host: mediatek: check link status after exit hibern8
  ufs: host: mediatek: fix mcq mode tm cmd timeout
  ufs: host: mediatek: disable mcq irq when clock off

 drivers/ufs/host/ufs-mediatek.c | 65 ++++++++++++++++++++++++++++-----
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 57 insertions(+), 9 deletions(-)

-- 
2.18.0

