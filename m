From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove dead scsi_cmnd members
Date: Sun, 27 Apr 2003 14:50:53 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427145053.A28194@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:2316 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263086AbTD0Mil (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 08:38:41 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

->reset_chain is initialized by the midlayer only used in BusLogic's old EH
code (which is never called and thus can be #if 0'ed out until someone with
the hardware updates it to new EH), ->done_late is never used.


--- 1.17/drivers/scsi/BusLogic.c	Sat Apr 26 10:28:12 2003
+++ edited/drivers/scsi/BusLogic.c	Sun Apr 27 09:35:22 2003
@@ -3213,6 +3213,7 @@
 	    Place CCB back on the Host Adapter's free list.
 	  */
 	  BusLogic_DeallocateCCB(CCB);
+#if 0	/* this needs to be redone different for new EH */
 	  /*
 	    Bus Device Reset CCBs have the Command field non-NULL only when a
 	    Bus Device Reset was requested for a Command that did not have a
@@ -3228,6 +3229,7 @@
 	      Command->scsi_done(Command);
 	      Command = NextCommand;
 	    }
+#endif
 	  /*
 	    Iterate over the CCBs for this Host Adapter performing completion
 	    processing for any CCBs marked as Reset for this Target.
@@ -3948,6 +3950,7 @@
       {
 	Command = CCB->Command;
 	BusLogic_DeallocateCCB(CCB);
+#if 0	/* this needs to be redone different for new EH */
 	while (Command != NULL)
 	  {
 	    SCSI_Command_T *NextCommand = Command->reset_chain;
@@ -3956,6 +3959,7 @@
 	    Command->scsi_done(Command);
 	    Command = NextCommand;
 	  }
+#endif
       }
   for (TargetID = 0; TargetID < HostAdapter->MaxTargetDevices; TargetID++)
     {
@@ -3967,7 +3971,7 @@
   return Result;
 }
 
-
+#if 0	/* old-style EH code references a dead struct scsi_cmnd member */
 /*
   BusLogic_SendBusDeviceReset sends a Bus Device Reset to the Target
   Device associated with Command.
@@ -4204,6 +4208,7 @@
     }
   return SCSI_RESET_PUNT;
 }
+#endif
 
 
 /*
--- 1.105/drivers/scsi/scsi.c	Sat Apr 26 14:36:16 2003
+++ edited/drivers/scsi/scsi.c	Sun Apr 27 09:12:47 2003
@@ -533,7 +534,6 @@
 
 	cmd->request = sreq->sr_request;
 	memcpy(cmd->data_cmnd, sreq->sr_cmnd, sizeof(cmd->data_cmnd));
-	cmd->reset_chain = NULL;
 	cmd->serial_number = 0;
 	cmd->serial_number_at_timeout = 0;
 	cmd->bufflen = sreq->sr_bufflen;
--- 1.75/drivers/scsi/scsi.h	Wed Apr 23 04:06:29 2003
+++ edited/drivers/scsi/scsi.h	Sun Apr 27 10:45:24 2003
@@ -698,7 +472,6 @@
 	unsigned short state;
 	unsigned short owner;
 	Scsi_Request *sc_request;
-	struct scsi_cmnd *reset_chain;
 
 	struct list_head list;  /* scsi_cmnd participates in queue lists */
 
@@ -783,14 +556,6 @@
 
 	unsigned flags;
 
-	/*
-	 * Used to indicate that a command which has timed out also
-	 * completed normally.  Typically the completion function will
-	 * do nothing but set this flag in this instance because the
-	 * timeout handler is already running.
-	 */
-	unsigned done_late:1;
-
 	/* Low-level done function - can be used by low-level driver to point
 	 *        to completion function.  Not used by mid/upper level code. */
 	void (*scsi_done) (struct scsi_cmnd *);
--- 1.48/drivers/scsi/scsi_error.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_error.c	Sun Apr 27 10:46:14 2003
@@ -1674,13 +1653,10 @@
     
 	scmd->scsi_done		= scsi_reset_provider_done_command;
 	scmd->done			= NULL;
-	scmd->reset_chain		= NULL;
-        
 	scmd->buffer			= NULL;
 	scmd->bufflen			= 0;
 	scmd->request_buffer		= NULL;
 	scmd->request_bufflen		= 0;
-
 	scmd->internal_timeout		= NORMAL_TIMEOUT;
 	scmd->abort_reason		= DID_ABORT;
 
--- 1.84/drivers/scsi/scsi_lib.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_lib.c	Sun Apr 27 12:21:36 2003
@@ -271,7 +261,6 @@
 static int scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
 	cmd->owner = SCSI_OWNER_MIDLEVEL;
-	cmd->reset_chain = NULL;
 	cmd->serial_number = 0;
 	cmd->serial_number_at_timeout = 0;
 	cmd->flags = 0;
@@ -296,7 +285,6 @@
 	memcpy(cmd->data_cmnd, cmd->cmnd, sizeof(cmd->cmnd));
 	cmd->buffer = cmd->request_buffer;
 	cmd->bufflen = cmd->request_bufflen;
-	cmd->reset_chain = NULL;
 	cmd->internal_timeout = NORMAL_TIMEOUT;
 	cmd->abort_reason = 0;
 
