Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BFB2A1CF
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756117107; cv=none; b=VIW3pONv34NPC6zQoqxkONqaQlufQHcXM4b27TvtKBoSEFUFecadEoINtIwqPrnFVverirUaee0MEuI9XEpPv9XoHk9oMya8uU/j02McKvGjKR4VtB/v59E/Bsw5TnMKqwaf4vMuPLNkXiymAcfuoi/RRue2LIJZcof/mG6sD3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756117107; c=relaxed/simple;
	bh=H6a4Jn3mmKGN51V9brjzLqb7GvJ7zeGktHzAyaioPko=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ktwaL5NMxjuZeBgsCiwOekG704DZrag7fPFeD6VfP2WQCFqY8HlORo/KgvRohxDkN8XBrDU3DND5lxYYj1RbqzlifxJOsiWTO0VTKhgufPQkTGGlY9DZfuf27QcuOjwG6kFjD+OsyJa2uI11UKJ4a5gJ0VFvlV1SOZVTxdXrfEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=f3sa8kkW; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="f3sa8kkW"
X-UUID: d1fbd42a819c11f0b2125946c7b33498-20250825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=J7g3d4Sf0BMZgiD7mJvVRCUZXsOADAvbi+DruDyMICw=;
	b=f3sa8kkWn7/tAv1EigGjPsQctxHfBDBUMk6xt9fOEe3f6CbDpZ7BuKBsZtipAgIduwwsmWUjntORxoGH3g/Ylnb9IZ4VCki8NUdruPy0QEx3Ej1C9znFo7jtf57IZuJ9eqwcXSfUsnt6fLUm9zwxyCQ8hhc2oISNR3SatPgMTvg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:f0e39ac7-744e-47ef-b715-b38797925717,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:d69f4bf4-66cd-4ff9-9728-6a6f64661009,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:-5,Content:0|15|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d1fbd42a819c11f0b2125946c7b33498-20250825
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 254774915; Mon, 25 Aug 2025 18:18:18 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 25 Aug 2025 18:18:16 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 25 Aug 2025 18:18:16 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>
Subject: [PATCH v1 00/10] ufs: host: mediatek: Power Management and Stability Enhancements
Date: Mon, 25 Aug 2025 18:10:08 +0800
Message-ID: <20250825101815.2891905-1-peter.wang@mediatek.com>
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

These patches collectively enhance the UFS host driver's reliability,
power management efficiency, and error recovery mechanisms on MediaTek
platforms. They address critical issues and introduce optimizations
that improve system stability and performance.

Peter Wang (7):
  ufs: host: mediatek: Enhance recovery on hibernation exit failure
  ufs: host: mediatek: Enhance recovery on resume failure
  ufs: host: mediatek: Correct system PM flow
  ufs: host: mediatek: Support UFS PHY runtime PM and correct sequence
  ufs: host: mediatek: Disable auto-hibern8 during power mode changes
  ufs: host: mediatek: Fix unbalanced IRQ enable issue
  ufs: host: mediatek: Fix device power control

Alice Chao (2):
  ufs: host: mediatek: Correct resume flow for LPM and MTCMOS
  ufs: host: mediatek: Fix adapt issue after PA_Init

Sanjeev Y (1):
  ufs: host: mediatek: Return error directly on idle wait timeout

 drivers/ufs/host/ufs-mediatek.c | 176 ++++++++++++++++++++++++++------
 drivers/ufs/host/ufs-mediatek.h |   1 +
 2 files changed, 147 insertions(+), 30 deletions(-)

-- 
2.45.2

