From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH RESEND] [SCSI] aic94xx: Remove broken fallback for missing
 'Ctrl-A' user settings
Date: Sun, 08 Jun 2014 23:37:44 +0100
Message-ID: <1402267064.23860.42.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cTjoiiYPmxdb5SvS/Foy"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41518 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753707AbaFHWhu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jun 2014 18:37:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


--=-cTjoiiYPmxdb5SvS/Foy
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
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-cTjoiiYPmxdb5SvS/Foy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5TluOe/yOyVhhEJAQpzig/+J/JffNH99Rh9NtcoE1gQskHQZDVlENHU
atG2SZ5fooZQCwYMyOf7ipI6HrFoXkWoLllsum7hyhgJ2pWYwwhPNeylyccGlCAj
KnCt/s7Pyrvb0If5og09VDp0uKXesDOFain5sOpML5U8HfU8z7uK57cjEViF/IDl
A3hRqfzopSuPu6RySbcJNPZNukMlK78qVwm9laLXTXIw+t6L4PzUBh+w8lfLHQxZ
t+EL2urVucTdH8GbbmeS7r1lGhAH/0faS306Znc3cHlORuMzhPOfN+Nzf23tpql4
GC7RXOVHp5eN/nCY3JCS6MD20sj+4w8v9jPPxFZRWfITZNiB5mUpmmmkqZHizAtV
kADoC0/Txnu1ljNNHGrafWQfg2K5jZggcNcnUKpAns09G7tP18fkbWsy+9q8NV91
UfKCR/0uYkpX6bAbajlXd1yjnoX+iUaKtZmotuVHwKrKflHMFGLPYGBM61zWvmG6
4hfuwUEedLc25f+//rO2JVGri25jZeBHlkRF56b3FcON9pMSB3QSsLHdVe2p0F9W
8wHouokTH6N9KopGwZPv2LQAeSqUuRktbxRZsbtVMf3R5GCuWFsi56PBzXa3Njrq
ztDosZP1UxXEil6NnIaltYZJybnWJxu+LHDhP7fdq9jo4hgQ0eHeRYTUjx2HRAfl
1S7OftdjxBs=
=PYbG
-----END PGP SIGNATURE-----

--=-cTjoiiYPmxdb5SvS/Foy--
