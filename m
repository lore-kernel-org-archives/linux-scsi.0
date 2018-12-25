From: Kangjie Lu <kjlu@umn.edu>
Subject: [PATCH] scsi: avoid a double-fetch and a redundant copy
Date: Tue, 25 Dec 2018 16:47:18 -0600
Message-ID: <20181225224718.70271-1-kjlu@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: kjlu@umn.edu
Cc: pakki001@umn.edu, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

What we need is only "pack_id", so do not create a heap object or copy
the whole object in. The fix efficiently copies "pack_id" only.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 drivers/scsi/sg.c   |  4 ++--
 kernel/sched/core.c | 18 ++++++++++++------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 41774e4f9508..75842ceabc7f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -446,8 +446,8 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
 		}
 		if (old_hdr->reply_len < 0) {
 			if (count >= SZ_SG_IO_HDR) {
-				retval = get_user(req_pack_id,
-						&((sg_io_hdr_t *)buf->pack_id));
+				retval =
+					get_user(req_pack_id, &(sg_io_hdr_t __user *)buf->pack_id);
 				if (retval) {
 					retval = -EFAULT;
 					goto free_old_hdr;
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6fedf3a98581..0a55bdce9a42 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4447,7 +4447,7 @@ do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
  */
 static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *attr)
 {
-	u32 size;
+	u32 size, size_cp;
 	int ret;
 
 	if (!access_ok(VERIFY_WRITE, uattr, SCHED_ATTR_SIZE_VER0))
@@ -4460,15 +4460,17 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
 	if (ret)
 		return ret;
 
+	size_cp = size;
+
 	/* Bail out on silly large: */
 	if (size > PAGE_SIZE)
 		goto err_size;
 
 	/* ABI compatibility quirk: */
 	if (!size)
-		size = SCHED_ATTR_SIZE_VER0;
+		size_cp = SCHED_ATTR_SIZE_VER0;
 
-	if (size < SCHED_ATTR_SIZE_VER0)
+	else if (size < SCHED_ATTR_SIZE_VER0)
 		goto err_size;
 
 	/*
@@ -4483,7 +4485,7 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
 		unsigned char val;
 
 		addr = (void __user *)uattr + sizeof(*attr);
-		end  = (void __user *)uattr + size;
+		end  = (void __user *)uattr + size_cp;
 
 		for (; addr < end; addr++) {
 			ret = get_user(val, addr);
@@ -4492,13 +4494,17 @@ static int sched_copy_attr(struct sched_attr __user *uattr, struct sched_attr *a
 			if (val)
 				goto err_size;
 		}
-		size = sizeof(*attr);
+		size_cp = sizeof(*attr);
 	}
 
-	ret = copy_from_user(attr, uattr, size);
+	ret = copy_from_user(attr, uattr, size_cp);
 	if (ret)
 		return -EFAULT;
 
+	/* Sanity check if size was changed in user space */
+	if (attr->size != size)
+		return -EINVAL;
+
 	/*
 	 * XXX: Do we want to be lenient like existing syscalls; or do we want
 	 * to be strict and return an error on out-of-bounds values?
-- 
2.17.2 (Apple Git-113)
