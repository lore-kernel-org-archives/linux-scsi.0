From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 05/15] dm: remove incomple BLOCK_PC support
Date: Wed, 11 Jan 2017 20:09:37 -0500
Message-ID: <20170112010936.GA19953@redhat.com>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484060780-15592-6-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 10 2017 at 10:06am -0500,
Christoph Hellwig <hch@lst.de> wrote:

> DM tries to copy a few fields around for BLOCK_PC requests, but given
> that no dm-target ever wires up scsi_cmd_ioctl BLOCK_PC can't actually
> be sent to dm.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-rq.c | 16 ----------------
>  1 file changed, 16 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 93f6e9f..3f12916 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -270,19 +270,6 @@ static void dm_end_request(struct request *clone, int error)
>  	struct mapped_device *md = tio->md;
>  	struct request *rq = tio->orig;
>  
> -	if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
> -		rq->errors = clone->errors;
> -		rq->resid_len = clone->resid_len;
> -
> -		if (rq->sense)
> -			/*
> -			 * We are using the sense buffer of the original
> -			 * request.
> -			 * So setting the length of the sense data is enough.
> -			 */
> -			rq->sense_len = clone->sense_len;
> -	}
> -
>  	free_rq_clone(clone);
>  	rq_end_stats(md, rq);
>  	if (!rq->q->mq_ops)
> @@ -511,9 +498,6 @@ static int setup_clone(struct request *clone, struct request *rq,
>  	if (r)
>  		return r;
>  
> -	clone->cmd = rq->cmd;
> -	clone->cmd_len = rq->cmd_len;
> -	clone->sense = rq->sense;
>  	clone->end_io = end_clone_request;
>  	clone->end_io_data = tio;
>  

I'm not following your reasoning.

dm_blk_ioctl calls __blkdev_driver_ioctl and will call scsi_cmd_ioctl
(sd_ioctl -> scsi_cmd_blk_ioctl -> scsi_cmd_ioctl) if DM's underlying
block device is a scsi device.
