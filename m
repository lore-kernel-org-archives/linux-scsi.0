Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29E5372EF7;
	Wed,  3 Jun 2026 09:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780477447; cv=none; b=iFcgiSr/A1Wnj4GNe1tmS/uM8SSseBQSNXMb6V7H9xywGm1OnpaJg9HOvILMYPs6nsAby6wSkZWXBMwejZ24PwRx27vYsfScBE6hV/ZdVUB35E9mT8B0QKGxINphbVgOg8QySuTihPmWYeRyOKGsnXV4p0+ojP+e0sksA2eVGhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780477447; c=relaxed/simple;
	bh=ioMPMLysh+ggKDHwFTdEhoJ38LukBtucYbnRJn8GWPw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b0E5bLnDVr2pBXgABqkPzRtR2JcOdFqcoDWTpnnD3/v16K/1AokZAb1zN9gpLbDXuJb7oupSM9TagrL1BIzcCAwzSCXL215h/S5Fp0YdnolyFnjM2/wLsz387f/u6frPhhDQi4ohNssyCZ9QBneBAkBBA3O2XDtLpb24R6b1lfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 287affda5f2b11f1aa26b74ffac11d73-20260603
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:daf01482-828a-48eb-88e8-3667f21292d3,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:bad97901ae90cc1345082e806dd50a79,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 287affda5f2b11f1aa26b74ffac11d73-20260603
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1772892839; Wed, 03 Jun 2026 17:03:59 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: hare@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: myrb: Fix off-by-one error in target ID boundary check
Date: Wed,  3 Jun 2026 17:03:55 +0800
Message-Id: <20260603090355.196528-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix off-by-one error where sdev->id is allowed to equal MYRB_MAX_TARGETS
(16), leading to out-of-bounds array access. When sdev->id is 16 and
channel is 2, err_table_offset becomes 48, accessing array index 48
in a 48-element array (indices 0-47).

Change the boundary check from > to >= to properly reject invalid
target IDs.

Cc: stable@vger.kernel.org
Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 drivers/scsi/myrb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 591ba70a0579..54d89d1643de 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1669,7 +1669,7 @@ static int myrb_pdev_sdev_init(struct scsi_device *sdev)
 	struct myrb_pdev_state *pdev_info;
 	unsigned short status;
 
-	if (sdev->id > MYRB_MAX_TARGETS)
+	if (sdev->id >= MYRB_MAX_TARGETS)
 		return -ENXIO;
 
 	pdev_info = kzalloc_obj(*pdev_info);
-- 
2.25.1

