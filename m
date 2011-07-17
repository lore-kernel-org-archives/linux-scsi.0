From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 20/20] target: change alloc_task call to take *cdb, not
	*cmd
Date: Sun, 17 Jul 2011 13:04:55 -0700
Message-ID: <1310933095.26130.42.camel@haakon2.linux-iscsi.org>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
	 <1310174329-22228-21-git-send-email-agrover@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48843 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754887Ab1GQUOG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jul 2011 16:14:06 -0400
In-Reply-To: <1310174329-22228-21-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2011-07-08 at 18:18 -0700, Andy Grover wrote:
> The transports really don't need the entire struct se_cmd to allocate
> the memory for the se_task. If it wasn't for pscsi, they wouldn't even
> need the *cdb.
> 
> Modify pscsi to allocate space for cdb at the end of pscsi_plugin_task,
> instead of a separate allocation.
> 
> Signed-off-by: Andy Grover <agrover@redhat.com>
> ---
>  drivers/target/target_core_file.c      |    8 ++----
>  drivers/target/target_core_file.h      |    2 -
>  drivers/target/target_core_iblock.c    |    3 +-
>  drivers/target/target_core_iblock.h    |    1 -
>  drivers/target/target_core_pscsi.c     |   33 +++++--------------------------
>  drivers/target/target_core_pscsi.h     |    3 +-
>  drivers/target/target_core_rd.c        |    7 ++---
>  drivers/target/target_core_rd.h        |    2 -
>  drivers/target/target_core_transport.c |    2 +-
>  include/target/target_core_transport.h |    2 +-
>  10 files changed, 16 insertions(+), 47 deletions(-)
> 
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 60ee94e..272d9bd 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -257,7 +257,7 @@ static inline struct fd_request *FILE_REQ(struct se_task *task)
>  
> 
>  static struct se_task *
> -fd_alloc_task(struct se_cmd *cmd)
> +fd_alloc_task(unsigned char *cdb)
>  {
>  	struct fd_request *fd_req;
>  
> @@ -267,15 +267,13 @@ fd_alloc_task(struct se_cmd *cmd)
>  		return NULL;
>  	}
>  
> -	fd_req->fd_dev = cmd->se_dev->dev_ptr;
> -
>  	return &fd_req->fd_task;
>  }
>  
>  static int fd_do_readv(struct se_task *task)
>  {
>  	struct fd_request *req = FILE_REQ(task);
> -	struct file *fd = req->fd_dev->fd_file;
> +	struct file *fd = req->fd_task.se_dev->dev_ptr;
>  	struct scatterlist *sg = task->task_sg;
>  	struct iovec *iov;
>  	mm_segment_t old_fs;
> @@ -326,7 +324,7 @@ static int fd_do_readv(struct se_task *task)
>  static int fd_do_writev(struct se_task *task)
>  {
>  	struct fd_request *req = FILE_REQ(task);
> -	struct file *fd = req->fd_dev->fd_file;
> +	struct file *fd = req->fd_task.se_dev->dev_ptr;
>  	struct scatterlist *sg = task->task_sg;
>  	struct iovec *iov;
>  	mm_segment_t old_fs;

Bogus assignments of *fd here..  Fixed up via rebase in the original
commit:

commit a0c6b9c4397f541e0b01bfffcaf49de0a42a9f42
Author: Andy Grover <agrover@redhat.com>
Date:   Fri Jul 8 16:46:30 2011 -0700

    target: change alloc_task call to take *cdb, not *cmd


--nab


