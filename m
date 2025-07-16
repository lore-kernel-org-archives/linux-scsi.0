Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24DE2874FF
	for <linux-scsi@vger.kernel.org>; Wed, 16 Jul 2025 06:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752647326; cv=none; b=FiHF2Atkm7OXzOb0MDd+CCh9eh8TdeoLYU6p3dyajpPotufFf09pyVBHZ40Xe8eq3gzO1Qgoo7ip5n2Uf0eLF5zuEPEv+7Hr3rdw6G+kMQ84c9u6oeEMZzIGzOJE7i4N2oGzGrEsFyPiPBAo5UMLoo3Q1XNrMi6RW8V8BW8q67s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752647326; c=relaxed/simple;
	bh=syL9jPcUlsPPhXDe+MDhM7KfZAEEDJeURGHpdacqDoA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=knKyIJmPMoUVmViOB11lvC5nIQFxhaNII0b9Ytve0pQpyDtSBD9u2JKAzWSqu+aWgTqwPd+Rljb9r5Sdp52Cipf23xetvg2eqFZ5H9i+KfzFgVcTbyURXJ1WJ0PSY7/RSTcVsj93x5uOIC74rgL29FkysjztcO7LFz1LQeLn4wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=MCX1JKHp; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="MCX1JKHp"
X-UUID: 1892e7f6620e11f08b7dc59d57013e23-20250716
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=lx0GhBKRDknE8K4JeiRNMVxYB7SoA83Xzs9YXSDFdDc=;
	b=MCX1JKHp98euYGTZ4MzZ/8SEHjxPwyTk0GnxPXdrCTO2upVydnUMvH/uIsWIA1kmKotoUd+3Du8zezQBisf73ktmMetc4IZ6Vx0lHqc0FdNMgF+jjSNjD666uPE/4QbnZQXwMqB5PTuX2tDwyzk9NAzyC3WEVOWdmRnlVA6Fekw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:88651446-afe8-4f3f-bd3a-0377c4cbeecc,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:921836df-2070-40bb-9c24-dfabef7c07f4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1892e7f6620e11f08b7dc59d57013e23-20250716
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1947691188; Wed, 16 Jul 2025 14:28:32 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 16 Jul 2025 14:28:31 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 16 Jul 2025 14:28:31 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v1 00/10] ufs: host: mediatek: Provide features and fixes in MediaTek platforms
Date: Wed, 16 Jul 2025 14:25:25 +0800
Message-ID: <20250716062830.3712487-1-peter.wang@mediatek.com>
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
  ufs: host: mediatek: Change return type to bool
  ufs: host: mediatek: Add memory barrier for ref-clk control
  ufs: host: mediatek: Change ref-clk timeout policy
  ufs: host: mediatek: Handle broken RTC based on DTS setting
  ufs: host: mediatek: Set IRQ affinity policy for MCQ mode
  ufs: host: mediatek: Add clock scaling query function
  ufs: host: mediatek: Support clock scaling with Vcore binding
  ufs: host: mediatek: Support FDE (AES) clock scaling

Naomi Chu (1):
  ufs: host: mediatek: Add DDR_EN setting

Alice Chao (1):
  ufs: host: mediatek: Add more UFSCHI hardware versions

 drivers/ufs/host/ufs-mediatek.c | 326 +++++++++++++++++++++++++++++---
 drivers/ufs/host/ufs-mediatek.h |  32 ++++
 2 files changed, 330 insertions(+), 28 deletions(-)

-- 
2.45.2

