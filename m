Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B46C32ED5C
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 07:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770707327; cv=none; b=dn0+Cc1yXrLaaqPrLIX9a9+7N4RvXCvHLescqWa+aKUZUYNlUKXbLXmBFUvcvctqVx4J9lisOgTZZB+FrUAgh12IivsuRZRWlcg5nz1iHX2AiDJsC6CznMzhSZ2phq7TZxziK4pVuZ4jh/7tG/ub5UdI0RZXyYKqJZ6iiDBbRpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770707327; c=relaxed/simple;
	bh=QcOiNMOGbXxiQ8fl7O0UyQ9rACnheKoqrx8llOlGJhY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cowi7VWTxP0rn4bXy5eY+enkxjqyyTRYqhYa7+Xqkge4dxkSoNxKigRrz2JmdY2yq8gGscIfKk2tFeFrjDq/nBgC/Jmvhcw57yS2UpDqdVbIX2WGgTAJTSqO0K/l72FiIkUisMO6I5qaCwX1ikqQ8L1b/nt9Y0gb84aUYwRfHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XrjAN/3R; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XrjAN/3R"
X-UUID: 53f9af6a064f11f1b7fc4fdb8733b2bc-20260210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=TScqYfHnvAIcJ4R80g7WUaCVr8TpNDnfVY4ZI5GrzMI=;
	b=XrjAN/3Rq1iqapZRmOyGEIo08ogJCdaoHsK6/pFvvALR/7E99Bx+WVuu3tl6U0Qu7nGjcgNFfVXAGb2Nv8SymfZLZCDSIUJm3Xw5gjpkv7TpKXo3TFNm3gCzZ4b5vsg6ch3ylZpxW3exDpf6HhuGi9M4Hm/7MjTBmFaOAeZMn10=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:29d26a06-800a-4b08-98b7-4790fc3afadc,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:e34aca7a-8c8a-4fc4-88c0-3556e7711556,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 53f9af6a064f11f1b7fc4fdb8733b2bc-20260210
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1002236452; Tue, 10 Feb 2026 15:08:40 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 10 Feb 2026 15:08:40 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 10 Feb 2026 15:08:40 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2 1/2] ufs: core: add debug log for uic command timeout
Date: Tue, 10 Feb 2026 14:41:43 +0800
Message-ID: <20260210070837.1820710-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260210070837.1820710-1-peter.wang@mediatek.com>
References: <20260210070837.1820710-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

It is difficult to debug when a UIC command timeout occurs
simultaneously with a UIC command complete interrupt.
Currently, we only see the timeout log without any debug
information, making it unclear whether the UFS device failed
to respond or the host entered an incorrect state.
Add a one-line log to cover this situation.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 604043a7533d..ec175a099459 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5564,8 +5564,11 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 
 	guard(spinlock_irqsave)(hba->host->host_lock);
 	cmd = hba->active_uic_cmd;
-	if (!cmd)
+	if (!cmd) {
+		dev_err(hba->dev,
+			"No active UIC command. Maybe a timeout occurred?\n");
 		return retval;
+	}
 
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
 		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-- 
2.45.2

