Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9669FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 10:51:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E922610E5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 10:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbhJSKxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 06:53:30 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:48397 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235180AbhJSKx2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Oct 2021 06:53:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R411e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UsvUfEV_1634640657;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UsvUfEV_1634640657)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Oct 2021 18:51:13 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     aacraid@microsemi.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        chongjiapeng <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] scsi: core: return -ENOMEM on ips_init_phase1() allocation failure
Date:   Tue, 19 Oct 2021 18:50:55 +0800
Message-Id: <1634640655-20667-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: chongjiapeng <jiapeng.chong@linux.alibaba.com>

Fixes the following smatch warning:

drivers/scsi/ips.c:6901 ips_init_phase1() warn: returning -1 instead of
-ENOMEM is sloppy.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: dd00cc486ab1 ("some kmalloc/memset ->kzalloc (tree wide)")
Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/ips.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 498bf04499ce..2ce97f407d18 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -6898,7 +6898,7 @@ ips_init_phase1(struct pci_dev *pci_dev, int *indexPtr)
 	if (ha == NULL) {
 		IPS_PRINTK(KERN_WARNING, pci_dev,
 			   "Unable to allocate temporary ha struct\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	ips_sh[index] = NULL;
-- 
2.19.1.6.gb485710b

