From: Kurt Garloff <kurt@garloff.de>
Subject: Re: [PATCH] Additional BLIST_LARGELUN devices
Date: Thu, 27 Jun 2002 16:53:01 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020627145301.GB11237@gum01m.etpnet.phys.tue.nl>
References: <20020626164744.GH3023@gum01m.etpnet.phys.tue.nl> <3D1B1C87.4020504@metaparadigm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3D1B1C87.4020504@metaparadigm.com>
List-Id: linux-scsi@vger.kernel.org
To: Michael Clark <michael@metaparadigm.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Dave Jones <davej@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>


--Fig2xvG2VGoz8o/s
Content-Type: multipart/mixed; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michael,

On Thu, Jun 27, 2002 at 10:09:11PM +0800, Michael Clark wrote:
> On 06/27/02 00:47, Kurt Garloff wrote:
> >here are some additional devices that need the BLIST_LARGELUN flag.
> >
> >+	{"CNSi", "G8324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     //=20
> >Chaparral G8324 RAID
>=20
> The G8324 correctly identifies itself as SCSI-3 so doesn't
> need the BLIST_LARGELUN flag (proc output below
> from 2.4.18 with automated large lun scanning).

OK, it got in that list by accident then. Won't hurt, of course.
I removed the flag. New patch attached.

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>         [Eindhoven, NL]
Physics: Plasma simulations    <K.Garloff@TUE.NL>     [TU Eindhoven, NL]
Linux: SCSI, Security          <garloff@suse.de>    [SuSE Nuernberg, DE]
 (See mail header or public key servers for PGP2 and GPG public keys.)

--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="50_scsi-largelun-2.4.19-pre7aa1.new"
Content-Transfer-Encoding: quoted-printable

diff -urN linux-2.4.18.tmp/drivers/scsi/scsi_scan.c linux-2.4.18.SuSE/drive=
rs/scsi/scsi_scan.c
--- linux-2.4.18.tmp/drivers/scsi/scsi_scan.c	Wed Apr 24 11:26:44 2002
+++ linux-2.4.18.SuSE/drivers/scsi/scsi_scan.c	Wed Apr 24 11:35:48 2002
@@ -149,17 +149,17 @@
  	{"TOSHIBA","CDROM","*", BLIST_ISROM},
  	{"TOSHIBA","CD-ROM","*", BLIST_ISROM},
 	{"MegaRAID", "LD", "*", BLIST_FORCELUN},
-	{"DGC",  "RAID",      "*", BLIST_SPARSELUN}, // Dell PV 650F (tgt @ LUN 0)
-	{"DGC",  "DISK",      "*", BLIST_SPARSELUN}, // Dell PV 650F (no tgt @ LU=
N 0)=20
-	{"DELL", "PV660F",   "*", BLIST_SPARSELUN},
-	{"DELL", "PV660F   PSEUDO",   "*", BLIST_SPARSELUN},
-	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN}, // Dell PV 530F
-	{"DELL", "PV530F",    "*", BLIST_SPARSELUN}, // Dell PV 530F
+	{"DGC",  "RAID",      "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV =
650F (tgt @ LUN 0)
+	{"DGC",  "DISK",      "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV =
650F (no tgt @ LUN 0)=20
+	{"DELL", "PV660F",   "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"DELL", "PV660F   PSEUDO",   "*", BLIST_SPARSELUN | BLIST_LARGELUN},
+	{"DELL", "PSEUDO DEVICE .",   "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // =
Dell PV 530F
+	{"DELL", "PV530F",    "*", BLIST_SPARSELUN | BLIST_LARGELUN}, // Dell PV =
530F
 	{"EMC", "SYMMETRIX", "*", BLIST_SPARSELUN | BLIST_LARGELUN | BLIST_FORCEL=
UN},
 	{"HP", "A6189A", "*", BLIST_SPARSELUN |  BLIST_LARGELUN}, // HP VA7400, b=
y Alar Aun
-	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN},   // CMD RAID Controller
-	{"CNSI", "G7324", "*", BLIST_SPARSELUN},     // Chaparral G7324 RAID
-	{"CNSi", "G8324", "*", BLIST_SPARSELUN},     // Chaparral G8324 RAID
+	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN | BLIST_LARGELUN},   // CMD RAID=
 Controller
+	{"CNSI", "G7324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparra=
l G7324 RAID
+	{"CNSi", "G8324", "*", BLIST_SPARSELUN},     // Chaparral G8324 RAID
 	{"Zzyzx", "RocketStor 500S", "*", BLIST_SPARSELUN},
 	{"Zzyzx", "RocketStor 2000", "*", BLIST_SPARSELUN},
 	{"SONY", "TSL",       "*", BLIST_FORCELUN},  // DDS3 & DDS4 autoloaders

--NDin8bjvE/0mNLFQ--

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.7 (GNU/Linux)

iD8DBQE9GybNxmLh6hyYd04RAkWYAJ0fPBHioXNydWKCfekyJ753XfzJiQCeJpUe
4ITDqx5axk+mG3UVnkrUwCI=
=Nj6n
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
