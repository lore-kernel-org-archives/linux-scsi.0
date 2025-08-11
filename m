Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DADC2DCF6C
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918078; cv=none; b=RlMYVdeiPtpil/DpWBSdWRFy5RDPeMsFtBI6QFZWmmVMUK6SfO0Xuuy6hALCLOegvHKkv5xEQT0g1VJGJjAOvuNBQs8stqtwRlr0Yw7YNU2DH9ubV7vbDS5QR6C5Cu+oWeMrUWDKcsF+cQ7EiQm7cXZs6/QKh4EeSwI2gxmF8L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918078; c=relaxed/simple;
	bh=AmTCNXIY67PYnNYcVpqFQJX8MCVSS/9hCbR2mqOCyKw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LNZI64IVRTu7Mf7gx9Yb+odZJV9yiRAVfb4kkhtn3bIzKgH8Ysb8r1Nz53wDTausu2WfDig0WoBBVwDyIW5K/JfBwfudoNWuT74EjXfG/TI9vvggtioWIS1SQyE+J/ulctgxo2VqrpUd+v2XQcAYv9bTzuWSnHROq1uEfdOIslM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SvAIKENP; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SvAIKENP"
X-UUID: 1ac34c1c76b511f0b33aeb1e7f16c2b6-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=8ccB9MQly4klStRXD4xKsnoHFEl4apXZflGejcFCrqc=;
	b=SvAIKENPgQfGOZPmAnB1Hvz/SBH7+oOQyDH8hnmAW7L9cfQYy27fLiH5GX+gs3iu1vCRCkVmN9KlYuIBEJg1pFjUAzg5KKnFae6C34DOOjVjGF7GJK+NzE53QMRUDC8RAOht+mFczzRsYnN/P6g78Km5se0tb+wkJNYtwl8Gfqo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:fd344436-d606-4fc7-9562-7a6c5ab7d98a,IP:0,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-25
X-CID-META: VersionHash:f1326cf,CLOUDID:996bd29d-7ad4-4169-ab95-78e9164f00fe,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1ac34c1c76b511f0b33aeb1e7f16c2b6-20250811
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 425173395; Mon, 11 Aug 2025 21:14:25 +0800
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
Subject: [PATCH v1 05/10] ufs: host: mediatek: Fix PWM mode switch issue
Date: Mon, 11 Aug 2025 21:11:21 +0800
Message-ID: <20250811131423.3444014-6-peter.wang@mediatek.com>
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

This patch addresses a failure in switching to PWM mode by
ensuring proper configuration of power modes and adaptation
settings. The changes include checks for SLOW_MODE and
adjustments to the desired working mode and adaptation
configuration based on the device's power mode and hardware
version.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 31fe8efa5778..e0a51b86469c 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1321,6 +1321,10 @@ static bool ufs_mtk_pmc_via_fastauto(struct ufs_hba *hba,
 	    dev_req_params->gear_rx < UFS_HS_G4)
 		return false;
 
+	if (dev_req_params->pwr_tx == SLOW_MODE ||
+	    dev_req_params->pwr_rx == SLOW_MODE)
+		return false;
+
 	return true;
 }
 
@@ -1336,6 +1340,10 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 	host_params.hs_rx_gear = UFS_HS_G5;
 	host_params.hs_tx_gear = UFS_HS_G5;
 
+	if (dev_max_params->pwr_rx == SLOW_MODE ||
+	    dev_max_params->pwr_tx == SLOW_MODE)
+		host_params.desired_working_mode = UFS_PWM_MODE;
+
 	ret = ufshcd_negotiate_pwr_params(&host_params, dev_max_params, dev_req_params);
 	if (ret) {
 		pr_info("%s: failed to determine capabilities\n",
@@ -1368,10 +1376,21 @@ static int ufs_mtk_pre_pwr_change(struct ufs_hba *hba,
 		}
 	}
 
-	if (host->hw_ver.major >= 3) {
+	if (dev_req_params->pwr_rx == FAST_MODE ||
+	    dev_req_params->pwr_rx == FASTAUTO_MODE) {
+		if (host->hw_ver.major >= 3) {
+			ret = ufshcd_dme_configure_adapt(hba,
+						   dev_req_params->gear_tx,
+						   PA_INITIAL_ADAPT);
+		} else {
+			ret = ufshcd_dme_configure_adapt(hba,
+				   dev_req_params->gear_tx,
+				   PA_NO_ADAPT);
+		}
+	} else {
 		ret = ufshcd_dme_configure_adapt(hba,
-					   dev_req_params->gear_tx,
-					   PA_INITIAL_ADAPT);
+			   dev_req_params->gear_tx,
+			   PA_NO_ADAPT);
 	}
 
 	return ret;
-- 
2.45.2

