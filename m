Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA74CC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 13:57:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiJRN5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 09:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJRN5j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 09:57:39 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02989CF874;
        Tue, 18 Oct 2022 06:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=UL/oJgiXhDP3Rot9t1Yjrg10QIRTRuPfSbvNftFdb6U=; b=PtcorG/fx3FnYy/YcOiBITTQku
        foo+sdC9TYuKcjZdv4RJeCr4BxLhXJoI15PITMjjW1vCj5nOY+VUxJmG+QlVzelzJ+/tMelS3xTK/
        6OAiZzgmOzuqguLvPi7M1llm4ct/kflWEVfOMnE/n3S1DA+LPSUaanJh3+N4QUbWKy+UgsicjGhJ5
        AbJGHpPRyYB7kYPL0qOP8L8BoEwqFQc4ZulF44eEjyaq2ARuoLPAGXjAZxdV+TkqgzRoR27VzEc21
        5Kevh7NsLYYQUuNwtFf9soLgWa40rDKSbmqFwYPUtHw6LfeRlg6C4uEcRjfPkNqltzohfUG3SIcPv
        j0mfFVyg==;
Received: from [2001:4bb8:199:ad84:3a05:173d:d0f5:e725] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1okn61-007C5t-52; Tue, 18 Oct 2022 13:57:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 1/4] blk-mq: move the call to blk_put_queue out of blk_mq_destroy_queue
Date:   Tue, 18 Oct 2022 15:57:17 +0200
Message-Id: <20221018135720.670094-2-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221018135720.670094-1-hch@lst.de>
References: <20221018135720.670094-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The fact that blk_mq_destroy_queue also drops a queue reference leads
to various places having to grab an extra reference.  Move the call to
blk_put_queue into the callers to allow removing the extra references.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c            |  4 +---
 block/bsg-lib.c           |  2 ++
 drivers/nvme/host/apple.c |  1 +
 drivers/nvme/host/core.c  | 10 ++++++++--
 drivers/nvme/host/pci.c   |  1 +
 drivers/scsi/scsi_sysfs.c |  1 +
 drivers/ufs/core/ufshcd.c |  2 ++
 7 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 8070b6c10e8d5..ee644444e0f33 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4007,9 +4007,6 @@ void blk_mq_destroy_queue(struct request_queue *q)
 	blk_sync_queue(q);
 	blk_mq_cancel_work_sync(q);
 	blk_mq_exit_queue(q);
-
-	/* @q is and will stay empty, shutdown and put */
-	blk_put_queue(q);
 }
 EXPORT_SYMBOL(blk_mq_destroy_queue);
 
@@ -4026,6 +4023,7 @@ struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
 	disk = __alloc_disk_node(q, set->numa_node, lkclass);
 	if (!disk) {
 		blk_mq_destroy_queue(q);
+		blk_put_queue(q);
 		return ERR_PTR(-ENOMEM);
 	}
 	set_bit(GD_OWNS_QUEUE, &disk->state);
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index d6f5dcdce748c..435c32373cd68 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -325,6 +325,7 @@ void bsg_remove_queue(struct request_queue *q)
 
 		bsg_unregister_queue(bset->bd);
 		blk_mq_destroy_queue(q);
+		blk_put_queue(q);
 		blk_mq_free_tag_set(&bset->tag_set);
 		kfree(bset);
 	}
@@ -400,6 +401,7 @@ struct request_queue *bsg_setup_queue(struct device *dev, const char *name,
 	return q;
 out_cleanup_queue:
 	blk_mq_destroy_queue(q);
+	blk_put_queue(q);
 out_queue:
 	blk_mq_free_tag_set(set);
 out_tag_set:
diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index 5fc5ea196b400..42b17439dfd57 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1508,6 +1508,7 @@ static int apple_nvme_probe(struct platform_device *pdev)
 	if (!blk_get_queue(anv->ctrl.admin_q)) {
 		nvme_start_admin_queue(&anv->ctrl);
 		blk_mq_destroy_queue(anv->ctrl.admin_q);
+		blk_put_queue(anv->ctrl.admin_q);
 		anv->ctrl.admin_q = NULL;
 		ret = -ENODEV;
 		goto put_dev;
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 059737c1a2c19..07381673170b9 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4847,6 +4847,7 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 
 out_cleanup_admin_q:
 	blk_mq_destroy_queue(ctrl->fabrics_q);
+	blk_put_queue(ctrl->fabrics_q);
 out_free_tagset:
 	blk_mq_free_tag_set(ctrl->admin_tagset);
 	return ret;
@@ -4856,8 +4857,11 @@ EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 {
 	blk_mq_destroy_queue(ctrl->admin_q);
-	if (ctrl->ops->flags & NVME_F_FABRICS)
+	blk_put_queue(ctrl->admin_q);
+	if (ctrl->ops->flags & NVME_F_FABRICS) {
 		blk_mq_destroy_queue(ctrl->fabrics_q);
+		blk_put_queue(ctrl->fabrics_q);
+	}
 	blk_mq_free_tag_set(ctrl->admin_tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
@@ -4903,8 +4907,10 @@ EXPORT_SYMBOL_GPL(nvme_alloc_io_tag_set);
 
 void nvme_remove_io_tag_set(struct nvme_ctrl *ctrl)
 {
-	if (ctrl->ops->flags & NVME_F_FABRICS)
+	if (ctrl->ops->flags & NVME_F_FABRICS) {
 		blk_mq_destroy_queue(ctrl->connect_q);
+		blk_put_queue(ctrl->connect_q);
+	}
 	blk_mq_free_tag_set(ctrl->tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_io_tag_set);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index bcbef6bc5672f..16509b8d92e59 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1749,6 +1749,7 @@ static void nvme_dev_remove_admin(struct nvme_dev *dev)
 		 */
 		nvme_start_admin_queue(&dev->ctrl);
 		blk_mq_destroy_queue(dev->ctrl.admin_q);
+		blk_put_queue(dev->ctrl.admin_q);
 		blk_mq_free_tag_set(&dev->admin_tagset);
 	}
 }
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c95177ca6ed26..1214c6f07bc64 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1478,6 +1478,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	mutex_unlock(&sdev->state_mutex);
 
 	blk_mq_destroy_queue(sdev->request_queue);
+	blk_put_queue(sdev->request_queue);
 	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca68..8ee0ac168ff2b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -9544,6 +9544,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshpb_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	blk_mq_destroy_queue(hba->tmf_queue);
+	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
@@ -9840,6 +9841,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 free_tmf_queue:
 	blk_mq_destroy_queue(hba->tmf_queue);
+	blk_put_queue(hba->tmf_queue);
 free_tmf_tag_set:
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 out_remove_scsi_host:
-- 
2.30.2

