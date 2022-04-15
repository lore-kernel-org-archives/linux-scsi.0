Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A3AC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 03:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349063AbiDODZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Apr 2022 23:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349043AbiDODZo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2022 23:25:44 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0779D4F0;
        Thu, 14 Apr 2022 20:23:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=dtcccc@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0VA5Gud0_1649992993;
Received: from localhost.localdomain(mailfrom:dtcccc@linux.alibaba.com fp:SMTPD_---0VA5Gud0_1649992993)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Apr 2022 11:23:14 +0800
From:   Tianchen Ding <dtcccc@linux.alibaba.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] scsi: ses: Fix out-of-bound write at ses_enclosure_data_process()
Date:   Fri, 15 Apr 2022 11:23:13 +0800
Message-Id: <20220415032313.94991-1-dtcccc@linux.alibaba.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Our modified KFENCE reported a memory corruption:

[   52.584914] BUG: KFENCE: memory corruption in ses_enclosure_data_process+0x24b/0x310 [ses]

[   52.584917] Corrupted memory at 0xffff88982de06ff0 [ 0x00 . . . . . . . . . . . . . . . ] (in kfence-#1624698):
[   52.607212]  ses_enclosure_data_process+0x24b/0x310 [ses]
[   52.607215]  ses_intf_add+0x444/0x542 [ses]
[   52.621369]  class_interface_register+0x110/0x120
[   52.621373]  ses_init+0x13/0x1000 [ses]
[   52.621377]  do_one_initcall+0x41/0x1c0
[   52.621380]  do_init_module+0x5c/0x260
[   52.621382]  __do_sys_finit_module+0xb1/0x110
[   52.621386]  do_syscall_64+0x2d/0x40
[   52.621388]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[   52.621393] kfence-#1624698 [0xffff88982de06fc0-0xffff88982de06fe0, size=33, cache=kmalloc-64] allocated by task 1033:
[   52.670344]  ses_enclosure_data_process+0x2ae/0x310 [ses]
[   52.670347]  ses_intf_add+0x444/0x542 [ses]
[   52.670353]  class_interface_register+0x110/0x120
[   52.688165]  ses_init+0x13/0x1000 [ses]
[   52.688169]  do_one_initcall+0x41/0x1c0
[   52.688172]  do_init_module+0x5c/0x260
[   52.688174]  __do_sys_finit_module+0xb1/0x110
[   52.688177]  do_syscall_64+0x2d/0x40
[   52.688179]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

This is because we check desc_ptr >= buf + page7_len first but then
write '\0' to desc_ptr[len+4], while this address may be out of bound.

Fixes: 21fab1d0595e ("[SCSI] ses: update enclosure data on hot add")
Signed-off-by: Tianchen Ding <dtcccc@linux.alibaba.com>
---
 drivers/scsi/ses.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..06b991e27c84 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -559,11 +559,11 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			struct enclosure_component *ecomp;
 
 			if (desc_ptr) {
-				if (desc_ptr >= buf + page7_len) {
+				len = (desc_ptr[2] << 8) + desc_ptr[3];
+				desc_ptr += 4;
+				if (desc_ptr + len > buf + page7_len) {
 					desc_ptr = NULL;
 				} else {
-					len = (desc_ptr[2] << 8) + desc_ptr[3];
-					desc_ptr += 4;
 					/* Add trailing zero - pushes into
 					 * reserved space */
 					desc_ptr[len] = '\0';
-- 
2.33.0

