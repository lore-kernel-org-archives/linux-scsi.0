From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: aic7xxx: Remove unnecessary NULL check before kfree
Date: Thu, 6 Dec 2018 12:37:49 +0800
Message-ID: <20181206043749.34535-1-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>, Alex Deucher <alexander.deucher@amd.com>
List-Id: linux-scsi@vger.kernel.org

kfree(NULL) is safe, so removes NULL check before freeing the mem.
This patch also fix the ifnullfree.cocci warnings.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Alex Deucher <alexander.deucher@amd.com>
CC: Hannes Reinecke <hare@suse.com>
CC: "James E.J. Bottomley" <jejb@linux.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/aic7xxx/aic79xx=5Fcore.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx=5Fcore.c b/drivers/scsi/aic7xxx/a=
ic79xx=5Fcore.c
index 9ee75c9a9aa1..090440f2ebed 100644
--- a/drivers/scsi/aic7xxx/aic79xx=5Fcore.c
+++ b/drivers/scsi/aic7xxx/aic79xx=5Fcore.c
@@ -3673,8 +3673,7 @@ ahd=5Ffree=5Ftstate(struct ahd=5Fsoftc *ahd, u=5Fint =
scsi=5Fid, char channel, int force)
 		return;
=20
 	tstate =3D ahd->enabled=5Ftargets[scsi=5Fid];
-	if (tstate !=3D NULL)
-		kfree(tstate);
+	kfree(tstate);
 	ahd->enabled=5Ftargets[scsi=5Fid] =3D NULL;
 }
 #endif
@@ -6136,8 +6135,7 @@ ahd=5Fset=5Funit(struct ahd=5Fsoftc *ahd, int unit)
 void
 ahd=5Fset=5Fname(struct ahd=5Fsoftc *ahd, char *name)
 {
-	if (ahd->name !=3D NULL)
-		kfree(ahd->name);
+	kfree(ahd->name);
 	ahd->name =3D name;
 }
=20
@@ -6198,12 +6196,9 @@ ahd=5Ffree(struct ahd=5Fsoftc *ahd)
 		kfree(ahd->black=5Fhole);
 	}
 #endif
-	if (ahd->name !=3D NULL)
-		kfree(ahd->name);
-	if (ahd->seep=5Fconfig !=3D NULL)
-		kfree(ahd->seep=5Fconfig);
-	if (ahd->saved=5Fstack !=3D NULL)
-		kfree(ahd->saved=5Fstack);
+	kfree(ahd->name);
+	kfree(ahd->seep=5Fconfig);
+	kfree(ahd->saved=5Fstack);
 #ifndef =5F=5FFreeBSD=5F=5F
 	kfree(ahd);
 #endif
--=20
2.19.1
