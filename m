Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FD621A42D;
	Thu, 16 Jul 2026 06:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182835; cv=none; b=XTE2zgtHlioISypOqe3NUCfXNPcp8XaWaJeDlYS2jKg4gqD5LxhtoNMrR/B2bS5a5xhI4+FtQzuArs8Mhif9+ErlV0rAlH6EtNCOEFhG3uHtTasOmVSmryAF8YEwkf5bPQVD0ts8mjMn7mgxvSfImyXDz+6Al2JBwIaWKC+GBKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182835; c=relaxed/simple;
	bh=9Fc5c711UdhYrsPSBEO+heWSxh6l8CQGkq7ep3RjJJg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JgiUN83IS4ok353Eel1YtINva3Lr242CLss6cBf3zu7hkCqoyevjoE0dZLI1AlAPh0vpsXjrhv+KugkkxtbhihrDARmtu+Jmds5vKA+FDHpcVes8SxGF4ynVw+VQdjNYIfqvmw0v5GTDHPb2h2hW03XH+tD9yQIkPTAhmVhmgqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 6edf148c80de11f1aa26b74ffac11d73-20260716
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:1eadf644-da35-4c00-a67f-7c844eec7791,IP:15,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:40
X-CID-INFO: VERSION:1.3.12,REQID:1eadf644-da35-4c00-a67f-7c844eec7791,IP:15,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:40
X-CID-META: VersionHash:e7bac3a,CLOUDID:68defe7e8d94693855d1345562e11cfd,BulkI
	D:260716142026070H467W,BulkQuantity:0,Recheck:0,SF:10|66|78|102|127|865|89
	8|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 6edf148c80de11f1aa26b74ffac11d73-20260716
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1999001551; Thu, 16 Jul 2026 14:20:25 +0800
From: liqiang <liqiang01@kylinos.cn>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	alim.akhtar@samsung.com,
	avri.altman@wdc.com,
	bvanassche@acm.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	peter.wang@mediatek.com,
	beanhuo@micron.com,
	can.guo@oss.qualcomm.com,
	adrian.hunter@intel.com,
	tomas.winkler@intel.com
Subject: [PATCH 0/5] scsi: ufs: Fix descriptor parsing and invalid input handling
Date: Thu, 16 Jul 2026 14:19:50 +0800
Message-ID: <cover.1784182493.git.liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Li Qiang <liqiang01@kylinos.cn>

This series fixes five independently triggerable UFS robustness issues.

The first patch validates string descriptor payload sizes and avoids raw
descriptor overreads. The remaining patches protect command completion and
MCQ cleanup, validate connected lane counts, validate RPMB frame sizes before
parsing, and retain a NUL terminator for debugfs input.

The series was built with x86_64 defconfig plus UFS, RPMB, and debugfs.

Li Qiang (5):
  scsi: ufs: core: Validate string descriptors
  scsi: ufs: Fix NULL dereferences after tag lookup
  scsi: ufs: core: Validate connected lane counts
  scsi: ufs: rpmb: Validate frame before parsing
  scsi: ufs: debugfs: Reserve space for a string terminator

 drivers/ufs/core/ufs-debugfs.c |  2 +-
 drivers/ufs/core/ufs-mcq.c     |  6 ++++--
 drivers/ufs/core/ufs-rpmb.c    |  8 ++++++--
 drivers/ufs/core/ufshcd.c      | 35 +++++++++++++++++++++++++---------
 4 files changed, 37 insertions(+), 14 deletions(-)

-- 
2.43.0
