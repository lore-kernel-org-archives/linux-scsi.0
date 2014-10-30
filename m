From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3 11/11] IB/srp: Fix a race condition triggered by destroying
 a queue pair
Date: Thu, 30 Oct 2014 16:26:03 +0200
Message-ID: <54524A7B.3060708@dev.mellanox.co.il>
References: <545240AE.6060009@acm.org> <5452420B.2070206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5452420B.2070206-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/30/2014 3:50 PM, Bart Van Assche wrote:
> At least LID reassignment can trigger a race condition in the SRP
> initiator driver, namely the receive completion handler trying to
> post a request on a QP during or after QP destruction and before
> the CQ's have been destroyed. Avoid this race by modifying a QP
> into the error state and by waiting until all receive completions
> have been processed before destroying a QP.
>
> Reported-by: Max Gurtuvoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>   drivers/infiniband/ulp/srp/ib_srp.c | 59 +++++++++++++++++++++++++++++++------
>   drivers/infiniband/ulp/srp/ib_srp.h |  2 ++
>   2 files changed, 52 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
> index c8b84a2..d3a5abe 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -453,6 +453,41 @@ static struct srp_fr_pool *srp_alloc_fr_pool(struct srp_target_port *target)
>   				  dev->max_pages_per_mr);
>   }
>
> +/**
> + * srp_destroy_qp() - destroy an RDMA queue pair
> + * @ch: SRP RDMA channel.
> + *
> + * Change a queue pair into the error state and wait until all receive
> + * completions have been processed before destroying it. This avoids that
> + * the receive completion handler can access the queue pair while it is
> + * being destroyed.
> + */
> +static void srp_destroy_qp(struct srp_rdma_ch *ch)
> +{
> +	struct srp_target_port *target = ch->target;
> +	static struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> +	static struct ib_recv_wr wr = { .wr_id = SRP_LAST_WR_ID };
> +	struct ib_recv_wr *bad_wr;
> +	int ret;
> +
> +	/* Destroying a QP and reusing ch->done is only safe if not connected */
> +	WARN_ON_ONCE(target->connected);

I thought we agreed that cannot happen. I guess I don't mind keeping
it... BTW, were you able to reproduce this race as well?

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
