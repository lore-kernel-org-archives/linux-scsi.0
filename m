From: Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: BUG in handling of last_sector_bug flag
Date: Fri, 15 Aug 2008 19:43:50 +0200
Message-ID: <20080815194350.c0930909.ospite@studenti.unina.it>
References: <48A30DC7.8070501@panasas.com>
	<Pine.LNX.4.44L0.0808141535350.2148-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__15_Aug_2008_19_43_50_+0200_hQ2RJCbHl.S7uR21"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out25.alice.it ([85.33.2.25]:1503 "EHLO
	smtp-out25.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbYHORn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 13:43:59 -0400
In-Reply-To: <Pine.LNX.4.44L0.0808141535350.2148-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Boaz Harrosh <bharrosh@panasas.com>, Alan Jenkins <alan-jenkins@tuffmail.co.uk>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hans de Goede <j.w.r.degoede@hhs.nl>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

--Signature=_Fri__15_Aug_2008_19_43_50_+0200_hQ2RJCbHl.S7uR21
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Aug 2008 15:41:28 -0400 (EDT)
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 13 Aug 2008, Boaz Harrosh wrote:
>=20
> > One thing I don't like is the now blk_end_request(req, -EIO, bytes=3D0)
> > inside scsi_end_request(). What's the point of calling that with 0 byte=
s?
> > Maybe fix that too.
>=20
> While testing the patch, I learned what the point is.  :-)
>=20
> Actually it's very simple; you just have to remember that not all=20
> requests are BLOCK_FS type.  Other types of request can indeed have a=20
> transfer length of 0, and we want to end those requests normally.
>=20
> So this version of the patch works better than the earlier one.  In=20
> principle there doesn't seem to be any reason not to call=20
> blk_end_request with bytes =3D 0, but I left the test in there.
>=20
> Alan, you might want to test this version and see how well it works for=20
> you.
>=20
> Alan Stern
>

Thanks Alan,

the latest patch fixes the problem for me as well, just great.

Now here's the log I have, there are still Medium errors, but I think
that's ok, I also had them with 2.6.24 after all.
http://shell.studenti.unina.it/~ospite/tmp/linux-usb/usb-mass-storage+Alan_=
Stern_patch-2.6.27-rc3-WORKING.log

Best regards,
   Antonio Ospite

--=20
A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

  Web site: http://www.studenti.unina.it/~ospite
Public key: http://www.studenti.unina.it/~ospite/aopubkey.asc

--Signature=_Fri__15_Aug_2008_19_43_50_+0200_hQ2RJCbHl.S7uR21
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkilwFYACgkQ5xr2akVTsAGnpwCeIVRaXsj/3kJBLYAjX/TSW4Bm
6gwAn0LJK0hPKMGqTIT+dhAaRsZwSkaI
=oIoX
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Aug_2008_19_43_50_+0200_hQ2RJCbHl.S7uR21--
