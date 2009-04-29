From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 04/10] block: implement blk_rq_pos/[cur_]sectors() and
 convert obvious ones
Date: Wed, 29 Apr 2009 11:25:32 +0200 (CEST)
Message-ID: <alpine.LRH.2.00.0904291123440.31700@vixen.sonytel.be>
References: <1240996428-10159-1-git-send-email-tj@kernel.org> <1240996428-10159-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:44258 "EHLO
	pophost.sonytel.be" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750795AbZD2JZj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 05:25:39 -0400
In-Reply-To: <1240996428-10159-5-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, chirag.kantharia@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, jesper.juhl@gmail.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, David Woodhouse <dwmw2@infradead.org>, schwidefsky@de.ibm.com, ballabio_dario@emc.com, "David S. Miller" <davem@davemloft.net>, Paul Russell <rusty@rustcorp.com.au>, Markus.Lidel@shadowconnect.com, bharrosh@panasas.com

On Wed, 29 Apr 2009, Tejun Heo wrote:
> Implement accessors - blk_rq_pos(), blk_rq_sectors() and
> blk_rq_cur_sectors() which return rq->sector, rq->hard_nr_sectors and
> rq->hard_cur_sectors respectively and convert direct references of th=
e
> said fields to the accessors.
>=20
> This is in preparation of request data length handling cleanup.
>=20
> [ Impact: cleanup ]
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

>  drivers/block/ps3disk.c         |    2 +-

Acked-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -832,13 +832,30 @@ static inline void blk_run_address_space(struct=
 address_space *mapping)
>  extern void blkdev_dequeue_request(struct request *req);
> =20
>  /*
> - * blk_end_request() takes bytes instead of sectors as a complete si=
ze.
> - * blk_rq_bytes() returns bytes left to complete in the entire reque=
st.
> - * blk_rq_cur_bytes() returns bytes left to complete in the current =
segment.
> + * blk_rq_pos()		: the current sector
> + * blk_rq_bytes()	: bytes left in the entire request
> + * blk_rq_cur_bytes()	: bytes left in the current segment
> + * blk_rq_sectors()	: sectors left in the entire request
> + * blk_rq_cur_sectors()	: sectors left in the current segment
>   */
> +static inline sector_t blk_rq_pos(struct request *rq)
                                     ^
				     const?
> +{
> +	return rq->hard_sector;
> +}
> +
>  extern unsigned int blk_rq_bytes(struct request *rq);
>  extern unsigned int blk_rq_cur_bytes(struct request *rq);
> =20
> +static inline unsigned int blk_rq_sectors(struct request *rq)
					     ^
					     const?
> +{
> +	return rq->hard_nr_sectors;
> +}
> +
> +static inline unsigned int blk_rq_cur_sectors(struct request *rq)
						 ^
						 const?
> +{
> +	return rq->hard_cur_sectors;
> +}
> +

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
