Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2B02C38A2D
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Oct 2022 07:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233245AbiJZHkG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 03:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiJZHkD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 03:40:03 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 998A813CFA
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 00:39:57 -0700 (PDT)
X-UUID: 97cd148f2f8941378503f37dbe7aae8f-20221026
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Z1gFY3alioo5hLWRum8LaBv7avS7z7Myd6WGS9UzTTs=;
        b=lBfeCWZz7JEYSQ9cW1BMNq/76yX3C3N131eOxaUlZub0928+dXzwfzM+4DzcCvMkSRNUS4186HHhQ5jjH/GVgKmAwxyGiDqcPzgMPYDeHixwhY0VsEY142GWOi4tQvLmiHaQSfH5TXTkGD2NNkfl7LxMhMaEJpxjRoPhk4wq8EE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:bbe05789-832f-424e-aeeb-e86d3e3155f2,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:90
X-CID-INFO: VERSION:1.1.12,REQID:bbe05789-832f-424e-aeeb-e86d3e3155f2,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
        N:quarantine,TS:90
X-CID-META: VersionHash:62cd327,CLOUDID:9fe2b6e4-e572-4957-be22-d8f73f3158f9,B
        ulkID:221026153953QYFSVDV1,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 97cd148f2f8941378503f37dbe7aae8f-20221026
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <eddie.huang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 192730564; Wed, 26 Oct 2022 15:39:51 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 26 Oct 2022 15:39:50 +0800
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
Subject: [PATCH v1 1/2] ufs: core: mcq: Add config_mcq_resource vops
Date:   Wed, 26 Oct 2022 15:39:42 +0800
Message-ID: <20221026073943.22111-2-eddie.huang@mediatek.com>
X-Mailer: git-send-email 2.9.2
In-Reply-To: <20221026073943.22111-1-eddie.huang@mediatek.com>
References: <20221026073943.22111-1-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

SoCs vendor config MCQ register address resource in
config_mcq_resource vops

Signed-off-by: Eddie Huang <eddie.huang@mediatek.com>
---
 drivers/ufs/core/ufs-mcq.c     | 3 +++
 drivers/ufs/core/ufshcd-priv.h | 8 ++++++++
 include/ufs/ufshcd.h           | 1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index b51ba35..1fdb45a 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -173,6 +173,9 @@ static int ufshcd_mcq_config_resource(struct ufs_hba *hba)
 	struct resource *res_mem, *res_mcq;
 	int i, ret = 0;
 
+	if (ufshcd_mcq_vops_config_resource(hba) == 0)
+		return 0;
+
 	memcpy(hba->res, ufs_res_info, sizeof(ufs_res_info));
 
 	for (i = 0; i < RES_MAX; i++) {
diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
index 6e9bec6..2f71b0e 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -257,6 +257,14 @@ static inline int ufshcd_vops_get_outstanding_cqs(struct ufs_hba *hba,
 	return -EOPNOTSUPP;
 }
 
+static inline int ufshcd_mcq_vops_config_resource(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->config_mcq_resource)
+		return hba->vops->config_mcq_resource(hba);
+
+	return -EOPNOTSUPP;
+}
+
 extern const struct ufs_pm_lvl_states ufs_pm_lvl_states[];
 
 /**
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 506fc6e..be323c9 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -339,6 +339,7 @@ struct ufs_hba_variant_ops {
 	int	(*op_runtime_config)(struct ufs_hba *hba);
 	int	(*get_outstanding_cqs)(struct ufs_hba *hba,
 				       unsigned long *ocqs);
+	int	(*config_mcq_resource)(struct ufs_hba *hba);
 };
 
 /* clock gating state  */
-- 
2.9.2

