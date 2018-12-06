From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: aic7xxx: Use kmemdup instead of duplicating its function
Date: Thu, 6 Dec 2018 21:02:18 +0800
Message-ID: <20181206130218.19776-1-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

kmemdup has implemented the function that kmalloc() + memcpy().
We prefer to kmemdup rather than code opened implementation.

This issue was detected with the help of coccinelle.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Hannes Reinecke <hare@suse.com>
CC: "James E.J. Bottomley" <jejb@linux.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/aic7xxx/aic79xx=5Fcore.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx=5Fcore.c b/drivers/scsi/aic7xxx/a=
ic79xx=5Fcore.c
index 9ee75c9a9aa1..3e72fac6d248 100644
--- a/drivers/scsi/aic7xxx/aic79xx=5Fcore.c
+++ b/drivers/scsi/aic7xxx/aic79xx=5Fcore.c
@@ -9438,10 +9438,10 @@ ahd=5Floadseq(struct ahd=5Fsoftc *ahd)
 	if (cs=5Fcount !=3D 0) {
=20
 		cs=5Fcount *=3D sizeof(struct cs);
-		ahd->critical=5Fsections =3D kmalloc(cs=5Fcount, GFP=5FATOMIC);
+		ahd->critical=5Fsections =3D kmemdup(cs=5Ftable, cs=5Fcount,
+						GFP=5FATOMIC);
 		if (ahd->critical=5Fsections =3D=3D NULL)
 			panic("ahd=5Floadseq: Could not malloc");
-		memcpy(ahd->critical=5Fsections, cs=5Ftable, cs=5Fcount);
 	}
 	ahd=5Foutb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE);
=20
--=20
2.19.1
