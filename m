From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] move scsi_reset_provider to scsi_error.c
Date: Sat, 16 Nov 2002 20:58:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021116205816.A24497@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

it's clearly error-handling specific and allows to mark scsi_new_reset
static


--- 1.61/drivers/scsi/scsi.c	Thu Nov 14 13:19:04 2002
+++ edited/drivers/scsi/scsi.c	Sat Nov 16 19:53:49 2002
@@ -175,11 +175,6 @@
 void scsi_build_commandblocks(Scsi_Device * SDpnt);
 
 /*
- * Private interface into the new error handling code.
- */
-extern int scsi_new_reset(Scsi_Cmnd *SCpnt, unsigned int flag);
-
-/*
  * Function:    scsi_initialize_queue()
  *
  * Purpose:     Selects queue handler function for a device.
@@ -2851,112 +2834,3 @@
 		kfree(SDpnt->inquiry);
         kfree(SDpnt);
 }
-
-/*
- * Function:	scsi_reset_provider_done_command
- *
- * Purpose:	Dummy done routine.
- *
- * Notes:	Some low level drivers will call scsi_done and end up here,
- *		others won't bother.
- *		We don't want the bogus command used for the bus/device
- *		reset to find its way into the mid-layer so we intercept
- *		it here.
- */
-static void
-scsi_reset_provider_done_command(Scsi_Cmnd *SCpnt)
-{
-}
-
-/*
- * Function:	scsi_reset_provider
- *
- * Purpose:	Send requested reset to a bus or device at any phase.
- *
- * Arguments:	device	- device to send reset to
- *		flag - reset type (see scsi.h)
- *
- * Returns:	SUCCESS/FAILURE.
- *
- * Notes:	This is used by the SCSI Generic driver to provide
- *		Bus/Device reset capability.
- */
-int
-scsi_reset_provider(Scsi_Device *dev, int flag)
-{
-	Scsi_Cmnd SC, *SCpnt = &SC;
-        struct request req;
-	int rtn;
-
-        SCpnt->request = &req;
-	memset(&SCpnt->eh_timeout, 0, sizeof(SCpnt->eh_timeout));
-	SCpnt->host                    	= dev->host;
-	SCpnt->device                  	= dev;
-	SCpnt->target                  	= dev->id;
-	SCpnt->lun                     	= dev->lun;
-	SCpnt->channel                 	= dev->channel;
-	SCpnt->request->rq_status      	= RQ_SCSI_BUSY;
-	SCpnt->request->waiting        	= NULL;
-	SCpnt->use_sg                  	= 0;
-	SCpnt->old_use_sg              	= 0;
-	SCpnt->old_cmd_len             	= 0;
-	SCpnt->underflow               	= 0;
-	SCpnt->transfersize            	= 0;
-	SCpnt->resid			= 0;
-	SCpnt->serial_number           	= 0;
-	SCpnt->serial_number_at_timeout	= 0;
-	SCpnt->host_scribble           	= NULL;
-	SCpnt->next                    	= NULL;
-	SCpnt->state                   	= SCSI_STATE_INITIALIZING;
-	SCpnt->owner	     		= SCSI_OWNER_MIDLEVEL;
-    
-	memset(&SCpnt->cmnd, '\0', sizeof(SCpnt->cmnd));
-    
-	SCpnt->scsi_done		= scsi_reset_provider_done_command;
-	SCpnt->done			= NULL;
-	SCpnt->reset_chain		= NULL;
-        
-	SCpnt->buffer			= NULL;
-	SCpnt->bufflen			= 0;
-	SCpnt->request_buffer		= NULL;
-	SCpnt->request_bufflen		= 0;
-
-	SCpnt->internal_timeout		= NORMAL_TIMEOUT;
-	SCpnt->abort_reason		= DID_ABORT;
-
-	SCpnt->cmd_len			= 0;
-
-	SCpnt->sc_data_direction	= SCSI_DATA_UNKNOWN;
-	SCpnt->sc_request		= NULL;
-	SCpnt->sc_magic			= SCSI_CMND_MAGIC;
-
-	/*
-	 * Sometimes the command can get back into the timer chain,
-	 * so use the pid as an identifier.
-	 */
-	SCpnt->pid			= 0;
-
-        rtn = scsi_new_reset(SCpnt, flag);
-
-	scsi_delete_timer(SCpnt);
-	return rtn;
-}
-
-/*
- * Overrides for Emacs so that we follow Linus's tabbing style.
- * Emacs will notice this stuff at the end of the file and automatically
- * adjust the settings for this buffer only.  This must remain at the end
- * of the file.
- * ---------------------------------------------------------------------------
- * Local variables:
- * c-indent-level: 4
- * c-brace-imaginary-offset: 0
- * c-brace-offset: -4
- * c-argdecl-indent: 4
- * c-label-offset: -4
- * c-continued-statement-offset: 4
- * c-continued-brace-offset: 0
- * indent-tabs-mode: nil
- * tab-width: 8
- * End:
- */
===== drivers/scsi/scsi_error.c 1.20 vs edited =====
--- 1.20/drivers/scsi/scsi_error.c	Sat Nov  9 22:32:01 2002
+++ edited/drivers/scsi/scsi_error.c	Sat Nov 16 19:54:08 2002
@@ -1714,7 +1714,7 @@
  * Return value:
  *    SUCCESS/FAILED.
  **/
-int scsi_new_reset(Scsi_Cmnd *scmd, int flag)
+static int scsi_new_reset(Scsi_Cmnd *scmd, int flag)
 {
 	int rtn;
 
@@ -1736,5 +1736,84 @@
 		rtn = FAILED;
 	}
 
+	return rtn;
+}
+
+static void
+scsi_reset_provider_done_command(Scsi_Cmnd *SCpnt)
+{
+}
+
+/*
+ * Function:	scsi_reset_provider
+ *
+ * Purpose:	Send requested reset to a bus or device at any phase.
+ *
+ * Arguments:	device	- device to send reset to
+ *		flag - reset type (see scsi.h)
+ *
+ * Returns:	SUCCESS/FAILURE.
+ *
+ * Notes:	This is used by the SCSI Generic driver to provide
+ *		Bus/Device reset capability.
+ */
+int
+scsi_reset_provider(Scsi_Device *dev, int flag)
+{
+	struct scsi_cmnd SC, *SCpnt = &SC;
+	struct request req;
+	int rtn;
+
+	SCpnt->request = &req;
+	memset(&SCpnt->eh_timeout, 0, sizeof(SCpnt->eh_timeout));
+	SCpnt->host                    	= dev->host;
+	SCpnt->device                  	= dev;
+	SCpnt->target                  	= dev->id;
+	SCpnt->lun                     	= dev->lun;
+	SCpnt->channel                 	= dev->channel;
+	SCpnt->request->rq_status      	= RQ_SCSI_BUSY;
+	SCpnt->request->waiting        	= NULL;
+	SCpnt->use_sg                  	= 0;
+	SCpnt->old_use_sg              	= 0;
+	SCpnt->old_cmd_len             	= 0;
+	SCpnt->underflow               	= 0;
+	SCpnt->transfersize            	= 0;
+	SCpnt->resid			= 0;
+	SCpnt->serial_number           	= 0;
+	SCpnt->serial_number_at_timeout	= 0;
+	SCpnt->host_scribble           	= NULL;
+	SCpnt->next                    	= NULL;
+	SCpnt->state                   	= SCSI_STATE_INITIALIZING;
+	SCpnt->owner	     		= SCSI_OWNER_MIDLEVEL;
+    
+	memset(&SCpnt->cmnd, '\0', sizeof(SCpnt->cmnd));
+    
+	SCpnt->scsi_done		= scsi_reset_provider_done_command;
+	SCpnt->done			= NULL;
+	SCpnt->reset_chain		= NULL;
+        
+	SCpnt->buffer			= NULL;
+	SCpnt->bufflen			= 0;
+	SCpnt->request_buffer		= NULL;
+	SCpnt->request_bufflen		= 0;
+
+	SCpnt->internal_timeout		= NORMAL_TIMEOUT;
+	SCpnt->abort_reason		= DID_ABORT;
+
+	SCpnt->cmd_len			= 0;
+
+	SCpnt->sc_data_direction	= SCSI_DATA_UNKNOWN;
+	SCpnt->sc_request		= NULL;
+	SCpnt->sc_magic			= SCSI_CMND_MAGIC;
+
+	/*
+	 * Sometimes the command can get back into the timer chain,
+	 * so use the pid as an identifier.
+	 */
+	SCpnt->pid			= 0;
+
+	rtn = scsi_new_reset(SCpnt, flag);
+
+	scsi_delete_timer(SCpnt);
 	return rtn;
 }
