Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9E9BA33;
	Wed,  7 Aug 2024 00:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722992358; cv=none; b=K1WQCGi/qHu120a2a3gIcyIfLW/4qzSdeZOIbc3FMTSApKE3ShZ6QlS0dvdFdbyb3cUQTP+O766eeW4nmFDr09CeN7i3kQecIuhlW1ltceBYhleju1f+dKAqqnsjcVNA4DOV+zlO0aH4Fn3QjHbZqHfIJQcAGcct8TEUvDZThh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722992358; c=relaxed/simple;
	bh=yBHEj7vHz6leVh1KJIZdxTMqYZMh5PHqcWKJ3wFMn4o=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qIPXSv0TnhPM01XC3Z2LgaEUYINCfEgLenA9HiXMdlkh0xebkdiPVUtIrkydlcggW+KvH97ibbsdnQXCFS3YWtKXWpR/PYE4fLkupYBI6I33Br9nfOVJQh1t4pizs2VBK2A/8HcGZuLJc10oKfIpGtkDnO8m5XMh6hDUrb/lWPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TLXvPhoK; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TLXvPhoK"
X-UUID: 41d497b4545811ef87684b57767b52b1-20240807
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=tqvFLsU38AQ4ZsYa+GqPZqwxYkXOtirMZ+Qc0V7lbbI=;
	b=TLXvPhoKbi6Iusbo3Urm069p1bmhTk210O663SwdHjbZVRuBjn8xMHg4vpb+m2xU0LSBJrbhX02TEfMwuiW6A+TPyjSJhVw3U5FGuKK7+msugFwmsFY+uFKaUzqq6Xk+c5/4UImrff/cYz0ShVZ6+id11tKj5aVLZM50K4yXhNE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:13db8756-d176-41fd-b485-8c4566e8d10c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:838146c1-acff-4a0f-9582-14bcdf4ed7e0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,
	SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 41d497b4545811ef87684b57767b52b1-20240807
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <chaotian.jing@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1543075415; Wed, 07 Aug 2024 08:59:11 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 7 Aug 2024 08:59:10 +0800
Received: from mhfsdcap04.gcn.mediatek.inc (10.17.3.154) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 7 Aug 2024 08:59:09 +0800
From: Chaotian Jing <chaotian.jing@mediatek.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>, AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-mediatek@lists.infradead.org>, <srv_heupstream@mediatek.com>, Chaotian
 Jing <chaotian.jing@mediatek.com>, <stable@vger.kernel.org>, Bart Van Assche
	<bvanassche@acm.org>
Subject: [PATCH] scsi: fix the return value of scsi_logical_block_count
Date: Wed, 7 Aug 2024 08:57:59 +0800
Message-ID: <20240807005907.12380-1-chaotian.jing@mediatek.com>
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

