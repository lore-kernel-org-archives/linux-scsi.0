From: =?windows-1252?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH 2/3] st.ko: remove unnecessary normalize_buffer
Date: Mon, 16 Dec 2013 20:45:00 +0200
Message-ID: <96E79A72-FE3D-4040-A338-A778835C4FDB@kolumbus.fi>
References: <61eb00$4eu08m@dgate20u.abg.fsc.net>
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:40685 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3LPSpF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 13:45:05 -0500
In-Reply-To: <61eb00$4eu08m@dgate20u.abg.fsc.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: linux-scsi@vger.kernel.org


On 2.12.2013, at 21.00, Bodo Stroesser <bstroesser@ts.fujitsu.com> wrot=
e:

> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Date: Mon, 2 Dec 2013 18:52:10 +0100
> Subject: [PATCH 2/3] st.ko: remove unnecessary normalize_buffer
>=20
> This patch removes an unnecessary call to normalize_buffer()
> in enlarge_buffer()
>=20
> In st_open() always a buffer of one page is allocated.
> When the buffer needs to be enlarged later, it does not make
> sense to free this page unconditionally.
>=20

The original reason for this was to make the function to allocate the m=
inimum number of segments for maximum efficiency. In some cases it was =
essential not to waste one segment because that would have made the all=
ocation fail.

Now there is another reason to have this =93optimization=94. Reading th=
e code you probably have noticed that nowadays all segments must have t=
he same size. If the first segment is only one page, the first allocati=
on may it may not be possible to allocate the buffer using single page =
segments. This leads to freeing the pages and trying again. This is not=
 efficient.

So, I think this fragment of code should not be removed.

Thanks,
Kai

> Cc: Kai Makisara <kai.makisara@kolumbus.fi>
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>=20
> ---
>=20
> --- a/drivers/scsi/st.c	2013-12-02 18:52:10.000000000 +0100
> +++ b/drivers/scsi/st.c	2013-12-02 18:52:10.000000000 +0100
> @@ -3725,9 +3725,6 @@ static int enlarge_buffer(struct st_buff
> 	if (new_size <=3D STbuffer->buffer_size)
> 		return 1;
>=20
> -	if (STbuffer->buffer_size <=3D PAGE_SIZE)
> -		normalize_buffer(STbuffer);  /* Avoid extra segment */
> -
> 	max_segs =3D STbuffer->use_sg;
>=20
> 	priority =3D GFP_KERNEL | __GFP_NOWARN;

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
