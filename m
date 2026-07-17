Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213A43546F8;
	Fri, 17 Jul 2026 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302778; cv=none; b=hj4xHya7lCfq52i0ULQk7XajE0yyP+6hnuOOyaruaI7lAcG2hDSTfIGDNTx6fAblNdCn+qWunyLLH580qFKxT/MIw6xF6oovfkth1ccpseBv8l+LvtwolZs2jA9YXxIxYKcNGl/Fo1ZKIRewM/7BthRg2V2UNIkPdHPjjpEbA2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302778; c=relaxed/simple;
	bh=N9V267Z6ilpa68gOCCF1mhYpf9dThBx3L1HSyRADHkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zao+tFFgk8w5zJnNAENrIgwFroax3fQ/LO8ml5ahnK/6IbZRLvcoir7oUUbVhEM+GzdkwUFhh+VxCI1Hi6PKvizPDavwywCdYTXUjegofQ08y7UuxWlN0kWUQibB87422v8xmkP6vDX39m7pNuYwXW4r5f+EzA2TZ9uRvuGzXuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b28b02b481f511f1aa26b74ffac11d73-20260717
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:6f021a33-231e-421d-b9ac-365ece44ba37,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.12,REQID:6f021a33-231e-421d-b9ac-365ece44ba37,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:e7bac3a,CLOUDID:e8c1d69296f270e7d48c10a2d6366b0f,BulkI
	D:260717233929GNM25IE2,BulkQuantity:0,Recheck:0,SF:10|66|78|81|82|102|127|
	865|898|908|914,TC:nil,Content:0|15|50,EDM:5,IP:-2,URL:0,File:nil,RT:nil,B
	ulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR
	:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: b28b02b481f511f1aa26b74ffac11d73-20260717
X-User: liqiang01@kylinos.cn
Received: from cvdaxia.localdomain [(36.148.177.170)] by mailgw.kylinos.cn
	(envelope-from <liqiang01@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 344467571; Fri, 17 Jul 2026 23:39:28 +0800
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
Subject: [PATCH v2 3/6] scsi: ufs: core: Validate connected lane counts
Date: Fri, 17 Jul 2026 23:39:10 +0800
Message-ID: <20260717153914.26321-4-liqiang01@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260717153914.26321-1-liqiang01@kylinos.cn>
References: <cover.1784182493.git.liqiang01@kylinos.cn>
 <20260717153914.26321-1-liqiang01@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The connected lane count is used by TX equalization code to index
arrays sized by UFS_MAX_LANES. Reject zero and out-of-range RX or TX
lane counts before they can be propagated.

Fixes: 03e5d38e2f98 ("scsi: ufs: core: Add support for TX Equalization")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
---
 drivers/ufs/core/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d1b989abc9e2..bbadddcd661a 100644
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

