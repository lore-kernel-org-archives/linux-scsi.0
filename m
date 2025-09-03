Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289A1222593
	for <linux-scsi@vger.kernel.org>; Wed,  3 Sep 2025 02:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756867605; cv=none; b=sSwEbGIdlPv/j5uPEf4zbCo1uAPzs7YpjhKqyYWb8ePnvQ4G6rUq7+E7/c5l0oDPcLFFBxXRe8VLFXX0UIZAwz4Qj8AGkQjDSvv+k/XGhcq71VxIXJQNC3DNfKBlj0niLIMqofbm8i0bZHRgPkswOR7LWjmWdmnxdpnuslpb6OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756867605; c=relaxed/simple;
	bh=+98ucuzKLg25AWg3lKGBf2vZBnolxoPjgHVAO4yMfJs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nbBaJN6yCgnVi6iYXEDUpKEXM0mdVVLXggrOdsdznguU2MRQRVbQ8FD5TUdeXrALjo7acTetagTOMZMvnOedUcBPNb+9RVSHiWSKXSH1BsIqLRvHNGRhrnEsIGNkleX+IJz2d8sT+gQhcggEVcawusuq+5UscdlSjc9YOzYyzh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=H9/iLnia; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="H9/iLnia"
X-UUID: 34584b56887011f0b33aeb1e7f16c2b6-20250903
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=eZrdx+ciTdSvmJANJ2eKH+hL3/VVLURAAziM8Od9UtM=;
	b=H9/iLnia7ZN1Dw65uPJXIptC93Uq/59Osmb6/f8riJ2MrQ6LuT1raST5Hti/gcomANclJ1La9UCM3WVOtZ+IQARVirGDhzoQlg1zl8jp176oKqSE54SnlSXDWawQtS59tLbaT8UO6eP9ZrFp8YtKsvg89XXFdWjNHtlfpqSeeaA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:f8f6ae3d-cafa-4ede-b6af-dfc2045e0777,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:f1326cf,CLOUDID:0e47e7a8-24df-464e-9c88-e53ab7cf7153,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 34584b56887011f0b33aeb1e7f16c2b6-20250903
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1113283097; Wed, 03 Sep 2025 10:46:34 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Wed, 3 Sep 2025 10:46:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Wed, 3 Sep 2025 10:46:33 +0800
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
Subject: [PATCH v3 07/10] ufs: host: mediatek: Return error directly on idle wait timeout
Date: Wed, 3 Sep 2025 10:44:43 +0800
Message-ID: <20250903024631.496693-8-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250903024631.496693-1-peter.wang@mediatek.com>
References: <20250903024631.496693-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Sanjeev Y <sanjeev.y@mediatek.com>

Optimize the recovery flow by returning an error code immediately if a
wait idle timeout occurs, rather than waiting for the link to reach
the up state. Shorten the recovery process and improve error handling
efficiency when idle state transitions fail.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Sanjeev Y <sanjeev.y@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index e42e9b97810c..a6f812713345 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -416,7 +416,7 @@ static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
 	}
 }
 
-static void ufs_mtk_wait_idle_state(struct ufs_hba *hba,
+static int ufs_mtk_wait_idle_state(struct ufs_hba *hba,
 			    unsigned long retry_ms)
 {
 	u64 timeout, time_checked;
@@ -452,8 +452,12 @@ static void ufs_mtk_wait_idle_state(struct ufs_hba *hba,
 			break;
 	} while (time_checked < timeout);
 
-	if (wait_idle && sm != VS_HCE_BASE)
+	if (wait_idle && sm != VS_HCE_BASE) {
 		dev_info(hba->dev, "wait idle tmo: 0x%x\n", val);
+		return -ETIMEDOUT;
+	}
+
+	return 0;
 }
 
 static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
@@ -1437,9 +1441,13 @@ static int ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
 
 	/* wait host return to idle state when auto-hibern8 off */
-	ufs_mtk_wait_idle_state(hba, 5);
+	ret = ufs_mtk_wait_idle_state(hba, 5);
+	if (ret)
+		goto out;
 
 	ret = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
+
+out:
 	if (ret) {
 		dev_warn(hba->dev, "exit h8 state fail, ret=%d\n", ret);
 
@@ -1614,7 +1622,11 @@ static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 		return err;
 
 	/* Check link state to make sure exit h8 success */
-	ufs_mtk_wait_idle_state(hba, 5);
+	err = ufs_mtk_wait_idle_state(hba, 5);
+	if (err) {
+		dev_warn(hba->dev, "wait idle fail, err=%d\n", err);
+		return err;
+	}
 	err = ufs_mtk_wait_link_state(hba, VS_LINK_UP, 100);
 	if (err) {
 		dev_warn(hba->dev, "exit h8 state fail, err=%d\n", err);
-- 
2.45.2

