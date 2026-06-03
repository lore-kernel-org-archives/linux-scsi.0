Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC773F0AA9;
	Wed,  3 Jun 2026 07:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780471038; cv=none; b=OK1QgCDxz+yAfYEm70UxhgJRb1jCJ38/Xl7+Q7YEJ3f1MMc+zlW5es+ikuwhnzh67vIVtxs9VHORQHjDZvTkWyMgWEM3W2oLsoZfA8v0U2InJobLhmbMvgbxPAmgD4SvHKkjjY1eXoT+w3pFvpXWa21Tj09kti7bNMXyhibKKoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780471038; c=relaxed/simple;
	bh=zOyP0pAh7wLzWtWugN4Ymjekpw1uizx0Zim9lcd33rY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QQiXwjTksZTFuvFhDa3mgwPSkvB0kSJHEaPZuWUZKQ7hFwUC0b48BHX1I+pi4WRhMmqmJWnYwH12JZWAWnBDEpp08xr8Oqb8j3XosRkFoupF+cOG04XOAhWmKlBEC8biZkNUp/8gAL8WnjoHIHHL4rRjf5rX8h7mqVNoT9y4O/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 3b7e578a5f1c11f1aa26b74ffac11d73-20260603
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:eda6be66-6e57-4d3a-86bd-3f5e0d516ebf,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:4e712981538c28d92a94a98b18bc3c58,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|850|865|898,TC:nil,Content:0|15|50,E
	DM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA
	:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3b7e578a5f1c11f1aa26b74ffac11d73-20260603
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1186270292; Wed, 03 Jun 2026 15:17:08 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: hare@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH v2] scsi: myrb: Fix region leak in hw_init functions
Date: Wed,  3 Jun 2026 15:17:04 +0800
Message-Id: <20260603071704.151708-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When DAC960_PD_hw_init() and DAC960_P_hw_init() fail after successfully
requesting the I/O region with request_region(), the region is not
released before returning. This causes a resource leak.

Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>

---
Change in v2:
-The fix is to clear cb->io_addr when request_region() fails, matching
 the same fix already applied to DAC960_P_hw_init.
---
 drivers/scsi/myrb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3678b66310ed..591ba70a0579 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -3115,6 +3115,7 @@ static int DAC960_PD_hw_init(struct pci_dev *pdev,
 	if (!request_region(cb->io_addr, 0x80, "myrb")) {
 		dev_err(&pdev->dev, "IO port 0x%lx busy\n",
 			(unsigned long)cb->io_addr);
+		cb->io_addr = 0;
 		return -EBUSY;
 	}
 	DAC960_PD_disable_intr(base);
@@ -3281,6 +3282,7 @@ static int DAC960_P_hw_init(struct pci_dev *pdev,
 	if (!request_region(cb->io_addr, 0x80, "myrb")) {
 		dev_err(&pdev->dev, "IO port 0x%lx busy\n",
 			(unsigned long)cb->io_addr);
+		cb->io_addr = 0;
 		return -EBUSY;
 	}
 	DAC960_PD_disable_intr(base);
-- 
2.25.1

