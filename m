From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 1/2] SCSI tape: add option to use SILI in variable block
 reads
Date: Sun, 24 Feb 2008 22:23:24 +0200 (EET)
Message-ID: <alpine.LSU.1.00.0802242220350.5772@kai.makisara.local>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-290811868-1203884605=:5772"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:32908 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYBXUX2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Feb 2008 15:23:28 -0500
Received: from saunalahti-vams (vs3-10.mail.saunalahti.fi [62.142.5.94])
	by emh06-2.mail.saunalahti.fi (Postfix) with SMTP id 89DF1C7E19
	for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2008 22:23:25 +0200 (EET)
Received: from kai.makisara.local (a88-114-81-250.elisa-laajakaista.fi [88.114.81.250])
	by emh06.mail.saunalahti.fi (Postfix) with ESMTP id 64DF3E5557
	for <linux-scsi@vger.kernel.org>; Sun, 24 Feb 2008 22:23:24 +0200 (EET)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-290811868-1203884605=:5772
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Add new option MT_ST_SILI to enable setting the SILI bit in reads in vari=
able
block mode. If SILI is set, reading a block shorter than the byte count d=
oes
not result in CHECK CONDITION. The length of the block is determined usin=
g the
residual count from the HBA. Avoiding the REQUEST SENSE command for every
block speeds up some real applications considerably.

Signed-off-by: Kai Makisara <kai.makisara@kolumbus.fi>
---
The patch is against Feb 24 git version of 2.5.25-rc2. Candidate for
inclusion into 2.6.26.

 Documentation/scsi/st.txt |    7 ++++++-
 drivers/scsi/st.c         |   40 ++++++++++++++++++++++++++++++++++++---=
-
 drivers/scsi/st.h         |    3 +++
 drivers/scsi/st_options.h |    6 +++++-
 include/linux/mtio.h      |    1 +
 5 files changed, 51 insertions(+), 6 deletions(-)

Index: linux-2.6.25-rc2-q/drivers/scsi/st.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.25-rc2-q.orig/drivers/scsi/st.c
+++ linux-2.6.25-rc2-q/drivers/scsi/st.c
@@ -17,7 +17,7 @@
    Last modified: 18-JAN-1998 Richard Gooch <rgooch@atnf.csiro.au> Devfs=
 support
  */
=20
-static const char *verstr =3D "20080221";
+static const char *verstr =3D "20080224";
=20
 #include <linux/module.h>
=20
@@ -183,6 +183,7 @@ static int modes_defined;
=20
 static struct st_buffer *new_tape_buffer(int, int, int);
 static int enlarge_buffer(struct st_buffer *, int, int);
+static void clear_buffer(struct st_buffer *);
 static void normalize_buffer(struct st_buffer *);
 static int append_to_buffer(const char __user *, struct st_buffer *, int=
);
 static int from_buffer(struct st_buffer *, char __user *, int);
@@ -442,6 +443,7 @@ static void st_sleep_done(void *data, ch
=20
 	memcpy(SRpnt->sense, sense, SCSI_SENSE_BUFFERSIZE);
 	(STp->buffer)->cmdstat.midlevel_result =3D SRpnt->result =3D result;
+	(STp->buffer)->cmdstat.residual =3D resid;
 	DEB( STp->write_pending =3D 0; )
=20
 	if (SRpnt->waiting)
@@ -1159,6 +1161,7 @@ static int st_open(struct inode *inode,=20
 		goto err_out;
 	}
=20
+	(STp->buffer)->cleared =3D 0;
 	(STp->buffer)->writing =3D 0;
 	(STp->buffer)->syscall_result =3D 0;
=20
@@ -1432,8 +1435,14 @@ static int setup_buffering(struct scsi_t
 		if (STp->block_size)
 			bufsize =3D STp->block_size > st_fixed_buffer_size ?
 				STp->block_size : st_fixed_buffer_size;
-		else
+		else {
 			bufsize =3D count;
+			/* Make sure that data from previous user is not leaked even if
+			   HBA does not return correct residual */
+			if (is_read && STp->sili && !STbp->cleared)
+				clear_buffer(STbp);
+		}
+
 		if (bufsize > STbp->buffer_size &&
 		    !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
 			printk(KERN_WARNING "%s: Can't allocate %d byte tape buffer.\n",
@@ -1783,6 +1792,8 @@ static long read_tape(struct scsi_tape *
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] =3D READ_6;
 	cmd[1] =3D (STp->block_size !=3D 0);
+	if (!cmd[1] && STp->sili)
+		cmd[1] |=3D 2;
 	cmd[2] =3D blks >> 16;
 	cmd[3] =3D blks >> 8;
 	cmd[4] =3D blks;
@@ -1911,8 +1922,11 @@ static long read_tape(struct scsi_tape *
=20
 	}
 	/* End of error handling */=20
-	else			/* Read successful */
+	else {			/* Read successful */
 		STbp->buffer_bytes =3D bytes;
+		if (STp->sili) /* In fixed block mode residual is always zero here */
+			STbp->buffer_bytes -=3D STp->buffer->cmdstat.residual;
+	}
=20
 	if (STps->drv_block >=3D 0) {
 		if (STp->block_size =3D=3D 0)
@@ -2090,7 +2104,8 @@ static void st_log_options(struct scsi_t
 		       name, STm->defaults_for_writes, STp->omit_blklims, STp->can_par=
titions,
 		       STp->scsi2_logical);
 		printk(KERN_INFO
-		       "%s:    sysv: %d nowait: %d\n", name, STm->sysv, STp->immediate=
);
+		       "%s:    sysv: %d nowait: %d sili: %d\n", name, STm->sysv, STp->=
immediate,
+			STp->sili);
 		printk(KERN_INFO "%s:    debugging: %d\n",
 		       name, debugging);
 	}
@@ -2133,6 +2148,7 @@ static int st_set_options(struct scsi_ta
 		STp->scsi2_logical =3D (options & MT_ST_SCSI2LOGICAL) !=3D 0;
 		STp->immediate =3D (options & MT_ST_NOWAIT) !=3D 0;
 		STm->sysv =3D (options & MT_ST_SYSV) !=3D 0;
+		STp->sili =3D (options & MT_ST_SILI) !=3D 0;
 		DEB( debugging =3D (options & MT_ST_DEBUGGING) !=3D 0;
 		     st_log_options(STp, STm, name); )
 	} else if (code =3D=3D MT_ST_SETBOOLEANS || code =3D=3D MT_ST_CLEARBOOL=
EANS) {
@@ -2164,6 +2180,8 @@ static int st_set_options(struct scsi_ta
 			STp->immediate =3D value;
 		if ((options & MT_ST_SYSV) !=3D 0)
 			STm->sysv =3D value;
+		if ((options & MT_ST_SILI) !=3D 0)
+			STp->sili =3D value;
                 DEB(
 		if ((options & MT_ST_DEBUGGING) !=3D 0)
 			debugging =3D value;
@@ -3655,6 +3673,8 @@ static int enlarge_buffer(struct st_buff
 		STbuffer->frp_segs +=3D 1;
 		got +=3D b_size;
 		STbuffer->buffer_size =3D got;
+		if (STbuffer->cleared)
+			memset(page_address(STbuffer->frp[segs].page), 0, b_size);
 		segs++;
 	}
 	STbuffer->b_data =3D page_address(STbuffer->frp[0].page);
@@ -3663,6 +3683,17 @@ static int enlarge_buffer(struct st_buff
 }
=20
=20
+/* Make sure that no data from previous user is in the internal buffer *=
/
+static void clear_buffer(struct st_buffer * st_bp)
+{
+	int i;
+
+	for (i=3D0; i < st_bp->frp_segs; i++)
+		memset(page_address(st_bp->frp[i].page), 0, st_bp->frp[i].length);
+	st_bp->cleared =3D 1;
+}
+
+
 /* Release the extra buffer */
 static void normalize_buffer(struct st_buffer * STbuffer)
 {
@@ -3987,6 +4018,7 @@ static int st_probe(struct device *dev)
 	tpnt->two_fm =3D ST_TWO_FM;
 	tpnt->fast_mteom =3D ST_FAST_MTEOM;
 	tpnt->scsi2_logical =3D ST_SCSI2LOGICAL;
+	tpnt->sili =3D ST_SILI;
 	tpnt->immediate =3D ST_NOWAIT;
 	tpnt->default_drvbuffer =3D 0xff;		/* No forced buffering */
 	tpnt->partition =3D 0;
Index: linux-2.6.25-rc2-q/drivers/scsi/st.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.25-rc2-q.orig/drivers/scsi/st.h
+++ linux-2.6.25-rc2-q/drivers/scsi/st.h
@@ -12,6 +12,7 @@ struct st_cmdstatus {
 	int midlevel_result;
 	struct scsi_sense_hdr sense_hdr;
 	int have_sense;
+	int residual;
 	u64 uremainder64;
 	u8 flags;
 	u8 remainder_valid;
@@ -34,6 +35,7 @@ struct st_request {
 struct st_buffer {
 	unsigned char dma;	/* DMA-able buffer */
 	unsigned char do_dio;   /* direct i/o set up? */
+	unsigned char cleared;  /* internal buffer cleared after open? */
 	int buffer_size;
 	int buffer_blocks;
 	int buffer_bytes;
@@ -122,6 +124,7 @@ struct scsi_tape {
 	unsigned char try_dio_now;		/* try direct i/o before next close? */
 	unsigned char c_algo;			/* compression algorithm */
 	unsigned char pos_unknown;			/* after reset position unknown */
+	unsigned char sili;			/* use SILI when reading in variable b mode */
 	int tape_type;
 	int long_timeout;	/* timeout for commands known to take long time */
=20
Index: linux-2.6.25-rc2-q/drivers/scsi/st_options.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.25-rc2-q.orig/drivers/scsi/st_options.h
+++ linux-2.6.25-rc2-q/drivers/scsi/st_options.h
@@ -3,7 +3,7 @@
=20
    Copyright 1995-2003 Kai Makisara.
=20
-   Last modified: Mon Apr  7 22:49:18 2003 by makisara
+   Last modified: Thu Feb 21 21:47:07 2008 by kai.makisara
 */
=20
 #ifndef _ST_OPTIONS_H
@@ -94,6 +94,10 @@
    The default is BSD semantics. */
 #define ST_SYSV 0
=20
+/* If ST_SILI is non-zero, the SILI bit is set when reading in variable =
block
+   mode and the block size is determined using the residual returned by =
the HBA. */
+#define ST_SILI 0
+
 /* Time to wait for the drive to become ready if blocking open */
 #define ST_BLOCK_SECONDS     120
=20
Index: linux-2.6.25-rc2-q/include/linux/mtio.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.25-rc2-q.orig/include/linux/mtio.h
+++ linux-2.6.25-rc2-q/include/linux/mtio.h
@@ -192,6 +192,7 @@ struct	mtpos {
 #define MT_ST_SCSI2LOGICAL      0x800
 #define MT_ST_SYSV              0x1000
 #define MT_ST_NOWAIT            0x2000
+#define MT_ST_SILI		0x4000
=20
 /* The mode parameters to be controlled. Parameter chosen with bits 20-2=
8 */
 #define MT_ST_CLEAR_DEFAULT	0xfffff
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
-Last modified: Mon Mar  7 21:14:44 2005 by kai.makisara
+Last modified: Thu Feb 21 21:54:16 2008 by kai.makisara
=20
=20
 BASICS
@@ -372,6 +372,11 @@ MTSETDRVBUFFER
 	     MT_ST_SYSV sets the SYSV semantics (mode)
 	     MT_ST_NOWAIT enables immediate mode (i.e., don't wait for
 	        the command to finish) for some commands (e.g., rewind)
+	     MT_ST_SILI enables setting the SILI bit in SCSI commands when
+		reading in variable block mode to enhance performance when
+		reading blocks shorter than the byte count; set this only
+		if you are sure that the drive supports SILI and the HBA
+		correctly returns transfer residuals
 	     MT_ST_DEBUGGING debugging (global; debugging must be
 		compiled into the driver)
 	MT_ST_SETBOOLEANS
---1463811327-290811868-1203884605=:5772--
