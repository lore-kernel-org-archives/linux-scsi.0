From: Hannes Reinecke <hare@suse.de>
Subject: =?UTF-8?q?=5BPATCH=204/6=5D=20scsi=3A=20Implement=20st=5Fprintk=28=29?=
Date: Tue,  3 Jun 2014 13:22:55 +0200
Message-ID: <1401794577-102277-5-git-send-email-hare@suse.de>
References: <1401794577-102277-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38552 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753440AbaFCLXC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jun 2014 07:23:02 -0400
In-Reply-To: <1401794577-102277-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>

Update the st driver to use dev_printk() variants instead of
plain printk(); this will prefix logging messages with the
appropriate device.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>
---
 drivers/scsi/st.c | 605 ++++++++++++++++++++++++++++------------------=
--------
 1 file changed, 311 insertions(+), 294 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index afc834e..721d840 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -58,11 +58,11 @@ static const char *verstr =3D "20101219";
    is defined and non-zero. */
 #define DEBUG 0
=20
+#define ST_DEB_MSG  KERN_NOTICE
 #if DEBUG
 /* The message level for the debug messages is currently set to KERN_N=
OTICE
    so that people can easily see the messages. Later when the debuggin=
g messages
    in the drivers are more widely classified, this may be changed to K=
ERN_DEBUG. */
-#define ST_DEB_MSG  KERN_NOTICE
 #define DEB(a) a
 #define DEBC(a) if (debugging) { a ; }
 #else
@@ -305,6 +305,15 @@ static inline char *tape_name(struct scsi_tape *ta=
pe)
 	return tape->disk->disk_name;
 }
=20
+#define st_printk(prefix, t, fmt, a...) \
+	sdev_printk(prefix, (t)->device, "%s: " fmt, \
+		    tape_name(t), ##a)
+#ifdef DEBUG
+#define DEBC_printk(t, fmt, a...) \
+	if (debugging) { st_printk(ST_DEB_MSG, t, fmt, ##a ); }
+#else
+#define DEBC_printk(t, fmt, a...)
+#endif
=20
 static void st_analyze_sense(struct st_request *SRpnt, struct st_cmdst=
atus *s)
 {
@@ -358,21 +367,20 @@ static int st_chk_result(struct scsi_tape *STp, s=
truct st_request * SRpnt)
 	else
 		scode =3D 0;
=20
-        DEB(
-        if (debugging) {
-                printk(ST_DEB_MSG "%s: Error: %x, cmd: %x %x %x %x %x =
%x\n",
-		       name, result,
-		       SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
-		       SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
+	DEB(
+	if (debugging) {
+		st_printk(ST_DEB_MSG, STp,
+			    "Error: %x, cmd: %x %x %x %x %x %x\n", result,
+			    SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
+			    SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
 			 __scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
-			printk(KERN_WARNING
-			       "%s: Error %x (driver bt 0x%x, host bt 0x%x).\n",
-			       name, result, driver_byte(result),
-			       host_byte(result));
+			st_printk(KERN_WARNING, STp,
+			       "Error %x (driver bt 0x%x, host bt 0x%x).\n",
+			       result, driver_byte(result), host_byte(result));
 		else if (cmdstatp->have_sense &&
 			 scode !=3D NO_SENSE &&
 			 scode !=3D RECOVERED_ERROR &&
@@ -411,7 +419,7 @@ static int st_chk_result(struct scsi_tape *STp, str=
uct st_request * SRpnt)
 		STp->recover_count++;
 		STp->recover_reg++;
=20
-                DEB(
+		DEB(
 		if (debugging) {
 			if (SRpnt->cmd[0] =3D=3D READ_6)
 				stp =3D "read";
@@ -419,8 +427,9 @@ static int st_chk_result(struct scsi_tape *STp, str=
uct st_request * SRpnt)
 				stp =3D "write";
 			else
 				stp =3D "ioctl";
-			printk(ST_DEB_MSG "%s: Recovered %s error (%d).\n", name, stp,
-			       STp->recover_count);
+			st_printk(ST_DEB_MSG, STp,
+				  "Recovered %s error (%d).\n",
+				  stp, STp->recover_count);
 		} ) /* end DEB */
=20
 		if (cmdstatp->flags =3D=3D 0)
@@ -437,8 +446,8 @@ static struct st_request *st_allocate_request(struc=
t scsi_tape *stp)
 	if (streq)
 		streq->stp =3D stp;
 	else {
-		DEBC(printk(KERN_ERR "%s: Can't get SCSI request.\n",
-			    tape_name(stp)););
+		st_printk(KERN_ERR, stp,
+			  "Can't get SCSI request.\n");
 		if (signal_pending(current))
 			stp->buffer->syscall_result =3D -EINTR;
 		else
@@ -525,8 +534,8 @@ st_do_scsi(struct st_request * SRpnt, struct scsi_t=
ape * STp, unsigned char *cmd
=20
 	/* if async, make sure there's no command outstanding */
 	if (!do_wait && ((STp->buffer)->last_SRpnt)) {
-		printk(KERN_ERR "%s: Async command already active.\n",
-		       tape_name(STp));
+		st_printk(KERN_ERR, STp,
+			  "Async command already active.\n");
 		if (signal_pending(current))
 			(STp->buffer)->syscall_result =3D (-EINTR);
 		else
@@ -597,12 +606,12 @@ static int write_behind_check(struct scsi_tape * =
STp)
 	if (!STbuffer->writing)
 		return 0;
=20
-        DEB(
+	DEB(
 	if (STp->write_pending)
 		STp->nbr_waits++;
 	else
 		STp->nbr_finished++;
-        ) /* end DEB */
+	) /* end DEB */
=20
 	wait_for_completion(&(STp->wait));
 	SRpnt =3D STbuffer->last_SRpnt;
@@ -639,8 +648,9 @@ static int write_behind_check(struct scsi_tape * ST=
p)
 	STbuffer->writing =3D 0;
=20
 	DEB(if (debugging && retval)
-	    printk(ST_DEB_MSG "%s: Async write error %x, return value %d.\n",
-		   tape_name(STp), STbuffer->cmdstat.midlevel_result, retval);) /* e=
nd DEB */
+		    st_printk(ST_DEB_MSG, STp,
+				"Async write error %x, return value %d.\n",
+				STbuffer->cmdstat.midlevel_result, retval);) /* end DEB */
=20
 	return retval;
 }
@@ -662,8 +672,8 @@ static int cross_eof(struct scsi_tape * STp, int fo=
rward)
 		cmd[2] =3D cmd[3] =3D cmd[4] =3D 0xff;	/* -1 filemarks */
 	cmd[5] =3D 0;
=20
-        DEBC(printk(ST_DEB_MSG "%s: Stepping over filemark %s.\n",
-		   tape_name(STp), forward ? "forward" : "backward"));
+	DEBC_printk(STp, "Stepping over filemark %s.\n",
+		    forward ? "forward" : "backward");
=20
 	SRpnt =3D st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
 			   STp->device->request_queue->rq_timeout,
@@ -675,8 +685,9 @@ static int cross_eof(struct scsi_tape * STp, int fo=
rward)
 	SRpnt =3D NULL;
=20
 	if ((STp->buffer)->cmdstat.midlevel_result !=3D 0)
-		printk(KERN_ERR "%s: Stepping over filemark %s failed.\n",
-		   tape_name(STp), forward ? "forward" : "backward");
+		st_printk(KERN_ERR, STp,
+			  "Stepping over filemark %s failed.\n",
+			  forward ? "forward" : "backward");
=20
 	return (STp->buffer)->syscall_result;
 }
@@ -699,8 +710,7 @@ static int st_flush_write_buffer(struct scsi_tape *=
 STp)
 	if (STp->dirty =3D=3D 1) {
=20
 		transfer =3D STp->buffer->buffer_bytes;
-                DEBC(printk(ST_DEB_MSG "%s: Flushing %d bytes.\n",
-                               tape_name(STp), transfer));
+		DEBC_printk(STp, "Flushing %d bytes.\n", transfer);
=20
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] =3D WRITE_6;
@@ -732,8 +742,7 @@ static int st_flush_write_buffer(struct scsi_tape *=
 STp)
 					STps->drv_block +=3D blks;
 				result =3D (-ENOSPC);
 			} else {
-				printk(KERN_ERR "%s: Error on flush.\n",
-                                       tape_name(STp));
+				st_printk(KERN_ERR, STp, "Error on flush.\n");
 				STps->drv_block =3D (-1);
 				result =3D (-EIO);
 			}
@@ -811,7 +820,6 @@ static int set_mode_densblk(struct scsi_tape * STp,=
 struct st_modedef * STm)
 {
 	int set_it =3D 0;
 	unsigned long arg;
-	char *name =3D tape_name(STp);
=20
 	if (!STp->density_changed &&
 	    STm->default_density >=3D 0 &&
@@ -830,9 +838,10 @@ static int set_mode_densblk(struct scsi_tape * STp=
, struct st_modedef * STm)
 		arg |=3D STp->block_size;
 	if (set_it &&
 	    st_int_ioctl(STp, SET_DENS_AND_BLK, arg)) {
-		printk(KERN_WARNING
-		       "%s: Can't set default block size to %d bytes and density %x.=
\n",
-		       name, STm->default_blksize, STm->default_density);
+		st_printk(KERN_WARNING, STp,
+			  "Can't set default block size to %d bytes "
+			  "and density %x.\n",
+			  STm->default_blksize, STm->default_density);
 		if (modes_defined)
 			return (-EINVAL);
 	}
@@ -844,12 +853,9 @@ static int set_mode_densblk(struct scsi_tape * STp=
, struct st_modedef * STm)
 static int do_door_lock(struct scsi_tape * STp, int do_lock)
 {
 	int retval, cmd;
-	DEB(char *name =3D tape_name(STp);)
-
=20
 	cmd =3D do_lock ? SCSI_IOCTL_DOORLOCK : SCSI_IOCTL_DOORUNLOCK;
-	DEBC(printk(ST_DEB_MSG "%s: %socking drive door.\n", name,
-		    do_lock ? "L" : "Unl"));
+	DEBC_printk(STp, "%socking drive door.\n", do_lock ? "L" : "Unl");
 	retval =3D scsi_ioctl(STp->device, cmd, NULL);
 	if (!retval) {
 		STp->door_locked =3D do_lock ? ST_LOCKED_EXPLICIT : ST_UNLOCKED;
@@ -976,15 +982,14 @@ static int check_tape(struct scsi_tape *STp, stru=
ct file *filp)
 	struct st_request *SRpnt =3D NULL;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
-	char *name =3D tape_name(STp);
 	struct inode *inode =3D file_inode(filp);
 	int mode =3D TAPE_MODE(inode);
=20
 	STp->ready =3D ST_READY;
=20
 	if (mode !=3D STp->current_mode) {
-                DEBC(printk(ST_DEB_MSG "%s: Mode change from %d to %d.=
\n",
-			       name, STp->current_mode, mode));
+		DEBC_printk(STp, "Mode change from %d to %d.\n",
+			    STp->current_mode, mode);
 		new_session =3D 1;
 		STp->current_mode =3D mode;
 	}
@@ -1055,13 +1060,12 @@ static int check_tape(struct scsi_tape *STp, st=
ruct file *filp)
 			STp->min_block =3D ((STp->buffer)->b_data[4] << 8) |
 			    (STp->buffer)->b_data[5];
 			if ( DEB( debugging || ) !STp->inited)
-				printk(KERN_INFO
-                                       "%s: Block limits %d - %d bytes=
=2E\n", name,
-                                       STp->min_block, STp->max_block)=
;
+				st_printk(KERN_INFO, STp,
+					  "Block limits %d - %d bytes.\n",
+					  STp->min_block, STp->max_block);
 		} else {
 			STp->min_block =3D STp->max_block =3D (-1);
-                        DEBC(printk(ST_DEB_MSG "%s: Can't read block l=
imits.\n",
-                                       name));
+			DEBC_printk(STp, "Can't read block limits.\n");
 		}
 	}
=20
@@ -1078,56 +1082,58 @@ static int check_tape(struct scsi_tape *STp, st=
ruct file *filp)
 	}
=20
 	if ((STp->buffer)->syscall_result !=3D 0) {
-                DEBC(printk(ST_DEB_MSG "%s: No Mode Sense.\n", name));
+		DEBC_printk(STp, "No Mode Sense.\n");
 		STp->block_size =3D ST_DEFAULT_BLOCK;	/* Educated guess (?) */
 		(STp->buffer)->syscall_result =3D 0;	/* Prevent error propagation */
 		STp->drv_write_prot =3D 0;
 	} else {
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Mode sense. Length %d, medium %x, WBS=
 %x, BLL %d\n",
-                            name,
-                            (STp->buffer)->b_data[0], (STp->buffer)->b=
_data[1],
-                            (STp->buffer)->b_data[2], (STp->buffer)->b=
_data[3]));
+		DEBC_printk(STp,"Mode sense. Length %d, "
+			    "medium %x, WBS %x, BLL %d\n",
+			    (STp->buffer)->b_data[0],
+			    (STp->buffer)->b_data[1],
+			    (STp->buffer)->b_data[2],
+			    (STp->buffer)->b_data[3]);
=20
 		if ((STp->buffer)->b_data[3] >=3D 8) {
 			STp->drv_buffer =3D ((STp->buffer)->b_data[2] >> 4) & 7;
 			STp->density =3D (STp->buffer)->b_data[4];
 			STp->block_size =3D (STp->buffer)->b_data[9] * 65536 +
 			    (STp->buffer)->b_data[10] * 256 + (STp->buffer)->b_data[11];
-                        DEBC(printk(ST_DEB_MSG
-                                    "%s: Density %x, tape length: %x, =
drv buffer: %d\n",
-                                    name, STp->density, (STp->buffer)-=
>b_data[5] * 65536 +
-                                    (STp->buffer)->b_data[6] * 256 + (=
STp->buffer)->b_data[7],
-                                    STp->drv_buffer));
+			DEBC_printk(STp, "Density %x, tape length: %x, "
+				    "drv buffer: %d\n",
+				    STp->density,
+				    (STp->buffer)->b_data[5] * 65536 +
+				    (STp->buffer)->b_data[6] * 256 +
+				    (STp->buffer)->b_data[7],
+				    STp->drv_buffer);
 		}
 		STp->drv_write_prot =3D ((STp->buffer)->b_data[2] & 0x80) !=3D 0;
 		if (!STp->drv_buffer && STp->immediate_filemark) {
-			printk(KERN_WARNING
-			    "%s: non-buffered tape: disabling writing immediate filemarks\n=
",
-			    name);
+			st_printk(KERN_WARNING, STp,
+				  "non-buffered tape: disabling "
+				  "writing immediate filemarks\n");
 			STp->immediate_filemark =3D 0;
 		}
 	}
 	st_release_request(SRpnt);
 	SRpnt =3D NULL;
-        STp->inited =3D 1;
+	STp->inited =3D 1;
=20
 	if (STp->block_size > 0)
 		(STp->buffer)->buffer_blocks =3D
-                        (STp->buffer)->buffer_size / STp->block_size;
+			(STp->buffer)->buffer_size / STp->block_size;
 	else
 		(STp->buffer)->buffer_blocks =3D 1;
 	(STp->buffer)->buffer_bytes =3D (STp->buffer)->read_pointer =3D 0;
=20
-        DEBC(printk(ST_DEB_MSG
-                       "%s: Block size: %d, buffer size: %d (%d blocks=
).\n", name,
-		       STp->block_size, (STp->buffer)->buffer_size,
-		       (STp->buffer)->buffer_blocks));
+	DEBC_printk(STp, "Block size: %d, buffer size: %d (%d blocks).\n",
+		    STp->block_size, (STp->buffer)->buffer_size,
+		    (STp->buffer)->buffer_blocks);
=20
 	if (STp->drv_write_prot) {
 		STp->write_prot =3D 1;
=20
-                DEBC(printk(ST_DEB_MSG "%s: Write protected\n", name))=
;
+		DEBC_printk(STp, "Write protected\n");
=20
 		if (do_wait &&
 		    ((st_flags & O_ACCMODE) =3D=3D O_WRONLY ||
@@ -1141,8 +1147,7 @@ static int check_tape(struct scsi_tape *STp, stru=
ct file *filp)
 		/* This code is reached when the device is opened for the first time
 		   after the driver has been initialized with tape in the drive and =
the
 		   partition support has been enabled. */
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Updating partition number in status.\=
n", name));
+		DEBC_printk(STp, "Updating partition number in status.\n");
 		if ((STp->partition =3D find_partition(STp)) < 0) {
 			retval =3D STp->partition;
 			goto err_out;
@@ -1160,9 +1165,10 @@ static int check_tape(struct scsi_tape *STp, str=
uct file *filp)
=20
 		if (STp->default_drvbuffer !=3D 0xff) {
 			if (st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer))
-				printk(KERN_WARNING
-                                       "%s: Can't set default drive bu=
ffering to %d.\n",
-				       name, STp->default_drvbuffer);
+				st_printk(KERN_WARNING, STp,
+					  "Can't set default drive "
+					  "buffering to %d.\n",
+					  STp->default_drvbuffer);
 		}
 	}
=20
@@ -1182,7 +1188,6 @@ static int st_open(struct inode *inode, struct fi=
le *filp)
 	struct scsi_tape *STp;
 	struct st_partstat *STps;
 	int dev =3D TAPE_NR(inode);
-	char *name;
=20
 	/*
 	 * We really want to do nonseekable_open(inode, filp); here, but some
@@ -1196,13 +1201,12 @@ static int st_open(struct inode *inode, struct =
file *filp)
 	}
=20
 	filp->private_data =3D STp;
-	name =3D tape_name(STp);
=20
 	spin_lock(&st_use_lock);
 	if (STp->in_use) {
 		spin_unlock(&st_use_lock);
 		scsi_tape_put(STp);
-		DEB( printk(ST_DEB_MSG "%s: Device already in use.\n", name); )
+		DEBC_printk(STp, "Device already in use.\n");
 		return (-EBUSY);
 	}
=20
@@ -1222,8 +1226,8 @@ static int st_open(struct inode *inode, struct fi=
le *filp)
=20
 	/* See that we have at least a one page buffer available */
 	if (!enlarge_buffer(STp->buffer, PAGE_SIZE, STp->restr_dma)) {
-		printk(KERN_WARNING "%s: Can't allocate one page tape buffer.\n",
-		       name);
+		st_printk(KERN_WARNING, STp,
+			  "Can't allocate one page tape buffer.\n");
 		retval =3D (-EOVERFLOW);
 		goto err_out;
 	}
@@ -1279,7 +1283,6 @@ static int st_flush(struct file *filp, fl_owner_t=
 id)
 	struct scsi_tape *STp =3D filp->private_data;
 	struct st_modedef *STm =3D &(STp->modes[STp->current_mode]);
 	struct st_partstat *STps =3D &(STp->ps[STp->partition]);
-	char *name =3D tape_name(STp);
=20
 	if (file_count(filp) > 1)
 		return 0;
@@ -1292,24 +1295,25 @@ static int st_flush(struct file *filp, fl_owner=
_t id)
=20
 	if (STp->can_partitions &&
 	    (result2 =3D switch_partition(STp)) < 0) {
-                DEBC(printk(ST_DEB_MSG
-                               "%s: switch_partition at close failed.\=
n", name));
+		DEBC_printk(STp, "switch_partition at close failed.\n");
 		if (result =3D=3D 0)
 			result =3D result2;
 		goto out;
 	}
=20
 	DEBC( if (STp->nbr_requests)
-		printk(KERN_DEBUG "%s: Number of r/w requests %d, dio used in %d, pa=
ges %d.\n",
-		       name, STp->nbr_requests, STp->nbr_dio, STp->nbr_pages));
+		st_printk(KERN_DEBUG, STp,
+			  "Number of r/w requests %d, dio used in %d, "
+			  "pages %d.\n", STp->nbr_requests, STp->nbr_dio,
+			  STp->nbr_pages));
=20
 	if (STps->rw =3D=3D ST_WRITING && !STp->pos_unknown) {
 		struct st_cmdstatus *cmdstatp =3D &STp->buffer->cmdstat;
=20
-                DEBC(printk(ST_DEB_MSG "%s: Async write waits %d, fini=
shed %d.\n",
-                            name, STp->nbr_waits, STp->nbr_finished);
-		)
-
+#if DEBUG
+		DEBC_printk(STp, "Async write waits %d, finished %d.\n",
+			    STp->nbr_waits, STp->nbr_finished);
+#endif
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] =3D WRITE_FILEMARKS;
 		if (STp->immediate_filemark)
@@ -1343,13 +1347,13 @@ static int st_flush(struct file *filp, fl_owner=
_t id)
 		else { /* Write error */
 			st_release_request(SRpnt);
 			SRpnt =3D NULL;
-			printk(KERN_ERR "%s: Error on write filemark.\n", name);
+			st_printk(KERN_ERR, STp,
+				  "Error on write filemark.\n");
 			if (result =3D=3D 0)
 				result =3D (-EIO);
 		}
=20
-                DEBC(printk(ST_DEB_MSG "%s: Buffer flushed, %d EOF(s) =
written\n",
-                            name, cmd[4]));
+		DEBC_printk(STp, "Buffer flushed, %d EOF(s) written\n", cmd[4]);
 	} else if (!STp->rew_at_close) {
 		STps =3D &(STp->ps[STp->partition]);
 		if (!STm->sysv || STps->rw !=3D ST_READING) {
@@ -1447,9 +1451,10 @@ static ssize_t rw_checks(struct scsi_tape *STp, =
struct file *filp, size_t count)
 	if (count =3D=3D 0)
 		goto out;
=20
-        DEB(
+	DEB(
 	if (!STp->in_use) {
-		printk(ST_DEB_MSG "%s: Incorrect device.\n", tape_name(STp));
+		st_printk(ST_DEB_MSG, STp,
+			  "Incorrect device.\n");
 		retval =3D (-EIO);
 		goto out;
 	} ) /* end DEB */
@@ -1519,8 +1524,9 @@ static int setup_buffering(struct scsi_tape *STp,=
 const char __user *buf,
=20
 		if (bufsize > STbp->buffer_size &&
 		    !enlarge_buffer(STbp, bufsize, STp->restr_dma)) {
-			printk(KERN_WARNING "%s: Can't allocate %d byte tape buffer.\n",
-			       tape_name(STp), bufsize);
+			st_printk(KERN_WARNING, STp,
+				  "Can't allocate %d byte tape buffer.\n",
+				  bufsize);
 			retval =3D (-EOVERFLOW);
 			goto out;
 		}
@@ -1563,7 +1569,6 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *STbp;
-	char *name =3D tape_name(STp);
=20
 	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
@@ -1574,8 +1579,8 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
=20
 	/* Write must be integral number of blocks */
 	if (STp->block_size !=3D 0 && (count % STp->block_size) !=3D 0) {
-		printk(KERN_WARNING "%s: Write not multiple of tape block size.\n",
-		       name);
+		st_printk(KERN_WARNING, STp,
+			  "Write not multiple of tape block size.\n");
 		retval =3D (-EINVAL);
 		goto out;
 	}
@@ -1601,8 +1606,8 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
 		if (STm->default_compression !=3D ST_DONT_TOUCH &&
 		    !(STp->compression_changed)) {
 			if (st_compression(STp, (STm->default_compression =3D=3D ST_YES))) =
{
-				printk(KERN_WARNING "%s: Can't set default compression.\n",
-				       name);
+				st_printk(KERN_WARNING, STp,
+					  "Can't set default compression.\n");
 				if (modes_defined) {
 					retval =3D (-EINVAL);
 					goto out;
@@ -1723,7 +1728,7 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
 		if (STbp->syscall_result !=3D 0) {
 			struct st_cmdstatus *cmdstatp =3D &STp->buffer->cmdstat;
=20
-                        DEBC(printk(ST_DEB_MSG "%s: Error on write:\n"=
, name));
+			DEBC_printk(STp, "Error on write:\n");
 			if (cmdstatp->have_sense && (cmdstatp->flags & SENSE_EOM)) {
 				scode =3D cmdstatp->sense_hdr.sense_key;
 				if (cmdstatp->remainder_valid)
@@ -1750,9 +1755,9 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
 					if (STp->block_size =3D=3D 0 ||
 					    undone > 0 || count =3D=3D 0)
 						retval =3D (-ENOSPC); /* EOM within current request */
-                                        DEBC(printk(ST_DEB_MSG
-                                                       "%s: EOM with %=
d bytes unwritten.\n",
-						       name, (int)count));
+					DEBC_printk(STp, "EOM with %d "
+						    "bytes unwritten.\n",
+						    (int)count);
 				} else {
 					/* EOT within data buffered earlier (possible only
 					   in fixed block mode without direct i/o) */
@@ -1765,9 +1770,10 @@ st_write(struct file *filp, const char __user *b=
uf, size_t count, loff_t * ppos)
 								STp->block_size;
 						}
 						STps->eof =3D ST_EOM_OK;
-						DEBC(printk(ST_DEB_MSG
-							    "%s: Retry write of %d bytes at EOM.\n",
-							    name, STp->buffer->buffer_bytes));
+						DEBC_printk(STp, "Retry "
+							    "write of %d "
+							    "bytes at EOM.\n",
+							    STp->buffer->buffer_bytes);
 						goto retry_write;
 					}
 					else {
@@ -1778,9 +1784,8 @@ st_write(struct file *filp, const char __user *bu=
f, size_t count, loff_t * ppos)
 						STps->eof =3D ST_EOM_ERROR;
 						STps->drv_block =3D (-1); /* Too cautious? */
 						retval =3D (-EIO);	/* EOM for old data */
-						DEBC(printk(ST_DEB_MSG
-							    "%s: EOM with lost data.\n",
-							    name));
+						DEBC_printk(STp, "EOM with "
+							    "lost data.\n");
 					}
 				}
 			} else {
@@ -1839,7 +1844,6 @@ static long read_tape(struct scsi_tape *STp, long=
 count,
 	struct st_partstat *STps;
 	struct st_buffer *STbp;
 	int retval =3D 0;
-	char *name =3D tape_name(STp);
=20
 	if (count =3D=3D 0)
 		return 0;
@@ -1891,12 +1895,12 @@ static long read_tape(struct scsi_tape *STp, lo=
ng count,
 		struct st_cmdstatus *cmdstatp =3D &STp->buffer->cmdstat;
=20
 		retval =3D 1;
-		DEBC(printk(ST_DEB_MSG "%s: Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n=
",
-                            name,
-                            SRpnt->sense[0], SRpnt->sense[1],
-                            SRpnt->sense[2], SRpnt->sense[3],
-                            SRpnt->sense[4], SRpnt->sense[5],
-                            SRpnt->sense[6], SRpnt->sense[7]));
+		DEBC_printk(STp,
+			    "Sense: %2x %2x %2x %2x %2x %2x %2x %2x\n",
+			    SRpnt->sense[0], SRpnt->sense[1],
+			    SRpnt->sense[2], SRpnt->sense[3],
+			    SRpnt->sense[4], SRpnt->sense[5],
+			    SRpnt->sense[6], SRpnt->sense[7]);
 		if (cmdstatp->have_sense) {
=20
 			if (cmdstatp->sense_hdr.sense_key =3D=3D BLANK_CHECK)
@@ -1913,23 +1917,27 @@ static long read_tape(struct scsi_tape *STp, lo=
ng count,
 					transfer =3D bytes;
=20
 				if (cmdstatp->flags & SENSE_ILI) {	/* ILI */
-					if (STp->block_size =3D=3D 0) {
-						if (transfer <=3D 0) {
-							if (transfer < 0)
-								printk(KERN_NOTICE
-								       "%s: Failed to read %d byte block with %d byte transfer=
=2E\n",
-								       name, bytes - transfer, bytes);
-							if (STps->drv_block >=3D 0)
-								STps->drv_block +=3D 1;
-							STbp->buffer_bytes =3D 0;
-							return (-ENOMEM);
-						}
+					if (STp->block_size =3D=3D 0 &&
+					    transfer < 0) {
+						st_printk(KERN_NOTICE, STp,
+							  "Failed to read %d "
+							  "byte block with %d "
+							  "byte transfer.\n",
+							  bytes - transfer,
+							  bytes);
+						if (STps->drv_block >=3D 0)
+							STps->drv_block +=3D 1;
+						STbp->buffer_bytes =3D 0;
+						return (-ENOMEM);
+					} else if (STp->block_size =3D=3D 0) {
 						STbp->buffer_bytes =3D bytes - transfer;
 					} else {
 						st_release_request(SRpnt);
 						SRpnt =3D *aSRpnt =3D NULL;
 						if (transfer =3D=3D blks) {	/* We did not get anything, error */
-							printk(KERN_NOTICE "%s: Incorrect block size.\n", name);
+							st_printk(KERN_NOTICE, STp,
+								  "Incorrect "
+								  "block size.\n");
 							if (STps->drv_block >=3D 0)
 								STps->drv_block +=3D blks - transfer + 1;
 							st_int_ioctl(STp, MTBSR, 1);
@@ -1938,9 +1946,11 @@ static long read_tape(struct scsi_tape *STp, lon=
g count,
 						/* We have some data, deliver it */
 						STbp->buffer_bytes =3D (blks - transfer) *
 						    STp->block_size;
-                                                DEBC(printk(ST_DEB_MSG
-                                                            "%s: ILI b=
ut enough data received %ld %d.\n",
-                                                            name, coun=
t, STbp->buffer_bytes));
+						DEBC_printk(STp, "ILI but "
+							    "enough data "
+							    "received %ld "
+							    "%d.\n", count,
+							    STbp->buffer_bytes);
 						if (STps->drv_block >=3D 0)
 							STps->drv_block +=3D 1;
 						if (st_int_ioctl(STp, MTBSR, 1))
@@ -1956,9 +1966,9 @@ static long read_tape(struct scsi_tape *STp, long=
 count,
 					else
 						STbp->buffer_bytes =3D
 						    bytes - transfer * STp->block_size;
-                                        DEBC(printk(ST_DEB_MSG
-                                                    "%s: EOF detected =
(%d bytes read).\n",
-                                                    name, STbp->buffer=
_bytes));
+					DEBC_printk(STp, "EOF detected (%d "
+						    "bytes read).\n",
+						    STbp->buffer_bytes);
 				} else if (cmdstatp->flags & SENSE_EOM) {
 					if (STps->eof =3D=3D ST_FM)
 						STps->eof =3D ST_EOD_1;
@@ -1970,20 +1980,20 @@ static long read_tape(struct scsi_tape *STp, lo=
ng count,
 						STbp->buffer_bytes =3D
 						    bytes - transfer * STp->block_size;
=20
-                                        DEBC(printk(ST_DEB_MSG "%s: EO=
M detected (%d bytes read).\n",
-                                                    name, STbp->buffer=
_bytes));
+					DEBC_printk(STp, "EOM detected (%d "
+						    "bytes read).\n",
+						    STbp->buffer_bytes);
 				}
 			}
-			/* end of EOF, EOM, ILI test */=20
+			/* end of EOF, EOM, ILI test */
 			else {	/* nonzero sense key */
-                                DEBC(printk(ST_DEB_MSG
-                                            "%s: Tape error while read=
ing.\n", name));
+				DEBC_printk(STp, "Tape error while reading.\n");
 				STps->drv_block =3D (-1);
 				if (STps->eof =3D=3D ST_FM &&
 				    cmdstatp->sense_hdr.sense_key =3D=3D BLANK_CHECK) {
-                                        DEBC(printk(ST_DEB_MSG
-                                                    "%s: Zero returned=
 for first BLANK CHECK after EOF.\n",
-                                                    name));
+					DEBC_printk(STp, "Zero returned for "
+						    "first BLANK CHECK "
+						    "after EOF.\n");
 					STps->eof =3D ST_EOD_2;	/* First BLANK_CHECK after FM */
 				} else	/* Some other extended sense code */
 					retval =3D (-EIO);
@@ -1992,13 +2002,13 @@ static long read_tape(struct scsi_tape *STp, lo=
ng count,
 			if (STbp->buffer_bytes < 0)  /* Caused by bogus sense data */
 				STbp->buffer_bytes =3D 0;
 		}
-		/* End of extended sense test */=20
+		/* End of extended sense test */
 		else {		/* Non-extended sense */
 			retval =3D STbp->syscall_result;
 		}
=20
 	}
-	/* End of error handling */=20
+	/* End of error handling */
 	else {			/* Read successful */
 		STbp->buffer_bytes =3D bytes;
 		if (STp->sili) /* In fixed block mode residual is always zero here *=
/
@@ -2028,7 +2038,6 @@ st_read(struct file *filp, char __user *buf, size=
_t count, loff_t * ppos)
 	struct st_modedef *STm;
 	struct st_partstat *STps;
 	struct st_buffer *STbp =3D STp->buffer;
-	DEB( char *name =3D tape_name(STp); )
=20
 	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
@@ -2053,11 +2062,12 @@ st_read(struct file *filp, char __user *buf, si=
ze_t count, loff_t * ppos)
 			goto out;
 		STps->rw =3D ST_READING;
 	}
-        DEB(
+	DEB(
 	if (debugging && STps->eof !=3D ST_NOEOF)
-		printk(ST_DEB_MSG "%s: EOF/EOM flag up (%d). Bytes %d\n", name,
-		       STps->eof, STbp->buffer_bytes);
-        ) /* end DEB */
+		st_printk(ST_DEB_MSG, STp,
+			  "EOF/EOM flag up (%d). Bytes %d\n",
+			  STps->eof, STbp->buffer_bytes);
+	) /* end DEB */
=20
 	retval =3D setup_buffering(STp, buf, count, 1);
 	if (retval)
@@ -2104,13 +2114,13 @@ st_read(struct file *filp, char __user *buf, si=
ze_t count, loff_t * ppos)
=20
 		/* Move the data from driver buffer to user buffer */
 		if (STbp->buffer_bytes > 0) {
-                        DEB(
+			DEB(
 			if (debugging && STps->eof !=3D ST_NOEOF)
-				printk(ST_DEB_MSG
-                                       "%s: EOF up (%d). Left %d, need=
ed %d.\n", name,
-				       STps->eof, STbp->buffer_bytes,
-                                       (int)(count - total));
-                        ) /* end DEB */
+				st_printk(ST_DEB_MSG, STp,
+					  "EOF up (%d). Left %d, needed %d.\n",
+					  STps->eof, STbp->buffer_bytes,
+					  (int)(count - total));
+			) /* end DEB */
 			transfer =3D STbp->buffer_bytes < count - total ?
 			    STbp->buffer_bytes : count - total;
 			if (!do_dio) {
@@ -2166,26 +2176,30 @@ st_read(struct file *filp, char __user *buf, si=
ze_t count, loff_t * ppos)
=20
 DEB(
 /* Set the driver options */
-static void st_log_options(struct scsi_tape * STp, struct st_modedef *=
 STm, char *name)
+static void st_log_options(struct scsi_tape * STp, struct st_modedef *=
 STm)
 {
 	if (debugging) {
-		printk(KERN_INFO
-		       "%s: Mode %d options: buffer writes: %d, async writes: %d, re=
ad ahead: %d\n",
-		       name, STp->current_mode, STm->do_buffer_writes, STm->do_async=
_writes,
-		       STm->do_read_ahead);
-		printk(KERN_INFO
-		       "%s:    can bsr: %d, two FMs: %d, fast mteom: %d, auto lock: =
%d,\n",
-		       name, STp->can_bsr, STp->two_fm, STp->fast_mteom, STp->do_aut=
o_lock);
-		printk(KERN_INFO
-		       "%s:    defs for wr: %d, no block limits: %d, partitions: %d,=
 s2 log: %d\n",
-		       name, STm->defaults_for_writes, STp->omit_blklims, STp->can_p=
artitions,
-		       STp->scsi2_logical);
-		printk(KERN_INFO
-		       "%s:    sysv: %d nowait: %d sili: %d nowait_filemark: %d\n",
-		       name, STm->sysv, STp->immediate, STp->sili,
-		       STp->immediate_filemark);
-		printk(KERN_INFO "%s:    debugging: %d\n",
-		       name, debugging);
+		st_printk(KERN_INFO, STp,
+			  "Mode %d options: buffer writes: %d, "
+			  "async writes: %d, read ahead: %d\n",
+			  STp->current_mode, STm->do_buffer_writes,
+			  STm->do_async_writes, STm->do_read_ahead);
+		st_printk(KERN_INFO, STp,
+			  "    can bsr: %d, two FMs: %d, "
+			  "fast mteom: %d, auto lock: %d,\n",
+			  STp->can_bsr, STp->two_fm, STp->fast_mteom,
+			  STp->do_auto_lock);
+		st_printk(KERN_INFO, STp,
+			  "    defs for wr: %d, no block limits: %d, "
+			  "partitions: %d, s2 log: %d\n",
+			  STm->defaults_for_writes, STp->omit_blklims,
+			  STp->can_partitions, STp->scsi2_logical);
+		st_printk(KERN_INFO, STp,
+			  "    sysv: %d nowait: %d sili: %d "
+			  "nowait_filemark: %d\n",
+			  STm->sysv, STp->immediate, STp->sili,
+			  STp->immediate_filemark);
+		st_printk(KERN_INFO, STp, "    debugging: %d\n", debugging);
 	}
 }
 	)
@@ -2196,7 +2210,6 @@ static int st_set_options(struct scsi_tape *STp, =
long options)
 	int value;
 	long code;
 	struct st_modedef *STm;
-	char *name =3D tape_name(STp);
 	struct cdev *cd0, *cd1;
 	struct device *d0, *d1;
=20
@@ -2212,9 +2225,8 @@ static int st_set_options(struct scsi_tape *STp, =
long options)
 		STm->devs[0]  =3D d0;
 		STm->devs[1]  =3D d1;
 		modes_defined =3D 1;
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Initialized mode %d definition from m=
ode 0\n",
-                            name, STp->current_mode));
+		DEBC_printk(STp, "Initialized mode %d definition from mode 0\n",
+			    STp->current_mode);
 	}
=20
 	code =3D options & MT_ST_OPTIONS;
@@ -2236,7 +2248,7 @@ static int st_set_options(struct scsi_tape *STp, =
long options)
 		STm->sysv =3D (options & MT_ST_SYSV) !=3D 0;
 		STp->sili =3D (options & MT_ST_SILI) !=3D 0;
 		DEB( debugging =3D (options & MT_ST_DEBUGGING) !=3D 0;
-		     st_log_options(STp, STm, name); )
+		     st_log_options(STp, STm); )
 	} else if (code =3D=3D MT_ST_SETBOOLEANS || code =3D=3D MT_ST_CLEARBO=
OLEANS) {
 		value =3D (code =3D=3D MT_ST_SETBOOLEANS);
 		if ((options & MT_ST_BUFFER_WRITES) !=3D 0)
@@ -2270,21 +2282,21 @@ static int st_set_options(struct scsi_tape *STp=
, long options)
 			STm->sysv =3D value;
 		if ((options & MT_ST_SILI) !=3D 0)
 			STp->sili =3D value;
-                DEB(
+		DEB(
 		if ((options & MT_ST_DEBUGGING) !=3D 0)
 			debugging =3D value;
-			st_log_options(STp, STm, name); )
+			st_log_options(STp, STm); )
 	} else if (code =3D=3D MT_ST_WRITE_THRESHOLD) {
 		/* Retained for compatibility */
 	} else if (code =3D=3D MT_ST_DEF_BLKSIZE) {
 		value =3D (options & ~MT_ST_OPTIONS);
 		if (value =3D=3D ~MT_ST_OPTIONS) {
 			STm->default_blksize =3D (-1);
-			DEBC( printk(KERN_INFO "%s: Default block size disabled.\n", name))=
;
+			DEBC_printk(STp, "Default block size disabled.\n");
 		} else {
 			STm->default_blksize =3D value;
-			DEBC( printk(KERN_INFO "%s: Default block size set to %d bytes.\n",
-			       name, STm->default_blksize));
+			DEBC_printk(STp,"Default block size set to "
+				    "%d bytes.\n", STm->default_blksize);
 			if (STp->ready =3D=3D ST_READY) {
 				STp->blksize_changed =3D 0;
 				set_mode_densblk(STp, STm);
@@ -2294,13 +2306,13 @@ static int st_set_options(struct scsi_tape *STp=
, long options)
 		value =3D (options & ~MT_ST_OPTIONS);
 		if ((value & MT_ST_SET_LONG_TIMEOUT) !=3D 0) {
 			STp->long_timeout =3D (value & ~MT_ST_SET_LONG_TIMEOUT) * HZ;
-			DEBC( printk(KERN_INFO "%s: Long timeout set to %d seconds.\n", nam=
e,
-			       (value & ~MT_ST_SET_LONG_TIMEOUT)));
+			DEBC_printk(STp, "Long timeout set to %d seconds.\n",
+				    (value & ~MT_ST_SET_LONG_TIMEOUT));
 		} else {
 			blk_queue_rq_timeout(STp->device->request_queue,
 					     value * HZ);
-			DEBC( printk(KERN_INFO "%s: Normal timeout set to %d seconds.\n",
-				name, value) );
+			DEBC_printk(STp, "Normal timeout set to %d seconds.\n",
+				    value);
 		}
 	} else if (code =3D=3D MT_ST_SET_CLN) {
 		value =3D (options & ~MT_ST_OPTIONS) & 0xff;
@@ -2311,21 +2323,21 @@ static int st_set_options(struct scsi_tape *STp=
, long options)
 		STp->cln_mode =3D value;
 		STp->cln_sense_mask =3D (options >> 8) & 0xff;
 		STp->cln_sense_value =3D (options >> 16) & 0xff;
-		printk(KERN_INFO
-		       "%s: Cleaning request mode %d, mask %02x, value %02x\n",
-		       name, value, STp->cln_sense_mask, STp->cln_sense_value);
+		st_printk(KERN_INFO, STp,
+			  "Cleaning request mode %d, mask %02x, value %02x\n",
+			  value, STp->cln_sense_mask, STp->cln_sense_value);
 	} else if (code =3D=3D MT_ST_DEF_OPTIONS) {
 		code =3D (options & ~MT_ST_CLEAR_DEFAULT);
 		value =3D (options & MT_ST_CLEAR_DEFAULT);
 		if (code =3D=3D MT_ST_DEF_DENSITY) {
 			if (value =3D=3D MT_ST_CLEAR_DEFAULT) {
 				STm->default_density =3D (-1);
-				DEBC( printk(KERN_INFO "%s: Density default disabled.\n",
-                                       name));
+				DEBC_printk(STp,
+					    "Density default disabled.\n");
 			} else {
 				STm->default_density =3D value & 0xff;
-				DEBC( printk(KERN_INFO "%s: Density default set to %x\n",
-				       name, STm->default_density));
+				DEBC_printk(STp, "Density default set to %x\n",
+					    STm->default_density);
 				if (STp->ready =3D=3D ST_READY) {
 					STp->density_changed =3D 0;
 					set_mode_densblk(STp, STm);
@@ -2334,31 +2346,33 @@ static int st_set_options(struct scsi_tape *STp=
, long options)
 		} else if (code =3D=3D MT_ST_DEF_DRVBUFFER) {
 			if (value =3D=3D MT_ST_CLEAR_DEFAULT) {
 				STp->default_drvbuffer =3D 0xff;
-				DEBC( printk(KERN_INFO
-                                       "%s: Drive buffer default disab=
led.\n", name));
+				DEBC_printk(STp,
+					    "Drive buffer default disabled.\n");
 			} else {
 				STp->default_drvbuffer =3D value & 7;
-				DEBC( printk(KERN_INFO
-                                       "%s: Drive buffer default set t=
o %x\n",
-				       name, STp->default_drvbuffer));
+				DEBC_printk(STp,
+					    "Drive buffer default set to %x\n",
+					    STp->default_drvbuffer);
 				if (STp->ready =3D=3D ST_READY)
 					st_int_ioctl(STp, MTSETDRVBUFFER, STp->default_drvbuffer);
 			}
 		} else if (code =3D=3D MT_ST_DEF_COMPRESSION) {
 			if (value =3D=3D MT_ST_CLEAR_DEFAULT) {
 				STm->default_compression =3D ST_DONT_TOUCH;
-				DEBC( printk(KERN_INFO
-                                       "%s: Compression default disabl=
ed.\n", name));
+				DEBC_printk(STp,
+					    "Compression default disabled.\n");
 			} else {
 				if ((value & 0xff00) !=3D 0) {
 					STp->c_algo =3D (value & 0xff00) >> 8;
-					DEBC( printk(KERN_INFO "%s: Compression algorithm set to 0x%x.\n"=
,
-					       name, STp->c_algo));
+					DEBC_printk(STp, "Compression "
+						    "algorithm set to 0x%x.\n",
+						    STp->c_algo);
 				}
 				if ((value & 0xff) !=3D 0xff) {
 					STm->default_compression =3D (value & 1 ? ST_YES : ST_NO);
-					DEBC( printk(KERN_INFO "%s: Compression default set to %x\n",
-					       name, (value & 1)));
+					DEBC_printk(STp, "Compression default "
+						    "set to %x\n",
+						    (value & 1));
 					if (STp->ready =3D=3D ST_READY) {
 						STp->compression_changed =3D 0;
 						st_compression(STp, (STm->default_compression =3D=3D ST_YES));
@@ -2473,7 +2487,6 @@ static int st_compression(struct scsi_tape * STp,=
 int state)
 	int retval;
 	int mpoffs;  /* Offset to mode page start */
 	unsigned char *b_data =3D (STp->buffer)->b_data;
-	DEB( char *name =3D tape_name(STp); )
=20
 	if (STp->ready !=3D ST_READY)
 		return (-EIO);
@@ -2481,18 +2494,17 @@ static int st_compression(struct scsi_tape * ST=
p, int state)
 	/* Read the current page contents */
 	retval =3D read_mode_page(STp, COMPRESSION_PAGE, 0);
 	if (retval) {
-                DEBC(printk(ST_DEB_MSG "%s: Compression mode page not =
supported.\n",
-                            name));
+		DEBC_printk(STp, "Compression mode page not supported.\n");
 		return (-EIO);
 	}
=20
 	mpoffs =3D MODE_HEADER_LENGTH + b_data[MH_OFF_BDESCS_LENGTH];
-        DEBC(printk(ST_DEB_MSG "%s: Compression state is %d.\n", name,
-                    (b_data[mpoffs + CP_OFF_DCE_DCC] & DCE_MASK ? 1 : =
0)));
+	DEBC_printk(STp, "Compression state is %d.\n",
+		    (b_data[mpoffs + CP_OFF_DCE_DCC] & DCE_MASK ? 1 : 0));
=20
 	/* Check if compression can be changed */
 	if ((b_data[mpoffs + CP_OFF_DCE_DCC] & DCC_MASK) =3D=3D 0) {
-                DEBC(printk(ST_DEB_MSG "%s: Compression not supported.=
\n", name));
+		DEBC_printk(STp, "Compression not supported.\n");
 		return (-EIO);
 	}
=20
@@ -2510,11 +2522,10 @@ static int st_compression(struct scsi_tape * ST=
p, int state)
=20
 	retval =3D write_mode_page(STp, COMPRESSION_PAGE, 0);
 	if (retval) {
-                DEBC(printk(ST_DEB_MSG "%s: Compression change failed.=
\n", name));
+		DEBC_printk(STp, "Compression change failed.\n");
 		return (-EIO);
 	}
-        DEBC(printk(ST_DEB_MSG "%s: Compression state changed to %d.\n=
",
-		       name, state));
+	DEBC_printk(STp, "Compression state changed to %d.\n", state);
=20
 	STp->compression_changed =3D 1;
 	return 0;
@@ -2525,7 +2536,6 @@ static int st_compression(struct scsi_tape * STp,=
 int state)
 static int do_load_unload(struct scsi_tape *STp, struct file *filp, in=
t load_code)
 {
 	int retval =3D (-EIO), timeout;
-	DEB( char *name =3D tape_name(STp); )
 	unsigned char cmd[MAX_COMMAND_SIZE];
 	struct st_partstat *STps;
 	struct st_request *SRpnt;
@@ -2546,9 +2556,9 @@ static int do_load_unload(struct scsi_tape *STp, =
struct file *filp, int load_cod
 	 */
 	if (load_code >=3D 1 + MT_ST_HPLOADER_OFFSET
 	    && load_code <=3D 6 + MT_ST_HPLOADER_OFFSET) {
-		DEBC(printk(ST_DEB_MSG "%s: Enhanced %sload slot %2d.\n",
-			    name, (cmd[4]) ? "" : "un",
-			    load_code - MT_ST_HPLOADER_OFFSET));
+		DEBC_printk(STp, " Enhanced %sload slot %2d.\n",
+			    (cmd[4]) ? "" : "un",
+			    load_code - MT_ST_HPLOADER_OFFSET);
 		cmd[3] =3D load_code - MT_ST_HPLOADER_OFFSET; /* MediaID field of C1=
553A */
 	}
 	if (STp->immediate) {
@@ -2560,9 +2570,9 @@ static int do_load_unload(struct scsi_tape *STp, =
struct file *filp, int load_cod
=20
 	DEBC(
 		if (!load_code)
-		printk(ST_DEB_MSG "%s: Unloading tape.\n", name);
+			st_printk(ST_DEB_MSG, STp, "Unloading tape.\n");
 		else
-		printk(ST_DEB_MSG "%s: Loading tape.\n", name);
+			st_printk(ST_DEB_MSG, STp, "Loading tape.\n");
 		);
=20
 	SRpnt =3D st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
@@ -2597,17 +2607,24 @@ static int do_load_unload(struct scsi_tape *STp=
, struct file *filp, int load_cod
 #if DEBUG
 #define ST_DEB_FORWARD  0
 #define ST_DEB_BACKWARD 1
-static void deb_space_print(char *name, int direction, char *units, un=
signed char *cmd)
+static void deb_space_print(struct scsi_tape *STp, int direction, char=
 *units, unsigned char *cmd)
 {
 	s32 sc;
=20
+	if (!debugging)
+		return;
+
 	sc =3D cmd[2] & 0x80 ? 0xff000000 : 0;
 	sc |=3D (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
 	if (direction)
 		sc =3D -sc;
-	printk(ST_DEB_MSG "%s: Spacing tape %s over %d %s.\n", name,
-	       direction ? "backward" : "forward", sc, units);
+	st_printk(ST_DEB_MSG, STp, "Spacing tape %s over %d %s.\n",
+		  direction ? "backward" : "forward", sc, units);
 }
+#else
+#define ST_DEB_FORWARD  0
+#define ST_DEB_BACKWARD 1
+static void deb_space_print(struct scsi_tape *STp, int direction, char=
 *units, unsigned char *cmd) {}
 #endif
=20
=20
@@ -2623,7 +2640,6 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 	struct st_partstat *STps;
 	int fileno, blkno, at_sm, undone;
 	int datalen =3D 0, direction =3D DMA_NONE;
-	char *name =3D tape_name(STp);
=20
 	WARN_ON(STp->buffer->do_dio !=3D 0);
 	if (STp->ready !=3D ST_READY) {
@@ -2648,7 +2664,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		cmd[2] =3D (arg >> 16);
 		cmd[3] =3D (arg >> 8);
 		cmd[4] =3D arg;
-                DEBC(deb_space_print(name, ST_DEB_FORWARD, "filemarks"=
, cmd);)
+		deb_space_print(STp, ST_DEB_FORWARD, "filemarks", cmd);
 		if (fileno >=3D 0)
 			fileno +=3D arg;
 		blkno =3D 0;
@@ -2663,7 +2679,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		cmd[2] =3D (ltmp >> 16);
 		cmd[3] =3D (ltmp >> 8);
 		cmd[4] =3D ltmp;
-                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "filemarks=
", cmd);)
+		deb_space_print(STp, ST_DEB_BACKWARD, "filemarks", cmd);
 		if (fileno >=3D 0)
 			fileno -=3D arg;
 		blkno =3D (-1);	/* We can't know the block number */
@@ -2675,7 +2691,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		cmd[2] =3D (arg >> 16);
 		cmd[3] =3D (arg >> 8);
 		cmd[4] =3D arg;
-                DEBC(deb_space_print(name, ST_DEB_FORWARD, "blocks", c=
md);)
+		deb_space_print(STp, ST_DEB_FORWARD, "blocks", cmd);
 		if (blkno >=3D 0)
 			blkno +=3D arg;
 		at_sm &=3D (arg =3D=3D 0);
@@ -2687,7 +2703,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		cmd[2] =3D (ltmp >> 16);
 		cmd[3] =3D (ltmp >> 8);
 		cmd[4] =3D ltmp;
-                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "blocks", =
cmd);)
+		deb_space_print(STp, ST_DEB_BACKWARD, "blocks", cmd);
 		if (blkno >=3D 0)
 			blkno -=3D arg;
 		at_sm &=3D (arg =3D=3D 0);
@@ -2698,7 +2714,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		cmd[2] =3D (arg >> 16);
 		cmd[3] =3D (arg >> 8);
 		cmd[4] =3D arg;
-                DEBC(deb_space_print(name, ST_DEB_FORWARD, "setmarks",=
 cmd);)
+		deb_space_print(STp, ST_DEB_FORWARD, "setmarks", cmd);
 		if (arg !=3D 0) {
 			blkno =3D fileno =3D (-1);
 			at_sm =3D 1;
@@ -2711,7 +2727,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		cmd[2] =3D (ltmp >> 16);
 		cmd[3] =3D (ltmp >> 8);
 		cmd[4] =3D ltmp;
-                DEBC(deb_space_print(name, ST_DEB_BACKWARD, "setmarks"=
, cmd);)
+		deb_space_print(STp, ST_DEB_BACKWARD, "setmarks", cmd);
 		if (arg !=3D 0) {
 			blkno =3D fileno =3D (-1);
 			at_sm =3D 1;
@@ -2732,13 +2748,19 @@ static int st_int_ioctl(struct scsi_tape *STp, =
unsigned int cmd_in, unsigned lon
 		cmd[3] =3D (arg >> 8);
 		cmd[4] =3D arg;
 		timeout =3D STp->device->request_queue->rq_timeout;
-                DEBC(
-		     if (cmd_in !=3D MTWSM)
-                               printk(ST_DEB_MSG "%s: Writing %d filem=
arks.\n", name,
-				 cmd[2] * 65536 + cmd[3] * 256 + cmd[4]);
-                     else
-				printk(ST_DEB_MSG "%s: Writing %d setmarks.\n", name,
-				 cmd[2] * 65536 + cmd[3] * 256 + cmd[4]);
+		DEBC(
+			if (cmd_in !=3D MTWSM)
+				st_printk(ST_DEB_MSG, STp,
+					  "Writing %d filemarks.\n",
+					  cmd[2] * 65536 +
+					  cmd[3] * 256 +
+					  cmd[4]);
+			else
+				st_printk(ST_DEB_MSG, STp,
+					  "Writing %d setmarks.\n",
+					  cmd[2] * 65536 +
+					  cmd[3] * 256 +
+					  cmd[4]);
 		)
 		if (fileno >=3D 0)
 			fileno +=3D arg;
@@ -2751,11 +2773,11 @@ static int st_int_ioctl(struct scsi_tape *STp, =
unsigned int cmd_in, unsigned lon
 			cmd[1] =3D 1;	/* Don't wait for completion */
 			timeout =3D STp->device->request_queue->rq_timeout;
 		}
-                DEBC(printk(ST_DEB_MSG "%s: Rewinding tape.\n", name))=
;
+		DEBC_printk(STp, "Rewinding tape.\n");
 		fileno =3D blkno =3D at_sm =3D 0;
 		break;
 	case MTNOP:
-                DEBC(printk(ST_DEB_MSG "%s: No op on tape.\n", name));
+		DEBC_printk(STp, "No op on tape.\n");
 		return 0;	/* Should do something ? */
 		break;
 	case MTRETEN:
@@ -2765,7 +2787,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 			timeout =3D STp->device->request_queue->rq_timeout;
 		}
 		cmd[4] =3D 3;
-                DEBC(printk(ST_DEB_MSG "%s: Retensioning tape.\n", nam=
e));
+		DEBC_printk(STp, "Retensioning tape.\n");
 		fileno =3D blkno =3D at_sm =3D 0;
 		break;
 	case MTEOM:
@@ -2783,8 +2805,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 			fileno =3D (-1);
 		cmd[0] =3D SPACE;
 		cmd[1] =3D 3;
-                DEBC(printk(ST_DEB_MSG "%s: Spacing to end of recorded=
 medium.\n",
-                            name));
+		DEBC_printk(STp, "Spacing to end of recorded medium.\n");
 		blkno =3D -1;
 		at_sm =3D 0;
 		break;
@@ -2800,7 +2821,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		else
 			timeout =3D STp->long_timeout * 8;
=20
-                DEBC(printk(ST_DEB_MSG "%s: Erasing tape.\n", name));
+		DEBC_printk(STp, "Erasing tape.\n");
 		fileno =3D blkno =3D at_sm =3D 0;
 		break;
 	case MTSETBLK:		/* Set block length */
@@ -2815,7 +2836,7 @@ static int st_int_ioctl(struct scsi_tape *STp, un=
signed int cmd_in, unsigned lon
 		    STp->max_block > 0 &&
 		    ((arg & MT_ST_BLKSIZE_MASK) < STp->min_block ||
 		     (arg & MT_ST_BLKSIZE_MASK) > STp->max_block)) {
-			printk(KERN_WARNING "%s: Illegal block size.\n", name);
+			st_printk(KERN_WARNING, STp, "Illegal block size.\n");
 			return (-EINVAL);
 		}
 		cmd[0] =3D MODE_SELECT;
@@ -2848,21 +2869,21 @@ static int st_int_ioctl(struct scsi_tape *STp, =
unsigned int cmd_in, unsigned lon
 		(STp->buffer)->b_data[10] =3D (ltmp >> 8);
 		(STp->buffer)->b_data[11] =3D ltmp;
 		timeout =3D STp->device->request_queue->rq_timeout;
-                DEBC(
+		DEBC(
 			if (cmd_in =3D=3D MTSETBLK || cmd_in =3D=3D SET_DENS_AND_BLK)
-				printk(ST_DEB_MSG
-                                       "%s: Setting block size to %d b=
ytes.\n", name,
-				       (STp->buffer)->b_data[9] * 65536 +
-				       (STp->buffer)->b_data[10] * 256 +
-				       (STp->buffer)->b_data[11]);
+				st_printk(ST_DEB_MSG, STp,
+					  "Setting block size to %d bytes.\n",
+					  (STp->buffer)->b_data[9] * 65536 +
+					  (STp->buffer)->b_data[10] * 256 +
+					  (STp->buffer)->b_data[11]);
 			if (cmd_in =3D=3D MTSETDENSITY || cmd_in =3D=3D SET_DENS_AND_BLK)
-				printk(ST_DEB_MSG
-                                       "%s: Setting density code to %x=
=2E\n", name,
-				       (STp->buffer)->b_data[4]);
+				st_printk(ST_DEB_MSG, STp,
+					  "Setting density code to %x.\n",
+					  (STp->buffer)->b_data[4]);
 			if (cmd_in =3D=3D MTSETDRVBUFFER)
-				printk(ST_DEB_MSG
-                                       "%s: Setting drive buffer code =
to %d.\n", name,
-				    ((STp->buffer)->b_data[2] >> 4) & 7);
+				st_printk(ST_DEB_MSG, STp,
+					  "Setting drive buffer code to %d.\n",
+					  ((STp->buffer)->b_data[2] >> 4) & 7);
 		)
 		break;
 	default:
@@ -3019,7 +3040,6 @@ static int get_location(struct scsi_tape *STp, un=
signed int *block, int *partiti
 	int result;
 	unsigned char scmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
-	DEB( char *name =3D tape_name(STp); )
=20
 	if (STp->ready !=3D ST_READY)
 		return (-EIO);
@@ -3043,7 +3063,7 @@ static int get_location(struct scsi_tape *STp, un=
signed int *block, int *partiti
 	    (STp->device->scsi_level >=3D SCSI_2 &&
 	     ((STp->buffer)->b_data[0] & 4) !=3D 0)) {
 		*block =3D *partition =3D 0;
-                DEBC(printk(ST_DEB_MSG "%s: Can't read tape position.\=
n", name));
+		DEBC_printk(STp, " Can't read tape position.\n");
 		result =3D (-EIO);
 	} else {
 		result =3D 0;
@@ -3062,8 +3082,8 @@ static int get_location(struct scsi_tape *STp, un=
signed int *block, int *partiti
 			    (STp->buffer)->b_data[1] =3D=3D 0)	/* BOP of partition 0 */
 				STp->ps[0].drv_block =3D STp->ps[0].drv_file =3D 0;
 		}
-                DEBC(printk(ST_DEB_MSG "%s: Got tape pos. blk %d part =
%d.\n", name,
-                            *block, *partition));
+		DEBC_printk(STp, "Got tape pos. blk %d part %d.\n",
+			    *block, *partition);
 	}
 	st_release_request(SRpnt);
 	SRpnt =3D NULL;
@@ -3083,15 +3103,14 @@ static int set_location(struct scsi_tape *STp, =
unsigned int block, int partition
 	int timeout;
 	unsigned char scmd[MAX_COMMAND_SIZE];
 	struct st_request *SRpnt;
-	DEB( char *name =3D tape_name(STp); )
=20
 	if (STp->ready !=3D ST_READY)
 		return (-EIO);
 	timeout =3D STp->long_timeout;
 	STps =3D &(STp->ps[STp->partition]);
=20
-        DEBC(printk(ST_DEB_MSG "%s: Setting block to %d and partition =
to %d.\n",
-                    name, block, partition));
+	DEBC_printk(STp, "Setting block to %d and partition to %d.\n",
+		    block, partition);
 	DEB(if (partition < 0)
 		return (-EIO); )
=20
@@ -3105,9 +3124,9 @@ static int set_location(struct scsi_tape *STp, un=
signed int block, int partition
 		else {
 			STps->last_block_valid =3D 1;
 			STps->last_block_visited =3D blk;
-                        DEBC(printk(ST_DEB_MSG
-                                    "%s: Visited block %d for partitio=
n %d saved.\n",
-                                    name, blk, STp->partition));
+			DEBC_printk(STp, "Visited block %d for "
+				    "partition %d saved.\n",
+				    blk, STp->partition);
 		}
 	}
=20
@@ -3129,9 +3148,9 @@ static int set_location(struct scsi_tape *STp, un=
signed int block, int partition
 		if (STp->partition !=3D partition) {
 			scmd[1] |=3D 2;
 			scmd[8] =3D partition;
-                        DEBC(printk(ST_DEB_MSG
-                                    "%s: Trying to change partition fr=
om %d to %d\n",
-                                    name, STp->partition, partition));
+			DEBC_printk(STp, "Trying to change partition "
+				    "from %d to %d\n", STp->partition,
+				    partition);
 		}
 	}
 	if (STp->immediate) {
@@ -3222,7 +3241,6 @@ static int switch_partition(struct scsi_tape *STp=
)
 static int nbr_partitions(struct scsi_tape *STp)
 {
 	int result;
-	DEB( char *name =3D tape_name(STp); )
=20
 	if (STp->ready !=3D ST_READY)
 		return (-EIO);
@@ -3230,13 +3248,12 @@ static int nbr_partitions(struct scsi_tape *STp=
)
 	result =3D read_mode_page(STp, PART_PAGE, 1);
=20
 	if (result) {
-                DEBC(printk(ST_DEB_MSG "%s: Can't read medium partitio=
n page.\n",
-                            name));
+		DEBC_printk(STp, "Can't read medium partition page.\n");
 		result =3D (-EIO);
 	} else {
 		result =3D (STp->buffer)->b_data[MODE_HEADER_LENGTH +
 					      PP_OFF_NBR_ADD_PARTS] + 1;
-                DEBC(printk(ST_DEB_MSG "%s: Number of partitions %d.\n=
", name, result));
+		DEBC_printk(STp, "Number of partitions %d.\n", result);
 	}
=20
 	return result;
@@ -3264,21 +3281,20 @@ static int nbr_partitions(struct scsi_tape *STp=
)
  */
 static int partition_tape(struct scsi_tape *STp, int size)
 {
-	char *name =3D tape_name(STp);
 	int result;
 	int pgo, psd_cnt, psdo;
 	unsigned char *bp;
=20
 	result =3D read_mode_page(STp, PART_PAGE, 0);
 	if (result) {
-		DEBC(printk(ST_DEB_MSG "%s: Can't read partition mode page.\n", name=
));
+		DEBC_printk(STp, "Can't read partition mode page.\n");
 		return result;
 	}
 	/* The mode page is in the buffer. Let's modify it and write it. */
 	bp =3D (STp->buffer)->b_data;
 	pgo =3D MODE_HEADER_LENGTH + bp[MH_OFF_BDESCS_LENGTH];
-	DEBC(printk(ST_DEB_MSG "%s: Partition page length is %d bytes.\n",
-		    name, bp[pgo + MP_OFF_PAGE_LENGTH] + 2));
+	DEBC_printk(STp, "Partition page length is %d bytes.\n",
+		    bp[pgo + MP_OFF_PAGE_LENGTH] + 2);
=20
 	psd_cnt =3D (bp[pgo + MP_OFF_PAGE_LENGTH] + 2 - PART_PAGE_FIXED_LENGT=
H) / 2;
 	psdo =3D pgo + PART_PAGE_FIXED_LENGTH;
@@ -3288,25 +3304,23 @@ static int partition_tape(struct scsi_tape *STp=
, int size)
 	}
 	memset(bp + psdo, 0, bp[pgo + PP_OFF_NBR_ADD_PARTS] * 2);
=20
-	DEBC(printk("%s: psd_cnt %d, max.parts %d, nbr_parts %d\n", name,
+	DEBC_printk(STp, "psd_cnt %d, max.parts %d, nbr_parts %d\n",
 		    psd_cnt, bp[pgo + PP_OFF_MAX_ADD_PARTS],
-		    bp[pgo + PP_OFF_NBR_ADD_PARTS]));
+		    bp[pgo + PP_OFF_NBR_ADD_PARTS]);
=20
 	if (size <=3D 0) {
 		bp[pgo + PP_OFF_NBR_ADD_PARTS] =3D 0;
 		if (psd_cnt <=3D bp[pgo + PP_OFF_MAX_ADD_PARTS])
 		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 6;
-                DEBC(printk(ST_DEB_MSG "%s: Formatting tape with one p=
artition.\n",
-                            name));
+		DEBC_printk(STp, "Formatting tape with one partition.\n");
 	} else {
 		bp[psdo] =3D (size >> 8) & 0xff;
 		bp[psdo + 1] =3D size & 0xff;
 		bp[pgo + 3] =3D 1;
 		if (bp[pgo + MP_OFF_PAGE_LENGTH] < 8)
 		    bp[pgo + MP_OFF_PAGE_LENGTH] =3D 8;
-                DEBC(printk(ST_DEB_MSG
-                            "%s: Formatting tape with two partitions (=
1 =3D %d MB).\n",
-                            name, size));
+		DEBC_printk(STp, "Formatting tape with two partitions "
+			    "(1 =3D %d MB).\n", size);
 	}
 	bp[pgo + PP_OFF_PART_UNITS] =3D 0;
 	bp[pgo + PP_OFF_RESERVED] =3D 0;
@@ -3314,7 +3328,7 @@ static int partition_tape(struct scsi_tape *STp, =
int size)
=20
 	result =3D write_mode_page(STp, PART_PAGE, 1);
 	if (result) {
-		printk(KERN_INFO "%s: Partitioning of tape failed.\n", name);
+		st_printk(KERN_INFO, STp, "Partitioning of tape failed.\n");
 		result =3D (-EIO);
 	}
=20
@@ -3332,15 +3346,14 @@ static long st_ioctl(struct file *file, unsigne=
d int cmd_in, unsigned long arg)
 	struct scsi_tape *STp =3D file->private_data;
 	struct st_modedef *STm;
 	struct st_partstat *STps;
-	char *name =3D tape_name(STp);
 	void __user *p =3D (void __user *)arg;
=20
 	if (mutex_lock_interruptible(&STp->lock))
 		return -ERESTARTSYS;
=20
-        DEB(
+	DEB(
 	if (debugging && !STp->in_use) {
-		printk(ST_DEB_MSG "%s: Incorrect device.\n", name);
+		st_printk(ST_DEB_MSG, STp, "Incorrect device.\n");
 		retval =3D (-EIO);
 		goto out;
 	} ) /* end DEB */
@@ -3378,8 +3391,8 @@ static long st_ioctl(struct file *file, unsigned =
int cmd_in, unsigned long arg)
 		}
=20
 		if (mtc.mt_op =3D=3D MTSETDRVBUFFER && !capable(CAP_SYS_ADMIN)) {
-			printk(KERN_WARNING
-                               "%s: MTSETDRVBUFFER only allowed for ro=
ot.\n", name);
+			st_printk(KERN_WARNING, STp,
+				  "MTSETDRVBUFFER only allowed for root.\n");
 			retval =3D (-EPERM);
 			goto out;
 		}
@@ -4087,7 +4100,8 @@ static int st_probe(struct device *dev)
 		return -ENODEV;
 	if ((stp =3D st_incompatible(SDp))) {
 		sdev_printk(KERN_INFO, SDp, "Found incompatible tape\n");
-		printk(KERN_INFO "st: The suggested driver is %s.\n", stp);
+		sdev_printk(KERN_INFO, SDp,
+			    "st: The suggested driver is %s.\n", stp);
 		return -ENODEV;
 	}
=20
@@ -4096,20 +4110,23 @@ static int st_probe(struct device *dev)
 		i =3D st_max_sg_segs;
 	buffer =3D new_tape_buffer((SDp->host)->unchecked_isa_dma, i);
 	if (buffer =3D=3D NULL) {
-		printk(KERN_ERR
-		       "st: Can't allocate new tape buffer. Device not attached.\n")=
;
+		sdev_printk(KERN_ERR, SDp,
+			    "st: Can't allocate new tape buffer. "
+			    "Device not attached.\n");
 		goto out;
 	}
=20
 	disk =3D alloc_disk(1);
 	if (!disk) {
-		printk(KERN_ERR "st: out of memory. Device not attached.\n");
+		sdev_printk(KERN_ERR, SDp,
+			    "st: out of memory. Device not attached.\n");
 		goto out_buffer_free;
 	}
=20
 	tpnt =3D kzalloc(sizeof(struct scsi_tape), GFP_ATOMIC);
 	if (tpnt =3D=3D NULL) {
-		printk(KERN_ERR "st: Can't allocate device descriptor.\n");
+		sdev_printk(KERN_ERR, SDp,
+			    "st: Can't allocate device descriptor.\n");
 		goto out_put_disk;
 	}
 	kref_init(&tpnt->kref);
--=20
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
