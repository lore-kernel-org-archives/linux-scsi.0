Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95ED26AF7
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 12:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DjQO3xKk"
X-UUID: 3f326bbaaeec11ee9e680517dc993faa-20240109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=N7nHaY1I5LnfvEwQ7ggCcVfjDHhMZ7XKaKi9cDsT4Bc=;
	b=DjQO3xKklIG3KWM15GvJ5oa1xsHE4l1sU7y5tNtJTyBWh+8kPLdmRQ2da7ffXey6ZSnsNm8fNgerNtM6rsgj3XEtKdDViLZ2+btVQouX12sptz+urHsQPeBFBfRxzpT1n8VrVIR33leF9/X6po8YtbTe9apg8zcC1bGP9hhSIYY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:b70ccbd6-8df7-41a2-828e-9dec47d2e070,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:5d391d7,CLOUDID:1f320f8e-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 3f326bbaaeec11ee9e680517dc993faa-20240109
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1460247848; Tue, 09 Jan 2024 20:40:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 Jan 2024 20:40:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 9 Jan 2024 20:40:17 +0800
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
Subject: [PATCH v1 0/2] scsi: allow host change auto suspend timer
Date: Tue, 9 Jan 2024 20:40:13 +0800
Message-ID: <20240109124015.31359-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--5.705200-8.000000
X-TMASE-MatchedRID: 19mYHspCoIeAAYHsHSPDcxn0UD4GU5IqXs5nqGvDCfP7efdnqtsaE1KT
	eW+F3fxdT4hrqjpfaZikeU7arquyzkkjllSXrjtQFEUknJ/kEl4RTILTyAA+ovoLR4+zsDTtjoc
	zmuoPCq1ZRUwzXy/+utN/h9wesHlSrX1FKKjdWOn3YAizmQdU5AxaakXpnihf
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.705200-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: DDFD86B58787EE8D420B5793A26BD63AAB035909B05C7B70FACCD81BBE1FBCAF2000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

This patch allow MediaTek platform driver change auto suspend timer.

Peter Wang (2):
  scsi: core: move auto suspend timer to Scsi_Host
  ufs: host: mediatek: change default auto suspend timer

 drivers/scsi/sd.c               | 2 +-
 drivers/ufs/core/ufshcd.c       | 9 +++++++--
 drivers/ufs/host/ufs-mediatek.c | 4 ++++
 drivers/ufs/host/ufs-mediatek.h | 3 +++
 include/scsi/scsi_host.h        | 6 +++---
 5 files changed, 18 insertions(+), 6 deletions(-)

-- 
2.18.0

