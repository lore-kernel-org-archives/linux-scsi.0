From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: wd719x: Fix sleeping under a spinlock
Date: Wed, 5 Dec 2018 12:21:44 +0800
Message-ID: <20181205042144.14174-1-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>
List-Id: linux-scsi@vger.kernel.org

Currently, dma=5Falloc=5Fcoherent is being called with a GFP=5FKERNEL
flag which allows it to sleep with a spinlock held.
The call tree is:
wd719x=5Fhost=5Freset() holds wd->sh->host=5Flock
    -> wd719x=5Fchip=5Finit()
        -> dma=5Falloc=5Fcoherent() uses GFP=5FKERNEL

This patch introduces a can=5Fsleep parameter into
the wd719x=5Fchip=5Finit() function. When we have spinlock and
can't sleep, we pass in 0; in other cases, we pass in 1.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: "James E.J. Bottomley" <jejb@linux.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/wd719x.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 808ba8e952db..e1dac0115947 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -289,7 +289,7 @@ static int wd719x=5Fqueuecommand(struct Scsi=5FHost *sh=
, struct scsi=5Fcmnd *cmd)
 	return 0;
 }
=20
-static int wd719x=5Fchip=5Finit(struct wd719x *wd)
+static int wd719x=5Fchip=5Finit(struct wd719x *wd, int can=5Fsleep)
 {
 	int i, ret;
 	u32 risc=5Finit[3];
@@ -318,7 +318,8 @@ static int wd719x=5Fchip=5Finit(struct wd719x *wd)
=20
 	if (!wd->fw=5Fvirt)
 		wd->fw=5Fvirt =3D dma=5Falloc=5Fcoherent(&wd->pdev->dev, wd->fw=5Fsize,
-						 &wd->fw=5Fphys, GFP=5FKERNEL);
+						 &wd->fw=5Fphys, can=5Fsleep ?
+						 GFP=5FKERNEL : GFP=5FATOMIC);
 	if (!wd->fw=5Fvirt) {
 		ret =3D -ENOMEM;
 		goto wd719x=5Finit=5Fend;
@@ -510,7 +511,7 @@ static int wd719x=5Fhost=5Freset(struct scsi=5Fcmnd *cm=
d)
 	dev=5Finfo(&wd->pdev->dev, "host reset requested\n");
 	spin=5Flock=5Firqsave(wd->sh->host=5Flock, flags);
 	/* Try to reinit the RISC */
-	if (wd719x=5Fchip=5Finit(wd) =3D=3D 0)
+	if (wd719x=5Fchip=5Finit(wd, 0) =3D=3D 0)
 		result =3D SUCCESS;
 	else
 		result =3D FAILED;
@@ -834,7 +835,7 @@ static int wd719x=5Fboard=5Ffound(struct Scsi=5FHost *s=
h)
 	/* read parameters from EEPROM */
 	wd719x=5Fread=5Feeprom(wd);
=20
-	ret =3D wd719x=5Fchip=5Finit(wd);
+	ret =3D wd719x=5Fchip=5Finit(wd, 1);
 	if (ret)
 		goto fail=5Ffree=5Firq;
=20
--=20
2.19.1
