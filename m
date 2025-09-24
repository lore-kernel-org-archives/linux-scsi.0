Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DFC2D94A5
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707141; cv=none; b=dA5rWGXAPBEgAeb+jR28hdoqNKgoFIgQ7pCIKuBt87+PW1a8a05amPRVxYag9oqzfRW9b9SpmJ32byfxVJUPL9IXQMCPMpYaOqCG3cWa3xVV22siWJK1Z0yNjrSZ9LB1gaNXTqQpYb4p2y+sxFkLNoCp69mjIx4OLNn021RPm2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707141; c=relaxed/simple;
	bh=QFKD3TCm/g1Zz65zX697GWB9lLvIjXaFRDtCZXDyaaU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YbBaSkSKps64DPgU8kZKabg+lzMKBgaNLgfvVKUm5MMdxUrs9pw01YdU+rSfDbRPKE1p3OmjququYCK0sVZ8TmhQ8Xg2X8DcOmuMavlQB1r6NvklaXmY7TOsaiJomKFXc/ytI9yaH0qw7UZmhpwO16GwtFmuiOp3nrKWAml7vt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=hKRQ2Ooa; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="hKRQ2Ooa"
X-UUID: 3520f1de992b11f0b33aeb1e7f16c2b6-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=FiNdLeHoJnnZ3Dpb8+NTfZ+NoFUFoMYMprvIzWFvdd8=;
	b=hKRQ2Ooa4RjhtYFmMsSGaKEzIdG9bypX5bYOTVkyLTAZbVpo7UXmvncbBJqo/3iHsdc3vddjPmfRDg8xhlOdgsb2nfvSbJ9eQYXSJwqD+2zZjzcpNXTr+ogoGr44PZ2iNArrVVF5diNXke5BK/ALqZaz89Xfpas8Uaq8LAVtFZY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:e840a146-3560-45e9-89aa-ade0b1a12c4a,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:1ca6b93,CLOUDID:43ffa1e9-2ff9-4246-902c-2e3f7acb03c4,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 3520f1de992b11f0b33aeb1e7f16c2b6-20250924
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1468790475; Wed, 24 Sep 2025 17:45:30 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:45:28 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1748.10 via Frontend Transport; Wed, 24 Sep 2025 17:45:29 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v2 4/8] ufs: host: mediatek: Adjust sync length for FASTAUTO mode
Date: Wed, 24 Sep 2025 17:43:26 +0800
Message-ID: <20250924094527.2992256-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250924094527.2992256-1-peter.wang@mediatek.com>
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
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

Set the sync length for FASTAUTO G1 mode in the UFS Mediatek
driver. This ensures the sync length meets minimum values
for high-speed gears, improving stability during power mode
changes.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 32 ++++++++++++++++++++++++++++++++
 include/ufs/unipro.h            |  7 ++++++-
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 1dcc0c7c9f9b..2a69b4cede22 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1332,6 +1332,36 @@ static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba *hba,
 	return true;
 }
 
+static void ufs_mtk_adjust_sync_length(struct ufs_hba *hba)
+{
+	int i;
+	u32 value;
+	u32 cnt, att, min;
+	struct attr_min {
+		u32 attr;
+		u32 min_value;
+	} pa_min_sync_length[] = {
+		{PA_TXHSG1SYNCLENGTH, 0x48},
+		{PA_TXHSG2SYNCLENGTH, 0x48},
+		{PA_TXHSG3SYNCLENGTH, 0x48},
+		{PA_TXHSG4SYNCLENGTH, 0x48},
+		{PA_TXHSG5SYNCLENGTH, 0x48}
+	};
+
+	cnt = sizeof(pa_min_sync_length) / sizeof(struct attr_min);
+	for (i = 0; i < cnt; i++) {
+		att = pa_min_sync_length[i].attr;
+		min = pa_min_sync_length[i].min_value;
+		ufshcd_dme_get(hba, UIC_ARG_MIB(att), &value);
+		if (value < min)
+			ufshcd_dme_set(hba, UIC_ARG_MIB(att), min);
+
+		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(att), &value);
+		if (value < min)
+			ufshcd_dme_peer_set(hba, UIC_ARG_MIB(att), min);
+	}
+}
+
 static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 				const struct ufs_pa_layer_attr *dev_max_params,
 				struct ufs_pa_layer_attr *dev_req_params)
@@ -1355,6 +1385,8 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	}
 
 	if (ufs_mtk_pmc_via_fastauto(hba, dev_req_params)) {
+		ufs_mtk_adjust_sync_length(hba);
+
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), true);
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), UFS_HS_G1);
 
diff --git a/include/ufs/unipro.h b/include/ufs/unipro.h
index 360e1245fb40..498ec9028b3c 100644
--- a/include/ufs/unipro.h
+++ b/include/ufs/unipro.h
@@ -111,6 +111,9 @@
 #define PA_TXLINKSTARTUPHS	0x1544
 #define PA_AVAILRXDATALANES	0x1540
 #define PA_MINRXTRAILINGCLOCKS	0x1543
+#define PA_TXHSG1SYNCLENGTH	0x1552
+#define PA_TXHSG2SYNCLENGTH	0x1554
+#define PA_TXHSG3SYNCLENGTH	0x1556
 #define PA_LOCAL_TX_LCC_ENABLE	0x155E
 #define PA_ACTIVETXDATALANES	0x1560
 #define PA_CONNECTEDTXDATALANES	0x1561
@@ -160,7 +163,9 @@
 #define PA_PACPFRAMECOUNT	0x15C0
 #define PA_PACPERRORCOUNT	0x15C1
 #define PA_PHYTESTCONTROL	0x15C2
-#define PA_TXHSADAPTTYPE       0x15D4
+#define PA_TXHSG4SYNCLENGTH	0x15D0
+#define PA_TXHSADAPTTYPE	0x15D4
+#define PA_TXHSG5SYNCLENGTH	0x15D6
 
 /* Adpat type for PA_TXHSADAPTTYPE attribute */
 #define PA_REFRESH_ADAPT       0x00
-- 
2.45.2

