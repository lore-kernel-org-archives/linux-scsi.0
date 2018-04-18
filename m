From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCH] blk-mq: Clear out elevator private data
Date: Wed, 18 Apr 2018 10:47:17 +0200
Message-ID: <D8B8B059-149B-4A7D-8537-31052A51AAD1@linaro.org>
References: <20180417214218.GA44753@beast>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417214218.GA44753@beast>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Oleksandr Natalenko <oleksandr@natalenko.name>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Bart Van Assche <bart.vanassche@wdc.com>, David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



> Il giorno 17 apr 2018, alle ore 23:42, Kees Cook =
<keescook@chromium.org> ha scritto:
>=20
> Some elevators may not correctly check rq->rq_flags & RQF_ELVPRIV, and
> may attempt to read rq->elv fields. When requests got reused, this
> caused BFQ to think it already had a bfqq (rq->elv.priv[1]) allocated.

Hi Kees,
where does BFQ gets confused and operates on a request not destined to
it?  I'm asking because I paid attention to always avoid such a
mistake.

Thanks,
Paolo

> This could lead to odd behaviors like having the sense buffer address
> slowly start incrementing. This eventually tripped HARDENED_USERCOPY
> and KASAN.
>=20
> This patch wipes all of rq->elv instead of just rq->elv.icq. While
> it shouldn't technically be needed, this ends up being a robustness
> improvement that should lead to at least finding bugs in elevators =
faster.
>=20
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Fixes: bd166ef183c26 ("blk-mq-sched: add framework for MQ capable IO =
schedulers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> In theory, BFQ needs to also check the RQF_ELVPRIV flag, but I'll =
leave that
> to Paolo to figure out. Also, my Fixes line is kind of a best-guess. =
This
> is where icq was originally wiped, so it seemed as good a commit as =
any.
> ---
> block/blk-mq.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 0dc9e341c2a7..859df3160303 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -363,7 +363,7 @@ static struct request *blk_mq_get_request(struct =
request_queue *q,
>=20
> 	rq =3D blk_mq_rq_ctx_init(data, tag, op);
> 	if (!op_is_flush(op)) {
> -		rq->elv.icq =3D NULL;
> +		memset(&rq->elv, 0, sizeof(rq->elv));
> 		if (e && e->type->ops.mq.prepare_request) {
> 			if (e->type->icq_cache && rq_ioc(bio))
> 				blk_mq_sched_assign_ioc(rq, bio);
> @@ -461,7 +461,7 @@ void blk_mq_free_request(struct request *rq)
> 			e->type->ops.mq.finish_request(rq);
> 		if (rq->elv.icq) {
> 			put_io_context(rq->elv.icq->ioc);
> -			rq->elv.icq =3D NULL;
> +			memset(&rq->elv, 0, sizeof(rq->elv));
> 		}
> 	}
>=20
> --=20
> 2.7.4
>=20
>=20
> --=20
> Kees Cook
> Pixel Security
