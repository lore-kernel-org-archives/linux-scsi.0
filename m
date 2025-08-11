Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7701A2DC34A
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918078; cv=none; b=V1ojix6K+q6npOhlC/EdvLw3sM/9SqT8fx7KnFHcH1CgFvWCQENqavbbP0TTsaPW9tEVcNtVEH/YVK7To5ijIfzFblgzgx23W0aTJFUm4q77O1gqvGSdLdXXk37E6tEgjJSBI8W4LA7TYZ9nFLZp84kGP+arTtX4LHVjvAgKlkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918078; c=relaxed/simple;
	bh=GPuLZswiOifDMN21txov4aSLo4Q20VzlL63I3XdCN7c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RO4dxNih4hv7Z6lVkbHXYt70WaIU3POMm9wqbsx/U022zK4PBkBGnTp0lSN4ZGyvV6KB2vF92B5tANrEqCyq2XPYq0b1/P4tl23QJ1xM3+r0qSUESh78mzMLZ8CNWM0Pk6KxC0kk2suyZ7I3Cq6MtcF5PxEcVw0eXcz2MiFxzX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=bnR1dH0c; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="bnR1dH0c"
X-UUID: 1b71332276b511f08729452bf625a8b4-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Q6XkUygVqVvbimaOublF5EYtr6zrC6aN1cJAVWuDYcE=;
	b=bnR1dH0cEMmT0H6IzPvXQHa21P+OON5qyy+Cax5Ox6iyMTk09VE42CIAKF+P5qBJtI7qehVtM3XK8y0iTtlMKEdJ0mhN3pervgriVRq6wj4U5+4J4FlSHJUxgIf8w9kv8GhJgn83W7MtQ0KlO0c6+rslS40qp3izIFALZqhoYys=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:1e6f51fd-e871-4aeb-8307-525966ecc9da,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:956bd29d-7ad4-4169-ab95-78e9164f00fe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b71332276b511f08729452bf625a8b4-20250811
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 862461304; Mon, 11 Aug 2025 21:14:27 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:25 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 07/10] ufs: host: mediatek: Optimize power mode change handling
Date: Mon, 11 Aug 2025 21:11:23 +0800
Message-ID: <20250811131423.3444014-8-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250811131423.3444014-1-peter.wang@mediatek.com>
References: <20250811131423.3444014-1-peter.wang@mediatek.com>
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

This patch optimizes the power mode change process by skipping the
adaptation setting toggle if the requested power mode configuration
is already applied. This enhancement reduces unnecessary operations,
improving efficiency during power mode transitions.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 517c26362ac6..d9f582e3e72b 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1398,6 +1398,17 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		}
 	}
 
+	/* if already configured to the requested pwr_mode, skip adapt */
+	if (dev_req_params->gear_rx == hba->pwr_info.gear_rx &&
+	    dev_req_params->gear_tx == hba->pwr_info.gear_tx &&
+	    dev_req_params->lane_rx == hba->pwr_info.lane_rx &&
+	    dev_req_params->lane_tx == hba->pwr_info.lane_tx &&
+	    dev_req_params->pwr_rx == hba->pwr_info.pwr_rx &&
+	    dev_req_params->pwr_tx == hba->pwr_info.pwr_tx &&
+	    dev_req_params->hs_rate == hba->pwr_info.hs_rate) {
+		return ret;
+	}
+
 	if (dev_req_params->pwr_rx == FAST_MODE ||
 	    dev_req_params->pwr_rx == FASTAUTO_MODE) {
 		if (host->hw_ver.major >= 3) {
-- 
2.45.2

