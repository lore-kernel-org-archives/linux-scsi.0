Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2ED93ECAAA1
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 13:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiJXNKi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Oct 2022 09:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235870AbiJXNJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2022 09:09:53 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4672C17401
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2022 05:23:32 -0700 (PDT)
X-UUID: e6be62e6014a4862a44e8cd3b17c5021-20221024
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=sFjsyP8ZKZS0F9t1VR6XE2dkw5z7AQiMIr8WnQjyVtY=;
        b=efs0JhyieJVELkYHwe9neZdl0pc+/ISG3YNll4VYweOOxZqxXU3KwSVZKl+63mhAil5K+7JBKkLzoMrrwKLRRUnxb6ODCyP1SmvB6rE+hX3E2tKPP6FGHFXPoIu+bLnXDobKj1zP+QAVCoKc0RkZeJaK7DYsLF2yroi7wMGRCjk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:7be86530-9179-44e1-96d9-f57c4cebb853,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:90
X-CID-INFO: VERSION:1.1.12,REQID:7be86530-9179-44e1-96d9-f57c4cebb853,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:0,SF:95,FILE:0,BULK:0,RULE:Spam_GS981B3D,ACTIO
        N:quarantine,TS:90
X-CID-META: VersionHash:62cd327,CLOUDID:9f6282c8-03ab-4171-989e-341ab5339257,B
        ulkID:221024200608K5U9JB2K,BulkQuantity:0,Recheck:0,SF:38|28|17|19|48,TC:n
        il,Content:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: e6be62e6014a4862a44e8cd3b17c5021-20221024
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1158467370; Mon, 24 Oct 2022 20:06:06 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 24 Oct 2022 20:06:04 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Mon, 24 Oct 2022 20:06:04 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Subject: [PATCH v1] ufs: core: print more evt history
Date:   Mon, 24 Oct 2022 20:06:02 +0800
Message-ID: <20221024120602.30019-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

Some error event is missing in ufshcd_print_evt_hist.
Add print for this error event.

Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/ufs/core/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca6..ed354febed29 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -486,6 +486,9 @@ static void ufshcd_print_evt_hist(struct ufs_hba *hba)
 	ufshcd_print_evt(hba, UFS_EVT_RESUME_ERR, "resume_fail");
 	ufshcd_print_evt(hba, UFS_EVT_SUSPEND_ERR,
 			 "suspend_fail");
+	ufshcd_print_evt(hba, UFS_EVT_WL_RES_ERR, "wlun resume_fail");
+	ufshcd_print_evt(hba, UFS_EVT_WL_SUSP_ERR,
+			 "wlun suspend_fail");
 	ufshcd_print_evt(hba, UFS_EVT_DEV_RESET, "dev_reset");
 	ufshcd_print_evt(hba, UFS_EVT_HOST_RESET, "host_reset");
 	ufshcd_print_evt(hba, UFS_EVT_ABORT, "task_abort");
-- 
2.18.0

