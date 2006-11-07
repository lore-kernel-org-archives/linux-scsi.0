From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] blk_rq_unmap_user: remove superflous ulen argument
Date: Tue, 7 Nov 2006 18:30:43 +0100
Message-ID: <20061107173043.GA14371@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34234 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S965599AbWKGRbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 12:31:01 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

blk_rq_unmap_user does not use it's ulen argument at all, and a patch
I'm working on can't easily provide it.  So let's just remove the
argument.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/block/ll_rw_blk.c
===================================================================
--- scsi-misc-2.6.orig/block/ll_rw_blk.c	2006-11-02 15:44:06.000000000 +0100
+++ scsi-misc-2.6/block/ll_rw_blk.c	2006-11-05 11:20:55.000000000 +0100
@@ -2466,12 +2466,11 @@
 /**
  * blk_rq_unmap_user - unmap a request with user data
  * @bio:	bio to be unmapped
- * @ulen:	length of user buffer
  *
  * Description:
  *    Unmap a bio previously mapped by blk_rq_map_user().
  */
-int blk_rq_unmap_user(struct bio *bio, unsigned int ulen)
+int blk_rq_unmap_user(struct bio *bio)
 {
 	int ret = 0;
 
Index: scsi-misc-2.6/block/scsi_ioctl.c
===================================================================
--- scsi-misc-2.6.orig/block/scsi_ioctl.c	2006-11-02 15:44:06.000000000 +0100
+++ scsi-misc-2.6/block/scsi_ioctl.c	2006-11-05 11:21:00.000000000 +0100
@@ -340,7 +340,7 @@
 			hdr->sb_len_wr = len;
 	}
 
-	if (blk_rq_unmap_user(bio, hdr->dxfer_len))
+	if (blk_rq_unmap_user(bio))
 		ret = -EFAULT;
 
 	/* may not have succeeded, but output values written to control
Index: scsi-misc-2.6/drivers/cdrom/cdrom.c
===================================================================
--- scsi-misc-2.6.orig/drivers/cdrom/cdrom.c	2006-11-02 15:44:07.000000000 +0100
+++ scsi-misc-2.6/drivers/cdrom/cdrom.c	2006-11-05 11:21:11.000000000 +0100
@@ -2142,7 +2142,7 @@
 			cdi->last_sense = s->sense_key;
 		}
 
-		if (blk_rq_unmap_user(bio, len))
+		if (blk_rq_unmap_user(bio))
 			ret = -EFAULT;
 
 		if (ret)
Index: scsi-misc-2.6/include/linux/blkdev.h
===================================================================
--- scsi-misc-2.6.orig/include/linux/blkdev.h	2006-11-02 15:44:19.000000000 +0100
+++ scsi-misc-2.6/include/linux/blkdev.h	2006-11-05 11:21:20.000000000 +0100
@@ -658,7 +658,7 @@
 extern void blk_start_queueing(request_queue_t *);
 extern void blk_queue_activity_fn(request_queue_t *, activity_fn *, void *);
 extern int blk_rq_map_user(request_queue_t *, struct request *, void __user *, unsigned int);
-extern int blk_rq_unmap_user(struct bio *, unsigned int);
+extern int blk_rq_unmap_user(struct bio *);
 extern int blk_rq_map_kern(request_queue_t *, struct request *, void *, unsigned int, gfp_t);
 extern int blk_rq_map_user_iov(request_queue_t *, struct request *, struct sg_iovec *, int);
 extern int blk_execute_rq(request_queue_t *, struct gendisk *,
