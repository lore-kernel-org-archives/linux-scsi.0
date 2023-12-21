Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973046AB88
	for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2023 11:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="G/iLTO4i"
X-UUID: b0a221609ff011eea5db2bebc7c28f94-20231221
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=do7zMceIWaGw8/yhimnExT4AyyuSwfTWi02UV9OsjYU=;
	b=G/iLTO4iGUSWyF3usuag84Qt5I5BI91mrOzB02gUmD/R65Hit3rey+gCT3pYTz+rbpv3RGpnYjECg0ZmklXMgvPxccLugy/vb/9bBSa0cJi2oxvLhPtkhXcrxDY3K128PpyJgjhlI3RqFICSuZ1si5BWW6ERuIotOfedlqaSIHQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.35,REQID:ba098634-eeb7-4c84-9652-818f78749dad,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:5d391d7,CLOUDID:2c29572e-1ab8-4133-9780-81938111c800,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:
	NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: b0a221609ff011eea5db2bebc7c28f94-20231221
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 486916409; Thu, 21 Dec 2023 19:04:19 +0800
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
Subject: [PATCH v1 1/3] ufs: host: mediatek: check link status after exit hibern8
Date: Thu, 21 Dec 2023 19:04:14 +0800
Message-ID: <20231221110416.16176-2-peter.wang@mediatek.com>
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
X-TM-AS-Result: No-10--4.232700-8.000000
X-TMASE-MatchedRID: +IljWppZe6AZ9FA+BlOSKuEpCHUsKYYG31GU/N5W5BB91DunZtIaFuLz
	NWBegCW2wgn7iDBesS1YF3qW3Je6+88LmiW61oHPI333c7+rQ7gYL4qGrdclK+OObeXsQgZv/Nc
	HLrl+KVCdV/B0fzrYWS+sso3wY8TptDi3KUxBdDfDOSyp7wpU/oCE5xpCtDRTUbJFyh4XXyqYo/
	TPOlMB4bCh3zE4wqa8wIE77PEBbml+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.232700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: F8490AB79D951FF54ABE2B0E501EF906A6F7F98C958AA5658B62BC230EDC1B082000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

To prevent SSU(Active) error, check link status after exit hibern8.
If link is not VS_LINK_UP, return error and do ufshcd_link_recovery.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index fc61790d289b..104354a4d899 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1208,11 +1208,18 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 		return err;
 
 	err = ufshcd_uic_hibern8_exit(hba);
-	if (!err)
-		ufshcd_set_link_active(hba);
-	else
+	if (err)
 		return err;
 
+	/* Check link state to make sure exit h8 success */
+	ufs_mtk_wait_idle_state(hba, 5);
+	err = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
+	if (err) {
+		dev_warn(hba->dev, "exit h8 state fail, err=%d\n", err);
+		return err;
+	}
+	ufshcd_set_link_active(hba);
+
 	if (!hba->mcq_enabled) {
 		err = ufshcd_make_hba_operational(hba);
 	} else {
-- 
2.18.0

