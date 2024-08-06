Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C99F164A;
	Tue,  6 Aug 2024 07:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722929312; cv=none; b=Yfuot8OB/1i+qcgMRiGNZPVwrk1s7q4IqL3qMETQ+BLRtAvgv1zmkEenWJYdoETcXEUZrqgnalAf3bhcfeFC9PWp2nNtt9H8wqeM/tbwkxh8iR0kCrUxPUH0eenOGxA2+1BxX+tK8tLsH84gYYq+Hist1T+qg/2cTWc2Y+J3eBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722929312; c=relaxed/simple;
	bh=DPKMbIhNMBWo8TVDQHV16EL/N7iDJy1aU8uVJ8RTMBc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=EIyyxMm+tbAC3cyJAS/2vN70lRkxBEDYcgYk9aqdX+KZ/ZW8KyJPuYcMyoHASlUkpz+mhrBNzojecTdw7gE8yJD1IYYlvZdHpCwTNsC1mvEHPnaoCPj4tB9+stKVH7mWbZ4Hkz0xJVIe/Md9CznF78umffykfJE6e2vBQdIOCkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=S7lo9+Cc; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="S7lo9+Cc"
X-UUID: 70155fb653c511ef9a4e6796c666300c-20240806
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=bd8GlhW9froM6GOA2YyMMX+R5JWkQRdHXG8ufSuKDZk=;
	b=S7lo9+CcEvbtzQeRMFP90ClQE05B2DplLGO+YHRUL8nvyWUKJvhyejiClqcIzd6kmCQJHD0F2XQlVO6AOy+n7KZ+y5vgo5forAQrx4uXCAB2WUw6P7zcD3mpJ2/KGdEVXaQ6F0fn63JGjE57gb3amP3BxZiJWQYiwBxWB16rK8g=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:35d93b46-6f65-4d6a-b2ea-bb55fe00c44a,IP:0,U
	RL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:25
X-CID-META: VersionHash:6dc6a47,CLOUDID:b66160d2-931c-41a1-8323-49b8649cd827,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:5,IP:nil,UR
	L:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,S
	PR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 70155fb653c511ef9a4e6796c666300c-20240806
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1313570926; Tue, 06 Aug 2024 15:28:12 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 6 Aug 2024 15:28:13 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 6 Aug 2024 15:28:12 +0800
From: Chaotian Jing <chaotian.jing@mediatek.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <srv_heupstream@mediatek.com>, Chaotian
 Jing <chaotian.jing@mediatek.com>
Subject: [PATCH] scsi: fix the return value of scsi_logical_block_count
Date: Tue, 6 Aug 2024 15:26:34 +0800
Message-ID: <20240806072714.29756-1-chaotian.jing@mediatek.com>
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

Signed-off-by: Chaotian Jing <chaotian.jing@mediatek.com>
---
 include/scsi/scsi_cmnd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 45c40d200154..f0be0caa295a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -236,7 +236,7 @@ static inline unsigned int scsi_logical_block_count(struct scsi_cmnd *scmd)
 {
 	unsigned int shift = ilog2(scmd->device->sector_size) - SECTOR_SHIFT;
 
-	return blk_rq_bytes(scsi_cmd_to_rq(scmd)) >> shift;
+	return blk_rq_sectors(scsi_cmd_to_rq(scmd)) >> shift;
 }
 
 /*
-- 
2.46.0

