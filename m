From: =?iso-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH 1/3] st.ko: fix enlarge_buffer
Date: Mon, 16 Dec 2013 20:39:36 +0200
Message-ID: <673E19EA-2460-4392-BBF5-B4923DE67093@kolumbus.fi>
References: <d6437a$579to8@dgate10u.abg.fsc.net>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:41348 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3LPSjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 13:39:42 -0500
In-Reply-To: <d6437a$579to8@dgate10u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: linux-scsi@vger.kernel.org


On 2.12.2013, at 21.00, Bodo Stroesser <bstroesser@ts.fujitsu.com> wrot=
e:

> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Date: Mon, 2 Dec 2013 18:52:10 +0100
> Subject: [PATCH 1/3] st.ko: fix enlarge_buffer
>=20
> This patch removes a bug in enlarge_buffer() that can make a
> read or write fail under special conditions.
>=20
> After changing TRY_DIRECT_IO to 0 and ST_MAX_SG to 32 in
> st_options.h, a program that writes a first block of 128k and
> than a second bigger block (e.g. 256k) fails. The second write
> returns errno EOVERFLOW, as enlarge_buffer() checks the sg list
> and detects that it already is full.
> As enlarge_buffer uses different page allocation orders
> depending on the size of the buffer needed, the check does not
> make sense.
>=20
Yes, it is not useful any more. It may have been necessary at some time=
 but I am now not sure about that either ;-)

> Cc: Kai Makisara <kai.makisara@kolumbus.fi>

Acked-by: Kai M=E4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai

> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>=20
> ---
>=20
> --- a/drivers/scsi/st.c	2013-12-02 18:52:10.000000000 +0100
> +++ b/drivers/scsi/st.c	2013-12-02 18:52:10.000000000 +0100
> @@ -3719,7 +3719,7 @@ static struct st_buffer *new_tape_buffer
>=20
> static int enlarge_buffer(struct st_buffer * STbuffer, int new_size, =
int need_dma)
> {
> -	int segs, nbr, max_segs, b_size, order, got;
> +	int segs, max_segs, b_size, order, got;
> 	gfp_t priority;
>=20
> 	if (new_size <=3D STbuffer->buffer_size)
> @@ -3729,9 +3729,6 @@ static int enlarge_buffer(struct st_buff
> 		normalize_buffer(STbuffer);  /* Avoid extra segment */
>=20
> 	max_segs =3D STbuffer->use_sg;
> -	nbr =3D max_segs - STbuffer->frp_segs;
> -	if (nbr <=3D 0)
> -		return 0;
>=20
> 	priority =3D GFP_KERNEL | __GFP_NOWARN;
> 	if (need_dma)

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
