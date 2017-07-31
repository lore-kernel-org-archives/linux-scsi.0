From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Mon, 31 Jul 2017 23:34:35 +0000
Message-ID: <1501544074.2466.29.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-6-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170731165111.11536-6-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <E2A17CBE08DAE9489C4F3563AEC02452@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2017-08-01 at 00:51 +0800, Ming Lei wrote:
> SCSI devices use host-wide tagset, and the shared
> driver tag space is often quite big. Meantime
> there is also queue depth for each lun(.cmd_per_lun),
> which is often small.
>=20
> So lots of requests may stay in sw queue, and we
> always flush all belonging to same hw queue and
> dispatch them all to driver, unfortunately it is
> easy to cause queue busy becasue of the small
> per-lun queue depth. Once these requests are flushed
> out, they have to stay in hctx->dispatch, and no bio
> merge can participate into these requests, and
> sequential IO performance is hurted.
>=20
> This patch improves dispatching from sw queue when
> there is per-request-queue queue depth by taking
> request one by one from sw queue, just like the way
> of IO scheduler.
>=20
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-sched.c | 25 +++++++++++++++----------
>  1 file changed, 15 insertions(+), 10 deletions(-)
>=20
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 47a25333a136..3510c01cb17b 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -96,6 +96,9 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ct=
x *hctx)
>  	const bool has_sched_dispatch =3D e && e->type->ops.mq.dispatch_request=
;
>  	bool can_go =3D true;
>  	LIST_HEAD(rq_list);
> +	struct request *(*dispatch_fn)(struct blk_mq_hw_ctx *) =3D
> +		has_sched_dispatch ? e->type->ops.mq.dispatch_request :
> +			blk_mq_dispatch_rq_from_ctxs;
> =20
>  	/* RCU or SRCU read lock is needed before checking quiesced flag */
>  	if (unlikely(blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)))
> @@ -126,26 +129,28 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_h=
w_ctx *hctx)
>  	if (!list_empty(&rq_list)) {
>  		blk_mq_sched_mark_restart_hctx(hctx);
>  		can_go =3D blk_mq_dispatch_rq_list(q, &rq_list);
> -	} else if (!has_sched_dispatch) {
> +	} else if (!has_sched_dispatch && !q->queue_depth) {
>  		blk_mq_flush_busy_ctxs(hctx, &rq_list);
>  		blk_mq_dispatch_rq_list(q, &rq_list);
> +		can_go =3D false;
>  	}
> =20
> +	if (!can_go)
> +		return;
> +
>  	/*
>  	 * We want to dispatch from the scheduler if we had no work left
>  	 * on the dispatch list, OR if we did have work but weren't able
>  	 * to make progress.
>  	 */
> -	if (can_go && has_sched_dispatch) {
> -		do {
> -			struct request *rq;
> +	do {
> +		struct request *rq;
> =20
> -			rq =3D e->type->ops.mq.dispatch_request(hctx);
> -			if (!rq)
> -				break;
> -			list_add(&rq->queuelist, &rq_list);
> -		} while (blk_mq_dispatch_rq_list(q, &rq_list));
> -	}
> +		rq =3D dispatch_fn(hctx);
> +		if (!rq)
> +			break;
> +		list_add(&rq->queuelist, &rq_list);
> +	} while (blk_mq_dispatch_rq_list(q, &rq_list));
>  }

Hello Ming,

Although I like the idea behind this patch, I'm afraid that this patch will
cause a performance regression for high-performance SCSI LLD drivers, e.g.
ib_srp. Have you considered to rework this patch as follows:
* Remove the code under "else if (!has_sched_dispatch && !q->queue_depth) {=
".
* Modify all blk_mq_dispatch_rq_list() functions such that these dispatch u=
p
  to cmd_per_lun - (number of requests in progress) at once.

Thanks,

Bart.=
