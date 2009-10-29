From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH] Add new driver for LSI 3ware 9750
Date: Thu, 29 Oct 2009 20:14:21 +0100
Message-ID: <200910292014.28787.eike@sf-mail.de>
References: <b1bc6a000910201722v28d895cbv25e4959473ff215d@mail.gmail.com> <200910211727.34165.eike-kernel@sf-tec.de> <20091023112137.GB19566@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2075810.WeOeznnmXz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:44572 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374AbZJ2TO3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2009 15:14:29 -0400
In-Reply-To: <20091023112137.GB19566@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>, adam radford <aradford@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Chris Wright <chrisw@sous-sol.org>

--nextPart2075810.WeOeznnmXz
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Freitag 23 Oktober 2009 13:21:38 schrieb Matthew Wilcox:
> On Wed, Oct 21, 2009 at 05:27:27PM +0200, Rolf Eike Beer wrote:
> > > +	/* Try to enable MSI */
> > > +	if (use_msi && !pci_enable_msi(pdev))
> > > +		set_bit(TW_USING_MSI, &tw_dev->flags);
> > > +
> > > +	/* Now setup the interrupt handler */
> > > +	retval =3D request_irq(pdev->irq, twl_interrupt, IRQF_SHARED, "3w-s=
as",
> > >  tw_dev); +	if (retval) {
> > > +		TW_PRINTK(tw_dev->host, TW_DRIVER, 0x1f, "Error requesting IRQ");
> > > +		goto out_remove_host;
> > > +	}
> >
> > If you're using MSI you should not pass IRQF_SHARED here.
>=20
> That's not true.  While it is currently the case that each MSI gets its
> own vector, if you have a machine with sufficiently many interrupt sources
> and insufficiently many interrupt vectors, it is possible we'll have to
> share interrupt vectors.  The PCI MSI code does not support this yet,
> but it may have to in the future, and it would be unpleasant to have to
> go through and change all the device drivers.

Sounds reasonable. Anyway I've seen the exact opposite comment from Chris (=
CC=20
added) in his review of VMware's driver (Message-ID:=20
<20091013053726.GE17547@sequoia.sous-sol.org> from Mon, 12 Oct 2009 22:37:2=
6=20
=2D0700).

Either way is fine for me, I just would like to have a common agreement on=
=20
that.

Eike

--nextPart2075810.WeOeznnmXz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkrp6ZQACgkQXKSJPmm5/E4h4wCgjTK83V8djqYchA3NMfTPsDru
2nwAoIym137hkBP5TQBYSMxqK3SK1enA
=CHVv
-----END PGP SIGNATURE-----

--nextPart2075810.WeOeznnmXz--
