Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD11F25B0AA;
	Wed,  3 Jun 2026 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780476159; cv=none; b=eXV83iIgyxEuVQXJrnfCJevy8KYakQLYiuCOdPktlfRYTyhVPTq22gqD+4/neejVqABA3YUl567o0n0mh9ohreaGei/mAdHOovcE9jTIKcDwLfUUO+J0SawJZk18UOAu+44pjcaDRX+nNKwqg0HKXcEuHhPAEnT4xV9R0nurEak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780476159; c=relaxed/simple;
	bh=a2iF54jfg2R7nbiPqKKC+kTlTvycieWUiohCnOB44nE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f7MXSc+VTvT3okT9MPpB6UP2vQjAdmJuqqQ1slURDyVH4JQYXjR6B3vShBbriYs/JDefra058Jf7tRczlH7OqpW9dQ/yKeixaij8v0te+mY6sytZckxyIFE9BS0mnSyiJabqksVJzYRU2YKxrN0kfgP+oLxOfnWxwpL0+rftOU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 2803cd965f2811f1aa26b74ffac11d73-20260603
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:b1b4065e-fa9f-4b0d-a140-3a07fc52741a,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e7bac3a,CLOUDID:8892152f4a9dcdb6a1566af2a65fd185,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102|136|850|865|898,TC:nil,Content:0|15|
	50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2803cd965f2811f1aa26b74ffac11d73-20260603
X-User: zenghongling@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <zenghongling@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1665208560; Wed, 03 Jun 2026 16:42:29 +0800
From: Hongling Zeng <zenghongling@kylinos.cn>
To: hare@kernel.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: myrb: Fix DMA buffer overflow in error table handling
Date: Wed,  3 Jun 2026 16:42:25 +0800
Message-Id: <20260603084225.187942-1-zenghongling@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix DMA buffer overflow where firmware can write up to 80 error entries
into a 48-entry buffer (3 channels x 16 targets), causing kernel
memory corruption. Also fix out-of-bounds stack access in
myrb_get_errtable().

Increase MYRB_MAX_CHANNELS from 3 to 8 to support all controller
configurations up to 5 channels.

Cc: stable@vger.kernel.org
Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
---
 drivers/scsi/myrb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.h b/drivers/scsi/myrb.h
index 78dc4136fb10..c2c958481ab7 100644
--- a/drivers/scsi/myrb.h
+++ b/drivers/scsi/myrb.h
@@ -14,7 +14,7 @@
 #define MYRB_H
 
 #define MYRB_MAX_LDEVS			32
-#define MYRB_MAX_CHANNELS		3
+#define MYRB_MAX_CHANNELS		8
 #define MYRB_MAX_TARGETS		16
 #define MYRB_MAX_PHYSICAL_DEVICES	45
 #define MYRB_SCATTER_GATHER_LIMIT	32
--
2.25.1
