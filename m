From: Ingo Saitz <Ingo.Saitz@stud.uni-hannover.de>
Subject: Re: PROBLEM: 2.6.25: sr0 cdrom does not change medium size on
	medium change
Date: Mon, 12 May 2008 22:34:22 +0200
Message-ID: <20080512203422.GA2641@schwan.zoo>
References: <20080508112108.GA2744@schwan.zoo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758698AbYELUem@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080508112108.GA2744@schwan.zoo>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I did some git bisecting during which I found it does matte wether you
let the drive settle before mounting or not during the 2.6.25 devcycle.
So after being struck at some random position I redid the bisection.

This commit applies to: changing the medium (cd/dvd), waiting until the
drive settles and mounting it. The kernel no longer changes the size of
the medium in /sys/block/sr0/size, giving read errors for bigger mediae.

-----8<-----8<-----
210ba1d1724f5c4ed87a2ab1a21ca861a915f734 is first bad commit
commit 210ba1d1724f5c4ed87a2ab1a21ca861a915f734
Author: James Bottomley <James.Bottomley@HansenPartnership.com>
Date:   Sat Jan 5 10:39:51 2008 -0600

    [SCSI] sr: update to follow tray status correctly

    Based on an original patch from: David Martin <tasio@tasio.net>

    When trying to get the drive status via ioctl CDROM_DRIVE_STATUS, with
    no disk it gives CDS_TRAY_OPEN even if the tray is closed.

    ioctl works as expected with ide-cd driver.

    Gentoo bug report: http://bugs.gentoo.org/show_bug.cgi?id=196879

    Cc: Maarten Bressers <mbres@gentoo.org>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

:040000 040000 704d23cdc9b3e5d596d879b4705586966b76e74d 9f1f71802ee45e734758d2c89d0b90102b549bdb M      drivers
----->8----->8-----

I'm forwarding this to the linux-scsi list, too.

    Ingo

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIKKnO4XrXtQkN2NURAuE8AJ9VFuMjXXq37zk8RHnhiYfavNXq1QCgpYe+
jiJz5S3sBk+D0KJ4F4WsLFs=
=Nkum
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
