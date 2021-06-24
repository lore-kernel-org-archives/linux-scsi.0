Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1CEC48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 12:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B278613FA
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 12:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbhFXMms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 08:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhFXMms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2021 08:42:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34162C061574;
        Thu, 24 Jun 2021 05:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=P6h0LuQ49oeCoLbkr5MrGGKJj6Y7bHefD5pEYVctvT0=; b=UT04g2puQmBCsHybFCk7xl7XyM
        NELqiqczij2qRdy4gjnGV/x+oE2vz2ZYUsk1Ls61tnYkj8/COaRFLcXm7lKX9mU8AvUDLsmVpcfDl
        X78Pjs/M7yHF7VxMaf6+PgNVjb8guscXpC9qGj720jot6BczoAIqBmTJxY3pXja/kNmOf8UKBr3TN
        yb1n9xg2N8+47mXUC0BPEbh8eYAC0uTtsYK7sfyTjNLT28aiUQ4BAuBYcfvDO02BB3wRmfDhKC+tX
        sEXZacbMzL1Vbwvc0RmLctCgjg30FF+paw8z3EtgguUuKa/VeMQVPJc88RkHD4/RlNCkYvjui/HLD
        BptCVz0A==;
Received: from 213-225-9-92.nat.highway.a1.net ([213.225.9.92] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lwOeH-00GZl7-EX; Thu, 24 Jun 2021 12:40:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] nvme
Date:   Thu, 24 Jun 2021 14:39:35 +0200
Message-Id: <20210624123935.479229-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210624123935.479229-1-hch@lst.de>
References: <20210624123935.479229-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

---
 drivers/nvme/host/core.c | 31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 468d26456857..2d7f15e9f8ca 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3740,31 +3740,24 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (!ns)
 		goto out_free_id;
 
-	ns->queue = blk_mq_init_queue(ctrl->tagset);
-	if (IS_ERR(ns->queue))
+	disk = blk_mq_alloc_disk(ctrl->tagset, ns);
+	if (IS_ERR(disk))
 		goto out_free_ns;
 
-	if (ctrl->opts && ctrl->opts->data_digest)
-		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, ns->queue);
-
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, ns->queue);
 	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
 		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
+	if (ctrl->opts && ctrl->opts->data_digest)
+		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, ns->queue);
 
-	ns->queue->queuedata = ns;
 	ns->ctrl = ctrl;
 	kref_init(&ns->kref);
 
 	if (nvme_init_ns_head(ns, nsid, ids, id->nmic & NVME_NS_NMIC_SHARED))
-		goto out_free_queue;
-
-	disk = alloc_disk_node(0, node);
-	if (!disk)
-		goto out_unlink_ns;
+		goto out_cleanup_disk;
 
 	disk->fops = &nvme_bdev_ops;
 	disk->private_data = ns;
-	disk->queue = ns->queue;
 	/*
 	 * Without the multipath code enabled, multiple controller per
 	 * subsystems are visible as devices and thus we cannot use the
@@ -3776,12 +3769,12 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	ns->disk = disk;
 
 	if (nvme_update_ns_info(ns, id))
-		goto out_put_disk;
+		goto out_unlink_ns;
 
 	if ((ctrl->quirks & NVME_QUIRK_LIGHTNVM) && id->vs[0] == 0x1) {
 		if (nvme_nvm_register(ns, disk->disk_name, node)) {
 			dev_warn(ctrl->device, "LightNVM init failure\n");
-			goto out_put_disk;
+			goto out_unlink_ns;
 		}
 	}
 
@@ -3798,12 +3791,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	nvme_mpath_add_disk(ns, id);
 	nvme_fault_inject_init(&ns->fault_inject, ns->disk->disk_name);
 	kfree(id);
-
 	return;
- out_put_disk:
-	/* prevent double queue cleanup */
-	ns->disk->queue = NULL;
-	put_disk(ns->disk);
+
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
@@ -3811,8 +3800,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
 	nvme_put_ns_head(ns->head);
- out_free_queue:
-	blk_cleanup_queue(ns->queue);
+ out_cleanup_disk:
+	blk_cleanup_disk(ns->disk);
  out_free_ns:
 	kfree(ns);
  out_free_id:
-- 
2.30.2

