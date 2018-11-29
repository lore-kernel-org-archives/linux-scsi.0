From: Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH] scsi: Fix bad alignments
Date: Thu, 29 Nov 2018 11:18:55 +0800
Message-ID: <20181129031855.18701-1-wen.yang99@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhong.weidong@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>, Julia Lawall <julia.lawall@lip6.fr>, Willem Riede <osst@riede.org>, Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

As reported by cocinelle:

drivers/scsi/sym53c8xx=5F2/sym=5Fhipd.c:5411:1-49: code aligned with follow=
ing code on line 5418
drivers/scsi/osst.c:4701:3-9: code aligned with following code on line 4703
drivers/scsi/osst.c:4206:3-17: code aligned with following code on line 4207
drivers/scsi/osst.c:5570:2-25: code aligned with following code on line 5571
drivers/scsi/osst.c:5572:2-59: code aligned with following code on line 5573
drivers/scsi/osst.c:5574:2-42: code aligned with following code on line 5575
drivers/scsi/megaraid/megaraid=5Fsas=5Fbase.c:1825:2-59: code aligned with =
following code on line 1827

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
CC: Julia Lawall <julia.lawall@lip6.fr>
CC: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Willem Riede <osst@riede.org>
CC: Kashyap Desai <kashyap.desai@broadcom.com>
CC: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
CC: linux-scsi@vger.kernel.org
CC: linux-kernel@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid=5Fsas=5Fbase.c |  3 ++-
 drivers/scsi/osst.c                       | 10 +++++-----
 drivers/scsi/sym53c8xx=5F2/sym=5Fhipd.c       |  8 ++++----
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid=5Fsas=5Fbase.c b/drivers/scsi/m=
egaraid/megaraid=5Fsas=5Fbase.c
index 9b90c716f06d..e00b44babb28 100644
--- a/drivers/scsi/megaraid/megaraid=5Fsas=5Fbase.c
+++ b/drivers/scsi/megaraid/megaraid=5Fsas=5Fbase.c
@@ -1822,7 +1822,8 @@ void megasas=5Fset=5Fdynamic=5Ftarget=5Fproperties(st=
ruct scsi=5Fdevice *sdev,
 		raid =3D MR=5FLdRaidGet(ld, local=5Fmap=5Fptr);
=20
 		if (raid->capability.ldPiMode =3D=3D MR=5FPROT=5FINFO=5FTYPE=5FCONTROLLE=
R)
-		blk=5Fqueue=5Fupdate=5Fdma=5Falignment(sdev->request=5Fqueue, 0x7);
+			blk=5Fqueue=5Fupdate=5Fdma=5Falignment(
+					sdev->request=5Fqueue, 0x7);
=20
 		mr=5Fdevice=5Fpriv=5Fdata->is=5Ftm=5Fcapable =3D
 			raid->capability.tmCapable;
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 7a1a1edde35d..bbf8e60dbb04 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4698,7 +4698,7 @@ static int =5F=5Fos=5Fscsi=5Ftape=5Fopen(struct inode=
 * inode, struct file * filp)
 						    STp->timeout, MAX=5FRETRIES, 1);
 			if ((SRpnt->sense[0] & 0x70) !=3D 0x70 ||
 			    (SRpnt->sense[2] & 0x0f) =3D=3D NOT=5FREADY)
-			break;
+				break;
=20
 			if ((SRpnt->sense[2] & 0x0f) =3D=3D UNIT=5FATTENTION) {
 				int j;
@@ -5567,13 +5567,13 @@ static int osst=5Fcopy=5Ffrom=5Fbuffer(struct osst=
=5Fbuffer *st=5Fbp, unsigned char *ptr)
 static void validate=5Foptions (void)
 {
   if (max=5Fdev > 0)
-		osst=5Fmax=5Fdev =3D max=5Fdev; =20
+	osst=5Fmax=5Fdev =3D max=5Fdev;
   if (write=5Fthreshold=5Fkbs > 0)
-		osst=5Fwrite=5Fthreshold =3D write=5Fthreshold=5Fkbs * ST=5FKILOBYTE;
+	osst=5Fwrite=5Fthreshold =3D write=5Fthreshold=5Fkbs * ST=5FKILOBYTE;
   if (osst=5Fwrite=5Fthreshold > osst=5Fbuffer=5Fsize)
-		osst=5Fwrite=5Fthreshold =3D osst=5Fbuffer=5Fsize;
+	osst=5Fwrite=5Fthreshold =3D osst=5Fbuffer=5Fsize;
   if (max=5Fsg=5Fsegs >=3D OSST=5FFIRST=5FSG)
-		osst=5Fmax=5Fsg=5Fsegs =3D max=5Fsg=5Fsegs;
+	osst=5Fmax=5Fsg=5Fsegs =3D max=5Fsg=5Fsegs;
 #if DEBUG
   printk(OSST=5FDEB=5FMSG "osst :D: max tapes %d, write threshold %d, max =
s/g segs %d.\n",
 			   osst=5Fmax=5Fdev, osst=5Fwrite=5Fthreshold, osst=5Fmax=5Fsg=5Fsegs);
diff --git a/drivers/scsi/sym53c8xx=5F2/sym=5Fhipd.c b/drivers/scsi/sym53c8=
xx=5F2/sym=5Fhipd.c
index 0a2a54517b15..29be0f4e8bd6 100644
--- a/drivers/scsi/sym53c8xx=5F2/sym=5Fhipd.c
+++ b/drivers/scsi/sym53c8xx=5F2/sym=5Fhipd.c
@@ -5407,8 +5407,8 @@ void sym=5Fcomplete=5Ferror(struct sym=5Fhcb *np, str=
uct sym=5Fccb *cp)
 		cp->sv=5Fresid =3D 0;
 	}
 #ifdef DEBUG=5F2=5F0=5FX
-if (resid)
-	printf("XXXX RESID=3D %d - 0x%x\n", resid, resid);
+	if (resid)
+		printf("XXXX RESID=3D %d - 0x%x\n", resid, resid);
 #endif
=20
 	/*
@@ -5531,8 +5531,8 @@ void sym=5Fcomplete=5Fok (struct sym=5Fhcb *np, struc=
t sym=5Fccb *cp)
 	if (!SYM=5FSETUP=5FRESIDUAL=5FSUPPORT)
 		resid  =3D 0;
 #ifdef DEBUG=5F2=5F0=5FX
-if (resid)
-	printf("XXXX RESID=3D %d - 0x%x\n", resid, resid);
+	if (resid)
+		printf("XXXX RESID=3D %d - 0x%x\n", resid, resid);
 #endif
=20
 	/*
--=20
2.19.1
