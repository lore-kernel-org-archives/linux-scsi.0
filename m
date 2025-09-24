Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DEA92D97AA
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 09:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707147; cv=none; b=nXykdQ0DqHKW0KQQjtPxvY0GXeqIaqs/b1/SLmz7YgDLLVIjFGRp/HcbaHFNA+qZK1EDscQ5IS0+i/GujA2dt0GGPS0ND8Tpxj87S441ZZVX/F//cY7iRTkyNmQ3HWhPYA+aaZAqwmOTFiMhhm58oparyIBo9uRMEESlTrf4xDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707147; c=relaxed/simple;
	bh=PLVGumJUU9hKZvM8NWnon0rEFhRQ2y36lAKwS2Cv2YY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D64EFPnFlVZ6t20iPYA3xJ/EAQMBB+CAVegK0n+JukVVMyL67t0tv3s9z3NC+Q7IyUgF3XqnlnTZavv6sxOXmbkTWH2Z+6xiI+ZRYy1sgEiDp4UM5Tyjv4Ydrd2y/iD9UGB4Ua4OC7k/GMqnHqd9RK4onsMdeiQH88lsKdAyEGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=VBgJEDz8; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="VBgJEDz8"
X-UUID: 35d592a6992b11f0b33aeb1e7f16c2b6-20250924
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=si3j8d5cgVjUsmGkTpHa4AhEh9vW1KoViw9giBVSot4=;
	b=VBgJEDz8QI7FqPP/L6rGDF3YqOvy3UjARIN0sgC2apd+0C79ds/Hpgts7cYTpvtvCdvRLT9TRkMsycu+PBmNebb3YjUqTxLAUbqvmB5lPBnOnKfD58N2JbLxtK7lXB/QwMepxBCjRSvIPF3NzykN3ufAd6Fof6ESZymkta9CzNs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.4,REQID:28a4d135-bf63-4b56-95d6-e6e93568cdec,IP:0,UR
	L:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:-5
X-CID-META: VersionHash:1ca6b93,CLOUDID:0c3ce56c-8443-424b-b119-dc42e68239b0,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|888|898,TC:-5,Content:
	0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,
	OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 35d592a6992b11f0b33aeb1e7f16c2b6-20250924
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1212084665; Wed, 24 Sep 2025 17:45:31 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 24 Sep 2025 17:45:29 +0800
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
Subject: [PATCH v2 7/8] ufs: host: mediatek: Add support for new platform with MMIO_OTSD_CTR
Date: Wed, 24 Sep 2025 17:43:29 +0800
Message-ID: <20250924094527.2992256-8-peter.wang@mediatek.com>
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

Introduce support for a new UFS Mediatek platform by adding
the REG_UFS_UFS_MMIO_OTSD_CTRL register. This update includes
checks for legacy platforms and uses the new register to
replace debug selection and handle specific operations.
The changes ensure compatibility across different hardware
versions and prevent potential issues with debug usage on
newer platforms.

Additional updates include error logging improvements
during link setup for newer and legacy platforms, ensuring
proper event logging and debugging.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 42 +++++++++++++++++++++++++++------
 drivers/ufs/host/ufs-mediatek.h |  1 +
 2 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 3e54154d5547..8498e95e263a 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -280,6 +280,9 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
 			      ufshcd_readl(hba, REG_UFS_XOUFS_CTRL) | 0x80,
 			      REG_UFS_XOUFS_CTRL);
 
+		if (host->legacy_ip_ver)
+			return 0;
+
 		/* DDR_EN setting */
 		if (host->ip_ver >= IP_VER_MT6989) {
 			ufshcd_rmwl(hba, UFS_MASK(0x7FFF, 8),
@@ -405,7 +408,7 @@ static void ufs_mtk_dbg_sel(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
-	if (((host->ip_ver >> 16) & 0xFF) >= 0x36) {
+	if (!host->legacy_ip_ver && host->ip_ver >= IP_VER_MT6983) {
 		ufshcd_writel(hba, 0x820820, REG_UFS_DEBUG_SEL);
 		ufshcd_writel(hba, 0x0, REG_UFS_DEBUG_SEL_B0);
 		ufshcd_writel(hba, 0x55555555, REG_UFS_DEBUG_SEL_B1);
@@ -422,6 +425,7 @@ static int ufs_mtk_wait_idle_state(struct ufs_hba *hba,
 	u64 timeout, time_checked;
 	u32 val, sm;
 	bool wait_idle;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	/* cannot use plain ktime_get() in suspend */
 	timeout = ktime_get_mono_fast_ns() + retry_ms * 1000000UL;
@@ -432,8 +436,13 @@ static int ufs_mtk_wait_idle_state(struct ufs_hba *hba,
 
 	do {
 		time_checked = ktime_get_mono_fast_ns();
-		ufs_mtk_dbg_sel(hba);
-		val = ufshcd_readl(hba, REG_UFS_PROBE);
+		if (host->legacy_ip_ver || host->ip_ver < IP_VER_MT6899) {
+			ufs_mtk_dbg_sel(hba);
+			val = ufshcd_readl(hba, REG_UFS_PROBE);
+		} else {
+			val = ufshcd_readl(hba, REG_UFS_UFS_MMIO_OTSD_CTRL);
+			val = val >> 16;
+		}
 
 		sm = val & 0x1f;
 
@@ -465,13 +474,20 @@ static int ufs_mtk_wait_link_state(struct ufs_hba *hba, u32 state,
 {
 	ktime_t timeout, time_checked;
 	u32 val;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	timeout = ktime_add_ms(ktime_get(), max_wait_ms);
 	do {
 		time_checked = ktime_get();
-		ufs_mtk_dbg_sel(hba);
-		val = ufshcd_readl(hba, REG_UFS_PROBE);
-		val = val >> 28;
+
+		if (host->legacy_ip_ver || host->ip_ver < IP_VER_MT6899) {
+			ufs_mtk_dbg_sel(hba);
+			val = ufshcd_readl(hba, REG_UFS_PROBE);
+			val = val >> 28;
+		} else {
+			val = ufshcd_readl(hba, REG_UFS_UFS_MMIO_OTSD_CTRL);
+			val = val >> 24;
+		}
 
 		if (val == state)
 			return 0;
@@ -1639,14 +1655,26 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
 static int ufs_mtk_link_set_hpm(struct ufs_hba *hba)
 {
 	int err;
+	u32 val;
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
 
 	err = ufshcd_hba_enable(hba);
 	if (err)
 		return err;
 
 	err = ufs_mtk_unipro_set_lpm(hba, false);
-	if (err)
+	if (err) {
+		if (host->ip_ver < IP_VER_MT6899) {
+			ufs_mtk_dbg_sel(hba);
+			val = ufshcd_readl(hba, REG_UFS_PROBE);
+		} else {
+			val = ufshcd_readl(hba, REG_UFS_UFS_MMIO_OTSD_CTRL);
+		}
+		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)val);
+		val = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)val);
 		return err;
+	}
 
 	err = ufshcd_uic_hibern8_exit(hba);
 	if (err)
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index dfbf78bd8664..f96fd032371d 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -28,6 +28,7 @@
  */
 #define REG_UFS_XOUFS_CTRL          0x140
 #define REG_UFS_REFCLK_CTRL         0x144
+#define REG_UFS_UFS_MMIO_OTSD_CTRL  0x14C
 #define REG_UFS_MMIO_OPT_CTRL_0     0x160
 #define REG_UFS_EXTREG              0x2100
 #define REG_UFS_MPHYCTRL            0x2200
-- 
2.45.2

