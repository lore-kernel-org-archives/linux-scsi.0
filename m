Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8802D9EFF
	for <linux-scsi@vger.kernel.org>; Thu, 18 Sep 2025 10:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758192015; cv=none; b=QFExeHAoiYNmEXQrr7kd1LgzpU33qXV4AF6fmF71oVoqBj7wcs4nR9l2k5DEbrXUPxBQr0M0xS54OoYXZ4uRYsu2/sMTby+lXwWK2c2++47mwxuFlL44vE3K2WVXcTUPuxEstJDURzFj7lnEunnWpYdc6CygNkLesAn9fsgt7ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758192015; c=relaxed/simple;
	bh=hlcZ9ev2vgyE0JYyddYvwu7/QENdY89GDcvxGsFMb74=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHzsZbvRnTyo8pWmGQ54bRZOQRGoUxY7V+I4N2Cd0tY4/ACXtP9fuXjPX3ooVBDwZfrHni8m9nn6z+3dj0eycKHVhhqK9DfFQh+1QGwiZoBshbvUAvrCYynq1jxDlGMyW/xJjfijt5oqcbDWq+gOV2HO7YfqUNhVEf/MWeLAnTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=t9Tr/VQ8; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="t9Tr/VQ8"
X-UUID: d6074a8a947b11f0b33aeb1e7f16c2b6-20250918
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=vnFjASWdN09Z2pxgJ/BkA4FP4+u11UAWeYt+tGr5voQ=;
	b=t9Tr/VQ8juk+D1Vs0DKD7Xr/g+BYlNTcuoHcBGQU+V717anU0F4qABqFSsgvX0v9cr6Es+9EAPEknitIgvrR1VbE9Tzk3K/NTJjiFoMkweHK+GMnGcuVt9duEizoeaGJZEOSVbVa5/0bHVeLOxJhaCCVwdxO/7W8Qwvi4ICk29o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:e1eff614-f6b7-4cdf-8462-b7370a4c31ba,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:1ca6b93,CLOUDID:b6fd1891-68e1-4022-b848-86f5c49a6751,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: d6074a8a947b11f0b33aeb1e7f16c2b6-20250918
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 936950209; Thu, 18 Sep 2025 18:40:04 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Thu, 18 Sep 2025 18:40:02 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Thu, 18 Sep 2025 18:40:02 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 01/10] ufs: host: mediatek: Fix runtime suspend error deadlock
Date: Thu, 18 Sep 2025 18:36:11 +0800
Message-ID: <20250918104000.208856-2-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250918104000.208856-1-peter.wang@mediatek.com>
References: <20250918104000.208856-1-peter.wang@mediatek.com>
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

Fix the deadlock issue during runtime suspend by checking
the error handler's progress. If the error handler is active,
break the runtime suspend process by returning -EAGAIN.
This approach prevents potential deadlocks when acquiring
runtime PM and enhances system stability.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c       | 12 ------------
 drivers/ufs/host/ufs-mediatek.c | 12 +++++++++---
 include/ufs/ufshcd.h            | 12 ++++++++++++
 3 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c9eb89dccd1e..c7a12748e479 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -214,11 +214,6 @@ static const char *const ufshcd_state_name[] = {
 	[UFSHCD_STATE_EH_SCHEDULED_NON_FATAL]	= "eh_non_fatal",
 };
 
-/* UFSHCD error handling flags */
-enum {
-	UFSHCD_EH_IN_PROGRESS = (1 << 0),
-};
-
 /* UFSHCD UIC layer error flags */
 enum {
 	UFSHCD_UIC_DL_PA_INIT_ERROR = (1 << 0), /* Data link layer error */
@@ -230,13 +225,6 @@ enum {
 	UFSHCD_UIC_PA_GENERIC_ERROR = (1 << 6), /* Generic PA error */
 };
 
-#define ufshcd_set_eh_in_progress(h) \
-	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
-#define ufshcd_eh_in_progress(h) \
-	((h)->eh_flags & UFSHCD_EH_IN_PROGRESS)
-#define ufshcd_clear_eh_in_progress(h) \
-	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
-
 const struct ufs_pm_lvl_states ufs_pm_lvl_states[] = {
 	[UFS_PM_LVL_0] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_ACTIVE_STATE},
 	[UFS_PM_LVL_1] = {UFS_ACTIVE_PWR_MODE, UIC_LINK_HIBERN8_STATE},
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 758a393a9de1..b1797386668c 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1746,9 +1746,15 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	struct arm_smccc_res res;
 
 	if (status == PRE_CHANGE) {
-		if (ufshcd_is_auto_hibern8_supported(hba))
-			return ufs_mtk_auto_hibern8_disable(hba);
-		return 0;
+		if (!ufshcd_is_auto_hibern8_supported(hba))
+			return 0;
+		err = ufs_mtk_auto_hibern8_disable(hba);
+
+		/* May trigger EH work without exiting hibern8 error */
+		if (ufshcd_eh_in_progress(hba))
+			return -EAGAIN;
+		else
+			return err;
 	}
 
 	if (ufshcd_is_link_hibern8(hba)) {
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index ea0021f067c9..45e2ca65de90 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -97,6 +97,11 @@ enum uic_link_state {
 	UIC_LINK_BROKEN_STATE	= 3, /* Link is in broken state */
 };
 
+/* UFSHCD error handling flags */
+enum {
+	UFSHCD_EH_IN_PROGRESS = (1 << 0),
+};
+
 #define ufshcd_is_link_off(hba) ((hba)->uic_link_state == UIC_LINK_OFF_STATE)
 #define ufshcd_is_link_active(hba) ((hba)->uic_link_state == \
 				    UIC_LINK_ACTIVE_STATE)
@@ -129,6 +134,13 @@ enum uic_link_state {
 #define ufshcd_is_ufs_dev_deepsleep(h) \
 	((h)->curr_dev_pwr_mode == UFS_DEEPSLEEP_PWR_MODE)
 
+#define ufshcd_set_eh_in_progress(h) \
+	((h)->eh_flags |= UFSHCD_EH_IN_PROGRESS)
+#define ufshcd_eh_in_progress(h) \
+	((h)->eh_flags & UFSHCD_EH_IN_PROGRESS)
+#define ufshcd_clear_eh_in_progress(h) \
+	((h)->eh_flags &= ~UFSHCD_EH_IN_PROGRESS)
+
 /*
  * UFS Power management levels.
  * Each level is in increasing order of power savings, except DeepSleep
-- 
2.45.2

