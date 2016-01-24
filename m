From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: RE: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Sun, 24 Jan 2016 23:05:17 +0200 (EET)
Message-ID: <alpine.LSU.2.11.1601242247440.3145@xnv.znxvfnen.cevingr>
References: <20151218170644.24167419@harpe.intellique.com> <alpine.LSU.2.11.1601041219340.1615@xnv.znxvfnen.cevingr> <20160104124626.3112e8c0@harpe.intellique.com> <CAAzz28iCoG-rjnL7EsjHXA7UtRJSCEXuwL3+27ZBo7fckcBAfg@mail.gmail.com>
 <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com>
 <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi> <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811327-1078589832-1453669529=:3145"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs16.mail.saunalahti.fi ([62.142.117.197]:41830 "EHLO
	vs16.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbcAXVFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Jan 2016 16:05:32 -0500
In-Reply-To: <DDB9C85B850785449757F9914A034FCB44517327@G4W3219.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Seymour, Shane M" <shane.seymour@hpe.com>
Cc: Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-1078589832-1453669529=:3145
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Friday 2016-01-22 04:10, Seymour, Shane M wrote:


>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of "Kai M=C3=A4kisara (Kolumbus)"
>> Sent: Friday, January 22, 2016 7:59 AM
>> To: Seymour, Shane M
>> Cc: Laurence Oberman; Emmanuel Florac; Laurence Oberman; linux-
>> scsi@vger.kernel.org
>> Subject: What partition should the MTMKPART argument specify? Was: Re:
>> st driver doesn't seem to grok LTO partitioning
>>=20
...
>>=20
>> There seem to be lot of arguments supporting both possible choices. Sh=
ould
>> we use the existing definition (1) or change it for the drives support=
ing SCSI
>> level >=3D 3 (or supporting FORMAT MEDIUM)? The definition can=E2=80=99=
t be
>> changed later. This is why we should make a good decision.
>>=20
>> Opinions?
>
>How about using the fact the size is signed to indicate one slightly dif=
ferent
>thing? I'm not sure if you'd call this using or abusing the fact that it=
's signed.
>
>Make the default behavior for a positive size the same as the current
>behavior for SCSI-2 (size applies to partition 1). If the size is negati=
ve then
>the absolute value of the size applies to partition 0. That provides som=
e
>flexibility in choosing which partition the size applies to if it worked=
 that
>way for all devices.
>
>With that you also get consistent behavior between tape drives without
>having to know if the size will apply to partition 0 or partition 1 base=
d on
>the tape technology and you get the benefit of being able to set an
>explicit size for partition 0 or partition 1.
>
I like this suggestion, because of the reasons you point out. I think=20
this is using the fact that the argument is signed.

>You could overload the value of 0 as well to use FDP to choose the sizes
>for the partitions (assuming 0 doesn't already have a side effect in
>the code). Then you get whatever the tape drive wants to do.
>
The value zero is used to specify only one partition. The previous=20
patches overloaded the size 1. However, I think supporting FDP is=20
useless nowadays: the drives that support FDP=3D1 seem to end up with the=
=20
same partitioning (two wraps to partition 1) with any small number as=20
argument.

Below is a test patch that implements the current behaviour with=20
non-negative argument (but works with LTOs etc.) and makes partition=20
zero size absolute value of argument (MB) if argument is negative. If=20
you want to test the patch, note that the current mt-st does not accept=20
negative numbers. A minimal patch is needed.

Thanks,
Kai
-------------------------------8<----------------------------------------
--- ref/drivers/scsi/st.c	2015-12-21 18:54:05.068882001 +0200
+++ new/drivers/scsi/st.c	2016-01-24 22:36:13.250928500 +0200
@@ -9,7 +9,7 @@
    Steve Hirsch, Andreas Koppenh"ofer, Michael Leodolter, Eyal Lebedinsk=
y,
    Michael Schaefer, J"org Weule, and Eric Youngdale.
=20
-   Copyright 1992 - 2010 Kai Makisara
+   Copyright 1992 - 2016 Kai Makisara
    email Kai.Makisara@kolumbus.fi
=20
    Some small formal changes - aeb, 950809
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs=
 support
  */
=20
-static const char *verstr =3D "20101219";
+static const char *verstr =3D "20160124";
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
@@ -3322,6 +3325,29 @@
 }
=20
=20
+static int format_medium(struct scsi_tape *STp, int format)
+{
+	int result =3D 0;
+	int timeout =3D STp->long_timeout;
+	unsigned char scmd[MAX_COMMAND_SIZE];
+	struct st_request *SRpnt;
+
+	memset(scmd, 0, MAX_COMMAND_SIZE);
+	scmd[0] =3D FORMAT_UNIT;
+	scmd[2] =3D format;
+	if (STp->immediate) {
+		scmd[1] |=3D 1;		/* Don't wait for completion */
+		timeout =3D STp->device->request_queue->rq_timeout;
+	}
+	DEBC_printk(STp, "Sending FORMAT MEDIUM\n");
+	SRpnt =3D st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
+			   timeout, MAX_RETRIES, 1);
+	if (!SRpnt)
+		result =3D STp->buffer->syscall_result;
+	return result;
+}
+
+
 /* Partition the tape into two partitions if size > 0 or one partition i=
f
    size =3D=3D 0.
=20
@@ -3340,11 +3366,16 @@
    and 10 when 1 partition is defined (information from Eric Lee Green).=
 This is
    is acceptable also to some other old drives and enforced if the first=
 partition
    size field is used for the first additional partition size.
+
+   For drives that advertize SCSI-3 or newer, use the SSC-3 methods.
  */
 static int partition_tape(struct scsi_tape *STp, int size)
 {
 	int result;
+	int target_partition;
+	bool scsi3 =3D STp->device->scsi_level >=3D SCSI_3,  needs_format =3D f=
alse;
 	int pgo, psd_cnt, psdo;
+	int psum =3D PP_MSK_PSUM_MB, units =3D 0;
 	unsigned char *bp;
=20
 	result =3D read_mode_page(STp, PART_PAGE, 0);
@@ -3352,16 +3383,72 @@
 		DEBC_printk(STp, "Can't read partition mode page.\n");
 		return result;
 	}
+	target_partition =3D 1;
+	if (size < 0) {
+		target_partition =3D 0;
+		size =3D -size;
+	}
+
 	/* The mode page is in the buffer. Let's modify it and write it. */
 	bp =3D (STp->buffer)->b_data;
 	pgo =3D MODE_HEADER_LENGTH + bp[MH_OFF_BDESCS_LENGTH];
 	DEBC_printk(STp, "Partition page length is %d bytes.\n",
 		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2);
+	DEBC_printk(STp, "PP: max %u, add %u, xdp %u, psum %02x, pofmetc %u, "
+		    "rec %02x, units %02x, sizes: %u %u\n",
+		    bp[pgo + PP_OFF_MAX_ADD_PARTS],
+		    bp[pgo + PP_OFF_NBR_ADD_PARTS],
+		    (bp[pgo + PP_OFF_FLAGS] & 0xe0) >> 5,
+		    (bp[pgo + PP_OFF_FLAGS] & 0x18) >> 3,
+		    bp[pgo + PP_OFF_FLAGS] & 0x07,
+		    bp[pgo + 5],
+		    bp[pgo + PP_OFF_PART_UNITS],
+		    bp[pgo + 8] * 256 + bp[pgo + 9],
+		    bp[pgo + 10] * 256 + bp[pgo + 11]);
+	DEBC_printk(STp, "MP: %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x=
 %02x %02x\n",
+		    bp[pgo], bp[pgo+1], bp[pgo+2], bp[pgo+3], bp[pgo+4], bp[pgo+5],
+		    bp[pgo+6], bp[pgo+7], bp[pgo+8], bp[pgo+9], bp[pgo+10], bp[pgo+11]=
);
+
+	if (scsi3) {
+		needs_format =3D (bp[pgo + PP_OFF_FLAGS] & PP_MSK_POFM) !=3D 0;
+		if (needs_format && size =3D=3D 0) {
+			/* No need to write the mode page when clearing partitioning */
+			result =3D format_medium(STp, 0);
+			goto out;
+		}
+
+		psd_cnt =3D size > 0 ? 2 : 1;
+		if ((bp[pgo + PP_OFF_FLAGS] & PP_MSK_PSUM_UNITS) =3D=3D PP_MSK_PSUM_UN=
ITS) {
+			/* Use units scaling for large partitions if the device suggests
+			   it and no precision lost. Required for IBM TS1140/50 drives
+			   that don't support MB units. */
+			if (size >=3D 1000 && (size % 1000) =3D=3D 0) {
+				size /=3D 1000;
+				psum =3D PP_MSK_PSUM_UNITS;
+				units =3D 9; /* GB */
+			}
+		}
+		/* Try it anyway if too large to specify in MB */
+		if (psum =3D=3D PP_MSK_PSUM_MB && size >=3D 65534) {
+				size /=3D 1000;
+				psum =3D PP_MSK_PSUM_UNITS;
+				units =3D 9;  /* GB */
+		}
+	} else
+		psd_cnt =3D (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 -
+			   PART_PAGE_FIXED_LENGTH) / 2;
+
+	if (size >=3D 65535 ||  /* Does not fit into two bytes */
+	    (target_partition =3D=3D 0 && psd_cnt < 2)) {
+		result =3D -EINVAL;
+		goto out;
+	}
=20
-	psd_cnt =3D (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 - PART_PAGE_FIXED_LENGTH)=
 / 2;
 	psdo =3D pgo + PART_PAGE_FIXED_LENGTH;
-	if (psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
-		bp[psdo] =3D bp[psdo + 1] =3D 0xff;  /* Rest of the tape */
+	/* The second condition if for HP DDS which use only one partition size
+	   descriptor */
+	if (target_partition > 0 && psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
+		bp[psdo] =3D bp[psdo + 1] =3D 0xff;  /* Rest of the tape to partition =
0 */
 		psdo +=3D 2;
 	}
 	memset(bp + psdo, 0, bp[pgo + PP_OFF_NBR_ADD_PARTS] * 2);
@@ -3370,7 +3457,7 @@
 		    psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
 		    bp[pgo + PP_OFF_NBR_ADD_PARTS]);
=20
-	if (size <=3D 0) {
+	if (size =3D=3D 0) {
 		bp[pgo + PP_OFF_NBR_ADD_PARTS] =3D 0;
 		if (psd_cnt <=3D bp[pgo + PP_OFF_MAX_ADD_PARTS])
 		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 6;
@@ -3378,22 +3465,54 @@
 	} else {
 		bp[psdo] =3D (size >> 8) & 0xff;
 		bp[psdo + 1] =3D size & 0xff;
+		if (target_partition =3D=3D 0)
+			bp[psdo + 2] =3D bp[psdo + 3] =3D 0xff;
 		bp[pgo + 3] =3D 1;
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
+	if (size !=3D 1 || units !=3D 0) {
+		bp[pgo + PP_OFF_FLAGS] =3D PP_BIT_IDP | psum |
+			(bp[pgo + PP_OFF_FLAGS] & 0x07);
+		bp[pgo + PP_OFF_PART_UNITS] =3D units;
+	} else
+		bp[pgo + PP_OFF_FLAGS] =3D PP_BIT_FDP |
+			(bp[pgo + PP_OFF_FLAGS] & 0x1f);
+	bp[pgo + MP_OFF_PAGE_LENGTH] =3D 6 + psd_cnt * 2;
+
+	DEBC_printk(STp, "Sent partition page length is %d bytes. needs_format:=
 %d\n",
+		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2, needs_format);
+	DEBC_printk(STp, "PP: max %u, add %u, xdp %u, psum %02x, pofmetc %u, "
+		    "rec %02x, units %02x, sizes: %u %u\n",
+		    bp[pgo + PP_OFF_MAX_ADD_PARTS],
+		    bp[pgo + PP_OFF_NBR_ADD_PARTS],
+		    (bp[pgo + PP_OFF_FLAGS] & 0xe0) >> 5,
+		    (bp[pgo + PP_OFF_FLAGS] & 0x18) >> 3,
+		    bp[pgo + PP_OFF_FLAGS] & 0x07,
+		    bp[pgo + 5],
+		    bp[pgo + PP_OFF_PART_UNITS],
+		    bp[pgo + 8] * 256 + bp[pgo + 9],
+		    bp[pgo + 10] * 256 + bp[pgo + 11]);
+	DEBC_printk(STp, "MP: %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x=
 %02x %02x\n",
+		    bp[pgo], bp[pgo+1], bp[pgo+2], bp[pgo+3], bp[pgo+4], bp[pgo+5],
+		    bp[pgo+6], bp[pgo+7], bp[pgo+8], bp[pgo+9], bp[pgo+10], bp[pgo+11]=
);
=20
 	result =3D write_mode_page(STp, PART_PAGE, 1);
+
+	if (!result && needs_format)
+		result =3D format_medium(STp, 1);
+
 	if (result) {
 		st_printk(KERN_INFO, STp, "Partitioning of tape failed.\n");
 		result =3D (-EIO);
 	}
=20
+out:
 	return result;
 }
 =0C
@@ -3570,7 +3689,7 @@
 				retval =3D (-EINVAL);
 				goto out;
 			}
-			if ((i =3D st_int_ioctl(STp, MTREW, 0)) < 0 ||
+			if ((i =3D do_load_unload(STp, file, 1)) < 0 ||
 			    (i =3D partition_tape(STp, mtc.mt_count)) < 0) {
 				retval =3D i;
 				goto out;
@@ -3581,7 +3700,7 @@
 				STp->ps[i].last_block_valid =3D 0;
 			}
 			STp->partition =3D STp->new_partition =3D 0;
-			STp->nbr_partitions =3D 1;	/* Bad guess ?-) */
+			STp->nbr_partitions =3D mtc.mt_count > 0 ? 2 : 1;
 			STps->drv_block =3D STps->drv_file =3D 0;
 			retval =3D 0;
 			goto out;
---1463811327-1078589832-1453669529=:3145--
