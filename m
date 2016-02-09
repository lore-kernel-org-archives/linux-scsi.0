From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH] st: Fix MTMKPART to work with newer drives
Date: Tue, 9 Feb 2016 21:56:55 +0200 (EET)
Message-ID: <alpine.LSU.2.11.1602092146480.4677@xnv.znxvfnen.cevingr>
Mime-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="-1463811327-473907491-1455047826=:4677"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs14.mail.saunalahti.fi ([62.142.117.201]:52661 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624AbcBIT5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 14:57:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Seymour, Shane M" <shane.seymour@hpe.com>, Douglas Gilbert <dgilbert@interlog.com>, Laurence Oberman <loberman@redhat.com>, Emmanuel Florac <eflorac@intellique.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-473907491-1455047826=:4677
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Change the MTMKPART operation of the MTIOCTOP ioctl so that it works also=
 with
current drives (LTO-5/6, etc.). Send a separate FORMAT MEDIUM command if =
the
partition mode page indicates that this is required. Use LOAD to position=
 the
tape at the beginning of tape.

The operation is extended so that if the argument is negative, its absolu=
te
value specifies the size of partition 0, which is the physically first
partition of the tape.

Signed-off-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>
Tested-by: Shane M Seymour <shane.seymour@hpe.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
---
 Documentation/scsi/st.txt |   15 ++--
 drivers/scsi/st.c         |  122 ++++++++++++++++++++++++++++++++----
 2 files changed, 121 insertions(+), 16 deletions(-)

--- a/drivers/scsi/st.c	2015-12-21 18:54:05.068882001 +0200
+++ b/drivers/scsi/st.c	2016-02-09 20:57:52.614816514 +0200
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
+static const char *verstr =3D "20160209";
=20
 #include <linux/module.h>
=20
@@ -3296,7 +3296,10 @@ static int switch_partition(struct scsi_
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
@@ -3322,6 +3325,29 @@ static int nbr_partitions(struct scsi_ta
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
@@ -3340,11 +3366,16 @@ static int nbr_partitions(struct scsi_ta
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
+	bool scsi3 =3D STp->device->scsi_level >=3D SCSI_3, needs_format =3D fa=
lse;
 	int pgo, psd_cnt, psdo;
+	int psum =3D PP_MSK_PSUM_MB, units =3D 0;
 	unsigned char *bp;
=20
 	result =3D read_mode_page(STp, PART_PAGE, 0);
@@ -3352,6 +3383,12 @@ static int partition_tape(struct scsi_ta
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
@@ -3359,9 +3396,52 @@ static int partition_tape(struct scsi_ta
 		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2);
=20
 	psd_cnt =3D (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 - PART_PAGE_FIXED_LENGTH)=
 / 2;
+
+	if (scsi3) {
+		needs_format =3D (bp[pgo + PP_OFF_FLAGS] & PP_MSK_POFM) !=3D 0;
+		if (needs_format && size =3D=3D 0) {
+			/* No need to write the mode page when clearing
+			 *  partitioning
+			 */
+			DEBC_printk(STp, "Formatting tape with one partition.\n");
+			result =3D format_medium(STp, 0);
+			goto out;
+		}
+		if (needs_format)  /* Leave the old value for HP DATs claiming SCSI_3 =
*/
+			psd_cnt =3D 2;
+		if ((bp[pgo + PP_OFF_FLAGS] & PP_MSK_PSUM_UNITS) =3D=3D PP_MSK_PSUM_UN=
ITS) {
+			/* Use units scaling for large partitions if the device
+			 * suggests it and no precision lost. Required for IBM
+			 * TS1140/50 drives that don't support MB units.
+			 */
+			if (size >=3D 1000 && (size % 1000) =3D=3D 0) {
+				size /=3D 1000;
+				psum =3D PP_MSK_PSUM_UNITS;
+				units =3D 9; /* GB */
+			}
+		}
+		/* Try it anyway if too large to specify in MB */
+		if (psum =3D=3D PP_MSK_PSUM_MB && size >=3D 65534) {
+			size /=3D 1000;
+			psum =3D PP_MSK_PSUM_UNITS;
+			units =3D 9;  /* GB */
+		}
+	}
+
+	if (size >=3D 65535 ||  /* Does not fit into two bytes */
+	    (target_partition =3D=3D 0 && psd_cnt < 2)) {
+		result =3D -EINVAL;
+		goto out;
+	}
+
 	psdo =3D pgo + PART_PAGE_FIXED_LENGTH;
-	if (psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS]) {
-		bp[psdo] =3D bp[psdo + 1] =3D 0xff;  /* Rest of the tape */
+	/* The second condition is for HP DDS which use only one partition size
+	 * descriptor
+	 */
+	if (target_partition > 0 &&
+	    (psd_cnt > bp[pgo + PP_OFF_MAX_ADD_PARTS] ||
+	     bp[pgo + PP_OFF_MAX_ADD_PARTS] !=3D 1)) {
+		bp[psdo] =3D bp[psdo + 1] =3D 0xff;  /* Rest to partition 0 */
 		psdo +=3D 2;
 	}
 	memset(bp + psdo, 0, bp[pgo + PP_OFF_NBR_ADD_PARTS] * 2);
@@ -3370,7 +3450,7 @@ static int partition_tape(struct scsi_ta
 		    psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
 		    bp[pgo + PP_OFF_NBR_ADD_PARTS]);
=20
-	if (size <=3D 0) {
+	if (size =3D=3D 0) {
 		bp[pgo + PP_OFF_NBR_ADD_PARTS] =3D 0;
 		if (psd_cnt <=3D bp[pgo + PP_OFF_MAX_ADD_PARTS])
 		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 6;
@@ -3378,22 +3458,37 @@ static int partition_tape(struct scsi_ta
 	} else {
 		bp[psdo] =3D (size >> 8) & 0xff;
 		bp[psdo + 1] =3D size & 0xff;
+		if (target_partition =3D=3D 0)
+			bp[psdo + 2] =3D bp[psdo + 3] =3D 0xff;
 		bp[pgo + 3] =3D 1;
 		if (bp[pgo + MP_OFF_PAGE_LENGTH] < 8)
 		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 8;
-		DEBC_printk(STp, "Formatting tape with two partitions "
-			    "(1 =3D %d MB).\n", size);
+		DEBC_printk(STp,
+			    "Formatting tape with two partitions (%i =3D %d MB).\n",
+			    target_partition, units > 0 ? size * 1000 : size);
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
@@ -3570,8 +3665,13 @@ static long st_ioctl(struct file *file,
 				retval =3D (-EINVAL);
 				goto out;
 			}
-			if ((i =3D st_int_ioctl(STp, MTREW, 0)) < 0 ||
-			    (i =3D partition_tape(STp, mtc.mt_count)) < 0) {
+			i =3D do_load_unload(STp, file, 1);
+			if (i < 0) {
+				retval =3D i;
+				goto out;
+			}
+			i =3D partition_tape(STp, mtc.mt_count);
+			if (i < 0) {
 				retval =3D i;
 				goto out;
 			}
@@ -3581,7 +3681,7 @@ static long st_ioctl(struct file *file,
 				STp->ps[i].last_block_valid =3D 0;
 			}
 			STp->partition =3D STp->new_partition =3D 0;
-			STp->nbr_partitions =3D 1;	/* Bad guess ?-) */
+			STp->nbr_partitions =3D mtc.mt_count !=3D 0 ? 2 : 1;
 			STps->drv_block =3D STps->drv_file =3D 0;
 			retval =3D 0;
 			goto out;
--- a/Documentation/scsi/st.txt	2015-11-24 21:50:56.594913001 +0200
+++ b/Documentation/scsi/st.txt	2016-02-09 21:54:16.778547621 +0200
@@ -2,7 +2,7 @@ This file contains brief information abo
 The driver is currently maintained by Kai M=C3=A4kisara (email
 Kai.Makisara@kolumbus.fi)
=20
-Last modified: Sun Aug 29 18:25:47 2010 by kai.makisara
+Last modified: Tue Feb  9 21:54:16 2016 by kai.makisara
=20
=20
 BASICS
@@ -408,10 +408,15 @@ MTSETPART Moves the tape to the partitio
 	specified by MTSEEK. MTSETPART is inactive unless
 	MT_ST_CAN_PARTITIONS set.
 MTMKPART Formats the tape with one partition (argument zero) or two
-	partitions (the argument gives in megabytes the size of
-	partition 1 that is physically the first partition of the
-	tape). The drive has to support partitions with size specified
-	by the initiator. Inactive unless MT_ST_CAN_PARTITIONS set.
+	partitions (argument non-zero). If the argument is positive,
+	it specifies the size of partition 1 in megabytes. For DDS
+	drives and several early drives this is the physically first
+	partition of the tape. If the argument is negative, its absolute
+	value specifies the size of partition 0 in megabytes. This is
+	the physically first partition of many later drives, like the
+	LTO drives from LTO-5 upwards. The drive has to support partitions
+	with size specified by the initiator. Inactive unless
+	MT_ST_CAN_PARTITIONS set.
 MTSETDRVBUFFER
 	Is used for several purposes. The command is obtained from count
         with mask MT_SET_OPTIONS, the low order bits are used as argumen=
t.
---1463811327-473907491-1455047826=:4677--
