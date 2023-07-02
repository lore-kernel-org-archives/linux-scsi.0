Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA06EB64DA
	for <linux-scsi@archiver.kernel.org>; Sun,  2 Jul 2023 19:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232365AbjGBToP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 2 Jul 2023 15:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbjGBTnH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Jul 2023 15:43:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBE02122;
        Sun,  2 Jul 2023 12:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECA1A60CF9;
        Sun,  2 Jul 2023 19:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA65C433C7;
        Sun,  2 Jul 2023 19:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688326891;
        bh=N/N7KV2ya6gMiKA/u+eeu8WR2lgqm6LYdipuZUuUgbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GA6pGdrApKSEM2fnxl2NqHUCcqcLs8qx02gDHJIed8TwjKajcWKKxOgYlVkCoJ5jg
         hRs2bI63KPHHmvyG1jbUD5RWkENMQe6BFx8YplP34r3acYewihwe5Zlh6IJFgvCWuf
         xkZm8ERRzIS8Odz7MHFp/VIQPzfea9fV0zh2jVVNx2dGitDsMVah4oVUQ/e9Z7VyFW
         dDfoiRZF8ybWPLKrbtg2PYFVo5N40Lpc96oPpkXNrBeIQa0lvlyqBiXaT7qEgGkJ23
         q9LB4tyPpSLxGovx/1XqgYWxcRHFzGtrIXZZWvtD/gHSvSmowZOfdt9xlf9f2UIb+m
         dyC6AICida6LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        dgilbert@interlog.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 08/12] scsi: sg: fix blktrace debugfs entries leakage
Date:   Sun,  2 Jul 2023 15:41:13 -0400
Message-Id: <20230702194118.1777794-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230702194118.1777794-1-sashal@kernel.org>
References: <20230702194118.1777794-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.37
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit db59133e927916d8a25ee1fd8264f2808040909d ]

sg_ioctl() support to enable blktrace, which will create debugfs entries
"/sys/kernel/debug/block/sgx/", however, there is no guarantee that user
will remove these entries through ioctl, and deleting sg device doesn't
cleanup these blktrace entries.

This problem can be fixed by cleanup blktrace while releasing
request_queue, however, it's not a good idea to do this special handling
in common layer just for sg device.

Fix this problem by shutdown bltkrace in sg_device_destroy(), where the
device is deleted and all the users close the device, also grab a
scsi_device reference from sg_add_device() to prevent scsi_device to be
freed before sg_device_destroy();

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20230610022003.2557284-3-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 12344be14232b..3d7c27f0bd688 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1496,6 +1496,10 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 	int error;
 	unsigned long iflags;
 
+	error = scsi_device_get(scsidp);
+	if (error)
+		return error;
+
 	error = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev) {
@@ -1553,6 +1557,7 @@ sg_add_device(struct device *cl_dev, struct class_interface *cl_intf)
 out:
 	if (cdev)
 		cdev_del(cdev);
+	scsi_device_put(scsidp);
 	return error;
 }
 
@@ -1560,6 +1565,7 @@ static void
 sg_device_destroy(struct kref *kref)
 {
 	struct sg_device *sdp = container_of(kref, struct sg_device, d_ref);
+	struct request_queue *q = sdp->device->request_queue;
 	unsigned long flags;
 
 	/* CAUTION!  Note that the device can still be found via idr_find()
@@ -1567,6 +1573,9 @@ sg_device_destroy(struct kref *kref)
 	 * any other cleanup.
 	 */
 
+	blk_trace_remove(q);
+	scsi_device_put(sdp->device);
+
 	write_lock_irqsave(&sg_index_lock, flags);
 	idr_remove(&sg_index_idr, sdp->index);
 	write_unlock_irqrestore(&sg_index_lock, flags);
-- 
2.39.2

