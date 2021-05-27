Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD22C47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:02:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97E15611CD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 16:02:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbhE0QEE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 12:04:04 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:56387 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S234782AbhE0QEB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 12:04:01 -0400
X-UUID: b514b908cff74303813b75ef07dc65f2-20210528
X-UUID: b514b908cff74303813b75ef07dc65f2-20210528
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <alice.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1939296915; Fri, 28 May 2021 00:02:26 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 28 May 2021 00:02:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 28 May 2021 00:02:24 +0800
From:   Alice <alice.chao@mediatek.com>
To:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <peter.wang@mediatek.com>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <powen.kao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>
Subject: [PATCH 1/1] scsi: ufs-mediatek: Fix HWReset timing
Date:   Fri, 28 May 2021 00:02:09 +0800
Message-ID: <20210527160209.17231-2-alice.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20210527160209.17231-1-alice.chao@mediatek.com>
References: <20210527160209.17231-1-alice.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Alice.Chao" <alice.chao@mediatek.com>

HCI disable before HW Reset.
Because of the property of mtk ufshci,
we need to change reset flow to avoid potential issues.

Change-Id: I3eb917fd2953b58dcf7e021286d1de71c9232cfb
Signed-off-by: Alice.Chao <alice.chao@mediatek.com>
CR-Id: ALPS05728133
Feature: UFS(Universal Flash Storage)
---
 drivers/scsi/ufs/ufs-mediatek.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index a981f261b304..c62603ed3d33 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -846,6 +846,9 @@ static int ufs_mtk_device_reset(struct ufs_hba *hba)
 {
 	struct arm_smccc_res res;
 
+	/* disable hba before device reset */
+	ufshcd_hba_stop(hba);
+
 	ufs_mtk_device_reset_ctrl(0, res);
 
 	/*
-- 
2.18.0

