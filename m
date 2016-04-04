From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH 11/12] Stream Id: Use PID to seed Stream Id construction.
Date: Mon,  4 Apr 2016 12:06:15 +0700
Message-ID: <1459746376-27983-12-git-send-email-shaun@tancheff.com>
References: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:35472 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbcDDFHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 01:07:04 -0400
In-Reply-To: <1459746376-27983-1-git-send-email-shaun@tancheff.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-ide@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@fb.com>, Shaun Tancheff <shaun@tancheff.com>, Shaun Tancheff <shaun.tancheff@seagate.com>

Depends on:
https://lkml.kernel.org/r/1457107853-8689-1-git-send-email-axboe@fb.com

Use file open PID and inode's i_no to differentiate seed
generation streamid when fadvise is not supplied.

Effectivly attempting simulate the effect that stream id may have
on certain predictable workloads.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
 drivers/md/dm-zoned.c | 12 +++++++++++-
 fs/ext4/file.c        |  1 +
 fs/xfs/xfs_aops.c     |  2 +-
 fs/xfs/xfs_file.c     |  1 +
 include/linux/fs.h    | 10 ++++++++--
 5 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned.c b/drivers/md/dm-zoned.c
index 6cab33e..90da803 100644
--- a/drivers/md/dm-zoned.c
+++ b/drivers/md/dm-zoned.c
@@ -121,8 +121,18 @@ static inline u32 bio_stream(struct bio *bio)
 	 * use this heuristic to try to skip unnecessary co-mingling of data.
 	 */
 
-	if (bio->bi_rw & REQ_META)
+	if (bio->bi_rw & REQ_META) {
 		stream_id = 0xff;
+	} else {
+		unsigned int id = bio_get_streamid(bio);
+
+		/* high 8 bits is hash of PID, low 8 bits is hash of inode# */
+		stream_id = id >> 8;
+		if (stream_id == 0)
+			stream_id++;
+		if (stream_id == 0xff)
+			stream_id--;
+	}
 
 	return stream_id;
 }
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 4cd318f..1c5102c 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -340,6 +340,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
 	char buf[64], *cp;
 	int ret;
 
+	inode->pid = get_current()->pid;
 	if (unlikely(!(sbi->s_mount_flags & EXT4_MF_MNTDIR_SAMPLED) &&
 		     !(sb->s_flags & MS_RDONLY))) {
 		sbi->s_mount_flags |= EXT4_MF_MNTDIR_SAMPLED;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9a35e61..8f78de4 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -382,7 +382,7 @@ xfs_submit_ioend_bio(
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
-	bio_set_streamid(bio, ioend->io_inode->i_streamid);
+	bio_set_streamid(bio, inode_streamid(ioend->io_inode));
 	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
 }
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 52883ac..c38ea85 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1058,6 +1058,7 @@ xfs_file_open(
 		return -EFBIG;
 	if (XFS_FORCED_SHUTDOWN(XFS_M(inode->i_sb)))
 		return -EIO;
+	inode->pid = get_current()->pid;
 	return 0;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 10599d2..5d45e66 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -32,6 +32,7 @@
 #include <linux/workqueue.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/delayed_call.h>
+#include <linux/hash.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -678,15 +679,20 @@ struct inode {
 	__u32			i_fsnotify_mask; /* all events this inode cares about */
 	struct hlist_head	i_fsnotify_marks;
 #endif
+	pid_t			pid; /* use PID for fallback streamid */
 
 	void			*i_private; /* fs or device private pointer */
 };
 
 static inline unsigned int inode_streamid(struct inode *inode)
 {
-	if (inode)
-		return inode->i_streamid;
+	if (inode) {
+		if (inode->i_streamid)
+			return inode->i_streamid;
 
+		return ((hash_32(inode->pid, 8) << 8)
+			|hash_32(inode->i_ino, 8));
+	}
 	return 0;
 }
 
-- 
1.9.1

