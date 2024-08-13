Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4434A2262B;
	Tue, 13 Aug 2024 05:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723527354; cv=none; b=t5nhpeYgvQSHl5xgUn6O5rTzNbP/OrJ1AZcHHGx/nFjlMHnsJ3geMkCp/QiKVp7y03oOgVJrZkOGVkkvYYzVDaRcUxBCiVqCFjIPklzdam1HboQDS0sANAYHW+ZzntY7/GVaIQxqsfI1zOPQ2dX4iNnmqDp0fNh0O3BXPDEY++A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723527354; c=relaxed/simple;
	bh=leX6LTkBLs4xXEn0eU34c+kXiu6whunxTHrih4W8c7U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mtyeLquzLWe2ft3uvA06ubW2umGq9yF/d1kEd11WcRtbsCrCLtKmewJvM3s4NUN+xxWXniUGIbZaOeP95ZxdJQC+hYZQmJZmdeUiI1t4NTgchZY3RZkhQOxHAVl1Sjouv15h05M9LuDlu/NGeLoK4IYniPu6R3k4egPfs7kZJGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ur8dWJqm; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ur8dWJqm"
X-UUID: e21fd0bc593511ef9a4e6796c666300c-20240813
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=/EL4a84+ewNtTbFzf9olvVO+ScQrjy5OcNClP3jBT/Q=;
	b=ur8dWJqmragf9F617NZtYGjGQtSSzzxU40yoM9n7DWZTWflVJhj1cM87HwEaGozfeYtonb4ovyBFQH3P/hDWItachhAjiDzOIIlKhC1VI7uqJ1b5HLCFYSMl25DAO6NYADGdBUSSVF9j1K4v+I8GcEvBY4K5mC/tE+Dc0fNHzE0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:13ba0f39-76b7-4140-8442-79f59cf65512,IP:0,U
	RL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6dc6a47,CLOUDID:343a85c1-acff-4a0f-9582-14bcdf4ed7e0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:1,IP:nil,UR
	L:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,S
	PR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: e21fd0bc593511ef9a4e6796c666300c-20240813
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1575888886; Tue, 13 Aug 2024 13:35:43 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 13 Aug 2024 13:35:44 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 13 Aug 2024 13:35:43 +0800
From: Chaotian Jing <chaotian.jing@mediatek.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <srv_heupstream@mediatek.com>, Chaotian
 Jing <chaotian.jing@mediatek.com>, <stable@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>
Subject: [PATCH v2] scsi: fix the return value of scsi_logical_block_count
Date: Tue, 13 Aug 2024 13:34:10 +0800
Message-ID: <20240813053534.7720-1-chaotian.jing@mediatek.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

scsi_logical_block_count() should return the block count of scsi device,
but the original code has a wrong implement.

Cc: stable@vger.kernel.org
Fixes: 6a20e21ae1e2 ("scsi: core: Add helper to return number of logical
blocks in a request")
Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 45c40d200154..8ecfb94049db 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -234,7 +234,7 @@ static inline sector_t scsi_get_lba(struct scsi_cmnd *scmd)
 
 static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
 {
-	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
+	unsigned int shift = ilog2(scmd->device->sector_size);
 
 	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
 }
-- 
2.46.0

