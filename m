From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 21 Apr 2003 12:35:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421123541.C12581@one-eyed-alien.net>
References: <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030420143351.C20891@one-eyed-alien.net> <1050942530.1772.12.camel@mulgrave> <20030421100102.A12581@one-eyed-alien.net> <1050953018.2269.140.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="bAmEntskrkuBymla"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:58884 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261570AbTDUTXw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 15:23:52 -0400
Content-Disposition: inline
In-Reply-To: <1050953018.2269.140.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Apr 21, 2003 at 02:23:36PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--bAmEntskrkuBymla
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2003 at 02:23:36PM -0500, James Bottomley wrote:
> On Mon, 2003-04-21 at 12:01, Matthew Dharm wrote:
> > My biggest complaints are:
> > (1) Your patch doesn't compile on my system.  RH7.3 -- it chokes on an
> > array in a struct with no length.  I doubt I'm the only person with this
> > problem.  Considering that in other places we bother to support this
> > compiler (-fomit-frame-pointer anyone?), it seems reasonable that we wa=
nt
> > to support it here.
> >
> > (2) You're creating a struct to associate two things (white/black selec=
tion
> > and the list) which don't really need to be associated.  A list is a li=
st
> > -- if we treat it as whitelist or blacklist really is a separate questi=
on.
>=20
> To be honest, I don't care much.  I think I had a merge problem where
> the function template mismatched.

Then can we have it the way I proposed?   I have tested patches that use
this code as I proposed it waiting to be merged as soon as this is
accepted.

> The blacklist only exists because you apparently have a device that lies
> about the inquiry length it supports and then goes out to lunch when an
> inquiry of that length is sent to it.
>=20
> Therefore, the only current use of the inquiry filter is to black/white
> list 36 and 58 byte inquiries.
>=20
> Can you send us the inquiry strings of such a problem device?  We've had
> absolutely no takers for the inquiry limitations in the current
> blacklist, which does seem to imply that the code changes made to probe
> all luns fixed the problem for almost everyone else.

I think takers may be waiting in the wings to see this code merged.
Honestly, tho, I don't think I can send you such strings.  I work pretty
closely with some vendors, so most of the devices in my possession have
'fixed' firmware (to report meaningful INQUIRY length).  However, I get
report after report of devices that blow this in new and creative ways from
end-users.

You may recall that my first approach was to set the BLIST flag for 36-byte
INQUIRY -- Linus shot that down in favor of a command-filter approach.

In the end, the limitation of what INQUIRY can be filtered is a minor
complaint compared to the others.  If I have to live with it, I will --
however I will suggest that instead of allowing a length < 127 to be
specified, why not just use a couple of bits to mean 36 and 58 -- i.e.
treat this like the EVPD logic.  If it's not going to be fully flexible,
then let's make it mean exactly what we want.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I see you've been reading alt.sex.chubby.sheep voraciously.
					-- Tanya
User Friendly, 11/24/97

--bAmEntskrkuBymla
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pEgNIjReC7bSPZARAsM6AJ9yZFRDGqTDMfObsufBhzWQYTZMKwCePEc1
xv0fUQhA7FbJVY66Jiiswqc=
=lZJj
-----END PGP SIGNATURE-----

--bAmEntskrkuBymla--
