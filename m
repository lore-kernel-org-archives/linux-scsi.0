Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5026E364A8
	for <linux-scsi@vger.kernel.org>; Tue,  9 Jan 2024 12:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="aXZKAQNt"
X-UUID: 3f33fd0eaeec11ee9e680517dc993faa-20240109
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=9YnYZ+9HQO7srjh6G+ugxuioYLUj69zev/NkRZhEzbo=;
	b=aXZKAQNtYZKOH3bNT4RGB24aiokaYMoul5NfGMridaUJ9nnLxH+7fKBVUg+w0TUNwDhXiYx4t0E58Vl/lOge+c9ToMLsLFuWm4bVg1SN+CUvpaA2ee1B0ecVAHrPSE3TVCXAPX0qFRR2B4/5EYYUTZ2ys9mEPnTRNSbuYzzBkqU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:1bd16209-1476-44df-bb99-2dbe8adcef9d,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:5d391d7,CLOUDID:974b287f-4f93-4875-95e7-8c66ea833d57,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: 3f33fd0eaeec11ee9e680517dc993faa-20240109
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 500669645; Tue, 09 Jan 2024 20:40:19 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 9 Jan 2024 20:40:17 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 9 Jan 2024 20:40:17 +0800
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
Subject: [PATCH v1 2/2] ufs: host: mediatek: change default auto suspend timer
Date: Tue, 9 Jan 2024 20:40:15 +0800
Message-ID: <20240109124015.31359-3-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240109124015.31359-1-peter.wang@mediatek.com>
References: <20240109124015.31359-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--6.634100-8.000000
X-TMASE-MatchedRID: ivhBngArENGAAYHsHSPDcxn0UD4GU5IquLwbhNl9B5UY0A95tjAn+4lb
	XigDnfa40/AsCkkwxo4Dcb80+9h4A294Ipa1otxo4pdq9sdj8LUK3n1SHen81WHZ+cd7VyKXFrG
	/KStN8Cgkh92jn4TMCfWwXl0A4TcEGAdnzrnkM48URSScn+QSXt0H8LFZNFG7bkV4e2xSge4JOD
	FehVdzk7cfTC05fAlZLwYE9U5/3fLkf9e0AcUBj+ulxyHOcPoH
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.634100-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 408B38EB27E7D1DC6ECFE717F89F4676B026CAFDF49F764B6564A733B55A921B2000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

Mediatek ufs driver change default auto suspend timer from 2000 ms
to 500 ms.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 4 ++++
 drivers/ufs/host/ufs-mediatek.h | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index fc61790d289b..1bcf75dd13fc 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -893,6 +893,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	const struct of_device_id *id;
 	struct device *dev = hba->dev;
 	struct ufs_mtk_host *host;
+	struct Scsi_Host *shost = hba->host;
 	int err = 0;
 
 	host = devm_kzalloc(dev, sizeof(*host), GFP_KERNEL);
@@ -937,6 +938,9 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 	/* Enable clk scaling*/
 	hba->caps |= UFSHCD_CAP_CLK_SCALING;
 
+	/* Set runtime pm delay to replace default */
+	shost->rpm_autosuspend_delay = MTK_RPM_AUTOSUSPEND_DELAY_MS;
+
 	hba->quirks |= UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL;
 	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_INTR;
 	hba->quirks |= UFSHCD_QUIRK_MCQ_BROKEN_RTC;
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index f76e80d91729..596edadfe747 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -190,6 +190,9 @@ struct ufs_mtk_host {
 	struct ufs_mtk_mcq_intr_info mcq_intr_info[UFSHCD_MAX_Q_NR];
 };
 
+/* MTK delay of autosuspend: 500 ms */
+#define MTK_RPM_AUTOSUSPEND_DELAY_MS 500
+
 /*
  * Multi-VCC by Numbering
  */
-- 
2.18.0

