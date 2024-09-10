Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC95317C231;
	Tue, 10 Sep 2024 07:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725953453; cv=none; b=kazJcfF2sF2eErYy4KMsGYEX8CeWVH6ZOKo8RMYofvCXRuBVd4Bff8sJStAG3qPR+JprA7230f8v5k+2rRmvYEISU5OzqsoYuVDLu2OzsifMyH4on5pPXsBR0raH4YHmPVGAMeUJBjmnbqJpGAesMLrUSWnSWto80SbcbCtVBQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725953453; c=relaxed/simple;
	bh=9g6mH65weF44bLQevwU1JtpQ/d+yi8uM5z152woSbYc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/A0NUtzqsbHfI6xmDCnSvjbDthjjnXwc22BXqLbYAPYrcBEvDvMNLGBP/bq+tieevlwOq/+VHUG/17VzQXszioLHsJOdz3WGYKnqWJIz+rtPy7h+OM4pvU0eO9kLfi+iqJfXhYhXI1IsweZqQ3y0C4G5rxXIBw/C0j9mDC97tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=XYoSD9To; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="XYoSD9To"
X-UUID: 936a8c7e6f4611ef8b96093e013ec31c-20240910
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=LQLPSb8ldyG1OVVh0BB+yFOhjzNrq/gu6sGXkPkLj9A=;
	b=XYoSD9To7R83Di0pr6preyBmmIW6CEX08nva6ZokJfaEeOXgmIp4UPretQd+REZHo0Kwd1+QP7+IaVa8r+DrtjsM+d2e1aW7ffWxcWpeJBoWNEgJN7xPTh14vPdpYMPBheFeUXHW4DXOfna4S1xSUAN0Xd9s6jjOcJcZ3yQaTCE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:4e0ba635-d8cc-4f57-97fb-ffe18c057855,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6dc6a47,CLOUDID:da75f8cf-7921-4900-88a1-3aef019a55ce,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 936a8c7e6f4611ef8b96093e013ec31c-20240910
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1620826804; Tue, 10 Sep 2024 15:30:38 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 10 Sep 2024 00:30:37 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 10 Sep 2024 15:30:37 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<quic_nguyenb@quicinc.com>, <stable@vger.kernel.org>
Subject: [PATCH v4 1/2] ufs: core: fix the issue of ICU failure
Date: Tue, 10 Sep 2024 15:30:34 +0800
Message-ID: <20240910073035.25974-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240910073035.25974-1-peter.wang@mediatek.com>
References: <20240910073035.25974-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When setting the ICU bit without using read-modify-write,
SQRTCy will restart SQ again and receive an RTC return
error code 2 (Failure - SQ not stopped).

Additionally, the error log has been modified so that
this type of error can be observed.

Fixes: ab248643d3d6 ("scsi: ufs: core: Add error handling for MCQ mode")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bao D. Nguyen <quic_nguyenb@quicinc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-mcq.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 5891cdacd0b3..3903947dbed1 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -539,7 +539,7 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 	struct scsi_cmnd *cmd = lrbp->cmd;
 	struct ufs_hw_queue *hwq;
 	void __iomem *reg, *opr_sqd_base;
-	u32 nexus, id, val;
+	u32 nexus, id, val, rtc;
 	int err;
 
 	if (hba->quirks & UFSHCD_QUIRK_MCQ_BROKEN_RTC)
@@ -569,17 +569,18 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int task_tag)
 	opr_sqd_base = mcq_opr_base(hba, OPR_SQD, id);
 	writel(nexus, opr_sqd_base + REG_SQCTI);
 
-	/* SQRTCy.ICU = 1 */
-	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);
+	/* Initiate Cleanup */
+	writel(readl(opr_sqd_base + REG_SQRTC) | SQ_ICU,
+		opr_sqd_base + REG_SQRTC);
 
 	/* Poll SQRTSy.CUS = 1. Return result from SQRTSy.RTC */
 	reg = opr_sqd_base + REG_SQRTS;
 	err = read_poll_timeout(readl, val, val & SQ_CUS, 20,
 				MCQ_POLL_US, false, reg);
-	if (err)
-		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%ld\n",
-			__func__, id, task_tag,
-			FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
+	rtc = FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg));
+	if (err || rtc)
+		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%d RTC=%d\n",
+			__func__, id, task_tag, err, rtc);
 
 	if (ufshcd_mcq_sq_start(hba, hwq))
 		err = -ETIMEDOUT;
-- 
2.45.2

