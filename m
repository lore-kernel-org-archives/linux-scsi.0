From: Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 2/4] 2.4 SCSI error handling fixes
Date: Thu, 12 Sep 2002 19:13:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912191354.B4739@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17pYTU-0005Bc-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:13:56 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17pYTS-0001L6-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:13:54 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been chasing a few SCSI problems today, and here's 4 patches to
address the issues I found.  These patches are against 2.4.19.

My main aim here was to solve the bad behaviour with a medium error.
Some problems were found in my HBA driver, but some were found in
the error handling code.

Problems found were:

a) retrying a command with stale or invalid command information.
   (Patches 1 and 2)
b) reporting the wrong command on IO error.
   (Patch 3)
c) drives behaving badly in error condition, reporting success without
   data transfer.
   (Patch 4)

Results of investigation into these issues can be found at in my lkml
messages at:

  http://marc.theaimsgroup.com/?l=linux-kernel&m=103184937214222&w=2

Patch 4 is the one I'm least happy about; we shouldn't unconditionally
set the FUA bit in READ10 commands.  It seems that we need to set this
bit only after receiving an error, and only when we try to read the
remaining blocks which we believe are good.

Patch 2: remove loop from scsi_send_eh_cmd().  The parent function
is responsible for re-initialising the various command fields when
we need to retry the command.

--- orig/drivers/scsi/scsi_error.c	Thu Sep 12 18:01:02 2002
+++ linux/drivers/scsi/scsi_error.c	Thu Sep 12 18:07:40 2002
@@ -385,8 +385,10 @@
  */
 STATIC int scsi_eh_retry_command(Scsi_Cmnd * SCpnt)
 {
-	scsi_setup_cmd_retry(SCpnt);
-	scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
+	do {
+		scsi_setup_cmd_retry(SCpnt);
+		scsi_send_eh_cmnd(SCpnt, SCpnt->timeout_per_command);
+	} while (SCpnt->eh_state == NEEDS_RETRY);
 
 	/*
 	 * Hey, we are done.  Let's look to see what happened.
@@ -417,12 +419,6 @@
 
 	ASSERT_LOCK(&io_request_lock, 0);
 
-	memcpy((void *) SCpnt->cmnd, (void *) generic_sense,
-	       sizeof(generic_sense));
-
-	if (SCpnt->device->scsi_level <= SCSI_2)
-		SCpnt->cmnd[1] = SCpnt->lun << 5;
-
 	scsi_result = (!SCpnt->host->hostt->unchecked_isa_dma)
 	    ? &scsi_result0[0] : kmalloc(512, GFP_ATOMIC | GFP_DMA);
 
@@ -430,24 +426,40 @@
 		printk("cannot allocate scsi_result in scsi_request_sense.\n");
 		return FAILED;
 	}
-	/*
-	 * Zero the sense buffer.  Some host adapters automatically always request
-	 * sense, so it is not a good idea that SCpnt->request_buffer and
-	 * SCpnt->sense_buffer point to the same address (DB).
-	 * 0 is not a valid sense code. 
-	 */
-	memset((void *) SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
-	memset((void *) scsi_result, 0, 256);
 
 	saved_result = SCpnt->result;
-	SCpnt->request_buffer = scsi_result;
-	SCpnt->request_bufflen = 256;
-	SCpnt->use_sg = 0;
-	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
-	SCpnt->sc_data_direction = SCSI_DATA_READ;
-	SCpnt->underflow = 0;
 
-	scsi_send_eh_cmnd(SCpnt, SENSE_TIMEOUT);
+	do {
+		memcpy((void *) SCpnt->cmnd, (void *) generic_sense,
+		       sizeof(generic_sense));
+
+		if (SCpnt->device->scsi_level <= SCSI_2)
+			SCpnt->cmnd[1] = SCpnt->lun << 5;
+
+		/*
+		 * Zero the sense buffer.  Some host adapters automatically
+		 * always request sense, so it is not a good idea that
+		 * SCpnt->request_buffer and SCpnt->sense_buffer point to
+		 * the same address (DB).  0 is not a valid sense code. 
+		 */
+		memset((void *) SCpnt->sense_buffer, 0,
+		       sizeof(SCpnt->sense_buffer));
+		memset((void *) scsi_result, 0, 256);
+
+		SCpnt->request_buffer = scsi_result;
+		SCpnt->request_bufflen = 256;
+		SCpnt->use_sg = 0;
+		SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
+		SCpnt->sc_data_direction = SCSI_DATA_READ;
+		SCpnt->underflow = 0;
+
+		scsi_send_eh_cmnd(SCpnt, SENSE_TIMEOUT);
+		/*
+		 * If the SCSI device responded with "logical unit
+		 * is in process of becoming ready", we need to
+		 * retry this command.
+		 */
+	} while (SCpnt->eh_state == NEEDS_RETRY);
 
 	/* Last chance to have valid sense data */
 	if (!scsi_sense_valid(SCpnt))
@@ -489,26 +501,34 @@
 	static unsigned char tur_command[6] =
 	{TEST_UNIT_READY, 0, 0, 0, 0, 0};
 
-	memcpy((void *) SCpnt->cmnd, (void *) tur_command,
-	       sizeof(tur_command));
+	do {
+		memcpy((void *) SCpnt->cmnd, (void *) tur_command,
+		       sizeof(tur_command));
 
-	if (SCpnt->device->scsi_level <= SCSI_2)
-		SCpnt->cmnd[1] = SCpnt->lun << 5;
+		if (SCpnt->device->scsi_level <= SCSI_2)
+			SCpnt->cmnd[1] = SCpnt->lun << 5;
 
-	/*
-	 * Zero the sense buffer.  The SCSI spec mandates that any
-	 * untransferred sense data should be interpreted as being zero.
-	 */
-	memset((void *) SCpnt->sense_buffer, 0, sizeof(SCpnt->sense_buffer));
+		/*
+		 * Zero the sense buffer.  The SCSI spec mandates that any
+		 * untransferred sense data should be interpreted as being zero.
+		 */
+		memset((void *) SCpnt->sense_buffer, 0,
+		       sizeof(SCpnt->sense_buffer));
 
-	SCpnt->request_buffer = NULL;
-	SCpnt->request_bufflen = 0;
-	SCpnt->use_sg = 0;
-	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
-	SCpnt->underflow = 0;
-	SCpnt->sc_data_direction = SCSI_DATA_NONE;
+		SCpnt->request_buffer = NULL;
+		SCpnt->request_bufflen = 0;
+		SCpnt->use_sg = 0;
+		SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
+		SCpnt->underflow = 0;
+		SCpnt->sc_data_direction = SCSI_DATA_NONE;
 
-	scsi_send_eh_cmnd(SCpnt, SENSE_TIMEOUT);
+		scsi_send_eh_cmnd(SCpnt, SENSE_TIMEOUT);
+		/*
+		 * If the SCSI device responded with "logical unit
+		 * is in process of becoming ready", we need to
+		 * retry this command.
+		 */
+	} while (SCpnt->eh_state == NEEDS_RETRY);
 
 	/*
 	 * When we eventually call scsi_finish, we really wish to complete
@@ -581,7 +601,6 @@
 
 	host = SCpnt->host;
 
-      retry:
 	/*
 	 * We will use a queued command if possible, otherwise we will emulate the
 	 * queuing and calling of completion function ourselves.
@@ -664,14 +683,13 @@
 		SCSI_LOG_ERROR_RECOVERY(3,
 			printk("scsi_send_eh_cmnd: scsi_eh_completed_normally %x\n", ret));
 		switch (ret) {
-		case SUCCESS:
-			SCpnt->eh_state = SUCCESS;
-			break;
-		case NEEDS_RETRY:
-			goto retry;
-		case FAILED:
 		default:
-			SCpnt->eh_state = FAILED;
+			ret = FAILED;
+			/*FALLTHROUGH*/
+		case FAILED:
+		case NEEDS_RETRY:
+		case SUCCESS:
+			SCpnt->eh_state = ret;
 			break;
 		}
 	} else {

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

