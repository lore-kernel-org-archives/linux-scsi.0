From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 05/10] block: convert to pos and nr_sectors accessors
Date: Wed, 29 Apr 2009 11:40:04 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0904291136160.3531@vixen.sonytel.be>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-6-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33960 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755061AbZD2JkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 05:40:11 -0400
In-Reply-To: <1240996428-10159-6-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com, Jeff Garzik <jgarzik@pobox.com>

On Wed, 29 Apr 2009, Tejun Heo wrote:
> With recent cleanups, there is no place where low level driver
> directly manipulates request fields.  This means that the 'hard'
> request fields always equal the !hard fields.  Convert all
> rq->sectors, nr_sectors and current_nr_sectors references to
> accessors.
>=20
> [ Impact: use pos and nr_sectors accessors ]
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

>  drivers/block/amiflop.c             |    6 ++--
>  drivers/block/ataflop.c             |   10 +++---
>  drivers/block/ps3disk.c             |    9 ++---
>  drivers/block/swim3.c               |   34 ++++++++++++----------
>  drivers/block/z2ram.c               |    6 ++--

Looks OK, so
Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
> index b66ad58..d4e6b71 100644
> --- a/drivers/block/z2ram.c
> +++ b/drivers/block/z2ram.c
> @@ -71,12 +71,12 @@ static void do_z2_request(struct request_queue *q=
)
>  {
>  	struct request *req;
>  	while ((req =3D elv_next_request(q)) !=3D NULL) {
> -		unsigned long start =3D req->sector << 9;
> -		unsigned long len  =3D req->current_nr_sectors << 9;
> +		unsigned long start =3D blk_rq_pos(req) << 9;
> +		unsigned long len  =3D blk_rq_cur_sectors(req) << 9;
                ^^^^^^^^^^^^^
I guess this one can become `unsigned int' now, as:

static inline unsigned int blk_rq_cur_sectors(struct request *rq)
{
	return blk_rq_cur_bytes(rq) >> 9;
}

and blk_rq_cur_bytes(rq) returns `int', so it must fit in an `int' anyw=
ay?

With kind regards,

Geert Uytterhoeven
Software Architect
Techsoft Centre

Technology and Software Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
