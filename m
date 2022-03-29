Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58ED6C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 02:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiC2CPQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Mar 2022 22:15:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiC2CPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2022 22:15:07 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0C7E23
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 19:13:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648520000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6Xtm5yb4YmoUhtBExxyi2QEXaXQrkqIAlNVciaFJjr4=;
        b=qEmLruDGJHn/NSGUyoy2rvoCh1aDQ+QDipzBfrVvtSro8ZE1eyStkH2uJ3TVw2W6lATv94
        NUKEPRxaIJhWkmrltA7EStK3kDik1ejYif76yTbJH6Uc1cS866KtZJb72o+OXMjSX4uufO
        GkSCJYvLBbbsb+8qemXbqrZ2yhH6q7k=
From:   Jackie Liu <liu.yun@linux.dev>
To:     martin.petersen@oracle.com
Cc:     hch@lst.de, linux@roeck-us.net, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: core: sysfs: remove comments that conflict with the actual logic
Date:   Tue, 29 Mar 2022 10:12:51 +0800
Message-Id: <20220329021251.123805-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

Christoph Hellwig Says:
=======================
I think we should just handle the error properly and remove the comment.
There's no good reason to ignore bsg registration errors.

In fact, after commit 92c4b58b15c5 ("scsi: core: Register sysfs attributes
earlier"), we are already forced to return errno.

We discuss this issue in [1].

[1] https://lore.kernel.org/all/20211022010201.426746-1-liu.yun@linux.dev/

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 drivers/scsi/scsi_sysfs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f1e0c131b77c..322228faf8da 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1392,10 +1392,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	if (IS_ENABLED(CONFIG_BLK_DEV_BSG)) {
 		sdev->bsg_dev = scsi_bsg_register_queue(sdev);
 		if (IS_ERR(sdev->bsg_dev)) {
-			/*
-			 * We're treating error on bsg register as non-fatal, so
-			 * pretend nothing went wrong.
-			 */
 			error = PTR_ERR(sdev->bsg_dev);
 			sdev_printk(KERN_INFO, sdev,
 				    "Failed to register bsg queue, errno=%d\n",
-- 
2.25.1

