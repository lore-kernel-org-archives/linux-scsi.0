From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 3/9] IB: add a helper to safely drain a QP
Date: Fri, 13 Nov 2015 10:16:04 -0600
Message-ID: <56460CC4.3030001@opengridcomputing.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447422410-20891-4-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 11/13/2015 7:46 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>   drivers/infiniband/core/cq.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
>   include/rdma/ib_verbs.h      |  2 ++
>   2 files changed, 48 insertions(+)
>
> diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
> index d9eb796..bf2a079 100644
> --- a/drivers/infiniband/core/cq.c
> +++ b/drivers/infiniband/core/cq.c
> @@ -206,3 +206,49 @@ void ib_free_cq(struct ib_cq *cq)
>   	WARN_ON_ONCE(ret);
>   }
>   EXPORT_SYMBOL(ib_free_cq);
> +
> +struct ib_stop_cqe {
> +	struct ib_cqe	cqe;
> +	struct completion done;
> +};
> +
> +static void ib_stop_done(struct ib_cq *cq, struct ib_wc *wc)
> +{
> +	struct ib_stop_cqe *stop =
> +		container_of(wc->wr_cqe, struct ib_stop_cqe, cqe);
> +
> +	complete(&stop->done);
> +}
> +
> +/*
> + * Change a queue pair into the error state and wait until all receive
> + * completions have been processed before destroying it. This avoids that
> + * the receive completion handler can access the queue pair while it is
> + * being destroyed.
> + */
> +void ib_drain_qp(struct ib_qp *qp)
> +{
> +	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> +	struct ib_stop_cqe stop = { };
> +	struct ib_recv_wr wr, *bad_wr;
> +	int ret;
> +
> +	wr.wr_cqe = &stop.cqe;
> +	stop.cqe.done = ib_stop_done;
> +	init_completion(&stop.done);
> +
> +	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = ib_post_recv(qp, &wr, &bad_wr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain QP: %d\n", ret);
> +		return;
> +	}
> +
> +	wait_for_completion(&stop.done);
> +}
> +EXPORT_SYMBOL(ib_drain_qp);

This won't work with iwarp qps.  Once the QP is in ERROR state, 
post_send/post_recv can return a synchronous error vs async via the 
cq.   The IB spec explicitly states that posts while in ERROR will be 
completed with "flushed" via the CQ.

>From http://tools.ietf.org/html/draft-hilland-rddp-verbs-00#section-6.2.4:

    *   At some point in the execution of the flushing operation, the RI
        MUST begin to return an Immediate Error for any attempt to post
        a WR to a Work Queue; prior to that point, any WQEs posted to a
        Work Queue MUST be enqueued and then flushed as described above
        (e.g. The PostSQ is done in Non-Privileged Mode and the Non-
        Privileged Mode portion of the RI has not yet been informed that
        the QP is in the Error state).


Also pending send work requests can be completed with status "flushed", 
and I would think we need to do something similar for send wrs.  We 
definitely can see this with cxgb4 in the presence of unsignaled wrs 
that aren't followed by a signaled wr at the time the QP is moved out of 
RTS.   The driver has no way to know if these pending unsignaled wrs 
completed or not.  So it completes them with "flushed" status.

So how can we do this for iwarp?  It seems like all that might be needed 
is to modify the QP state to idle, retrying until it succeeds:

    If the QP is transitioning to the Error state, or has not yet
    finished flushing the Work Queues, a Modify QP request to transition
    to the IDLE state MUST fail with an Immediate Error. If none of the
    prior conditions are true, a Modify QP to the Idle state MUST take
    the QP to the Idle state. No other state transitions out of Error
    are supported. Any attempt to transition the QP to a state other
    than Idle MUST result in an Immediate Error.


Steve.

> diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> index e11e038..f59a8d3 100644
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
> @@ -3075,4 +3075,6 @@ int ib_sg_to_pages(struct ib_mr *mr,
>   		   int sg_nents,
>   		   int (*set_page)(struct ib_mr *, u64));
>   
> +void ib_drain_qp(struct ib_qp *qp);
> +
>   #endif /* IB_VERBS_H */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
