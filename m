From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH] tcm/fileio: Convert to iov allocations for fd_do_readv()
 and fd_do_writev()
Date: Wed, 22 Sep 2010 13:26:14 +0200
Message-ID: <4C99E7D6.1040004@gmail.com>
References: <1285142558-13219-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56023 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0IVL0U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Sep 2010 07:26:20 -0400
In-Reply-To: <1285142558-13219-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Fubo Chen <fubo.chen@gmail.com>

On 09/22/2010 10:02 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Greetings all,
> 
> This patch converts target_core_file.c fd_do_readv() and fd_do_writev() code to
> use dynamic allocation for *iov[] instead of local scope static memory to
> properly handle cases with TCM_Loop that can potentially exceed the 8K stack
> on 64-bit kernels with per 1:1 struct scatterlist <-> 512-byte block_size SGL length
> mapping up to the current FD_MAX_SECTORS=1024.  For more information please see:
> 
> http://lkml.org/lkml/2010/9/22/42
> 
> Many thanks to Fubo Chen for spotting this one!
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_file.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 221b41e..93d3f63 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -476,12 +476,16 @@ static int fd_do_readv(struct fd_request *req, struct se_task *task)
>  {
>  	struct file *fd = req->fd_dev->fd_file;
>  	struct scatterlist *sg = task->task_sg;
> -	struct iovec iov[req->fd_sg_count];
> +	struct iovec *iov;
>  	mm_segment_t old_fs;
>  	loff_t pos = (req->fd_lba * DEV_ATTRIB(task->se_dev)->block_size);
>  	int ret = 0, i;
>  
> -	memset(iov, 0, sizeof(struct iovec) * req->fd_sg_count);
> +	iov = kzalloc(sizeof(struct iovec) * req->fd_sg_count, GFP_KERNEL);

A kzalloc allocation bigger then PAG_SIZE is very unstable, more so when
the system is up for a long time.

Better prepare to loop here, up to PAG_SIZE iov at a time.

Boaz

> +	if (!(iov)) {
> +		printk(KERN_ERR "Unable to allocate fd_do_readv iov[]\n");
> +		return -1;
> +	}
>  
>  	for (i = 0; i < req->fd_sg_count; i++) {
>  		iov[i].iov_len = sg[i].length;
> @@ -492,6 +496,8 @@ static int fd_do_readv(struct fd_request *req, struct se_task *task)
>  	set_fs(get_ds());
>  	ret = vfs_readv(fd, &iov[0], req->fd_sg_count, &pos);
>  	set_fs(old_fs);
> +
> +	kfree(iov);
>  	/*
>  	 * Return zeros and GOOD status even if the READ did not return
>  	 * the expected virt_size for struct file w/o a backing struct
> @@ -583,12 +589,16 @@ static int fd_do_writev(struct fd_request *req, struct se_task *task)
>  {
>  	struct file *fd = req->fd_dev->fd_file;
>  	struct scatterlist *sg = task->task_sg;
> -	struct iovec iov[req->fd_sg_count];
> +	struct iovec *iov;
>  	mm_segment_t old_fs;
>  	loff_t pos = (req->fd_lba * DEV_ATTRIB(task->se_dev)->block_size);
>  	int ret, i = 0;
>  
> -	memset(iov, 0, sizeof(struct iovec) * req->fd_sg_count);
> +	iov = kzalloc(sizeof(struct iovec) * req->fd_sg_count, GFP_KERNEL);
> +	if (!(iov)) {
> +		printk(KERN_ERR "Unable to allocate fd_do_writev iov[]\n");
> +		return -1;
> +	}
>  
>  	for (i = 0; i < req->fd_sg_count; i++) {
>  		iov[i].iov_len = sg[i].length;
> @@ -600,6 +610,8 @@ static int fd_do_writev(struct fd_request *req, struct se_task *task)
>  	ret = vfs_writev(fd, &iov[0], req->fd_sg_count, &pos);
>  	set_fs(old_fs);
>  
> +	kfree(iov);
> +
>  	if (ret < 0 || ret != req->fd_size) {
>  		printk(KERN_ERR "vfs_writev() returned %d\n", ret);
>  		return -1;

