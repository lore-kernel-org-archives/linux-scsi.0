Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 584FDC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jun 2022 02:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379582AbiFQCGw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiFQCGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2022 22:06:51 -0400
X-Greylist: delayed 127 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Jun 2022 19:06:49 PDT
Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7831B64BC2;
        Thu, 16 Jun 2022 19:06:48 -0700 (PDT)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id LYV00035;
        Fri, 17 Jun 2022 10:04:35 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201602.home.langchao.com (10.100.2.2) with Microsoft SMTP Server id
 15.1.2308.27; Fri, 17 Jun 2022 10:04:34 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <fujita.tomonori@lab.ntt.co.jp>, <axboe@kernel.dk>
CC:     <linux-scsi@vger.kernel.org>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bo Liu <liubo03@inspur.com>
Subject: [PATCH] scsi: Remove usage of the deprecated ida_simple_xxx API
Date:   Thu, 16 Jun 2022 22:04:30 -0400
Message-ID: <20220617020430.2300-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   2022617100435427b25fa09428565519558434c2ae0a3
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use ida_alloc_xxx()/ida_free() instead of
ida_simple_get()/ida_simple_remove().
The latter is deprecated and more verbose.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 block/bsg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 882f56bff14f..2ab1351eb082 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -169,7 +169,7 @@ static void bsg_device_release(struct device *dev)
 {
 	struct bsg_device *bd = container_of(dev, struct bsg_device, device);
 
-	ida_simple_remove(&bsg_minor_ida, MINOR(bd->device.devt));
+	ida_free(&bsg_minor_ida, MINOR(bd->device.devt));
 	kfree(bd);
 }
 
@@ -196,7 +196,7 @@ struct bsg_device *bsg_register_queue(struct request_queue *q,
 	bd->queue = q;
 	bd->sg_io_fn = sg_io_fn;
 
-	ret = ida_simple_get(&bsg_minor_ida, 0, BSG_MAX_DEVS, GFP_KERNEL);
+	ret = ida_alloc_max(&bsg_minor_ida, BSG_MAX_DEVS - 1, GFP_KERNEL);
 	if (ret < 0) {
 		if (ret == -ENOSPC)
 			dev_err(parent, "bsg: too many bsg devices\n");
-- 
2.27.0

