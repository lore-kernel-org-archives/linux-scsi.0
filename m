From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 21 Apr 2003 10:01:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421100102.A12581@one-eyed-alien.net>
References: <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030420143351.C20891@one-eyed-alien.net> <1050942530.1772.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:55058 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261722AbTDUQtM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 12:49:12 -0400
Content-Disposition: inline
In-Reply-To: <1050942530.1772.12.camel@mulgrave>; from James.Bottomley@SteelEye.com on Mon, Apr 21, 2003 at 11:28:48AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 21, 2003 at 11:28:48AM -0500, James Bottomley wrote:
> Actually, you havn't folded any of the list feedback into your version.=
=20
> I've done the merger and collapsed the EVPD inquiry filter into a
> qualifier of the inquiry filter (which seems more appropriate).

I think 'any' is a bit harsh here... but, regardless...

My biggest complaints are:
(1) Your patch doesn't compile on my system.  RH7.3 -- it chokes on an
array in a struct with no length.  I doubt I'm the only person with this
problem.  Considering that in other places we bother to support this
compiler (-fomit-frame-pointer anyone?), it seems reasonable that we want
to support it here.

(2) You're creating a struct to associate two things (white/black selection
and the list) which don't really need to be associated.  A list is a list
-- if we treat it as whitelist or blacklist really is a separate question.

(3) Your treatment of the INQUIRY EVPD filter arbitrarily limits what the
filter can specify just to conserve a 'case' in a 'switch' -- considering
that the history of the problem starts with scsi_scan issuing INQUIRY for
255 bytes, making the filter unable to limit anything >=3D127 seems bad.

I stand by my original patch on this.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Why am I talking to a toilet brush?
					-- CEO
User Friendly, 4/30/1998

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pCPOIjReC7bSPZARAj4kAKCij3q1M38zXIjZCej0tztppKCnHwCbBLnn
tzkVLetP+c1mq7gjJXAi450=
=z7eA
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
