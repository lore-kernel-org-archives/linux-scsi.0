Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CC6BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 01:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 592BC60FC1
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Oct 2021 01:02:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhJVBEn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 21:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJVBEm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Oct 2021 21:04:42 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B53AC061764
        for <linux-scsi@vger.kernel.org>; Thu, 21 Oct 2021 18:02:26 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1634864543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=fQUQkqKVef7w+D6IMc48FykM/6/kJnpU27VG3u1FljM=;
        b=FsyZuvjcdw1h2nP9bzDd6WvTSBEFTsgC6z3SeqRP+DcIZSmOe/d0BKkfb+ofx1Wn2N5hN8
        fkgBBUIJIJlnGGPgNGN2gRxpGdJL6VycbGP9+njun/w5TAnYUzhZGYiIQQRmVMvjsiBhBN
        ARNopIrTBxwhCnh6rmwHSZs0x5AknjE=
From:   Jackie Liu <liu.yun@linux.dev>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, hch@lst.de, axboe@kernel.dk,
        liu.yun@linux.dev
Subject: [PATCH v2] scsi: bsg: fix errno when scsi_bsg_register_queue fails
Date:   Fri, 22 Oct 2021 09:02:01 +0800
Message-Id: <20211022010201.426746-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: liu.yun@linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

When the value of error is printed, it will always be 0. Here, we should be
print the correct error code when scsi_bsg_register_queue fails.

Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 v1->v2:
 resend to linux-scsi mail list.

 drivers/scsi/scsi_sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 86793259e541..d8789f6cda62 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1379,6 +1379,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 			 * We're treating error on bsg register as non-fatal, so
 			 * pretend nothing went wrong.
 			 */
+			error = PTR_ERR(sdev->bsg_dev);
 			sdev_printk(KERN_INFO, sdev,
 				    "Failed to register bsg queue, errno=%d\n",
 				    error);
-- 
2.25.1

