From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH, scsi-block-2.6] remove bio_map_user
Date: Sun, 19 Jun 2005 11:29:46 +0200
Message-ID: <20050619092946.GA16872@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:170 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262223AbVFSJ3w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 05:29:52 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

It's only used by blk_rq_map_user and that's the only sensible caller.
So do the iov wrapping there and kill bio_map_user.


Index: linux-2.6/drivers/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/drivers/block/ll_rw_blk.c	2005-06-18 17:15:17.000000000 +0200
+++ linux-2.6/drivers/block/ll_rw_blk.c	2005-06-18 17:26:55.000000000 +0200
@@ -2126,9 +2126,10 @@
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q)))
-		bio = bio_map_user(q, NULL, uaddr, len, reading);
-	else
+	if (!(uaddr & queue_dma_alignment(q)) && !(len & queue_dma_alignment(q))) {
+		struct sg_iovec iov = { .iov_base = ubuf, .iov_len = len };
+		bio = bio_map_user_iov(q, NULL, &iov, 1, reading);
+	} else
 		bio = bio_copy_user(q, uaddr, len, reading);
 
 	if (!IS_ERR(bio)) {
Index: linux-2.6/fs/bio.c
===================================================================
--- linux-2.6.orig/fs/bio.c	2005-06-18 17:15:21.000000000 +0200
+++ linux-2.6/fs/bio.c	2005-06-18 17:26:42.000000000 +0200
@@ -662,28 +662,6 @@
 }
 
 /**
- *	bio_map_user	-	map user address into bio
- *	@q: the request_queue_t for the bio
- *	@bdev: destination block device
- *	@uaddr: start of user address
- *	@len: length in bytes
- *	@write_to_vm: bool indicating writing to pages or not
- *
- *	Map the user space address into a bio suitable for io to a block
- *	device. Returns an error pointer in case of error.
- */
-struct bio *bio_map_user(request_queue_t *q, struct block_device *bdev,
-			 unsigned long uaddr, unsigned int len, int write_to_vm)
-{
-	struct sg_iovec iov;
-
-	iov.iov_base = (__user void *)uaddr;
-	iov.iov_len = len;
-
-	return bio_map_user_iov(q, bdev, &iov, 1, write_to_vm);
-}
-
-/**
  *	bio_map_user_iov - map user sg_iovec table into bio
  *	@q: the request_queue_t for the bio
  *	@bdev: destination block device
@@ -1222,7 +1200,6 @@
 EXPORT_SYMBOL(bio_hw_segments);
 EXPORT_SYMBOL(bio_add_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
-EXPORT_SYMBOL(bio_map_user);
 EXPORT_SYMBOL(bio_unmap_user);
 EXPORT_SYMBOL(bio_map_kern);
 EXPORT_SYMBOL(bio_pair_release);
Index: linux-2.6/include/linux/bio.h
===================================================================
--- linux-2.6.orig/include/linux/bio.h	2005-06-18 17:15:21.000000000 +0200
+++ linux-2.6/include/linux/bio.h	2005-06-18 17:26:16.000000000 +0200
@@ -279,8 +279,6 @@
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
-				unsigned long, unsigned int, int);
 struct sg_iovec;
 extern struct bio *bio_map_user_iov(struct request_queue *,
 				    struct block_device *,
