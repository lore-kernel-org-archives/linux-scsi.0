From: =?Windows-1252?Q?Str=F6sser=2C_Bodo?=
	<bodo.stroesser@ts.fujitsu.com>
Subject: RE: [PATCH 2/3] st.ko: remove unnecessary normalize_buffer
Date: Mon, 16 Dec 2013 20:19:33 +0100
Message-ID: <8B06D1E6480A6747B23FEC34909D2B5E96D3F453BD@ABGEX70E.FSC.NET>
References: <61eb00$4eu08m@dgate20u.abg.fsc.net>
 <96E79A72-FE3D-4040-A338-A778835C4FDB@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:39248 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3LPT3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 14:29:19 -0500
In-Reply-To: <96E79A72-FE3D-4040-A338-A778835C4FDB@kolumbus.fi>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: "Kai M=E4kisara (Kolumbus)" [mailto:kai.makisara@kolumbus.fi]
> Sent: Monday, December 16, 2013 7:45 PM
> To: Str=F6sser, Bodo
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 2/3] st.ko: remove unnecessary normalize_buffer
>=20
>=20
> On 2.12.2013, at 21.00, Bodo Stroesser <bstroesser@ts.fujitsu.com>
> wrote:
>=20
> > From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> > Date: Mon, 2 Dec 2013 18:52:10 +0100
> > Subject: [PATCH 2/3] st.ko: remove unnecessary normalize_buffer
> >
> > This patch removes an unnecessary call to normalize_buffer()
> > in enlarge_buffer()
> >
> > In st_open() always a buffer of one page is allocated.
> > When the buffer needs to be enlarged later, it does not make
> > sense to free this page unconditionally.
> >
>=20
> The original reason for this was to make the function to allocate the
> minimum number of segments for maximum efficiency. In some cases it w=
as
> essential not to waste one segment because that would have made the
> allocation fail.

The method of enlarge_buffer now seems to have changed. It tries to
find out the minimum size of a segment that can be used with the given
sg list length. I assume, this method is used to be able to allocate
very big buffers, while in case of "normal" buffer still small chunks o=
f
memory can be used, which under memory pressure are more likely to be
granted.

>=20
> Now there is another reason to have this =93optimization=94. Reading =
the
> code you probably have noticed that nowadays all segments must have t=
he
> same size. If the first segment is only one page, the first allocatio=
n
> may it may not be possible to allocate the buffer using single page
> segments. This leads to freeing the pages and trying again. This is n=
ot
> efficient.
>=20

OTOH, if the size of the currently allocated segments is too small for
the buffer that needs to be allocated now, enlarge_buffer will free all
current segments and do a completely new allocation using bigger segmen=
ts
anyway.

The lines, that the patch would remove, currently free one segment, if =
it
is the smallest possible and the only one, even if the same segment siz=
e
will be allocated again a few lines below. So I'd still call it a not
optimal handling of a special case, that not needs to be handled specia=
lly.

Thanks,
Bodo
=20

> So, I think this fragment of code should not be removed.
>=20
> Thanks,
> Kai
>=20
> > Cc: Kai Makisara <kai.makisara@kolumbus.fi>
> > Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> >
> > ---
> >
> > --- a/drivers/scsi/st.c	2013-12-02 18:52:10.000000000 +0100
> > +++ b/drivers/scsi/st.c	2013-12-02 18:52:10.000000000 +0100
> > @@ -3725,9 +3725,6 @@ static int enlarge_buffer(struct st_buff
> > 	if (new_size <=3D STbuffer->buffer_size)
> > 		return 1;
> >
> > -	if (STbuffer->buffer_size <=3D PAGE_SIZE)
> > -		normalize_buffer(STbuffer);  /* Avoid extra segment */
> > -
> > 	max_segs =3D STbuffer->use_sg;
> >
> > 	priority =3D GFP_KERNEL | __GFP_NOWARN;

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
