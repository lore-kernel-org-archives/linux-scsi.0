Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95456221264
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 08:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770625870; cv=none; b=ldeniO1yTDO9ymAly0CvwwFZlrfXgxuOVS4IqxBGRE+0ckdJHrj+bWpjVjuQda7HE5eUwACZyPEnZa1u+KnSDQPi1YWu7NLw1NBXC3DQ+l3XRV5XJ4eg5zlyQfzRFR20m6vUbFeBGW6L7JmTcWWhReOz7Gp6+S9u9I16VMuJCZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770625870; c=relaxed/simple;
	bh=zsiEO0jx/a1exv7yxtKOekpjmoIP63DWVqjzSVOAck0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fZHTsP6ICnz4ElnrDVOGdeB0JogYnjbMJn4Fs9PzG4s2BId+zEMe9TTxNIFyzAfsWxwPU017Q1Qh2oMOrQcge+SGaUC7uqOaBhf02tV9MMuqFyMZ4mtBheRF+uuW4of3cKKGptGo6E/iIXzIiI0cYBWfH/dZVjsh9foVVV5LC6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Y330Jvbj; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Y330Jvbj"
X-UUID: a786b736059111f185319dbc3099e8fb-20260209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=dC4WolGnhLTi40jxEVbhTsw0SN67edXA2YmiUO+NTLA=;
	b=Y330JvbjYlcqqeEHBf4zNJCUm6USRSsfPAhhyxTMV3h7IqozAkIXlAK6AvOJrZ6ocjxY+jI1j32it5OFvIr9jScb4iTlTY5mX9WMYVm9TVTwRS9XL2cWrB8G3T44rUIvkUTkJkGp03V9lxfuG6jSNFMLJv6wuLRHEFAYS9VuQKE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:8cf21324-a836-4ae9-a068-4770c89ead27,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:b93c7df0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a786b736059111f185319dbc3099e8fb-20260209
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 469353940; Mon, 09 Feb 2026 16:30:56 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Feb 2026 16:30:55 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 9 Feb 2026 16:30:55 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1 0/2] add debug log for commnad timoeut
Date: Mon, 9 Feb 2026 16:28:46 +0800
Message-ID: <20260209083053.1467647-1-peter.wang@mediatek.com>
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

Peter Wang (2):
  ufs: core: add debug log for uic commnad timoeut
  ufs: core: add debug log for mcq commnad timoeut

 drivers/ufs/core/ufs-mcq.c | 2 ++
 drivers/ufs/core/ufshcd.c  | 5 ++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.45.2

