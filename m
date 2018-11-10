From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 1/3] block: add back queue-private command filter
Date: Sat, 10 Nov 2018 17:35:31 +0100
Message-ID: <1541867733-7836-2-git-send-email-pbonzini@redhat.com>
References: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1541867733-7836-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

The command filter used to be mutable via sysfs, but this was broken
and backed out. Let's add it back. This patch adds the infrastructure
for filtering, but unlike the old code this one just adds a pointer to
request_queue, so as to make it cheaper in the majority of cases where
no special filtering is desired.

This is a revert of commit 018e044 ("block: get rid of queue-private
command filter", 2009-06-26), though with many changes.

Cc: linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-sysfs.c      |  2 ++
 block/bsg-lib.c        |  4 ++--
 block/bsg.c            |  8 ++++----
 block/scsi_ioctl.c     | 19 +++++++++----------
 drivers/scsi/sg.c      |  5 +++--
 include/linux/blkdev.h |  9 ++++++++-
 include/linux/bsg.h    |  4 ++--
 7 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3772671cf2bc..d1ec150a3478 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -838,6 +838,8 @@ static void __blk_release_queue(struct work_struct *work)
 
 	blk_exit_rl(q, &q->root_rl);
 
+	kfree(q->cmd_filter);
+
 	if (q->queue_tags)
 		__blk_queue_free_tags(q);
 
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index f3501cdaf1a6..23200d8b035d 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -41,8 +41,8 @@ static int bsg_transport_check_proto(struct sg_io_v4 *hdr)
 	return 0;
 }
 
-static int bsg_transport_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
-		fmode_t mode)
+static int bsg_transport_fill_hdr(struct request_queue *q, struct request *rq,
+				  struct sg_io_v4 *hdr, fmode_t mode)
 {
 	struct bsg_job *job = blk_mq_rq_to_pdu(rq);
 
diff --git a/block/bsg.c b/block/bsg.c
index 9a442c23a715..ec8cbf3bf734 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -69,8 +69,8 @@ static int bsg_scsi_check_proto(struct sg_io_v4 *hdr)
 	return 0;
 }
 
-static int bsg_scsi_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
-		fmode_t mode)
+static int bsg_scsi_fill_hdr(struct request_queue *q, struct request *rq,
+			     struct sg_io_v4 *hdr, fmode_t mode)
 {
 	struct scsi_request *sreq = scsi_req(rq);
 
@@ -83,7 +83,7 @@ static int bsg_scsi_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
 
 	if (copy_from_user(sreq->cmd, uptr64(hdr->request), sreq->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(sreq->cmd, mode))
+	if (blk_verify_command(q, sreq->cmd, mode))
 		return -EPERM;
 	return 0;
 }
@@ -159,7 +159,7 @@ static void bsg_scsi_free_rq(struct request *rq)
 	if (IS_ERR(rq))
 		return rq;
 
-	ret = q->bsg_dev.ops->fill_hdr(rq, hdr, mode);
+	ret = q->bsg_dev.ops->fill_hdr(q, rq, hdr, mode);
 	if (ret)
 		goto out;
 
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 533f4aee8567..5d577c89f9e6 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -34,11 +34,6 @@
 #include <scsi/scsi_ioctl.h>
 #include <scsi/scsi_cmnd.h>
 
-struct blk_cmd_filter {
-	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
-	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
-};
-
 static struct blk_cmd_filter blk_default_cmd_filter;
 
 /* Command group 3 is reserved and should never be used.  */
@@ -207,14 +202,18 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
 }
 
-int blk_verify_command(unsigned char *cmd, fmode_t mode)
+int blk_verify_command(struct request_queue *q, unsigned char *cmd,
+		       fmode_t mode)
 {
-	struct blk_cmd_filter *filter = &blk_default_cmd_filter;
-
+	struct blk_cmd_filter *filter = q->cmd_filter;
+	
 	/* root can do any command. */
 	if (capable(CAP_SYS_RAWIO))
 		return 0;
 
+	if (!filter)
+		filter = &blk_default_cmd_filter;
+
 	/* Anybody who can open the device can do a read-safe command */
 	if (test_bit(cmd[0], filter->read_ok))
 		return 0;
@@ -234,7 +233,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 
 	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(req->cmd, mode))
+	if (blk_verify_command(q, req->cmd, mode))
 		return -EPERM;
 
 	/*
@@ -468,7 +467,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = blk_verify_command(req->cmd, mode);
+	err = blk_verify_command(q, req->cmd, mode);
 	if (err)
 		goto error;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8a254bb46a9b..1b04016d3bb8 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -240,11 +240,12 @@ static int sg_check_file_access(struct file *filp, const char *caller)
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
 	struct sg_fd *sfp = filp->private_data;
+	struct scsi_device *device = sfp->parentdp->device;
 
-	if (sfp->parentdp->device->type == TYPE_SCANNER)
+	if (device->type == TYPE_SCANNER)
 		return 0;
 
-	return blk_verify_command(cmd, filp->f_mode);
+	return blk_verify_command(device->request_queue, cmd, filp->f_mode);
 }
 
 static int
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6980014357d4..df46a36c9467 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -352,6 +352,11 @@ struct blk_queue_tag {
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
+struct blk_cmd_filter {
+	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
+	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
+};
+
 /*
  * Zoned block device models (zoned limit).
  */
@@ -639,6 +644,7 @@ struct request_queue {
 	bsg_job_fn		*bsg_job_fn;
 	struct bsg_class_device bsg_dev;
 #endif
+	struct blk_cmd_filter	*cmd_filter;
 
 #ifdef CONFIG_BLK_DEV_THROTTLING
 	/* Throttle data */
@@ -1424,7 +1430,8 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 				    gfp_mask, 0);
 }
 
-extern int blk_verify_command(unsigned char *cmd, fmode_t mode);
+extern int blk_verify_command(struct request_queue *q, unsigned char *cmd,
+			      fmode_t mode);
 
 enum blk_default_limits {
 	BLK_MAX_SEGMENTS	= 128,
diff --git a/include/linux/bsg.h b/include/linux/bsg.h
index dac37b6e00ec..461ac68691b9 100644
--- a/include/linux/bsg.h
+++ b/include/linux/bsg.h
@@ -9,8 +9,8 @@
 #ifdef CONFIG_BLK_DEV_BSG
 struct bsg_ops {
 	int	(*check_proto)(struct sg_io_v4 *hdr);
-	int	(*fill_hdr)(struct request *rq, struct sg_io_v4 *hdr,
-				fmode_t mode);
+	int	(*fill_hdr)(struct request_queue *q, struct request *rq,
+			    struct sg_io_v4 *hdr, fmode_t mode);
 	int	(*complete_rq)(struct request *rq, struct sg_io_v4 *hdr);
 	void	(*free_rq)(struct request *rq);
 };
-- 
1.8.3.1
