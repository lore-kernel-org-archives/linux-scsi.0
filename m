From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] bsg: Fix sense buffer bug in SG_IO
Date: Tue, 20 Jan 2009 14:09:41 +0100
Message-ID: <20090120130941.GI30821@kernel.dk>
References: <4975CC4F.40006@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:16133 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbZATNLM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 08:11:12 -0500
Content-Disposition: inline
In-Reply-To: <4975CC4F.40006@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>

On Tue, Jan 20 2009, Boaz Harrosh wrote:
> 
> When submitting requests via SG_IO, which does a sync io, a
> bsg_command is not allocated, so an in-Kernel sense_buffer was not
> set. However when calling blk_execute_rq() with no sense buffer
> one is provided from the stack. Now bsg at blk_complete_sgv4_hdr_rq()
> would check if rq->sense_len and a sense was requested by sg_io_v4
> the rq->sense was copy_user() back, but by now it is already mangled
> stack memory.
> 
> I have fixed that by forcing a sense_buffer when calling bsg_map_hdr().
> The bsg_command->sense is provided in the write/read path like before,
> and on-the-stack buffer is provided when doing SG_IO.
> 
> I have also fixed a dprintk message to print rq->errors in hex because
> of the scsi bit-field use of this member. For other block devices it
> does not matter anyway.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Jens Axboe <jens.axboe@oracle.com>


> ---
>  block/bsg.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index d414bb5..0ce8806 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -244,7 +244,8 @@ bsg_validate_sgv4_hdr(struct request_queue *q, struct sg_io_v4 *hdr, int *rw)
>   * map sg_io_v4 to a request.
>   */
>  static struct request *
> -bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
> +bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
> +	    u8 *sense)
>  {
>  	struct request_queue *q = bd->queue;
>  	struct request *rq, *next_rq = NULL;
> @@ -306,6 +307,10 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
>  		if (ret)
>  			goto out;
>  	}
> +
> +	rq->sense = sense;
> +	rq->sense_len = 0;
> +
>  	return rq;
>  out:
>  	if (rq->cmd != rq->__cmd)
> @@ -348,9 +353,6 @@ static void bsg_rq_end_io(struct request *rq, int uptodate)
>  static void bsg_add_command(struct bsg_device *bd, struct request_queue *q,
>  			    struct bsg_command *bc, struct request *rq)
>  {
> -	rq->sense = bc->sense;
> -	rq->sense_len = 0;
> -
>  	/*
>  	 * add bc command to busy queue and submit rq for io
>  	 */
> @@ -419,7 +421,7 @@ static int blk_complete_sgv4_hdr_rq(struct request *rq, struct sg_io_v4 *hdr,
>  {
>  	int ret = 0;
>  
> -	dprintk("rq %p bio %p %u\n", rq, bio, rq->errors);
> +	dprintk("rq %p bio %p 0x%x\n", rq, bio, rq->errors);
>  	/*
>  	 * fill in all the output members
>  	 */
> @@ -635,7 +637,7 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
>  		/*
>  		 * get a request, fill in the blanks, and add to request queue
>  		 */
> -		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm);
> +		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm, bc->sense);
>  		if (IS_ERR(rq)) {
>  			ret = PTR_ERR(rq);
>  			rq = NULL;
> @@ -922,11 +924,12 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		struct request *rq;
>  		struct bio *bio, *bidi_bio = NULL;
>  		struct sg_io_v4 hdr;
> +		u8 sense[SCSI_SENSE_BUFFERSIZE];
>  
>  		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
>  			return -EFAULT;
>  
> -		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE);
> +		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE, sense);
>  		if (IS_ERR(rq))
>  			return PTR_ERR(rq);
>  
> -- 
> 1.6.0.1
> 

-- 
Jens Axboe

