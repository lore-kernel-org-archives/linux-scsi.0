From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill of ->command
Date: Mon, 9 Jun 2003 18:20:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609162056.GA1857@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:44174 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264493AbTFIQHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 12:07:20 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

It's unused now.  Also kill off the stupid = NULL initializations
in usb-storage that made this not compile the first time..


diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sun Jun  8 20:31:57 2003
+++ b/drivers/scsi/scsi.c	Sun Jun  8 20:31:57 2003
@@ -441,29 +441,18 @@
 		goto out;
 	}
 
-	if (host->can_queue) {
-		SCSI_LOG_MLQUEUE(3, printk("queuecommand : routine at %p\n",
-					   host->hostt->queuecommand));
+	SCSI_LOG_MLQUEUE(3, printk("queuecommand : routine at %p\n",
+				   host->hostt->queuecommand));
 
-		spin_lock_irqsave(host->host_lock, flags);
-		rtn = host->hostt->queuecommand(cmd, scsi_done);
-		spin_unlock_irqrestore(host->host_lock, flags);
-		if (rtn) {
-			scsi_queue_insert(cmd,
+	spin_lock_irqsave(host->host_lock, flags);
+	rtn = host->hostt->queuecommand(cmd, scsi_done);
+	spin_unlock_irqrestore(host->host_lock, flags);
+	if (rtn) {
+		scsi_queue_insert(cmd,
 				(rtn == SCSI_MLQUEUE_DEVICE_BUSY) ?
-					rtn : SCSI_MLQUEUE_HOST_BUSY);
-			SCSI_LOG_MLQUEUE(3,
-			    printk("queuecommand : request rejected\n"));
-		}
-	} else {
-		SCSI_LOG_MLQUEUE(3, printk("command() :  routine at %p\n",
-					host->hostt->command));
-
-		spin_lock_irqsave(host->host_lock, flags);
-		cmd->result = host->hostt->command(cmd);
-		scsi_done(cmd);
-		spin_unlock_irqrestore(host->host_lock, flags);
-		rtn = 0;
+				 rtn : SCSI_MLQUEUE_HOST_BUSY);
+		SCSI_LOG_MLQUEUE(3,
+		    printk("queuecommand : request rejected\n"));
 	}
 
  out:
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Sun Jun  8 20:31:57 2003
+++ b/drivers/scsi/scsi_error.c	Sun Jun  8 20:31:57 2003
@@ -435,6 +435,7 @@
 static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, int timeout)
 {
 	struct Scsi_Host *host = scmd->device->host;
+	DECLARE_MUTEX_LOCKED(sem);
 	unsigned long flags;
 	int rtn = SUCCESS;
 
@@ -448,71 +449,53 @@
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(scmd->device->lun << 5 & 0xe0);
 
-	if (host->can_queue) {
-		DECLARE_MUTEX_LOCKED(sem);
+	scsi_add_timer(scmd, timeout, scsi_eh_times_out);
 
-		scsi_add_timer(scmd, timeout, scsi_eh_times_out);
+	/*
+	 * set up the semaphore so we wait for the command to complete.
+	 */
+	scmd->device->host->eh_action = &sem;
+	scmd->request->rq_status = RQ_SCSI_BUSY;
 
-		/*
-		 * set up the semaphore so we wait for the command to complete.
-		 */
-		scmd->device->host->eh_action = &sem;
-		scmd->request->rq_status = RQ_SCSI_BUSY;
+	spin_lock_irqsave(scmd->device->host->host_lock, flags);
+	host->hostt->queuecommand(scmd, scsi_eh_done);
+	spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 
-		spin_lock_irqsave(scmd->device->host->host_lock, flags);
-		host->hostt->queuecommand(scmd, scsi_eh_done);
-		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
+	down(&sem);
 
-		down(&sem);
+	scmd->device->host->eh_action = NULL;
 
-		scmd->device->host->eh_action = NULL;
+	/*
+	 * see if timeout.  if so, tell the host to forget about it.
+	 * in other words, we don't want a callback any more.
+	 */
+	if (scsi_eh_eflags_chk(scmd, SCSI_EH_REC_TIMEOUT)) {
+		scsi_eh_eflags_clr(scmd,  SCSI_EH_REC_TIMEOUT);
+		scmd->owner = SCSI_OWNER_LOWLEVEL;
 
 		/*
-		 * see if timeout.  if so, tell the host to forget about it.
-		 * in other words, we don't want a callback any more.
+		 * as far as the low level driver is
+		 * concerned, this command is still active, so
+		 * we must give the low level driver a chance
+		 * to abort it. (db) 
+		 *
+		 * FIXME(eric) - we are not tracking whether we could
+		 * abort a timed out command or not.  not sure how
+		 * we should treat them differently anyways.
 		 */
-		if (scsi_eh_eflags_chk(scmd, SCSI_EH_REC_TIMEOUT)) {
-			scsi_eh_eflags_clr(scmd,  SCSI_EH_REC_TIMEOUT);
-                        scmd->owner = SCSI_OWNER_LOWLEVEL;
-
-			/*
-			 * as far as the low level driver is
-			 * concerned, this command is still active, so
-			 * we must give the low level driver a chance
-			 * to abort it. (db) 
-			 *
-			 * FIXME(eric) - we are not tracking whether we could
-			 * abort a timed out command or not.  not sure how
-			 * we should treat them differently anyways.
-			 */
-			spin_lock_irqsave(scmd->device->host->host_lock, flags);
-			if (scmd->device->host->hostt->eh_abort_handler)
-				scmd->device->host->hostt->eh_abort_handler(scmd);
-			spin_unlock_irqrestore(scmd->device->host->host_lock,
-					       flags);
+		spin_lock_irqsave(scmd->device->host->host_lock, flags);
+		if (scmd->device->host->hostt->eh_abort_handler)
+			scmd->device->host->hostt->eh_abort_handler(scmd);
+		spin_unlock_irqrestore(scmd->device->host->host_lock, flags);
 			
-			scmd->request->rq_status = RQ_SCSI_DONE;
-			scmd->owner = SCSI_OWNER_ERROR_HANDLER;
+		scmd->request->rq_status = RQ_SCSI_DONE;
+		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
 			
-			rtn = FAILED;
-		}
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd: %p, rtn:%x\n",
-						  __FUNCTION__, scmd, rtn));
-	} else {
-		int temp;
-
-		/*
-		 * we damn well had better never use this code.  there is no
-		 * timeout protection here, since we would end up waiting in
-		 * the actual low level driver, we don't know how to wake it up.
-		 */
-		spin_lock_irqsave(host->host_lock, flags);
-		temp = host->hostt->command(scmd);
-		spin_unlock_irqrestore(host->host_lock, flags);
-
-		scmd->result = temp;
-		/* fall through to code below to examine status. */
+		rtn = FAILED;
 	}
+
+	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: scmd: %p, rtn:%x\n",
+					  __FUNCTION__, scmd, rtn));
 
 	/*
 	 * now examine the actual status codes to see whether the command
diff -Nru a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
--- a/drivers/usb/storage/scsiglue.c	Sun Jun  8 20:31:57 2003
+++ b/drivers/usb/storage/scsiglue.c	Sun Jun  8 20:31:57 2003
@@ -365,24 +365,15 @@
 	.name =				"usb-storage",
 	.proc_name =			"usb-storage",
 	.proc_info =			usb_storage_proc_info,
-	.proc_dir =			NULL,
 	.info =				usb_storage_info,
-	.ioctl =			NULL,
-
-	/* old-style detect and release */
-	.detect =			NULL,
-	.release =			NULL,
 
 	/* command interface -- queued only */
-	.command =			NULL,
 	.queuecommand =			usb_storage_queuecommand,
 
 	/* error and abort handlers */
 	.eh_abort_handler =		usb_storage_command_abort,
 	.eh_device_reset_handler =	usb_storage_device_reset,
 	.eh_bus_reset_handler =		usb_storage_bus_reset,
-	.eh_host_reset_handler =	NULL,
-	.eh_strategy_handler =		NULL,
 
 	/* queue commands only, only one command per LUN */
 	.can_queue =			1,
@@ -391,21 +382,9 @@
 	/* unknown initiator id */
 	.this_id =			-1,
 
-	/* no limit on commands */
-	.max_sectors =			0,
-	
-	/* pre- and post- device scan functions */
-	.slave_alloc =			NULL,
-	.slave_configure =		NULL,
-	.slave_destroy =		NULL,
-
 	/* lots of sg segments can be handled */
 	.sg_tablesize =			SG_ALL,
 
-	/* use 32-bit address space for DMA */
-	.unchecked_isa_dma =		FALSE,
-	.highmem_io =			FALSE,
-
 	/* merge commands... this seems to help performance, but
 	 * periodically someone should test to see which setting is more
 	 * optimal.
@@ -414,9 +393,6 @@
 
 	/* emulated HBA */
 	.emulated =			TRUE,
-
-	/* sorry, no BIOS to help us */
-	.bios_param =			NULL,
 
 	/* module management */
 	.module =			THIS_MODULE
diff -Nru a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h	Sun Jun  8 20:31:57 2003
+++ b/include/scsi/scsi_host.h	Sun Jun  8 20:31:57 2003
@@ -95,24 +95,10 @@
 	 * I/O pressure in the system if there are no other outstanding
 	 * commands.
 	 *
-	 * STATUS: REQUIRED	(for exceptions see below)
+	 * STATUS: REQUIRED
 	 */
 	int (* queuecommand)(struct scsi_cmnd *,
 			     void (*done)(struct scsi_cmnd *));
-
-	/*
-	 * This is used instead of queuecommand if can_queue == 0;
-	 *
-	 * The return value has the following meaning:
-	 * Byte What:
-	 * 0    SCSI status code
-	 * 1    SCSI 1 byte message
-	 * 2    host error return.
-	 * 3    mid level error return
-	 *
-	 * Status: OBSOLETE
-	 */
-	int (* command)(struct scsi_cmnd *);
 
 	/*
 	 * This is an error handling strategy routine.  You don't need to

