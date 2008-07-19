From: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Sat, 19 Jul 2008 03:30:50 +0200
Message-ID: <20080719033050.552f9b49@mjolnir.drzeus.cx>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
	<200807170053.36661.rjw@sisk.pl>
	<1216249292.3358.66.camel@localhost.localdomain>
	<200807170109.30655.rjw@sisk.pl>
	<48808EE0.2060603@gmail.com>
	<20080719004736.626ef169@mjolnir.drzeus.cx>
	<48813C5F.70007@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-25412-1216431055-0001-2"
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <48813C5F.70007@gmail.com>
Sender: linux-next-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-25412-1216431055-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Jul 2008 09:59:11 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Pierre Ossman wrote:
> > I just have one objection to your version, and that is that it cannot
> > be used to nibble away at the sg list. The _next() call jumps an entire
> > page, whereas you sometimes need to consume that page in two different
> > sweeps. This could be handled by some external buffer that keeps the
> > remainder of the page, but the point of these functions was to keep
> > things simple for the callers.
>=20
> Well, I don't know how often such usages would be necessary.  If it's a
> very common ops, you can add a param to the next function but frankly I
> think it's better to build a inside control structure for that.  There's
> no need for external buffer, just an inner loop is sufficient.
>=20

I'm not sure how this can be solved by an inner loop. My primary use
case is:

1. Wait for interrupt
2. Write n bytes
3. goto 1

n has no guarantee of being aligned to any page boundaries, so state
needs to be kept between each invokation of writing a chunk of data. I
doubt I'm alone in this use pattern (in fact, most device drivers using
PIO should do something similar).

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-25412-1216431055-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiBQ84ACgkQ7b8eESbyJLh53QCg7qnc+iwa36yyuiN8TlQ4A9Yj
0WQAoLHgjuev75S9ngB8lO9/0neIaAvZ
=Oe++
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-25412-1216431055-0001-2--
