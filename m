Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AC76AB9A
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="jO8Y1rDw"
X-UUID: b0a35f269ff011eea5db2bebc7c28f94-20231221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=HuhSNqj3oscVEWtEIkp54a6nNUXTvGMlS7FefVV/uyc=;
	b=jO8Y1rDwHjYCk88EdlYGMrECDLzulrA4GJWZoHGzVd9zAJ/do/vGreo+SFWB9Dc3lUn1tK3/aauT+Wi41OJ8V2Q76P/hziWzMyUlUs1b27T2jUytnU7/EG/4AzK0RHS0wSXZRB+TH3HtbGSV3hCELg+t89UmXZ7yRZTEo4ZwCXE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:7cf61cfc-9980-4342-9fb1-e1c5464a2830,IP:0,U
	RL:0,TC:0,Content:-5,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:-30
X-CID-META: VersionHash:5d391d7,CLOUDID:64c56c8d-e2c0-40b0-a8fe-7c7e47299109,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:1,IP:nil,UR
	L:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:N
	O,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: b0a35f269ff011eea5db2bebc7c28f94-20231221
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 578587708; Thu, 21 Dec 2023 19:04:19 +0800
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
Subject: [PATCH v1 3/3] ufs: host: mediatek: disable mcq irq when clock off
Date: Thu, 21 Dec 2023 19:04:16 +0800
Message-ID: <20231221110416.16176-4-peter.wang@mediatek.com>
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
X-TM-AS-Result: No-10--5.506700-8.000000
X-TMASE-MatchedRID: lR9wedxBitsMQLXc2MGSbA5KPhGIg0MRKx5ICGp/WtFKUzR+o2IeheYH
	EPaPco6b09NQNrxIpFYBtjkcfRMmqWMAzi+7d0ch4RtSDjG+z7D/lBG+uXYJkA6QlBHhBZuwzrW
	t8TufKdvi8zVgXoAltsIJ+4gwXrEtIAcCikR3vq8ecJ4UYu58w+t7M4NW55EM+LVSHK96ubpkoG
	te0BaN7j0poA2OJItE
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.506700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 33DF9C373C8C3152FAE21E497C73C2D539563E69A265D231F0BE56F97B91DB562000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Disable mcq irq when clock off, this is same as legacy mode.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 41 +++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 42 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index eb1934126c87..51f05038408a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -660,6 +660,45 @@ static void ufs_mtk_pwr_ctrl(struct ufs_hba *hba, bool on)
 	}
 }
 
+static void ufs_mtk_mcq_disable_irq(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 irq, i;
+
+	if (!is_mcq_enabled(hba))
+		return;
+
+	if (host->mcq_nr_intr == 0)
+		return;
+
+	for (i = 0; i < host->mcq_nr_intr; i++) {
+		irq = host->mcq_intr_info[i].irq;
+		disable_irq(irq);
+	}
+	host->is_mcq_intr_enabled = false;
+}
+
+static void ufs_mtk_mcq_enable_irq(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 irq, i;
+
+	if (!is_mcq_enabled(hba))
+		return;
+
+	if (host->mcq_nr_intr == 0)
+		return;
+
+	if (host->is_mcq_intr_enabled == true)
+		return;
+
+	for (i = 0; i < host->mcq_nr_intr; i++) {
+		irq = host->mcq_intr_info[i].irq;
+		enable_irq(irq);
+	}
+	host->is_mcq_intr_enabled = true;
+}
+
 /**
  * ufs_mtk_setup_clocks - enables/disable clocks
  * @hba: host controller instance
@@ -703,8 +742,10 @@ static int ufs_mtk_setup_clocks(struct ufs_hba *hba, bool on,
 
 		if (clk_pwr_off)
 			ufs_mtk_pwr_ctrl(hba, false);
+		ufs_mtk_mcq_disable_irq(hba);
 	} else if (on && status == POST_CHANGE) {
 		ufs_mtk_pwr_ctrl(hba, true);
+		ufs_mtk_mcq_enable_irq(hba);
 	}
 
 	return ret;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index f76e80d91729..922f1e51a60c 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -186,6 +186,7 @@ struct ufs_mtk_host {
 	u32 ip_ver;
 
 	bool mcq_set_intr;
+	bool is_mcq_intr_enabled;
 	int mcq_nr_intr;
 	struct ufs_mtk_mcq_intr_info mcq_intr_info[UFSHCD_MAX_Q_NR];
 };
-- 
2.18.0

