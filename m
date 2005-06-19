From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove scsi_cmnd->owner
Date: Sun, 19 Jun 2005 13:40:52 +0200
Message-ID: <20050619114052.GD18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:10412 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262248AbVFSLky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 07:40:54 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

never checked anywhere

Index: linux-2.6/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi.c	2005-06-19 12:03:42.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi.c	2005-06-19 12:27:27.000000000 +0200
@@ -258,7 +258,6 @@
 		memset(cmd, 0, sizeof(*cmd));
 		cmd->device = dev;
 		cmd->state = SCSI_STATE_UNUSED;
-		cmd->owner = SCSI_OWNER_NOBODY;
 		init_timer(&cmd->eh_timeout);
 		INIT_LIST_HEAD(&cmd->list);
 		spin_lock_irqsave(&dev->list_lock, flags);
@@ -610,7 +609,6 @@
 	 */
 
 	cmd->state = SCSI_STATE_QUEUED;
-	cmd->owner = SCSI_OWNER_LOWLEVEL;
 
 	atomic_inc(&cmd->device->iorequest_cnt);
 
@@ -681,7 +679,6 @@
 {
 	sreq->sr_command = cmd;
 
-	cmd->owner = SCSI_OWNER_MIDLEVEL;
 	cmd->cmd_len = sreq->sr_cmd_len;
 	cmd->use_sg = sreq->sr_use_sg;
 
@@ -766,7 +763,6 @@
 	 */
 	cmd->serial_number = 0;
 	cmd->state = SCSI_STATE_BHQUEUE;
-	cmd->owner = SCSI_OWNER_BH_HANDLER;
 
 	atomic_inc(&cmd->device->iodone_cnt);
 	if (cmd->result)
@@ -887,7 +883,6 @@
 	SCSI_LOG_MLCOMPLETE(4, printk("Notifying upper driver of completion "
 				"for device %d %x\n", sdev->id, cmd->result));
 
-	cmd->owner = SCSI_OWNER_HIGHLEVEL;
 	cmd->state = SCSI_STATE_FINISHED;
 
 	/*
Index: linux-2.6/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_error.c	2005-06-19 12:03:42.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_error.c	2005-06-19 12:27:27.000000000 +0200
@@ -77,7 +77,6 @@
 	/*
 	 * FIXME: Can we stop setting owner and state.
 	 */
-	scmd->owner = SCSI_OWNER_ERROR_HANDLER;
 	scmd->state = SCSI_STATE_FAILED;
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	set_bit(SHOST_RECOVERY, &shost->shost_state);
@@ -451,7 +450,6 @@
 	 */
 	if (del_timer(&scmd->eh_timeout)) {
 		scmd->request->rq_status = RQ_SCSI_DONE;
-		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
 
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s scmd: %p result: %x\n",
 					   __FUNCTION__, scmd, scmd->result));
@@ -484,8 +482,6 @@
 	 * we will use a queued command if possible, otherwise we will
 	 * emulate the queuing and calling of completion function ourselves.
 	 */
-	scmd->owner = SCSI_OWNER_LOWLEVEL;
-
 	if (sdev->scsi_level <= SCSI_2)
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);
@@ -514,7 +510,6 @@
 	 */
 	if (scsi_eh_eflags_chk(scmd, SCSI_EH_REC_TIMEOUT)) {
 		scsi_eh_eflags_clr(scmd,  SCSI_EH_REC_TIMEOUT);
-		scmd->owner = SCSI_OWNER_LOWLEVEL;
 
 		/*
 		 * as far as the low level driver is
@@ -530,8 +525,6 @@
 			shost->hostt->eh_abort_handler(scmd);
 			
 		scmd->request->rq_status = RQ_SCSI_DONE;
-		scmd->owner = SCSI_OWNER_ERROR_HANDLER;
-			
 		rtn = FAILED;
 	}
 
@@ -742,9 +735,6 @@
 	 */
 	if (scmd->serial_number == 0)
 		return SUCCESS;
-
-	scmd->owner = SCSI_OWNER_LOWLEVEL;
-
 	return scmd->device->host->hostt->eh_abort_handler(scmd);
 }
 
@@ -862,10 +852,7 @@
 	if (!scmd->device->host->hostt->eh_device_reset_handler)
 		return FAILED;
 
-	scmd->owner = SCSI_OWNER_LOWLEVEL;
-
 	rtn = scmd->device->host->hostt->eh_device_reset_handler(scmd);
-
 	if (rtn == SUCCESS) {
 		scmd->device->was_reset = 1;
 		scmd->device->expecting_cc_ua = 1;
@@ -1048,7 +1035,6 @@
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Bus RST\n",
 					  __FUNCTION__));
-	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
 	if (!scmd->device->host->hostt->eh_bus_reset_handler)
 		return FAILED;
@@ -1077,7 +1063,6 @@
 
 	SCSI_LOG_ERROR_RECOVERY(3, printk("%s: Snd Host RST\n",
 					  __FUNCTION__));
-	scmd->owner = SCSI_OWNER_LOWLEVEL;
 
 	if (!scmd->device->host->hostt->eh_host_reset_handler)
 		return FAILED;
@@ -1819,8 +1804,7 @@
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
 	scmd->request->rq_status      	= RQ_SCSI_BUSY;
 	scmd->state                   	= SCSI_STATE_INITIALIZING;
-	scmd->owner	     		= SCSI_OWNER_MIDLEVEL;
-    
+
 	memset(&scmd->cmnd, '\0', sizeof(scmd->cmnd));
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
Index: linux-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_lib.c	2005-06-19 12:03:42.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_lib.c	2005-06-19 12:27:27.000000000 +0200
@@ -149,7 +149,6 @@
 	 * Register the fact that we own the thing for now.
 	 */
 	cmd->state = SCSI_STATE_MLQUEUE;
-	cmd->owner = SCSI_OWNER_MIDLEVEL;
 
 	/*
 	 * Decrement the counters, since these commands are no longer
@@ -299,7 +298,6 @@
  */
 static int scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
-	cmd->owner = SCSI_OWNER_MIDLEVEL;
 	cmd->serial_number = 0;
 
 	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
Index: linux-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_priv.h	2005-06-19 12:00:47.000000000 +0200
+++ linux-2.6/drivers/scsi/scsi_priv.h	2005-06-19 12:27:24.000000000 +0200
@@ -13,17 +13,6 @@
 
 
 /*
- * These are the values that the owner field can take.
- * They are used as an indication of who the command belongs to.
- */
-#define SCSI_OWNER_HIGHLEVEL      0x100
-#define SCSI_OWNER_MIDLEVEL       0x101
-#define SCSI_OWNER_LOWLEVEL       0x102
-#define SCSI_OWNER_ERROR_HANDLER  0x103
-#define SCSI_OWNER_BH_HANDLER     0x104
-#define SCSI_OWNER_NOBODY         0x105
-
-/*
  * Magic values for certain scsi structs. Shouldn't ever be used.
  */
 #define SCSI_CMND_MAGIC		0xE25C23A5
Index: linux-2.6/include/scsi/scsi_cmnd.h
===================================================================
--- linux-2.6.orig/include/scsi/scsi_cmnd.h	2005-06-19 12:03:42.000000000 +0200
+++ linux-2.6/include/scsi/scsi_cmnd.h	2005-06-19 12:27:27.000000000 +0200
@@ -32,7 +32,6 @@
 
 	struct scsi_device *device;
 	unsigned short state;
-	unsigned short owner;
 	struct scsi_request *sc_request;
 
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
