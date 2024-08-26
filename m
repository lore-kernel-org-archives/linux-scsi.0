Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C119A1773D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2024 03:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724643927; cv=none; b=fHqk3h5RmyLDd42yY97IyU7GZdz2PXYWPnn4c40lybQEf5icX/RYHNNo5FrXTNEzerzgBf9k44NTkyKsSkTN/NrTBKjB0qA89zEpCVs2j8XclVQXYaMX0ldq4xZZHzzWpu73V+B5XiIapwbEafhA61OLCcBBnGDYJj4W+anpedI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724643927; c=relaxed/simple;
	bh=Ls7UjH+7bHLDR6Kq+9PeClfT0HtNPL5JiPZxuDQoYOQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pbKzt/EP1mAAy+3bQJTV4/gNiwtAi0PapOq32rUkS3ZO0Mgq/fCggCLmoe5evRIsh7byfLS9gZimP2I7jM7fVH4MhZYf7RMi6drzwxyeybBcU4WhMQbUZFBK8skb/9OJaM4CTuU4+dlNeFFNShotGaXbXitjYgeBnzarrZLr2hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=nxgO+a7S; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="nxgO+a7S"
X-UUID: 9b971fce635d11ef8593d301e5c8a9c0-20240826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=V9BffS1yIKEDqiempHbn9a8orD7egiUP74LZ/SGn2Og=;
	b=nxgO+a7SeZefETDSjgz34khF+K5TUb1XQ/7u8g/a3x9GkYnrn75JrWNy0pH/QPc3GA91lHSQ8erwzcAcsle6ly6lJWAjRR60WKKdmrzB5jnuMjGD3qCuIjY1EE3WcxwSIENrw2tQtjNATOi7QRL5ts8FldyQBVvT+3+9jbdSV4Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:70abb69e-30ff-440e-a424-61237f7829f6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:71cdebbe-d7af-4351-93aa-42531abf0c7b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 9b971fce635d11ef8593d301e5c8a9c0-20240826
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 515369066; Mon, 26 Aug 2024 11:45:16 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Sun, 25 Aug 2024 20:45:11 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Mon, 26 Aug 2024 11:45:11 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: [PATCH v2 2/2] ufs: core: force reset after mcq abort all
Date: Mon, 26 Aug 2024 11:45:09 +0800
Message-ID: <20240826034509.17677-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240826034509.17677-1-peter.wang@mediatek.com>
References: <20240826034509.17677-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

In mcq mode gerneal case, cq (head/tail) pointer is same as
sq pointer (head/tail) if the hwq is empty.

But if command send to device and abort it,
no response return and cq point will less than sq.
In this case will have unpredictable error.
This patch force reset for this case.

Below is error log
[   34.976612][    C3] ufshcd-mtk 112b0000.ufshci: OCS error from controller = 3 for tag 19

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4bcd4e5b62bd..d9ef8f0279da 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6519,6 +6519,8 @@ static bool ufshcd_abort_all(struct ufs_hba *hba)
 	/* Complete the requests that are cleared by s/w */
 	ufshcd_complete_requests(hba, false);
 
+	if (is_mcq_enabled(hba))
+		return true;
 	return ret != 0;
 }
 
-- 
2.45.2

