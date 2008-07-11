From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [RFC, PATCH] SCSI tape: MTIOCSENSE ioctl to return the sense data
 from errors
Date: Fri, 11 Jul 2008 16:57:00 +0300 (EEST)
Message-ID: <alpine.LNX.1.10.0807111643250.5811@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1214485543-1215784622=:5811"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:53677 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762219AbYGKN5F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jul 2008 09:57:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Arne Wiebalck <arne.wiebalck@cern.ch>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1214485543-1215784622=:5811
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The st driver currently provides very limited information about the
errors. The information in errno after an error usually only tells that t=
he
command has failed. The MTIOCGET ioctl gives some information about the s=
tatus
of the device.

Most (all?) of the current tape drives use the SCSI command set. It defin=
es
the sense data that is returned from the device in case of errors. The se=
nse
data contains all of the error information the device provides. What it
contains, depends on the device. One possibility is to return the sense d=
ata
together with some other information and leave the interpretation to user
space. In this way the kernel interface can stay constant even when the s=
ense
data definition evolves.

To see if this idea is useful, here is a proof-of-concept patch for the s=
t
driver in Linux 2.6.26-rc9. It defines a new ioctl (MTIOCSENSE) to return=
 the
sense data. The returned data is the latest "useful" sense data received.=
 What
"useful" actually means, will probably need refinement. Conceptually it m=
eans
the sense data that is relevant to the latest error condition the user is
interested in. For example, sense data from the latest read error, even i=
f the
driver would receive other sense data from tape movement commands necessa=
ry to
implement the tape semantics. In addition to the sense data, the ioctl re=
turns
the command resulting in check condition and a flag to tell if the sense =
data
is from the latest SCSI command sent to the device.

A small program to test the new ioctl can be found from URL
http://www.kolumbus.fi/kai.makisara/st.html

The patch below this text applies to 2.6.26-rc9 plus the two bug fixes I =
just
sent to linux-scsi.

Some questions:
- is this useful?
- would someone really use this?
- what information should be provided together with the sense data?
  - should the complete command be saved?
- is ioctl the best way to return this information?

Kai

-----------------------8<-----------------------------------------------
diff --git a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
index 4075260..7847655 100644
--- a/Documentation/scsi/st.txt
+++ b/Documentation/scsi/st.txt
@@ -2,7 +2,7 @@ This file contains brief information about the SCSI tape =
driver.
 The driver is currently maintained by Kai M=C3=A4kisara (email
 Kai.Makisara@kolumbus.fi)
=20
-Last modified: Fri Jul 11 16:55:44 2008 by kai.makisara
+Last modified: Fri Jul 11 16:53:06 2008 by kai.makisara
=20
=20
 BASICS
@@ -291,6 +291,8 @@ The supported ioctls are:
=20
 The following use the structure mtop:
=20
+MTIOCTOP implements the following operations
+
 MTFSF   Space forward over count filemarks. Tape positioned after filema=
rk.
 MTFSFM  As above but tape positioned before filemark.
 MTBSF	Space backward over count filemarks. Tape positioned before
@@ -457,6 +459,17 @@ MTIOCGET Returns some status information.
 	is set if there is no tape in the drive. GMT_EOD means either
 	end of recorded data or end of tape. GMT_EOT means end of tape.
=20
+The following ioctl uses the structure mtsense to return error informati=
on:
+MTIOCSENSE returns the sense data from the previous "interesting" SCSI c=
ommand
+	resulting in CHECK CONDITION. Sense data is not saved from a command
+	if is used only for supporting the implementation of the tape
+	semantics and the sense data from that command would overwrite the
+	sense data from the error interesting to the user. For instance, error
+	from backspacing over a block by st after a read error does not
+	overwrite the sense data from the read. The field 'latest' tells if
+	the sense data is from the previous SCSI command sent to the device
+	(all SCSI commands are counted). The cmd field is the command byte
+	from the SCSI command resulting in the sense data.
=20
 MISCELLANEOUS COMPILE OPTIONS
=20
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1986ebc..918f20f 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -352,14 +352,21 @@ static int st_chk_result(struct scsi_tape *STp, str=
uct st_request * SRpnt)
 	char *name =3D tape_name(STp);
 	struct st_cmdstatus *cmdstatp;
=20
+	STp->saved_sense_latest =3D 0;
 	if (!result)
 		return 0;
=20
 	cmdstatp =3D &STp->buffer->cmdstat;
 	st_analyze_sense(SRpnt, cmdstatp);
=20
-	if (cmdstatp->have_sense)
+	if (cmdstatp->have_sense) {
 		scode =3D STp->buffer->cmdstat.sense_hdr.sense_key;
+		if (SRpnt->save_sense) {
+			STp->saved_sense_cmd =3D SRpnt->cmd[0];
+			memcpy(STp->saved_sense, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			STp->saved_sense_latest =3D 1;
+		}
+	}
 	else
 		scode =3D 0;
=20
@@ -465,7 +472,7 @@ static void st_release_request(struct st_request *str=
eq)
    has finished. */
 static struct st_request *
 st_do_scsi(struct st_request * SRpnt, struct scsi_tape * STp, unsigned c=
har *cmd,
-	   int bytes, int direction, int timeout, int retries, int do_wait)
+	   int bytes, int direction, int timeout, int retries, int do_wait, int=
 save_sense)
 {
 	struct completion *waiting;
=20
@@ -491,6 +498,7 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_tap=
e * STp, unsigned char *cmd
 				(STp->buffer)->syscall_result =3D (-EBUSY);
 			return NULL;
 		}
+		SRpnt->save_sense =3D save_sense;
 		SRpnt->stp =3D STp;
 	}
=20
@@ -612,7 +620,7 @@ static int cross_eof(struct scsi_tape * STp, int forw=
ard)
 		   tape_name(STp), forward ? "forward" : "backward"));
=20
 	SRpnt =3D st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->timeout, MAX_RETRIES, 1, 0);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
=20
@@ -656,7 +664,7 @@ static int st_flush_write_buffer(struct scsi_tape * S=
Tp)
 		cmd[4] =3D blks;
=20
 		SRpnt =3D st_do_scsi(NULL, STp, cmd, transfer, DMA_TO_DEVICE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
+				   STp->device->timeout, MAX_WRITE_RETRIES, 1, 1);
 		if (!SRpnt)
 			return (STp->buffer)->syscall_result;
=20
@@ -852,7 +860,7 @@ static int test_ready(struct scsi_tape *STp, int do_w=
ait)
 		memset((void *) &cmd[0], 0, MAX_COMMAND_SIZE);
 		cmd[0] =3D TEST_UNIT_READY;
 		SRpnt =3D st_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
-				   STp->long_timeout, MAX_READY_RETRIES, 1);
+				   STp->long_timeout, MAX_READY_RETRIES, 1, 1);
=20
 		if (!SRpnt) {
 			retval =3D (STp->buffer)->syscall_result;
@@ -986,7 +994,7 @@ static int check_tape(struct scsi_tape *STp, struct f=
ile *filp)
 		cmd[0] =3D READ_BLOCK_LIMITS;
=20
 		SRpnt =3D st_do_scsi(SRpnt, STp, cmd, 6, DMA_FROM_DEVICE,
-				   STp->device->timeout, MAX_READY_RETRIES, 1);
+				   STp->device->timeout, MAX_READY_RETRIES, 1, 0);
 		if (!SRpnt) {
 			retval =3D (STp->buffer)->syscall_result;
 			goto err_out;
@@ -1013,7 +1021,7 @@ static int check_tape(struct scsi_tape *STp, struct=
 file *filp)
 	cmd[4] =3D 12;
=20
 	SRpnt =3D st_do_scsi(SRpnt, STp, cmd, 12, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
+			   STp->device->timeout, MAX_READY_RETRIES, 1, 0);
 	if (!SRpnt) {
 		retval =3D (STp->buffer)->syscall_result;
 		goto err_out;
@@ -1240,7 +1248,7 @@ static int st_flush(struct file *filp, fl_owner_t i=
d)
 		cmd[4] =3D 1 + STp->two_fm;
=20
 		SRpnt =3D st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, 1);
+				   STp->device->timeout, MAX_WRITE_RETRIES, 1, 1);
 		if (!SRpnt) {
 			result =3D (STp->buffer)->syscall_result;
 			goto out;
@@ -1627,7 +1635,7 @@ st_write(struct file *filp, const char __user *buf,=
 size_t count, loff_t * ppos)
 		cmd[4] =3D blks;
=20
 		SRpnt =3D st_do_scsi(SRpnt, STp, cmd, transfer, DMA_TO_DEVICE,
-				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write);
+				   STp->device->timeout, MAX_WRITE_RETRIES, !async_write, 1);
 		if (!SRpnt) {
 			retval =3D STbp->syscall_result;
 			goto out;
@@ -1797,7 +1805,7 @@ static long read_tape(struct scsi_tape *STp, long c=
ount,
=20
 	SRpnt =3D *aSRpnt;
 	SRpnt =3D st_do_scsi(SRpnt, STp, cmd, bytes, DMA_FROM_DEVICE,
-			   STp->device->timeout, MAX_RETRIES, 1);
+			   STp->device->timeout, MAX_RETRIES, 1, 1);
 	release_buffering(STp, 1);
 	*aSRpnt =3D SRpnt;
 	if (!SRpnt)
@@ -2314,7 +2322,7 @@ static int read_mode_page(struct scsi_tape *STp, in=
t page, int omit_block_descs)
 	cmd[4] =3D 255;
=20
 	SRpnt =3D st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE,
-			   STp->device->timeout, 0, 1);
+			   STp->device->timeout, 0, 1, 0);
 	if (SRpnt =3D=3D NULL)
 		return (STp->buffer)->syscall_result;
=20
@@ -2345,7 +2353,7 @@ static int write_mode_page(struct scsi_tape *STp, i=
nt page, int slow)
 	(STp->buffer)->b_data[pgo + MP_OFF_PAGE_NBR] &=3D MP_MSK_PAGE_NBR;
=20
 	SRpnt =3D st_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE,
-			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1);
+			   (slow ? STp->long_timeout : STp->device->timeout), 0, 1, 0);
 	if (SRpnt =3D=3D NULL)
 		return (STp->buffer)->syscall_result;
=20
@@ -2470,7 +2478,7 @@ static int do_load_unload(struct scsi_tape *STp, st=
ruct file *filp, int load_cod
 		);
=20
 	SRpnt =3D st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
-			   timeout, MAX_RETRIES, 1);
+			   timeout, MAX_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
=20
@@ -2770,7 +2778,7 @@ static int st_int_ioctl(struct scsi_tape *STp, unsi=
gned int cmd_in, unsigned lon
 	}
=20
 	SRpnt =3D st_do_scsi(NULL, STp, cmd, datalen, direction,
-			   timeout, MAX_RETRIES, 1);
+			   timeout, MAX_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
=20
@@ -2937,7 +2945,7 @@ static int get_location(struct scsi_tape *STp, unsi=
gned int *block, int *partiti
 			scmd[1] =3D 1;
 	}
 	SRpnt =3D st_do_scsi(NULL, STp, scmd, 20, DMA_FROM_DEVICE,
-			STp->device->timeout, MAX_READY_RETRIES, 1);
+			   STp->device->timeout, MAX_READY_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
=20
@@ -3042,7 +3050,7 @@ static int set_location(struct scsi_tape *STp, unsi=
gned int block, int partition
 	}
=20
 	SRpnt =3D st_do_scsi(NULL, STp, scmd, 0, DMA_NONE,
-			   timeout, MAX_READY_RETRIES, 1);
+			   timeout, MAX_READY_RETRIES, 1, 1);
 	if (!SRpnt)
 		return (STp->buffer)->syscall_result;
=20
@@ -3548,6 +3556,32 @@ static long st_ioctl(struct file *file, unsigned i=
nt cmd_in, unsigned long arg)
 			retval =3D (-EFAULT);
 		goto out;
 	}
+
+	if (cmd_type =3D=3D _IOC_TYPE(MTIOCSENSE) && cmd_nr =3D=3D _IOC_NR(MTIO=
CSENSE)) {
+		struct mtsense *mt_sensep;
+
+		mt_sensep =3D kzalloc(sizeof(struct mtsense), GFP_KERNEL);
+		if (!mt_sensep) {
+			retval =3D -ENOMEM;
+			goto out;
+		}
+
+		if (STp->saved_sense) {
+			mt_sensep->length =3D _IOC_SIZE(cmd_in) - sizeof(int);
+			mt_sensep->latest =3D STp->saved_sense_latest;
+			if (mt_sensep->length > SCSI_SENSE_BUFFERSIZE)
+				mt_sensep->length =3D SCSI_SENSE_BUFFERSIZE;
+			mt_sensep->cmd =3D STp->saved_sense_cmd;
+			memcpy(mt_sensep->data, STp->saved_sense, SCSI_SENSE_BUFFERSIZE);
+		}
+
+		i =3D copy_to_user(p, mt_sensep, sizeof(struct mtsense));
+		if (i)
+			retval =3D (-EFAULT);
+		kfree(mt_sensep);
+		goto out;
+	}
+
 	mutex_unlock(&STp->lock);
 	switch (cmd_in) {
 		case SCSI_IOCTL_GET_IDLUN:
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index b92712f..b3fb81e 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -27,6 +27,7 @@ struct st_request {
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
 	int result;
+	int save_sense;
 	struct scsi_tape *stp;
 	struct completion *waiting;
 };
@@ -160,6 +161,13 @@ struct scsi_tape {
 	int recover_count;     /* From tape opening */
 	int recover_reg;       /* From last status call */
=20
+	/* The latest sense data to be returned to the user. If the first byte =
is zero,
+	   there is no sense data to return. */
+	unsigned char saved_sense[SCSI_SENSE_BUFFERSIZE];
+	unsigned char saved_sense_cmd;  /* the command resulting in request sen=
se */
+	unsigned char saved_sense_latest; /* is the sense data from the latest =
command
+					     submitted to the device */
+
 #if DEBUG
 	unsigned char write_pending;
 	int nbr_finished;
diff --git a/include/linux/mtio.h b/include/linux/mtio.h
index ef01d6a..96ca0d7 100644
--- a/include/linux/mtio.h
+++ b/include/linux/mtio.h
@@ -122,11 +122,20 @@ struct	mtpos {
 	long 	mt_blkno;	/* current block number */
 };
=20
+/* structure for MTIOCSENSE - mag tape get sense data */
+struct mtsense {
+	__u16 length;		/* length of the returned data */
+	__u8 cmd;		/* the command that returned the sense data */
+	__u8 latest;		/* is this sense data from the latest SCSI command to dev=
ice? */
+	__u8 data[252];		/* space for all data in REQUEST SENSE response */
+};
+
=20
 /* mag tape io control commands */
 #define	MTIOCTOP	_IOW('m', 1, struct mtop)	/* do a mag tape op */
 #define	MTIOCGET	_IOR('m', 2, struct mtget)	/* get tape status */
 #define	MTIOCPOS	_IOR('m', 3, struct mtpos)	/* get tape position */
+#define MTIOCSENSE      _IOR('m', 4, struct mtsense)    /* get latest se=
nse data */
=20
=20
 /* Generic Mag Tape (device independent) status macros for examining
--8323584-1214485543-1215784622=:5811--
