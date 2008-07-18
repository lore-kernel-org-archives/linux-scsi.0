From: Pierre Ossman <drzeus-p3sGCRWkH8CeZLLa646FqQ@public.gmane.org>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Sat, 19 Jul 2008 00:47:36 +0200
Message-ID: <20080719004736.626ef169@mjolnir.drzeus.cx>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>
	<200807170053.36661.rjw@sisk.pl>
	<1216249292.3358.66.camel@localhost.localdomain>
	<200807170109.30655.rjw@sisk.pl>
	<48808EE0.2060603@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-23535-1216421260-0001-2"
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <48808EE0.2060603-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <jens.axboe-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-ide <linux-ide-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeff Garzik <jeff-o2qLIJkoznsdnm+yROfE0A@public.gmane.org>, Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>, tino.keitel-Mmb7MZpHnFY@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-23535-1216421260-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jul 2008 21:38:56 +0900
Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>=20
> The offending commit was 83e7d317cef3ee624886f128401a72e414c0a99d
> which implements sg iterator but it forgot to add offset to the
> kmapped address and copy goes out of bounds.  Takashi, this could also
> be the problem you were seeing if you don't have slab debugging turned
> on.
>=20

Oops, sorry. This thing wasn't supposed to go out and mess with anyone
else's tree quite yet. I'll make sure to clean out my -next tree right
away.

> The implemented iterator didn't look too pretty and the usage was
> quite awkward involving a callback and end condition check distributed
> between the callback and the outer user who runs the loop.  For
> copying, end of buffer condition was tested by testing whether the
> callback returned 0 copied bytes for the iteration but AFAIK there's
> no restriction against zero length sg entry in the middle and it will
> terminate the copying prematurely.
>=20
> So, I implemented slightly different version which follows below.
>=20

I just have one objection to your version, and that is that it cannot
be used to nibble away at the sg list. The _next() call jumps an entire
page, whereas you sometimes need to consume that page in two different
sweeps. This could be handled by some external buffer that keeps the
remainder of the page, but the point of these functions was to keep
things simple for the callers.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-23535-1216421260-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiBHYoACgkQ7b8eESbyJLjioACgq9/meiFFoM9mYVbZ+dUmHKbR
YkQAniXrU9ByoRAnds3bxb4VqRUg1xaQ
=Hk64
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-23535-1216421260-0001-2--
