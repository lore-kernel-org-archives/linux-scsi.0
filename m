From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/23] scsi: Use sdev as argument for sense code printing
Date: Tue, 30 Sep 2014 13:50:34 +0200
Message-ID: <1412077852-40893-6-git-send-email-hare@suse.de>
References: <1412077852-40893-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57135 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaI3LvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Sep 2014 07:51:04 -0400
In-Reply-To: <1412077852-40893-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

We should be using the standard dev_printk() variants for
sense code printing.

Reviewed-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/53c700.c      |   2 +-
 drivers/scsi/ch.c          |   2 +-
 drivers/scsi/constants.c   | 117 ++++++++++++++++++++++-----------------------
 drivers/scsi/osst.c        |   8 ++--
 drivers/scsi/scsi.c        |   2 +-
 drivers/scsi/scsi_error.c  |   2 +-
 drivers/scsi/scsi_ioctl.c  |   2 +-
 drivers/scsi/scsi_lib.c    |   4 +-
 drivers/scsi/sd.c          |   9 ++--
 drivers/scsi/sg.c          |   2 +-
 drivers/scsi/sr_ioctl.c    |   6 +--
 drivers/scsi/st.c          |   6 ++-
 drivers/scsi/storvsc_drv.c |   3 +-
 include/scsi/scsi_dbg.h    |  17 ++++---
 14 files changed, 96 insertions(+), 86 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index fabd4be..68bf423 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -602,7 +602,7 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 #ifdef NCR_700_DEBUG
 			printk(" ORIGINAL CMD %p RETURNED %d, new return is %d sense is\n",
 			       SCp, SCp->cmnd[7], result);
-			scsi_print_sense("53c700", SCp);
+			scsi_print_sense(SCp);
 
 #endif
 			dma_unmap_single(hostdata->dev, slot->dma_handle,
diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 52060e7..53621a3 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -206,7 +206,7 @@ ch_do_scsi(scsi_changer *ch, unsigned char *cmd,
 	DPRINTK("result: 0x%x\n",result);
 	if (driver_byte(result) & DRIVER_SENSE) {
 		if (debug)
-			scsi_print_sense_hdr(ch->name, &sshdr);
+			scsi_print_sense_hdr(ch->device, ch->name, &sshdr);
 		errno = ch_find_errno(&sshdr);
 
 		switch(sshdr.sense_key) {
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 2f44707..dab8d74 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1292,18 +1292,19 @@ static const struct error_info additional[] =
 
 struct error_info2 {
 	unsigned char code1, code2_min, code2_max;
+	const char * str;
 	const char * fmt;
 };
 
 static const struct error_info2 additional2[] =
 {
-	{0x40, 0x00, 0x7f, "Ram failure (%x)"},
-	{0x40, 0x80, 0xff, "Diagnostic failure on component (%x)"},
-	{0x41, 0x00, 0xff, "Data path failure (%x)"},
-	{0x42, 0x00, 0xff, "Power-on or self-test failure (%x)"},
-	{0x4D, 0x00, 0xff, "Tagged overlapped commands (task tag %x)"},
-	{0x70, 0x00, 0xff, "Decompression exception short algorithm id of %x"},
-	{0, 0, 0, NULL}
+	{0x40, 0x00, 0x7f, "Ram failure", ""},
+	{0x40, 0x80, 0xff, "Diagnostic failure on component", ""},
+	{0x41, 0x00, 0xff, "Data path failure", ""},
+	{0x42, 0x00, 0xff, "Power-on or self-test failure", ""},
+	{0x4D, 0x00, 0xff, "Tagged overlapped commands", "task tag "},
+	{0x70, 0x00, 0xff, "Decompression exception", "short algorithm id of "},
+	{0, 0, 0, NULL, NULL}
 };
 
 /* description of the sense key values */
@@ -1349,7 +1350,8 @@ EXPORT_SYMBOL(scsi_sense_key_string);
  * This string may contain a "%x" and should be printed with ascq as arg.
  */
 const char *
-scsi_extd_sense_format(unsigned char asc, unsigned char ascq) {
+scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
+{
 #ifdef CONFIG_SCSI_CONSTANTS
 	int i;
 	unsigned short code = ((asc << 8) | ascq);
@@ -1361,7 +1363,8 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq) {
 		if (additional2[i].code1 == asc &&
 		    ascq >= additional2[i].code2_min &&
 		    ascq <= additional2[i].code2_max)
-			return additional2[i].fmt;
+			*fmt = additional2[i].fmt;
+			return additional2[i].str;
 	}
 #endif
 	return NULL;
@@ -1369,49 +1372,53 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq) {
 EXPORT_SYMBOL(scsi_extd_sense_format);
 
 void
-scsi_show_extd_sense(unsigned char asc, unsigned char ascq)
+scsi_show_extd_sense(struct scsi_device *sdev, const char *name,
+		     unsigned char asc, unsigned char ascq)
 {
-        const char *extd_sense_fmt = scsi_extd_sense_format(asc, ascq);
+	const char *extd_sense_fmt = NULL;
+	const char *extd_sense_str = scsi_extd_sense_format(asc, ascq,
+							    &extd_sense_fmt);
+
+	if (extd_sense_str) {
+		if (extd_sense_fmt)
+			sdev_prefix_printk(KERN_INFO, sdev, name,
+					   "Add. Sense: %s (%s%x)",
+					   extd_sense_str, extd_sense_fmt,
+					   ascq);
+		else
+			sdev_prefix_printk(KERN_INFO, sdev, name,
+					   "Add. Sense: %s", extd_sense_str);
 
-	if (extd_sense_fmt) {
-		if (strstr(extd_sense_fmt, "%x")) {
-			printk("Add. Sense: ");
-			printk(extd_sense_fmt, ascq);
-		} else
-			printk("Add. Sense: %s", extd_sense_fmt);
 	} else {
-		if (asc >= 0x80)
-			printk("<<vendor>> ASC=0x%x ASCQ=0x%x", asc,
-			       ascq);
-		if (ascq >= 0x80)
-			printk("ASC=0x%x <<vendor>> ASCQ=0x%x", asc,
-			       ascq);
-		else
-			printk("ASC=0x%x ASCQ=0x%x", asc, ascq);
+		sdev_prefix_printk(KERN_INFO, sdev, name,
+				   "%sASC=0x%x %sASCQ=0x%x\n",
+				   asc >= 0x80 ? "<<vendor>> " : "", asc,
+				   ascq >= 0x80 ? "<<vendor>> " : "", ascq);
 	}
-
-	printk("\n");
 }
 EXPORT_SYMBOL(scsi_show_extd_sense);
 
 void
-scsi_show_sense_hdr(struct scsi_sense_hdr *sshdr)
+scsi_show_sense_hdr(struct scsi_device *sdev, const char *name,
+		    struct scsi_sense_hdr *sshdr)
 {
 	const char *sense_txt;
 
 	sense_txt = scsi_sense_key_string(sshdr->sense_key);
 	if (sense_txt)
-		printk("Sense Key : %s ", sense_txt);
+		sdev_prefix_printk(KERN_INFO, sdev, name,
+				   "Sense Key : %s [%s]%s\n", sense_txt,
+				   scsi_sense_is_deferred(sshdr) ?
+				   "deferred" : "current",
+				   sshdr->response_code >= 0x72 ?
+				   " [descriptor]" : "");
 	else
-		printk("Sense Key : 0x%x ", sshdr->sense_key);
-
-	printk("%s", scsi_sense_is_deferred(sshdr) ? "[deferred] " :
-	       "[current] ");
-
-	if (sshdr->response_code >= 0x72)
-		printk("[descriptor]");
-
-	printk("\n");
+		sdev_prefix_printk(KERN_INFO, sdev, name,
+				   "Sense Key : 0x%x [%s]%s", sshdr->sense_key,
+				   scsi_sense_is_deferred(sshdr) ?
+				   "deferred" : "current",
+				   sshdr->response_code >= 0x72 ?
+				   " [descriptor]" : "");
 }
 EXPORT_SYMBOL(scsi_show_sense_hdr);
 
@@ -1419,12 +1426,11 @@ EXPORT_SYMBOL(scsi_show_sense_hdr);
  * Print normalized SCSI sense header with a prefix.
  */
 void
-scsi_print_sense_hdr(const char *name, struct scsi_sense_hdr *sshdr)
+scsi_print_sense_hdr(struct scsi_device *sdev, const char *name,
+		     struct scsi_sense_hdr *sshdr)
 {
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_sense_hdr(sshdr);
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	scsi_show_sense_hdr(sdev, name, sshdr);
+	scsi_show_extd_sense(sdev, name, sshdr->asc, sshdr->ascq);
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
@@ -1513,33 +1519,26 @@ scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
 }
 
 /* Normalize and print sense buffer with name prefix */
-void __scsi_print_sense(const char *name, const unsigned char *sense_buffer,
-			int sense_len)
+void __scsi_print_sense(struct scsi_device *sdev, const char *name,
+			const unsigned char *sense_buffer, int sense_len)
 {
 	struct scsi_sense_hdr sshdr;
 
-	printk(KERN_INFO "%s: ", name);
 	scsi_decode_sense_buffer(sense_buffer, sense_len, &sshdr);
-	scsi_show_sense_hdr(&sshdr);
+	scsi_show_sense_hdr(sdev, name, &sshdr);
 	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
-	printk(KERN_INFO "%s: ", name);
-	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
+	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
 }
 EXPORT_SYMBOL(__scsi_print_sense);
 
 /* Normalize and print sense buffer in SCSI command */
-void scsi_print_sense(char *name, struct scsi_cmnd *cmd)
+void scsi_print_sense(struct scsi_cmnd *cmd)
 {
-	struct scsi_sense_hdr sshdr;
+	struct gendisk *disk = cmd->request->rq_disk;
+	const char *disk_name = disk ? disk->disk_name : NULL;
 
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_decode_sense_buffer(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
-				 &sshdr);
-	scsi_show_sense_hdr(&sshdr);
-	scsi_decode_sense_extras(cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE,
-				 &sshdr);
-	scmd_printk(KERN_INFO, cmd, " ");
-	scsi_show_extd_sense(sshdr.asc, sshdr.ascq);
+	__scsi_print_sense(cmd->device, disk_name, cmd->sense_buffer,
+			   SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 0727ea7..4ba2a9f 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -259,9 +259,10 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 		   SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
 		   SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (scode) printk(OSST_DEB_MSG "%s:D: Sense: %02x, ASC: %02x, ASCQ: %02x\n",
-			       	name, scode, sense[12], sense[13]);
+				  name, scode, sense[12], sense[13]);
 		if (cmdstatp->have_sense)
-			__scsi_print_sense("osst ", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			__scsi_print_sense(STp->device, name,
+					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	}
 	else
 #endif
@@ -275,7 +276,8 @@ static int osst_chk_result(struct osst_tape * STp, struct osst_request * SRpnt)
 		 SRpnt->cmd[0] != TEST_UNIT_READY)) { /* Abnormal conditions for tape */
 		if (cmdstatp->have_sense) {
 			printk(KERN_WARNING "%s:W: Command with sense data:\n", name);
-			__scsi_print_sense("osst ", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			__scsi_print_sense(STp->device, name,
+					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 		}
 		else {
 			static	int	notyetprinted = 1;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 1423cb1..61aeaf1 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -606,7 +606,7 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 			scsi_print_result(cmd);
 			scsi_print_command(cmd);
 			if (status_byte(cmd->result) & CHECK_CONDITION)
-				scsi_print_sense("", cmd);
+				scsi_print_sense(cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
 					    "scsi host busy %d failed %d\n",
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6b20ef3..6c99624 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1180,7 +1180,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
 		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
 			"sense requested for %p result %x\n",
 			scmd, scmd->result));
-		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense("bh", scmd));
+		SCSI_LOG_ERROR_RECOVERY(3, scsi_print_sense(scmd));
 
 		rtn = scsi_decide_disposition(scmd);
 
diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 1aaaf43..7d2de08 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -126,7 +126,7 @@ static int ioctl_internal_command(struct scsi_device *sdev, char *cmd,
 			sdev_printk(KERN_INFO, sdev,
 				    "ioctl_internal_command return code = %x\n",
 				    result);
-			scsi_print_sense_hdr("   ", &sshdr);
+			scsi_print_sense_hdr(sdev, NULL, &sshdr);
 			break;
 		}
 	}
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b9a8ddd..c3220b7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -911,7 +911,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		if ((sshdr.asc == 0x0) && (sshdr.ascq == 0x1d))
 			;
 		else if (!(req->cmd_flags & REQ_QUIET))
-			scsi_print_sense("", cmd);
+			scsi_print_sense(cmd);
 		result = 0;
 		/* BLOCK_PC may have set error */
 		error = 0;
@@ -1040,7 +1040,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		if (!(req->cmd_flags & REQ_QUIET)) {
 			scsi_print_result(cmd);
 			if (driver_byte(result) & DRIVER_SENSE)
-				scsi_print_sense("", cmd);
+				scsi_print_sense(cmd);
 			scsi_print_command(cmd);
 		}
 		if (!scsi_end_request(req, error, blk_rq_err_bytes(req), 0))
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 0ccb459..848b17d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3321,10 +3321,11 @@ module_exit(exit_sd);
 static void sd_print_sense_hdr(struct scsi_disk *sdkp,
 			       struct scsi_sense_hdr *sshdr)
 {
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_sense_hdr(sshdr);
-	sd_printk(KERN_INFO, sdkp, " ");
-	scsi_show_extd_sense(sshdr->asc, sshdr->ascq);
+	scsi_show_sense_hdr(sdkp->device,
+			    sdkp->disk ? sdkp->disk->disk_name : NULL, sshdr);
+	scsi_show_extd_sense(sdkp->device,
+			     sdkp->disk ? sdkp->disk->disk_name : NULL,
+			     sshdr->asc, sshdr->ascq);
 }
 
 static void sd_print_result(struct scsi_disk *sdkp, int result)
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 87304c8..fde1f18 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1360,7 +1360,7 @@ sg_rq_end_io(struct request *rq, int uptodate)
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
 		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense(__func__, sense,
+			__scsi_print_sense(sdp->device, __func__, sense,
 					   SCSI_SENSE_BUFFERSIZE);
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 6389fcf..17e0c2b 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -246,7 +246,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 					  "CDROM not ready.  Make sure there "
 					  "is a disc in the drive.\n");
 #ifdef DEBUG
-			scsi_print_sense_hdr("sr", &sshdr);
+			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 #endif
 			err = -ENOMEDIUM;
 			break;
@@ -258,14 +258,14 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 				err = -EDRIVE_CANT_DO_THIS;
 #ifdef DEBUG
 			__scsi_print_command(cgc->cmd);
-			scsi_print_sense_hdr("sr", &sshdr);
+			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 #endif
 			break;
 		default:
 			sr_printk(KERN_ERR, cd,
 				  "CDROM (ioctl) error, command: ");
 			__scsi_print_command(cgc->cmd);
-			scsi_print_sense_hdr("sr", &sshdr);
+			scsi_print_sense_hdr(cd->device, cd->cdi.name, &sshdr);
 			err = -EIO;
 		}
 	}
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e479343..052d1f9 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -373,7 +373,8 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 			    SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
 			    SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
 		if (cmdstatp->have_sense)
-			 __scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			__scsi_print_sense(STp->device, name,
+					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
@@ -389,7 +390,8 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 			 SRpnt->cmd[0] != MODE_SENSE &&
 			 SRpnt->cmd[0] != TEST_UNIT_READY) {
 
-			__scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+			__scsi_print_sense(STp->device, name,
+					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
 		}
 	}
 
diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fecac5d0..9168d1b 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1097,7 +1097,8 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 	if (scmnd->result) {
 		if (scsi_normalize_sense(scmnd->sense_buffer,
 				SCSI_SENSE_BUFFERSIZE, &sense_hdr))
-			scsi_print_sense_hdr("storvsc", &sense_hdr);
+			scsi_print_sense_hdr(scmnd->device, "storvsc",
+					     &sense_hdr);
 	}
 
 	if (vm_srb->srb_status != SRB_STATUS_SUCCESS)
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index 5a43a4c..cd0c873 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -2,21 +2,26 @@
 #define _SCSI_SCSI_DBG_H
 
 struct scsi_cmnd;
+struct scsi_device;
 struct scsi_sense_hdr;
 
 extern void scsi_print_command(struct scsi_cmnd *);
 extern void __scsi_print_command(unsigned char *);
-extern void scsi_show_extd_sense(unsigned char, unsigned char);
-extern void scsi_show_sense_hdr(struct scsi_sense_hdr *);
-extern void scsi_print_sense_hdr(const char *, struct scsi_sense_hdr *);
-extern void scsi_print_sense(char *, struct scsi_cmnd *);
-extern void __scsi_print_sense(const char *name,
+extern void scsi_show_extd_sense(struct scsi_device *, const char *,
+				 unsigned char, unsigned char);
+extern void scsi_show_sense_hdr(struct scsi_device *, const char *,
+				struct scsi_sense_hdr *);
+extern void scsi_print_sense_hdr(struct scsi_device *, const char *,
+				 struct scsi_sense_hdr *);
+extern void scsi_print_sense(struct scsi_cmnd *);
+extern void __scsi_print_sense(struct scsi_device *, const char *name,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
 extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern void scsi_print_status(unsigned char);
 extern const char *scsi_sense_key_string(unsigned char);
-extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
+extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
+					  const char **);
 
 #endif /* _SCSI_SCSI_DBG_H */
-- 
1.8.5.2

