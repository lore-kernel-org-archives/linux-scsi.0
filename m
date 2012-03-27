From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Commit "arm: convert drivers to scsi proc_ops" breaks
 linux-next
Date: Wed, 28 Mar 2012 01:49:00 +1100
Message-ID: <20120328014900.4ac23b9c65831393cae1eb1b@canb.auug.org.au>
References: <20120327025100.GD26825@windriver.com>
	<1332838284.2883.22.camel@dabdike>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Mar_2012_01_49_00_+1100_AKrUUkn=rPPDHRQR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:48890 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2C0OtK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Mar 2012 10:49:10 -0400
In-Reply-To: <1332838284.2883.22.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, "adobriyan@gmail.com" <adobriyan@gmail.com>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--Signature=_Wed__28_Mar_2012_01_49_00_+1100_AKrUUkn=rPPDHRQR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Tue, 27 Mar 2012 08:51:25 +0000 James Bottomley <jbottomley@parallels.co=
m> wrote:
>
> On Mon, 2012-03-26 at 22:51 -0400, Paul Gortmaker wrote:
> >=20
> > This error showed up in linux-next today:
> >=20
> >  CC      drivers/scsi/arm/powertec.o
> > drivers/scsi/arm/powertec.c: In function 'powertecscsi_proc_show':
> > drivers/scsi/arm/powertec.c:199: error: dereferencing pointer to incomp=
lete type
> > drivers/scsi/arm/powertec.c:202: error: implicit declaration of functio=
n 'seq_printf'
> > drivers/scsi/arm/powertec.c: In function 'powertecscsi_proc_open':
> > drivers/scsi/arm/powertec.c:214: error: implicit declaration of functio=
n 'single_open'
> > drivers/scsi/arm/powertec.c: At top level:
> > drivers/scsi/arm/powertec.c:250: error: 'seq_read' undeclared here (not=
 in a function)
> > drivers/scsi/arm/powertec.c:251: error: 'seq_lseek' undeclared here (no=
t in a function)
> > drivers/scsi/arm/powertec.c:252: error: 'single_release' undeclared her=
e (not in a function)
> >=20
> > and a bisect leads to this:
> >=20
> > --------------
> > commit bb6c20445c1bdd1c49ac5e76801211116694e3b9
> > Author: Alexey Dobriyan <adobriyan@gmail.com>
> > Date:   Wed Feb 22 22:46:23 2012 +0300
> >=20
> >     [SCSI] arm: convert drivers to scsi proc_ops
> >    =20
> >     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> >     Signed-off-by: James Bottomley <JBottomley@Parallels.com>
> > --------------
>=20
> Could you dig a little deeper on this one?  seq_printf is defined in
> include/linux/seq_file.h which is included by this commit.  I can't see
> why the function prototype should end up undefined.
>=20
> Could the include guards for this file be getting set erroneously
> somehow?

This patch added seq_file.h to drivers/scsi/arm/acornscsi.c, but not to
drivers/scsi/arm/powertec.c .

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Mar_2012_01_49_00_+1100_AKrUUkn=rPPDHRQR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcdNcAAoJEECxmPOUX5FEx44P/1cBMndLB2VVtzF4wxpSQ3Dm
5YqTYNn6nb6CFERNzv+seOiXkGdTL4MMaR931aecx85+EJi0VhC0+uCGbHtLN+dn
zrA/zYD7wllNTMJA69NUBWGfIM+5K8RXWGnsnEQiw+lCTUmuxak8ZFHQLFYij4uI
FgIp4W5K4h9y4/DRXuBNPMoUT3FgoPnDU+tefsvvlD/2TImBzi2676TpbZwiHMf3
KH0r3wTNpIFPTrPGHq2elUljIgK4XSU1Y2JCkGiM1NEMLHhyZgGeLDhypV6XO4w7
aNERBoaqYHjUCrASZGQjZu0R/CIzJzLw3ZsfWAYlyp3aI8E35v0QHDTFCisWXVLY
kNuqHmccN3XJFNsDZltm7k3dTW5lIohTsK27WHN4XA7N70vb8KMJrq2s4BuKiH3Q
OQYu2SbSRLv1vgedNdwbSh3vrtogtKUczWGGANyHbDy1eTrAMV3tlwR96h+LVgl4
LUQ+q30vgIa8PtxdD+IfTWeELFBeIHLZFIIj2xQVLSvvEftMnvqmZU+RPYD2vsKp
FrgTEkIJp+bKeKK87zlX+nPEZN/H+jKP5fSFhUWFMYGzJzVTmeTEOWrjlEik4OLe
94e2x0/EKEyUfjw7WWH+r/ebW7JAd+w94HbhuQheaSCmbOm4Y1SnCjArupuMm7Jm
oQEB7NHNghVX2WUHDoDP
=ReHl
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Mar_2012_01_49_00_+1100_AKrUUkn=rPPDHRQR--
