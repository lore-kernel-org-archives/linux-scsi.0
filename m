Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78D0C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 07:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A028C6124D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Sep 2021 07:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244324AbhIXHev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Sep 2021 03:34:51 -0400
Received: from mailgw01.mediatek.com ([60.244.123.138]:45330 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S231921AbhIXHeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2021 03:34:50 -0400
X-UUID: f73c5cca686d40e4897280c3ec968409-20210924
X-UUID: f73c5cca686d40e4897280c3ec968409-20210924
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <jonathan.hsu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 951111375; Fri, 24 Sep 2021 15:33:14 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.792.15; Fri, 24 Sep 2021 15:33:13 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 24 Sep 2021 15:33:13 +0800
From:   Jonathan Hsu <jonathan.hsu@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <stable@vger.kernel.org>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <wsd_upstream@mediatek.com>
Subject: [PATCH v1 1/1] scsi: ufs: Fix illegal address reading in upiu event trace
Date:   Fri, 24 Sep 2021 15:33:09 +0800
Message-ID: <20210924073309.6656-1-jonathan.hsu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix incorrect index for UTMRD reference in ufshcd_add_tm_upiu_trace().

Fixes: 4b42d557a8ad ("scsi: ufs: core: Fix wrong Task Tag used in task management request UPIUs")
Signed-off-by: Jonathan Hsu <jonathan.hsu@mediatek.com>
Change-Id: I9acab6f3223f96d864948bb5670759d58cf92ad6
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3841ab49f556..36aa27cdc2ab 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -319,8 +319,7 @@ static void ufshcd_add_query_upiu_trace(struct ufs_hba *hba,
 static void ufshcd_add_tm_upiu_trace(struct ufs_hba *hba, unsigned int tag,
 				     enum ufs_trace_str_t str_t)
 {
-	int off = (int)tag - hba->nutrs;
-	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[off];
+	struct utp_task_req_desc *descp = &hba->utmrdl_base_addr[tag];
 
 	if (!trace_ufshcd_upiu_enabled())
 		return;
-- 
2.18.0

