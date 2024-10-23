Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A9414D2AC;
	Wed, 23 Oct 2024 13:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729689558; cv=none; b=N852ISuqXrtzx+ATJeP112IrdfdCup1+aMunS5lm94RYoMZu8uuOgXdhTmVaTpR6hbx15Ki4RYuKW+heH6+y+aJJ23PaF+HOlB0w1Cmy1r+A/bzOYXYK7pvL7yp1rYfre+pKYXDz61p8MQcZwqlzO1bdxyBbh4S7mNxo0MiYalk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729689558; c=relaxed/simple;
	bh=D81vbdxCRZJcfgxt2LqldgILeZKab/LHhk16jE7ROYI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nxtjn71dozI7Wrx6URoIHJT0uxZUndYCNlkSsWS8I4M9hr3WHTlyE3Dz+CRdm4i6YH9NmIeZWNV7hF69gp+3r3euRmiu5C3vhbGEuI/b3VfLPw0lhqfYi4MORBswL1X1qoVo1I994wkIKdC9mzicnboYpdZMlQ8+2uvKdV+N+uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TmZDJNVW; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TmZDJNVW"
X-UUID: 61972ff0914111efb88477ffae1fc7a5-20241023
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=dDkakBKHHeSI6Ly6LRF1kpJRycLvpXUtBSp9373LIMA=;
	b=TmZDJNVW8m0KhcHfqXzqZOICWgSTID33NP8R64NHVrl1sVLeY+m2Ojn23QOtKF4NEpLk76UKoO9z3cHrYJh705hX0zDsGc8CmT91wjbKhI0nq8f2bewNo3oxEJy4KTjVJ5Ni+HJ1cuJYeiyg/B9pK1Ps5U+BldtON1WZHWn9vHc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.42,REQID:634ad587-8f0c-4fe2-8ff5-493b87b6fefc,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:b0fcdc3,CLOUDID:7f09bfcc-110e-4f79-849e-58237df93e70,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 61972ff0914111efb88477ffae1fc7a5-20241023
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 864402913; Wed, 23 Oct 2024 21:19:06 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 23 Oct 2024 21:19:05 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 23 Oct 2024 21:19:05 +0800
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
Subject: [PATCH v1] ufs: core: fix another deadlock when rtc update
Date: Wed, 23 Oct 2024 21:19:04 +0800
Message-ID: <20241023131904.9749-1-peter.wang@mediatek.com>
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
Cc: <stable@vger.kernel.org> 6.11.x

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
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

