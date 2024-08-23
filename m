Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB4A1BF3A
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724407637; cv=none; b=EnTDIGPe54bEr0iiWXMc1bZhvhikWvICK7IM2hMD/gu61iZdfT0XMTGOlv5IbVb6SmluxqOFXDGut4ITC6hKLHgUaox5h+xyCRx7/fZs2xrzOqTuWTN0wYuz/hlNN6cl5V+98VIS0e5+z+aZ7DJoaLnYUPJc+99lKVKtSSzmDBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724407637; c=relaxed/simple;
	bh=kVXSpDBjpqeIA9h/JrCMEWc0xvlaSHtAgxR+7HXSlh8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uJ4NLpmpfLA9DB+ehbDE/Nlkbx2vc6B1dL+eVnT/ZxuHsj93LFYZOg1tvtbEKcSxEZKeIT5TSNkNcG91TP7XJ+Xzo0rlJu7WwZZu1eRAVvl0Vct665Hd0A29X4rK9r9LN/4elDcaULbWJ0dOXJU9BNCmP5kenJU1fFkA6IkswRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VWnvUEjD; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VWnvUEjD"
X-UUID: 754a190c613711ef8b96093e013ec31c-20240823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=Fdq16s+JWgRTDOO2fTXORoRgv/0rmwreJrXDzyZgQbo=;
	b=VWnvUEjDehtEvDx1cBztaJsTNIfR9Geufx+xr3KC30z+NVuv4kIpIiRSSkYWeEm1VDN2cwLRI1ZBAOw8VyFHmcHa+ssWbUtIBPf46cVvf76nxSgcgQ5joHscGOETULpyX8Ksg5sbKiKwXLNB/uaPKlIBtFUHsep79QdvVp+hncI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:8563a014-c7eb-4b70-bd6c-c2fd882056c4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:e9b411cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 754a190c613711ef8b96093e013ec31c-20240823
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 703298884; Fri, 23 Aug 2024 18:07:09 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 23 Aug 2024 03:07:09 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 23 Aug 2024 18:07:09 +0800
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
Subject: [PATCH v1 0/2] ufs: core: fix err handler mcq abort defect
Date: Fri, 23 Aug 2024 18:07:05 +0800
Message-ID: <20240823100707.6699-1-peter.wang@mediatek.com>
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

This series fixes ufshcd_err_handler abort defect in mcq mode.

Peter Wang (2):
  ufs: core: complete scsi command after release
  ufs: core: force reset after mcq abort all

 drivers/ufs/core/ufshcd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.45.2

