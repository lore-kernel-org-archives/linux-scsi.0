From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_cmnd->abort_reason
Date: Sun, 19 Jun 2005 13:40:08 +0200
Message-ID: <20050619114008.GC18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:9132 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262246AbVFSLkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 07:40:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Never used for anything but printing it out in debug routines.

Index: linux-2.6/drivers/scsi/advansys.c
===================================================================
--- linux-2.6.orig/drivers/scsi/advansys.c	2005-06-19 12:00:46.000000000 +0200
+++ linux-2.6/drivers/scsi/advansys.c	2005-06-19 12:03:42.000000000 +0200
@@ -9194,8 +9194,8 @@
         s->sc_data_direction, s->resid);
 
     printk(
-" use_sg %u, sglist_len %u, abort_reason 0x%x\n",
-        s->use_sg, s->sglist_len, s->abort_reason);
+" use_sg %u, sglist_len %u\n",
+        s->use_sg, s->sglist_len);
 
     printk(
 " serial_number 0x%x, retries %d, allowed %d\n",
Index: linux-2.6/drivers/scsi/eata_pio.c
===================================================================
--- linux-2.6.orig/drivers/scsi/eata_pio.c	2005-06-19 12:00:46.000000000 +0200
+++ linux-2.6/drivers/scsi/eata_pio.c	2005-06-19 12:03:42.000000000 +0200
@@ -449,7 +449,7 @@
 {
 	uint loop = HZ;
 
-	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_abort called pid: %ld " "target: %x lun: %x reason %x\n", cmd->pid, cmd->device->id, cmd->device->lun, cmd->abort_reason));
+	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_abort called pid: %ld " "target: %x lun: %x\n", cmd->pid, cmd->device->id, cmd->device->lun));
 
 
 	while (inb(cmd->device->host->base + HA_RAUXSTAT) & HA_ABUSY)
@@ -484,7 +484,7 @@
 	struct scsi_cmnd *sp;
 	struct Scsi_Host *host = cmd->device->host;
 
-	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset called pid:%ld target:" " %x lun: %x reason %x\n", cmd->pid, cmd->device->id, cmd->device->lun, cmd->abort_reason));
+	DBG(DBG_ABNORM, printk(KERN_WARNING "eata_pio_reset called pid:%ld target:" " %x lun: %x\n", cmd->pid, cmd->device->id, cmd->device->lun));
 
 	spin_lock_irq(host->host_lock);
 
Index: linux-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi.c	2005-06-19 12:00:47.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi.c	2005-06-19 12:27:34.000000000 +0200
@@ -717,7 +717,6 @@
 	/*
 	 * Start the timer ticking.
 	 */
-	cmd->abort_reason = 0;
 	cmd->result = 0;
 
 	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_init_cmd_from_req()\n"));
Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2005-06-19 12:00:47.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2005-06-19 12:27:34.000000000 +0200
@@ -1829,7 +1829,6 @@
 	scmd->bufflen			= 0;
 	scmd->request_buffer		= NULL;
 	scmd->request_bufflen		= 0;
-	scmd->abort_reason		= DID_ABORT;
 
 	scmd->cmd_len			= 0;
 
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2005-06-19 12:00:47.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_lib.c	2005-06-19 12:27:59.000000000 +0200
@@ -301,7 +301,6 @@
 {
 	cmd->owner = SCSI_OWNER_MIDLEVEL;
 	cmd->serial_number = 0;
-	cmd->abort_reason = 0;
 
 	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
 
@@ -322,7 +321,6 @@
 	memcpy(cmd->data_cmnd, cmd->cmnd, sizeof(cmd->cmnd));
 	cmd->buffer = cmd->request_buffer;
 	cmd->bufflen = cmd->request_bufflen;
-	cmd->abort_reason = 0;
 
 	return 1;
 }
Index: linux-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_cmnd.h	2005-06-19 12:03:40.000000000 +0200
+++ linux-2.6/include/scsi/scsi_cmnd.h	2005-06-19 12:27:34.000000000 +0200
@@ -79,8 +79,6 @@
 					 * sense info */
 	unsigned short use_sg;	/* Number of pieces of scatter-gather */
 	unsigned short sglist_len;	/* size of malloc'd scatter-gather list */
-	unsigned short abort_reason;	/* If the mid-level code requests an
-					 * abort, this is the reason. */
 	unsigned bufflen;	/* Size of data buffer */
 	void *buffer;		/* Data buffer */
 
