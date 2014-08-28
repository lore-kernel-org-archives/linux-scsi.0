From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/22] scsi: dump sense buffer only for debugging
Date: Thu, 28 Aug 2014 19:33:22 +0200
Message-ID: <1409247216-76074-9-git-send-email-hare@suse.de>
References: <1409247216-76074-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60187 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaH1Rdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 13:33:41 -0400
In-Reply-To: <1409247216-76074-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliot <elliot@hp.com>, Yoshihiro Yunomae <yoshihiro.ynomae.ez@hitachi.com>, Hannes Reinecke <hare@suse.de>

Dumping the entire sense buffer might overwhelm the logging functions,
so suppress it per default.

Signed-off-by: Hannes Reinecke <hare@suse.de.
---
 drivers/scsi/53c700.c    |  1 -
 drivers/scsi/constants.c | 32 ++++++++++++++++++++++----------
 drivers/scsi/scsi.c      |  6 ++++--
 drivers/scsi/sg.c        |  9 ++++++---
 drivers/scsi/st.c        | 11 ++++++++---
 include/scsi/scsi_dbg.h  | 10 ++++++----
 6 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 68bf423..8752481 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -603,7 +603,6 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 			printk(" ORIGINAL CMD %p RETURNED %d, new return is %d sense is\n",
 			       SCp, SCp->cmnd[7], result);
 			scsi_print_sense(SCp);
-
 #endif
 			dma_unmap_single(hostdata->dev, slot->dma_handle,
 					 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index f0a6595..ecce5b3 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1428,9 +1428,9 @@ scsi_print_sense_hdr(struct scsi_device *sdev, const char *name,
 }
 EXPORT_SYMBOL(scsi_print_sense_hdr);
 
-static void
-scsi_dump_sense_buffer(struct scsi_device *sdev, const char *name,
-		       const unsigned char *sense_buffer, int sense_len)
+void
+__scsi_dump_sense(struct scsi_device *sdev, const char *name,
+		  const unsigned char *sense_buffer, int sense_len)
 {
 	char linebuf[128];
 	int i, linelen, remaining;
@@ -1446,9 +1446,21 @@ scsi_dump_sense_buffer(struct scsi_device *sdev, const char *name,
 				   "Sense: %s\n", linebuf);
 	}
 }
+EXPORT_SYMBOL(__scsi_dump_sense);
+
+void
+scsi_dump_sense(struct scsi_cmnd *cmd)
+{
+	struct gendisk *disk = cmd->request->rq_disk;
+	const char *disk_name = disk ? disk->disk_name : NULL;
+
+	__scsi_dump_sense(cmd->device, disk_name, cmd->sense_buffer,
+			  SCSI_SENSE_BUFFERSIZE);
+}
+EXPORT_SYMBOL(scsi_dump_sense);
 
 /* Normalize and print sense buffer with name prefix */
-void __scsi_print_sense(struct scsi_device *sdev, const char *name,
+int __scsi_print_sense(struct scsi_device *sdev, const char *name,
 			const unsigned char *sense_buffer, int sense_len)
 {
 	struct scsi_sense_hdr sshdr;
@@ -1456,23 +1468,23 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
 
 	res = scsi_normalize_sense(sense_buffer, sense_len, &sshdr);
 	if (res == 0) {
-		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
-		return;
+		__scsi_dump_sense(sdev, name, sense_buffer, sense_len);
+		return 0;
 	}
 	scsi_show_sense_hdr(sdev, name, &sshdr);
 	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
-	scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
+	return res;
 }
 EXPORT_SYMBOL(__scsi_print_sense);
 
 /* Normalize and print sense buffer in SCSI command */
-void scsi_print_sense(struct scsi_cmnd *cmd)
+int scsi_print_sense(struct scsi_cmnd *cmd)
 {
 	struct gendisk *disk = cmd->request->rq_disk;
 	const char *disk_name = disk ? disk->disk_name : NULL;
 
-	__scsi_print_sense(cmd->device, disk_name, cmd->sense_buffer,
-			   SCSI_SENSE_BUFFERSIZE);
+	return __scsi_print_sense(cmd->device, disk_name, cmd->sense_buffer,
+				  SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 8954036..283f053 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -597,8 +597,10 @@ void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 			}
 			scsi_print_result(cmd);
 			scsi_print_command(cmd);
-			if (status_byte(cmd->result) & CHECK_CONDITION)
-				scsi_print_sense(cmd);
+			if (status_byte(cmd->result) & CHECK_CONDITION) {
+				if (scsi_print_sense(cmd))
+					scsi_dump_sense(cmd);
+			}
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
 					    "scsi host busy %d failed %d\n",
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 16f826e..6bed135 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1359,9 +1359,12 @@ sg_rq_end_io(struct request *rq, int uptodate)
 		srp->header.driver_status = driver_byte(result);
 		if ((sdp->sgdebug > 0) &&
 		    ((CHECK_CONDITION == srp->header.masked_status) ||
-		     (COMMAND_TERMINATED == srp->header.masked_status)))
-			__scsi_print_sense(sdp->device, __func__, sense,
-					   SCSI_SENSE_BUFFERSIZE);
+		     (COMMAND_TERMINATED == srp->header.masked_status))) {
+			if (__scsi_print_sense(sdp->device, __func__, sense,
+					       SCSI_SENSE_BUFFERSIZE))
+				__scsi_dump_sense(sdp->device, __func__,
+						  sense, SCSI_SENSE_BUFFERSIZE);
+		}
 
 		/* Following if statement is a patch supplied by Eric Youngdale */
 		if (driver_byte(result) != 0
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c0cc4ca..8107e03 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -373,9 +373,14 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 			    "Error: %x, cmd: %x %x %x %x %x %x\n", result,
 			    SRpnt->cmd[0], SRpnt->cmd[1], SRpnt->cmd[2],
 			    SRpnt->cmd[3], SRpnt->cmd[4], SRpnt->cmd[5]);
-		if (cmdstatp->have_sense)
-			__scsi_print_sense(STp->device, name,
-					   SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
+		if (cmdstatp->have_sense) {
+			if (__scsi_print_sense(STp->device, name,
+					       SRpnt->sense,
+					       SCSI_SENSE_BUFFERSIZE))
+				__scsi_dump_sense(STp->device, name,
+						  SRpnt->sense,
+						  SCSI_SENSE_BUFFERSIZE);
+		}
 	} ) /* end DEB */
 	if (!debugging) { /* Abnormal conditions for tape */
 		if (!cmdstatp->have_sense)
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index cd0c873..0bbf118 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -13,10 +13,12 @@ extern void scsi_show_sense_hdr(struct scsi_device *, const char *,
 				struct scsi_sense_hdr *);
 extern void scsi_print_sense_hdr(struct scsi_device *, const char *,
 				 struct scsi_sense_hdr *);
-extern void scsi_print_sense(struct scsi_cmnd *);
-extern void __scsi_print_sense(struct scsi_device *, const char *name,
-			       const unsigned char *sense_buffer,
-			       int sense_len);
+extern int scsi_print_sense(struct scsi_cmnd *);
+extern int __scsi_print_sense(struct scsi_device *, const char *,
+			      const unsigned char *, int);
+extern void scsi_dump_sense(struct scsi_cmnd *);
+extern void __scsi_dump_sense(struct scsi_device *, const char *,
+			      const unsigned char *, int);
 extern void scsi_show_result(int);
 extern void scsi_print_result(struct scsi_cmnd *);
 extern void scsi_print_status(unsigned char);
-- 
1.8.5.2

