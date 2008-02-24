From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 2/2] SCSI tape: show options currently set in sysfs
Date: Sun, 24 Feb 2008 22:29:12 +0200 (EET)
Message-ID: <alpine.LSU.1.00.0802242227410.5772@kai.makisara.local>
References: <alpine.LSU.1.00.0802242220350.5772@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-1468074096-1203884963=:5772"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:34864 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbYBXU3Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 15:29:24 -0500
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh05-2.mail.saunalahti.fi (Postfix) with SMTP id 323C48CB3D
	for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2008 22:29:23 +0200 (EET)
Received: from kai.makisara.local (a88-114-81-250.elisa-laajakaista.fi [88.114.81.250])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 1993E42063
	for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2008 22:29:22 +0200 (EET)
In-Reply-To: <alpine.LSU.1.00.0802242220350.5772@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-1468074096-1203884963=:5772
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Show the current binary tape driver and mode options is sysfs. A file
(options) is created in each directory in /sys/class/scsi_tape. The files
contain masks showing the options. The mask bit definitions are the same =
as
used when setting the options using the MTSETDRVBUFFER function in the
MTIOCTOP ioctl (defined in include/linux/mtio.h). For example:
> cat /sys/class/scsi_tape/nst0/options=20
0x00000d07

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
The patch is against Feb 24 git version of 2.6.25-rc2. Candidate for
inclusion into 2.6.26.

 Documentation/scsi/st.txt |    7 ++++++-
 drivers/scsi/st.c         |   43 +++++++++++++++++++++++++++++++++++++++=
++++
 2 files changed, 49 insertions(+), 1 deletion(-)

Index: linux-2.6.25-rc2-q/drivers/scsi/st.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.25-rc2-q.orig/drivers/scsi/st.c
+++ linux-2.6.25-rc2-q/drivers/scsi/st.c
@@ -4365,6 +4365,46 @@ static ssize_t st_defcompression_show(st
=20
 CLASS_DEVICE_ATTR(default_compression, S_IRUGO, st_defcompression_show, =
NULL);
=20
+static ssize_t st_options_show(struct class_device *class_dev, char *buf=
)
+{
+	struct st_modedef *STm =3D (struct st_modedef *)class_get_devdata(class=
_dev);
+	struct scsi_tape *STp;
+	int i, j, options;
+	ssize_t l =3D 0;
+
+	for (i=3D0; i < st_dev_max; i++) {
+		for (j=3D0; j < ST_NBR_MODES; j++)
+			if (&scsi_tapes[i]->modes[j] =3D=3D STm)
+				break;
+		if (j < ST_NBR_MODES)
+			break;
+	}
+	if (i =3D=3D st_dev_max)
+		return 0;  /* should never happen */
+
+	STp =3D scsi_tapes[i];
+
+	options =3D STm->do_buffer_writes ? MT_ST_BUFFER_WRITES : 0;
+	options |=3D STm->do_async_writes ? MT_ST_ASYNC_WRITES : 0;
+	options |=3D STm->do_read_ahead ? MT_ST_READ_AHEAD : 0;
+	DEB( options |=3D debugging ? MT_ST_DEBUGGING : 0 );
+	options |=3D STp->two_fm ? MT_ST_TWO_FM : 0;
+	options |=3D STp->fast_mteom ? MT_ST_FAST_MTEOM : 0;
+	options |=3D STm->defaults_for_writes ? MT_ST_DEF_WRITES : 0;
+	options |=3D STp->can_bsr ? MT_ST_CAN_BSR : 0;
+	options |=3D STp->omit_blklims ? MT_ST_NO_BLKLIMS : 0;
+	options |=3D STp->can_partitions ? MT_ST_CAN_PARTITIONS : 0;
+	options |=3D STp->scsi2_logical ? MT_ST_SCSI2LOGICAL : 0;
+	options |=3D STm->sysv ? MT_ST_SYSV : 0;
+	options |=3D STp->immediate ? MT_ST_NOWAIT : 0;
+	options |=3D STp->sili ? MT_ST_SILI : 0;
+
+	l =3D snprintf(buf, PAGE_SIZE, "0x%08x\n", options);
+	return l;
+}
+
+CLASS_DEVICE_ATTR(options, S_IRUGO, st_options_show, NULL);
+
 static int do_create_class_files(struct scsi_tape *STp, int dev_num, int=
 mode)
 {
 	int i, rew, error;
@@ -4402,6 +4442,9 @@ static int do_create_class_files(struct=20
 		error =3D class_device_create_file(st_class_member,
 				        &class_device_attr_default_compression);
 		if (error) goto out;
+		error =3D class_device_create_file(st_class_member,
+				        &class_device_attr_options);
+		if (error) goto out;
=20
 		if (mode =3D=3D 0 && rew =3D=3D 0) {
 			error =3D sysfs_create_link(&STp->device->sdev_gendev.kobj,
Index: linux-2.6.25-rc2-q/Documentation/scsi/st.txt
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.25-rc2-q.orig/Documentation/scsi/st.txt
+++ linux-2.6.25-rc2-q/Documentation/scsi/st.txt
@@ -2,7 +2,7 @@ This file contains brief information abo
 The driver is currently maintained by Kai M=C3=A4kisara (email
 Kai.Makisara@kolumbus.fi)
=20
-Last modified: Thu Feb 21 21:54:16 2008 by kai.makisara
+Last modified: Sun Feb 24 21:59:07 2008 by kai.makisara
=20
=20
 BASICS
@@ -133,6 +133,11 @@ the defaults set by the user. The value=20
 file 'dev' contains the device numbers corresponding to this device. The=
 links
 'device' and 'driver' point to the SCSI device and driver entries.
=20
+Each directory acontains also the entry 'options' which shows the curren=
tly
+enabled driver and mode options. The value in the file is a bit mask whe=
re the
+bit definitions are the same as those used with MTSETDRVBUFFER in settin=
g the
+options.
+
 A link named 'tape' is made from the SCSI device directory to the class
 directory corresponding to the mode 0 auto-rewind device (e.g., st0).=20
=20
---1463811327-1468074096-1203884963=:5772--
