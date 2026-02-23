Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9912B34FF41
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 10:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771843160; cv=none; b=TRNhriZ7c+nZwICgzZKE2hKtztDnTGKqX3f/QEDqgeSpFl1KFlU6vYCJmfjqucM464JKEODPE41MYjPeY1cmA01KuKyyY47ANE60tJy2Glq1H5vhDdgJQKQtIIUhWbxrM2RPINzaCX8MPBiArsBg6ofaKoQo2Kr3WjyOtfqfbS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771843160; c=relaxed/simple;
	bh=IHhu0bsADy/wJVYMzwVUAkFnrjgoGtECpCyHWA4D4PI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mqbMt/5bzVdCObnEEY4OJjZw85Z5fP74h/bWSyzamwC3Q1iBdUAdU8pOIo+M6d70M/DmIKmv8T+TZyVQzozEnYiq9cm14CAX9Zpee68L3Pnf1WPWGWFEfzdykhHNVkktmHAFKrSMmV1fMUETIqaPEq2MESbNIBD3Y+j9Wxk0h7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=EyxOPe70; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="EyxOPe70"
X-UUID: e2f4fbc610a311f1bcd7499a721e883d-20260223
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=pQGO0rOrP6CshyI23vD7FI6nty5bzJA+eY3Su3dHLJQ=;
	b=EyxOPe700SZVQeoTFn0XtbWd5i3FaQ+fX2WvChQi8+6fc9RhINXTO3o+7wismmR2bZMufBcEIBHyfFA6IjpimyP7+60pomcKuVedtUOqHrn2cPM94gNjexnu2B4uq6SawXL6Gn1mD1PUl58MnjzlD3pvyt4nfgeZbKSla4Se4r8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.11,REQID:2a8dcbd6-2551-492c-af45-2eaf39a075a6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:89c9d04,CLOUDID:8904e9f0-16bd-4243-b4ca-b08ca08ab1d8,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|123|836|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e2f4fbc610a311f1bcd7499a721e883d-20260223
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 766810847; Mon, 23 Feb 2026 18:39:09 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 23 Feb 2026 18:39:08 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 23 Feb 2026 18:39:08 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
	<avri.altman@sandisk.com>, <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <tun-yu.yu@mediatek.com>,
	<eddie.huang@mediatek.com>, <naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>,
	<bvanassche@acm.org>, <sh043.lee@samsung.com>
Subject: [PATCH v1] ufs: core: Move link recovery for hibern8 exit failure to wl_resume
Date: Mon, 23 Feb 2026 18:37:57 +0800
Message-ID: <20260223103906.2533654-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

Move the link recovery trigger from ufshcd_uic_pwr_ctrl() to
__ufshcd_wl_resume(). Ensure link recovery is only attempted
when hibern8 exit fails during resume, not during hibern8 enter
in suspend. Improve error handling and prevent unnecessary link
recovery attempts.

Fixes: 35dabf4503b9 ("scsi: ufs: core: Use link recovery when h8 exit fails during runtime resume")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 44efb03765b9..9908375b2f98 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -4385,14 +4385,6 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
-	/*
-	 * If the h8 exit fails during the runtime resume process, it becomes
-	 * stuck and cannot be recovered through the error handler.  To fix
-	 * this, use link recovery instead of the error handler.
-	 */
-	if (ret && hba->pm_op_in_progress)
-		ret = ufshcd_link_recovery(hba);
-
 	return ret;
 }
 
@@ -10175,7 +10167,15 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		} else {
 			dev_err(hba->dev, "%s: hibern8 exit failed %d\n",
 					__func__, ret);
-			goto vendor_suspend;
+			/*
+			 * If the h8 exit fails during the runtime resume
+			 * process, it becomes stuck and cannot be recovered
+			 * through the error handler. To fix this, use link
+			 * recovery instead of the error handler.
+			 */
+			ret = ufshcd_link_recovery(hba);
+			if (ret)
+				goto vendor_suspend;
 		}
 	} else if (ufshcd_is_link_off(hba)) {
 		/*
-- 
2.45.2

