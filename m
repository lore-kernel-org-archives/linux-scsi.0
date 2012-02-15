From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH] [SCSI] st: expand ability to write immediate filemarks
Date: Wed, 15 Feb 2012 12:11:53 -0800
Message-ID: <4F3C1189.7090406@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat.nue.novell.com ([195.135.221.2]:49363 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2BOUMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Feb 2012 15:12:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The st tape driver recently added the MTWEOFI ioctl, which writes
a tape filemark (EOF), like the MTWEOF ioctl, except that MTWEOFI
returns immediately. This makes certain applications, like backup
software, run much more quickly on buffered tape drives.

Since legacy applications do not know about this new MTWEOFI ioctl,
this patch adds a new flag that tells the st driver to return
immediately when writing an EOF (i.e. a filemark). This new flag
is much like the existing flag that tells the st driver to perform
writes (and certain other IOs) immediately, but this new flag only
applies to writing EOFs.

This new feature can be enabled via a new module flag: st_nowait_eof.
It can also be set or cleared via the MTSETDRVBUFFER ioctl, using
the newly-defined MT_ST_NOWAIT_EOF flag.

Lastly, this new feature is displayed via the sysfs tape "options"
attribute.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 Documentation/scsi/st.txt |    2 ++
 drivers/scsi/st.c         |   24 +++++++++++++++++++++---
 drivers/scsi/st.h         |    1 +
 include/linux/mtio.h      |    1 +
 4 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/scsi/st.txt b/Documentation/scsi/st.txt
index 691ca29..85c1b1a 100644
--- a/Documentation/scsi/st.txt
+++ b/Documentation/scsi/st.txt
@@ -390,6 +390,8 @@ MTSETDRVBUFFER
 	     MT_ST_SYSV sets the SYSV semantics (mode)
 	     MT_ST_NOWAIT enables immediate mode (i.e., don't wait for
 	        the command to finish) for some commands (e.g., rewind)
+	     MT_ST_NOWAIT_EOF enables immediate filemark mode (i.e. when
+	        writing a filemark, don't wait for it to complete)
 	     MT_ST_SILI enables setting the SILI bit in SCSI commands when
 		reading in variable block mode to enhance performance when
 		reading blocks shorter than the byte count; set this only
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9b28f39..f18d10b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -81,6 +81,7 @@ static int max_sg_segs;
 static int try_direct_io = TRY_DIRECT_IO;
 static int try_rdio = 1;
 static int try_wdio = 1;
+static int st_nowait_eof;
 
 static int st_dev_max;
 static int st_nr_dev;
@@ -103,6 +104,8 @@ module_param_named(max_sg_segs, max_sg_segs, int, 0);
 MODULE_PARM_DESC(max_sg_segs, "Maximum number of scatter/gather segments to use (256)");
 module_param_named(try_direct_io, try_direct_io, int, 0);
 MODULE_PARM_DESC(try_direct_io, "Try direct I/O between user buffer and tape drive (1)");
+module_param_named(st_nowait_eof, st_nowait_eof, int, 0);
+MODULE_PARM_DESC(st_nowait_eof, "Do not wait when writing EOF (filemark) (0)");
 
 /* Extra parameters for testing */
 module_param_named(try_rdio, try_rdio, int, 0);
@@ -1106,6 +1109,12 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
                                     STp->drv_buffer));
 		}
 		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
+		if (!STp->drv_buffer && STp->immediate_filemark) {
+			printk(KERN_WARNING
+			    "%s: non-buffered tape: disabling writing immediate filemarks\n",
+			    name);
+			STp->immediate_filemark = 0;
+		}
 	}
 	st_release_request(SRpnt);
 	SRpnt = NULL;
@@ -1306,6 +1315,8 @@ static int st_flush(struct file *filp, fl_owner_t id)
 
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = WRITE_FILEMARKS;
+		if (STp->immediate_filemark)
+			cmd[1] = 1;
 		cmd[4] = 1 + STp->two_fm;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
@@ -2172,8 +2183,9 @@ static void st_log_options(struct scsi_tape * STp, struct st_modedef * STm, char
 		       name, STm->defaults_for_writes, STp->omit_blklims, STp->can_partitions,
 		       STp->scsi2_logical);
 		printk(KERN_INFO
-		       "%s:    sysv: %d nowait: %d sili: %d\n", name, STm->sysv, STp->immediate,
-			STp->sili);
+		       "%s:    sysv: %d nowait: %d sili: %d nowait_filemark: %d\n",
+		       name, STm->sysv, STp->immediate, STp->sili,
+		       STp->immediate_filemark);
 		printk(KERN_INFO "%s:    debugging: %d\n",
 		       name, debugging);
 	}
@@ -2215,6 +2227,7 @@ static int st_set_options(struct scsi_tape *STp, long options)
 			STp->can_partitions = (options & MT_ST_CAN_PARTITIONS) != 0;
 		STp->scsi2_logical = (options & MT_ST_SCSI2LOGICAL) != 0;
 		STp->immediate = (options & MT_ST_NOWAIT) != 0;
+		STp->immediate_filemark = (options & MT_ST_NOWAIT_EOF) != 0;
 		STm->sysv = (options & MT_ST_SYSV) != 0;
 		STp->sili = (options & MT_ST_SILI) != 0;
 		DEB( debugging = (options & MT_ST_DEBUGGING) != 0;
@@ -2246,6 +2259,8 @@ static int st_set_options(struct scsi_tape *STp, long options)
 			STp->scsi2_logical = value;
 		if ((options & MT_ST_NOWAIT) != 0)
 			STp->immediate = value;
+		if ((options & MT_ST_NOWAIT_EOF) != 0)
+			STp->immediate_filemark = value;
 		if ((options & MT_ST_SYSV) != 0)
 			STm->sysv = value;
 		if ((options & MT_ST_SILI) != 0)
@@ -2705,7 +2720,8 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[0] = WRITE_FILEMARKS;
 		if (cmd_in == MTWSM)
 			cmd[1] = 2;
-		if (cmd_in == MTWEOFI)
+		if (cmd_in == MTWEOFI ||
+		    (cmd_in == MTWEOF && STp->immediate_filemark))
 			cmd[1] |= 1;
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
@@ -4084,6 +4100,7 @@ static int st_probe(struct device *dev)
 	tpnt->scsi2_logical = ST_SCSI2LOGICAL;
 	tpnt->sili = ST_SILI;
 	tpnt->immediate = ST_NOWAIT;
+	tpnt->immediate_filemark = st_nowait_eof;
 	tpnt->default_drvbuffer = 0xff;		/* No forced buffering */
 	tpnt->partition = 0;
 	tpnt->new_partition = 0;
@@ -4467,6 +4484,7 @@ st_options_show(struct device *dev, struct device_attribute *attr, char *buf)
 	options |= STp->scsi2_logical ? MT_ST_SCSI2LOGICAL : 0;
 	options |= STm->sysv ? MT_ST_SYSV : 0;
 	options |= STp->immediate ? MT_ST_NOWAIT : 0;
+	options |= STp->immediate_filemark ? MT_ST_NOWAIT_EOF : 0;
 	options |= STp->sili ? MT_ST_SILI : 0;
 
 	l = snprintf(buf, PAGE_SIZE, "0x%08x\n", options);
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index f91a67c..ea35632 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -120,6 +120,7 @@ struct scsi_tape {
 	unsigned char c_algo;			/* compression algorithm */
 	unsigned char pos_unknown;			/* after reset position unknown */
 	unsigned char sili;			/* use SILI when reading in variable b mode */
+	unsigned char immediate_filemark;	/* write filemark immediately */
 	int tape_type;
 	int long_timeout;	/* timeout for commands known to take long time */
 
diff --git a/include/linux/mtio.h b/include/linux/mtio.h
index 8f82575..18543e2 100644
--- a/include/linux/mtio.h
+++ b/include/linux/mtio.h
@@ -194,6 +194,7 @@ struct	mtpos {
 #define MT_ST_SYSV              0x1000
 #define MT_ST_NOWAIT            0x2000
 #define MT_ST_SILI		0x4000
+#define MT_ST_NOWAIT_EOF	0x8000
 
 /* The mode parameters to be controlled. Parameter chosen with bits 20-28 */
 #define MT_ST_CLEAR_DEFAULT	0xfffff
-- 
1.7.8.3

