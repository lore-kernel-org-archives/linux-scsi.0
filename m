Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C3EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 10:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F44B61355
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 10:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbhJSKzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 06:55:46 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:36964 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230097AbhJSKzo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 06:55:44 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Uswb3AN_1634640805;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Uswb3AN_1634640805)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Oct 2021 18:53:30 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     kashyap.desai@broadcom.com
Cc:     sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: megaraid_mbox: return -ENOMEM on megaraid_init_mbox() allocation failure
Date:   Tue, 19 Oct 2021 18:53:20 +0800
Message-Id: <1634640800-22502-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

Fixes the following smatch warning:

drivers/scsi/megaraid/megaraid_mbox.c:715 megaraid_init_mbox() warn:
returning -1 instead of -ENOMEM is sloppy.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: dd00cc486ab1 ("some kmalloc/memset ->kzalloc (tree wide)")
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index 14f930d27ca1..d98b223eab9a 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -712,7 +712,8 @@ megaraid_init_mbox(adapter_t *adapter)
 	 * controllers
 	 */
 	raid_dev = kzalloc(sizeof(mraid_device_t), GFP_KERNEL);
-	if (raid_dev == NULL) return -1;
+	if (raid_dev == NULL)
+		return -ENOMEM;
 
 
 	/*
-- 
2.19.1.6.gb485710b

