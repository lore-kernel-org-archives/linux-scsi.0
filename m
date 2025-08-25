Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8822DC329
	for <linux-scsi@vger.kernel.org>; Mon, 25 Aug 2025 10:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756117112; cv=none; b=mbMcwT3CZQPRq2hm9zo952XmbTN+y2cLKNDF9VSxHCEOTzjaxrQVn94Ah407orMk0aJiHmUamCF4hVql0SU29eK1eY1ZimgTZ/7FQO44rVVUUxDKVvig/0wlcj9Lrk4zTWR0wavC3NwI6JQ17ye328wTXrWQfOya/NgcNJYczZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756117112; c=relaxed/simple;
	bh=IvIHBO6VfQPLm1WXwawI3yKYUL7K8r5waKVPM9L/+do=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pO6JrQ2OBkjOQxJlxw28ACzfJ18BPT+m7cf5qN16g5IWL37pPrM9MUBdCC58hF4MkVVjkLE0n70cAXXoJ1diZ25h/8K7x7HL7EKMMk8uhEnSLcxKEBbt8DmbITl4jwV2vPFwivu2TxspI94xkOPQGJ5UczOlDgI85uAEfU/av3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=JmVPkS5A; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="JmVPkS5A"
X-UUID: d22964c6819c11f0b33aeb1e7f16c2b6-20250825
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=1qRYWUXTgS4YKm3AyVWYG0syxcRZyMFivXbEJrDk9mA=;
	b=JmVPkS5Anx22Ue7x0rER9w1x7UEba7XC8xHpHIq9nc1ej0k3aN95i2gABhzU9cr0DiebgwS1a9TFBx2vAkE4iHY50bbR2Oe8sF9rt6u2IGY4LSDdvbUbtz29UhyLfRcl/8MiMqDsZpthuVRYAgTL4le5HFAj8/EpQesa3/Bt1z0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:7e0b3ccf-bf3d-4659-af78-4e16107c7a4b,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:0fe47f7a-966c-41bd-96b5-7d0b3c22e782,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d22964c6819c11f0b33aeb1e7f16c2b6-20250825
Received: from mtkmbs14n2.mediatek.inc [(172.21.101.76)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 132663333; Mon, 25 Aug 2025 18:18:18 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 25 Aug 2025 18:18:17 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 25 Aug 2025 18:18:17 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <sanjeev.y@mediatek.com>
Subject: [PATCH v1 01/10] ufs: host: mediatek: Enhance recovery on hibernation exit failure
Date: Mon, 25 Aug 2025 18:10:09 +0800
Message-ID: <20250825101815.2891905-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250825101815.2891905-1-peter.wang@mediatek.com>
References: <20250825101815.2891905-1-peter.wang@mediatek.com>
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

This patch improves the recovery process when exiting hibernation
mode fails. It triggers the error handler and breaks the suspend
operation, ensuring that the system can recover from hibernation
errors more effectively. The error handling mechanism is activated
by setting 'force_reset' and scheduling the error handler work.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 5ef0ba4527e4..3882bcc85305 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1686,8 +1686,9 @@ static void ufs_mtk_dev_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	}
 }
 
-static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
+static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 {
+	unsigned long flags;
 	int ret;
 
 	/* disable auto-hibern8 */
@@ -1697,8 +1698,20 @@ static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	ufs_mtk_wait_idle_state(hba, 5);
 
 	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
-	if (ret)
+	if (ret) {
 		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->force_reset = true;
+		hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED_FATAL;
+		schedule_work(&hba->eh_work);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+
+		/* trigger error handler and break suspend */
+		ret = -EBUSY;
+	}
+
+	return ret;
 }
 
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
@@ -1709,7 +1722,7 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 
 	if (status == PRE_CHANGE) {
 		if (ufshcd_is_auto_hibern8_supported(hba))
-			ufs_mtk_auto_hibern8_disable(hba);
+			return ufs_mtk_auto_hibern8_disable(hba);
 		return 0;
 	}
 
-- 
2.45.2

