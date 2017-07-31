From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 01/14] blk-mq-sched: fix scheduler bad performance
Date: Mon, 31 Jul 2017 23:00:24 +0000
Message-ID: <1501542023.2466.22.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-3-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:6956 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbdGaXBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jul 2017 19:01:12 -0400
In-Reply-To: <20170731165111.11536-3-ming.lei@redhat.com>
Content-Language: en-US
Content-ID: <C90B68C54049154D8D7AAA6CF540654C@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-08-01 at 00:50 +0800, Ming Lei wrote:
> When hw queue is busy, we shouldn't take requests from
> scheduler queue any more, otherwise IO merge will be
> difficult to do.
>=20
> This patch fixes the awful IO performance on some
> SCSI devices(lpfc, qla2xxx, ...) when mq-deadline/kyber
> is used by not taking requests if hw queue is busy.
>=20
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  block/blk-mq-sched.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
> index 4ab69435708c..47a25333a136 100644
> --- a/block/blk-mq-sched.c
> +++ b/block/blk-mq-sched.c
> @@ -94,7 +94,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ct=
x *hctx)
>  	struct request_queue *q =3D hctx->queue;
>  	struct elevator_queue *e =3D q->elevator;
>  	const bool has_sched_dispatch =3D e && e->type->ops.mq.dispatch_request=
;
> -	bool did_work =3D false;
> +	bool can_go =3D true;
>  	LIST_HEAD(rq_list);
> =20
>  	/* RCU or SRCU read lock is needed before checking quiesced flag */
> @@ -125,7 +125,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_=
ctx *hctx)
>  	 */
>  	if (!list_empty(&rq_list)) {
>  		blk_mq_sched_mark_restart_hctx(hctx);
> -		did_work =3D blk_mq_dispatch_rq_list(q, &rq_list);
> +		can_go =3D blk_mq_dispatch_rq_list(q, &rq_list);
>  	} else if (!has_sched_dispatch) {
>  		blk_mq_flush_busy_ctxs(hctx, &rq_list);
>  		blk_mq_dispatch_rq_list(q, &rq_list);
> @@ -136,7 +136,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_=
ctx *hctx)
>  	 * on the dispatch list, OR if we did have work but weren't able
>  	 * to make progress.
>  	 */
> -	if (!did_work && has_sched_dispatch) {
> +	if (can_go && has_sched_dispatch) {
>  		do {
>  			struct request *rq;

Hello Ming,

Please chose a better name for the new variable, e.g. "do_sched_dispatch".=
=20
Otherwise this patch looks fine to me. Hence:

Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Bart.=
