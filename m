From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [patch 5/8] mptfusion: command line parameters
Date: Fri, 19 Nov 2004 08:38:47 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C5468AC@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C4CE4D.DC496E20"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:30144 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261464AbUKSQMJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 11:12:09 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id iAJGAUcq006801
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:10:30 -0800 (PST)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id iAJGC70X030499
	for <linux-scsi@vger.kernel.org>; Fri, 19 Nov 2004 08:12:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C4CE4D.DC496E20
Content-Type: text/plain;
	charset="iso-8859-1"

This cleans up the command line parameters
with individual parameters and descriptions.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>






------_=_NextPart_000_01C4CE4D.DC496E20
Content-Type: application/octet-stream;
	name="mptfusion-5.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mptfusion-5.patch"

diff -uarN b/drivers/message/fusion/mptscsih.c =
a/drivers/message/fusion/mptscsih.c=0A=
--- b/drivers/message/fusion/mptscsih.c	2004-11-18 12:56:39.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.c	2004-11-18 14:54:27.000000000 =
-0700=0A=
@@ -96,10 +96,22 @@=0A=
 MODULE_DESCRIPTION(my_NAME);=0A=
 MODULE_LICENSE("GPL");=0A=
 =0A=
-/* Set string for command line args from insmod */=0A=
 #ifdef MODULE=0A=
-char *mptscsih =3D NULL;=0A=
-module_param(mptscsih, charp, 0);=0A=
+static int dv =3D MPTSCSIH_DOMAIN_VALIDATION;=0A=
+module_param(dv, int, 0);=0A=
+MODULE_PARM_DESC(dv, "DV Algorithm: enhanced =3D 1, basic =3D 0 =
(default=3DMPTSCSIH_DOMAIN_VALIDATION=3D1)");=0A=
+=0A=
+static int width =3D MPTSCSIH_MAX_WIDTH;=0A=
+module_param(width, int, 0);=0A=
+MODULE_PARM_DESC(width, "Max Bus Width: wide =3D 1, narrow =3D 0 =
(default=3DMPTSCSIH_MAX_WIDTH=3D1)");=0A=
+=0A=
+static ushort factor =3D MPTSCSIH_MIN_SYNC;=0A=
+module_param(factor, ushort, 0);=0A=
+MODULE_PARM_DESC(factor, "Min Sync Factor: =
(default=3DMPTSCSIH_MIN_SYNC=3D0x08)");=0A=
+=0A=
+static int saf_te =3D MPTSCSIH_SAF_TE;=0A=
+module_param(saf_te, int, 0);=0A=
+MODULE_PARM_DESC(saf_te, "Force enabling SEP Processor: =
(default=3DMPTSCSIH_SAF_TE=3D0)");=0A=
 #endif=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -200,9 +212,6 @@=0A=
 static void	mptscsih_dv_parms(MPT_SCSI_HOST *hd, DVPARAMETERS *dv,void =
*pPage);=0A=
 static void	mptscsih_fillbuf(char *buffer, int size, int index, int =
width);=0A=
 #endif=0A=
-#ifdef MODULE=0A=
-static int	mptscsih_setup(char *str);=0A=
-#endif=0A=
 /* module entry point */=0A=
 static int  __init   mptscsih_init  (void);=0A=
 static void __exit   mptscsih_exit  (void);=0A=
@@ -245,11 +254,9 @@=0A=
 static int scandv_wait_done =3D 1;=0A=
 =0A=
 =0A=
-/* Driver default setup=0A=
+/* Driver command line structure=0A=
  */=0A=
-static struct mptscsih_driver_setup=0A=
-	driver_setup =3D MPTSCSIH_DRIVER_SETUP;=0A=
-=0A=
+static struct mptscsih_driver_setup driver_setup;=0A=
 static struct scsi_host_template driver_template;=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
@@ -1242,9 +1249,9 @@=0A=
 		}=0A=
 =0A=
 		if (ioc->spi_data.minSyncFactor <=0A=
-		  driver_setup.min_sync_fac) {=0A=
+		  driver_setup.min_sync_factor) {=0A=
 			ioc->spi_data.minSyncFactor =3D=0A=
-			  driver_setup.min_sync_fac;=0A=
+			  driver_setup.min_sync_factor;=0A=
 		}=0A=
 =0A=
 		if (ioc->spi_data.minSyncFactor =3D=3D MPT_ASYNC) {=0A=
@@ -1271,7 +1278,7 @@=0A=
 			"dv %x width %x factor %x saf_te %x\n",=0A=
 			ioc->name, driver_setup.dv,=0A=
 			driver_setup.max_width,=0A=
-			driver_setup.min_sync_fac,=0A=
+			driver_setup.min_sync_factor,=0A=
 			driver_setup.saf_te));=0A=
 	}=0A=
 =0A=
@@ -1489,9 +1496,15 @@=0A=
 	}=0A=
 =0A=
 #ifdef MODULE=0A=
-	/* Evaluate the command line arguments, if any */=0A=
-	if (mptscsih)=0A=
-		mptscsih_setup(mptscsih);=0A=
+	dinitprintk((KERN_INFO MYNAM=0A=
+		": Command Line Args: dv=3D%d max_width=3D%d "=0A=
+		"factor=3D0x%x saf_te=3D%d\n",=0A=
+		dv, width, factor, saf_te));=0A=
+=0A=
+	driver_setup.dv =3D (dv) ? 1 : 0;=0A=
+	driver_setup.max_width =3D (width) ? 1 : 0;=0A=
+	driver_setup.min_sync_factor =3D factor;=0A=
+	driver_setup.saf_te =3D (saf_te) ? 1 : 0;;=0A=
 #endif=0A=
 =0A=
 	if(mpt_device_driver_register(&mptscsih_driver,=0A=
@@ -2943,7 +2956,7 @@=0A=
 =0A=
 		/* 4. Renegotiate to all devices, if SCSI=0A=
 		 */=0A=
-		if (hd->ioc->bus_type =3D=3D SCSI) {=0A=
+		if (ioc->bus_type =3D=3D SCSI) {=0A=
 			dnegoprintk(("writeSDP1: ALL_IDS USE_NVRAM\n"));=0A=
 			mptscsih_writeSDP1(hd, 0, 0, MPT_SCSICFG_ALL_IDS | =
MPT_SCSICFG_USE_NVRAM);=0A=
 		}=0A=
@@ -6074,107 +6087,6 @@=0A=
 #endif /* ~MPTSCSIH_ENABLE_DOMAIN_VALIDATION */=0A=
 =0A=
 =
/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-/* Commandline Parsing routines and defines.=0A=
- *=0A=
- * insmod format:=0A=
- *	insmod mptscsih mptscsih=3D"width:1 dv:n factor:0x09 saf-te:1"=0A=
- *  boot format:=0A=
- *	mptscsih=3Dwidth:1,dv:n,factor:0x8,saf-te:1=0A=
- *=0A=
- */=0A=
-#ifdef MODULE=0A=
-#define	ARG_SEP	' '=0A=
-#else=0A=
-#define	ARG_SEP	','=0A=
-#endif=0A=
-=0A=
-#ifdef MODULE=0A=
-static char setup_token[] __initdata =3D=0A=
-	"dv:"=0A=
-	"width:"=0A=
-	"factor:"=0A=
-	"saf-te:"=0A=
-       ;	/* DO NOT REMOVE THIS ';' */=0A=
-#endif=0A=
-       =0A=
-#define OPT_DV			1=0A=
-#define OPT_MAX_WIDTH		2=0A=
-#define OPT_MIN_SYNC_FACTOR	3=0A=
-#define OPT_SAF_TE		4=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
*/=0A=
-#ifdef MODULE=0A=
-static int=0A=
-get_setup_token(char *p)=0A=
-{=0A=
-	char *cur =3D setup_token;=0A=
-	char *pc;=0A=
-	int i =3D 0;=0A=
-=0A=
-	while (cur !=3D NULL && (pc =3D strchr(cur, ':')) !=3D NULL) {=0A=
-		++pc;=0A=
-		++i;=0A=
-		if (!strncmp(p, cur, pc - cur))=0A=
-			return i;=0A=
-		cur =3D pc;=0A=
-	}=0A=
-	return 0;=0A=
-}=0A=
-=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
*/=0A=
-static int=0A=
-mptscsih_setup(char *str)=0A=
-{=0A=
-	char *cur =3D str;=0A=
-	char *pc, *pv;=0A=
-	unsigned long val;=0A=
-	int  c;=0A=
-=0A=
-	while (cur !=3D NULL && (pc =3D strchr(cur, ':')) !=3D NULL) {=0A=
-		char *pe;=0A=
-=0A=
-		val =3D 0;=0A=
-		pv =3D pc;=0A=
-		c =3D *++pv;=0A=
-=0A=
-		if	(c =3D=3D 'n')=0A=
-			val =3D 0;=0A=
-		else if	(c =3D=3D 'y')=0A=
-			val =3D 1;=0A=
-		else=0A=
-			val =3D (int) simple_strtoul(pv, &pe, 0);=0A=
-=0A=
-		printk("Found Token: %s, value %x\n", cur, (int)val);=0A=
-		switch (get_setup_token(cur)) {=0A=
-		case OPT_DV:=0A=
-			driver_setup.dv =3D val;=0A=
-			break;=0A=
-=0A=
-		case OPT_MAX_WIDTH:=0A=
-			driver_setup.max_width =3D val;=0A=
-			break;=0A=
-=0A=
-		case OPT_MIN_SYNC_FACTOR:=0A=
-			driver_setup.min_sync_fac =3D val;=0A=
-			break;=0A=
-=0A=
-		case OPT_SAF_TE:=0A=
-			driver_setup.saf_te =3D val;=0A=
-			break;=0A=
-=0A=
-		default:=0A=
-			printk("mptscsih_setup: unexpected boot option '%.*s' ignored\n", =
(int)(pc-cur+1), cur);=0A=
-			break;=0A=
-		}=0A=
-=0A=
-		if ((cur =3D strchr(cur, ARG_SEP)) !=3D NULL)=0A=
-			++cur;=0A=
-	}=0A=
-	return 1;=0A=
-}=0A=
-#endif=0A=
-/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/=0A=
-=0A=
 =0A=
 module_init(mptscsih_init);=0A=
 module_exit(mptscsih_exit);=0A=
diff -uarN b/drivers/message/fusion/mptscsih.h =
a/drivers/message/fusion/mptscsih.h=0A=
--- b/drivers/message/fusion/mptscsih.h	2004-11-17 16:24:38.000000000 =
-0700=0A=
+++ a/drivers/message/fusion/mptscsih.h	2004-11-18 12:10:00.000000000 =
-0700=0A=
@@ -95,17 +95,8 @@=0A=
 {=0A=
         u8      dv;=0A=
         u8      max_width;=0A=
-        u8      min_sync_fac;=0A=
+        u8      min_sync_factor;=0A=
         u8      saf_te;=0A=
 };=0A=
 =0A=
-=0A=
-#define MPTSCSIH_DRIVER_SETUP                   \=0A=
-{                                               \=0A=
-        MPTSCSIH_DOMAIN_VALIDATION,             \=0A=
-        MPTSCSIH_MAX_WIDTH,                     \=0A=
-        MPTSCSIH_MIN_SYNC,                      \=0A=
-        MPTSCSIH_SAF_TE,                        \=0A=
-}=0A=
-=0A=
 #endif=0A=

------_=_NextPart_000_01C4CE4D.DC496E20--
