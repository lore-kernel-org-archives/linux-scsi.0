Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D694532ED37
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 07:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770707327; cv=none; b=UKJ3C78RU+NH7KNr3u/HZP0sOMZcDhH3OANLkGaFMp4bxFpJ84e4LyGU+UmV92pvaoKLwmz+q7mWmr94juwUcDzajc161c7HMsaK3KPKW/cfs+DNqefDEUXEZGBpE5/SwjZpd6tVE0WeinNcvz29INKUbAJ3glotTL3t9WPBDQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770707327; c=relaxed/simple;
	bh=pyCg8BDixb2W47G0uJLqx4U1+9bKjg/Gj3Rla1yaq40=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eYDDYGUAO3GUnLRTFH3PwQA517ZHKmfatE1t4/Rn6f4sqNacZTUve60CKqomZ3SZJQPITavmSrxFgy/41nZ8fcnD14XdS0n2t5yZ4kUFwF1hWqP3X5vioN8oUsiXxNesaw2pX40y+G6DGTUmMQDqyN0lP8N2oTlTrNgy14acGDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=N4Y+zYHG; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="N4Y+zYHG"
X-UUID: 53f76264064f11f1b7fc4fdb8733b2bc-20260210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=EQSKw1Zxqh3yfhQJOprXxiikhgbHS7MU4joIUwR58+8=;
	b=N4Y+zYHGajOR1QIUHkhWoALEfjqmZftZqRNOEa+l+eYPrt8b9tidJGpBA80CJqA/5wVjbZKOFdYUDny4XbP3EKYeS5xkYqIEk2jMO7SBY7nl3RHLVwvFR0pcHQZq8U908b1+tuU4ZtsLhfTEQMTDwPM1On2FuLvCl5pDXMhwswA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:4fec9984-58a6-4986-9717-1b2f196ee8eb,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:b75e215b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 53f76264064f11f1b7fc4fdb8733b2bc-20260210
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 995122630; Tue, 10 Feb 2026 15:08:40 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 15:08:40 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 10 Feb 2026 15:08:40 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2 0/2] add debug log for command timeout
Date: Tue, 10 Feb 2026 14:41:42 +0800
Message-ID: <20260210070837.1820710-1-peter.wang@mediatek.com>
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

Add some logs to make it easier to debug after a command timeout.

Changes since v1:
1. Fix typos in the cover letter and commit message title.
2. Improve log clarity.

Peter Wang (2):
  ufs: core: add debug log for uic command timeout
  ufs: core: add debug log for mcq command timeout

 drivers/ufs/core/ufs-mcq.c | 2 ++
 drivers/ufs/core/ufshcd.c  | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.45.2

