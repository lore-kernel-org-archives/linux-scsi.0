From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sun, 20 Apr 2003 14:35:46 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030420143546.D20891@one-eyed-alien.net>
References: <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com> <20030322233136.D17056@one-eyed-alien.net> <1048467235.1634.22.camel@mulgrave> <20030323173733.B24668@one-eyed-alien.net> <1048469946.1643.2.camel@mulgrave> <20030323230438.E24668@one-eyed-alien.net> <1048519237.1982.16.camel@mulgrave> <20030324093028.A1066@one-eyed-alien.net> <1049556643.1762.16.camel@mulgrave> <20030420143351.C20891@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:18701 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263710AbTDTVX5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Apr 2003 17:23:57 -0400
Content-Disposition: inline
In-Reply-To: <20030420143351.C20891@one-eyed-alien.net>; from mdharm-scsi@one-eyed-alien.net on Sun, Apr 20, 2003 at 02:33:51PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 20, 2003 at 02:33:51PM -0700, Matthew Dharm wrote:
> I've tested this, and it works well.  Linus, if you'll take this I've got
> several more patches -- ones to make usb-storage use this to cut some
> undesireable commands, and one to fix up the INQUIRY probing in scsi_scan=
.c
> to be compatible with the filter code.

Here is my patch to the SCSI scanning code.  Basically, if the first
INQUIRY for 36 bytes works, but a later one fails because of the filter, we
should still accept the device.

Linus, please apply.  I'll push the usb-storage patches via Greg K-H once
these are accepted.

Matt

# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.671   -> 1.672 =20
#	drivers/scsi/scsi_scan.c	1.28    -> 1.29  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/04/19	mdharm@zen.san.one-eyed-alien.net	1.672
# Modified probing routine so that HBAs which use the command filter to
# restrict INQUIRY to 36-bytes still get their devices detected.
#=20
# This entire section of code may be bogus.  After all, if we got a good
# INQUIRY the first time, shouldn't we be on the guaranteed-accept path?
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sat Apr 19 17:16:53 2003
+++ b/drivers/scsi/scsi_scan.c	Sat Apr 19 17:16:53 2003
@@ -1065,8 +1065,28 @@
 		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 2nd INQUIRY"
 				" %s with code 0x%x\n", sreq->sr_result ?
 				"failed" : "successful", sreq->sr_result));
-		if (sreq->sr_result)
-			return;
+
+		/* problem with the additional request */
+		if (sreq->sr_result) {
+			/* if it's anything but an ILLEGAL_REQUEST bail out */
+			if ((sreq->sr_sense_buffer[2] & 0xf) !=3D ILLEGAL_REQUEST)
+				return;
+
+			/* a CHECK_CONDITION -- likely this came from the
+			 * command filter code.  We re-issue the 36-byte req
+			 * so we have good data to work with.
+			 */
+			possible_inq_resp_len =3D 36;
+			memset(scsi_cmd, 0, 6);
+			scsi_cmd[0] =3D INQUIRY;
+			scsi_cmd[4] =3D (unsigned char) possible_inq_resp_len;
+			sreq->sr_cmd_len =3D 0;
+			sreq->sr_data_direction =3D SCSI_DATA_READ;
+			memset(inq_result, 0, 36);
+			scsi_wait_req(sreq, (void *) scsi_cmd,
+					(void *) inq_result, 36,
+				       	SCSI_TIMEOUT + 4 * HZ, 3);
+		}
=20
 		/*
 		 * The INQUIRY can change, this means the length can change.

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+oxKyIjReC7bSPZARAtXCAKCcghb7Kma6p8N2M10/GDQ8eFPYZgCaAtmS
ZHD2UlXVBKO/1RC21VZySUA=
=pVP3
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
