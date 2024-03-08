Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541391CFB2
	for <linux-scsi@vger.kernel.org>; Fri,  8 Mar 2024 07:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709881374; cv=none; b=cU5fpk73QC3mwYgfpopyNSJTxK9h8h0P1H5GUdAR+Z8tJAq3t92NfAuuQWZfp7xAoMsb1vb/KMw+C/3nN0OuaI3l4lbATUFNfQkq2xrnB7k91URXmlzekBaItngSKLIBVa7bMtIYEzl8r56N/opYkYPVxVOsmYbSa7b5V7rmJ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709881374; c=relaxed/simple;
	bh=lavoBp2dFWT5Rz5QzyMMnBbXVtR8+OKozSZ7zJhYb00=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NgxQu+K1N2EtdvAtU4b/HCBUjLApPQ5bTba+xV16UCxpmhfeUI5ERTUSwZVQQQGDIIzq1YVZ+Zjdr87vN8eXsu0+nVuPCF8BVSsV1ht6VyaWcsdWCRCGk0hRmHx5BrwVicE7LTQMyNtptssiJ/j6WrSeIqX8mINlq/lNGnBdVlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=dPrcMwzK; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="dPrcMwzK"
X-UUID: dd1c8bacdd1911ee935d6952f98a51a9-20240308
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=aZAUzmXcDPsRydiyY1LflM9eKbdm2UGJ7VfbLXQMNPM=;
	b=dPrcMwzK6eIwnlvmhChD6OcEOQ7qXtYh7kRs3fA1XTPOXPEkPYrxvBFEzY9OF/OiSwtaae5Pw7RELjr2XeruzGJEM9cshrmiOTxtFA1Sjo7JUW7zNOS/YlDp8PD+g9alWepi4sUef8QmbWUErSASaJlN9phUmjFs41CV0N5cp+8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:c9604209-cde5-4963-bdae-b4aaa8682d49,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:089aa8ff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: dd1c8bacdd1911ee935d6952f98a51a9-20240308
Received: from mtkmbs13n1.mediatek.inc [(172.21.101.193)] by mailgw02.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 382913652; Fri, 08 Mar 2024 15:02:44 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 8 Mar 2024 15:02:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 8 Mar 2024 15:02:44 +0800
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
Subject: [PATCH v1 4/7] ufs: host: mediatek: ufs mtk sip command reconstruct
Date: Fri, 8 Mar 2024 15:02:38 +0800
Message-ID: <20240308070241.9163-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240308070241.9163-1-peter.wang@mediatek.com>
References: <20240308070241.9163-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--6.461700-8.000000
X-TMASE-MatchedRID: B6j6C829dRoMQLXc2MGSbNIKqYKXY3SWLoYOuiLW+uVnnK6mXN72myKz
	h5wZeOKyeeTK1AUftLJM8qdoCvOVvj13WcdbGR6QyeVujmXuYYXzWEMQjooUzUYvSDWdWaRhVSd
	AA6mVeIZZ5DVQDc2sDZ2hJeRJMbudngk9B7BU8G9VTfJWlqPdDO3+iQEtoSj4Ydn5x3tXIpe/b9
	EjSOMJJG9ouIygpjDSsGRzEHTW2nEfE8yM4pjsDwtuKBGekqUpI/NGWt0UYPDnPr4wtyjJvF+mM
	DFkG4GgdxbJrBNty0TYjs8v2qLr1xT5eR7DbmvA
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.461700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: CE1DC8A20C5CB37381B195FE9423F90A3C388DD1A2DF6D7032DB5AB85B3150322000:8
X-MTK: N

From: Peter Wang <peter.wang@mediatek.com>

From: Po-Wen Kao <powen.kao@mediatek.com>

Move sip command and define to a new sip header file.

Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek-sip.h | 90 +++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.c     |  3 +-
 drivers/ufs/host/ufs-mediatek.h     | 79 -------------------------
 3 files changed, 92 insertions(+), 80 deletions(-)
 create mode 100755 drivers/ufs/host/ufs-mediatek-sip.h

diff --git a/drivers/ufs/host/ufs-mediatek-sip.h b/drivers/ufs/host/ufs-mediatek-sip.h
new file mode 100755
index 000000000000..30146bb1ccbe
--- /dev/null
+++ b/drivers/ufs/host/ufs-mediatek-sip.h
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2022 MediaTek Inc.
+ */
+
+#ifndef _UFS_MEDIATEK_SIP_H
+#define _UFS_MEDIATEK_SIP_H
+
+#include <linux/soc/mediatek/mtk_sip_svc.h>
+
+/*
+ * SiP commands
+ */
+#define MTK_SIP_UFS_CONTROL               MTK_SIP_SMC_CMD(0x276)
+#define UFS_MTK_SIP_VA09_PWR_CTRL         BIT(0)
+#define UFS_MTK_SIP_DEVICE_RESET          BIT(1)
+#define UFS_MTK_SIP_CRYPTO_CTRL           BIT(2)
+#define UFS_MTK_SIP_REF_CLK_NOTIFICATION  BIT(3)
+#define UFS_MTK_SIP_HOST_PWR_CTRL         BIT(5)
+#define UFS_MTK_SIP_GET_VCC_NUM           BIT(6)
+#define UFS_MTK_SIP_DEVICE_PWR_CTRL       BIT(7)
+
+
+/*
+ * Multi-VCC by Numbering
+ */
+enum ufs_mtk_vcc_num {
+	UFS_VCC_NONE = 0,
+	UFS_VCC_1,
+	UFS_VCC_2,
+	UFS_VCC_MAX
+};
+
+/*
+ * Host Power Control options
+ */
+enum {
+	HOST_PWR_HCI = 0,
+	HOST_PWR_MPHY
+};
+
+/*
+ * SMC call wrapper function
+ */
+struct ufs_mtk_smc_arg {
+	unsigned long cmd;
+	struct arm_smccc_res *res;
+	unsigned long v1;
+	unsigned long v2;
+	unsigned long v3;
+	unsigned long v4;
+	unsigned long v5;
+	unsigned long v6;
+	unsigned long v7;
+};
+
+
+static inline void _ufs_mtk_smc(struct ufs_mtk_smc_arg s)
+{
+	arm_smccc_smc(MTK_SIP_UFS_CONTROL,
+		s.cmd,
+		s.v1, s.v2, s.v3, s.v4, s.v5, s.v6, s.res);
+}
+
+#define ufs_mtk_smc(...) \
+	_ufs_mtk_smc((struct ufs_mtk_smc_arg) {__VA_ARGS__})
+
+/* Sip kernel interface */
+#define ufs_mtk_va09_pwr_ctrl(res, on) \
+	ufs_mtk_smc(UFS_MTK_SIP_VA09_PWR_CTRL, &(res), on)
+
+#define ufs_mtk_crypto_ctrl(res, enable) \
+	ufs_mtk_smc(UFS_MTK_SIP_CRYPTO_CTRL, &(res), enable)
+
+#define ufs_mtk_ref_clk_notify(on, stage, res) \
+	ufs_mtk_smc(UFS_MTK_SIP_REF_CLK_NOTIFICATION, &(res), on, stage)
+
+#define ufs_mtk_device_reset_ctrl(high, res) \
+	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, &(res), high)
+
+#define ufs_mtk_host_pwr_ctrl(opt, on, res) \
+	ufs_mtk_smc(UFS_MTK_SIP_HOST_PWR_CTRL, &(res), opt, on)
+
+#define ufs_mtk_get_vcc_num(res) \
+	ufs_mtk_smc(UFS_MTK_SIP_GET_VCC_NUM, &(res))
+
+#define ufs_mtk_device_pwr_ctrl(on, ufs_version, res) \
+	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_PWR_CTRL, &(res), on, ufs_version)
+
+#endif /* !_UFS_MEDIATEK_SIP_H */
diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index cdf29cfa490b..ae184e4f90e6 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -20,13 +20,14 @@
 #include <linux/pm_qos.h>
 #include <linux/regulator/consumer.h>
 #include <linux/reset.h>
-#include <linux/soc/mediatek/mtk_sip_svc.h>
 
 #include <ufs/ufshcd.h>
 #include "ufshcd-pltfrm.h"
 #include <ufs/ufs_quirks.h>
 #include <ufs/unipro.h>
+
 #include "ufs-mediatek.h"
+#include "ufs-mediatek-sip.h"
 
 static int  ufs_mtk_config_mcq(struct ufs_hba *hba, bool irq);
 
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index 79c64de25254..17be3f748fa0 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -8,7 +8,6 @@
 
 #include <linux/bitops.h>
 #include <linux/pm_qos.h>
-#include <linux/soc/mediatek/mtk_sip_svc.h>
 
 /*
  * MCQ define and struct
@@ -100,18 +99,6 @@ enum {
 	VS_HIB_EXIT                 = 13,
 };
 
-/*
- * SiP commands
- */
-#define MTK_SIP_UFS_CONTROL               MTK_SIP_SMC_CMD(0x276)
-#define UFS_MTK_SIP_VA09_PWR_CTRL         BIT(0)
-#define UFS_MTK_SIP_DEVICE_RESET          BIT(1)
-#define UFS_MTK_SIP_CRYPTO_CTRL           BIT(2)
-#define UFS_MTK_SIP_REF_CLK_NOTIFICATION  BIT(3)
-#define UFS_MTK_SIP_HOST_PWR_CTRL         BIT(5)
-#define UFS_MTK_SIP_GET_VCC_NUM           BIT(6)
-#define UFS_MTK_SIP_DEVICE_PWR_CTRL       BIT(7)
-
 /*
  * VS_DEBUGCLOCKENABLE
  */
@@ -197,70 +184,4 @@ struct ufs_mtk_host {
 	struct ufs_mtk_mcq_intr_info mcq_intr_info[UFSHCD_MAX_Q_NR];
 };
 
-/*
- * Multi-VCC by Numbering
- */
-enum ufs_mtk_vcc_num {
-	UFS_VCC_NONE = 0,
-	UFS_VCC_1,
-	UFS_VCC_2,
-	UFS_VCC_MAX
-};
-
-/*
- * Host Power Control options
- */
-enum {
-	HOST_PWR_HCI = 0,
-	HOST_PWR_MPHY
-};
-
-/*
- * SMC call wrapper function
- */
-struct ufs_mtk_smc_arg {
-	unsigned long cmd;
-	struct arm_smccc_res *res;
-	unsigned long v1;
-	unsigned long v2;
-	unsigned long v3;
-	unsigned long v4;
-	unsigned long v5;
-	unsigned long v6;
-	unsigned long v7;
-};
-
-static void _ufs_mtk_smc(struct ufs_mtk_smc_arg s)
-{
-	arm_smccc_smc(MTK_SIP_UFS_CONTROL,
-		      s.cmd, s.v1, s.v2, s.v3, s.v4, s.v5, s.v6, s.res);
-}
-
-#define ufs_mtk_smc(...) \
-	_ufs_mtk_smc((struct ufs_mtk_smc_arg) {__VA_ARGS__})
-
-/*
- * SMC call interface
- */
-#define ufs_mtk_va09_pwr_ctrl(res, on) \
-	ufs_mtk_smc(UFS_MTK_SIP_VA09_PWR_CTRL, &(res), on)
-
-#define ufs_mtk_crypto_ctrl(res, enable) \
-	ufs_mtk_smc(UFS_MTK_SIP_CRYPTO_CTRL, &(res), enable)
-
-#define ufs_mtk_ref_clk_notify(on, stage, res) \
-	ufs_mtk_smc(UFS_MTK_SIP_REF_CLK_NOTIFICATION, &(res), on, stage)
-
-#define ufs_mtk_device_reset_ctrl(high, res) \
-	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_RESET, &(res), high)
-
-#define ufs_mtk_host_pwr_ctrl(opt, on, res) \
-	ufs_mtk_smc(UFS_MTK_SIP_HOST_PWR_CTRL, &(res), opt, on)
-
-#define ufs_mtk_get_vcc_num(res) \
-	ufs_mtk_smc(UFS_MTK_SIP_GET_VCC_NUM, &(res))
-
-#define ufs_mtk_device_pwr_ctrl(on, ufs_ver, res) \
-	ufs_mtk_smc(UFS_MTK_SIP_DEVICE_PWR_CTRL, &(res), on, ufs_ver)
-
 #endif /* !_UFS_MEDIATEK_H */
-- 
2.18.0

