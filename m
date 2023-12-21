Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2A34555
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="t38WXDDH"
X-UUID: b0a0dc4c9ff011eea5db2bebc7c28f94-20231221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=wnMnp7U7Ka2iy4vdDrI57MQqW8gqRkoFcBs89KNVKw4=;
	b=t38WXDDH3L2cs/D+ZicJWMIfJyzqKEUuIP2anfwc94pqfqI9zn7nX7ca4eqmYqPd5TO5I7i0LEvyBa6rgQ+d6E4hDPK+KiBFeY3ZMFy0ltgRnlYLCxndoCV3qUS9L4Ic+YYQOkKgjXrHkAnzAnsVf2vgZ++dS7Nv2RfrpCS25mA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:135b90d8-1bd9-4ff0-a01f-1af640b6d362,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:63c56c8d-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: b0a0dc4c9ff011eea5db2bebc7c28f94-20231221
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1663898122; Thu, 21 Dec 2023 19:04:19 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Thu, 21 Dec 2023 19:04:18 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Thu, 21 Dec 2023 19:04:18 +0800
From: <peter.wang@mediatek.com>
To: <chun-hung.wu@mediatek.com>, <linux-scsi@vger.kernel.org>,
	<martin.petersen@oracle.com>, <avri.altman@wdc.com>,
	<alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<powen.kao@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <chu.stanley@gmail.com>
Subject: [PATCH v1 2/3] ufs: host: mediatek: fix mcq mode tm cmd timeout
Date: Thu, 21 Dec 2023 19:04:15 +0800
Message-ID: <20231221110416.16176-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20231221110416.16176-1-peter.wang@mediatek.com>
References: <20231221110416.16176-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--4.767700-8.000000
X-TMASE-MatchedRID: lR9wedxBitsMQLXc2MGSbJdc7I2df+msBdebOqawiLu7qpOHKudqc23f
	WdM9RlQ2zdj35i6vMlBEsaNCyIJWnMwdQieqpnTaA9lly13c/gHt/okBLaEo+L/A+0D1to6Pssf
	Gi2vQI7ji8zVgXoAltsIJ+4gwXrEtJ0RPnyOnrZIAxGtSO4KkmxNYNZmU4uVWS8I7bW/SATL0EJ
	yVPQ55+EuyZH7V8PCJ9SHI8VpW6bZ4HO0lhy+Lh/xHbAYq7iU2Vg3cAB57L/mAhOcaQrQ0U1GyR
	coeF18qmKP0zzpTAeGwod8xOMKmvA1Aka/KIp/p
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.767700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: D14675FDA39D1B2ACBD4958B2B7A21CC02E80549EC3F625B495BD4D11A5B1E4D2000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Fix tm cmd timeout issue in mcq mode by default resume call
ufshcd_make_hba_operational to set tm cmd dma address.
This flow same as ufs init make operational after link startup then
set mcq related register if use mcq mode.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 104354a4d899..eb1934126c87 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1220,9 +1220,11 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 	}
 	ufshcd_set_link_active(hba);
 
-	if (!hba->mcq_enabled) {
-		err = ufshcd_make_hba_operational(hba);
-	} else {
+	err = ufshcd_make_hba_operational(hba);
+	if (err)
+		return err;
+
+	if (is_mcq_enabled(hba)) {
 		ufs_mtk_config_mcq(hba, false);
 		ufshcd_mcq_make_queues_operational(hba);
 		ufshcd_mcq_config_mac(hba, hba->nutrs);
@@ -1231,9 +1233,6 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 			      REG_UFS_MEM_CFG);
 	}
 
-	if (err)
-		return err;
-
 	return 0;
 }
 
-- 
2.18.0

