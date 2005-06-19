From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_eh_eflags_ macros
Date: Sun, 19 Jun 2005 13:43:26 +0200
Message-ID: <20050619114326.GF18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:13996 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262251AbVFSLn2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 07:43:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Just opencoded access to eh_eflags, it's much more readable anyway.


Index: linux-2.6/drivers/scsi/libata-core.c
===================================================================
--- linux-2.6.orig/drivers/scsi/libata-core.c	2005-06-19 00:16:48.000000000 +0200
+++ linux-2.6/drivers/scsi/libata-core.c	2005-06-19 12:23:06.000000000 +0200
@@ -2864,7 +2864,7 @@
 	if (qc->dev->class == ATA_DEV_ATAPI && qc->scsicmd) {
 		struct scsi_cmnd *cmd = qc->scsicmd;
 
-		if (!scsi_eh_eflags_chk(cmd, SCSI_EH_CANCEL_CMD)) {
+		if (!(cmd->eh_eflags & SCSI_EH_CANCEL_CMD)) {
 
 			/* finish completing original command */
 			__ata_qc_complete(qc);
Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2005-06-19 12:19:53.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2005-06-19 12:27:05.000000000 +0200
@@ -73,7 +73,7 @@
 
 	spin_lock_irqsave(shost->host_lock, flags);
 
-	scsi_eh_eflags_set(scmd, eh_flag);
+	scmd->eh_eflags |= eh_flag;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	set_bit(SHOST_RECOVERY, &shost->shost_state);
 	shost->host_failed++;
@@ -228,8 +228,7 @@
 		list_for_each_entry(scmd, work_q, eh_entry) {
 			if (scmd->device == sdev) {
 				++total_failures;
-				if (scsi_eh_eflags_chk(scmd,
-						       SCSI_EH_CANCEL_CMD))
+				if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD)
 					++cmd_cancel;
 				else 
 					++cmd_failed;
@@ -425,7 +424,7 @@
  **/
 static void scsi_eh_times_out(struct scsi_cmnd *scmd)
 {
-	scsi_eh_eflags_set(scmd, SCSI_EH_REC_TIMEOUT);
+	scmd->eh_eflags |= SCSI_EH_REC_TIMEOUT;
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd:%p\n", __FUNCTION__,
 					  scmd));
 
@@ -504,8 +503,8 @@
 	 * see if timeout.  if so, tell the host to forget about it.
 	 * in other words, we don't want a callback any more.
 	 */
-	if (scsi_eh_eflags_chk(scmd, SCSI_EH_REC_TIMEOUT)) {
-		scsi_eh_eflags_clr(scmd,  SCSI_EH_REC_TIMEOUT);
+	if (scmd->eh_eflags & SCSI_EH_REC_TIMEOUT) {
+		scmd->eh_eflags &= ~SCSI_EH_REC_TIMEOUT;
 
 		/*
 		 * as far as the low level driver is
@@ -630,7 +629,7 @@
 			       struct list_head *done_q)
 {
 	scmd->device->host->host_failed--;
-	scsi_eh_eflags_clr_all(scmd);
+	scmd->eh_eflags = 0;
 
 	/*
 	 * set this back so that the upper level can correctly free up
@@ -669,7 +668,7 @@
 
 	list_for_each_safe(lh, lh_sf, work_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD) ||
+		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
 		    SCSI_SENSE_VALID(scmd))
 			continue;
 
@@ -805,14 +804,14 @@
 
 	list_for_each_safe(lh, lh_sf, work_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
-		if (!scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD))
+		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
 			continue;
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
 						  "0x%p\n", current->comm,
 						  scmd));
 		rtn = scsi_try_to_abort_cmd(scmd);
 		if (rtn == SUCCESS) {
-			scsi_eh_eflags_clr(scmd,  SCSI_EH_CANCEL_CMD);
+			scmd->eh_eflags &= ~SCSI_EH_CANCEL_CMD;
 			if (!scsi_device_online(scmd->device) ||
 			    !scsi_eh_tur(scmd)) {
 				scsi_eh_finish_cmd(scmd, done_q);
@@ -1194,7 +1193,7 @@
 				scmd->device->id,
 				scmd->device->lun);
 		scsi_device_set_state(scmd->device, SDEV_OFFLINE);
-		if (scsi_eh_eflags_chk(scmd, SCSI_EH_CANCEL_CMD)) {
+		if (scmd->eh_eflags & SCSI_EH_CANCEL_CMD) {
 			/*
 			 * FIXME: Handle lost cmds.
 			 */
Index: linux-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_priv.h	2005-06-19 12:04:21.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_priv.h	2005-06-19 12:25:37.000000000 +0200
@@ -21,15 +21,6 @@
 /*
  * Scsi Error Handler Flags
  */
-#define scsi_eh_eflags_chk(scp, flags) \
-	((scp)->eh_eflags & (flags))
-#define scsi_eh_eflags_set(scp, flags) \
-	do { (scp)->eh_eflags |= (flags); } while(0)
-#define scsi_eh_eflags_clr(scp, flags) \
-	do { (scp)->eh_eflags &= ~(flags); } while(0)
-#define scsi_eh_eflags_clr_all(scp) \
-	(scp->eh_eflags = 0)
-
 #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
 #define SCSI_EH_REC_TIMEOUT	0x0002	/* EH retry timed out */
 
