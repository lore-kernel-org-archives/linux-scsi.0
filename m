Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EABADC6FD18
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Mar 2023 02:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjC3Cis (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Mar 2023 22:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC3Ciq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Mar 2023 22:38:46 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEDD5256;
        Wed, 29 Mar 2023 19:38:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Veyr.ii_1680143916;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0Veyr.ii_1680143916)
          by smtp.aliyun-inc.com;
          Thu, 30 Mar 2023 10:38:41 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: target: return -ENOMEM when kzalloc failed
Date:   Thu, 30 Mar 2023 10:38:34 +0800
Message-Id: <20230330023834.97455-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The driver is using -1 instead of the -ENOMEM defined macro to specify
that a buffer allocation failed.

drivers/target/iscsi/iscsi_target.c:691 iscsi_target_init_module() warn: returning -1 instead of -ENOMEM is sloppy.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4644
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/target/iscsi/iscsi_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 834cce50f9b0..d3a40c3caaf5 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -688,7 +688,7 @@ static int __init iscsi_target_init_module(void)
 	pr_debug("iSCSI-Target "ISCSIT_VERSION"\n");
 	iscsit_global = kzalloc(sizeof(*iscsit_global), GFP_KERNEL);
 	if (!iscsit_global)
-		return -1;
+		return -ENOMEM;
 
 	spin_lock_init(&iscsit_global->ts_bitmap_lock);
 	mutex_init(&auth_id_lock);
-- 
2.20.1.7.g153144c

