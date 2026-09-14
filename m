Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10852416878
	for <linux-scsi@vger.kernel.org>; Mon, 14 Sep 2026 08:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375928; cv=none; b=TF8/P1U1XS0BA1N4yPV0d9L+qX0uHIYdabvSML/p250eCx3ZxpuwgMWsm9fRnvfvAxCb70EOBFrovWodubLbeM91F5E7vsS6ZtoMWO1JIZq2zXqOguvBte5l6VGB+ocRLG707lsoFBoKRectn4rkP6q76QAnBZ5ohbvc/Z6UzuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375928; c=relaxed/simple;
	bh=Tt9sYe6sabeYwRQuw+pE+ehAUsV51QjkFMlMZtUFOIU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a3AuETCgseiiemATP9VCqI0Gi6nqERvwoXv43HqGRMkSFGg5le1otKKI84E59/QdnmC2aPcOgG/fR1jdxc/eQesWanfhCPNw25oTEK9K+4dwob8M2bhahQscqOq5yotbHs75wnTIcTGVnNSB3FLgOzGweWIxKEXY7wPw0p08Ftg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GwQCKcaI; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GwQCKcaI"
X-UUID: 87287208b01911f1b1788b6acf885367-20260914
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0AY+gePrW59hf9RdRVw+cOuM7T7UqFZxJBc4kVKXZYM=;
	b=GwQCKcaIxh2kTdBSJPx1lGZtmxB267JAQjacZmemkLAHzoLpmKsH+8Vf5UCPZ36+Jj+HkzEjBb4yNtK13sXHRVs/igczG2tFJ9H33LW4L3AXDG4HB8eJ+kZizYiPJ+bV3BCaineFXWBZEGH3FAXzc56MgGacPxRpdphyVIbpHLo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:a6e524b3-ac05-4f59-a120-9bee43b7db10,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:f3e64928-9ebf-4787-bb42-3cd26eee85aa,B
	ulkID:nil,BulkQuantity:0,SF:102|123|836|865|888|898,TC:-5,Content:0|15|50|
	99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OS
	A:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 87287208b01911f1b1788b6acf885367-20260914
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1725578602; Mon, 14 Sep 2026 16:51:51 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 14 Sep 2026 16:51:49 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 14 Sep 2026 16:51:49 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <bvanassche@acm.org>,
	<santosh.sy@samsung.com>, <h.vinayak@samsung.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>
Subject: [PATCH v2 0/2] ufs: fix POST_CHANGE pairing and AHIT race condition
Date: Mon, 14 Sep 2026 16:49:23 +0800
Message-ID: <20260914085148.136429-1-peter.wang@mediatek.com>
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

Patch 1 fixes a bug where POST_CHANGE was skipped on a failed gear
switch, leaving the host in an inconsistent state if resources acquired
in PRE_CHANGE were never released.

Patch 2 fixes a race between the sysfs AHIT update path and the
MediaTek host driver's power mode change path. A mutex and depth
counter are introduced to serialize AHIT register access and ensure
AHIT is correctly restored after the last disabler completes.

The two patches are related: patch 1 guarantees POST_CHANGE is always
called, ensuring the depth counter introduced in patch 2 is always
properly decremented.

Peter Wang (2):
  ufs: always notify POST_CHANGE even on gear switch failure
  ufs: serialize AHIT register access between sysfs and host driver

 drivers/ufs/core/ufshcd.c       | 22 +++++++++++++++++++---
 drivers/ufs/host/ufs-exynos.c   |  4 +++-
 drivers/ufs/host/ufs-mediatek.c | 16 ++++++++++++----
 drivers/ufs/host/ufshcd-pci.c   |  3 ++-
 include/ufs/ufshcd.h            |  8 ++++++++
 5 files changed, 44 insertions(+), 9 deletions(-)

-- 
2.45.2

