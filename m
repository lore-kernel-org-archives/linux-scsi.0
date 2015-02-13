From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 1/2] [SCSI] sg: fix unkillable I/O wait deadlock with
 scsi-mq
Date: Fri, 13 Feb 2015 12:55:32 -0500
Message-ID: <54DE3A94.9060305@interlog.com>
References: <54DE2FD8.8000901@cybernetics.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54DE2FD8.8000901@cybernetics.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15-02-13 12:09 PM, Tony Battersby wrote:
> When using the write()/read() interface for submitting commands, the
> SCSI generic driver does not call blk_put_request() on a completed SCSI
> command until userspace calls read() to get the command completion.
> Since scsi-mq uses a fixed number of preallocated requests, this makes
> it possible for userspace to exhaust the entire preallocated supply of
> requests.  For places in the kernel that call blk_get_request() with
> GFP_KERNEL, this can cause the calling process to deadlock in a
> permanent unkillable I/O wait in blk_get_request() -> ... -> bt_get().
> For places in the kernel that call blk_get_request() with GFP_ATOMIC,
> this can cause blk_get_request() always to return -EWOULDBLOCK.  Note
> that these problems happen only if scsi-mq is enabled.  Prevent the
> problems by calling blk_put_request() as soon as the SCSI command
> completes instead of waiting for userspace to call read().
>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: <stable@vger.kernel.org> # 3.17+
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
>
> For inclusion in kernel 3.20.
>
> This is the exact same patch as before; I have only updated the patch
> description to reflect new details uncovered by myself and Douglas
> Gilbert.  There is also now a second related patch to sg that must be
> applied after this one.

I agree with this patch but since it is a significant
change I intend to do more testing. The follow-up patch
changes the call to blk_get_request() to use GFP_KERNEL.
I note that that GFP_* setting has ping-ponged several
times.


However I suspect the real problem is with the mq code
which for all devices on a scsi host enforces:
     sum_of_all(outstanding_requests) <= can_queue

The non-mq code does not do that, it left the scsi
mid level to handle the host_busy case. With the new
mq restriction the host_busy case has been pushed
up the stack, spilling into the user space as
unexpected EAGAINs in the sg and bsg pass-throughs.
That new restriction is causing problems with USB mass
storage (non-UASP) where can_queue==1. Those problems
are already being reported to this list and do not
seem to directly involve the sg or bsg drivers.

Suggestions anybody?

Doug Gilbert


BTW If there are block layer requests not directly associated
with SCSI commands (fadvise() ?), then isn't the USB host case:
     sum_of_all(outstanding_requests) <= 1
during a USB copy almost guaranteed to throw off nuisance
EAGAINs, as is being observed?

> --- linux-3.19.0/drivers/scsi/sg.c.orig	2015-02-08 21:54:22.000000000 -0500
> +++ linux-3.19.0/drivers/scsi/sg.c	2015-02-09 17:40:00.000000000 -0500
> @@ -1350,6 +1350,17 @@ sg_rq_end_io(struct request *rq, int upt
>   	}
>   	/* Rely on write phase to clean out srp status values, so no "else" */
>
> +	/*
> +	 * Free the request as soon as it is complete so that its resources
> +	 * can be reused without waiting for userspace to read() the
> +	 * result.  But keep the associated bio (if any) around until
> +	 * blk_rq_unmap_user() can be called from user context.
> +	 */
> +	srp->rq = NULL;
> +	if (rq->cmd != rq->__cmd)
> +		kfree(rq->cmd);
> +	__blk_put_request(rq->q, rq);
> +
>   	write_lock_irqsave(&sfp->rq_list_lock, iflags);
>   	if (unlikely(srp->orphan)) {
>   		if (sfp->keep_orphan)
> @@ -1777,10 +1788,10 @@ sg_finish_rem_req(Sg_request *srp)
>   	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
>   				      "sg_finish_rem_req: res_used=%d\n",
>   				      (int) srp->res_used));
> +	if (srp->bio)
> +		ret = blk_rq_unmap_user(srp->bio);
> +
>   	if (srp->rq) {
> -		if (srp->bio)
> -			ret = blk_rq_unmap_user(srp->bio);
> -
>   		if (srp->rq->cmd != srp->rq->__cmd)
>   			kfree(srp->rq->cmd);
>   		blk_put_request(srp->rq);
>
> --
