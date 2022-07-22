Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49CAFC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jul 2022 09:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234522AbiGVJxV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jul 2022 05:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiGVJxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2022 05:53:20 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBA42ED
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jul 2022 02:53:14 -0700 (PDT)
X-UUID: 2749a9920fdd4456b54b0af0572a9b64-20220722
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:3a4d175d-4faf-437b-b787-44fee4ef5763,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:0
X-CID-META: VersionHash:0f94e32,CLOUDID:66d79029-fd69-41f1-91fc-8b8a329d3a88,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:nil,BEC:nil,COL:0
X-UUID: 2749a9920fdd4456b54b0af0572a9b64-20220722
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 158808918; Fri, 22 Jul 2022 17:53:11 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Fri, 22 Jul 2022 17:53:10 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 22 Jul 2022 17:53:10 +0800
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
Subject: [PATCH v1] ufs: core: fix lockdep warning of clk_scaling_lock
Date:   Fri, 22 Jul 2022 17:53:08 +0800
Message-ID: <20220722095308.10112-1-peter.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

There have a lockdep warning like below in current flow.
kworker/u16:0:  Possible unsafe locking scenario:

kworker/u16:0:        CPU0                    CPU1
kworker/u16:0:        ----                    ----
kworker/u16:0:   lock(&hba->clk_scaling_lock);
kworker/u16:0:                                lock(&hba->dev_cmd.lock);
kworker/u16:0:                                lock(&hba->clk_scaling_lock);
kworker/u16:0:   lock(&hba->dev_cmd.lock);
kworker/u16:0:

Because ufshcd_wb_toggle -> ufshcd_query_flag -> ufshcd_exec_dev_cmd
will get read lock of clk_scaling_lock, so ufshcd_devfreq_scale
can release read lock before call ufshcd_wb_toggle.
This patch only release write lock of clk_scaling_lock before
ufshcd_wb_toggle.

---
 drivers/ufs/core/ufshcd.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index c7b337480e3e..209089bd8085 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1249,12 +1249,10 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	return ret;
 }
 
-static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
+static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
-	if (writelock)
-		up_write(&hba->clk_scaling_lock);
-	else
-		up_read(&hba->clk_scaling_lock);
+	up_write(&hba->clk_scaling_lock);
+
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 }
@@ -1271,7 +1269,7 @@ static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, bool writelock)
 static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 {
 	int ret = 0;
-	bool is_writelock = true;
+	bool wb_toggle = false;
 
 	ret = ufshcd_clock_scaling_prepare(hba);
 	if (ret)
@@ -1300,13 +1298,15 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 		}
 	}
 
-	/* Enable Write Booster if we have scaled up else disable it */
-	downgrade_write(&hba->clk_scaling_lock);
-	is_writelock = false;
-	ufshcd_wb_toggle(hba, scale_up);
+	wb_toggle = true;
 
 out_unprepare:
-	ufshcd_clock_scaling_unprepare(hba, is_writelock);
+	ufshcd_clock_scaling_unprepare(hba);
+
+	/* Enable Write Booster if we have scaled up else disable it */
+	if (wb_toggle)
+		ufshcd_wb_toggle(hba, scale_up);
+
 	return ret;
 }
 
-- 
2.18.0

