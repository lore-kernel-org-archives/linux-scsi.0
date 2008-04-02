From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] block: fix barrier error transmission
Date: Wed, 2 Apr 2008 21:08:28 +0200
Message-ID: <20080402190827.GJ12774@kernel.dk>
References: <1207159348.3082.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:15773 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756071AbYDBTIf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Apr 2008 15:08:35 -0400
Content-Disposition: inline
In-Reply-To: <1207159348.3082.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, mtosatti@redhat.com

On Wed, Apr 02 2008, James Bottomley wrote:
> There's a problem with barriers in SCSI.  They're prepared as a
> SYNCHRONIZE_CACHE REQ_TYPE_BLOCK_PC command.  However, our processing
> model dictates that we always return no block error but set req->errors
> to the SCSI result.  The upshot is that if we get an error on a flush
> barrier, it's never seen by the block layer.
> 
> This patch attempts to get the block layer to see such errors.  Note,
> it's still not quite right.  There are possible sense errors that could
> indicate success of the command (like deferred errors) that this will
> treat as failures.  I suppose we could process the sense in scsi and try
> to return a first pass error even for REQ_TYPE_BLOCK_PC ... I'm just not
> sure what that will do to the other users.
> 
> James
> 
> ---
> 
> diff --git a/block/blk-barrier.c b/block/blk-barrier.c
> index 55c5f1f..3a3947c 100644
> --- a/block/blk-barrier.c
> +++ b/block/blk-barrier.c
> @@ -114,18 +114,24 @@ void blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
>  
>  static void pre_flush_end_io(struct request *rq, int error)
>  {
> +	error = rq->errors ? -EIO : error;
> +
>  	elv_completed_request(rq->q, rq);
>  	blk_ordered_complete_seq(rq->q, QUEUE_ORDSEQ_PREFLUSH, error);
>  }

It's a bit of a hack, SCSI really should pass the error value back
instead of fiddling around with possibly perhaps finding it in ->errors.
And please don't use these ?: constructs, in this case it doesn't even
make a lot of sense and a

        if (rq->errors)
                error = -EIO;

would have been much cleaner ;-)

So my question is why does the model not allow you to return the error
properly?

-- 
Jens Axboe

