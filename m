From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] move cmd_filter from gendisk to request_queue
Date: Sat, 26 Jul 2008 18:03:23 +0900
Message-ID: <1217063005-25083-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <20080724123140V.fujita.tomonori@lab.ntt.co.jp>
 <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:55199 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYGZJFX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2008 05:05:23 -0400
In-Reply-To: <1217063005-25083-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, dan.j.williams@intel.com, adel.gadllah@gmail.com, pjones@redhat.com, viro@ZenIV.linux.org.uk, dougg@torque.net, matthew@wil.cx, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

cmd_filter works only for the block layer SG_IO with SCSI block
devices. It breaks scsi/sg.c, bsg, and the block layer SG_IO with SCSI
character devices (such as st). We hit a kernel crash with them.

The problem is that cmd_filter code accesses to gendisk (having struct
blk_scsi_cmd_filter) via inode->i_bdev->bd_disk. It works for only
SCSI block device files. With character device files, inode->i_bdev
leads you to struct cdev. inode->i_bdev->bd_disk->blk_scsi_cmd_filter
isn't safe.

SCSI ULDs don't expose gendisk; they keep it private. bsg needs to be
independent on any protocols. We shouldn't change ULDs to expose their
gendisk.

This patch moves struct blk_scsi_cmd_filter from gendisk to
request_queue, a common object, which eveyone can access to.

The user interface doesn't change; users can change the filters via
/sys/block/. gendisk has a pointer to request_queue so the cmd_filter
code accesses to struct blk_scsi_cmd_filter.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c             |   45 +++++-------------
 block/cmd-filter.c      |  118 ++--------------------------------------------
 block/scsi_ioctl.c      |   94 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/scsi_lib.c |    2 +
 drivers/scsi/sg.c       |   11 ++++-
 include/linux/blkdev.h  |   16 +++++-
 include/linux/genhd.h   |   10 ----
 7 files changed, 133 insertions(+), 163 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 5a68b09..6c5c6f3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -45,8 +45,6 @@ struct bsg_device {
 	char name[BUS_ID_SIZE];
 	int max_queue;
 	unsigned long flags;
-	struct blk_scsi_cmd_filter *cmd_filter;
-	mode_t *f_mode;
 };
 
 enum {
@@ -87,6 +85,7 @@ struct bsg_command {
 	int err;
 	struct sg_io_v4 hdr;
 	char sense[SCSI_SENSE_BUFFERSIZE];
+	int has_write_perm;
 };
 
 static void bsg_free_command(struct bsg_command *bc)
@@ -174,7 +173,8 @@ unlock:
 }
 
 static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
-				struct sg_io_v4 *hdr, struct bsg_device *bd)
+				struct sg_io_v4 *hdr, struct bsg_device *bd,
+				int has_write_perm)
 {
 	if (hdr->request_len > BLK_MAX_CDB) {
 		rq->cmd = kzalloc(hdr->request_len, GFP_KERNEL);
@@ -187,8 +187,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 		return -EFAULT;
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_cmd_filter_verify_command(bd->cmd_filter, rq->cmd,
-						 bd->f_mode))
+		if (blk_verify_command(&q->cmd_filter, rq->cmd, has_write_perm))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
@@ -244,7 +243,7 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
  * map sg_io_v4 to a request.
  */
 static struct request *
-bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
+bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, int has_write_perm)
 {
 	struct request_queue *q = bd->queue;
 	struct request *rq, *next_rq = NULL;
@@ -266,7 +265,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr)
 	rq = blk_get_request(q, rw, GFP_KERNEL);
 	if (!rq)
 		return ERR_PTR(-ENOMEM);
-	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd);
+	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
 	if (ret)
 		goto out;
 
@@ -568,25 +567,6 @@ static inline void bsg_set_block(struct bsg_device *bd, struct file *file)
 		set_bit(BSG_F_BLOCK, &bd->flags);
 }
 
-static void bsg_set_cmd_filter(struct bsg_device *bd,
-			   struct file *file)
-{
-	struct inode *inode;
-	struct gendisk *disk;
-
-	if (!file)
-		return;
-
-	inode = file->f_dentry->d_inode;
-	if (!inode)
-		return;
-
-	disk = inode->i_bdev->bd_disk;
-
-	bd->cmd_filter = &disk->cmd_filter;
-	bd->f_mode = &file->f_mode;
-}
-
 /*
  * Check if the error is a "real" error that we should return.
  */
@@ -608,7 +588,6 @@ bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	dprintk("%s: read %Zd bytes\n", bd->name, count);
 
 	bsg_set_block(bd, file);
-	bsg_set_cmd_filter(bd, file);
 
 	bytes_read = 0;
 	ret = __bsg_read(buf, count, bd, NULL, &bytes_read);
@@ -621,7 +600,7 @@ bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 }
 
 static int __bsg_write(struct bsg_device *bd, const char __user *buf,
-		       size_t count, ssize_t *bytes_written)
+		       size_t count, ssize_t *bytes_written, int has_write_perm)
 {
 	struct bsg_command *bc;
 	struct request *rq;
@@ -652,7 +631,7 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
 		/*
 		 * get a request, fill in the blanks, and add to request queue
 		 */
-		rq = bsg_map_hdr(bd, &bc->hdr);
+		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm);
 		if (IS_ERR(rq)) {
 			ret = PTR_ERR(rq);
 			rq = NULL;
@@ -683,10 +662,11 @@ bsg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	dprintk("%s: write %Zd bytes\n", bd->name, count);
 
 	bsg_set_block(bd, file);
-	bsg_set_cmd_filter(bd, file);
 
 	bytes_written = 0;
-	ret = __bsg_write(bd, buf, count, &bytes_written);
+	ret = __bsg_write(bd, buf, count, &bytes_written,
+			  file->f_mode & FMODE_WRITE);
+
 	*ppos = bytes_written;
 
 	/*
@@ -792,7 +772,6 @@ static struct bsg_device *bsg_add_device(struct inode *inode,
 	bd->queue = rq;
 
 	bsg_set_block(bd, file);
-	bsg_set_cmd_filter(bd, file);
 
 	atomic_set(&bd->ref_count, 1);
 	mutex_lock(&bsg_mutex);
@@ -943,7 +922,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
 			return -EFAULT;
 
-		rq = bsg_map_hdr(bd, &hdr);
+		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE);
 		if (IS_ERR(rq))
 			return PTR_ERR(rq);
 
diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index eec4404..c705c33 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -27,8 +27,8 @@
 #include <scsi/scsi.h>
 #include <linux/cdrom.h>
 
-int blk_cmd_filter_verify_command(struct blk_scsi_cmd_filter *filter,
-				  unsigned char *cmd, mode_t *f_mode)
+int blk_verify_command(struct blk_scsi_cmd_filter *filter,
+		       unsigned char *cmd, int has_write_perm)
 {
 	/* root can do any command. */
 	if (capable(CAP_SYS_RAWIO))
@@ -43,30 +43,11 @@ int blk_cmd_filter_verify_command(struct blk_scsi_cmd_filter *filter,
 		return 0;
 
 	/* Write-safe commands require a writable open */
-	if (test_bit(cmd[0], filter->write_ok) && (*f_mode & FMODE_WRITE))
+	if (test_bit(cmd[0], filter->write_ok) && has_write_perm)
 		return 0;
 
 	return -EPERM;
 }
-EXPORT_SYMBOL(blk_cmd_filter_verify_command);
-
-int blk_verify_command(struct file *file, unsigned char *cmd)
-{
-	struct gendisk *disk;
-	struct inode *inode;
-
-	if (!file)
-		return -EINVAL;
-
-	inode = file->f_dentry->d_inode;
-	if (!inode)
-		return -EINVAL;
-
-	disk = inode->i_bdev->bd_disk;
-
-	return blk_cmd_filter_verify_command(&disk->cmd_filter,
-						 cmd, &file->f_mode);
-}
 EXPORT_SYMBOL(blk_verify_command);
 
 /* and now, the sysfs stuff */
@@ -219,114 +200,27 @@ static struct kobj_type rcf_ktype = {
 	.default_attrs = default_attrs,
 };
 
-#ifndef MAINTENANCE_IN_CMD
-#define MAINTENANCE_IN_CMD 0xa3
-#endif
-
-static void rcf_set_defaults(struct blk_scsi_cmd_filter *filter)
-{
-	/* Basic read-only commands */
-	__set_bit(TEST_UNIT_READY, filter->read_ok);
-	__set_bit(REQUEST_SENSE, filter->read_ok);
-	__set_bit(READ_6, filter->read_ok);
-	__set_bit(READ_10, filter->read_ok);
-	__set_bit(READ_12, filter->read_ok);
-	__set_bit(READ_16, filter->read_ok);
-	__set_bit(READ_BUFFER, filter->read_ok);
-	__set_bit(READ_DEFECT_DATA, filter->read_ok);
-	__set_bit(READ_CAPACITY, filter->read_ok);
-	__set_bit(READ_LONG, filter->read_ok);
-	__set_bit(INQUIRY, filter->read_ok);
-	__set_bit(MODE_SENSE, filter->read_ok);
-	__set_bit(MODE_SENSE_10, filter->read_ok);
-	__set_bit(LOG_SENSE, filter->read_ok);
-	__set_bit(START_STOP, filter->read_ok);
-	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
-	__set_bit(VERIFY_16, filter->read_ok);
-	__set_bit(REPORT_LUNS, filter->read_ok);
-	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
-	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
-	__set_bit(MAINTENANCE_IN_CMD, filter->read_ok);
-	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
-
-	/* Audio CD commands */
-	__set_bit(GPCMD_PLAY_CD, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_10, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_MSF, filter->read_ok);
-	__set_bit(GPCMD_PLAY_AUDIO_TI, filter->read_ok);
-	__set_bit(GPCMD_PAUSE_RESUME, filter->read_ok);
-
-	/* CD/DVD data reading */
-	__set_bit(GPCMD_READ_CD, filter->read_ok);
-	__set_bit(GPCMD_READ_CD_MSF, filter->read_ok);
-	__set_bit(GPCMD_READ_DISC_INFO, filter->read_ok);
-	__set_bit(GPCMD_READ_CDVD_CAPACITY, filter->read_ok);
-	__set_bit(GPCMD_READ_DVD_STRUCTURE, filter->read_ok);
-	__set_bit(GPCMD_READ_HEADER, filter->read_ok);
-	__set_bit(GPCMD_READ_TRACK_RZONE_INFO, filter->read_ok);
-	__set_bit(GPCMD_READ_SUBCHANNEL, filter->read_ok);
-	__set_bit(GPCMD_READ_TOC_PMA_ATIP, filter->read_ok);
-	__set_bit(GPCMD_REPORT_KEY, filter->read_ok);
-	__set_bit(GPCMD_SCAN, filter->read_ok);
-	__set_bit(GPCMD_GET_CONFIGURATION, filter->read_ok);
-	__set_bit(GPCMD_READ_FORMAT_CAPACITIES, filter->read_ok);
-	__set_bit(GPCMD_GET_EVENT_STATUS_NOTIFICATION, filter->read_ok);
-	__set_bit(GPCMD_GET_PERFORMANCE, filter->read_ok);
-	__set_bit(GPCMD_SEEK, filter->read_ok);
-	__set_bit(GPCMD_STOP_PLAY_SCAN, filter->read_ok);
-
-	/* Basic writing commands */
-	__set_bit(WRITE_6, filter->write_ok);
-	__set_bit(WRITE_10, filter->write_ok);
-	__set_bit(WRITE_VERIFY, filter->write_ok);
-	__set_bit(WRITE_12, filter->write_ok);
-	__set_bit(WRITE_VERIFY_12, filter->write_ok);
-	__set_bit(WRITE_16, filter->write_ok);
-	__set_bit(WRITE_LONG, filter->write_ok);
-	__set_bit(WRITE_LONG_2, filter->write_ok);
-	__set_bit(ERASE, filter->write_ok);
-	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
-	__set_bit(MODE_SELECT, filter->write_ok);
-	__set_bit(LOG_SELECT, filter->write_ok);
-	__set_bit(GPCMD_BLANK, filter->write_ok);
-	__set_bit(GPCMD_CLOSE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_FLUSH_CACHE, filter->write_ok);
-	__set_bit(GPCMD_FORMAT_UNIT, filter->write_ok);
-	__set_bit(GPCMD_REPAIR_RZONE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_RESERVE_RZONE_TRACK, filter->write_ok);
-	__set_bit(GPCMD_SEND_DVD_STRUCTURE, filter->write_ok);
-	__set_bit(GPCMD_SEND_EVENT, filter->write_ok);
-	__set_bit(GPCMD_SEND_KEY, filter->write_ok);
-	__set_bit(GPCMD_SEND_OPC, filter->write_ok);
-	__set_bit(GPCMD_SEND_CUE_SHEET, filter->write_ok);
-	__set_bit(GPCMD_SET_SPEED, filter->write_ok);
-	__set_bit(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, filter->write_ok);
-	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
-	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
-}
-
 int blk_register_filter(struct gendisk *disk)
 {
 	int ret;
-	struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
+	struct blk_scsi_cmd_filter *filter = &disk->queue->cmd_filter;
 	struct kobject *parent = kobject_get(disk->holder_dir->parent);
 
 	if (!parent)
 		return -ENODEV;
 
 	ret = kobject_init_and_add(&filter->kobj, &rcf_ktype, parent,
-				 "%s", "cmd_filter");
+				   "%s", "cmd_filter");
 
 	if (ret < 0)
 		return ret;
 
-	rcf_set_defaults(filter);
 	return 0;
 }
 
 void blk_unregister_filter(struct gendisk *disk)
 {
-	struct blk_scsi_cmd_filter *filter = &disk->cmd_filter;
+	struct blk_scsi_cmd_filter *filter = &disk->queue->cmd_filter;
 
 	kobject_put(&filter->kobj);
 	kobject_put(disk->holder_dir->parent);
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index c5b9bcf..1f7d56e 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -105,12 +105,96 @@ static int sg_emulated_host(struct request_queue *q, int __user *p)
 	return put_user(1, p);
 }
 
+void blk_set_cmd_filter_defaults(struct blk_scsi_cmd_filter *filter)
+{
+	/* Basic read-only commands */
+	__set_bit(TEST_UNIT_READY, filter->read_ok);
+	__set_bit(REQUEST_SENSE, filter->read_ok);
+	__set_bit(READ_6, filter->read_ok);
+	__set_bit(READ_10, filter->read_ok);
+	__set_bit(READ_12, filter->read_ok);
+	__set_bit(READ_16, filter->read_ok);
+	__set_bit(READ_BUFFER, filter->read_ok);
+	__set_bit(READ_DEFECT_DATA, filter->read_ok);
+	__set_bit(READ_CAPACITY, filter->read_ok);
+	__set_bit(READ_LONG, filter->read_ok);
+	__set_bit(INQUIRY, filter->read_ok);
+	__set_bit(MODE_SENSE, filter->read_ok);
+	__set_bit(MODE_SENSE_10, filter->read_ok);
+	__set_bit(LOG_SENSE, filter->read_ok);
+	__set_bit(START_STOP, filter->read_ok);
+	__set_bit(GPCMD_VERIFY_10, filter->read_ok);
+	__set_bit(VERIFY_16, filter->read_ok);
+	__set_bit(REPORT_LUNS, filter->read_ok);
+	__set_bit(SERVICE_ACTION_IN, filter->read_ok);
+	__set_bit(RECEIVE_DIAGNOSTIC, filter->read_ok);
+	__set_bit(MAINTENANCE_IN, filter->read_ok);
+	__set_bit(GPCMD_READ_BUFFER_CAPACITY, filter->read_ok);
+
+	/* Audio CD commands */
+	__set_bit(GPCMD_PLAY_CD, filter->read_ok);
+	__set_bit(GPCMD_PLAY_AUDIO_10, filter->read_ok);
+	__set_bit(GPCMD_PLAY_AUDIO_MSF, filter->read_ok);
+	__set_bit(GPCMD_PLAY_AUDIO_TI, filter->read_ok);
+	__set_bit(GPCMD_PAUSE_RESUME, filter->read_ok);
+
+	/* CD/DVD data reading */
+	__set_bit(GPCMD_READ_CD, filter->read_ok);
+	__set_bit(GPCMD_READ_CD_MSF, filter->read_ok);
+	__set_bit(GPCMD_READ_DISC_INFO, filter->read_ok);
+	__set_bit(GPCMD_READ_CDVD_CAPACITY, filter->read_ok);
+	__set_bit(GPCMD_READ_DVD_STRUCTURE, filter->read_ok);
+	__set_bit(GPCMD_READ_HEADER, filter->read_ok);
+	__set_bit(GPCMD_READ_TRACK_RZONE_INFO, filter->read_ok);
+	__set_bit(GPCMD_READ_SUBCHANNEL, filter->read_ok);
+	__set_bit(GPCMD_READ_TOC_PMA_ATIP, filter->read_ok);
+	__set_bit(GPCMD_REPORT_KEY, filter->read_ok);
+	__set_bit(GPCMD_SCAN, filter->read_ok);
+	__set_bit(GPCMD_GET_CONFIGURATION, filter->read_ok);
+	__set_bit(GPCMD_READ_FORMAT_CAPACITIES, filter->read_ok);
+	__set_bit(GPCMD_GET_EVENT_STATUS_NOTIFICATION, filter->read_ok);
+	__set_bit(GPCMD_GET_PERFORMANCE, filter->read_ok);
+	__set_bit(GPCMD_SEEK, filter->read_ok);
+	__set_bit(GPCMD_STOP_PLAY_SCAN, filter->read_ok);
+
+	/* Basic writing commands */
+	__set_bit(WRITE_6, filter->write_ok);
+	__set_bit(WRITE_10, filter->write_ok);
+	__set_bit(WRITE_VERIFY, filter->write_ok);
+	__set_bit(WRITE_12, filter->write_ok);
+	__set_bit(WRITE_VERIFY_12, filter->write_ok);
+	__set_bit(WRITE_16, filter->write_ok);
+	__set_bit(WRITE_LONG, filter->write_ok);
+	__set_bit(WRITE_LONG_2, filter->write_ok);
+	__set_bit(ERASE, filter->write_ok);
+	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
+	__set_bit(MODE_SELECT, filter->write_ok);
+	__set_bit(LOG_SELECT, filter->write_ok);
+	__set_bit(GPCMD_BLANK, filter->write_ok);
+	__set_bit(GPCMD_CLOSE_TRACK, filter->write_ok);
+	__set_bit(GPCMD_FLUSH_CACHE, filter->write_ok);
+	__set_bit(GPCMD_FORMAT_UNIT, filter->write_ok);
+	__set_bit(GPCMD_REPAIR_RZONE_TRACK, filter->write_ok);
+	__set_bit(GPCMD_RESERVE_RZONE_TRACK, filter->write_ok);
+	__set_bit(GPCMD_SEND_DVD_STRUCTURE, filter->write_ok);
+	__set_bit(GPCMD_SEND_EVENT, filter->write_ok);
+	__set_bit(GPCMD_SEND_KEY, filter->write_ok);
+	__set_bit(GPCMD_SEND_OPC, filter->write_ok);
+	__set_bit(GPCMD_SEND_CUE_SHEET, filter->write_ok);
+	__set_bit(GPCMD_SET_SPEED, filter->write_ok);
+	__set_bit(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL, filter->write_ok);
+	__set_bit(GPCMD_LOAD_UNLOAD, filter->write_ok);
+	__set_bit(GPCMD_SET_STREAMING, filter->write_ok);
+}
+EXPORT_SYMBOL_GPL(blk_set_cmd_filter_defaults);
+
 static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 			     struct sg_io_hdr *hdr, struct file *file)
 {
 	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(file, rq->cmd))
+	if (blk_verify_command(&q->cmd_filter, rq->cmd,
+			       file->f_mode & FMODE_WRITE))
 		return -EPERM;
 
 	/*
@@ -298,7 +382,7 @@ int sg_scsi_ioctl(struct file *file, struct request_queue *q,
 		  struct gendisk *disk, struct scsi_ioctl_command __user *sic)
 {
 	struct request *rq;
-	int err;
+	int err, write_perm = 0;
 	unsigned int in_len, out_len, bytes, opcode, cmdlen;
 	char *buffer = NULL, sense[SCSI_SENSE_BUFFERSIZE];
 
@@ -340,7 +424,11 @@ int sg_scsi_ioctl(struct file *file, struct request_queue *q,
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = blk_verify_command(file, rq->cmd);
+	/* scsi_ioctl passes NULL */
+	if (file && (file->f_mode & FMODE_WRITE))
+		write_perm = 1;
+
+	err = blk_verify_command(&q->cmd_filter, rq->cmd, write_perm);
 	if (err)
 		goto error;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 88d1b5f..51cdae8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1617,6 +1617,8 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	 */
 	blk_queue_dma_alignment(q, 0x03);
 
+	blk_set_cmd_filter_defaults(&q->cmd_filter);
+
 	return q;
 }
 EXPORT_SYMBOL(__scsi_alloc_queue);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index d3b8ebb..207c357 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -641,6 +641,7 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 	unsigned char cmnd[MAX_COMMAND_SIZE];
 	int timeout;
 	unsigned long ul_timeout;
+	struct request_queue *q;
 
 	if (count < SZ_SG_IO_HDR)
 		return -EINVAL;
@@ -689,7 +690,9 @@ sg_new_write(Sg_fd *sfp, struct file *file, const char __user *buf,
 		sg_remove_request(sfp, srp);
 		return -EFAULT;
 	}
-	if (read_only && !blk_verify_command(file, cmnd)) {
+	q = sfp->parentdp->device->request_queue;
+	if (read_only && blk_verify_command(&q->cmd_filter, cmnd,
+					    file->f_mode & FMODE_WRITE)) {
 		sg_remove_request(sfp, srp);
 		return -EPERM;
 	}
@@ -793,6 +796,7 @@ sg_ioctl(struct inode *inode, struct file *filp,
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
+
 	SCSI_LOG_TIMEOUT(3, printk("sg_ioctl: %s, cmd=0x%x\n",
 				   sdp->disk->disk_name, (int) cmd_in));
 	read_only = (O_RDWR != (filp->f_flags & O_ACCMODE));
@@ -1057,11 +1061,14 @@ sg_ioctl(struct inode *inode, struct file *filp,
 			return -ENODEV;
 		if (read_only) {
 			unsigned char opcode = WRITE_6;
+			struct request_queue *q = sdp->device->request_queue;
 			Scsi_Ioctl_Command __user *siocp = p;
 
 			if (copy_from_user(&opcode, siocp->data, 1))
 				return -EFAULT;
-			if (!blk_verify_command(filp, &opcode))
+			if (blk_verify_command(&q->cmd_filter,
+					       &opcode,
+					       filp->f_mode & FMODE_WRITE))
 				return -EPERM;
 		}
 		return sg_scsi_ioctl(filp, sdp->device->request_queue, NULL, p);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 88d6808..211160f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -280,6 +280,15 @@ struct blk_queue_tag {
 	atomic_t refcnt;		/* map can be shared */
 };
 
+#define BLK_SCSI_MAX_CMDS	(256)
+#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
+
+struct blk_scsi_cmd_filter {
+	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
+	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
+	struct kobject kobj;
+};
+
 struct request_queue
 {
 	/*
@@ -398,6 +407,7 @@ struct request_queue
 #if defined(CONFIG_BLK_DEV_BSG)
 	struct bsg_class_device bsg_dev;
 #endif
+	struct blk_scsi_cmd_filter cmd_filter;
 };
 
 #define QUEUE_FLAG_CLUSTER	0	/* cluster several segments into 1 */
@@ -832,11 +842,11 @@ extern int blkdev_issue_flush(struct block_device *, sector_t *);
 /*
 * command filter functions
 */
-extern int blk_verify_command(struct file *file, unsigned char *cmd);
-extern int blk_cmd_filter_verify_command(struct blk_scsi_cmd_filter *filter,
-					 unsigned char *cmd, mode_t *f_mode);
+extern int blk_verify_command(struct blk_scsi_cmd_filter *filter,
+			      unsigned char *cmd, int has_write_perm);
 extern int blk_register_filter(struct gendisk *disk);
 extern void blk_unregister_filter(struct gendisk *disk);
+extern void blk_set_cmd_filter_defaults(struct blk_scsi_cmd_filter *filter);
 
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e878741..0978e1e 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -110,15 +110,6 @@ struct hd_struct {
 #define GENHD_FL_SUPPRESS_PARTITION_INFO	32
 #define GENHD_FL_FAIL				64
 
-#define BLK_SCSI_MAX_CMDS	(256)
-#define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
-
-struct blk_scsi_cmd_filter {
-	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
-	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-	struct kobject kobj;
-};
-
 struct gendisk {
 	int major;			/* major number of driver */
 	int first_minor;
@@ -128,7 +119,6 @@ struct gendisk {
 	struct hd_struct **part;	/* [indexed by minor] */
 	struct block_device_operations *fops;
 	struct request_queue *queue;
-	struct blk_scsi_cmd_filter cmd_filter;
 	void *private_data;
 	sector_t capacity;
 
-- 
1.5.4.2

