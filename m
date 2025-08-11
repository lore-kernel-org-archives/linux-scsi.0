Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92BE2DAFA3
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918075; cv=none; b=Ygs7VcUT4pPCLeEQYaJsSQe1tVnfyi1av6Q0pLvvcdKacyF8hgiVKHtb+4LRclY/JsLWOfdD2EAt3/eaSP9uFgIfbyU4uYEg+ZOXifMAM/xkHsrsnvlsq1ntF2eS5URauiBO8L2AQMpw6N13z7sUOO7eLRCFXHkKD5eUnxw95bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918075; c=relaxed/simple;
	bh=I6jT5G0LISNKHKworuoUJOFys0ZJ/vXptMt+JWh3DTE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MHaAlk/hKXLFg6R/TthanTa79ElJBpMY4vVxx8P6u6cd+hzy5BqvImX8xcPYQxt0RdSv1kYn9LdEJl7AHbI2XmarmpWGSmk6VngnjfA3kDASF7/H4r8qIX4M8IG/gOZXMSteB2jdNshq8Oa2fZUpo1do1vIALxEBN4OXKYSJLn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=d8WGCaNd; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="d8WGCaNd"
X-UUID: 1abda6f476b511f0b33aeb1e7f16c2b6-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=zE7VaC4MONDwK4PE8r0v7fr0w4FR+FHjUHLbyoOF2zs=;
	b=d8WGCaNdZGKemkIrv6UWaJNogDLixsyW5SdiS5uRWCoH74PUhHpLd6WwUcFh8/PGrpGDpcW05z2m/dkMXleLXQzw4MFdfr0oWLeAX5tWDn6vu9QAxHjPbUWWWmq0oZquflX7opbhdIhlRVNSa1t0S7Kcp78AjwDhTOeQxjNjLJU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:834df459-6e03-409a-b89e-d97a5160a2d5,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:7ea549ce-1ac4-40cd-97d9-e8f32bab97d5,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:-5,Content:0|15|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1abda6f476b511f0b33aeb1e7f16c2b6-20250811
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1748575200; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:24 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:24 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 00/10] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Mon, 11 Aug 2025 21:11:16 +0800
Message-ID: <20250811131423.3444014-1-peter.wang@mediatek.com>
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

Peter Wang (8):
  ufs: host: mediatek: Simplify variable usage
  ufs: host: mediatek: Fix auto-hibern8 timer configuration
  ufs: host: mediatek: Add debug information for Auto-Hibern8
  ufs: host: mediatek: Fine-tune clock scaling
  ufs: host: mediatek: Fix PWM mode switch issue
  ufs: host: mediatek: Optimize power mode change handling
  ufs: host: mediatek: Fix UniPro setting for MT6989
  ufs: host: mediatek: Change reset sequence for improved stability

Alice Chao (2):
  ufs: host: mediatek: Assign power mode userdata before FASTAUTO mode
    change
  ufs: host: mediatek: Fix invalid access in vccqx handling

 drivers/ufs/host/ufs-mediatek.c | 185 +++++++++++++++++++++++++++-----
 1 file changed, 156 insertions(+), 29 deletions(-)

-- 
2.45.2

