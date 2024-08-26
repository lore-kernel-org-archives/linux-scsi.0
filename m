Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F215A1773D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 03:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724643920; cv=none; b=N+Kg995aWSB57YjMN114+I4+t3TG/QV+02lFEyT8j/oUCz/JVmNeTC9sW8PHCMw7pFWOEHv4o6j51wQXfLdH6ZUE784Bfc5IGUFdM7yRZCZ+9Cbfz7Zlj200sjMXEfHf57AduG6bGKeC884DtiY6z8HoiHnjZC64D00uuRD9wnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724643920; c=relaxed/simple;
	bh=oJVN3M+sN+S7XTcFLYS77WvoOjbVbi2pJddU7iHW3F8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XyaJW5dJk9Z0GgdGoUgaMAj5GyzxPP6Eb6CNUKV6SmpLMLr2m4bFvhWojciVz4TvrV83t3WWhyixuQXyWw2QPYvGbhtITQ+JR3zY9Hk3zq/ulJAEfGn6+/2bCzGUhSiAfD1XJvXO6vkRAE0vgvSPNFpTWBBIHrqUHEETVc2Kgu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SXo08ZR5; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SXo08ZR5"
X-UUID: 984722f6635d11ef8593d301e5c8a9c0-20240826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=dZIiGVvIpecQWnYLZ08Qp1lFuCr4iZEaRdK87m+BHHI=;
	b=SXo08ZR5IwvsLO1/EivT2pTmOCUPdp9pRF/GCTgmCJo9dvlT2wf0KGVkTsYBoWZGkE9g7CxhwkTPzCQS0rwehbtqVa8M3JYla4HLq2Kx9Km04UJC/nc0t3A5ViPTGrrWmKkTRmdK6SxYmNe9FJgQ60FWrIT1vXULmGjbwqJAGyI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:a8074c00-3bd2-4633-8a62-e07d36a1c0d4,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:ffc1c814-737d-40b3-9394-11d4ad6e91a1,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 984722f6635d11ef8593d301e5c8a9c0-20240826
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 613884385; Mon, 26 Aug 2024 11:45:10 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sun, 25 Aug 2024 20:45:10 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 26 Aug 2024 11:45:10 +0800
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
Subject: [PATCH v2 0/2] ufs: core: fix err handler mcq abort defect
Date: Mon, 26 Aug 2024 11:45:07 +0800
Message-ID: <20240826034509.17677-1-peter.wang@mediatek.com>
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

V2:
 - Change patch description typo.

Peter Wang (2):
  ufs: core: complete scsi command after release
  ufs: core: force reset after mcq abort all

 drivers/ufs/core/ufshcd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.45.2

