From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH] SCSI, st: modify tape driver to allow writing immediate filemarks
Date: Tue, 07 Feb 2012 17:07:12 -0800
Message-ID: <4F31CAC0.3010905@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:63878 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab2BHBHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2012 20:07:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Add an st module option st_nowait_eof which defaults to 0. Setting this
option to 1 tells the st driver not to wait when writing a filemark, which
can result in much faster times on streaming tape drives.

Legacy applications cannot take advantage of the newer MTWEOFI ioctl, so this
patch gives such applications the ability to write an immediate EOF using the
normal MTWEOF ioctl if they set st_nowait_eof=1.

Reference: https://bugzilla.novell.com/show_bug.cgi?id=688996

Signed-off-by: Lee Duncan <lduncan@suse.com>
--- 
 drivers/scsi/st.c |   18 +++++++++++++++---
 drivers/scsi/st.h |    1 +
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9b28f39..1dd617a 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -81,6 +81,7 @@ static int max_sg_segs;
 static int try_direct_io = TRY_DIRECT_IO;
 static int try_rdio = 1;
 static int try_wdio = 1;
+static int st_nowait_eof = 0;
 
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
@@ -1106,6 +1109,11 @@ static int check_tape(struct scsi_tape *STp, struct file *filp)
                                     STp->drv_buffer));
 		}
 		STp->drv_write_prot = ((STp->buffer)->b_data[2] & 0x80) != 0;
+		if (!STp->drv_buffer && STp->immediate_filemark) {
+			printk(KERN_WARNING "%s: non-buffered tape: "
+			    "disabling writing immediate filemarks", name);
+			STp->immediate_filemark = 0;
+		}
 	}
 	st_release_request(SRpnt);
 	SRpnt = NULL;
@@ -1306,6 +1314,8 @@ static int st_flush(struct file *filp, fl_owner_t id)
 
 		memset(cmd, 0, MAX_COMMAND_SIZE);
 		cmd[0] = WRITE_FILEMARKS;
+		if (STp->immediate_filemark)
+			cmd[1] = 1;
 		cmd[4] = 1 + STp->two_fm;
 
 		SRpnt = st_do_scsi(NULL, STp, cmd, 0, DMA_NONE,
@@ -2172,8 +2182,8 @@ static void st_log_options(struct scsi_tape * STp, struct st_modedef * STm, char
 		       name, STm->defaults_for_writes, STp->omit_blklims, STp->can_partitions,
 		       STp->scsi2_logical);
 		printk(KERN_INFO
-		       "%s:    sysv: %d nowait: %d sili: %d\n", name, STm->sysv, STp->immediate,
-			STp->sili);
+		       "%s:    sysv: %d nowait: %d sili: %d nowait_filemark: %d\n",
+		       name, STm->sysv, STp->immediate, STp->sili, STp->immediate_filemark);
 		printk(KERN_INFO "%s:    debugging: %d\n",
 		       name, debugging);
 	}
@@ -2705,7 +2715,8 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		cmd[0] = WRITE_FILEMARKS;
 		if (cmd_in == MTWSM)
 			cmd[1] = 2;
-		if (cmd_in == MTWEOFI)
+		if (cmd_in == MTWEOFI ||
+		    (cmd_in == MTWEOF && STp->immediate_filemark))
 			cmd[1] |= 1;
 		cmd[2] = (arg >> 16);
 		cmd[3] = (arg >> 8);
@@ -4084,6 +4095,7 @@ static int st_probe(struct device *dev)
 	tpnt->scsi2_logical = ST_SCSI2LOGICAL;
 	tpnt->sili = ST_SILI;
 	tpnt->immediate = ST_NOWAIT;
+	tpnt->immediate_filemark = st_nowait_eof;
 	tpnt->default_drvbuffer = 0xff;		/* No forced buffering */
 	tpnt->partition = 0;
 	tpnt->new_partition = 0;
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index f91a67c..24f97f1 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -120,6 +120,7 @@ struct scsi_tape {
 	unsigned char c_algo;			/* compression algorithm */
 	unsigned char pos_unknown;			/* after reset position unknown */
 	unsigned char sili;			/* use SILI when reading in variable b mode */
+	unsigned char immediate_filemark;	/* set immediate bit when writing filemark */
 	int tape_type;
 	int long_timeout;	/* timeout for commands known to take long time */
 
