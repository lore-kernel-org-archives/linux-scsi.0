From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [RFC PATCH 1/4] block: add back queue-private command filter
Date: Mon, 27 May 2013 15:50:19 +0200
Message-ID: <1369662622-5959-2-git-send-email-pbonzini@redhat.com>
References: <1369662622-5959-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1369662622-5959-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org, msnitzer@redhat.com, ksievers@redhat.com, jbottomley@parallels.com, axboe@kernel.dk, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The command filter used to be mutable via sysfs, but this was broken
and backed out.  Let's add it back.  This patch adds the infrastructure
for filtering, but unlike the old code this one just adds a pointer to
request_queue, so as to make it cheaper in the majority of cases where
no special filtering is desired.

This is a partial (and massaged) revert of commit 018e044 (block: get
rid of queue-private command filter, 2009-06-26).

Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 block/blk-sysfs.c      |  2 ++
 block/bsg.c            |  2 +-
 block/scsi_ioctl.c     | 17 +++++------------
 drivers/scsi/sg.c      |  4 +++-
 include/linux/blkdev.h | 10 +++++++++-
 5 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 5efc5a6..2539f8d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -530,6 +530,8 @@ static void blk_release_queue(struct kobject *kobj)
 
 	blkcg_exit_queue(q);
 
+	kfree(q->cmd_filter);
+
 	if (q->elevator) {
 		spin_lock_irq(q->queue_lock);
 		ioc_clear_queue(q);
diff --git a/block/bsg.c b/block/bsg.c
index 420a5a9..fe16cae 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -187,7 +187,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 		return -EFAULT;
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_verify_command(rq->cmd, has_write_perm))
+		if (blk_verify_command(q->cmd_filter, rq->cmd, has_write_perm))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a5ffcc9..22b925f 100644
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
@@ -197,17 +192,15 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
 }
 
-int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
+int blk_verify_command(struct blk_cmd_filter *filter,
+		       unsigned char *cmd, fmode_t has_write_perm)
 {
-	struct blk_cmd_filter *filter = &blk_default_cmd_filter;
-
 	/* root can do any command. */
 	if (capable(CAP_SYS_RAWIO))
 		return 0;
 
-	/* if there's no filter set, assume we're filtering everything out */
 	if (!filter)
-		return -EPERM;
+		filter = &blk_default_cmd_filter;
 
 	/* Anybody who can open the device can do a read-safe command */
 	if (test_bit(cmd[0], filter->read_ok))
@@ -226,7 +219,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 {
 	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, mode & FMODE_WRITE))
+	if (blk_verify_command(q->cmd_filter, rq->cmd, mode & FMODE_WRITE))
 		return -EPERM;
 
 	/*
@@ -473,7 +466,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = blk_verify_command(rq->cmd, mode & FMODE_WRITE);
+	err = blk_verify_command(q->cmd_filter, rq->cmd, mode & FMODE_WRITE);
 	if (err)
 		goto error;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index df5e961..5f64202 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -218,11 +218,13 @@ static void sg_put_dev(Sg_device *sdp);
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
 	struct sg_fd *sfp = filp->private_data;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
 
 	if (sfp->parentdp->device->type == TYPE_SCANNER)
 		return 0;
 
-	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
+	return blk_verify_command(q->cmd_filter,
+				  cmd, filp->f_mode & FMODE_WRITE);
 }
 
 static int get_exclude(Sg_device *sdp)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2fdb4a4..9a8434d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -259,6 +259,11 @@ struct blk_queue_tag {
 #define BLK_SCSI_MAX_CMDS	(256)
 #define BLK_SCSI_CMD_PER_LONG	(BLK_SCSI_MAX_CMDS / (sizeof(long) * 8))
 
+struct blk_cmd_filter {
+	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
+	unsigned long write_ok[BLK_SCSI_CMD_PER_LONG];
+};
+
 struct queue_limits {
 	unsigned long		bounce_pfn;
 	unsigned long		seg_boundary_mask;
@@ -437,6 +442,8 @@ struct request_queue {
 	struct bsg_class_device bsg_dev;
 #endif
 
+	struct blk_cmd_filter	*cmd_filter;
+
 #ifdef CONFIG_BLK_CGROUP
 	struct list_head	all_q_node;
 #endif
@@ -1089,7 +1096,8 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 				    gfp_mask);
 }
 
-extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
+extern int blk_verify_command(struct blk_cmd_filter *filter,
+			      unsigned char *cmd, fmode_t has_write_perm);
 
 enum blk_default_limits {
 	BLK_MAX_SEGMENTS	= 128,
-- 
1.8.1.4
