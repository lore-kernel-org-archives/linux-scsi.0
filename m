From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 42/42] target/file: Alloc iov[] off the stack
Date: Tue, 31 May 2011 03:59:14 -0700
Message-ID: <1306839554.8193.190.camel@haakon2.linux-iscsi.org>
References: <1306523240-15543-1-git-send-email-agrover@redhat.com>
	 <1306523240-15543-43-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51707 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1EaLHi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2011 07:07:38 -0400
In-Reply-To: <1306523240-15543-43-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: target-devel <target-devel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2011-05-27 at 12:07 -0700, Andy Grover wrote:
> Apparently C supports variable arrays on the stack now, pretty sweet.
> Perfect for the iovec array.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---

So as Christoph mentioned, this is really not safe to do for all cases..

What about something along the lines of the following..?  Christoph, is
there a smarter way to determine when *_onstack() should be getting
called..?

Thanks,

--nab

--------------------------------------------------------------------

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 5c47f42..f437c51 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -284,23 +284,16 @@ fd_alloc_task(struct se_cmd *cmd)
        return &fd_req->fd_task;
 }
 
-static int fd_do_readv(struct se_task *task)
+static int __fd_do_readv(struct se_task *task, struct iovec *iov)
 {
        struct fd_request *req = FILE_REQ(task);
        struct file *fd = req->fd_dev->fd_file;
        struct scatterlist *sg = task->task_sg;
-       struct iovec *iov;
        mm_segment_t old_fs;
        loff_t pos = (task->task_lba *
                      task->se_dev->se_sub_dev->se_dev_attrib.block_size);
        int ret = 0, i;
 
-       iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
-       if (!(iov)) {
-               printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
-               return -ENOMEM;
-       }
-
        for (i = 0; i < task->task_sg_num; i++) {
                iov[i].iov_len = sg[i].length;
                iov[i].iov_base = sg_virt(&sg[i]);
@@ -310,8 +303,6 @@ static int fd_do_readv(struct se_task *task)
        set_fs(get_ds());
        ret = vfs_readv(fd, &iov[0], task->task_sg_num, &pos);
        set_fs(old_fs);
-
-       kfree(iov);
        /*
         * Return zeros and GOOD status even if the READ did not return
         * the expected virt_size for struct file w/o a backing struct
@@ -335,23 +326,39 @@ static int fd_do_readv(struct se_task *task)
        return 1;
 }
 
-static int fd_do_writev(struct se_task *task)
+static int fd_do_readv_onstack(struct se_task *task)
+{
+       struct iovec iov[task->task_sg_num];
+
+       return __fd_do_readv(task, &iov[0]);
+}
+
+static int fd_do_readv_offstack(struct se_task *task)
+{
+       struct iovec *iov;
+       int ret;
+
+       iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
+       if (!iov) {
+               printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
+               return -ENOMEM;
+       }
+
+       ret = __fd_do_readv(task, iov);
+       kfree(iov);
+       return ret;
+}
+
+static int __fd_do_writev(struct se_task *task, struct iovec *iov)
 {
        struct fd_request *req = FILE_REQ(task);
        struct file *fd = req->fd_dev->fd_file;
        struct scatterlist *sg = task->task_sg;
-       struct iovec *iov;
        mm_segment_t old_fs;
        loff_t pos = (task->task_lba *
                      task->se_dev->se_sub_dev->se_dev_attrib.block_size);
        int ret, i = 0;
 
-       iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
-       if (!(iov)) {
-               printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
-               return -ENOMEM;
-       }
-
        for (i = 0; i < task->task_sg_num; i++) {
                iov[i].iov_len = sg[i].length;
                iov[i].iov_base = sg_virt(&sg[i]);
@@ -362,8 +369,6 @@ static int fd_do_writev(struct se_task *task)
        ret = vfs_writev(fd, &iov[0], task->task_sg_num, &pos);
        set_fs(old_fs);
 
-       kfree(iov);
-
        if (ret < 0 || ret != task->task_size) {
                printk(KERN_ERR "vfs_writev() returned %d\n", ret);
                return (ret < 0 ? ret : -EINVAL);
@@ -372,6 +377,29 @@ static int fd_do_writev(struct se_task *task)
        return 1;
 }
 
+static int fd_do_writev_onstack(struct se_task *task)
+{
+       struct iovec iov[task->task_sg_num];
+
+       return __fd_do_writev(task, &iov[0]);
+}
+
+static int fd_do_writev_offstack(struct se_task *task)
+{
+       struct iovec *iov;
+       int ret;
+
+       iov = kzalloc(sizeof(struct iovec) * task->task_sg_num, GFP_KERNEL);
+       if (!iov) {
+               printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
+               return -ENOMEM;
+       }
+
+       ret = __fd_do_writev(task, iov);
+       kfree(iov);
+       return ret;
+}
+
 static void fd_emulate_sync_cache(struct se_task *task)
 {
        struct se_cmd *cmd = task->task_se_cmd;
@@ -461,6 +489,7 @@ static int fd_do_task(struct se_task *task)
 {
        struct se_cmd *cmd = task->task_se_cmd;
        struct se_device *dev = cmd->se_dev;
+       u32 iovec_bytes = task->task_sg_num * sizeof(struct iovec);
        int ret = 0;
 
        /*
@@ -468,9 +497,15 @@ static int fd_do_task(struct se_task *task)
         * physical memory addresses to struct iovec virtual memory.
         */
        if (task->task_data_direction == DMA_FROM_DEVICE) {
-               ret = fd_do_readv(task);
+               if (iovec_bytes < (THREAD_SIZE / 2))
+                       ret = fd_do_readv_onstack(task);
+               else
+                       ret = fd_do_readv_offstack(task);
        } else {
-               ret = fd_do_writev(task);
+               if (iovec_bytes < (THREAD_SIZE / 2))
+                       ret = fd_do_writev_onstack(task);
+               else
+                       ret = fd_do_writev_offstack(task);
 
                if (ret > 0 &&
                    dev->se_sub_dev->se_dev_attrib.emulate_write_cache > 0 &&




