Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9E92F6164
	for <linux-scsi@vger.kernel.org>; Tue, 26 Aug 2025 06:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756189412; cv=none; b=CZLOwxB/nAtPbgLZ8VzI7avoEnKbgVFKaqeb6N6u/QHsrxtez6JZfl/Hiy233foLSIebocfT8eGwINGatpu2Kw0ee1+u+nmu/rYOEQHgERaHL8sj2Y17M86SJc8v/taE0dHRTFsUDamXSG36kVvv2RJ3CfaNXqoWHBJGZdg4Qqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756189412; c=relaxed/simple;
	bh=YLRwI6BHgvwUKGeq5o9UJBYPBEAd1QDVZJ9eyweghpQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G6zSzk/KMEoMv0LjgHiHbATFKA0mD7TYOmb6eYyU7heFHi36dO8wssLnHatQBtTTFRlF77v63CBTF3Zb/rM0xH3GMHQwEu5++nM1D6Jg9axuJX1LhOzaN5nj5GzgfvTQrXQacJWus5NmhMwVAhuYILyZT/UUrZjnf78C6JsWbtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=awqt/9my; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="awqt/9my"
X-UUID: 28a4aaa6824511f0b2125946c7b33498-20250826
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=3s6gwBrD3rmyl0bovRc9IX9GcPd2zgMDwRhR97ekBng=;
	b=awqt/9myU4diwVx1u5iZ3EQDXG5B1RCPBnioEG+k2TpfQ70tIJBrLHhGvQBuANTvUH4RJ/TOjU0Q/e0ugn3K/fA0YHXQwi/fMHoAPiWSI4tugapJvPRBCtlKxTH6+fJtxF2wlCF0VjR/s9wCLgjIxwyxF9v7giHpSDFfgZcxsEk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:ee1ff076-ec23-49d6-88d6-18527f89679d,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:a2e09d6d-c2f4-47a6-876f-59a53e9ecc6e,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 28a4aaa6824511f0b2125946c7b33498-20250826
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1941481803; Tue, 26 Aug 2025 14:23:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 26 Aug 2025 14:23:18 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 26 Aug 2025 14:23:18 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>,
	<bvanassche@acm.org>
Subject: [PATCH v2 10/10] ufs: host: mediatek: Fix device power control
Date: Tue, 26 Aug 2025 14:22:24 +0800
Message-ID: <20250826062314.3070425-11-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250826062314.3070425-1-peter.wang@mediatek.com>
References: <20250826062314.3070425-1-peter.wang@mediatek.com>
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

This patch adjusts the timing of device power control to ensure
that low power mode (LPM) is entered only after VCC is turned off.
This change prevents VCCQ/VCCQ2 from entering LPM prematurely,
ensuring proper power management and device stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index af5574ac0b3c..758a393a9de1 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -2342,6 +2342,13 @@ static int ufs_mtk_probe(struct platform_device *pdev)
 		host->phy_dev = phy_dev;
 	}
 
+	/*
+	 * Because the default power setting of VSx (the upper layer of
+	 * VCCQ/VCCQ2) is HWLP, we need to prevent VCCQ/VCCQ2 from
+	 * entering LPM.
+	 */
+	ufs_mtk_dev_vreg_set_lpm(hba, false);
+
 out:
 	of_node_put(phy_node);
 	of_node_put(reset_node);
-- 
2.45.2

