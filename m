From: "Stephens, Larry" <larry.stephens@lsil.com>
Subject: Sym53c8xx_2 Odd Byte Data Transfer patches
Date: Mon, 9 May 2005 06:16:48 -0600
Message-ID: <91888D455306F94EBD4D168954A9457C013519A0@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_000_01C55490.F9720470"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:13269 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261324AbVEIMQz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 May 2005 08:16:55 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j49CDgo7029271
	for <linux-scsi@vger.kernel.org>; Mon, 9 May 2005 05:13:42 -0700 (PDT)
Received: from nacos172.ad.lsil.com (cos1.co.lsil.com [172.21.35.122])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id j49CGnS8012566
	for <linux-scsi@vger.kernel.org>; Mon, 9 May 2005 05:16:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Linux-Scsi@Vger. Kernel. Org (E-mail)" <linux-scsi@vger.kernel.org>

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_000_01C55490.F9720470
Content-Type: text/plain;
	charset="iso-8859-1"


> These changes fix a problem with odd byte data transfers to a wide device
> (16 bits) in the LSI sym53c8xx_2 driver.  This issue is primarily seen
> only with tape drives although the code doesn't restrict the fix to any
> particular device.
> 
> These changes are nearly identical to those made in the sym53c8xx driver
> over a year ago.
> 
> The changed driver has been checked out by the LSI Logic developer and by
> the customer who requested that the sym53c8xx_2 be updated for the odd
> byte data transfer problem.  
> 
> File 2.4_sym53c8xx_2.2.1.18.patch is the patch file for the 2.4 kernel
> driver.  That driver version number has been bumped to 2.1.18.
> 
> File 2.6_sym53c8xx_2.2.2.1.patch is the patch file for the 2.6 kernel
> driver.  That driver version  number has been bumped to 2.2.1.
> 
> Thank you for accepting this request.  Please let us know if you need
> additional information.
> 
>  <<2.4_sym53c8xx_2.2.1.18.patch>>  <<2.6_sym53c8xx_2.2.2.1.patch>> 

------_=_NextPart_000_01C55490.F9720470
Content-Type: application/octet-stream;
	name="2.4_sym53c8xx_2.2.1.18.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="2.4_sym53c8xx_2.2.1.18.patch"

diff -uarN b/drivers/scsi/sym53c8xx_2/sym_glue.c =
a/drivers/scsi/sym53c8xx_2/sym_glue.c=0A=
--- b/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-04-28 09:15:21.000000000 =
-0500=0A=
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-04-28 09:15:50.000000000 =
-0500=0A=
@@ -627,13 +627,22 @@=0A=
 {=0A=
 	struct sym_tblmove *data =3D &cp->phys.data[SYM_CONF_MAX_SG-1];=0A=
 	int segment;=0A=
+	unsigned int len =3D cmd->request_bufflen;=0A=
 =0A=
-	cp->data_len =3D cmd->request_bufflen;=0A=
-=0A=
-	if (cmd->request_bufflen) {=0A=
+	if (len) {=0A=
 		bus_addr_t baddr =3D map_scsi_single_data(np, cmd);=0A=
 		if (baddr) {=0A=
-			sym_build_sge(np, data, baddr, cmd->request_bufflen);=0A=
+			if ( len & 0x01 )  /* odd # of bytes? */=0A=
+			{=0A=
+				tcb_p tp =3D &np->target[cp->target];=0A=
+				if (tp->head.wval & EWS)  /* negotiated wide? */=0A=
+				{=0A=
+					len++;=0A=
+					cp->odd_byte_adjustment++;=0A=
+				}=0A=
+			}=0A=
+			cp->data_len =3D len;=0A=
+			sym_build_sge(np, data, baddr, len);=0A=
 			segment =3D 1;=0A=
 		}=0A=
 		else=0A=
@@ -665,6 +674,16 @@=0A=
 		for (segment =3D 0; segment < use_sg; segment++) {=0A=
 			bus_addr_t baddr =3D bus_sg_dma_address(&scatter[segment]);=0A=
 			unsigned int len =3D bus_sg_dma_len(&scatter[segment]);=0A=
+			if ( len & 0x01 )  /* odd # of bytes? */=0A=
+			{=0A=
+				tcb_p tp =3D &np->target[cp->target];=0A=
+				if (tp->head.wval & EWS)  /* negotiated wide? */=0A=
+				{=0A=
+					len++;=0A=
+					cp->odd_byte_adjustment++;=0A=
+				}=0A=
+			}=0A=
+=0A=
 =0A=
 			sym_build_sge(np, &data[segment], baddr, len);=0A=
 			cp->data_len +=3D len;=0A=
diff -uarN b/drivers/scsi/sym53c8xx_2/sym_hipd.c =
a/drivers/scsi/sym53c8xx_2/sym_hipd.c=0A=
--- b/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-04-28 09:15:21.000000000 =
-0500=0A=
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-04-28 09:15:50.000000000 =
-0500=0A=
@@ -50,7 +50,7 @@=0A=
  * SUCH DAMAGE.=0A=
  */=0A=
 =0A=
-#define SYM_DRIVER_NAME	"sym-2.1.17a"=0A=
+#define SYM_DRIVER_NAME	"sym-2.1.18"=0A=
 =0A=
 #ifdef __FreeBSD__=0A=
 #include <dev/sym/sym_glue.h>=0A=
@@ -3921,6 +3921,8 @@=0A=
 		resid +=3D (tmp & 0xffffff);=0A=
 	}=0A=
 =0A=
+	resid -=3D cp->odd_byte_adjustment;=0A=
+=0A=
 	/*=0A=
 	 *  Hopefully, the result is not too wrong.=0A=
 	 */=0A=
@@ -4828,7 +4830,7 @@=0A=
 	/*=0A=
 	 *  Remember all informations needed to free this CCB.=0A=
 	 */=0A=
-	cp->to_abort =3D 0;=0A=
+	cp->to_abort =3D cp->odd_byte_adjustment =3D 0;=0A=
 	cp->tag	   =3D tag;=0A=
 	cp->order  =3D tag_order;=0A=
 	cp->target =3D tn;=0A=
diff -uarN b/drivers/scsi/sym53c8xx_2/sym_hipd.h =
a/drivers/scsi/sym53c8xx_2/sym_hipd.h=0A=
--- b/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-04-28 09:15:21.000000000 =
-0500=0A=
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-04-28 09:15:50.000000000 =
-0500=0A=
@@ -862,6 +862,7 @@=0A=
 				/*  NO_TAG means no tag		*/=0A=
 	u_char	target;=0A=
 	u_char	lun;=0A=
+	u_char	odd_byte_adjustment;=0A=
 	ccb_p	link_ccbh;	/* Host adapter CCB hash chain	*/=0A=
 	SYM_QUEHEAD=0A=
 		link_ccbq;	/* Link to free/busy CCB queue	*/=0A=

------_=_NextPart_000_01C55490.F9720470
Content-Type: application/octet-stream;
	name="2.6_sym53c8xx_2.2.2.1.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="2.6_sym53c8xx_2.2.2.1.patch"

diff -uarN b/drivers/scsi/sym53c8xx_2/sym_defs.h =
a/drivers/scsi/sym53c8xx_2/sym_defs.h=0A=
--- b/drivers/scsi/sym53c8xx_2/sym_defs.h	2005-04-28 14:32:32.000000000 =
-0500=0A=
+++ a/drivers/scsi/sym53c8xx_2/sym_defs.h	2005-04-28 10:19:14.000000000 =
-0500=0A=
@@ -40,7 +40,7 @@=0A=
 #ifndef SYM_DEFS_H=0A=
 #define SYM_DEFS_H=0A=
 =0A=
-#define SYM_VERSION "2.2.0"=0A=
+#define SYM_VERSION "2.2.1"=0A=
 #define SYM_DRIVER_NAME	"sym-" SYM_VERSION=0A=
 =0A=
 /*=0A=
diff -uarN b/drivers/scsi/sym53c8xx_2/sym_glue.c =
a/drivers/scsi/sym53c8xx_2/sym_glue.c=0A=
--- b/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-04-28 14:32:32.000000000 =
-0500=0A=
+++ a/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-04-28 14:29:53.000000000 =
-0500=0A=
@@ -389,13 +389,22 @@=0A=
 {=0A=
 	struct sym_tblmove *data =3D &cp->phys.data[SYM_CONF_MAX_SG-1];=0A=
 	int segment;=0A=
+	unsigned int len =3D cmd->request_bufflen;=0A=
 =0A=
-	cp->data_len =3D cmd->request_bufflen;=0A=
-=0A=
-	if (cmd->request_bufflen) {=0A=
+	if (len) {=0A=
 		dma_addr_t baddr =3D map_scsi_single_data(np, cmd);=0A=
 		if (baddr) {=0A=
-			sym_build_sge(np, data, baddr, cmd->request_bufflen);=0A=
+			if ( len & 0x01 )  /* odd # of bytes? */=0A=
+			{=0A=
+				struct sym_tcb *tp =3D &np->target[cp->target];=0A=
+				if (tp->head.wval & EWS)  /* negotiated wide? */=0A=
+				{=0A=
+					len++;=0A=
+					cp->odd_byte_adjustment++;=0A=
+				}=0A=
+			}=0A=
+			cp->data_len =3D len;=0A=
+			sym_build_sge(np, data, baddr, len);=0A=
 			segment =3D 1;=0A=
 		} else {=0A=
 			segment =3D -2;=0A=
@@ -430,6 +439,15 @@=0A=
 		for (segment =3D 0; segment < use_sg; segment++) {=0A=
 			dma_addr_t baddr =3D sg_dma_address(&scatter[segment]);=0A=
 			unsigned int len =3D sg_dma_len(&scatter[segment]);=0A=
+			if ( len & 0x01 )  /* odd # of bytes? */=0A=
+			{=0A=
+				struct sym_tcb *tp =3D &np->target[cp->target];=0A=
+				if (tp->head.wval & EWS)  /* negotiated wide? */=0A=
+				{=0A=
+					len++;=0A=
+					cp->odd_byte_adjustment++;=0A=
+				}=0A=
+			}=0A=
 =0A=
 			sym_build_sge(np, &data[segment], baddr, len);=0A=
 			cp->data_len +=3D len;=0A=
diff -uarN b/drivers/scsi/sym53c8xx_2/sym_hipd.c =
a/drivers/scsi/sym53c8xx_2/sym_hipd.c=0A=
--- b/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-04-28 14:32:32.000000000 =
-0500=0A=
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.c	2005-04-28 10:26:59.000000000 =
-0500=0A=
@@ -3877,6 +3877,8 @@=0A=
 		resid +=3D (tmp & 0xffffff);=0A=
 	}=0A=
 =0A=
+	resid -=3D cp->odd_byte_adjustment;=0A=
+=0A=
 	/*=0A=
 	 *  Hopefully, the result is not too wrong.=0A=
 	 */=0A=
@@ -4761,7 +4763,7 @@=0A=
 	/*=0A=
 	 *  Remember all informations needed to free this CCB.=0A=
 	 */=0A=
-	cp->to_abort =3D 0;=0A=
+	cp->to_abort =3D cp->odd_byte_adjustment =3D 0;=0A=
 	cp->tag	   =3D tag;=0A=
 	cp->order  =3D tag_order;=0A=
 	cp->target =3D tn;=0A=
diff -uarN b/drivers/scsi/sym53c8xx_2/sym_hipd.h =
a/drivers/scsi/sym53c8xx_2/sym_hipd.h=0A=
--- b/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-04-28 14:32:32.000000000 =
-0500=0A=
+++ a/drivers/scsi/sym53c8xx_2/sym_hipd.h	2005-04-28 10:15:37.000000000 =
-0500=0A=
@@ -790,6 +790,7 @@=0A=
 				/*  NO_TAG means no tag		*/=0A=
 	u_char	target;=0A=
 	u_char	lun;=0A=
+	u_char	odd_byte_adjustment;=0A=
 	struct sym_ccb *link_ccbh;	/* Host adapter CCB hash chain	*/=0A=
 	SYM_QUEHEAD link_ccbq;	/* Link to free/busy CCB queue	*/=0A=
 	u32	startp;		/* Initial data pointer		*/=0A=

------_=_NextPart_000_01C55490.F9720470--
