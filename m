From: Quentin Deslandes <quentin.deslandes@itdev.co.uk>
Subject: [PATCH] scsi: aic79xx: NULL check before some freeing functions is
 not needed.
Date: Thu, 28 Mar 2019 13:11:04 +0000
Message-ID: <20190328131101.GA21866@qd-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <3F4A414268EA46479089CFBFC4E9A5A0@eurprd08.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Fix the following coccinelle warning by removing NULL check before
calling kfree:

NULL check before some freeing functions is not needed.

Signed-off-by: Quentin Deslandes <quentin.deslandes@itdev.co.uk>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic=
79xx_core.c
index 7e5044bf05c0..a61022db43ee 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3664,8 +3664,6 @@ ahd_alloc_tstate(struct ahd_softc *ahd, u_int scsi_id=
, char channel)
 static void
 ahd_free_tstate(struct ahd_softc *ahd, u_int scsi_id, char channel, int fo=
rce)
 {
-	struct ahd_tmode_tstate *tstate;
-
 	/*
 	 * Don't clean up our "master" tstate.
 	 * It has our default user settings.
@@ -3674,9 +3672,7 @@ ahd_free_tstate(struct ahd_softc *ahd, u_int scsi_id,=
 char channel, int force)
 	 && force =3D=3D FALSE)
 		return;
=20
-	tstate =3D ahd->enabled_targets[scsi_id];
-	if (tstate !=3D NULL)
-		kfree(tstate);
+	kfree(ahd->enabled_targets[scsi_id]);
 	ahd->enabled_targets[scsi_id] =3D NULL;
 }
 #endif
@@ -6138,8 +6134,7 @@ ahd_set_unit(struct ahd_softc *ahd, int unit)
 void
 ahd_set_name(struct ahd_softc *ahd, char *name)
 {
-	if (ahd->name !=3D NULL)
-		kfree(ahd->name);
+	kfree(ahd->name);
 	ahd->name =3D name;
 }
=20
@@ -6200,12 +6195,9 @@ ahd_free(struct ahd_softc *ahd)
 		kfree(ahd->black_hole);
 	}
 #endif
-	if (ahd->name !=3D NULL)
-		kfree(ahd->name);
-	if (ahd->seep_config !=3D NULL)
-		kfree(ahd->seep_config);
-	if (ahd->saved_stack !=3D NULL)
-		kfree(ahd->saved_stack);
+	kfree(ahd->name);
+	kfree(ahd->seep_config);
+	kfree(ahd->saved_stack);
 #ifndef __FreeBSD__
 	kfree(ahd);
 #endif
--=20
2.17.1
