Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D153C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 12:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 598706501C
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 12:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhCPMQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 08:16:43 -0400
Received: from m12-16.163.com ([220.181.12.16]:32803 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhCPMQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Mar 2021 08:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=T4KiiWIh4rt87rhPyI
        YwbvTb5hFpwH4hXDYNYg215Lw=; b=kx2C+8d0vNyVmAlyVZfYGQR+W4jVrzSA7j
        6d9oje/6hB6zMjIKbpIrt4fkDq5p0HArKie1vL8wpAVE3+YMO2AA/IJ4oDB62ipP
        vaoeo08yugOYU1K55HqXtAsd74y5eAL2BdMxwXo8yW14N7/QS1Z/qpRwJV45nvp1
        pJLmAlt1M=
Received: from bf-rmnj-02.ccdomain.com (unknown [218.94.48.178])
        by smtp12 (Coremail) with SMTP id EMCowADHz8dRoVBgeVCjgw--.16225S2;
        Tue, 16 Mar 2021 20:15:24 +0800 (CST)
From:   Jian Dong <dj0227@163.com>
To:     stanley.chu@mediatek.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, matthias.bgg@gmail.com
Cc:     linux-scsi@vger.kernel.org, dongjian <dongjian@yulong.com>,
        Yue Hu <huyue2@yulong.com>
Subject: [PATCH][RESEND] scsi: ufs-mediatek: Correct operator & -> &&
Date:   Tue, 16 Mar 2021 20:15:15 +0800
Message-Id: <1615896915-148864-1-git-send-email-dj0227@163.com>
X-Mailer: git-send-email 1.9.1
X-CM-TRANSID: EMCowADHz8dRoVBgeVCjgw--.16225S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruFWfur1UXF1Uur18JF1rXrb_yoWDGFg_CF
        WkXrsxW3yUGr4xAr1rXr4FyryIkF4rWr48AFnYvF9YyFZrWayIqw4vqr4v9w45X3y3X34D
        Z3Z0grnIyFn5CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0Ysj5UUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: dgmqjjqx6rljoofrz/1tbiFhxX3V44PXRakgAAsn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: dongjian <dongjian@yulong.com>

The "lpm" and "->enabled" are all bool type, it should be using
operator && rather than bit operator.

Fixes: 488edafb1120 (scsi: ufs-mediatek: Introduce low-power mode for device power supply)

Signed-off-by: dongjian <dongjian@yulong.com>
Signed-off-by: Yue Hu <huyue2@yulong.com>
---
 drivers/scsi/ufs/ufs-mediatek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index c55202b..a981f26 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -911,7 +911,7 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 	if (!hba->vreg_info.vccq2 || !hba->vreg_info.vcc)
 		return;
 
-	if (lpm & !hba->vreg_info.vcc->enabled)
+	if (lpm && !hba->vreg_info.vcc->enabled)
 		regulator_set_mode(hba->vreg_info.vccq2->reg,
 				   REGULATOR_MODE_IDLE);
 	else if (!lpm)
-- 
1.9.1


