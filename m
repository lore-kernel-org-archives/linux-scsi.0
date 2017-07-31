From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 05/14] blk-mq-sched: don't dequeue request until all in
 ->dispatch are flushed
Date: Mon, 31 Jul 2017 23:42:21 +0000
Message-ID: <1501544540.2466.31.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-7-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31641 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdGaXnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2017 19:43:09 -0400
In-Reply-To: <20170731165111.11536-7-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <C1205417C018144D8DB167927EF1427E@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-08-01 at 00:51 +0800, Ming Lei wrote:
> During dispatch, we moved all requests from hctx->dispatch to
> one temporary list, then dispatch them one by one from this list.
> Unfortunately duirng this period, run queue from other contexts
> may think the queue is idle and start to dequeue from sw/scheduler
> queue and try to dispatch because ->dispatch is empty.
>=20
> This way will hurt sequential I/O performance because requests are
> dequeued when queue is busy.
>=20
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-sched.c   | 24 ++++++++++++++++++------
>  include/linux/blk-mq.h |  1 +
>  2 files changed, 19 insertions(+), 6 deletions(-)
>=20
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 3510c01cb17b..eb638063673f 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -112,8 +112,15 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw=
_ctx *hctx)
>  	 */
>  	if (!list_empty_careful(&hctx->dispatch)) {
>  		spin_lock(&hctx->lock);
> -		if (!list_empty(&hctx->dispatch))
> +		if (!list_empty(&hctx->dispatch)) {
>  			list_splice_init(&hctx->dispatch, &rq_list);
> +
> +			/*
> +			 * BUSY won't be cleared until all requests
> +			 * in hctx->dispatch are dispatched successfully
> +			 */
> +			set_bit(BLK_MQ_S_BUSY, &hctx->state);
> +		}
>  		spin_unlock(&hctx->lock);
>  	}
> =20
> @@ -129,15 +136,20 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_h=
w_ctx *hctx)
>  	if (!list_empty(&rq_list)) {
>  		blk_mq_sched_mark_restart_hctx(hctx);
>  		can_go =3D blk_mq_dispatch_rq_list(q, &rq_list);
> -	} else if (!has_sched_dispatch && !q->queue_depth) {
> -		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> -		blk_mq_dispatch_rq_list(q, &rq_list);
> -		can_go =3D false;
> +		if (can_go)
> +			clear_bit(BLK_MQ_S_BUSY, &hctx->state);
>  	}
> =20
> -	if (!can_go)
> +	/* can't go until ->dispatch is flushed */
> +	if (!can_go || test_bit(BLK_MQ_S_BUSY, &hctx->state))
>  		return;
> =20
> +	if (!has_sched_dispatch && !q->queue_depth) {
> +		blk_mq_flush_busy_ctxs(hctx, &rq_list);
> +		blk_mq_dispatch_rq_list(q, &rq_list);
> +		return;
> +	}

Hello Ming,

Since setting, clearing and testing of BLK_MQ_S_BUSY can happen concurrentl=
y
and since clearing and testing happens without any locks held I'm afraid th=
is
patch introduces the following race conditions:
* Clearing of BLK_MQ_S_BUSY immediately after this bit has been set, result=
ing
  in this bit not being set although there are requests on the dispatch lis=
t.
* Checking BLK_MQ_S_BUSY after requests have been added to the dispatch lis=
t
  but before that bit is set, resulting in test_bit(BLK_MQ_S_BUSY, &hctx->s=
tate)
  reporting that the BLK_MQ_S_BUSY has not been set although there are requ=
ests
  on the dispatch list.
* Checking BLK_MQ_S_BUSY after requests have been removed from the dispatch=
 list
  but before that bit is cleared, resulting in test_bit(BLK_MQ_S_BUSY, &hct=
x->state)
  reporting that the BLK_MQ_S_BUSY
has been set although there are no requests
  on the dispatch list.

Bart.=
