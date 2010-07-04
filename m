From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 07/12] be2iscsi: Fix for premature buffer free
Date: Sun, 4 Jul 2010 22:22:30 +0200
Message-ID: <201007042222.36951.eike-kernel@sf-tec.de>
References: <20100630000021.GA20279@serverengines.com> <4C30E874.2090200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1365277.0lDhSurkoA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:53110 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757972Ab0GDUWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Jul 2010 16:22:40 -0400
In-Reply-To: <4C30E874.2090200@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org, James.Bottomley@suse.de

--nextPart1365277.0lDhSurkoA
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Mike Christie wrote:
> On 06/29/2010 07:00 PM, Jayamohan Kallickal wrote:

> > @@ -160,18 +179,34 @@ static int beiscsi_eh_device_reset(struct scsi_cm=
nd
> > *sc)
> >=20
> >   	spin_unlock_bh(&session->lock);
> >   	inv_tbl =3D phba->inv_tbl;
> >=20
> > -	tag =3D mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
> > +	nonemb_cmd.va =3D pci_alloc_consistent(phba->ctrl.pdev,
> > +				sizeof(struct invalidate_commands_params_in),
> > +				&nonemb_cmd.dma);
> > +	if (nonemb_cmd.va =3D=3D NULL) {
> > +		SE_DEBUG(DBG_LVL_1,
> > +			 "Failed to allocate memory for"
> > +			 "mgmt_invalidate_icds\n");
> > +		return -1;
>=20
> return FAILED.

Why not ENOMEM? That would come into my mind when an allocations fails.

Eike

--nextPart1365277.0lDhSurkoA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkww7YwACgkQXKSJPmm5/E6xuACaAzXZ6lEiQ8ulxMDG8GdH0Sa4
AEoAoImhk2LpxE4s5UR59MiFUCeRzxuF
=aUiw
-----END PGP SIGNATURE-----

--nextPart1365277.0lDhSurkoA--
