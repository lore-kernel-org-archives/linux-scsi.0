Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB197C433E4
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 07:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7C3E2067C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 07:01:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fOVmaNl0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgHZHBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 03:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726854AbgHZHAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Aug 2020 03:00:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B279AC0613ED;
        Wed, 26 Aug 2020 00:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0wLQREwCLa44wEl2hfeoilZWN+qNU12maLsfDeeDnXw=; b=fOVmaNl0hhBbHTyIodHZaxhtT3
        Dy2Fqd3O6tvNgLIg7ZGiDrpqjAGMkLn9SU2Eyq/KJCzY60tnLhRYktY9ji0pG4seu7X4ixHdZ6F0s
        QccUlVpuuHKvPs4yx7CzAvuaMTuRBL+top1QQ0UzaTSZyYNrf45PlPcXtOMh7K2wcvwGUzRq2CTtP
        cGPc8XU25+AQm/OVpXKFqNKOssn7EhMg4db1Qv1BDwpb2LuYSQAx1XT5f+PflmTnzfyHEPCmHqf1f
        nOVNLt/tJK0/ObjLMSFaMiMpKXcVgkqvS+6z1wS4XMjJkU5NJ6SSEqkvSOQ4mfETLq1Um+Wjg5m7u
        EzEMfVGw==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kApPc-0003lJ-UY; Wed, 26 Aug 2020 07:00:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: [PATCH 18/19] z2ram: use separate gendisk for the different modes
Date:   Wed, 26 Aug 2020 08:24:45 +0200
Message-Id: <20200826062446.31860-19-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200826062446.31860-1-hch@lst.de>
References: <20200826062446.31860-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use separate gendisks (which share a tag_set) for the different operating
modes instead of redirecting the gendisk lookup using a probe callback.
This avoids potential problems with aliased block_device instances and
will eventually allow for removing the blk_register_region framework.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/z2ram.c | 100 ++++++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 42 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 566c653399d8d3..2bf059ba95603c 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -63,7 +63,7 @@ static int current_device = -1;
 
 static DEFINE_SPINLOCK(z2ram_lock);
 
-static struct gendisk *z2ram_gendisk;
+static struct gendisk *z2ram_gendisk[Z2MINOR_COUNT];
 
 static blk_status_t z2_queue_rq(struct blk_mq_hw_ctx *hctx,
 				const struct blk_mq_queue_data *bd)
@@ -281,7 +281,7 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 
 		current_device = device;
 		z2ram_size <<= Z2RAM_CHUNKSHIFT;
-		set_capacity(z2ram_gendisk, z2ram_size >> 9);
+		set_capacity(z2ram_gendisk[device], z2ram_size >> 9);
 	}
 
 	mutex_unlock(&z2ram_mutex);
@@ -313,71 +313,87 @@ static const struct block_device_operations z2_fops = {
 	.release = z2_release,
 };
 
-static struct kobject *z2_find(dev_t dev, int *part, void *data)
-{
-	*part = 0;
-	return get_disk_and_module(z2ram_gendisk);
-}
-
-static struct request_queue *z2_queue;
 static struct blk_mq_tag_set tag_set;
 
 static const struct blk_mq_ops z2_mq_ops = {
 	.queue_rq = z2_queue_rq,
 };
 
+static int z2ram_register_disk(int minor)
+{
+	struct request_queue *q;
+	struct gendisk *disk;
+
+	disk = alloc_disk(1);
+	if (!disk)
+		return -ENOMEM;
+
+	q = blk_mq_init_queue(&tag_set);
+	if (IS_ERR(q)) {
+		put_disk(disk);
+		return PTR_ERR(q);
+	}
+
+	disk->major = Z2RAM_MAJOR;
+	disk->first_minor = minor;
+	disk->fops = &z2_fops;
+	if (minor)
+		sprintf(disk->disk_name, "z2ram%d", minor);
+	else
+		sprintf(disk->disk_name, "z2ram");
+	disk->queue = q;
+
+	z2ram_gendisk[minor] = disk;
+	add_disk(disk);
+	return 0;
+}
+
 static int __init z2_init(void)
 {
-	int ret;
+	int ret, i;
 
 	if (!MACH_IS_AMIGA)
 		return -ENODEV;
 
-	ret = -EBUSY;
 	if (register_blkdev(Z2RAM_MAJOR, DEVICE_NAME))
-		goto err;
-
-	ret = -ENOMEM;
-	z2ram_gendisk = alloc_disk(1);
-	if (!z2ram_gendisk)
-		goto out_disk;
-
-	z2_queue = blk_mq_init_sq_queue(&tag_set, &z2_mq_ops, 16,
-					BLK_MQ_F_SHOULD_MERGE);
-	if (IS_ERR(z2_queue)) {
-		ret = PTR_ERR(z2_queue);
-		z2_queue = NULL;
-		goto out_queue;
+		return -EBUSY;
+
+	tag_set.ops = &z2_mq_ops;
+	tag_set.nr_hw_queues = 1;
+	tag_set.nr_maps = 1;
+	tag_set.queue_depth = 16;
+	tag_set.numa_node = NUMA_NO_NODE;
+	tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
+	ret = blk_mq_alloc_tag_set(&tag_set);
+	if (ret)
+		goto out_unregister_blkdev;
+
+	for (i = 0; i < Z2MINOR_COUNT; i++) {
+		ret = z2ram_register_disk(i);
+		if (ret && i == 0)
+			goto out_free_tagset;
 	}
 
-	z2ram_gendisk->major = Z2RAM_MAJOR;
-	z2ram_gendisk->first_minor = 0;
-	z2ram_gendisk->fops = &z2_fops;
-	sprintf(z2ram_gendisk->disk_name, "z2ram");
-
-	z2ram_gendisk->queue = z2_queue;
-	add_disk(z2ram_gendisk);
-	blk_register_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT, THIS_MODULE,
-			    z2_find, NULL, NULL);
-
 	return 0;
 
-out_queue:
-	put_disk(z2ram_gendisk);
-out_disk:
+out_free_tagset:
+	blk_mq_free_tag_set(&tag_set);
+out_unregister_blkdev:
 	unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
-err:
 	return ret;
 }
 
 static void __exit z2_exit(void)
 {
 	int i, j;
-	blk_unregister_region(MKDEV(Z2RAM_MAJOR, 0), Z2MINOR_COUNT);
+
 	unregister_blkdev(Z2RAM_MAJOR, DEVICE_NAME);
-	del_gendisk(z2ram_gendisk);
-	put_disk(z2ram_gendisk);
-	blk_cleanup_queue(z2_queue);
+
+	for (i = 0; i < Z2MINOR_COUNT; i++) {
+		del_gendisk(z2ram_gendisk[i]);
+		blk_cleanup_queue(z2ram_gendisk[i]->queue);
+		put_disk(z2ram_gendisk[i]);
+	}
 	blk_mq_free_tag_set(&tag_set);
 
 	if (current_device != -1) {
-- 
2.28.0

