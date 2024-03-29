Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20232231C
	for <linux-scsi@vger.kernel.org>; Fri, 29 Mar 2024 01:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711677047; cv=none; b=J78BgA8aW0JpWF5K4V3mgZ85AlRRuHYTeZpB0c7t85V2KsT02blvu0ltlKYfgzQIhvh2m7N+krah9x9UD9pF7uSadkAv2uXN+dq8yNQ3nRoutSvPCOyp4QIBasgJ7QXOIhitAgvjYgPuNBTfJVFYfUFEzgU+7fpzBA6ZKdocLeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711677047; c=relaxed/simple;
	bh=To3QkPHzSnm4j2jryHrdTn+vkD84RZT448tUNWgF6UQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=feUF17R+doGdQoYuEl7rXwhyp9Pv3y3JUaUHIwP2gGvgUQEb0sPVn+eHpea+LVza+yoJv5hJ/pttb5S0vHD+6Z67mniLG0+wpHaTlDznlk1IBHYhfvoZ0zi8k/EWlfzJFHPpnBFWp8/afYO7ML5wJGtc38GyPg3dzuWqhfVbFEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ZYMtxWa/; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ZYMtxWa/"
X-UUID: bf2657b2ed6e11ee935d6952f98a51a9-20240329
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=JFeBk0+DU89vq1hnnaI6Bl2UJs+AoSLPwHXjH8VzhJc=;
	b=ZYMtxWa/DQkQkb2okA5e8dQhKKRHNEeonRrEwuughBkwtl6a10IghucEGzzseYEPNZTTaDjzlKMeA+GcttyVl81LFaD9R/SvNnzxj3n3CcAIlFncbG6fBcZJ2DUf6hhkOdyWts1AJlp7IP0qaoyvKjPMBSxFHk99BTEMdVOyHfc=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:f476e0c6-d48e-4773-9096-dc78b1fdf6fa,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:6f543d0,CLOUDID:56e87400-c26b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_ULN,TF_CID_SPAM_SNR
X-UUID: bf2657b2ed6e11ee935d6952f98a51a9-20240329
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1996315744; Fri, 29 Mar 2024 09:50:40 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 29 Mar 2024 09:50:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 29 Mar 2024 09:50:38 +0800
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
Subject: [PATCH v2] ufs: core: wlun suspend dev/link state error recovery
Date: Fri, 29 Mar 2024 09:50:36 +0800
Message-ID: <20240329015036.15707-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--4.622500-8.000000
X-TMASE-MatchedRID: ivhBngArENGAAYHsHSPDcxn0UD4GU5IqKx5ICGp/WtEmu2XKsBcW8RUO
	nrDGROOdLqWDA5QpvGM5QOj/9mEf0+DjmHulaCpRKaMQ6tw7oDJMkOX0UoduuQqiCYa6w8tv0Qx
	Bl5kNTScp3hgx44GaWoAGGZdCG6IYHxPMjOKY7A8LbigRnpKlKTpcQTtiHDgWU4F/Jt8R932aVJ
	EcZrHk0BlgnfyUVZLGJaK2yJXqOmyluwNqrgYVCguKdSkv7OH9i00MVOIfvt402JboeFS9LaIYp
	U3TtDF2wZBgUyJVEbl6Fw8/PpTMRaVvmiAyeA2kc5MSfkiJFI5QBJtcKcOYfpRMZUCEHkRt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.622500-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 707F0AFAE786535E85E36500F0A0D11221CD9D1ADC9505F9C3C461812A0605812000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

When wl suspend error occurs, for example, BKOP or SSU timeout, the host
triggers an error handler and returns -EBUSY to break the wl suspend process.
However, it is possible for the runtime PM to enter wl suspend again before
the error handler has finished, and return -EINVAL because the device is
in an error state. To address this, ensure that the rumtime PM waits for the
error handler to finish, or trigger the error handler in such cases,
because returning -EINVAL can cause the I/O to hang.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e30fd125988d..292b06f361a2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9791,7 +9791,10 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	/* UFS device & link must be active before we enter in this function */
 	if (!ufshcd_is_ufs_dev_active(hba) || !ufshcd_is_link_active(hba)) {
-		ret = -EINVAL;
+		/*  Wait err handler finish or trigger err recovery */
+		if (!ufshcd_eh_in_progress(hba))
+			ufshcd_force_error_recovery(hba);
+		ret = -EBUSY;
 		goto enable_scaling;
 	}
 
-- 
2.18.0

