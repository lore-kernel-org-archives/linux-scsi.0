From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 2/3] block: Separate zone requests from medium access
 requests
Date: Tue, 28 Feb 2017 16:57:22 +0000
Message-ID: <1488301028.2370.7.camel@sandisk.com>
References: <20170228102535.15966-1-damien.lemoal@wdc.com>
         <20170228102535.15966-3-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:8433 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751030AbdB1REF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 12:04:05 -0500
In-Reply-To: <20170228102535.15966-3-damien.lemoal@wdc.com>
Content-Language: en-US
Content-ID: <403EEA777FF4C34CA8039C4DD69E918E@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Damien Le Moal <Damien.LeMoal@wdc.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>, "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>

On Tue, 2017-02-28 at 19:25 +0900, Damien Le Moal wrote:
> From: Bart Van Assche <bart.vanassche@sandisk.com>
>=20
> Use blk_rq_accesses_medium() instead of !blk_rq_is_passthrough() to
> ensure that code that is intended for normal medium access requests,
> e.g. DISCARD, READ and WRITE requests, is not applied to
> REQ_OP_ZONE_REPORT requests nor to REQ_OP_ZONE_RESET requests.
> This allows excluding these zone requests from request accounting
> and from request scheduling.
>=20
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

Hello Damien,

Since you posted this patch you should have added your Signed-off-by. And
since you have edited this patch, you should have documented what you have
changed.

>  static inline void req_set_nomerge(struct request_queue *q, struct reque=
st *req)
> diff --git a/block/elevator.c b/block/elevator.c
> index 699d10f..cbf81c6 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -635,16 +635,20 @@ void __elv_add_request(struct request_queue *q, str=
uct request *rq, int where)
> =20
>  	rq->q =3D q;
> =20
> -	if (rq->rq_flags & RQF_SOFTBARRIER) {
> +	if (!blk_rq_accesses_medium(rq)) {
> +		/* Do not schedule zone requests */
> +		where =3D ELEVATOR_INSERT_FRONT;
> +	} if (rq->rq_flags & RQF_SOFTBARRIER) {

This change was not in the patch I sent to you. Additionally, this change
doesn't look properly formatted. Please make sure that the second "if" star=
ts
on a new line.

>  		}
>  	} else if (!(rq->rq_flags & RQF_ELVPRIV) &&
>  		    (where =3D=3D ELEVATOR_INSERT_SORT ||
> -		     where =3D=3D ELEVATOR_INSERT_SORT_MERGE))
> +		     where =3D=3D ELEVATOR_INSERT_SORT_MERGE)) {
>  		where =3D ELEVATOR_INSERT_BACK;
> +	}

This change wasn't in my patch either. Since this change only adds a pair o=
f
braces, can it be left out?

Thanks,

Bart.=
