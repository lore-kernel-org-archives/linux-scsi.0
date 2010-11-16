From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] fix kzalloc in scsi device handler
Date: Tue, 16 Nov 2010 18:35:48 +0100
Message-ID: <201011161835.49079.eike-kernel@sf-tec.de>
References: <AANLkTimsOGcybKBvJCjbtUaUpg5asYMDSky2QhovjcG+@mail.gmail.com> <E463DF2B2E584B4A82673F53D62C2EF4F51A7EDA@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1714237.PK1AVfAYK1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:44581 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab0KPRme (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Nov 2010 12:42:34 -0500
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4F51A7EDA@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: Hillf Danton <dhillf@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Chandra Seetharaman <chandra.seetharaman@us.ibm.com>

--nextPart1714237.PK1AVfAYK1
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Moger, Babu wrote:
> Agree.. But this may not fix the problem completely.. Please see my
> comments below.. Also copied Chandra if he has any comments..
>=20
> > -----Original Message-----
> > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > owner@vger.kernel.org] On Behalf Of Hillf Danton
> > Sent: Tuesday, November 16, 2010 7:34 AM
> > To: linux-scsi@vger.kernel.org
> > Subject: [PATCH] fix kzalloc in scsi device handler
> >=20
> > They look like typo, since there are four instances of kzalloc almost
> > typed by the same finger.
> >=20
> > The pointer is replaced with a struct, which helps kzalloc return
> > correct result.
> >=20
> > thanks for any comment on the possibility that mem overflow could
> > happen.
> >=20
> > Signed-off-by: Hillf Danton <dhillf@gmail.com>
> > ---
> >=20
> > --- a/drivers/scsi/device_handler/scsi_dh_alua.c	2010-11-01
> > 19:54:12.000000000 +0800
> > +++ b/drivers/scsi/device_handler/scsi_dh_alua.c	2010-11-16
> > 20:40:36.000000000 +0800
> > @@ -759,7 +759,7 @@ static int alua_bus_attach(struct scsi_d
> >=20
> >  	unsigned long flags;
> >  	int err =3D SCSI_DH_OK;
> >=20
> > -	scsi_dh_data =3D kzalloc(sizeof(struct scsi_device_handler *)
> > +	scsi_dh_data =3D kzalloc(sizeof(struct scsi_dh_data)
> >=20
> >  			       + sizeof(*h) , GFP_KERNEL);
>=20
> I think this should be like this below.
>=20
>       scsi_dh_data =3D kzalloc(sizeof(struct scsi_dh_data)
>   			       + sizeof(struct alua_dh_data) , GFP_KERNEL);

How about kzalloc(sizeof(*scsi_dh_data) + sizeof(*h), GFP_KERNEL)?

Eike

--nextPart1714237.PK1AVfAYK1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkziwPQACgkQXKSJPmm5/E4iXwCghE1Abk2+248ecRUdcwD8PUcm
3aEAn2KYYDe/iLSicdL4mOfGXQ2eMecA
=sjGd
-----END PGP SIGNATURE-----

--nextPart1714237.PK1AVfAYK1--
