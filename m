Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AB76C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 13:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiJRN57 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 09:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiJRN5x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 09:57:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B9ED0182;
        Tue, 18 Oct 2022 06:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=f7pjaExyWx0kiXJ6eN4VqPr9sGFWvL2YnRifHeTdaxw=; b=GyTDbR3hjhakV87BqN6621QQiV
        Ko2Aiu5sCFnQ53MuFGJ3R8F7uQSnLrBf/rUBQtsTCBTW3ICfuvc97bzOFV1bpMLpa9QgMbkN9YcRN
        +OOmWhhttfVATcH6UAaCGXPf7jy0GepCQt7LYhMqRSr4d82FsqhNB7t2xlM0ksqain5AhpZEcRTcE
        +GhrFKJGYyGgN7hSgmEqstyAam+Ac09OBghlv0dVmlrY8qhgwMACVwUBisPjGN+UjRuthoAnJrmR9
        v6D9/baiUiYrIorrQI3JkL4k20d2CwO1bP96M0/kq9bqwz80vTxJHHHSvUwceAa0YeLLlT4kTlfuD
        Tis3HBsA==;
Received: from [2001:4bb8:199:ad84:3a05:173d:d0f5:e725] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okn69-007C9f-9a; Tue, 18 Oct 2022 13:57:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 4/4] nvme-apple: remove an extra queue reference
Date:   Tue, 18 Oct 2022 15:57:20 +0200
Message-Id: <20221018135720.670094-5-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018135720.670094-1-hch@lst.de>
References: <20221018135720.670094-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that blk_mq_destroy_queue does not release the queue reference, there
is no need for a second admin queue reference to be held by the
apple_nvme structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/apple.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 42b17439dfd57..fe7f0444a8e46 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1505,15 +1505,6 @@ static int apple_nvme_probe(struct platform_device *pdev)
 		goto put_dev;
 	}
 
-	if (!blk_get_queue(anv->ctrl.admin_q)) {
-		nvme_start_admin_queue(&anv->ctrl);
-		blk_mq_destroy_queue(anv->ctrl.admin_q);
-		blk_put_queue(anv->ctrl.admin_q);
-		anv->ctrl.admin_q = NULL;
-		ret = -ENODEV;
-		goto put_dev;
-	}
-
 	nvme_reset_ctrl(&anv->ctrl);
 	async_schedule(apple_nvme_async_probe, anv);
 
-- 
2.30.2

