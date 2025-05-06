Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC31E27A478;
	Tue,  6 May 2025 12:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746535255; cv=none; b=sMmE6fYrkddbDhi4fEtUsI1RgRPoER2UhkB21+skhCzJWzwGhIBG7tQsHwGqddsf367uLlEj7cpA49CDZNk9fyRtcsV3l472a6kaXSD21x3wWmwlm5ID5lIfoBdUQWU40/hmEyZF/GptHCdTGa4YRU29lM0XcfIzzgnBWG0T7GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746535255; c=relaxed/simple;
	bh=hvEomEsZmTMlnPOhDxP1M7vexVqaFcHupXC1pSGzLZ8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rUnqWR4+kHX/bFmd2nWLh35RGAMxUpqma5skAjkDNdr7Het+3yZyMyjKNlFswCdo5sGu3AdLmVKVx4j4RjAGLD/Afb62LnrhpUog4Z9L3Qm+HqW3gE8pr63y97avDJtED7XKSWo8oa+pbHBhYkkT8D0TR+diwOFmSxtqYeWAVSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dTy/Fbx8; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dTy/Fbx8"
X-UUID: 51c055aa2a7711f082f7f7ac98dee637-20250506
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=InDdJP1K/CvYoSdBcXs4MwVOY78WNNJUgbJvEKFhfOI=;
	b=dTy/Fbx8P4XstKqjN3kNnwe7etjqH4AJNF4o+aBx9ardTe4vCPjppQBQnEl2t8bD8KbH5/G8clGtXJi58vMPNOIwuoidis1vSsztYfQbWV0DUySasFKEsCkxmDVPa+xCAw4c3PmmnThD/Xmcc/WXq2EYKPce/jCf6LnE5CkzMdo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.2.1,REQID:4b831b03-3081-4559-b94b-536c23d06a63,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:0ef645f,CLOUDID:4de478d4-9212-47de-8197-a0cdeb9ca45c,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:ni
	l,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 51c055aa2a7711f082f7f7ac98dee637-20250506
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1064041535; Tue, 06 May 2025 20:40:40 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 6 May 2025 20:40:39 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 6 May 2025 20:40:39 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<quic_ziqichen@quicinc.com>, <stable@vger.kernel.org>
Subject: [PATCH v1] ufs: core: fix hwq_id type and value
Date: Tue, 6 May 2025 20:39:34 +0800
Message-ID: <20250506124038.4071609-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

Because the member id of struct ufs_hw_queue is u32 (hwq->id) and
the trace entry hwq_id is also u32, the type should be changed to u32.
If mcq is not supported, SDB mode only supports one hardware queue,
for which setting the hwq_id to 0 is more suitable.

Fixes: 4a52338bf288 ("scsi: ufs: core: Add trace event for MCQ")
Cc: <stable@vger.kernel.org>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7735421e3991..14e4cfbcb9eb 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -432,7 +432,7 @@ static void ufshcd_add_command_trace(struct ufs_hba *hba, unsigned int tag,
 	u8 opcode = 0, group_id = 0;
 	u32 doorbell = 0;
 	u32 intr;
-	int hwq_id = -1;
+	u32 hwq_id = 0;
 	struct ufshcd_lrb *lrbp = &hba->lrb[tag];
 	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct request *rq = scsi_cmd_to_rq(cmd);
-- 
2.45.2

