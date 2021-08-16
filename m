Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A73C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:40:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1650463282
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:40:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239044AbhHPNkv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 09:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239043AbhHPNkn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 09:40:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A17C014CE3;
        Mon, 16 Aug 2021 06:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=1rFQ8D0mXAcBMAExuJh69Ps3M83Tx2U+4hJT0lcEW/Y=; b=wT34D1aOH5EtsS3X753iFgcCTR
        s3l0u59e5So2b125/NNC5jmfvK/yc1R5g8HBFyvuzZC+mYaPOwOYiEK5AuiR0loQmvPjYYZIDLT4O
        RqFocV2apLYKuMJIQ1bi9grEKBn+HeeA6nXZZ4C5/gT4FTbad3XOgivH8gfweE8zOMRLgnQgkhGsH
        m585oJGqitYuVBsvyFg3FMaSYfhF1GBxtV811WbLhpvPIKQsxO712UHRZhalCcBid5v7ipyYXtioF
        9PmyMaaiX9SNttOPnAC/y0obShNZLuV8vREpnVRlkl0EjvcEx6xDlvG/DtqF6WSVrccjz9T+wiPtu
        QRITjIew==;
Received: from [2001:4bb8:188:1b1:3731:604a:a6cd:dc60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFcWp-001OXs-EM; Mon, 16 Aug 2021 13:19:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/9] nvme: use blk_mq_alloc_disk
Date:   Mon, 16 Aug 2021 15:19:02 +0200
Message-Id: <20210816131910.615153-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816131910.615153-1-hch@lst.de>
References: <20210816131910.615153-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Switch to use the blk_mq_alloc_disk helper for allocating the
request_queue and gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 1478d825011d..a5878ba14c55 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3729,9 +3729,14 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (!ns)
 		goto out_free_id;
 
-	ns->queue = blk_mq_init_queue(ctrl->tagset);
-	if (IS_ERR(ns->queue))
+	disk = blk_mq_alloc_disk(ctrl->tagset, ns);
+	if (IS_ERR(disk))
 		goto out_free_ns;
+	disk->fops = &nvme_bdev_ops;
+	disk->private_data = ns;
+
+	ns->disk = disk;
+	ns->queue = disk->queue;
 
 	if (ctrl->opts && ctrl->opts->data_digest)
 		blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, ns->queue);
@@ -3740,20 +3745,12 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (ctrl->ops->flags & NVME_F_PCI_P2PDMA)
 		blk_queue_flag_set(QUEUE_FLAG_PCI_P2PDMA, ns->queue);
 
-	ns->queue->queuedata = ns;
 	ns->ctrl = ctrl;
 	kref_init(&ns->kref);
 
 	if (nvme_init_ns_head(ns, nsid, ids, id->nmic & NVME_NS_NMIC_SHARED))
-		goto out_free_queue;
+		goto out_cleanup_disk;
 
-	disk = alloc_disk_node(0, node);
-	if (!disk)
-		goto out_unlink_ns;
-
-	disk->fops = &nvme_bdev_ops;
-	disk->private_data = ns;
-	disk->queue = ns->queue;
 	/*
 	 * Without the multipath code enabled, multiple controller per
 	 * subsystems are visible as devices and thus we cannot use the
@@ -3762,15 +3759,14 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	if (!nvme_mpath_set_disk_name(ns, disk->disk_name, &disk->flags))
 		sprintf(disk->disk_name, "nvme%dn%d", ctrl->instance,
 			ns->head->instance);
-	ns->disk = disk;
 
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
 
@@ -3789,10 +3785,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 	kfree(id);
 
 	return;
- out_put_disk:
-	/* prevent double queue cleanup */
-	ns->disk->queue = NULL;
-	put_disk(ns->disk);
+
  out_unlink_ns:
 	mutex_lock(&ctrl->subsys->lock);
 	list_del_rcu(&ns->siblings);
@@ -3800,8 +3793,8 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
 		list_del_init(&ns->head->entry);
 	mutex_unlock(&ctrl->subsys->lock);
 	nvme_put_ns_head(ns->head);
- out_free_queue:
-	blk_cleanup_queue(ns->queue);
+ out_cleanup_disk:
+	blk_cleanup_disk(disk);
  out_free_ns:
 	kfree(ns);
  out_free_id:
-- 
2.30.2

