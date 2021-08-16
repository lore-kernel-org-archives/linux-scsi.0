Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D05C4320E
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22DF263250
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 13:43:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238112AbhHPNmw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 09:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236788AbhHPNmt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 09:42:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141F9C0363CE;
        Mon, 16 Aug 2021 06:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=FFcZLSiuWIHs24l1Onz0blvcgt4rcIjls/wQmp0eRcw=; b=qaJoaYgYZ36tiVcIzsRhnvelsk
        aCCL4+nwsOO8AreE5DJE0yA9aHQf7x32KoD6wH7hX7xtcT2fE2XgUN4D17jPAdj7sfdMGA60ztZKR
        rU5jN43stqECAUq0g9a4QFqyKXg+hUpQfH8PCc2uBFYg/+YOaCxNp39jCAjctMDjQBls6oAQ3+59C
        heF/AC+ZP42bwsFBAror7Bo2cuIEiEXm3vLYn7RjjXvzE3mHIBp6ehHe4A+zOKeEaGiBrQfeZAPiD
        FWYvfnC/gdQ11iI9to+NGTzq4w1pmqw8pXme4ZlhpYIj52JWjCyVabCNs/QGCxSNYmAqC4qJYpd5H
        6NXds8tw==;
Received: from [2001:4bb8:188:1b1:3731:604a:a6cd:dc60] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mFcdw-001PE0-Vo; Mon, 16 Aug 2021 13:27:37 +0000
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
Subject: [PATCH 6/9] block: remove the minors argument to __alloc_disk_node
Date:   Mon, 16 Aug 2021 15:19:07 +0200
Message-Id: <20210816131910.615153-7-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210816131910.615153-1-hch@lst.de>
References: <20210816131910.615153-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This was a leftover from the legacy alloc_disk interface.  Switch
the scsi ULPs and dasd to set ->minors directly like all other
drivers and remove the argument.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>	[dasd]
---
 block/blk-mq.c                  | 2 +-
 block/genhd.c                   | 6 ++----
 drivers/s390/block/dasd_genhd.c | 4 ++--
 drivers/scsi/sd.c               | 3 ++-
 drivers/scsi/sr.c               | 3 ++-
 include/linux/genhd.h           | 3 +--
 6 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4c56e43e6992..8ac30c343c06 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3143,7 +3143,7 @@ struct gendisk *__blk_mq_alloc_disk(struct blk_mq_tag_set *set, void *queuedata,
 	if (IS_ERR(q))
 		return ERR_CAST(q);
 
-	disk = __alloc_disk_node(0, set->numa_node, lkclass);
+	disk = __alloc_disk_node(set->numa_node, lkclass);
 	if (!disk) {
 		blk_cleanup_queue(q);
 		return ERR_PTR(-ENOMEM);
diff --git a/block/genhd.c b/block/genhd.c
index 2ad2b25dfc87..caeda726189c 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1254,8 +1254,7 @@ dev_t blk_lookup_devt(const char *name, int partno)
 	return devt;
 }
 
-struct gendisk *__alloc_disk_node(int minors, int node_id,
-		struct lock_class_key *lkclass)
+struct gendisk *__alloc_disk_node(int node_id, struct lock_class_key *lkclass)
 {
 	struct gendisk *disk;
 
@@ -1277,7 +1276,6 @@ struct gendisk *__alloc_disk_node(int minors, int node_id,
 	if (xa_insert(&disk->part_tbl, 0, disk->part0, GFP_KERNEL))
 		goto out_destroy_part_tbl;
 
-	disk->minors = minors;
 	rand_initialize_disk(disk);
 	disk_to_dev(disk)->class = &block_class;
 	disk_to_dev(disk)->type = &disk_type;
@@ -1309,7 +1307,7 @@ struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass)
 	if (!q)
 		return NULL;
 
-	disk = __alloc_disk_node(0, node, lkclass);
+	disk = __alloc_disk_node(node, lkclass);
 	if (!disk) {
 		blk_cleanup_queue(q);
 		return NULL;
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index 07a69b19dd31..6e44515b4d33 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -40,14 +40,14 @@ int dasd_gendisk_alloc(struct dasd_block *block)
 	if (base->devindex >= DASD_PER_MAJOR)
 		return -EBUSY;
 
-	gdp = __alloc_disk_node(1 << DASD_PARTN_BITS, NUMA_NO_NODE,
-				&dasd_bio_compl_lkclass);
+	gdp = __alloc_disk_node(NUMA_NO_NODE, &dasd_bio_compl_lkclass);
 	if (!gdp)
 		return -ENOMEM;
 
 	/* Initialize gendisk structure. */
 	gdp->major = DASD_MAJOR;
 	gdp->first_minor = base->devindex << DASD_PARTN_BITS;
+	gdp->minors = 1 << DASD_PARTN_BITS;
 	gdp->fops = &dasd_device_operations;
 
 	/*
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4986086009f1..4e22d1bb6226 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3409,7 +3409,7 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
-	gd = __alloc_disk_node(SD_MINORS, NUMA_NO_NODE, &sd_bio_compl_lkclass);
+	gd = __alloc_disk_node(NUMA_NO_NODE, &sd_bio_compl_lkclass);
 	if (!gd)
 		goto out_free;
 
@@ -3455,6 +3455,7 @@ static int sd_probe(struct device *dev)
 
 	gd->major = sd_major((index & 0xf0) >> 4);
 	gd->first_minor = ((index & 0xf) << 4) | (index & 0xfff00);
+	gd->minors = SD_MINORS;
 
 	gd->fops = &sd_fops;
 	gd->private_data = &sdkp->driver;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fee2bdfe6132..2c45b4140e67 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -714,7 +714,7 @@ static int sr_probe(struct device *dev)
 
 	kref_init(&cd->kref);
 
-	disk = __alloc_disk_node(1, NUMA_NO_NODE, &sr_bio_compl_lkclass);
+	disk = __alloc_disk_node(NUMA_NO_NODE, &sr_bio_compl_lkclass);
 	if (!disk)
 		goto fail_free;
 	mutex_init(&cd->lock);
@@ -731,6 +731,7 @@ static int sr_probe(struct device *dev)
 
 	disk->major = SCSI_CDROM_MAJOR;
 	disk->first_minor = minor;
+	disk->minors = 1;
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
 	disk->flags = GENHD_FL_CD | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index ceda9b255dba..d20f101be758 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -259,8 +259,7 @@ static inline sector_t get_capacity(struct gendisk *disk)
 int bdev_disk_changed(struct gendisk *disk, bool invalidate);
 void blk_drop_partitions(struct gendisk *disk);
 
-struct gendisk *__alloc_disk_node(int minors, int node_id,
-		struct lock_class_key *lkclass);
+struct gendisk *__alloc_disk_node(int node_id, struct lock_class_key *lkclass);
 extern void put_disk(struct gendisk *disk);
 struct gendisk *__blk_alloc_disk(int node, struct lock_class_key *lkclass);
 
-- 
2.30.2

