Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477A0C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 09:15:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01BBF6121E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 09:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhELJQj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 05:16:39 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:42565 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S230035AbhELJQi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 05:16:38 -0400
X-UUID: 952cfad86ec145feb425811659404855-20210512
X-UUID: 952cfad86ec145feb425811659404855-20210512
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1289632303; Wed, 12 May 2021 17:15:28 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs08n2.mediatek.inc (172.21.101.56) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 May 2021 17:15:22 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 May 2021 17:15:22 +0800
From:   <peter.wang@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Subject: [PATCH v2 1/1] scsi: ufs-mediatek: fix ufs power down specs violation
Date:   Wed, 12 May 2021 17:15:18 +0800
Message-ID: <1620810918-23422-2-git-send-email-peter.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1620810918-23422-1-git-send-email-peter.wang@mediatek.com>
References: <1620810918-23422-1-git-send-email-peter.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Wang <peter.wang@mediatek.com>

As per specs, e.g, JESD220E chapter 7.2, while powering off
the ufs device, RST_N signal should be between VSS(Ground)
and VCCQ/VCCQ2. The power down sequence after fixing as below:

Power down:
1. Assert RST_N low
2. Turn-off VCC
3. Turn-off VCCQ/VCCQ2

Change-Id: I297e9afe3c22bb1a5fc5e7acce9b5ecfd20181ed
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
---
 drivers/scsi/ufs/ufs-mediatek.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index c55202b..47f47ab 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -922,6 +922,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	int err;
+	struct arm_smccc_res res;
 
 	if (ufshcd_is_link_hibern8(hba)) {
 		err = ufs_mtk_link_set_lpm(hba);
@@ -941,6 +942,9 @@ static int ufs_mtk_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			goto fail;
 	}
 
+	if (ufshcd_is_shutdown_pm(pm_op))
+		ufs_mtk_device_reset_ctrl(0, res);
+
 	return 0;
 fail:
 	/*
-- 
1.7.9.5

