From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 08/14] block: Add prefix to block integrity profile flags
Date: Thu, 28 Aug 2014 15:31:26 -0400
Message-ID: <1409254292-2540-9-git-send-email-martin.petersen@oracle.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22891 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaH1Tal (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 15:30:41 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com, "Martin K. Petersen" <martin.petersen@oracle.com>

Add a BLK_ prefix to the integrity profile flags. Also rename the flags
to be more consistent with the generate/verify terminology in the rest
of the integrity code.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 block/bio-integrity.c  |  4 ++--
 block/blk-integrity.c  | 43 ++++++++++++++++++++++---------------------
 include/linux/blkdev.h |  6 ++++--
 3 files changed, 28 insertions(+), 25 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5ef996e8063f..c6bc2faf2af7 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -173,11 +173,11 @@ bool bio_integrity_enabled(struct bio *bio)
 		return false;
 
 	if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
-	    (bi->flags & INTEGRITY_FLAG_READ))
+	    (bi->flags & BLK_INTEGRITY_VERIFY))
 		return true;
 
 	if (bio_data_dir(bio) == WRITE && bi->generate_fn != NULL &&
-	    (bi->flags & INTEGRITY_FLAG_WRITE))
+	    (bi->flags & BLK_INTEGRITY_GENERATE))
 		return true;
 
 	return false;
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 3a83a7d08177..a7436ccc936b 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -269,42 +269,42 @@ static ssize_t integrity_tag_size_show(struct blk_integrity *bi, char *page)
 		return sprintf(page, "0\n");
 }
 
-static ssize_t integrity_read_store(struct blk_integrity *bi,
-				    const char *page, size_t count)
+static ssize_t integrity_verify_store(struct blk_integrity *bi,
+				      const char *page, size_t count)
 {
 	char *p = (char *) page;
 	unsigned long val = simple_strtoul(p, &p, 10);
 
 	if (val)
-		bi->flags |= INTEGRITY_FLAG_READ;
+		bi->flags |= BLK_INTEGRITY_VERIFY;
 	else
-		bi->flags &= ~INTEGRITY_FLAG_READ;
+		bi->flags &= ~BLK_INTEGRITY_VERIFY;
 
 	return count;
 }
 
-static ssize_t integrity_read_show(struct blk_integrity *bi, char *page)
+static ssize_t integrity_verify_show(struct blk_integrity *bi, char *page)
 {
-	return sprintf(page, "%d\n", (bi->flags & INTEGRITY_FLAG_READ) != 0);
+	return sprintf(page, "%d\n", (bi->flags & BLK_INTEGRITY_VERIFY) != 0);
 }
 
-static ssize_t integrity_write_store(struct blk_integrity *bi,
-				     const char *page, size_t count)
+static ssize_t integrity_generate_store(struct blk_integrity *bi,
+					const char *page, size_t count)
 {
 	char *p = (char *) page;
 	unsigned long val = simple_strtoul(p, &p, 10);
 
 	if (val)
-		bi->flags |= INTEGRITY_FLAG_WRITE;
+		bi->flags |= BLK_INTEGRITY_GENERATE;
 	else
-		bi->flags &= ~INTEGRITY_FLAG_WRITE;
+		bi->flags &= ~BLK_INTEGRITY_GENERATE;
 
 	return count;
 }
 
-static ssize_t integrity_write_show(struct blk_integrity *bi, char *page)
+static ssize_t integrity_generate_show(struct blk_integrity *bi, char *page)
 {
-	return sprintf(page, "%d\n", (bi->flags & INTEGRITY_FLAG_WRITE) != 0);
+	return sprintf(page, "%d\n", (bi->flags & BLK_INTEGRITY_GENERATE) != 0);
 }
 
 static struct integrity_sysfs_entry integrity_format_entry = {
@@ -317,23 +317,23 @@ static struct integrity_sysfs_entry integrity_tag_size_entry = {
 	.show = integrity_tag_size_show,
 };
 
-static struct integrity_sysfs_entry integrity_read_entry = {
+static struct integrity_sysfs_entry integrity_verify_entry = {
 	.attr = { .name = "read_verify", .mode = S_IRUGO | S_IWUSR },
-	.show = integrity_read_show,
-	.store = integrity_read_store,
+	.show = integrity_verify_show,
+	.store = integrity_verify_store,
 };
 
-static struct integrity_sysfs_entry integrity_write_entry = {
+static struct integrity_sysfs_entry integrity_generate_entry = {
 	.attr = { .name = "write_generate", .mode = S_IRUGO | S_IWUSR },
-	.show = integrity_write_show,
-	.store = integrity_write_store,
+	.show = integrity_generate_show,
+	.store = integrity_generate_store,
 };
 
 static struct attribute *integrity_attrs[] = {
 	&integrity_format_entry.attr,
 	&integrity_tag_size_entry.attr,
-	&integrity_read_entry.attr,
-	&integrity_write_entry.attr,
+	&integrity_verify_entry.attr,
+	&integrity_generate_entry.attr,
 	NULL,
 };
 
@@ -406,7 +406,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 
 		kobject_uevent(&bi->kobj, KOBJ_ADD);
 
-		bi->flags |= INTEGRITY_FLAG_READ | INTEGRITY_FLAG_WRITE;
+		bi->flags |= BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE;
 		bi->interval = queue_logical_block_size(disk->queue);
 		disk->integrity = bi;
 	} else
@@ -419,6 +419,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		bi->verify_fn = template->verify_fn;
 		bi->tuple_size = template->tuple_size;
 		bi->tag_size = template->tag_size;
+		bi->flags |= template->flags;
 	} else
 		bi->name = bi_unsupported_name;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5a7848f825a1..54cbd96fe94a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1464,8 +1464,10 @@ static inline uint64_t rq_io_start_time_ns(struct request *req)
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
-#define INTEGRITY_FLAG_READ	2	/* verify data integrity on read */
-#define INTEGRITY_FLAG_WRITE	4	/* generate data integrity on write */
+enum blk_integrity_flags {
+	BLK_INTEGRITY_VERIFY		= 1 << 0,
+	BLK_INTEGRITY_GENERATE		= 1 << 1,
+};
 
 struct blk_integrity_iter {
 	void			*prot_buf;
-- 
1.9.3

