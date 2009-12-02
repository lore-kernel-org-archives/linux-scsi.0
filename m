From: Torsten Duwe <duwe@lst.de>
Subject: Re: [Patch] fix <scsi/scsi.h> for userland
Date: Thu, 3 Dec 2009 00:57:04 +0100
Message-ID: <200912030057.08731.duwe@lst.de>
References: <200912030031.43645.duwe@lst.de> <20091202233523.GA27579@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6117300.0PDsCI96Bq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:35373 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbZLBX5I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 18:57:08 -0500
In-Reply-To: <20091202233523.GA27579@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Greg KH <gregkh@suse.de>, agraf@suse.de

--nextPart6117300.0PDsCI96Bq
Content-Type: multipart/mixed;
  boundary="Boundary-01=_Q7vFL+8MPzbioKA"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_Q7vFL+8MPzbioKA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 03 December 2009, Greg KH wrote:
> On Thu, Dec 03, 2009 at 12:31:39AM +0100, Torsten Duwe wrote:
> > Hi Greg!
> >
> > When I recompiled my system yesterday with includes from the latest
> > stable kernel(s) I found especially CD IO and similar breaking due to
> > <scsi/scsi.h>. At least 2.6.32-rc8 and 2.6.31.6 need fixing. Please apply
> > attached patch or equivalent.
>
> Is the patch upstream already?
>
> If not, please send this to the scsi maintainer, it needs to be there
> before I can apply it to the -stable releases.

Given that 2.6.32-rc8 and 2.6.31.6 are affected I don't think so. Resending.
linux-scsi, feel free to ignore this if it's already fixed. Otherwise:

Signed-off-by: Torsten Duwe <duwe@lst.de>

--Boundary-01=_Q7vFL+8MPzbioKA
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="compile-fix"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="compile-fix"

=2D-- linux-2.6.31/include/scsi/scsi.h.orig	2009-09-10 00:13:59.000000000 +=
0200
+++ linux-2.6.31/include/scsi/scsi.h	2009-12-02 01:00:34.000000000 +0100
@@ -142,10 +142,10 @@ struct scsi_cmnd;
=20
 /* defined in T10 SCSI Primary Commands-2 (SPC2) */
 struct scsi_varlen_cdb_hdr {
=2D	u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
=2D	u8 control;
=2D	u8 misc[5];
=2D	u8 additional_cdb_length;         /* total cdb length - 8 */
+	__u8 opcode;        /* opcode always =3D=3D VARIABLE_LENGTH_CMD */
+	__u8 control;
+	__u8 misc[5];
+	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
 };
@@ -156,6 +156,7 @@ scsi_varlen_cdb_length(const void *hdr)
 	return ((struct scsi_varlen_cdb_hdr *)hdr)->additional_cdb_length + 8;
 }
=20
+#ifdef __KERNEL__
 extern const unsigned char scsi_command_size_tbl[8];
 #define COMMAND_SIZE(opcode) scsi_command_size_tbl[((opcode) >> 5) & 7]
=20
@@ -165,6 +166,7 @@ scsi_command_size(const unsigned char *c
 	return (cmnd[0] =3D=3D VARIABLE_LENGTH_CMD) ?
 		scsi_varlen_cdb_length(cmnd) : COMMAND_SIZE(cmnd[0]);
 }
+#endif
=20
 /*
  *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft

--Boundary-01=_Q7vFL+8MPzbioKA--

--nextPart6117300.0PDsCI96Bq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBLFv7Q83adOIaM1d4RAsBfAKCMDr2uV3PbvkJDTE9NZ+lhRKdeqACbBjaN
0a8iGbZuJkBnLBgSMnX+Epw=
=cPtw
-----END PGP SIGNATURE-----

--nextPart6117300.0PDsCI96Bq--
