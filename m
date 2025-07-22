Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA5028BA84
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753153742; cv=none; b=LVg26mM1x3iyZKQ5gYxV4f++zr8NGfb5Jr71v/iNleuiluJFpRtlOI2LIJmw8r7AGxPSptb14BJfUNmufHxaJ/M2x+RNUHiiK1wzaeaiA2IC88jl87wydn42aWBBAKVuYWY/hL/mPiR4NTEoJmtP7w2LbVmams/W9MoR/L+2NnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753153742; c=relaxed/simple;
	bh=QwxYxf8hUdDNZZSPqVUwUzQ8EWZDmY+osdwArK06m5Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=chfSB4li6hNN4NPMGiEc7MsyM+w8l49JckiK4jr0jYdtv2Y6x/NRTFTCgSFcFRbf6V1ya7ZKHpPSEUrs48qwqMGKBsfM6qqd4iL0VeWQktEodoeTAvVnPmSe7njWbslbpfp1evIMhdbWgRQodhb1duaNtj4Nq9FZEq4bEwxoxhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=uZ1bHDO7; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="uZ1bHDO7"
X-UUID: 2e9e583866a911f0b33aeb1e7f16c2b6-20250722
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=kDQCZ1Sht6oTHexr5vqtnbtGwpXZJp98bhz3qp6ouyw=;
	b=uZ1bHDO7MJzx+zitE9ZEieCBWHv0gxedFkdyrBMGfCYp7zfHa3AwQ7OMcg+hgNNlF/7mhsCWYFDrHjDU0vIpxAojYgtN78rV9f44sSws9MJfd6MwULUvfdRnveua287f4nqU2JX4rY3S4a9W1eipH0XvEHTqIx5Pr5bnYcm4hF0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.2,REQID:cc17b22b-8333-48a7-b78a-d7a5e24dae96,IP:0,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:0
X-CID-META: VersionHash:9eb4ff7,CLOUDID:6bce1b50-93b9-417a-b51d-915a29f1620f,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3
	,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV
	:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2e9e583866a911f0b33aeb1e7f16c2b6-20250722
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 164625783; Tue, 22 Jul 2025 11:08:46 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N1.mediatek.inc (172.21.101.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.39; Tue, 22 Jul 2025 11:08:43 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1258.39 via Frontend Transport; Tue, 22 Jul 2025 11:08:43 +0800
From: <peter.wang@mediatek.com>
To: <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>
CC: <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
	<peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
	<alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
	<chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
	<yi-fan.peng@mediatek.com>, <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
	<tun-yu.yu@mediatek.com>, <eddie.huang@mediatek.com>,
	<naomi.chu@mediatek.com>, <ed.tsai@mediatek.com>, <bvanassche@acm.org>
Subject: [PATCH v4 6/9] ufs: host: mediatek: Add more UFSCHI hardware versions
Date: Tue, 22 Jul 2025 11:07:21 +0800
Message-ID: <20250722030841.1998783-7-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250722030841.1998783-1-peter.wang@mediatek.com>
References: <20250722030841.1998783-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Alice Chao <alice.chao@mediatek.com>

This patch introduces a function for version control to distinguish
between new and old platforms. It updates the handling of hardware
IP versions, ensuring correct version comparisons by adjusting the
version format for specific projects.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Alice Chao <alice.chao@mediatek.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Chun-Hung Wu <chun-hung.wu@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 47 ++++++++++++++++++++++++++++++++-
 drivers/ufs/host/ufs-mediatek.h | 12 +++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index 78eaf057cdc3..28aba44068da 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -838,6 +838,51 @@ static void ufs_mtk_mcq_set_irq_affinity(struct ufs_hba *hba, unsigned int cpu)
 	dev_info(hba->dev, "set irq %d affinity to CPU: %d\n", irq, _cpu);
 }
 
+static bool ufs_mtk_is_legacy_chipset(struct ufs_hba *hba, u32 hw_ip_ver)
+{
+	bool is_legacy = false;
+
+	switch (hw_ip_ver) {
+	case IP_LEGACY_VER_MT6893:
+	case IP_LEGACY_VER_MT6781:
+		/* can add other legacy chipset ID here accordingly */
+		is_legacy = true;
+		break;
+	default:
+		break;
+	}
+	dev_info(hba->dev, "legacy IP version - 0x%x, is legacy : %d", hw_ip_ver, is_legacy);
+
+	return is_legacy;
+}
+
+/*
+ * HW version format has been changed from 01MMmmmm to 1MMMmmmm, since
+ * project MT6878. In order to perform correct version comparison,
+ * version number is changed by SW for the following projects.
+ * IP_VER_MT6983	0x00360000 to 0x10360000
+ * IP_VER_MT6897	0x01440000 to 0x10440000
+ * IP_VER_MT6989	0x01450000 to 0x10450000
+ * IP_VER_MT6991	0x01460000 to 0x10460000
+ */
+static void ufs_mtk_get_hw_ip_version(struct ufs_hba *hba)
+{
+	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
+	u32 hw_ip_ver;
+
+	hw_ip_ver = ufshcd_readl(hba, REG_UFS_MTK_IP_VER);
+
+	if (((hw_ip_ver & (0xFF << 24)) == (0x1 << 24)) ||
+	    ((hw_ip_ver & (0xFF << 24)) == 0)) {
+		hw_ip_ver &= ~(0xFF << 24);
+		hw_ip_ver |= (0x1 << 28);
+	}
+
+	host->ip_ver = hw_ip_ver;
+
+	host->legacy_ip_ver = ufs_mtk_is_legacy_chipset(hba, hw_ip_ver);
+}
+
 static void ufs_mtk_get_controller_version(struct ufs_hba *hba)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
@@ -1112,7 +1157,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	ufs_mtk_setup_clocks(hba, true, POST_CHANGE);
 
-	host->ip_ver = ufshcd_readl(hba, REG_UFS_MTK_IP_VER);
+	ufs_mtk_get_hw_ip_version(hba);
 
 	goto out;
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index abb4a4fd4402..fd229514384e 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -181,6 +181,7 @@ struct ufs_mtk_host {
 	u16 ref_clk_ungating_wait_us;
 	u16 ref_clk_gating_wait_us;
 	u32 ip_ver;
+	bool legacy_ip_ver;
 
 	bool mcq_set_intr;
 	bool is_mcq_intr_enabled;
@@ -197,13 +198,24 @@ struct ufs_mtk_host {
 /* UFSHCI MTK ip version value */
 enum {
 	/* UFSHCI 3.1 */
+	IP_VER_MT6983    = 0x10360000,
 	IP_VER_MT6878    = 0x10420200,
 
 	/* UFSHCI 4.0 */
 	IP_VER_MT6897    = 0x10440000,
 	IP_VER_MT6989    = 0x10450000,
+	IP_VER_MT6899    = 0x10450100,
+	IP_VER_MT6991_A0 = 0x10460000,
+	IP_VER_MT6991_B0 = 0x10470000,
+	IP_VER_MT6993    = 0x10480000,
 
 	IP_VER_NONE      = 0xFFFFFFFF
 };
 
+enum ip_ver_legacy {
+	IP_LEGACY_VER_MT6781 = 0x10380000,
+	IP_LEGACY_VER_MT6879 = 0x10360000,
+	IP_LEGACY_VER_MT6893 = 0x20160706
+};
+
 #endif /* !_UFS_MEDIATEK_H */
-- 
2.45.2

