From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: DPC vs tasklet
Date: Fri, 21 May 2004 09:46:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085125571.2781.3.camel@laptop.fenrus.com>
References: <OFD20B05A9.954B29CD-ON85256E9B.0002C560-88256E9B.000355CC@us.ibm.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hILjxRP3m3d/VBQQm2R4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:22720 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265317AbUEUHqO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2004 03:46:14 -0400
In-Reply-To: <OFD20B05A9.954B29CD-ON85256E9B.0002C560-88256E9B.000355CC@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>


--=-hILjxRP3m3d/VBQQm2R4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-05-21 at 02:36, Bryan Henderson wrote:
> > Some
> > of the LINUX documentation I've read states "tasklets are the preferred
> > mechanism with which to implement your bottom half for a normal hardwar=
e
> > device".
>=20
> In all the great answers about why other things are better than tasklets,=
=20
> the basic question of why this documentation doesn't agree isn't=20
> addressed.  Let me try:  I believe the context of this statement is a=20
> comparison to the more traditional Unix method of implementing the bottom=
=20
> half in the interrupt handler.  The statement is saying that a tasklet is=
=20
> normally preferred to putting the same processing right in the interrupt=20
> handler.
>=20
> But in at least some cases, a kernel thread is better than either of=20
> those.

yup. And the scsi driver case is special because the SCSI layer
implements the tasklet/softirq *for you* already, so instead of each
driver having to do it's own, just use the scsi one (by completing
directly in the ISR, which queues for the generic scsi softirq)


--=-hILjxRP3m3d/VBQQm2R4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBArbPDxULwo51rQBIRAqOnAKCFRZVLt4kUnnZW+om6GCeZ5BxZHwCePL6h
7OrZx42+CKGUYAeWjxerPFc=
=cKk9
-----END PGP SIGNATURE-----

--=-hILjxRP3m3d/VBQQm2R4--

