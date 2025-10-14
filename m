Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6FE230F94E
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 13:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447889; cv=none; b=Pw4JK7/F2hp5G9yTL68XKiDIbfYxX8nTRO1qv4WgD76hQgPr8U31i+fqxF+RA+iXWmprgyzVR5DqNPd3NrFpRP9cXCyC8wUY1KD1Gjg7yat85JSK7iMLO1uO+QSaJ9N4mH1LaGydgh0AKh5dZmnN3aV7dKhb2sL3xc0oXwFnd/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447889; c=relaxed/simple;
	bh=c/BACOZexjdgDGEBtS9U4egCk4W7klh12EBf/wi9pnc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=n2RbSjWK9UlpLL0rFgwvXzy9+ItcxvdEmdLoF8vpoXiIa+Saa3AxTYulIFhqTyDje4sMU1N+wrMa44piqztRC5RkjwEwI2rZ/y0RweT3y+7D1K7/5+glry0/h4Bk+nfZnYzbOwQFrRCR9Cf7BxA+3jDHttGXvRbZ2o4RkeS2knM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Zx/XspCL; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Zx/XspCL"
X-UUID: 35cc90d6a90011f0ae1e63ff8927bad3-20251014
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=l1L6dCANxX6aUgtEXhtUXuM3yx6oct3U3laoE+p24ZQ=;
	b=Zx/XspCLadvqHpUk+xBJeFrYQXYhqSdacJ2yeAKVpk3mBH4+3kQicYebZTu29JJ2uIVowyC+wAKGx+K/er/spGCyDh1eck2PJOTXfq4yHSSW7oxf3Lr4QS+PElPb+gWrZUfWlxFvuxh/SS96Hy8ULedRD7jcCSaPVu7z8B8AVME=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:f287df7d-89f2-4434-b0ff-e73f351a7d05,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:a9d874c,CLOUDID:f79328b9-795c-4f99-91f3-c115e0d49051,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|888|898,TC:-5,Content:0|15|5
	0,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 35cc90d6a90011f0ae1e63ff8927bad3-20251014
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 747948841; Tue, 14 Oct 2025 21:18:01 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 14 Oct 2025 21:18:00 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Tue, 14 Oct 2025 21:18:00 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<qilin.tan@mediatek.com>, <lin.gui@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1 0/2] update CQ entry and dump CQE in MCQ mode
Date: Tue, 14 Oct 2025 21:15:54 +0800
Message-ID: <20251014131758.270324-1-peter.wang@mediatek.com>
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

Update the CQ entry format for UFS 4.1 compatibility and
add support for logging CQ entries in MCQ mode, enhancing
debugging capabilities.

Peter Wang (2):
  ufs: core: update CQ Entry to UFS 4.1 format
  ufs: core: support dumping CQ entry in MCQ Mode

 drivers/ufs/core/ufshcd.c | 17 ++++++++++-------
 include/ufs/ufshci.h      | 17 +++++++++++++----
 2 files changed, 23 insertions(+), 11 deletions(-)

-- 
2.45.2

