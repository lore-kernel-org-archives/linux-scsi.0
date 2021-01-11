Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369A2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E623D2250F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 09:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbhAKJaV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 04:30:21 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:58101 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727976AbhAKJaU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 04:30:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0ULMSlfj_1610357370;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0ULMSlfj_1610357370)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Jan 2021 17:29:35 +0800
From:   YANG LI <abaci-bugfix@linux.alibaba.com>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, skashyap@marvell.com,
        jhasan@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux@armlinux.org.uk, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        YANG LI <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] scsi: qedf: style: Simplify bool comparison
Date:   Mon, 11 Jan 2021 17:29:28 +0800
Message-Id: <1610357368-62866-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix the following coccicheck warning:
./drivers/scsi/qedf/qedf_main.c:3716:5-31: WARNING: Comparison to bool

Signed-off-by: YANG LI <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot<abaci@linux.alibaba.com>
---
 drivers/scsi/qedf/qedf_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 46d185c..cec27f2 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3713,7 +3713,7 @@ static void __qedf_remove(struct pci_dev *pdev, int mode)
 	else
 		fc_fabric_logoff(qedf->lport);
 
-	if (qedf_wait_for_upload(qedf) == false)
+	if (!qedf_wait_for_upload(qedf))
 		QEDF_ERR(&qedf->dbg_ctx, "Could not upload all sessions.\n");
 
 #ifdef CONFIG_DEBUG_FS
-- 
1.8.3.1

