From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Mon, 21 Apr 2003 18:17:56 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030421181755.A19118@one-eyed-alien.net>
References: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:6664 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262739AbTDVBF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2003 21:05:57 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304220109.h3M19NX09680.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Tue, Apr 22, 2003 at 03:09:23AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@SteelEye.com, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

First, we're talking about 2.5.

As for what fails... start by looking at bugzilla for bugs assigned to me.
There are about 4-5 which are all devices that choke on a command (or it's
variant) that the 'popular OSes' don't send.  There is a constant stream of
reports of similar problems on linux-usb-users and -devel.

The basic failure mode is this:  The host sends a command that the device
doesn't like (for the aforementioned reason), and the device firmware
crashes or otherwise enters an unrecoverable state.  Some of the evil
commands include various forms of INQUIRY, MODE_SENSE (to disks), READ_6,
WRITE_6, etc.

Your patches went a long way to improving things.  But, then people added
EVPD and further changed MODE_SENSE and other things.   It's pretty clear
to me that trying to change the SCSI core to not use these commands isn't
going to happen -- so I want a way to filter them.  I originally wanted a
centralized filter (i.e. usb-storage could indicate to the mid-layer not to
send the 'unwelcome' commands), but that got shot down in favor of a
centralized filter-framework which could be applied by any LLDD that wanted
to.

Or, at least, that's how I recap the situation.  I think we're at the point
where we're trying to decide what to merge.  At least I hope that's where
we are -- and I still stand by my patch (based on James' work).

The idea of a centralized framework was to allow multiple sections of code
to use this (sbp2, usb-storage, ide-scsi perhaps, and other LLDDs).

Matt

On Tue, Apr 22, 2003 at 03:09:23AM +0200, Andries.Brouwer@cwi.nl wrote:
> I have not been following this USB and SCSI stuff very carefully,
> but some time ago I tried a large number of strange USB devices,
> and of course some failed, and I changed the SCSI stuff a little
> so that everything worked. I think Linus took these patches,
> which means that on my sample of devices 2.5 works.
>=20
> Is the present discussion about 2.4, or is it about 2.5,
> and in case it is the latter, can anybody describe what
> devices fail, and in what way?
>=20
> Andries

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

But where are the THEMES?!  How do you expect me to use an OS without=20
themes?!
					-- Stef
User Friendly, 10/9/1998

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pJhDIjReC7bSPZARAh4YAJ9X7SUq1qhMmiwkJdp/qqXnG8xp9wCeIaCO
+tD9quBSdqhxRvL+gAqPTQ8=
=5zAz
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
