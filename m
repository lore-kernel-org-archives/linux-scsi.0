From: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 22 Mar 2003 19:37:05 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030322193705.C17056@one-eyed-alien.net>
References: <20030322193046.A17056@one-eyed-alien.net> <20030322193149.B17056@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="eRtJSFbw+EEWtPj3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030322193149.B17056@one-eyed-alien.net>; from mdharm-usb@one-eyed-alien.net on Sat, Mar 22, 2003 at 07:31:49PM -0800
List-Id: linux-scsi@vger.kernel.org
To: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@transmeta.com>


--eRtJSFbw+EEWtPj3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This patch changes how devices a probed on a SCSI bus if they are on an
emulated host.

A source-code survey shows that usb-storage, sbp2, ide-scsi, and the 3Ware
driver are the only 'emulated' hosts.

If a host is emulated, we (a) don't ask for EVPD data, as it's likely not
there, (b) assume that we have only 36-bytes of INQUIRY data, and (c) don't
ask disks for their cache-type (assume write-through).

All three of these things have been observed in the field to choke emulated
devices, thus it makes sense to cut them off at the SCSI layer.  In an
interesting side-note, this appears to be the only code which is
conditional on a host being emulated or not.

Linus, please apply to your 2.5.x tree.

Matthew Dharm

# This is a BitKeeper generated patch for the following project:
# Project Name: greg k-h's linux 2.5 USB kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.697   -> 1.698 =20
#	   drivers/scsi/sd.c	1.47    -> 1.48  =20
#	drivers/scsi/scsi_scan.c	1.26    -> 1.27  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/03/22	mdharm@zen.san.one-eyed-alien.net	1.698
# Emulated hosts shouldn't get certain commands.
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Sat Mar 22 19:19:22 2003
+++ b/drivers/scsi/scsi_scan.c	Sat Mar 22 19:19:22 2003
@@ -514,6 +514,10 @@
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	int max_lgth =3D 255;
=20
+	/* emulated devices don't like the request for EVPD page */
+	if (sdev->host->hostt->emulated)
+		return NULL;
+
 retry:
 	evpd_page =3D kmalloc(max_lgth, GFP_ATOMIC |
 			      (sdev->host->unchecked_isa_dma) ?
@@ -851,6 +855,10 @@
 		return 0;
 	}
=20
+	/* emulated devices do not react well to this sort of thing */
+	if (sdev->host->hostt->emulated)
+		goto leave;
+
 	memset(scsi_cmd, 0, MAX_COMMAND_SIZE);
 	scsi_cmd[0] =3D INQUIRY;
 	scsi_cmd[1] =3D 0x01;
@@ -1033,6 +1041,10 @@
 	 */
 	BUG_ON(bflags =3D=3D NULL);
 	*bflags =3D scsi_get_device_flags(&inq_result[8], &inq_result[16]);
+
+	/* emulated devices should all be treated as blacklisted */
+	if (sdev->host->hostt->emulated)
+		*bflags |=3D BLIST_INQUIRY_36;
=20
 	possible_inq_resp_len =3D (unsigned char) inq_result[4] + 5;
 	if (BLIST_INQUIRY_36 & *bflags)
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sat Mar 22 19:19:21 2003
+++ b/drivers/scsi/sd.c	Sat Mar 22 19:19:22 2003
@@ -1152,6 +1152,15 @@
 	const int dbd =3D 0x08;	   /* DBD */
 	const int modepage =3D 0x08; /* current values, cache page */
=20
+	/* emulated devices likely do not support this type of mode sense */
+	if (sdkp->device->host->hostt->emulated) {
+		printk(KERN_NOTICE "%s: emulated, assuming drive cache: %s\n",
+		       diskname, "write through");
+		sdkp->WCE =3D 0;
+		sdkp->RCD =3D 0;
+		return;
+	}
+
 	/* cautiously ask */
 	res =3D sd_do_mode_sense6(sdp, SRpnt, dbd, modepage, buffer, 4);
=20

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Sir, for the hundreth time, we do NOT carry 600-round boxes of belt-fed=20
suction darts!
					-- Salesperson to Greg
User Friendly, 12/30/1997

--eRtJSFbw+EEWtPj3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+fSvhIjReC7bSPZARAlbiAJwIdkei/spkYTcwm5DkrCZf9yUm/ACbBhSB
7TJaFOgGuAyxYT96C17t50c=
=/+3/
-----END PGP SIGNATURE-----

--eRtJSFbw+EEWtPj3--
