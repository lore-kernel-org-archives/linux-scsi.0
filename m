From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 02/12] scsi/sg: move compat_ioctl handling into sg driver
Date: Mon, 16 Nov 2009 00:26:57 +0000
Message-ID: <1258331227-1694-3-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752877AbZKPA1m@vger.kernel.org>
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This moves the handling of SG_GET_REQUEST_TABLE from fs/compat_ioctl.c
into the sg driver, which is the only user.

There was no emulation for BLKTRACE so far in the sg driver, because
it does not get accessed through the block layer. Fix that by
adding emulation for BLKTRACESETUP and passthrough for the other
ioctls as well.

Since we're already touching the ioctl function, make it use
unlocked_ioctl now, to also push down the big kernel lock into
the driver.

BLKTRACESETUP32 emulation and the straight calling of compatible
ioctls apparently work fine now, but I could not find a test case
for SG_GET_REQUEST_TABLE in sg3-utils or elsewhere.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/sg.c       |  182 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/compat_ioctl.c       |   50 -------------
 kernel/trace/blktrace.c |    1 +
 3 files changed, 176 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 040f751..31a65cf 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -49,6 +49,7 @@ static int sg_version_num = 30534;	/* 2 digits for each component */
 #include <linux/delay.h>
 #include <linux/blktrace_api.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
@@ -757,9 +758,8 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	return 0;
 }
 
-static int
-sg_ioctl(struct inode *inode, struct file *filp,
-	 unsigned int cmd_in, unsigned long arg)
+static long
+sg_locked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
@@ -1078,27 +1078,195 @@ sg_ioctl(struct inode *inode, struct file *filp,
 	}
 }
 
+static long
+sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+{
+	int ret;
+	lock_kernel();
+	ret = sg_locked_ioctl(filp, cmd_in, arg);
+	unlock_kernel();
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
-static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+
+typedef struct sg_compat_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
+    char req_state;     /* 0 -> not used, 1 -> written, 2 -> ready to read */
+    char orphan;        /* 0 -> normal request, 1 -> from interruped SG_IO */
+    char sg_io_owned;   /* 0 -> complete with read(), 1 -> owned by SG_IO */
+    char problem;       /* 0 -> no problem detected, 1 -> error to report */
+    int pack_id;        /* pack_id associated with request */
+    compat_uptr_t usr_ptr; /* user provided pointer (in new interface) */
+    unsigned int duration; /* millisecs elapsed since written (req_state==1)
+			      or request duration (req_state==2) */
+    int unused;
+} sg_compat_req_info_t; /* 20 bytes long on i386 */
+#define SZ_SG_COMPAT_REQ_INFO sizeof(sg_compat_req_info_t)
+
+struct compat_blk_user_trace_setup {
+	char name[32];
+	u16 act_mask;
+	u32 buf_size;
+	u32 buf_nr;
+	compat_u64 start_lba;
+	compat_u64 end_lba;
+	u32 pid;
+};
+#define BLKTRACESETUP32 _IOWR(0x12, 115, struct compat_blk_user_trace_setup)
+
+static long sg_compat_locked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	Sg_device *sdp;
 	Sg_fd *sfp;
 	struct scsi_device *sdev;
+	void __user *p = compat_ptr(arg);
+	Sg_request *srp;
+	unsigned long iflags;
+	struct blk_user_trace_setup buts;
+	struct compat_blk_user_trace_setup cbuts;
+	int ret, val;
 
 	if ((!(sfp = (Sg_fd *) filp->private_data)) || (!(sdp = sfp->parentdp)))
 		return -ENXIO;
 
+	switch (cmd_in) {
+	/* SG_IO comes back after conversion on fs/compat_ioctl.c */
+	case SG_IO:
+		return -ENOIOCTLCMD;
+
+	/* These are all compatible */
+	case SG_SET_TIMEOUT:
+	case SG_GET_TIMEOUT:
+	case SG_SET_FORCE_LOW_DMA:
+	case SG_GET_LOW_DMA:
+	case SG_GET_SCSI_ID:
+	case SG_SET_FORCE_PACK_ID:
+	case SG_GET_PACK_ID:
+	case SG_GET_NUM_WAITING:
+	case SG_GET_SG_TABLESIZE:
+	case SG_SET_RESERVED_SIZE:
+	case SG_GET_RESERVED_SIZE:
+	case SG_SET_COMMAND_Q:
+	case SG_GET_COMMAND_Q:
+	case SG_SET_KEEP_ORPHAN:
+	case SG_GET_KEEP_ORPHAN:
+	case SG_NEXT_CMD_LEN:
+	case SG_GET_VERSION_NUM:
+	case SG_GET_ACCESS_COUNT:
+	case SG_EMULATED_HOST:
+	case SG_SCSI_RESET:
+	case SCSI_IOCTL_SEND_COMMAND:
+	case SG_SET_DEBUG:
+	case SCSI_IOCTL_GET_IDLUN:
+	case SCSI_IOCTL_GET_BUS_NUMBER:
+	case SCSI_IOCTL_PROBE_HOST:
+	case SG_GET_TRANSFORM:
+	case BLKSECTGET:
+	case BLKTRACESTART:
+	case BLKTRACESTOP:
+	case BLKTRACETEARDOWN:
+		return sg_locked_ioctl(filp, cmd_in,
+				(unsigned long)compat_ptr(arg));
+	}
+
+	SCSI_LOG_TIMEOUT(3, printk("sg_compat_ioctl: %s, cmd=0x%x\n",
+				   sdp->disk->disk_name, (int) cmd_in));
+
+	switch (cmd_in) {
+	case SG_GET_REQUEST_TABLE:
+		if (!access_ok(VERIFY_WRITE, p, SZ_SG_REQ_INFO * SG_MAX_QUEUE))
+			return -EFAULT;
+		else {
+			sg_compat_req_info_t *rinfo;
+			unsigned int ms;
+
+			rinfo = kmalloc(SZ_SG_COMPAT_REQ_INFO * SG_MAX_QUEUE,
+								GFP_KERNEL);
+			if (!rinfo)
+				return -ENOMEM;
+			read_lock_irqsave(&sfp->rq_list_lock, iflags);
+			for (srp = sfp->headrp, val = 0; val < SG_MAX_QUEUE;
+			     ++val, srp = srp ? srp->nextrp : srp) {
+				memset(&rinfo[val], 0, SZ_SG_COMPAT_REQ_INFO);
+				if (srp) {
+					rinfo[val].req_state = srp->done + 1;
+					rinfo[val].problem =
+					    srp->header.masked_status &
+					    srp->header.host_status &
+					    srp->header.driver_status;
+					if (srp->done)
+						rinfo[val].duration =
+							srp->header.duration;
+					else {
+						ms = jiffies_to_msecs(jiffies);
+						rinfo[val].duration =
+						    (ms > srp->header.duration) ?
+						    (ms - srp->header.duration) : 0;
+					}
+					rinfo[val].orphan = srp->orphan;
+					rinfo[val].sg_io_owned =
+							srp->sg_io_owned;
+					rinfo[val].pack_id =
+							srp->header.pack_id;
+					rinfo[val].usr_ptr = (compat_uptr_t)
+					   (unsigned long) srp->header.usr_ptr;
+				}
+			}
+			read_unlock_irqrestore(&sfp->rq_list_lock, iflags);
+			ret = __copy_to_user(p, rinfo,
+						SZ_SG_COMPAT_REQ_INFO * SG_MAX_QUEUE);
+			ret = ret ? -EFAULT : 0;
+			kfree(rinfo);
+			return ret;
+		}
+	case BLKTRACESETUP32:
+		if (copy_from_user(&cbuts, p, sizeof(cbuts)))
+			return -EFAULT;
+
+		buts = (struct blk_user_trace_setup) {
+			.act_mask = cbuts.act_mask,
+			.buf_size = cbuts.buf_size,
+			.buf_nr = cbuts.buf_nr,
+			.start_lba = cbuts.start_lba,
+			.end_lba = cbuts.end_lba,
+			.pid = cbuts.pid,
+		};
+		memcpy(&buts.name, &cbuts.name, 32);
+
+		ret = do_blk_trace_setup(sdp->device->request_queue,
+					       sdp->disk->disk_name,
+					       MKDEV(SCSI_GENERIC_MAJOR, sdp->index),
+					       NULL,
+					       &buts);
+		if (ret)
+			return ret;
+
+		if (copy_to_user(p, &buts.name, 32))
+			return -EFAULT;
+
+		return 0;
+	}
+
 	sdev = sdp->device;
-	if (sdev->host->hostt->compat_ioctl) { 
+	if (sdev->host->hostt->compat_ioctl) {
 		int ret;
 
 		ret = sdev->host->hostt->compat_ioctl(sdev, cmd_in, (void __user *)arg);
 
 		return ret;
 	}
-	
+
 	return -ENOIOCTLCMD;
 }
+
+static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+{
+	int ret;
+	lock_kernel();
+	ret = sg_compat_locked_ioctl(filp, cmd_in, arg);
+	unlock_kernel();
+	return ret;
+}
 #endif
 
 static unsigned int
@@ -1322,7 +1490,7 @@ static const struct file_operations sg_fops = {
 	.read = sg_read,
 	.write = sg_write,
 	.poll = sg_poll,
-	.ioctl = sg_ioctl,
+	.unlocked_ioctl = sg_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 716788f..219a117 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -380,39 +380,6 @@ static int sg_ioctl_trans(unsigned int fd, unsigned int cmd,
 	return err;
 }
 
-struct compat_sg_req_info { /* used by SG_GET_REQUEST_TABLE ioctl() */
-	char req_state;
-	char orphan;
-	char sg_io_owned;
-	char problem;
-	int pack_id;
-	compat_uptr_t usr_ptr;
-	unsigned int duration;
-	int unused;
-};
-
-static int sg_grt_trans(unsigned int fd, unsigned int cmd, struct
-			compat_sg_req_info __user *o)
-{
-	int err, i;
-	sg_req_info_t __user *r;
-	r = compat_alloc_user_space(sizeof(sg_req_info_t)*SG_MAX_QUEUE);
-	err = sys_ioctl(fd,cmd,(unsigned long)r);
-	if (err < 0)
-		return err;
-	for (i = 0; i < SG_MAX_QUEUE; i++) {
-		void __user *ptr;
-		int d;
-
-		if (copy_in_user(o + i, r + i, offsetof(sg_req_info_t, usr_ptr)) ||
-		    get_user(ptr, &r[i].usr_ptr) ||
-		    get_user(d, &r[i].duration) ||
-		    put_user((u32)(unsigned long)(ptr), &o[i].usr_ptr) ||
-		    put_user(d, &o[i].duration))
-			return -EFAULT;
-	}
-	return err;
-}
 #endif /* CONFIG_BLOCK */
 
 struct sock_fprog32 {
@@ -1159,25 +1126,12 @@ IGNORE_IOCTL(LOOP_CLR_FD)
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_EMULATED_HOST)
-COMPATIBLE_IOCTL(SG_GET_TRANSFORM)
 COMPATIBLE_IOCTL(SG_SET_RESERVED_SIZE)
 COMPATIBLE_IOCTL(SG_GET_RESERVED_SIZE)
-COMPATIBLE_IOCTL(SG_GET_SCSI_ID)
-COMPATIBLE_IOCTL(SG_SET_FORCE_LOW_DMA)
-COMPATIBLE_IOCTL(SG_GET_LOW_DMA)
-COMPATIBLE_IOCTL(SG_SET_FORCE_PACK_ID)
-COMPATIBLE_IOCTL(SG_GET_PACK_ID)
-COMPATIBLE_IOCTL(SG_GET_NUM_WAITING)
-COMPATIBLE_IOCTL(SG_SET_DEBUG)
-COMPATIBLE_IOCTL(SG_GET_SG_TABLESIZE)
 COMPATIBLE_IOCTL(SG_GET_COMMAND_Q)
 COMPATIBLE_IOCTL(SG_SET_COMMAND_Q)
 COMPATIBLE_IOCTL(SG_GET_VERSION_NUM)
-COMPATIBLE_IOCTL(SG_NEXT_CMD_LEN)
 COMPATIBLE_IOCTL(SG_SCSI_RESET)
-COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)
-COMPATIBLE_IOCTL(SG_SET_KEEP_ORPHAN)
-COMPATIBLE_IOCTL(SG_GET_KEEP_ORPHAN)
 #endif
 /* PPP stuff */
 COMPATIBLE_IOCTL(PPPIOCGFLAGS)
@@ -1685,8 +1639,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 #ifdef CONFIG_BLOCK
 	case SG_IO:
 		return sg_ioctl_trans(fd, cmd, argp);
-	case SG_GET_REQUEST_TABLE:
-		return sg_grt_trans(fd, cmd, argp);
 	case MTIOCGET32:
 	case MTIOCPOS32:
 		return mt_ioctl_trans(fd, cmd, argp);
@@ -1763,8 +1715,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 	case KDSKBMETA:
 	case KDSKBLED:
 	case KDSETLED:
-	/* SG stuff */
-	case SG_SET_TRANSFORM:
 	/* AUTOFS */
 	case AUTOFS_IOC_READY:
 	case AUTOFS_IOC_FAIL:
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index d9d6206..96bc047 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -524,6 +524,7 @@ err:
 	blk_trace_free(bt);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(do_blk_trace_setup);
 
 int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 		    struct block_device *bdev,
-- 
1.6.3.3
