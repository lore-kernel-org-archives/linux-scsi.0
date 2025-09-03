Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7801FBEAC
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 02:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867604; cv=none; b=LMsoiE07EVVJ+p/bqyMTmPYq3s4FKHSbIRr9eb2Y4238zR8EwYoZkUc6BjFd7vb1Qd0+al+y7IuoEBL4bB3bgkKVb4Bubp3Mt8LYlbIX+1NYC4Nae9BuiJhdpw6e1Bd1nWas+YqZU5BdMoEnfFD+jbF4/U1/JU8KWmC9tpNXeS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867604; c=relaxed/simple;
	bh=VXk2w3P9aHWzK17m8nAksFQgupknrTGSjAePSDfZjQw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sdnYN8j+UCn0mlPOaWg/U7WFt2PCE9OH7OwIBJSlZgEKrYgBMFnCkUemt/fQdRQS+/0A/XdxqKCN5R7R5I0wljjJyAAifXVMUoWmucGMoeyDsAEnre3RPRrCmfkDkwfh1uGsb6ceT8bBVi4j7cIC16qK11UclrSUTwrc44aNdLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=DLzArD89; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="DLzArD89"
X-UUID: 344e1488887011f0b33aeb1e7f16c2b6-20250903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=TAoBlYksGK5PxxO/QDG8OKY6NfvTD6divmIC/9zQRik=;
	b=DLzArD899z/QEp84t10JGZXDazgYQ75T+2ZPvOfvRm48ggsvABKjUh2zX1geTP6jEYk9kHR4GV6TDevP5Iyfqv1Wivcq2I0Soz/WtC7ByI/BYMhdMjvrfXroY0V6OTGxKAtRToqgoueuhqm2V7NM+YlEEeAMg3BWqvNfssIzE5Y=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:b44c6197-8b78-46a7-ba55-ea6d13b10b00,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:a23b236c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:-5,Content:0|15|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 344e1488887011f0b33aeb1e7f16c2b6-20250903
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1122963891; Wed, 03 Sep 2025 10:46:34 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 3 Sep 2025 10:46:32 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 3 Sep 2025 10:46:32 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v3 00/10] ufs: host: mediatek: Power Management and Stability Enhancements
Date: Wed, 3 Sep 2025 10:44:36 +0800
Message-ID: <20250903024631.496693-1-peter.wang@mediatek.com>
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

Enhance the UFS host driver's reliability, power management efficiency,
and error recovery mechanisms on MediaTek platforms. Address critical
issues and introduce optimizations to improve system stability and
performance.

Changes since v2:
1. Change commit message to imperative mood

Changes since v1:
1. Export ufshcd_force_error_recovery instead use force_reset
  ufs: host: mediatek: Enhance recovery on hibernation exit failure

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

 drivers/ufs/core/ufshcd.c       |   3 +-
 drivers/ufs/host/ufs-mediatek.c | 171 ++++++++++++++++++++++++++------
 drivers/ufs/host/ufs-mediatek.h |   1 +
 include/ufs/ufshcd.h            |   1 +
 4 files changed, 145 insertions(+), 31 deletions(-)

-- 
2.45.2

