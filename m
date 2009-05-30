From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH block#for-2.6.31] block: fix an oops on BLKPREP_KILL
Date: Sat, 30 May 2009 06:41:37 +0200
Message-ID: <20090530044137.GM11363@kernel.dk>
References: <1243635503.2919.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:53755 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbZE3Elg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 May 2009 00:41:36 -0400
Content-Disposition: inline
In-Reply-To: <1243635503.2919.67.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Tejun Heo <htejun@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>

On Fri, May 29 2009, James Bottomley wrote:
> Doing a bit of torture testing, I ran across a BUG in the block
> subsystem (at blk-core.c:2048): the test for if the request is queued.
> 
> It turns out the trigger was a BLKPREP_KILL coming out of the SCSI prep
> function.  Currently for BLKPREP_KILL requests, we send them straight
> into __blk_end_request_all() with an error, but they've never been
> dequeued, so they trip the bug.  Fix this by starting requests before
> killing them.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> 
> ---
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 8b3b74e..9a0568c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1789,6 +1789,7 @@ struct request *blk_peek_request(struct request_queue *q)
>  			break;
>  		} else if (ret == BLKPREP_KILL) {
>  			rq->cmd_flags |= REQ_QUIET;
> +			blk_start_request(rq);
>  			__blk_end_request_all(rq, -EIO);
>  		} else {
>  			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);

Given how illogical that now looks, I think it could do with a comment.
I'll add that while applying.

-- 
Jens Axboe

