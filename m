From: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Mon, 21 Jul 2008 00:40:33 +0200
Message-ID: <20080721004033.1fc66aa3@mjolnir.drzeus.cx>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
	<200807170053.36661.rjw@sisk.pl>
	<1216249292.3358.66.camel@localhost.localdomain>
	<200807170109.30655.rjw@sisk.pl>
	<48808EE0.2060603@gmail.com>
	<20080719004736.626ef169@mjolnir.drzeus.cx>
	<48813C5F.70007@gmail.com>
	<20080719033050.552f9b49@mjolnir.drzeus.cx>
	<48814D81.8060001@gmail.com>
	<20080719140717.7b296eae@mjolnir.drzeus.cx>
	<4881F437.7000503@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-28653-1216593638-0001-2"
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4881F437.7000503@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-28653-1216593638-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Jul 2008 23:03:35 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Pierre Ossman wrote:
> > On Sat, 19 Jul 2008 11:12:17 +0900
> > Tejun Heo <htejun@gmail.com> wrote:
> >=20
> >> Oh... I see.  How about adding sg_miter_consume(@miter, @bytes)?  If t=
he
> >> function is never called, the whole chunk is assumed to be consumed.  =
If
> >> the function is called only @bytes are consumed.
> >>
> >=20
> > Sounds reasonable. Care to make an independent patch so that I can
> > continue my PIO hacking adventures? :)
>=20
> Sure thing.  Here you go.  :-)
>=20
> Subject: [PATCH 2.6.26] sg: reimplement sg mapping iterator
>=20

I've converted my code to use your implementation instead, and it seems
to be working perfectly.

How comfortable to you feel about your patch? :)
This fixes a big problem in the sdhci driver where falling back on PIO
(because of hw DMA bugs) would create lots of potential issues as the
driver couldn't access highmem pages. I'd like to get this fix in for
2.6.27, which means that your patch also needs to go in now.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-28653-1216593638-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiDvuQACgkQ7b8eESbyJLjU/wCg8Fy/hfuE55g8HvUdDDtEKtui
mWEAn1gDGsXeqGMD5chL1itu1ND1Rvrd
=HwL4
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-28653-1216593638-0001-2--
