From: Stuart Hayes <Stuart_Hayes@dell.com>
Subject: Re: [PATCH] ide-scsi.c:  Fix tape drive block limits problem
Date: Wed, 10 Sep 2003 14:49:45 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0309101445080.28523-100000@humbolt.us.dell.com>
References: <CE41BFEF2481C246A8DE0D2B4DBACF4F128A13@ausx2kmpc106.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp14.us.dell.com ([143.166.85.137]:20456 "EHLO
	smtp14.us.dell.com") by vger.kernel.org with ESMTP id S265692AbTIJTtr
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 15:49:47 -0400
Received: from koskovpd.us.dell.com (koskovpd.us.dell.com [143.166.6.46])
	by smtp14.us.dell.com (8.12.9/8.12.9) with ESMTP id h8AJnaIm001861
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2003 14:49:36 -0500
Received: from humbolt.us.dell.com (insidelists.us.dell.com [10.9.160.254])
	by koskovpd.us.dell.com (8.8.8p2+Sun/8.8.8/Dell.IT.04.09.03) with ESMTP id OAA18812
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2003 14:49:46 -0500 (CDT)
In-Reply-To: <CE41BFEF2481C246A8DE0D2B4DBACF4F128A13@ausx2kmpc106.aus.amer.dell.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Resending with (hopefully) unmolested text.
--Stuart

On Wed, 10 Sep 2003, Hayes, Stuart wrote:

>=20
> IDE tape drives return "st0: Error with sense data: Current st09:00:
> sense key illegal request ... Additional sense indicates Invalid comm=
and
> operation code" error message when using drive.=A0 This occurs becaus=
e st.c
> tries to issue a "read block limits" SCSI command when opening the
> device.=A0 IDE tape drives are not required to support this command (=
SCSI
> tapes are), but IDE tapes do have to report the block sizes they supp=
ort
> (512 and/or 1024 bytes only) in mode page 0x2A.
>=20
> This patch looks for "read block limits" commands being sent to tape
> drives, and changes them into "mode sense" commands to read mode page
> 0x2A.=A0 The data that's returned is reformatted to look like the res=
ults
> of a "read block limits" command (it will return block limits of mini=
mum
> 512 (or 1024, if 512 isn't supported), maximum of 1024 (or 512, if 10=
24
> isn't supported), with a granularity of 9 (512 bytes).
>=20
> This patch is for kernel 2.4.22 (for ide-scsi.c ver 0.93).
>=20
> Thanks
> Stuart
> ---------------




diff -uNr linux-2.4.21-1.1931.2.421.ent/drivers/scsi/ide-scsi.c linux-2=
=2E4.21-1.1931.2.421.ent.idescsifix/drivers/scsi/ide-scsi.c
--- linux-2.4.21-1.1931.2.421.ent/drivers/scsi/ide-scsi.c	2003-09-02 16=
:52:26.000000000 -0500
+++ linux-2.4.21-1.1931.2.421.ent.idescsifix/drivers/scsi/ide-scsi.c	20=
03-09-09 11:16:51.000000000 -0500
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/scsi/ide-scsi.c	Version 0.93    June 10, 2002
+ * linux/drivers/scsi/ide-scsi.c	Version 0.94    Sept 09, 2003
  *
  * Copyright (C) 1996 - 1999 Gadi Oxman <gadio@netvision.net.il>
  * Copyright (C) 2001 - 2002 Andre Hedrick <andre@linux-ide.org>
@@ -35,9 +35,12 @@
  * Ver 0.92  Mar 21 02   Include DevFs support
  *                        Borsenkow Andrej <Andrej.Borsenkow@mow.sieme=
ns.ru>
  * Ver 0.93  Jun 10 02   Fix "off by one" error in transforms
+ * Ver 0.94  Sep 09 03   Added transform for reading ATAPI tape drive =
block
+ *                        limits (ATAPI tapes report block limits in m=
ode
+ *                        page 0x2A, not by "read block limits" comman=
d)
  */
=20
-#define IDESCSI_VERSION "0.93"
+#define IDESCSI_VERSION "0.94"
=20
 #include <linux/module.h>
 #include <linux/config.h>
@@ -234,6 +237,25 @@
 			pc->buffer_size +=3D 4;
 		}
 	}
+	if (drive->media =3D=3D ide_tape) {
+		if (sc[0] =3D=3D READ_BLOCK_LIMITS) {	/* IDE tapes have blk lmts in =
mode page 0x2a */
+			if (!scsi_buf)
+				return;
+			/* buffer size should be 6 for READ_BLOCK_LIMITS    */
+			/* we need 12 bytes (4 for header + 8 for mode page */
+			if ((atapi_buf =3D kmalloc(12, GFP_ATOMIC)) =3D=3D NULL)
+				return;
+			memset(atapi_buf, 0, 12);
+			memset (c, 0, 12);
+			c[0] =3D MODE_SENSE;
+			c[1] =3D 8;  	/* no block descriptors     */
+			c[2] =3D 0x2A;	/* mode page 0x2A           */
+			c[4] =3D 12;	/* buffer length 12 decimal */
+			pc->buffer =3D atapi_buf;
+			pc->request_transfer =3D 12;
+			pc->buffer_size =3D 12;
+		}
+	}
 }
=20
 static inline void idescsi_transform_pc2 (ide_drive_t *drive, idescsi_=
pc_t *pc)
@@ -262,7 +284,19 @@
 			/* response data format */
 			scsi_buf[3] =3D (scsi_buf[3] & 0xf0) | 2;
 		}
+	}=09
+	if (drive->media =3D=3D ide_tape) {
+		if (sc[0] =3D=3D READ_BLOCK_LIMITS) {
+			memset(scsi_buf, 0, pc->scsi_cmd->request_bufflen);
+			/* granularity of 9 (always 9 for ide tapes) */
+			scsi_buf[0] =3D 9;
+			/* block length of 1024 bytes supported? */
+			scsi_buf[2] =3D (atapi_buf[11] & 0x04) ? 4 : 2;
+			/* block length of 512 bytes supported?  */
+			scsi_buf[4] =3D (atapi_buf[11] & 0x02) ? 2 : 4;
+		}
 	}
+
 	if (atapi_buf && atapi_buf !=3D scsi_buf)
 		kfree(atapi_buf);
 }

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
