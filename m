From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 4/6] block: use blk_rq_init() to initialize the request
Date: Sun, 27 Apr 2008 14:41:41 +0300
Message-ID: <48146675.5050801@panasas.com>
References: <1209140607-28654-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1209140607-28654-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1209140607-28654-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1209140607-28654-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1209140607-28654-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1209140607-28654-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-ide-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org, bzolnier@gmail.com, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 25 2008 at 19:23 +0300, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> Any path needs to call it to initialize the request.
> 
> This is a preparation for large command support, which needs to
> initialize the request in a proper way (that is, just doing a memset()
> will not work).
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Jens Axboe <jens.axboe@oracle.com>

Please, if not to late, add:
Cc: Boaz Harrosh <bharrosh@panasas.com>

> ---
>  drivers/block/nbd.c       |    1 +
>  drivers/block/paride/pd.c |    4 +---
>  drivers/scsi/scsi_error.c |    1 +
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 60cc543..f75bda1 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -537,6 +537,7 @@ static int nbd_ioctl(struct inode *inode, struct file *file,
>  	switch (cmd) {
>  	case NBD_DISCONNECT:
>  	        printk(KERN_INFO "%s: NBD_DISCONNECT\n", lo->disk->disk_name);
> +		blk_rq_init(NULL, &sreq);
>  		sreq.cmd_type = REQ_TYPE_SPECIAL;
>  		nbd_cmd(&sreq) = NBD_CMD_DISC;
>  		/*
> diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
> index df819f8..570f3b7 100644
> --- a/drivers/block/paride/pd.c
> +++ b/drivers/block/paride/pd.c
> @@ -716,10 +716,8 @@ static int pd_special_command(struct pd_unit *disk,
>  	struct request rq;
>  	int err = 0;
>  
> -	memset(&rq, 0, sizeof(rq));
> -	rq.errors = 0;
> +	blk_rq_init(NULL, &rq);
>  	rq.rq_disk = disk->gd;
> -	rq.ref_count = 1;
>  	rq.end_io_data = &wait;
>  	rq.end_io = blk_end_sync_rq;
>  	blk_insert_request(disk->gd->queue, &rq, 0, func);
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 221f31e..1eaba6c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1771,6 +1771,7 @@ scsi_reset_provider(struct scsi_device *dev, int flag)
>  	unsigned long flags;
>  	int rtn;
>  
> +	blk_rq_init(NULL, &req);
>  	scmd->request = &req;
>  	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
>  

