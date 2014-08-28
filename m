From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 01/14] block: Get rid of bdev_integrity_enabled()
Date: Thu, 28 Aug 2014 15:31:19 -0400
Message-ID: <1409254292-2540-2-git-send-email-martin.petersen@oracle.com>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22708 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbaH1Ta3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Aug 2014 15:30:29 -0400
In-Reply-To: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, axboe@fb.com
Cc: hch@lst.de, sagig@mellanox.com, "Martin K. Petersen" <martin.petersen@oracle.com>

bdev_integrity_enabled() is only used by bio_integrity_enabled().
Combine these two functions.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
---
 Documentation/block/data-integrity.txt | 10 ---------
 block/bio-integrity.c                  | 39 +++++++++++++++-------------------
 include/linux/bio.h                    |  6 +++---
 3 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/Documentation/block/data-integrity.txt b/Documentation/block/data-integrity.txt
index 2d735b0ae383..b4eacf48053c 100644
--- a/Documentation/block/data-integrity.txt
+++ b/Documentation/block/data-integrity.txt
@@ -192,16 +192,6 @@ will require extra work due to the application tag.
     supported by the block device.
 
 
-    int bdev_integrity_enabled(block_device, int rw);
-
-      bdev_integrity_enabled() will return 1 if the block device
-      supports integrity metadata transfer for the data direction
-      specified in 'rw'.
-
-      bdev_integrity_enabled() honors the write_generate and
-      read_verify flags in sysfs and will respond accordingly.
-
-
     int bio_integrity_prep(bio);
 
       To generate IMD for WRITE and to set up buffers for READ, the
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index bc423f7b02da..d660d9ccc6b9 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -147,24 +147,6 @@ int bio_integrity_add_page(struct bio *bio, struct page *page,
 }
 EXPORT_SYMBOL(bio_integrity_add_page);
 
-static int bdev_integrity_enabled(struct block_device *bdev, int rw)
-{
-	struct blk_integrity *bi = bdev_get_integrity(bdev);
-
-	if (bi == NULL)
-		return 0;
-
-	if (rw == READ && bi->verify_fn != NULL &&
-	    (bi->flags & INTEGRITY_FLAG_READ))
-		return 1;
-
-	if (rw == WRITE && bi->generate_fn != NULL &&
-	    (bi->flags & INTEGRITY_FLAG_WRITE))
-		return 1;
-
-	return 0;
-}
-
 /**
  * bio_integrity_enabled - Check whether integrity can be passed
  * @bio:	bio to check
@@ -174,16 +156,29 @@ static int bdev_integrity_enabled(struct block_device *bdev, int rw)
  * set prior to calling.  The functions honors the write_generate and
  * read_verify flags in sysfs.
  */
-int bio_integrity_enabled(struct bio *bio)
+bool bio_integrity_enabled(struct bio *bio)
 {
+	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+
 	if (!bio_is_rw(bio))
-		return 0;
+		return false;
 
 	/* Already protected? */
 	if (bio_integrity(bio))
-		return 0;
+		return false;
+
+	if (bi == NULL)
+		return false;
+
+	if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
+	    (bi->flags & INTEGRITY_FLAG_READ))
+		return true;
+
+	if (bio_data_dir(bio) == WRITE && bi->generate_fn != NULL &&
+	    (bi->flags & INTEGRITY_FLAG_WRITE))
+		return true;
 
-	return bdev_integrity_enabled(bio->bi_bdev, bio_data_dir(bio));
+	return false;
 }
 EXPORT_SYMBOL(bio_integrity_enabled);
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b39e5000ff58..63e399b4fde5 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -666,7 +666,7 @@ struct biovec_slab {
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
-extern int bio_integrity_enabled(struct bio *bio);
+extern bool bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_get_tag(struct bio *, void *, unsigned int);
 extern int bio_integrity_prep(struct bio *);
@@ -685,9 +685,9 @@ static inline int bio_integrity(struct bio *bio)
 	return 0;
 }
 
-static inline int bio_integrity_enabled(struct bio *bio)
+static inline bool bio_integrity_enabled(struct bio *bio)
 {
-	return 0;
+	return false;
 }
 
 static inline int bioset_integrity_create(struct bio_set *bs, int pool_size)
-- 
1.9.3

