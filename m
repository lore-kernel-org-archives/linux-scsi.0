From: Adam Kessel <adam@bostoncoop.net>
Subject: Crashing problems with Neuros USB Device
Date: Fri, 25 Jul 2003 15:18:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030725191853.GB3699@bostoncoop.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from proper.eecs.harvard.edu ([140.247.60.120]:17814 "EHLO
	bostoncoop.net") by vger.kernel.org with ESMTP id S272254AbTGYTDn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2003 15:03:43 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I've been experiencing various problems with the Neuros Audio Device
under Linux.  At this point, I've been working with USB people to try to
figure it out, but there are some SCSI errors showing up, so I thought it
would be good to at least post some information here. =20

Several other users with different hardware have reported the same
problems.[1][2] This problem has also been discused on linux-usb-devel,
with no success so far.[3]

The problem occurs only when writing to the device, and usually only
after several megabytes have been written.

In 2.4.21, the entire system will occasionally lock up when device is
mounted.  Only option is to kill the power. =20

In 2.5.{73,74,75} and 2.6, the system almost never locks up, but usually
the process writing to the device gets stuck in an uninterruptible state.
It can't be killed.  The system gets stuck shutting down and ultimately I
need to kill the power (or Magic-SysRQ-O).  Mounting the device sync
rather than async, and using rsync with a low bwlimit reduce the
frequency of blockage, but does not get rid of it entirely. =20

In 2.4.22-pre8, things seem to be working pretty well. I have been able
to write hundreds of megabytes with the device mounted async, and the
only glitch seems to be occasional long delays.  I suspect this is when
the device is "catching up".  But this far I have never had an unkillable
process or crash with 2.4.22-pre8. =20

While I don't understand well enough the interplay between usb-storage
and SCSI, there seems to be at least some SCSI part of this.  On
shutdown, the function that gets stuck is scsi_remove_host in
storage_disconnect--if I put debug output after scsi_remove_host is
called, I never see it. =20

I also get occasionally filesystem panics, presumably when the device
reset fails repeatedly.  I'm not sure where to report the filesystem
panics--USB, SCSI, or filesystem people? =20

Finally, I frequently get:=20

kernel: kernel BUG at drivers/block/as-iosched.c:1600! =20

in 2.6.

I've posted some logs which might give some more information.[4],[5]

Hope this is helpful.

--Adam

[1] http://bugs.xiph.org/show_bug.cgi?id=3D367
[2] http://www.neurosaudio.com/community/forum/topic.asp?TOPIC_ID=3D1222
[3] http://sourceforge.net/mailarchive/forum.php?thread_id=3D2679481&forum_=
id=3D5398
[4] http://bostoncoop.net/adam/temp/newest_2.6_log=20
    Annotated log under 2.6, mounting, writing to the device, eventually
    gets stuck, fails to shutdown (includes the as-iosched.c BUG)
[5] http://bostoncoop.net/adam/temp/crash-log-2.5
    Getting stuck under 2.5.75; can't shut down
=20

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IYKddTf3ZklQ6qYRAifpAKCdXcCzZRBHFKW0/s7ib0qkVK0KyQCfSumI
ZZ1FRUAzFT1FAsNySV3clhk=
=ui1j
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
