From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH 3/6] block: export blk_verify_command for SG v4
Date: Wed, 20 Dec 2006 14:43:06 +0900
Message-ID: <20061220144306B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:61029 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933009AbWLTFnR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Dec 2006 00:43:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

blk_fill_sghdr_rq doesn't work for SG v4 so verify_command needed to
be exported.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/scsi_ioctl.c     |    7 ++++---
 include/linux/blkdev.h |    1 +
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 5e69ef6..18e935f 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -110,7 +110,7 @@ #define CMD_WARNED	0x04
 #define safe_for_read(cmd)	[cmd] = CMD_READ_SAFE
 #define safe_for_write(cmd)	[cmd] = CMD_WRITE_SAFE
 
-static int verify_command(unsigned char *cmd, int has_write_perm)
+int blk_verify_command(unsigned char *cmd, int has_write_perm)
 {
 	static unsigned char cmd_type[256] = {
 
@@ -210,6 +210,7 @@ static int verify_command(unsigned char
 	/* Otherwise fail it with an "Operation not permitted" */
 	return -EPERM;
 }
+EXPORT_SYMBOL_GPL(blk_verify_command);
 
 int blk_fill_sghdr_rq(request_queue_t *q, struct request *rq,
 		      struct sg_io_hdr *hdr, int has_write_perm)
@@ -218,7 +219,7 @@ int blk_fill_sghdr_rq(request_queue_t *q
 
 	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (verify_command(rq->cmd, has_write_perm))
+	if (blk_verify_command(rq->cmd, has_write_perm))
 		return -EPERM;
 
 	/*
@@ -455,7 +456,7 @@ int sg_scsi_ioctl(struct file *file, str
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = verify_command(rq->cmd, file->f_mode & FMODE_WRITE);
+	err = blk_verify_command(rq->cmd, file->f_mode & FMODE_WRITE);
 	if (err)
 		goto error;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3f99737..9c55749 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -692,6 +692,7 @@ extern int blk_fill_sghdr_rq(request_que
 extern int blk_unmap_sghdr_rq(struct request *, struct sg_io_hdr *);
 extern int blk_complete_sghdr_rq(struct request *, struct sg_io_hdr *,
 			  struct bio *);
+extern int blk_verify_command(unsigned char *, int);
 
 static inline request_queue_t *bdev_get_queue(struct block_device *bdev)
 {
-- 
1.4.3.2

