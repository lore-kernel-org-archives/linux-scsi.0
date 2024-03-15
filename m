Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42A217C68
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 08:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710491706; cv=none; b=OqkF6mTnQ8G3laOKYgsOLEsngx890XCb+7a911RYA6jzxqjFi+yzFCwm88CSu51GpUuh2DqoCHgm9KvCJgXSOgQgYcpVEps4WH7NJyVekht6S5BgXOdqtFMSopuH63DiFfKK5CCg/ExpT8LIvnvQ+uXxYuY7vZwl2w3Y+0Ivg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710491706; c=relaxed/simple;
	bh=24UZ/o1Wdh+mtA9nQNCUbZxWLZiYz3rXbrykSTZFwNw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u3dc9qahZZaH7QqhRZgvcGugMapbHzU4LMKVL7lEZNDyNO2DYQN77xPcoZLmk7I54Pi9D0OmMTvklrxG9G9n07hzawxMtIjz43VpEGYzYKBviaKQW+SEq1u192L9E21wPjLEd1upHQIuaGfpCP7Z5PqtEtc84HAgsGGW7I74H34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=A6wEVPsS; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="A6wEVPsS"
X-UUID: e4ae8ea0e2a611eeb8927bc1f75efef4-20240315
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=yE4JBQTCPH3gA6ZXKyx8sgWao+HvBsWrcvvs5VHR2/A=;
	b=A6wEVPsSzSwREgj+fK2WnF7HB0eLeSdQtc/kL3qPGYjeBiTAMPA/bG6Ifpf5JiUdCVzs9hG4y+Ya8rVuGTU2aivJgkFiIUKObbwZxY84wmfYiGdSUIg8BM1WMX5lr1T48PUpOlN/U9iRjXa6tTPNGznuAsj7IcyhBQ6LuySNr7o=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.37,REQID:0047e6c0-390d-41ff-82cb-3f259939026e,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6f543d0,CLOUDID:09d0eeff-c16b-4159-a099-3b9d0558e447,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
	RL:11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES
	:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-UUID: e4ae8ea0e2a611eeb8927bc1f75efef4-20240315
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <peter.wang@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1506166101; Fri, 15 Mar 2024 16:34:52 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 15 Mar 2024 16:34:51 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Fri, 15 Mar 2024 16:34:51 +0800
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
Subject: [PATCH v2 4/7] ufs: host: mediatek: ufs mtk sip command reconstruct
Date: Fri, 15 Mar 2024 16:34:45 +0800
Message-ID: <20240315083448.7185-5-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20240315083448.7185-1-peter.wang@mediatek.com>
References: <20240315083448.7185-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-Product-Ver: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-AS-Result: No-10--6.741700-8.000000
X-TMASE-MatchedRID: jxLDw2lrPpv9jxte3IFskLiMC5wdwKqdf6/Md8Lb2l84YKAM3oRt9l0c
	vQ4E8DdUXk6mOXfvRmBM8qdoCvOVvj13WcdbGR6QyeVujmXuYYXzWEMQjooUzUYvSDWdWaRh/c+
	POq0n3JUSIx4SDL9Y5pNNyCYD/Z/9g4jZH72x494XrP0cYcrA24EcpMn6x9cZCqIJhrrDy28J64
	/kWP1C5qnX7naLYMc4ou7eTOm27Q0YB2fOueQzjxRFJJyf5BJe3QfwsVk0UbvdirxFVpmK9aHch
	3WEjd2F0nn3c1dbxAlDWsS2bc6upr30xNSH2BlAtZz3gO3LWCI=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.741700-8.000000
X-TMASE-Version: SMEX-14.0.0.3152-9.1.1006-23728.005
X-TM-SNTS-SMTP: 32482157928C4B65CAFD2AEC8DABE8A6FAEB78881EBB02EE5CA424F9AEC2BE422000:8
X-MTK: N

From: Po-Wen Kao <powen.kao@mediatek.com>

Move sip command and define to a new sip header file.

Acked-by: Chun-Hung Wu <Chun-Hung.Wu@mediatek.com>
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
index 000000000000..35d1d5e76a2c
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
+ * SiP (Slicon Partner) commands
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
index 2ee7881533ec..bb5b11185d8a 100644
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
index 3f698af5f5ac..9226e95c4a60 100644
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
@@ -198,70 +185,4 @@ struct ufs_mtk_host {
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

