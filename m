Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8088FFA3742
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 07:40:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233268AbiJZHkI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiJZHkF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 03:40:05 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDB713E16
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 00:39:58 -0700 (PDT)
X-UUID: 2a2dcd859ad243e99f3b3b6c58f89286-20221026
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=VY59DSr/vLv19nNx/B+Y43pG1dxoo/HaYIuPllk8qdg=;
        b=iE97Wp/D3wPRAcdKHTy/u0KnSADBjhUuFLRD1EaYiiiKUG2NrDhFLndRuKUktlPa4Fqf5CjnK186PFlk96abEMb3G/nhn8BTpakh6FBEi7f2roNFFJKU7YSiRyAwfuZEk1bV3n9qN8cNBisZpuiaz8E9C9EaDVFqDPLMCLK7WVY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:8c1d4b47-fe2a-454a-9390-10ceb764f554,IP:0,U
        RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTI
        ON:release,TS:70
X-CID-INFO: VERSION:1.1.12,REQID:8c1d4b47-fe2a-454a-9390-10ceb764f554,IP:0,URL
        :0,TC:0,Content:-25,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTI
        ON:quarantine,TS:70
X-CID-META: VersionHash:62cd327,CLOUDID:89bc2d27-9eb1-469f-b210-e32d06cfa36e,B
        ulkID:2210261539532I77BJK6,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 2a2dcd859ad243e99f3b3b6c58f89286-20221026
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <eddie.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1167171629; Wed, 26 Oct 2022 15:39:51 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 26 Oct 2022 15:39:50 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 26 Oct 2022 15:39:50 +0800
From:   Eddie Huang <eddie.huang@mediatek.com>
To:     Asutosh Das <quic_asutoshd@quicinc.com>,
        <martin.petersen@oracle.com>, <stanley.chu@mediatek.com>,
        <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
CC:     <avri.altman@wdc.com>, <liang-yen.wang@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <cc.chou@mediatek.com>,
        <powen.kao@mediatek.com>, Eddie Huang <eddie.huang@mediatek.com>
Subject: [PATCH v1 2/2] ufs: mtk-host: Add MCQ feature
Date:   Wed, 26 Oct 2022 15:39:43 +0800
Message-ID: <20221026073943.22111-3-eddie.huang@mediatek.com>
X-Mailer: git-send-email 2.9.2
In-Reply-To: <20221026073943.22111-1-eddie.huang@mediatek.com>
References: <20221026073943.22111-1-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add Mediatek mcq resource and runtime configuration function
to support MCQ capability

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 drivers/ufs/host/ufs-mediatek.c | 37 +++++++++++++++++++++++++++++++++++++
 drivers/ufs/host/ufs-mediatek.h |  7 +++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/ufs/host/ufs-mediatek.c b/drivers/ufs/host/ufs-mediatek.c
index c958279..3f5fc05 100644
--- a/drivers/ufs/host/ufs-mediatek.c
+++ b/drivers/ufs/host/ufs-mediatek.c
@@ -31,6 +31,8 @@
 #define CREATE_TRACE_POINTS
 #include "ufs-mediatek-trace.h"
 
+#define MCQ_QUEUE_OFFSET(c) ((((c) >> 16) & 0xFF) * 0x200)
+
 static const struct ufs_dev_quirk ufs_mtk_dev_fixups[] = {
 	{ .wmanufacturerid = UFS_ANY_VENDOR,
 	  .model = UFS_ANY_MODEL,
@@ -833,6 +835,8 @@ static int ufs_mtk_init(struct ufs_hba *hba)
 
 	host->ip_ver = ufshcd_readl(hba, REG_UFS_MTK_IP_VER);
 
+	hba->caps |= UFSHCD_CAP_MCQ_EN;
+
 	goto out;
 
 out_variant_clear:
@@ -1314,6 +1318,37 @@ static void ufs_mtk_event_notify(struct ufs_hba *hba,
 	trace_ufs_mtk_event(evt, val);
 }
 
+static int ufs_mtk_op_runtime_config(struct ufs_hba *hba)
+{
+	struct ufshcd_mcq_opr_info_t *opr;
+	int i;
+
+	for (i = 0; i < OPR_MAX; i++) {
+		opr = &hba->mcq_opr[i];
+		opr->stride = REG_UFS_MCQ_STRIDE;
+	}
+
+	hba->mcq_opr[OPR_SQD].offset = REG_UFS_MTK_SQD;
+	hba->mcq_opr[OPR_SQIS].offset = REG_UFS_MTK_SQIS;
+	hba->mcq_opr[OPR_CQD].offset = REG_UFS_MTK_CQD;
+	hba->mcq_opr[OPR_CQIS].offset = REG_UFS_MTK_CQIS;
+
+	hba->mcq_opr[OPR_SQD].base = hba->mmio_base + REG_UFS_MTK_SQD;
+	hba->mcq_opr[OPR_SQIS].base = hba->mmio_base + REG_UFS_MTK_SQIS;
+	hba->mcq_opr[OPR_CQD].base = hba->mmio_base + REG_UFS_MTK_CQD;
+	hba->mcq_opr[OPR_CQIS].base = hba->mmio_base + REG_UFS_MTK_CQIS;
+
+	return 0;
+}
+
+static int ufs_mtk_config_mcq_resource(struct ufs_hba *hba)
+{
+	hba->mcq_base = hba->mmio_base +
+					MCQ_QUEUE_OFFSET(hba->mcq_capabilities);
+
+	return 0;
+}
+
 /*
  * struct ufs_hba_mtk_vops - UFS MTK specific variant operations
  *
@@ -1335,6 +1370,8 @@ static const struct ufs_hba_variant_ops ufs_hba_mtk_vops = {
 	.dbg_register_dump   = ufs_mtk_dbg_register_dump,
 	.device_reset        = ufs_mtk_device_reset,
 	.event_notify        = ufs_mtk_event_notify,
+	.op_runtime_config   = ufs_mtk_op_runtime_config,
+	.config_mcq_resource = ufs_mtk_config_mcq_resource,
 };
 
 /**
diff --git a/drivers/ufs/host/ufs-mediatek.h b/drivers/ufs/host/ufs-mediatek.h
index aa26d41..febf702 100644
--- a/drivers/ufs/host/ufs-mediatek.h
+++ b/drivers/ufs/host/ufs-mediatek.h
@@ -26,6 +26,13 @@
 #define REG_UFS_DEBUG_SEL_B2        0x22D8
 #define REG_UFS_DEBUG_SEL_B3        0x22DC
 
+#define REG_UFS_MTK_SQD             0x2800
+#define REG_UFS_MTK_SQIS            0x2814
+#define REG_UFS_MTK_CQD             0x281C
+#define REG_UFS_MTK_CQIS            0x2824
+
+#define REG_UFS_MCQ_STRIDE          0x30
+
 /*
  * Ref-clk control
  *
-- 
2.9.2

