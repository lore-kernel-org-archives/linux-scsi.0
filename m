Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8202C11C4;
	Fri, 17 Jul 2026 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302769; cv=none; b=uyL6OgHq/0RNKLqWahMrtyXEPXDCwXMUvGbVVnhJishP70YHO8yd5aZcdAElaww2jTpIFNHdP7+TyLAV+95WLXzIxhOri7cn3IZID8kTLZdX/xURgXrtp+91pB98DXbfN5G2q7n8n0V166MBhT7biFoluOYamAyBafIGLq9dWqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302769; c=relaxed/simple;
	bh=xpOIjVBZfnQFOtT/OUuece+sX/gnJ1NFSNqQzUPQx9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XylqfgIOOI1bCbTQ0+JBiWlj39FGKDO8p+n3rATHRcFUrAJfSu9i5XisMfeKx4vV+dw/B5OfQ5+cB+221PJyWlZ9qmDjIBb+j1ot5fTjhgohz4op0l/5XHvUrMn7DVJW9mFxykKEyEFpIWa6s+bAaXQ+Q5oIsROkLNmwnQglQWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: ad8da99c81f511f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:7dc0d2b8-0ac7-4b05-a6ef-9461dc2d6ecf,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:7dc0d2b8-0ac7-4b05-a6ef-9461dc2d6ecf,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:2384095f3d6f2624b74511b28501b538,BulkI
	D:260717233920CA4B88IL,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: ad8da99c81f511f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1337696236; Fri, 17 Jul 2026 23:39:20 +0800
From: Li Qiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH v2 0/6] scsi: ufs: Fix descriptor parsing and invalid input handling
Date: Fri, 17 Jul 2026 23:39:07 +0800
Message-ID: <20260717153914.26321-1-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1784182493.git.liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The first patch validates string descriptor payload sizes and avoids raw
descriptor overreads. The remaining patches protect invalid completion
diagnostics, validate connected lane counts, validate RPMB frame sizes,
use unaligned RPMB frame accesses, and retain a NUL terminator for
debugfs input.

Changes in v2:
- Reworked patch 2 as requested: drop changes to the safe
  scsi_cmd_priv(NULL) and scsi_cmd_to_rq(NULL) calls and retain only the
  invalid-CQE diagnostic fix.
- Split the previous RPMB patch into a request-length validation patch
  and an independent unaligned-access patch.

Li Qiang (6):
  scsi: ufs: core: Validate string descriptors
  scsi: ufs: Avoid NULL CQE dereference when reporting invalid tags
  scsi: ufs: core: Validate connected lane counts
  scsi: ufs: rpmb: Validate request frame length before parsing
  scsi: ufs: rpmb: Use unaligned accessors for RPMB frames
  scsi: ufs: debugfs: Reserve space for a string terminator

 drivers/ufs/core/ufs-debugfs.c |  2 +-
 drivers/ufs/core/ufs-rpmb.c    |  8 ++++++--
 drivers/ufs/core/ufshcd.c      | 32 ++++++++++++++++++++++++--------
 3 files changed, 31 insertions(+), 11 deletions(-)

-- 
2.43.0
