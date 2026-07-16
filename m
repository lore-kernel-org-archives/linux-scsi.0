Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7456D23BD17;
	Thu, 16 Jul 2026 06:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784182843; cv=none; b=mYvOR0vcJQpm6YyO1elOXXcOzdpR9OdEGp7BwicoDDV9MYPPL3ex5EPcPJy1HwR/GVmTgzI+en27nzai1RUVgLOlV0JmReSkh1nYsWjuDDBw5UWGplZig6s5D3MgSOgUUzUYtYz25QlWzlf1vhiKccaF9j/6YFjj5kgPzNH/UII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784182843; c=relaxed/simple;
	bh=6mQnSFefLQNiNQXior6B1LcT+cQDcZgH50BxCN/ZCRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVQC0HJS0+mIQU8vW0ts0GpIuWN0MV0yDM34ZACOFaOlssIxMpj0RV9aroKYDO5yhrk3KEbMsLYxN3/CN1I+RrWYSu0dWkJBgzNxVE/M4f+NcXrrvJppJxv3Au1PC9dZ+7d27c5APXjlNGE2CqmLrUt+NGwJO/ZZjGvmefDb2YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 75100d2080de11f1aa26b74ffac11d73-20260716
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:9c43c007-149c-4859-bba3-7be5e4398362,IP:15,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:40
X-CID-INFO: VERSION:1.3.12,REQID:9c43c007-149c-4859-bba3-7be5e4398362,IP:15,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:40
X-CID-META: VersionHash:e7bac3a,CLOUDID:207df51e48b0f015607a2499e5678cf8,BulkI
	D:260716142038CWCDLBZ9,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 75100d2080de11f1aa26b74ffac11d73-20260716
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(116.128.244.171)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2134191926; Thu, 16 Jul 2026 14:20:36 +0800
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
Subject: [PATCH 3/5] scsi: ufs: core: Validate connected lane counts
Date: Thu, 16 Jul 2026 14:19:53 +0800
Message-ID: <36211db67413ff6d352bb4e2073dc03704657283.1784182493.git.liqiang01@kylinos.cn>
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

From: Li Qiang <liqiang01@kylinos.cn>

The connected lane count is used by TX equalization code to index
arrays sized by UFS_MAX_LANES. Reject zero and out-of-range RX or TX
lane counts before they can be propagated.

Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index f2a5fa624e74..1319e1071025 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4729,7 +4729,9 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
 			&pwr_info->lane_tx);
 
-	if (!pwr_info->lane_rx || !pwr_info->lane_tx) {
+	if (!pwr_info->lane_rx || !pwr_info->lane_tx ||
+	    pwr_info->lane_rx > UFS_MAX_LANES ||
+	    pwr_info->lane_tx > UFS_MAX_LANES) {
 		dev_err(hba->dev, "%s: invalid connected lanes value. rx=%d, tx=%d\n",
 				__func__,
 				pwr_info->lane_rx,
-- 
2.43.0

