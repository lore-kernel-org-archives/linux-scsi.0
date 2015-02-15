From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v2 1/2] [SCSI] sg: fix unkillable I/O wait deadlock with
 scsi-mq
Date: Sun, 15 Feb 2015 17:11:38 -0500
Message-ID: <54E1199A.2080508@interlog.com>
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

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>

> For inclusion in kernel 3.20.
>
> This is the exact same patch as before; I have only updated the patch
> description to reflect new details uncovered by myself and Douglas
> Gilbert.  There is also now a second related patch to sg that must be
> applied after this one.
>
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
