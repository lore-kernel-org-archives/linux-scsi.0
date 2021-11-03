Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5814AC4321E
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 021FC61175
	for <linux-scsi@archiver.kernel.org>; Wed,  3 Nov 2021 17:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhKCRsQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Nov 2021 13:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhKCRsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Nov 2021 13:48:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A9CC06120B;
        Wed,  3 Nov 2021 10:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=GuBWAeSpZzx+0ssaIhzYwBVOv+AVE01ZwW3soNLOj/Y=; b=0fHxGiGmLUK2wNpCtaU7oWkyvw
        aCs4pj97vh3B6WUrbVdJOP+WwGQbzwFvEOBCXJMjLD7qlWpwpjd352AjC/gJZiDkDFieoXvXeOqJ0
        hzywXXSfG8AYSmtTeyKSyp3tL4K56h4uAPW78LwDmf9vWdd7RqhKy0Gpk8lbnfXJtTLeSlo5dUGqd
        /t+2PzSjJcAiAUydupZr2tTltKvLsoFNpaUwKkO83xQuVPb1aQqQpPYJurXeWkgBy0Iq+1TBG3xyy
        MizJg+ZW+FbsTYqrRhDZCKKN2WNdJLNd0aA2uc4Me1HABbwidTnW5hjS995damzzaIYipX5A6pnYK
        d0MvTHGQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1miKKA-005z5Z-Ga; Wed, 03 Nov 2021 17:45:22 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     axboe@kernel.dk, hch@lst.de, penguin-kernel@i-love.sakura.ne.jp,
        dan.j.williams@intel.com, vishal.l.verma@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, richard@nod.at,
        miquel.raynal@bootlin.com, vigneshr@ti.com, efremov@linux.com,
        song@kernel.org, martin.petersen@oracle.com, hare@suse.de,
        jack@suse.cz, ming.lei@redhat.com, tj@kernel.org, mcgrof@kernel.org
Cc:     linux-mtd@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/13] nvdimm/pmem: use add_disk() error handling
Date:   Wed,  3 Nov 2021 10:45:15 -0700
Message-Id: <20211103174521.1426407-8-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211103174521.1426407-1-mcgrof@kernel.org>
References: <20211103174521.1426407-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that device_add_disk() supports returning an error, use
that. We must unwind alloc_dax() on error.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/nvdimm/pmem.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d98af6c31f42..fe7ece1534e1 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -505,7 +505,9 @@ static int pmem_attach_disk(struct device *dev,
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
 
-	device_add_disk(dev, disk, pmem_attribute_groups);
+	rc = device_add_disk(dev, disk, pmem_attribute_groups);
+	if (rc)
+		goto out_cleanup_dax;
 	if (devm_add_action_or_reset(dev, pmem_release_disk, pmem))
 		return -ENOMEM;
 
@@ -516,6 +518,10 @@ static int pmem_attach_disk(struct device *dev,
 	if (!pmem->bb_state)
 		dev_warn(dev, "'badblocks' notification disabled\n");
 	return 0;
+
+out_cleanup_dax:
+	kill_dax(pmem->dax_dev);
+	put_dax(pmem->dax_dev);
 out:
 	blk_cleanup_disk(pmem->disk);
 	return rc;
-- 
2.33.0

