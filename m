Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8389F2DCF58
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 13:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754918079; cv=none; b=C6WQgJBCkKp0nW6SVZR9x8Ar7TUfw6snNPEqLfW0fvDrLK5N/Uvw9/eY26ky8RE2U8VKh1tSSBMdY/+TRUiLhG9pf5AF4n5T1LBLz8NWTypQXFZg28rgBEHTYr2/jOvSN5y3oOGeNrfwWERJs+HScUXntGk1fqRl4wTE3SrNq0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754918079; c=relaxed/simple;
	bh=MVp0/Zl1hxtIBKnA5UjdZ79dnnsYZbbbrS6UlfuOkjg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PMCt54CqEGkvKYunb6WHetA7VcY+pTEaWsnhReVVEIRC7arDa1YPK0YK62ZeIj+2cdtZ0pjxjcMwNGOmcrw12/vw/l0/WK8EVBfcFWnkehANjlnphLI/BisnQJIuaimyk76SG9T91+7qGzpfvxPrlBzbN9qYhLNXDr+XT4c7VSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=RW2n4Pu+; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="RW2n4Pu+"
X-UUID: 1abffb3e76b511f0b33aeb1e7f16c2b6-20250811
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=jkrhPQ6BKSUDFaZFOMcUEoFwG6RKsaw5conE98ut2Sg=;
	b=RW2n4Pu+rpo+EZ02ehu28/fhH73Y7UJb9YWdEdr4GaNyNoXgdWBRI8DdP/NqOuin+2UJ0iX2yg816+looLaqz3vz+Ke5JJXOIryKJMW0bJL0ojS49k785jxcuhomqbrlcoyy7yhtNG8slXoiYWRSFDxLqGjNIGcrkR0Hil9kkdY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.3,REQID:36f96fcd-af49-49ac-8561-c9ca0ee355a9,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:f1326cf,CLOUDID:f5484951-d89a-4c27-9e37-f7ccfcbebd5b,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:-5,Content:0|15|50,EDM:
	-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 3,DMD|SSN|SDN
X-CID-BAS: 3,DMD|SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1abffb3e76b511f0b33aeb1e7f16c2b6-20250811
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1152501945; Mon, 11 Aug 2025 21:14:25 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Mon, 11 Aug 2025 21:14:24 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Mon, 11 Aug 2025 21:14:24 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v1 02/10] ufs: host: mediatek: Fix auto-hibern8 timer configuration
Date: Mon, 11 Aug 2025 21:11:18 +0800
Message-ID: <20250811131423.3444014-3-peter.wang@mediatek.com>
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

This patch moves the configuration of the Auto-Hibern8 (AHIT)
timer from the post-link stage to the 'fixup_dev_quirks'
function. This change allows setting the AHIT based on the
vendor requirements:
   (a) Samsung: 3.5 ms
   (b) Micron: 2 ms
   (c) Others: 1 ms

Additionally, the clock gating timer is adjusted based on
the AHIT scale, with a maximum setting of 10 ms. This ensures
that the clock gating delay is appropriately configured to
match the AHIT settings.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 86 ++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 22 deletions(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 2be13b982281..3e661494fbb6 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -1075,6 +1075,69 @@ static void ufs_mtk_vreg_fix_vccqx(struct ufs_hba *hba)
 	}
 }
 
+static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
+{
+	unsigned long flags;
+	u32 ah_ms = 10;
+	u32 ah_scale, ah_timer;
+	u32 scale_us[] = {1, 10, 100, 1000, 10000, 100000};
+
+	if (ufshcd_is_clkgating_allowed(hba)) {
+		if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit) {
+			ah_scale = FIELD_GET(UFSHCI_AHIBERN8_SCALE_MASK,
+					  hba->ahit);
+			ah_timer = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
+					  hba->ahit);
+			if (ah_scale <= 5)
+				ah_ms = ah_timer * scale_us[ah_scale] / 1000;
+		}
+
+		spin_lock_irqsave(hba->host->host_lock, flags);
+		hba->clk_gating.delay_ms = max(ah_ms, 10U);
+		spin_unlock_irqrestore(hba->host->host_lock, flags);
+	}
+}
+
+/* Convert microseconds to Auto-Hibernate Idle Timer register value */
+static u32 ufs_mtk_us_to_ahit(unsigned int timer)
+{
+	unsigned int scale;
+
+	for (scale = 0; timer > UFSHCI_AHIBERN8_TIMER_MASK; ++scale)
+		timer /= UFSHCI_AHIBERN8_SCALE_FACTOR;
+
+	return FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, timer) |
+	       FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, scale);
+}
+
+static void ufs_mtk_fix_ahit(struct ufs_hba *hba)
+{
+	unsigned int us;
+
+	if (ufshcd_is_auto_hibern8_supported(hba)) {
+		switch (hba->dev_info.wmanufacturerid) {
+		case UFS_VENDOR_SAMSUNG:
+			/* configure auto-hibern8 timer to 3.5 ms */
+			us = 3500;
+			break;
+
+		case UFS_VENDOR_MICRON:
+			/* configure auto-hibern8 timer to 2 ms */
+			us = 2000;
+			break;
+
+		default:
+			/* configure auto-hibern8 timer to 1 ms */
+			us = 1000;
+			break;
+		}
+
+		hba->ahit = ufs_mtk_us_to_ahit(us);
+	}
+
+	ufs_mtk_setup_clk_gating(hba);
+}
+
 static void ufs_mtk_init_mcq_irq(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -1369,32 +1432,10 @@ static int ufs_mtk_pre_link(struct ufs_hba *hba)
 
 	return ret;
 }
-
-static void ufs_mtk_setup_clk_gating(struct ufs_hba *hba)
-{
-	u32 ah_ms;
-
-	if (ufshcd_is_clkgating_allowed(hba)) {
-		if (ufshcd_is_auto_hibern8_supported(hba) && hba->ahit)
-			ah_ms = FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK,
-					  hba->ahit);
-		else
-			ah_ms = 10;
-		ufshcd_clkgate_delay_set(hba->dev, ah_ms + 5);
-	}
-}
-
 static void ufs_mtk_post_link(struct ufs_hba *hba)
 {
 	/* enable unipro clock gating feature */
 	ufs_mtk_cfg_unipro_cg(hba, true);
-
-	/* will be configured during probe hba */
-	if (ufshcd_is_auto_hibern8_supported(hba))
-		hba->ahit = FIELD_PREP(UFSHCI_AHIBERN8_TIMER_MASK, 10) |
-			FIELD_PREP(UFSHCI_AHIBERN8_SCALE_MASK, 3);
-
-	ufs_mtk_setup_clk_gating(hba);
 }
 
 static int ufs_mtk_link_startup_notify(struct ufs_hba *hba,
@@ -1726,6 +1767,7 @@ static void ufs_mtk_fixup_dev_quirks(struct ufs_hba *hba)
 
 	ufs_mtk_vreg_fix_vcc(hba);
 	ufs_mtk_vreg_fix_vccqx(hba);
+	ufs_mtk_fix_ahit(hba);
 }
 
 static void ufs_mtk_event_notify(struct ufs_hba *hba,
-- 
2.45.2

