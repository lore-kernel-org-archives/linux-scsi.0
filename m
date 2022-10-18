Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEF06C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 13:58:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbiJRN5z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 09:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiJRN5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 09:57:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3531D0189;
        Tue, 18 Oct 2022 06:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=eekyZCIfHhfYX5y+4YGgD1bvKKiVf3yXGGqVRjhh6U4=; b=yzRcazqlHWrnSPJOpot0uxylVf
        nkSu+R8elOMwNTBHDZ7gFFzi20X4/IkS1nXODd3LL6iG314I1le6H/x+O39SAb4Cpzy0LqvWUREmb
        rvAvanUUu9b6KClW+v0uqBEeAJ8z723wTvyzGXv2UO3VmuzYil8wOLUV/xC9hyeXwbza8ZL7VYN80
        /amBZP2uqAKX8Hd69Ddt2AbuUcy7m1BBfZHNvudGT+UkqQU01piQ3jlTvthZwNt08LJin+iWiblOM
        icqJGx3yYpht49jzfb0nOdFkW0hUJbtuLuZvvF3jaTyT7Hpn26CnMElc88N2PJ+/cg7pVJdiKtnl5
        HDe1+kVQ==;
Received: from [2001:4bb8:199:ad84:3a05:173d:d0f5:e725] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okn66-007C8I-IX; Tue, 18 Oct 2022 13:57:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 3/4] nvme-pci: remove an extra queue reference
Date:   Tue, 18 Oct 2022 15:57:19 +0200
Message-Id: <20221018135720.670094-4-hch@lst.de>
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
is no need for a second admin queue reference to be held by the nvme_dev.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/pci.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 16509b8d92e59..efea468a2a5bb 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1749,7 +1749,6 @@ static void nvme_dev_remove_admin(struct nvme_dev *dev)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
-		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
@@ -1778,11 +1777,6 @@ static int nvme_pci_alloc_admin_tag_set(struct nvme_dev *dev)
 		dev->ctrl.admin_q = NULL;
 		return -ENOMEM;
 	}
-	if (!blk_get_queue(dev->ctrl.admin_q)) {
-		nvme_dev_remove_admin(dev);
-		dev->ctrl.admin_q = NULL;
-		return -ENODEV;
-	}
 	return 0;
 }
 
-- 
2.30.2

