Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0433D14B084
	for <linux-scsi@vger.kernel.org>; Fri, 23 Aug 2024 10:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724407637; cv=none; b=oPA1epbcffdXyxTP2tCok/CcmkA8uI7ueEibxRuuUPBw5oWL676+80dLR77UbwMr2r8qNO4pOrBuYGTjZg5XsNeZ7+UmnMRidWJ0RGiMB80F5sR+Qm7oAxkas6PbtF+DZZqD0UXE379Neu0GVck8YEEXGvrKOe0FA+ig8KaxoDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724407637; c=relaxed/simple;
	bh=cKbPcPstO0h8+7w6vFc+G/W5pc9nMbsvCqi2Jvjk01o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kv++iEIp+ZfmsPufhXjmw0BoCPYP4xbr5uaEgtsScuW1SqYZlkM5qZ5FTOaD0LoBTtqjWWXk4a7E4QbhFM17fGpf19sPhQJeD3Uz+H08aYW1dzkC5kobtJhHpkyHQsafWycRfSWVqtVAsdHmV+PzUro8E2u5vgO3K04Bw817a1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bG9VRaXj; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bG9VRaXj"
X-UUID: 754e47f2613711ef8b96093e013ec31c-20240823
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=BHQfDfVAG+zH+Zezl57mlF3FkhhDLa4SwRr4U7LlRF0=;
	b=bG9VRaXjDU2agL2JNvJ7ue5OewAsjAgX5CapZ+AdPvEcXshNV7Bry9RA2qyxfubVaydFPci3cSsVBruXAZxq4KcPqNrribw7irCnnc9LQJhPlcSk9SzohQEoDcOAqi+rfirw7lGV95a3VTrNRKUTVvfTI2hb2kqDZ73KAUlKt0M=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:aa797c32-39be-47cc-84b2-613e1bdc6b0c,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6dc6a47,CLOUDID:ebb411cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: 754e47f2613711ef8b96093e013ec31c-20240823
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 862549262; Fri, 23 Aug 2024 18:07:09 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 23 Aug 2024 03:07:10 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 23 Aug 2024 18:07:09 +0800
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
Subject: [PATCH v1 2/2] ufs: core: force reset after mcq abort all
Date: Fri, 23 Aug 2024 18:07:07 +0800
Message-ID: <20240823100707.6699-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240823100707.6699-1-peter.wang@mediatek.com>
References: <20240823100707.6699-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

In mcq mode gerneal case, cq (head/tail) poniter is same as
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

