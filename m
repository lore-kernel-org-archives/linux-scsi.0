From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] aic94xx: Remove broken fallback for missing 'Ctrl-A'
 user settings
Date: Sun, 27 Oct 2013 21:19:22 +0000
Message-ID: <1382908762.2994.37.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-rYK8UD9FFpU/LL1lpGBw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59272 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288Ab3J0VT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Oct 2013 17:19:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


--=-rYK8UD9FFpU/LL1lpGBw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

asd_process_ctrl_a_user() attempts to find user settings in flash, and
if they are missing it prepares a substitute structure containing
default values for PHY settings.  But having done so, it will still
try to read user settings - from some random address in flash, as the
local variable 'offs' has not been initialised.

Since asd_common_setup() already sets default PHY settings, there
seems to be no need to repeat them here, and we can just return 0.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/aic94xx/aic94xx_sds.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_sds.c b/drivers/scsi/aic94xx/aic9=
4xx_sds.c
index edb43fd..f5d51d2 100644
--- a/drivers/scsi/aic94xx/aic94xx_sds.c
+++ b/drivers/scsi/aic94xx/aic94xx_sds.c
@@ -981,29 +981,15 @@ static int asd_process_ctrla_phy_settings(struct asd_=
ha_struct *asd_ha,
 static int asd_process_ctrl_a_user(struct asd_ha_struct *asd_ha,
 				   struct asd_flash_dir *flash_dir)
 {
-	int err, i;
+	int err;
 	u32 offs, size;
 	struct asd_ll_el *el;
 	struct asd_ctrla_phy_settings *ps;
-	struct asd_ctrla_phy_settings dflt_ps;
=20
 	err =3D asd_find_flash_de(flash_dir, FLASH_DE_CTRL_A_USER, &offs, &size);
 	if (err) {
 		ASD_DPRINTK("couldn't find CTRL-A user settings section\n");
-		ASD_DPRINTK("Creating default CTRL-A user settings section\n");
-
-		dflt_ps.id0 =3D 'h';
-		dflt_ps.num_phys =3D 8;
-		for (i =3D0; i < ASD_MAX_PHYS; i++) {
-			memcpy(dflt_ps.phy_ent[i].sas_addr,
-			       asd_ha->hw_prof.sas_addr, SAS_ADDR_SIZE);
-			dflt_ps.phy_ent[i].sas_link_rates =3D 0x98;
-			dflt_ps.phy_ent[i].flags =3D 0x0;
-			dflt_ps.phy_ent[i].sata_link_rates =3D 0x0;
-		}
-
-		size =3D sizeof(struct asd_ctrla_phy_settings);
-		ps =3D &dflt_ps;
+		return 0;
 	}
=20
 	if (size =3D=3D 0)

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-rYK8UD9FFpU/LL1lpGBw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2DWue/yOyVhhEJAQprPg/7B9v5WyXFM83+SlO6MkWjjFCXSm5MkRnO
1E0Wg/st9MEAipE5vawHR9WKO6A+6KEYo8DgcqHh2lFokr/PnE2KkxdOVDRzw0lv
HMy+E3VIivAYIBk7zNPoIu9q/gZASMTSkAWKEiDhFiSNQbjGpcdj+W+/7Y40efFp
ke/b1xTBg2g1Ol1Ie+DfisCx4ZS7G+qgY0EuIbCmgEm7FYhtRGslmu/OOJVW6WRf
XR29f0E3r5KsPiJ86ahG4TT202JLpry+NK29vlWB/V6JdnKFlZOzIJ84/x/Gb/dd
op083cHOhyvZdDaT1y+nkgGKk8UIdCDH/Vm0uoH1XFBZEwHjnH7gNb/6HFUPQEf8
+lM/YtzLsiAZ0s1agfdpxcte5oMooa8PeUGs74fOvfQnVb+Xxf3QNG2e2+5AbYJk
w2f0XLlWn0FiAUXRUZRKrl0XPWX1svxdbVWnzBGApkzRtwXqoc7FahIXwfqle+s+
rp4t6GskuIXF0TS+EjaD7jPuiqI/7Bc+Rv63Y8OjuWiRFQr99E+vuuCZiShEPPgH
ajd+38irh4tSgVIrB2EXqMfd5U+HkluStYbxWTEvyybqumdM6NmMCLqS0aEFiDc5
Es/vJmV1NDhbP58QQm+Mol4JNMz2kzoOksl2u1D+7kYZBazh7S953fRE9Fa4xu7M
+Jh60VDPWdI=
=wOGN
-----END PGP SIGNATURE-----

--=-rYK8UD9FFpU/LL1lpGBw--
