From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 12:14:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424121409.C10511@one-eyed-alien.net>
References: <UTC200304241859.h3OIxjh16776.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:7945 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263807AbTDXTCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 15:02:08 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304241859.h3OIxjh16776.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Thu, Apr 24, 2003 at 08:59:45PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, stelian@popies.net, torvalds@transmeta.com


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2003 at 08:59:45PM +0200, Andries.Brouwer@cwi.nl wrote:
>     From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
>     Yeah, I know that's a lousy answer.  But try to realize that I've been
>     dealing with a long, slow, and painful discovery process of what the
>     'popular OS' uses.
>=20
> Yes, I do not blame you at all. Nevertheless, we must only do
> things when we really understand why. If a filter is really
> necessary we'll find people with problems that are cured only
> that way. Today we do not know any such people, it seems.

Well, at this point, I guess I should just be happy that something is being
done.  But, what I'm really afraid of, this coming right back to this
point.

In the past, I modified the write-protect probing in 2.4.x to be more compa=
tible
with what usb-storage wanted.  But then someone changed it, and it broke.
So we changed it again... and it was fine for a while.  Then someone
changed it in 2.5.x, and it broke again.

I guess what's got me frustrated is that this is very fragile, tends to
cause serious problems when it fails, often gets changed, and isn't really
necessary -- after all, that's why the 'assume write-enabled' code path is
there for when the request fails.

I've just been around and around this merry-go-round, and I'm trying to get
off.  We can fix it now, but I am truly afraid that it's going to get
broken again in 6 months.

And, as for the need for filtering, I know we have such a need.  I have
several devices on my desk which choke at INQUIRY EVPD -- so right now I
filter it in the usb-storage driver.  I also have devices that report bogus
INQUIRY data lengths, but (luckily) the sanity checks in the INQUIRY
probing code generally catch those cases and save us.

I've seen devices that choke on START_STOP, unless that START_STOP is an
eject command.  I fixed this by eliminating the only non-eject use of
START_STOP in sd.c -- but how long is it before someone decides they need
to use START_STOP for something?

We may have fixed MODE_SENSE, but what about the other cases?

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

G:  Let me guess, you started on the 'net with AOL, right?
C:  WOW! d00d! U r leet!
					-- Greg and Customer=20
User Friendly, 2/12/1999

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qDeBIjReC7bSPZARAku1AKCtgXxePcJIJWf+n50fY9Ikq+wQeACfbj0i
LAVoYs4M2IqdrrIWaRUQres=
=k1Sp
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
