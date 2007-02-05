From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] bsg: convert bsg to use the generic ring buffer code
Date: Tue, 06 Feb 2007 08:54:08 +0900
Message-ID: <20070206085408U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:46528 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXBEXxX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2007 18:53:23 -0500
Received: from mfs34.rdh.ecl.ntt.co.jp (mfs34.rdh.ecl.ntt.co.jp [129.60.39.114])
	by tama55.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrMeb008261
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:22 +0900 (JST)
Received: from mfs34.rdh.ecl.ntt.co.jp (localhost [127.0.0.1])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id CED1420AE2A
	for <linux-scsi@vger.kernel.org>; Tue,  6 Feb 2007 08:53:21 +0900 (JST)
Received: from nttmail3.ecl.ntt.co.jp (nttmail3.ecl.ntt.co.jp [129.60.39.100])
	by mfs34.rdh.ecl.ntt.co.jp (Postfix) with ESMTP id A2ED620AE29
	for <linux-scsi@vger.kernel.org>; Tue,  6 Feb 2007 08:53:21 +0900 (JST)
Received: from dmailsv1.y.ecl.ntt.co.jp (dmailsv1.y.ecl.ntt.co.jp [129.60.53.14])
	by nttmail3.ecl.ntt.co.jp (8.13.8/8.13.8) with ESMTP id l15NrLiC029613
	for <linux-scsi@vger.kernel.org>; Tue, 6 Feb 2007 08:53:21 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This converts bsg to use the generic ring buffer code.

A new data structure, bsg_fd, is introduced to let each process to
have its own ring buffers (that is, several ring buffer pairs could be
attached to one bsg device).


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 block/bsg.c |  252 ++++++++++++++++++++++++++--------------------------------
 1 files changed, 113 insertions(+), 139 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index c85d961..1ce35d3 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -25,6 +25,8 @@ #include <linux/cdev.h>
 #include <linux/percpu.h>
 #include <linux/uio.h>
 #include <linux/bsg.h>
+#include <linux/eventchannel.h>
+#include <linux/eventchannel_if.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
@@ -51,6 +53,11 @@ struct bsg_device {
 	unsigned long flags;
 };
 
+struct bsg_fd {
+	struct bsg_device *bd;
+	struct ec_info *eci;
+};
+
 enum {
 	BSG_F_BLOCK		= 1,
 	BSG_F_WRITE_PERM	= 2,
@@ -418,7 +425,7 @@ static struct bsg_command *__bsg_get_don
 }
 
 static struct bsg_command *
-bsg_get_done_cmd(struct bsg_device *bd, const struct iovec *iov)
+bsg_get_done_cmd(struct bsg_device *bd)
 {
 	return __bsg_get_done_cmd(bd, TASK_INTERRUPTIBLE);
 }
@@ -519,46 +526,28 @@ static int bsg_complete_all_commands(str
 
 typedef struct bsg_command *(*bsg_command_callback)(struct bsg_device *bd, const struct iovec *iov);
 
-static ssize_t
-__bsg_read(char __user *buf, size_t count, bsg_command_callback get_bc,
-	   struct bsg_device *bd, const struct iovec *iov, ssize_t *bytes_read)
+static int bsg_send_response(struct file *file, char __user *buf)
 {
+	struct bsg_fd *bf = file->private_data;
+	struct bsg_device *bd = bf->bd;
 	struct bsg_command *bc;
-	int nr_commands, ret;
-
-	if (count % sizeof(struct sg_io_v4))
-		return -EINVAL;
-
-	ret = 0;
-	nr_commands = count / sizeof(struct sg_io_v4);
-	while (nr_commands) {
-		bc = get_bc(bd, iov);
-		if (IS_ERR(bc)) {
-			ret = PTR_ERR(bc);
-			break;
-		}
-
-		/*
-		 * this is the only case where we need to copy data back
-		 * after completing the request. so do that here,
-		 * bsg_complete_work() cannot do that for us
-		 */
-		ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
-
-		if (copy_to_user(buf, (char *) &bc->hdr, sizeof(bc->hdr)))
-			ret = -EFAULT;
+	int ret;
 
-		bsg_free_command(bc);
+	bc = bsg_get_done_cmd(bd);
+	if (IS_ERR(bc))
+		return 1;
 
-		if (ret)
-			break;
+	/*
+	 * this is the only case where we need to copy data back
+	 * after completing the request. so do that here,
+	 * bsg_complete_work() cannot do that for us
+	 */
+	ret = blk_complete_sgv4_hdr_rq(bc->rq, &bc->hdr, bc->bio);
 
-		buf += sizeof(struct sg_io_v4);
-		*bytes_read += sizeof(struct sg_io_v4);
-		nr_commands--;
-	}
+	ret = copy_to_user(buf, (char *) &bc->hdr, sizeof(bc->hdr));
 
-	return ret;
+	bsg_free_command(bc);
+	return 0;
 }
 
 static inline void bsg_set_block(struct bsg_device *bd, struct file *file)
@@ -585,107 +574,59 @@ static inline int err_block_err(int ret)
 	return 0;
 }
 
-static ssize_t
-bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+static int bsg_prepare_send_response(struct file *file)
 {
-	struct bsg_device *bd = file->private_data;
-	int ret;
-	ssize_t bytes_read;
+	struct bsg_fd *bf = file->private_data;
+	struct bsg_device *bd = bf->bd;
 
-	dprintk("%s: read %Zd bytes\n", bd->name, count);
+	dprintk("%s: read\n", bd->name);
 
 	bsg_set_block(bd, file);
-	bytes_read = 0;
-	ret = __bsg_read(buf, count, bsg_get_done_cmd,
-			bd, NULL, &bytes_read);
-	*ppos = bytes_read;
-
-	if (!bytes_read || (bytes_read && err_block_err(ret)))
-		bytes_read = ret;
-
-	return bytes_read;
+	return 0;
 }
 
-static ssize_t __bsg_write(struct bsg_device *bd, const char __user *buf,
-			   size_t count, ssize_t *bytes_read)
+static int bsg_recv_request(struct file *file, char __user *buf)
 {
+	struct bsg_fd *bf = file->private_data;
+	struct bsg_device *bd = bf->bd;
 	struct bsg_command *bc;
 	struct request *rq;
-	int ret, nr_commands;
-
-	if (count % sizeof(struct sg_io_v4))
-		return -EINVAL;
-
-	nr_commands = count / sizeof(struct sg_io_v4);
-	rq = NULL;
-	bc = NULL;
-	ret = 0;
-	while (nr_commands) {
-		request_queue_t *q = bd->queue;
+	request_queue_t *q = bd->queue;
 
-		bc = bsg_get_command(bd);
-		if (!bc)
-			break;
-		if (IS_ERR(bc)) {
-			ret = PTR_ERR(bc);
-			bc = NULL;
-			break;
-		}
+	bc = bsg_get_command(bd);
+	if (!bc)
+		return ENOMEM;
 
-		bc->uhdr = (struct sg_io_v4 __user *) buf;
-		if (copy_from_user(&bc->hdr, buf, sizeof(bc->hdr))) {
-			ret = -EFAULT;
-			break;
-		}
+	if (IS_ERR(bc))
+		return PTR_ERR(bc);
 
-		/*
-		 * get a request, fill in the blanks, and add to request queue
-		 */
-		rq = bsg_map_hdr(bd, &bc->hdr);
-		if (IS_ERR(rq)) {
-			ret = PTR_ERR(rq);
-			rq = NULL;
-			break;
-		}
-
-		bsg_add_command(bd, q, bc, rq);
-		bc = NULL;
-		rq = NULL;
-		nr_commands--;
-		buf += sizeof(struct sg_io_v4);
-		*bytes_read += sizeof(struct sg_io_v4);
+	bc->uhdr = (struct sg_io_v4 __user *) buf;
+	if (copy_from_user(&bc->hdr, buf, sizeof(bc->hdr))) {
+		bsg_free_command(bc);
+		return EFAULT;
 	}
 
-	if (bc)
+	rq = bsg_map_hdr(bd, &bc->hdr);
+	if (IS_ERR(rq)) {
 		bsg_free_command(bc);
+		return PTR_ERR(rq);
+	}
 
-	return ret;
+	bsg_add_command(bd, q, bc, rq);
+
+	return 0;
 }
 
-static ssize_t
-bsg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
+static int bsg_prepare_recv_request(struct file *file)
 {
-	struct bsg_device *bd = file->private_data;
-	ssize_t bytes_read;
-	int ret;
+	struct bsg_fd *bf = file->private_data;
+	struct bsg_device *bd = bf->bd;
 
-	dprintk("%s: write %Zd bytes\n", bd->name, count);
+	dprintk("%s write\n", bd->name);
 
 	bsg_set_block(bd, file);
 	bsg_set_write_perm(bd, file);
-
-	bytes_read = 0;
-	ret = __bsg_write(bd, buf, count, &bytes_read);
-	*ppos = bytes_read;
-
-	/*
-	 * return bytes written on non-fatal errors
-	 */
-	if (!bytes_read || (bytes_read && err_block_err(ret)))
-		bytes_read = ret;
-
-	dprintk("%s: returning %Zd\n", bd->name, bytes_read);
-	return bytes_read;
+	return 0;
 }
 
 static struct bsg_device *bsg_alloc_device(void)
@@ -822,46 +763,42 @@ static struct bsg_device *bsg_get_device
 
 static int bsg_open(struct inode *inode, struct file *file)
 {
-	struct bsg_device *bd = bsg_get_device(inode, file);
+	struct bsg_device *bd;
+	struct bsg_fd *bf;
+
+	bf = kzalloc(sizeof(*bf), GFP_KERNEL);
+	if (!bf)
+		return -ENOMEM;
 
-	if (IS_ERR(bd))
+	bd = bsg_get_device(inode, file);
+	if (IS_ERR(bd)) {
+		kfree(bf);
 		return PTR_ERR(bd);
+	}
 
-	file->private_data = bd;
+	bf->bd = bd;
+	file->private_data = bf;
 	return 0;
 }
 
 static int bsg_release(struct inode *inode, struct file *file)
 {
-	struct bsg_device *bd = file->private_data;
+	struct bsg_fd *bf = file->private_data;
+	struct bsg_device *bd = bf->bd;
 
 	file->private_data = NULL;
+	if (bf->eci)
+		ec_info_free(bf->eci);
+	kfree(bf);
 	return bsg_put_device(bd);
 }
 
-static unsigned int bsg_poll(struct file *file, poll_table *wait)
-{
-	struct bsg_device *bd = file->private_data;
-	unsigned int mask = 0;
-
-	poll_wait(file, &bd->wq_done, wait);
-	poll_wait(file, &bd->wq_free, wait);
-
-	spin_lock_irq(&bd->lock);
-	if (!list_empty(&bd->done_list))
-		mask |= POLLIN | POLLRDNORM;
-	if (bd->queued_cmds >= bd->max_queue)
-		mask |= POLLOUT;
-	spin_unlock_irq(&bd->lock);
-
-	return mask;
-}
-
 static int
 bsg_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	  unsigned long arg)
 {
-	struct bsg_device *bd = file->private_data;
+	struct bsg_fd *bf = file->private_data;
+	struct bsg_device *bd = bf->bd;
 	int __user *uarg = (int __user *) arg;
 
 	if (!bd)
@@ -936,9 +873,6 @@ #endif
 }
 
 static struct file_operations bsg_fops = {
-	.read		=	bsg_read,
-	.write		=	bsg_write,
-	.poll		=	bsg_poll,
 	.open		=	bsg_open,
 	.release	=	bsg_release,
 	.ioctl		=	bsg_ioctl,
@@ -997,10 +931,50 @@ err:
 	return -ENOMEM;
 }
 
+static int bsg_ec_init(struct file *file, struct ec_ring __user *kupring,
+		       struct ec_ring __user *ukpring, unsigned int num,
+		       unsigned int flags)
+{
+	struct bsg_fd *bf = file->private_data;
+	struct bsg_device *bd = bf->bd;
+	struct ec_info *eci;
+
+	if (bf->eci)
+		return -EINVAL;
+
+	eci = ec_info_alloc(kupring, &bd->wq_done, &bd->done_cmds,
+			    ukpring, NULL, NULL,
+			    num, flags);
+	if (!eci)
+		return -ENOMEM;
+
+	bf->eci = eci;
+	return 0;
+}
+
+static struct ec_info *bsg_file_to_ecinfo(struct file *file)
+{
+	return ((struct bsg_fd *) (file->private_data))->eci;
+}
+
+static struct ec_operations bsg_ec_ops = {
+	.ec_init			=	bsg_ec_init,
+	.file_to_ecinfo			=	bsg_file_to_ecinfo,
+	.prepare_send_event_to_user	=	bsg_prepare_send_response,
+	.send_event_to_user		=	bsg_send_response,
+	.prepare_recv_event_from_user	=	bsg_prepare_recv_request,
+	.recv_event_from_user		=	bsg_recv_request,
+};
+
 static int __init bsg_init(void)
 {
 	int ret, i;
 
+	ret = ec_register(EC_TYPE_BSG, sizeof(struct sg_io_v4), &bsg_ec_ops,
+			  &bsg_fops);
+	if (ret)
+		return -EINVAL;
+
 	bsg_cmd_cachep = kmem_cache_create("bsg_cmd",
 				sizeof(struct bsg_command), 0, 0, NULL, NULL);
 	if (!bsg_cmd_cachep) {
-- 
1.4.3.2

