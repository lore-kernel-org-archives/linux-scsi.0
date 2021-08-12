Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E43C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:56:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18AD360FED
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbhHLH5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhHLH5O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:57:14 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CB2C061765;
        Thu, 12 Aug 2021 00:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vbzQM6aTARPCC3+R9ES/KK4HZC4Ol4Ja+NtAVkKj4Fs=; b=qZEMPMHe3mr2wd5iUcJ26aoj9t
        Si1X+9X8oy70ughMGUzCa5MkYzM+zz0K9+CvjXyviH1HM26z+nYn2AGplJ9UnxZOTLqDq0nPtlKKJ
        L1lW08svi+5AexRSnGoLSVrV8Nvj02ioGswnnhBkPtHJHDE86WlUCMqwzMUy8ZNSUPCo5X3AmLEp5
        iIna5P53SiFpypNLcDUcMrG3cCSJ1DY0/P8NyXOUeefhyeU1hPyNs/5x5ZvxVX78Cd1f2+t7rNIke
        Nuw+N1L55lLwxwVludT0GnU+5pl+ncnTl9inGlyH9G62b9bTfoT3lWCtwnAC2fKS5cqlX4iwJd/nS
        Pc5eMnvQ==;
Received: from [2001:4bb8:184:6215:d7d:1904:40de:694d] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE5XV-00EJBt-5d; Thu, 12 Aug 2021 07:54:41 +0000
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
Subject: [PATCH 8/8] block: hold a request_queue reference for the lifetime of struct gendisk
Date:   Thu, 12 Aug 2021 09:46:42 +0200
Message-Id: <20210812074642.18592-9-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210812074642.18592-1-hch@lst.de>
References: <20210812074642.18592-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Acquire the queue ref dropped in disk_release in __blk_alloc_disk so any
allocate gendisk always has a queue reference.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c         | 20 +++++++-------------
 include/linux/genhd.h |  1 -
 2 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 283cf0c649e1..18600f682edb 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -544,16 +544,6 @@ static void __device_add_disk(struct device *parent, struct gendisk *disk,
 	register_disk(parent, disk, groups);
 	if (register_queue)
 		blk_register_queue(disk);
-
-	/*
-	 * Take an extra ref on queue which will be put on disk_release()
-	 * so that it sticks around as long as @disk is there.
-	 */
-	if (blk_get_queue(disk->queue))
-		set_bit(GD_QUEUE_REF, &disk->state);
-	else
-		WARN_ON_ONCE(1);
-
 	disk_add_events(disk);
 	blk_integrity_add(disk);
 }
@@ -1096,8 +1086,7 @@ static void disk_release(struct device *dev)
 	disk_release_events(disk);
 	kfree(disk->random);
 	xa_destroy(&disk->part_tbl);
-	if (test_bit(GD_QUEUE_REF, &disk->state) && disk->queue)
-		blk_put_queue(disk->queue);
+	blk_put_queue(disk->queue);
 	iput(disk->part0->bd_inode);	/* frees the disk */
 }
 
@@ -1268,9 +1257,12 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 {
 	struct gendisk *disk;
 
+	if (!blk_get_queue(q))
+		return NULL;
+
 	disk = kzalloc_node(sizeof(struct gendisk), GFP_KERNEL, node_id);
 	if (!disk)
-		return NULL;
+		goto out_put_queue;
 
 	disk->part0 = bdev_alloc(disk, 0);
 	if (!disk->part0)
@@ -1297,6 +1289,8 @@ struct gendisk *__alloc_disk_node(struct request_queue *q, int node_id,
 	iput(disk->part0->bd_inode);
 out_free_disk:
 	kfree(disk);
+out_put_queue:
+	blk_put_queue(q);
 	return NULL;
 }
 EXPORT_SYMBOL(__alloc_disk_node);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 875be3bc8afb..e94147613d01 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -149,7 +149,6 @@ struct gendisk {
 	unsigned long state;
 #define GD_NEED_PART_SCAN		0
 #define GD_READ_ONLY			1
-#define GD_QUEUE_REF			2
 
 	struct mutex open_mutex;	/* open/close mutex */
 	unsigned open_partitions;	/* number of open partitions */
-- 
2.30.2

