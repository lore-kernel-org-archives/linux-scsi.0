From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: st driver doesn't seem to grok LTO partitioning
Date: Fri, 25 Dec 2015 17:53:46 +0200 (EET)
Message-ID: <alpine.LSU.2.11.1512251732060.4761@xnv.znxvfnen.cevingr>
References: <20151218170644.24167419@harpe.intellique.com> <20151221134649.293a1a1e@harpe.intellique.com> <F89B43DA-FE51-4FEF-97BB-C79A401050D7@kolumbus.fi> <20151221185759.38dd21d6@harpe.intellique.com> <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811327-1123608655-1451058668=:4761"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs19.mail.saunalahti.fi ([62.142.117.200]:52711 "EHLO
	vs19.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbbLYPxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Dec 2015 10:53:52 -0500
In-Reply-To: <3F0204AE-89BD-45C7-883F-D6EC3A1D34E2@kolumbus.fi>
Content-ID: <alpine.LSU.2.11.1512251751510.4761@xnv.znxvfnen.cevingr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-1123608655-1451058668=:4761
Content-Type: text/plain; charset=UTF-8
Content-ID: <alpine.LSU.2.11.1512251751511.4761@xnv.znxvfnen.cevingr>
Content-Transfer-Encoding: quoted-printable

On Monday 2015-12-21 20:57, "Kai M=C3=A4kisara (Kolumbus)" wrote:

...
>I can look at the manuals during Christmas holidays and try to think abo=
ut a suggestion.
>All other suggestions are, of course, welcome. My view may be somewhat t=
heoretical
>because I don=E2=80=99t have access to current hardware.
>
I have had some time to look at manuals and even do some coding :-)

The partitioning is initiated with the MTMKPART operation of the=20
MTIOCTOP ioctl. This has one int parameter mt_count that is used to=20
specify the size in megabytes of the first partition on the tape. Note=20
that, for historical reasons, the number of this partition used to be 1,=20
not zero. So, the ioctls allocates the specified space to partition 1=20
and the rest to partition 0. This intefarce does not allow specifying=20
more than two partitions. We can make work for current drives quite=20
easily. More than two partitions need a new API but do we have a real=20
need for this?

The current code did not work basically because the current drives need=20
a separate FORMAT MEDIUM command to do the partitioning specified by=20
MODE SELECT. There are smaller details that could have also been a=20
problem.

The patch at the end of this message is an attempt to make the=20
partitioning work for both old and new drives. The patch is against st.c=20
from the current git kernel, although I have tested it in 4.3.3. It=20
seems to work with my HP DDS-4 drive. It includes some debugging printks=20
and I have tried to see that the commands that would have been sent to=20
newer drives are basically correct.

The patch uses the scsi level of the device to separate processing. The=20
FORMAT MEDIUM command is defined in SCSI-3 and I suppose that no current=20
drive is still SCSI-2. In addition to the "sane" changes using the=20
method to specify partitions, the patch implements the following: if the=20
size is 1, the driver tells the drive to use default partitioning for=20
two partitions. For the HP Ultrium this should result in partition 0 of=20
1425 GB and 1 of 37.5 GB. I don't know if this is a useful addition.


Kai

------------------------------------8<----------------------------------
--- ref/drivers/scsi/st.c	2015-12-21 18:54:05.068882001 +0200
+++ new/drivers/scsi/st.c	2015-12-25 16:49:54.345263675 +0200
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs=
 support
  */
=20
-static const char *verstr =3D "20101219";
+static const char *verstr =3D "20151225";
=20
 #include <linux/module.h>
=20
@@ -3296,7 +3296,10 @@
 #define PP_OFF_RESERVED        7
=20
 #define PP_BIT_IDP             0x20
+#define PP_BIT_FDP             0x80
 #define PP_MSK_PSUM_MB         0x10
+#define PP_MSK_PSUM_UNITS      0x18
+#define PP_MSK_POFM            0x04
=20
 /* Get the number of partitions on the tape. As a side effect reads the
    mode page into the tape buffer. */
@@ -3344,7 +3347,9 @@
 static int partition_tape(struct scsi_tape *STp, int size)
 {
 	int result;
+	int scsi3 =3D STp->device->scsi_level >=3D SCSI_3, needs_format =3D 0;
 	int pgo, psd_cnt, psdo;
+	int psum =3D PP_MSK_PSUM_MB, units =3D 0;
 	unsigned char *bp;
=20
 	result =3D read_mode_page(STp, PART_PAGE, 0);
@@ -3357,10 +3362,32 @@
 	pgo =3D MODE_HEADER_LENGTH + bp[MH_OFF_BDESCS_LENGTH];
 	DEBC_printk(STp, "Partition page length is %d bytes.\n",
 		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2);
-
-	psd_cnt =3D (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 - PART_PAGE_FIXED_LENGTH)=
 / 2;
+	DEBC_printk(STp, "PP: max %u, add %u, xdp %u, psum %02x, pofmetc %u,"
+		    "rec %02x units %02x, sizes: %u %u\n",
+		    bp[pgo + PP_OFF_MAX_ADD_PARTS],
+		    bp[pgo + PP_OFF_NBR_ADD_PARTS],
+		    (bp[pgo + PP_OFF_FLAGS] & 0xe0) >> 5,
+		    (bp[pgo + PP_OFF_FLAGS] & 0x18) >> 3,
+		    bp[pgo + PP_OFF_FLAGS] & 0x03,
+		    bp[pgo + 5],
+		    bp[pgo + PP_OFF_PART_UNITS],
+		    bp[pgo + 8] * 256 + bp[pgo + 9],
+		    bp[pgo + 10] * 256 + bp[pgo + 11]);
+
+	if (scsi3) {
+		psd_cnt =3D size > 0 ? 2 : 1;
+		if (size >=3D 65535) {
+			size /=3D 1000;
+			psum =3D PP_MSK_PSUM_UNITS;
+			units =3D 9; /* GB */
+		}
+	} else
+		psd_cnt =3D (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 -
+			   PART_PAGE_FIXED_LENGTH) / 2;
+	if (size >=3D 65535)
+		return -EINVAL;
 	psdo =3D pgo + PART_PAGE_FIXED_LENGTH;
-	if (psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
+	if (scsi3 || psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
 		bp[psdo] =3D bp[psdo + 1] =3D 0xff;  /* Rest of the tape */
 		psdo +=3D 2;
 	}
@@ -3375,6 +3402,11 @@
 		if (psd_cnt <=3D bp[pgo + PP_OFF_MAX_ADD_PARTS])
 		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 6;
 		DEBC_printk(STp, "Formatting tape with one partition.\n");
+	} else if (size =3D=3D 1) {
+		bp[pgo + PP_OFF_NBR_ADD_PARTS] =3D 1;
+		if (psd_cnt <=3D bp[pgo + PP_OFF_MAX_ADD_PARTS])
+		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 6;
+		DEBC_printk(STp, "Formatting tape with two partitions (FDP).\n");
 	} else {
 		bp[psdo] =3D (size >> 8) & 0xff;
 		bp[psdo + 1] =3D size & 0xff;
@@ -3382,13 +3414,55 @@
 		if (bp[pgo + MP_OFF_PAGE_LENGTH] < 8)
 		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 8;
 		DEBC_printk(STp, "Formatting tape with two partitions "
-			    "(1 =3D %d MB).\n", size);
+			    "(1 =3D %d MB).\n",
+			    units > 0 ? size * 1000 : size);
 	}
 	bp[pgo + PP_OFF_PART_UNITS] =3D 0;
 	bp[pgo + PP_OFF_RESERVED] =3D 0;
-	bp[pgo + PP_OFF_FLAGS] =3D PP_BIT_IDP | PP_MSK_PSUM_MB;
+	if (size !=3D 1) {
+		bp[pgo + PP_OFF_FLAGS] =3D PP_BIT_IDP | psum |
+			(bp[pgo + PP_OFF_FLAGS] & 0x0F);
+		bp[pgo + PP_OFF_PART_UNITS] =3D units;
+	} else
+		bp[pgo + PP_OFF_FLAGS] =3D PP_BIT_FDP;
+	if (scsi3)
+		needs_format =3D (bp[pgo + PP_OFF_FLAGS] & PP_MSK_POFM) !=3D 0;
+	bp[pgo + MP_OFF_PAGE_LENGTH] =3D 6 + psd_cnt * 2;
+	DEBC_printk(STp, "Sent partition page length is %d bytes. needs_format:=
 %d\n",
+		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2, needs_format);
+	DEBC_printk(STp, "PP: max %u, add %u, xdp %u, psum %02x, pofmetc %u,"
+		    "rec %02x units %02x, sizes: %u %u\n",
+		    bp[pgo + PP_OFF_MAX_ADD_PARTS],
+		    bp[pgo + PP_OFF_NBR_ADD_PARTS],
+		    (bp[pgo + PP_OFF_FLAGS] & 0xe0) >> 5,
+		    (bp[pgo + PP_OFF_FLAGS] & 0x18) >> 3,
+		    bp[pgo + PP_OFF_FLAGS] & 0x03,
+		    bp[pgo + 5],
+		    bp[pgo + PP_OFF_PART_UNITS],
+		    bp[pgo + 8] * 256 + bp[pgo + 9],
+		    bp[pgo + 10] * 256 + bp[pgo + 11]);
=20
 	result =3D write_mode_page(STp, PART_PAGE, 1);
+
+	if (!result && needs_format) {
+		int timeout =3D STp->long_timeout;
+		unsigned char scmd[MAX_COMMAND_SIZE];
+		struct st_request *SRpnt;
+
+		memset(scmd, 0, MAX_COMMAND_SIZE);
+		scmd[0] =3D FORMAT_UNIT;
+		scmd[2] =3D 1;
+		if (STp->immediate) {
+			scmd[1] |=3D 1;		/* Don't wait for completion */
+			timeout =3D STp->device->request_queue->rq_timeout;
+		}
+		DEBC_printk(STp, "Sending FORMAT MEDIUM\n");
+		SRpnt =3D st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
+				   timeout, MAX_RETRIES, 1);
+		if (!SRpnt)
+			result =3D STp->buffer->syscall_result;
+	}
+
 	if (result) {
 		st_printk(KERN_INFO, STp, "Partitioning of tape failed.\n");
 		result =3D (-EIO);
---1463811327-1123608655-1451058668=:4761--
