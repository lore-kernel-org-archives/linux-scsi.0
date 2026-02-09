Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D752459EA
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 12:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770639672; cv=none; b=vFTo5SZqY9yh7GtmBXI++GfwNC58NLQERsgfmP8U0AbhETOCEeVPp0W10wViuxO0DR6JCHdDSD8CWEVmuy12z7gYifoE3jia1aaqQLgnihLsA7f0B8llub57skVoZCvg3WyasDpePvlDKJZ/Hna6yqyvwheAG5z0MnhGq8a11Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770639672; c=relaxed/simple;
	bh=iMmlHBI0m8U0KV1shSkNZJhKeIT0eacbw2TawcYbfqE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=se31FygsXehwPohyr4jg9navrbVKjVfYslYfr+z5Em39sy99+IDvocKdpMNT9TvPPKpieOEARN+aNaiIdXHekks1r+M/mWHgv4KwHZItTtBZx/PPk39QboauO5E0S7OpB3DpbbBzP4e9TPbYhH8OBoZmgMQryoYpZrdz4UbuQHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=rnVOYM7j; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="rnVOYM7j"
X-UUID: cd5c2e3a05b111f1b7fc4fdb8733b2bc-20260209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=uYHdjwe6Z2tYVFm2NU+tRR4i/B4PB/vlm+8kwLkkP6w=;
	b=rnVOYM7jZvQe+kKaQj/i08fAUZZVCCHVPwgbkyxFPjx1fx6dsihpPG4NwJwv8dynJebDQgMzTkwpyLnuc8ToeJCfyYyHsd1QyJI5WPBty0s00O2xnRf1rUVgoSQ2K9680LLyc57zLKa2UIuFXNsv3KFyPDbPVYuV3yMA4NQUkMM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:89a8425b-cf16-4dc6-9013-22ccc0e33438,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:4ef77ae9-ef90-4382-9c6f-55f2a0689a6b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: cd5c2e3a05b111f1b7fc4fdb8733b2bc-20260209
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1080369864; Mon, 09 Feb 2026 20:21:03 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Feb 2026 20:21:03 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 9 Feb 2026 20:21:03 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1] ufs: core: support UFS 4.1 CQ entry tag
Date: Mon, 9 Feb 2026 20:20:37 +0800
Message-ID: <20260209122101.1529379-1-peter.wang@mediatek.com>
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

The UFS 4.1 specification introduces a new completion queue(CQ)
entry format, allowing the tag to be obtained directly.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufs-mcq.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index ad0ada57959a..d8b5cf18a01c 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -273,13 +273,18 @@ void ufshcd_mcq_write_cqis(struct ufs_hba *hba, u32 val, int i)
 EXPORT_SYMBOL_GPL(ufshcd_mcq_write_cqis);
 
 /*
- * Current MCQ specification doesn't provide a Task Tag or its equivalent in
+ * UFS 4.0 MCQ specification doesn't provide a Task Tag or its equivalent in
  * the Completion Queue Entry. Find the Task Tag using an indirect method.
+ * UFS 4.1 and above can directly return the Task Tag in the Completion Queue
+ * Entry.
  */
 static int ufshcd_mcq_get_tag(struct ufs_hba *hba, struct cq_entry *cqe)
 {
 	u64 addr;
 
+	if (hba->ufs_version >= ufshci_version(4, 1))
+		return cqe->task_tag;
+
 	/* sizeof(struct utp_transfer_cmd_desc) must be a multiple of 128 */
 	BUILD_BUG_ON(sizeof(struct utp_transfer_cmd_desc) & GENMASK(6, 0));
 
-- 
2.45.2

