Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7756258EE1
	for <linux-scsi@vger.kernel.org>; Mon,  9 Feb 2026 08:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770625870; cv=none; b=Kbvl8sBWMXQX+/7qXI/AgUJi2DioffwUVB34O7WqzkqHJ5/EItwqgVjyOr2zX4aYLY1QM1DBOyYe5/wKQr1aEm94LV97vptSryTTqMRjycIgFNMpps0pQuIHr7Gf4JczIyCfpOxNYiigc5Z2m3iaj3iHuRl/+LRhWC547JoixPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770625870; c=relaxed/simple;
	bh=xv8+LYzdnjbbbGq+6ZeINf8vOAbjFSs5BKGsCFW0WZQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4qs2sRB+QUTb/T5s6NPq7xHNGA3VitPeUQJPGktgjeX5yy0DHYQquweXgkjtV1uIvA4o8XCf9ihEPYhJofxHDfNM+vHpiMDgTHpaJs3jYvf1a+ek9m90BRZ/9/fqHxeQi33Bip0v5JE0MuqL0xez7r7jLYH5S5G8ppGTS61eNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=TZ5UyrEG; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="TZ5UyrEG"
X-UUID: a7894668059111f185319dbc3099e8fb-20260209
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=rbnBCI5kFYUDAvzmdDZ+LPmZZWAhzsgOBo5AF9tO3eM=;
	b=TZ5UyrEG00rivC7CMzGc0f7xR+2ICcKtfZx9szXr/nZeY93PRe4K6kK098Cq4E47vegCIuKOmc59vjzHfBoLBVkjXySM4l+s8FcPyMLxVF/8QR4eocWko7Lr7aDeu3Raww47bRWHwWwJMU+B3oxpvGjGZ6kPQK73MmuLxJQ1+E8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:357e0daf-5d08-43e5-9443-20f07ae37e15,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:8cd4165b-a957-4259-bcca-d3af718d7034,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|123|836|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: a7894668059111f185319dbc3099e8fb-20260209
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1135883578; Mon, 09 Feb 2026 16:30:56 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 9 Feb 2026 16:30:55 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 9 Feb 2026 16:30:55 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v1 1/2] ufs: core: add debug log for uic commnad timoeut
Date: Mon, 9 Feb 2026 16:28:47 +0800
Message-ID: <20260209083053.1467647-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260209083053.1467647-1-peter.wang@mediatek.com>
References: <20260209083053.1467647-1-peter.wang@mediatek.com>
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
index 604043a7533d..8c3d13f59cf5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5564,8 +5564,11 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 
 	guard(spinlock_irqsave)(hba->host->host_lock);
 	cmd = hba->active_uic_cmd;
-	if (!cmd)
+	if (!cmd) {
+		dev_err(hba->dev,
+			"No active_uic_cmd, may timeout and be cleared.\n");
 		return retval;
+	}
 
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
 		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-- 
2.45.2

