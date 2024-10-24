Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DF31BDDF;
	Thu, 24 Oct 2024 01:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729734902; cv=none; b=u0QJTGGh/3+tFLhVF97b65A7nUXxAXkwvo8MO4onWnHQpmorxdS2MJGpD9LcGb7FDbUnqduYAzsKkFo9bdEl0PA5zg/UWsLCjehq066KiyezMHjf/Ds1A4fHpP+EoRq3b8ZkYKlIAG5va5mr1d4N/56vKnO4QvC1Q6gZXd4NgLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729734902; c=relaxed/simple;
	bh=VKjnzWViqaacwxmVr+4DEPsTuDpMIYUv315O6plHzSI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nIwmBVKrHnvQmAeP9zx8cslbH8u7QFWe6OEdfLGA1ZGjpnof9rINxav3mfEqCn+F9wGTrAbpoVd2PnMAS8LiW/6JMwR91TkCbwbVKTyW3iau1riF6iXk1TRnV6x+vzbgFC7Fc/VklwlHwS6ZwBBlpwKfhJ03MpADRnrOdnUTJzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Z0awVBZk; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Z0awVBZk"
X-UUID: f83cbaa691aa11efb88477ffae1fc7a5-20241024
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=3CpmCRaf0iN6t3tO+rXWbvSp6h4e8oWCGaYzYX07O2A=;
	b=Z0awVBZks7GuVW/SHkBi3mRApiP49nHwGW4yll79KuZnr/qlvqakGKtjlNdfLrqR9qkOMBAOAr50l0IiJbI2/1JqCfNOcnFb5ICOKmk3WukZFEGrSpwN4//RRRNEeduHWVto93JtZnrw0i77p2DfObmsvHqSxPgHuiEnAMUo5+A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:91de5430-dabc-4fe0-bedd-c4a9f9ab4eb7,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:b0fcdc3,CLOUDID:438fbd41-8751-41b2-98dd-475503d45150,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: f83cbaa691aa11efb88477ffae1fc7a5-20241024
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1438409549; Thu, 24 Oct 2024 09:54:56 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 23 Oct 2024 18:54:55 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 24 Oct 2024 09:54:55 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
	<beanhuo@micron.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>,
	<stable@vger.kernel.org>
Subject: [PATCH v2] ufs: core: fix another deadlock when rtc update
Date: Thu, 24 Oct 2024 09:54:53 +0800
Message-ID: <20241024015453.21684-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When ufshcd_rtc_work calls ufshcd_rpm_put_sync and the pm's
usage_count is 0, it will enter the runtime suspend callback.
However, the runtime suspend callback will wait to flush
ufshcd_rtc_work, causing a deadlock.
Replacing ufshcd_rpm_put_sync with ufshcd_rpm_put can avoid
the deadlock.

Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
Cc: <stable@vger.kernel.org> #6.11.x
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a63dcf48e59d..f5846598d80e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8219,7 +8219,7 @@ static void ufshcd_update_rtc(struct ufs_hba *hba)
 
 	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR, QUERY_ATTR_IDN_SECONDS_PASSED,
 				0, 0, &val);
-	ufshcd_rpm_put_sync(hba);
+	ufshcd_rpm_put(hba);
 
 	if (err)
 		dev_err(hba->dev, "%s: Failed to update rtc %d\n", __func__, err);
-- 
2.18.0

