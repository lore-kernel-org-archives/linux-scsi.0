From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 1/2] sg_io: pass request_queue to blk_verify_command
Date: Tue, 13 Nov 2012 18:25:12 +0100
Message-ID: <1352827513-29890-2-git-send-email-pbonzini@redhat.com>
References: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352827513-29890-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Ric Wheeler <rwheeler@redhat.com>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Adjust the blk_verify_command function to let it look at per-queue
data.  This will be done in the next patch.

Cc: linux-scsi@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Ric Wheeler <rwheeler@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v2->v3: separated from "block: add back queue-private command filter"

 block/bsg.c            |    2 +-
 block/scsi_ioctl.c     |    7 ++++---
 drivers/scsi/sg.c      |    3 ++-
 include/linux/blkdev.h |    3 ++-
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index ff64ae3..eb5ad59 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -187,7 +187,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
 		return -EFAULT;
 
 	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
-		if (blk_verify_command(rq->cmd, has_write_perm))
+		if (blk_verify_command(q, rq->cmd, has_write_perm))
 			return -EPERM;
 	} else if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 9a87daa..a737562 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -196,7 +196,8 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
 	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
 }
 
-int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
+int blk_verify_command(struct request_queue *q,
+		       unsigned char *cmd, fmode_t has_write_perm)
 {
 	struct blk_cmd_filter *filter = &blk_default_cmd_filter;
 
@@ -225,7 +226,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
 {
 	if (copy_from_user(rq->cmd, hdr->cmdp, hdr->cmd_len))
 		return -EFAULT;
-	if (blk_verify_command(rq->cmd, mode & FMODE_WRITE))
+	if (blk_verify_command(q, rq->cmd, mode & FMODE_WRITE))
 		return -EPERM;
 
 	/*
@@ -472,7 +473,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
 		goto error;
 
-	err = blk_verify_command(rq->cmd, mode & FMODE_WRITE);
+	err = blk_verify_command(q, rq->cmd, mode & FMODE_WRITE);
 	if (err)
 		goto error;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index be2c9a6..cab816f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -217,11 +217,12 @@ static void sg_put_dev(Sg_device *sdp);
 static int sg_allow_access(struct file *filp, unsigned char *cmd)
 {
 	struct sg_fd *sfp = filp->private_data;
+	struct request_queue *q = sfp->parentdp->device->request_queue;
 
 	if (sfp->parentdp->device->type == TYPE_SCANNER)
 		return 0;
 
-	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
+	return blk_verify_command(q, cmd, filp->f_mode & FMODE_WRITE);
 }
 
 static int get_exclude(Sg_device *sdp)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1756001..69a5e55 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1053,7 +1053,8 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
 				    gfp_mask);
 }
 
-extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
+extern int blk_verify_command(struct request_queue *q,
+			      unsigned char *cmd, fmode_t has_write_perm);
 
 enum blk_default_limits {
 	BLK_MAX_SEGMENTS	= 128,
-- 
1.7.4.1
