From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] change scsi_cmd_ioctl to take a gendisk instead of a queue
Date: Sun, 1 Feb 2004 12:48:03 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040201124803.A18050@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:30108 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S263571AbUBAUsh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Feb 2004 15:48:37 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org

Jens or others, any comments?

This patch against a recent bk 2.6 changes scsi_cmd_ioctl to take a
gendisk as an argument instead of a request_queue_t. This allows scsi char
devices to use the scsi_cmd_ioctl interface.
 
In turn, change bio_map_user to also pass a request_queue_t, and add a
__bio_add_page helper that takes a request_queue_t.

Tested ide cd burning with no problems.

If the scsi upper level scsi_cmd_ioctl usage were consolidated in
scsi_prep_fn, we could pass a request_queue_t instead of a gendisk to
scsi_cmd_ioctl.

st.c patch follows.

diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/drivers/block/scsi_ioctl.c char_sg_io-bk-2.6.2-rc3/drivers/block/scsi_ioctl.c
--- bk-2.6.2-rc3/drivers/block/scsi_ioctl.c	Mon Jan  5 09:00:42 2004
+++ char_sg_io-bk-2.6.2-rc3/drivers/block/scsi_ioctl.c	Sun Feb  1 11:53:03 2004
@@ -46,14 +46,14 @@ const unsigned char scsi_command_size[8]
 #define SCSI_SENSE_BUFFERSIZE 64
 #endif
 
-static int blk_do_rq(request_queue_t *q, struct block_device *bdev, 
+static int blk_do_rq(request_queue_t *q, struct gendisk *bd_disk,
 		     struct request *rq)
 {
 	char sense[SCSI_SENSE_BUFFERSIZE];
 	DECLARE_COMPLETION(wait);
 	int err = 0;
 
-	rq->rq_disk = bdev->bd_disk;
+	rq->rq_disk = bd_disk;
 
 	/*
 	 * we need an extra reference to the request, so we can look at
@@ -142,7 +142,7 @@ static int sg_emulated_host(request_queu
 	return put_user(1, p);
 }
 
-static int sg_io(request_queue_t *q, struct block_device *bdev,
+static int sg_io(request_queue_t *q, struct gendisk *bd_disk,
 		 struct sg_io_hdr *hdr)
 {
 	unsigned long start_time;
@@ -190,7 +190,7 @@ static int sg_io(request_queue_t *q, str
 		 * first try to map it into a bio. reading from device will
 		 * be a write to vm.
 		 */
-		bio = bio_map_user(bdev, (unsigned long) hdr->dxferp,
+		bio = bio_map_user(q, NULL, (unsigned long) hdr->dxferp,
 				   hdr->dxfer_len, reading);
 
 		/*
@@ -246,7 +246,7 @@ static int sg_io(request_queue_t *q, str
 	 * (if he doesn't check that is his problem).
 	 * N.B. a non-zero SCSI status is _not_ necessarily an error.
 	 */
-	blk_do_rq(q, bdev, rq);
+	blk_do_rq(q, bd_disk, rq);
 
 	if (bio)
 		bio_unmap_user(bio, reading);
@@ -296,7 +296,7 @@ out_buffer:
 #define READ_DEFECT_DATA_TIMEOUT	(60 * HZ )
 #define OMAX_SB_LEN 16          /* For backward compatibility */
 
-static int sg_scsi_ioctl(request_queue_t *q, struct block_device *bdev,
+static int sg_scsi_ioctl(request_queue_t *q, struct gendisk *bd_disk,
 			 Scsi_Ioctl_Command *sic)
 {
 	struct request *rq;
@@ -369,7 +369,7 @@ static int sg_scsi_ioctl(request_queue_t
 	rq->data_len = bytes;
 	rq->flags |= REQ_BLOCK_PC;
 
-	blk_do_rq(q, bdev, rq);
+	blk_do_rq(q, bd_disk, rq);
 	err = rq->errors & 0xff;	/* only 8 bit SCSI status */
 	if (err) {
 		if (rq->sense_len && rq->sense) {
@@ -389,13 +389,13 @@ error:
 	return err;
 }
 
-int scsi_cmd_ioctl(struct block_device *bdev, unsigned int cmd, unsigned long arg)
+int scsi_cmd_ioctl(struct gendisk *bd_disk, unsigned int cmd, unsigned long arg)
 {
 	request_queue_t *q;
 	struct request *rq;
 	int close = 0, err;
 
-	q = bdev_get_queue(bdev);
+	q = bd_disk->queue;
 	if (!q)
 		return -ENXIO;
 
@@ -446,7 +446,7 @@ int scsi_cmd_ioctl(struct block_device *
 
 			old_cdb = hdr.cmdp;
 			hdr.cmdp = cdb;
-			err = sg_io(q, bdev, &hdr);
+			err = sg_io(q, bd_disk, &hdr);
 
 			hdr.cmdp = old_cdb;
 			if (copy_to_user((struct sg_io_hdr *) arg, &hdr, sizeof(hdr)))
@@ -493,7 +493,7 @@ int scsi_cmd_ioctl(struct block_device *
 			hdr.timeout = cgc.timeout;
 			hdr.cmdp = cgc.cmd;
 			hdr.cmd_len = sizeof(cgc.cmd);
-			err = sg_io(q, bdev, &hdr);
+			err = sg_io(q, bd_disk, &hdr);
 
 			if (hdr.status)
 				err = -EIO;
@@ -514,7 +514,8 @@ int scsi_cmd_ioctl(struct block_device *
 			if (!arg)
 				break;
 
-			err = sg_scsi_ioctl(q, bdev, (Scsi_Ioctl_Command *)arg);
+			err = sg_scsi_ioctl(q, bd_disk,
+					    (Scsi_Ioctl_Command *)arg);
 			break;
 		case CDROMCLOSETRAY:
 			close = 1;
@@ -528,7 +529,7 @@ int scsi_cmd_ioctl(struct block_device *
 			rq->cmd[0] = GPCMD_START_STOP_UNIT;
 			rq->cmd[4] = 0x02 + (close != 0);
 			rq->cmd_len = 6;
-			err = blk_do_rq(q, bdev, rq);
+			err = blk_do_rq(q, bd_disk, rq);
 			blk_put_request(rq);
 			break;
 		default:
diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/drivers/cdrom/cdrom.c char_sg_io-bk-2.6.2-rc3/drivers/cdrom/cdrom.c
--- bk-2.6.2-rc3/drivers/cdrom/cdrom.c	Tue Jan 27 10:47:50 2004
+++ char_sg_io-bk-2.6.2-rc3/drivers/cdrom/cdrom.c	Sun Feb  1 11:53:03 2004
@@ -1773,7 +1773,7 @@ int cdrom_ioctl(struct cdrom_device_info
 	int ret;
 
 	/* Try the generic SCSI command ioctl's first.. */
-	ret = scsi_cmd_ioctl(ip->i_bdev, cmd, arg);
+	ret = scsi_cmd_ioctl(ip->i_bdev->bd_disk, cmd, arg);
 	if (ret != -ENOTTY)
 		return ret;
 
diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/drivers/ide/ide.c char_sg_io-bk-2.6.2-rc3/drivers/ide/ide.c
--- bk-2.6.2-rc3/drivers/ide/ide.c	Thu Jan 22 09:36:55 2004
+++ char_sg_io-bk-2.6.2-rc3/drivers/ide/ide.c	Sun Feb  1 11:53:03 2004
@@ -1707,7 +1707,7 @@ int generic_ide_ioctl(struct block_devic
 
 		case CDROMEJECT:
 		case CDROMCLOSETRAY:
-			return scsi_cmd_ioctl(bdev, cmd, arg);
+			return scsi_cmd_ioctl(bdev->bd_disk, cmd, arg);
 
 		case HDIO_GET_BUSSTATE:
 			if (!capable(CAP_SYS_ADMIN))
diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/drivers/scsi/sd.c char_sg_io-bk-2.6.2-rc3/drivers/scsi/sd.c
--- bk-2.6.2-rc3/drivers/scsi/sd.c	Mon Nov 10 15:29:09 2003
+++ char_sg_io-bk-2.6.2-rc3/drivers/scsi/sd.c	Sun Feb  1 11:53:03 2004
@@ -554,7 +554,7 @@ static int sd_ioctl(struct inode * inode
 		case SCSI_IOCTL_GET_BUS_NUMBER:
 			return scsi_ioctl(sdp, cmd, (void *)arg);
 		default:
-			error = scsi_cmd_ioctl(bdev, cmd, arg);
+			error = scsi_cmd_ioctl(disk, cmd, arg);
 			if (error != -ENOTTY)
 				return error;
 	}
diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/fs/bio.c char_sg_io-bk-2.6.2-rc3/fs/bio.c
--- bk-2.6.2-rc3/fs/bio.c	Thu Jan 22 09:36:58 2004
+++ char_sg_io-bk-2.6.2-rc3/fs/bio.c	Sun Feb  1 11:55:27 2004
@@ -281,23 +281,9 @@ int bio_get_nr_vecs(struct block_device 
 	return nr_pages;
 }
 
-/**
- *	bio_add_page	-	attempt to add page to bio
- *	@bio: destination bio
- *	@page: page to add
- *	@len: vec entry length
- *	@offset: vec entry offset
- *
- *	Attempt to add a page to the bio_vec maplist. This can fail for a
- *	number of reasons, such as the bio being full or target block
- *	device limitations. The target block device must allow bio's
- *      smaller than PAGE_SIZE, so it is always possible to add a single
- *      page to an empty bio.
- */
-int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
-		 unsigned int offset)
+static int __bio_add_page(request_queue_t *q, struct bio *bio, struct page
+			  *page, unsigned int len, unsigned int offset)
 {
-	request_queue_t *q = bdev_get_queue(bio->bi_bdev);
 	int retried_segments = 0;
 	struct bio_vec *bvec;
 
@@ -362,14 +348,33 @@ int bio_add_page(struct bio *bio, struct
 	return len;
 }
 
-static struct bio *__bio_map_user(struct block_device *bdev,
+/**
+ *	bio_add_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block
+ *	device limitations. The target block device must allow bio's
+ *      smaller than PAGE_SIZE, so it is always possible to add a single
+ *      page to an empty bio.
+ */
+int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
+		 unsigned int offset)
+{
+	return __bio_add_page(bdev_get_queue(bio->bi_bdev), bio, page,
+			      len, offset);
+}
+
+static struct bio *__bio_map_user(request_queue_t *q, struct block_device *bdev,
 				  unsigned long uaddr, unsigned int len,
 				  int write_to_vm)
 {
 	unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = uaddr >> PAGE_SHIFT;
 	const int nr_pages = end - start;
-	request_queue_t *q = bdev_get_queue(bdev);
 	int ret, offset, i;
 	struct page **pages;
 	struct bio *bio;
@@ -412,7 +417,7 @@ static struct bio *__bio_map_user(struct
 		/*
 		 * sorry...
 		 */
-		if (bio_add_page(bio, pages[i], bytes, offset) < bytes)
+		if (__bio_add_page(q, bio, pages[i], bytes, offset) < bytes)
 			break;
 
 		len -= bytes;
@@ -451,12 +456,12 @@ out:
  *	Map the user space address into a bio suitable for io to a block
  *	device.
  */
-struct bio *bio_map_user(struct block_device *bdev, unsigned long uaddr,
-			 unsigned int len, int write_to_vm)
+struct bio *bio_map_user(request_queue_t *q, struct block_device *bdev,
+			 unsigned long uaddr, unsigned int len, int write_to_vm)
 {
 	struct bio *bio;
 
-	bio = __bio_map_user(bdev, uaddr, len, write_to_vm);
+	bio = __bio_map_user(q, bdev, uaddr, len, write_to_vm);
 
 	if (bio) {
 		/*
diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/include/linux/bio.h char_sg_io-bk-2.6.2-rc3/include/linux/bio.h
--- bk-2.6.2-rc3/include/linux/bio.h	Thu Jan 22 09:37:00 2004
+++ char_sg_io-bk-2.6.2-rc3/include/linux/bio.h	Sun Feb  1 11:53:03 2004
@@ -241,8 +241,8 @@ extern inline void bio_init(struct bio *
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
-extern struct bio *bio_map_user(struct block_device *, unsigned long,
-				unsigned int, int);
+extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
+				unsigned long, unsigned int, int);
 extern void bio_unmap_user(struct bio *, int);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
diff -uprN -X /home/patman/dontdiff bk-2.6.2-rc3/include/linux/blkdev.h char_sg_io-bk-2.6.2-rc3/include/linux/blkdev.h
--- bk-2.6.2-rc3/include/linux/blkdev.h	Tue Jan 27 10:47:51 2004
+++ char_sg_io-bk-2.6.2-rc3/include/linux/blkdev.h	Sun Feb  1 11:53:03 2004
@@ -508,7 +508,7 @@ extern int blk_remove_plug(request_queue
 extern void blk_recount_segments(request_queue_t *, struct bio *);
 extern inline int blk_phys_contig_segment(request_queue_t *q, struct bio *, struct bio *);
 extern inline int blk_hw_contig_segment(request_queue_t *q, struct bio *, struct bio *);
-extern int scsi_cmd_ioctl(struct block_device *, unsigned int, unsigned long);
+extern int scsi_cmd_ioctl(struct gendisk *, unsigned int, unsigned long);
 extern void blk_start_queue(request_queue_t *q);
 extern void blk_stop_queue(request_queue_t *q);
 extern void __blk_stop_queue(request_queue_t *q);
