Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7836115B966
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727259118; cv=none; b=hMAnFfllM+cd/ocPBfVWjrb3952VsmIoU7O6OPpL7zdlk3YeuAxPNwFO3KVgU41/rGcy6SL3kglCfa6+Pf3jd94XTetXYEyafzAKPg/pZPVf0RG/8icq84zdccqR5qIWqZtBF8wNmmxt55MNBNys94WmUMRG+/WFEi2n5S61oY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727259118; c=relaxed/simple;
	bh=yFGrwhTL7h3KlIChOJVg9xasvHKXUJbnGJ3TyKa/ZlI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h+ONAQW0/CkHoHwDNjxAWafkfaq1o95tlNPFOcS50QPqbDYckWqNvipiH7HliXB9RZLLfHHE1v54DJxJWyuRHuMc9S2qywYG1+Pyx//SlVJHVpdH7SH2U+ER6YnuWV14UJ+vN3JNJmTWtYiDWHgOv3msVQDganrTImyNewmNnNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GY15UL5r; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GY15UL5r"
X-UUID: 9409d5b87b2611efb66947d174671e26-20240925
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=MJnQKK/9GVFCpol62/YKdi7Bop9r1f03D07/z2b8dVI=;
	b=GY15UL5rFPRXr/Z1SUYsyi2gzkEUAUsz89RqWiXIaWS8bZULjvztgqIkodx7EEozSUB5Zi4iHVJ7oKe8S7kibXs0ZzJ+STqQBEg/ow7W8K+jqIiHT85ab1YoPeoYIT7QzOZetXa+ql8eRo4IM1vNV+fIKJJT/UP1PRtXfCSkjco=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.41,REQID:7d04bba9-310c-4d85-b6f5-d4495875fbd3,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6dc6a47,CLOUDID:90e68a9e-8e9a-4ac1-b510-390a86b53c0a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 9409d5b87b2611efb66947d174671e26-20240925
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 956276798; Wed, 25 Sep 2024 18:11:49 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 25 Sep 2024 03:11:47 -0700
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Wed, 25 Sep 2024 18:11:47 +0800
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
	<quic_nguyenb@quicinc.com>
Subject: [PATCH v9 3/3] ufs: core: add a quirk for MediaTek SDB mode aborted
Date: Wed, 25 Sep 2024 17:55:46 +0800
Message-ID: <20240925095546.19492-4-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240925095546.19492-1-peter.wang@mediatek.com>
References: <20240925095546.19492-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Because the MediaTek UFS controller uses UTRLCLR to clear commands
and fills the OCS with ABORTED, this patch introduces a quirk to
treat ABORTED as INVALID_OCS_VALUE.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c       | 5 ++++-
 drivers/ufs/host/ufs-mediatek.c | 1 +
 include/ufs/ufshcd.h            | 6 ++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 4fff929b70d6..d429817fca94 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5404,7 +5404,10 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp,
 		}
 		break;
 	case OCS_ABORTED:
-		result |= DID_ABORT << 16;
+		if (hba->quirks & UFSHCD_QUIRK_OCS_ABORTED)
+			result |= DID_REQUEUE << 16;
+		else
+			result |= DID_ABORT << 16;
 		dev_warn(hba->dev,
 				"OCS aborted from controller for tag %d\n",
 				lrbp->task_tag);
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 02c9064284e1..8a4c1b8f5a26 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1021,6 +1021,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
 	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_INTR;
 	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_RTC;
+	hba->quirks |= UFSHCD_QUIRK_OCS_ABORTED;
 	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
 
 	if (host->caps & UFS_MTK_CAP_DISABLE_AH8)
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 0fd2aebac728..8f156803d703 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -684,6 +684,12 @@ enum ufshcd_quirks {
 	 * single doorbell mode.
 	 */
 	UFSHCD_QUIRK_BROKEN_LSDBS_CAP			= 1 << 25,
+
+	/*
+	 * Some host controllers set OCS_ABORTED after UTRLCLR (SDB mode),
+	 * this quirk is set to treat OCS: ABORTED as INVALID_OCS_VALUE
+	 */
+	UFSHCD_QUIRK_OCS_ABORTED			= 1 << 26,
 };
 
 enum ufshcd_caps {
-- 
2.45.2

