Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40ACF28BAB0
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153743; cv=none; b=DX3iJsF5ZlIt5DbFaSii7H8bMmzlX2TZkqXRnAwMW9nTMCx2X3jHqPSv+8TqYIl868b0bJTaA7M3HtH1W0GQ/WsCiA8SLBbhwzuL51ie/46BFLMiQM23HAORS3kck5OEMYhxfg/ZYJg31cE7aoLYdInAQapLLdDmrk9j9Yb/8ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153743; c=relaxed/simple;
	bh=MvkH86q48mYlCbiK1+aShGM34kd8m7o0xjkZBfe3Cx0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H93fYkJlUh7l7oIQZZYqVBnZUR5c3rWfZqB7zlpjIcTNxqExtYpxvZ+Is3nbgkEQmrsEfpowAhpu7cvJB8DxgMj4UVpGRpSG8UUT4NDGATxsASaKHz+u5++POKml/zexYRouJ1KYOWf4Gef5n9fE1mJ2cfBySY0/57lvO1fWVK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=KQ6Y01g7; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="KQ6Y01g7"
X-UUID: 2e9be58a66a911f0b33aeb1e7f16c2b6-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=x/w5Y95ZDYGlYKLn2y+WMk8U4o4cEs44DcybgpkTwS8=;
	b=KQ6Y01g7Il4+3Z1Mie4BW0A5cS4UzZLC8KRHgbcBkWTNcCMQDrsNni1SdJV30V5uwroaCpdOpT2bJyZ89WsY8sMefJxssgu5TMQKRaoE5dod3Ys7ph9bhROFnxU8yZXc3RWMrOCjGXV66esiFBZjkL/3JLriLqQDMS2+hrCM/7E=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:9068bdd9-8463-407b-8716-82f7961d9f7d,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:9eb4ff7,CLOUDID:737d080f-6968-429c-a74d-a1cce2b698bd,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2e9be58a66a911f0b33aeb1e7f16c2b6-20250722
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 111648927; Tue, 22 Jul 2025 11:08:46 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 11:08:42 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 11:08:42 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v4 3/9] ufs: host: mediatek: Change ref-clk timeout policy
Date: Tue, 22 Jul 2025 11:07:18 +0800
Message-ID: <20250722030841.1998783-4-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250722030841.1998783-1-peter.wang@mediatek.com>
References: <20250722030841.1998783-1-peter.wang@mediatek.com>
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

This patch updates the timeout policy for ref-clk control.

- If a clock-on operation times out, it is assumed that the clock is
  off. The system will notify TFA to perform clock-off settings.
- If a clock-off operation times out, it is assumed that the clock
  will eventually turn off. The 'ref_clk_enabled' flag is set directly.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 90351fff501c..b30203d83ef1 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -351,7 +351,16 @@ static int ufs_mtk_setup_ref_clk(struct ufs_hba *hba, bool on)
 
 	dev_err(hba->dev, "missing ack of refclk req, reg: 0x%x\n", value);
 
-	ufs_mtk_ref_clk_notify(host->ref_clk_enabled, POST_CHANGE, res);
+	/*
+	 * If clock on timeout, assume clock is off, notify tfa do clock
+	 * off setting.(keep DIFN disable, release resource)
+	 * If clock off timeout, assume clock will off finally,
+	 * set ref_clk_enabled directly.(keep DIFN disable, keep resource)
+	 */
+	if (on)
+		ufs_mtk_ref_clk_notify(false, POST_CHANGE, res);
+	else
+		host->ref_clk_enabled = false;
 
 	return -ETIMEDOUT;
 
-- 
2.45.2

