Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82CDC07E96
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 07:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFC0361CDE
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jul 2021 07:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhGHHya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jul 2021 03:54:30 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:38348 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229851AbhGHHya (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2021 03:54:30 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xlpang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Uf5aDWK_1625730701;
Received: from localhost(mailfrom:xlpang@linux.alibaba.com fp:SMTPD_---0Uf5aDWK_1625730701)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 08 Jul 2021 15:51:46 +0800
From:   Xunlei Pang <xlpang@linux.alibaba.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Qingming Su <qingming.su@linux.alibaba.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: ses: Fix out-of-bound memory write
Date:   Thu,  8 Jul 2021 15:51:41 +0800
Message-Id: <20210708075141.103282-1-xlpang@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Our memory debug tool captured the following exception:

  BUG: memory corruption in ses_enclosure_data_process+0x24b/0x310 [ses]
  ses_enclosure_data_process+0x24b/0x310 [ses]
  ses_intf_add+0x444/0x542 [ses]
  class_interface_register+0x110/0x120
  ses_init+0x13/0x1000 [ses]
  do_one_initcall+0x41/0x1c0
  do_init_module+0x5c/0x260
  __do_sys_finit_module+0xb1/0x110
  do_syscall_64+0x2d/0x40
  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The root cause is "desc_ptr[len] = '\0'" makes out-of-bound
memory write beyond "buf", so make it within the buffer size.

Reported-by: Qingming Su <qingming.su@linux.alibaba.com>
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
---
 drivers/scsi/ses.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index c2afba2a5414..c1ac2e96d25d 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -544,11 +544,14 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			char *name = NULL;
 			struct enclosure_component *ecomp;
 
+			if (desc_ptr + 4 >= buf + page7_len)
+				desc_ptr = NULL;
+
 			if (desc_ptr) {
-				if (desc_ptr >= buf + page7_len) {
+				len = (desc_ptr[2] << 8) + desc_ptr[3];
+				if (desc_ptr + 4 + len >= buf + page7_len) {
 					desc_ptr = NULL;
 				} else {
-					len = (desc_ptr[2] << 8) + desc_ptr[3];
 					desc_ptr += 4;
 					/* Add trailing zero - pushes into
 					 * reserved space */
-- 
2.20.1.7.g153144c

