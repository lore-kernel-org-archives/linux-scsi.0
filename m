From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Tue, 21 May 2002 19:11:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205212311.g4LNBYo09061@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_-17832539770"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA25045
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2002 16:11:41 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id QAA24908
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2002 16:11:35 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g4LNBYo09061
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2002 19:11:34 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_-17832539770
Content-Type: text/plain; charset=us-ascii

The attached makes the request field in Scsi_Cmnd and Scsi_Request be pointers 
to the block layer request instead of copies of it.  The advantage of this is 
that it makes the scsi interface to the block layer conform much more closely 
to most other block device drivers.  It should also make it quite a lot easier 
to slot in the block layer tag command queueing functions.

The disadvantage is that you now _really_ need to use the scsi request 
interfaces instead of the command based ones (you will get a NULL deref if you 
allocate and use your own commands with no associated requests).  This also 
means that the following fibre drivers need some rework:  cpqfc, gdth, pluto, 
tmscsim.

It works on my system (at least it stays up during a full kernel compile).  
Any comments would be welcome.

After this, I plan to see if I can implement TCQ using the block level generic 
functions.  This would buy us the ability to support request barriers (modulo 
the already discussed edge cases) right down through the SCSI subsystem.

James Bottomley


--==_Exmh_-17832539770
Content-Type: text/plain ; name="scsi-req-2.5.17.diff"; charset=us-ascii
Content-Description: scsi-req-2.5.17.diff
Content-Disposition: attachment; filename="scsi-req-2.5.17.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.582   -> 1.583  
#	drivers/scsi/aha1542.c	1.13    -> 1.14   
#	drivers/scsi/scsi_error.c	1.10    -> 1.11   
#	drivers/scsi/ide-scsi.c	1.35    -> 1.36   
#	drivers/scsi/sun3_scsi.c	1.5     -> 1.6    
#	drivers/scsi/sun3_NCR5380.c	1.2     -> 1.3    
#	   drivers/scsi/sd.c	1.37    -> 1.38   
#	   drivers/scsi/sr.c	1.25    -> 1.26   
#	 drivers/scsi/scsi.h	1.12    -> 1.13   
#	drivers/scsi/u14-34f.c	1.10    -> 1.11   
#	 drivers/scsi/eata.c	1.12    -> 1.13   
#	   drivers/scsi/sg.c	1.15    -> 1.16   
#	 drivers/scsi/osst.c	1.13    -> 1.14   
#	drivers/scsi/scsi_lib.c	1.22    -> 1.23   
#	 drivers/scsi/scsi.c	1.28    -> 1.29   
#	drivers/scsi/scsi_debug.c	1.7     -> 1.8    
#	   drivers/scsi/st.c	1.15    -> 1.16   
#	drivers/scsi/sr_ioctl.c	1.12    -> 1.13   
#	drivers/scsi/constants.c	1.5     -> 1.6    
#	drivers/scsi/scsi_merge.c	1.19    -> 1.20   
#	drivers/scsi/qla1280.c	1.11    -> 1.12   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/05/21	jejb@mulgrave.(none)	1.583
# make Scsi_Cmnd and Scsi_Request.request be a pointer to the
# block layer request instead of a copy.
# 
# Precursor to generic tag queueing work
# --------------------------------------------
#
diff -Nru a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
--- a/drivers/scsi/aha1542.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/aha1542.c	Tue May 21 18:22:18 2002
@@ -1635,14 +1635,14 @@
 		if (HOSTDATA(SCpnt->host)->SCint[i]) {
 			if (HOSTDATA(SCpnt->host)->SCint[i] == SCpnt) {
 				printk(KERN_ERR "Timed out command pending for %s\n",
-				       kdevname(SCpnt->request.rq_dev));
+				       kdevname(SCpnt->request->rq_dev));
 				if (HOSTDATA(SCpnt->host)->mb[i].status) {
 					printk(KERN_ERR "OGMB still full - restarting\n");
 					aha1542_out(SCpnt->host->io_port, &ahacmd, 1);
 				};
 			} else
 				printk(KERN_ERR "Other pending command %s\n",
-				       kdevname(SCpnt->request.rq_dev));
+				       kdevname(SCpnt->request->rq_dev));
 		}
 #endif
 
diff -Nru a/drivers/scsi/constants.c b/drivers/scsi/constants.c
--- a/drivers/scsi/constants.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/constants.c	Tue May 21 18:22:18 2002
@@ -807,13 +807,13 @@
 void print_sense(const char * devclass, Scsi_Cmnd * SCpnt)
 {
 	print_sense_internal(devclass, SCpnt->sense_buffer,
-			     SCpnt->request.rq_dev);
+			     SCpnt->request->rq_dev);
 }
 
 void print_req_sense(const char * devclass, Scsi_Request * SRpnt)
 {
 	print_sense_internal(devclass, SRpnt->sr_sense_buffer,
-			     SRpnt->sr_request.rq_dev);
+			     SRpnt->sr_request->rq_dev);
 }
 
 #if (CONSTANTS & CONST_MSG) 
diff -Nru a/drivers/scsi/eata.c b/drivers/scsi/eata.c
--- a/drivers/scsi/eata.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/eata.c	Tue May 21 18:22:18 2002
@@ -1563,7 +1563,7 @@
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type)) {
       HD(j)->cp_stat[i] = READY;
-      flush_dev(SCpnt->device, SCpnt->request.sector, j, FALSE);
+      flush_dev(SCpnt->device, SCpnt->request->sector, j, FALSE);
       return 0;
       }
 
@@ -1875,11 +1875,11 @@
 
       if (!cpp->din) input_only = FALSE;
 
-      if (SCpnt->request.sector < minsec) minsec = SCpnt->request.sector;
-      if (SCpnt->request.sector > maxsec) maxsec = SCpnt->request.sector;
+      if (SCpnt->request->sector < minsec) minsec = SCpnt->request->sector;
+      if (SCpnt->request->sector > maxsec) maxsec = SCpnt->request->sector;
 
-      sl[n] = SCpnt->request.sector;
-      ioseek += SCpnt->request.nr_sectors;
+      sl[n] = SCpnt->request->sector;
+      ioseek += SCpnt->request->nr_sectors;
 
       if (!n) continue;
 
@@ -1907,7 +1907,7 @@
 
    if (!input_only) for (n = 0; n < n_ready; n++) {
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
-      ll[n] = SCpnt->request.nr_sectors; pl[n] = SCpnt->pid;
+      ll[n] = SCpnt->request->nr_sectors; pl[n] = SCpnt->pid;
 
       if (!n) continue;
 
@@ -1935,7 +1935,7 @@
                 " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
                 (ihdlr ? "ihdlr" : "qcomm"), SCpnt->channel, SCpnt->target,
                 SCpnt->lun, SCpnt->pid, k, flushcount, n_ready,
-                SCpnt->request.sector, SCpnt->request.nr_sectors, cursec,
+                SCpnt->request->sector, SCpnt->request->nr_sectors, cursec,
                 YESNO(s), YESNO(r), YESNO(rev), YESNO(input_only),
                 YESNO(overlap), cpp->din);
          }
@@ -2073,7 +2073,7 @@
 
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type))
-      flush_dev(SCpnt->device, SCpnt->request.sector, j, TRUE);
+      flush_dev(SCpnt->device, SCpnt->request->sector, j, TRUE);
 
    tstatus = status_byte(spp->target_status);
 
diff -Nru a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
--- a/drivers/scsi/ide-scsi.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/ide-scsi.c	Tue May 21 18:22:18 2002
@@ -718,7 +718,7 @@
 {
 	idescsi_scsi_t *scsi = drive->driver_data;
 
-	if (major(cmd->request.rq_dev) == SCSI_GENERIC_MAJOR)
+	if (major(cmd->request->rq_dev) == SCSI_GENERIC_MAJOR)
 		return test_bit(IDESCSI_SG_TRANSFORM, &scsi->transform);
 	return test_bit(IDESCSI_TRANSFORM, &scsi->transform);
 }
diff -Nru a/drivers/scsi/osst.c b/drivers/scsi/osst.c
--- a/drivers/scsi/osst.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/osst.c	Tue May 21 18:22:18 2002
@@ -271,7 +271,7 @@
 /* Wakeup from interrupt */
 static void osst_sleep_done (Scsi_Cmnd * SCpnt)
 {
-	unsigned int dev = TAPE_NR(SCpnt->request.rq_dev);
+	unsigned int dev = TAPE_NR(SCpnt->request->rq_dev);
 	OS_Scsi_Tape * STp;
 
 	if (os_scsi_tapes && (STp = os_scsi_tapes[dev])) {
@@ -286,13 +286,13 @@
 		}
 		else
 			(STp->buffer)->midlevel_result = SCpnt->result;
-		SCpnt->request.rq_status = RQ_SCSI_DONE;
+		SCpnt->request->rq_status = RQ_SCSI_DONE;
 		(STp->buffer)->last_SRpnt = SCpnt->sc_request;
 
 #if DEBUG
 		STp->write_pending = 0;
 #endif
-		complete(SCpnt->request.waiting);
+		complete(SCpnt->request->waiting);
 	}
 #if DEBUG
 	else if (debugging)
@@ -314,7 +314,7 @@
 #endif
 	if (SRpnt == NULL) {
 		if ((SRpnt = scsi_allocate_request(STp->device)) == NULL) {
-			printk(KERN_ERR "osst%d:E: Can't get SCSI request.\n", TAPE_NR(STp->devt));
+			printk(KERN_ERR "osst%d:E: Can't get SCSI request->\n", TAPE_NR(STp->devt));
 			if (signal_pending(current))
 				(STp->buffer)->syscall_result = (-EINTR);
 			else
@@ -337,15 +337,15 @@
 		bp = (STp->buffer)->b_data;
 	SRpnt->sr_data_direction = direction;
 	SRpnt->sr_cmd_len = 0;
-	SRpnt->sr_request.waiting = &(STp->wait);
-	SRpnt->sr_request.rq_status = RQ_SCSI_BUSY;
-	SRpnt->sr_request.rq_dev = STp->devt;
+	SRpnt->sr_request->waiting = &(STp->wait);
+	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
+	SRpnt->sr_request->rq_dev = STp->devt;
 
 	scsi_do_req(SRpnt, (void *)cmd, bp, bytes, osst_sleep_done, timeout, retries);
 
 	if (do_wait) {
-		wait_for_completion(SRpnt->sr_request.waiting);
-		SRpnt->sr_request.waiting = NULL;
+		wait_for_completion(SRpnt->sr_request->waiting);
+		SRpnt->sr_request->waiting = NULL;
 		STp->buffer->syscall_result = osst_chk_result(STp, SRpnt);
 #ifdef OSST_INJECT_ERRORS
 		if (STp->buffer->syscall_result == 0 &&
@@ -378,7 +378,7 @@
 		STp->nbr_finished++;
 #endif
 	wait_for_completion(&(STp->wait));
-	(STp->buffer)->last_SRpnt->sr_request.waiting = NULL;
+	(STp->buffer)->last_SRpnt->sr_request->waiting = NULL;
 
 	STp->buffer->syscall_result = osst_chk_result(STp, STp->buffer->last_SRpnt);
 
diff -Nru a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
--- a/drivers/scsi/qla1280.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/qla1280.c	Tue May 21 18:22:18 2002
@@ -4236,7 +4236,7 @@
 				/* Set transfer direction (READ and WRITE) */
 				/* Linux doesn't tell us                   */
 				/*
-				 * For block devices, cmd->request.cmd has the operation
+				 * For block devices, cmd->request->cmd has the operation
 				 * For character devices, this isn't always set properly, so
 				 * we need to check data_cmnd[0].  This catches the conditions
 				 * for st.c, but not sg. Generic commands are pass down to us.
@@ -6241,7 +6241,7 @@
 	       cmd->tag, cmd->flags, cmd->transfersize);
 	printk("  Pid=%li, SP=0x%p\n", cmd->pid, CMD_SP(cmd));
 	printk(" underflow size = 0x%x, direction=0x%x, req.cmd=0x%x \n",
-	       cmd->underflow, sp->dir, cmd->request.cmd);
+	       cmd->underflow, sp->dir, cmd->request->cmd);
 }
 
 /**************************************************************************
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/scsi.c	Tue May 21 18:22:18 2002
@@ -256,7 +256,7 @@
 {
 	struct request *req;
 
-	req = &SCpnt->request;
+	req = SCpnt->request;
 	req->rq_status = RQ_SCSI_DONE;	/* Busy, but indicate request done */
 
 	if (req->waiting)
@@ -297,17 +297,19 @@
 Scsi_Request *scsi_allocate_request(Scsi_Device * device)
 {
   	Scsi_Request *SRpnt = NULL;
+        const int offset = ALIGN(sizeof(Scsi_Request), 4);
+        const int size = offset + sizeof(struct request);
   
   	if (!device)
   		panic("No device passed to scsi_allocate_request().\n");
   
-	SRpnt = (Scsi_Request *) kmalloc(sizeof(Scsi_Request), GFP_ATOMIC);
+        SRpnt = (Scsi_Request *) kmalloc(size, GFP_ATOMIC);
 	if( SRpnt == NULL )
 	{
 		return NULL;
 	}
-
-	memset(SRpnt, 0, sizeof(Scsi_Request));
+	memset(SRpnt, 0, size);
+        SRpnt->sr_request = (struct request *)(((char *)SRpnt) + offset);
 	SRpnt->sr_device = device;
 	SRpnt->sr_host = device->host;
 	SRpnt->sr_magic = SCSI_REQ_MAGIC;
@@ -435,7 +437,7 @@
 			 * Now we can check for a free command block for this device.
 			 */
 			for (SCpnt = device->device_queue; SCpnt; SCpnt = SCpnt->next) {
-				if (SCpnt->request.rq_status == RQ_INACTIVE)
+				if (SCpnt->request == NULL)
 					break;
 			}
 		}
@@ -504,9 +506,7 @@
 		}
 	}
 
-	SCpnt->request.rq_status = RQ_SCSI_BUSY;
-	SCpnt->request.waiting = NULL;	/* And no one is waiting for this
-					 * to complete */
+	SCpnt->request = NULL;
 	atomic_inc(&SCpnt->host->host_active);
 	atomic_inc(&SCpnt->device->device_active);
 
@@ -549,7 +549,7 @@
 
         SDpnt = SCpnt->device;
 
-	SCpnt->request.rq_status = RQ_INACTIVE;
+	SCpnt->request = NULL;
 	SCpnt->state = SCSI_STATE_UNUSED;
 	SCpnt->owner = SCSI_OWNER_NOBODY;
 	atomic_dec(&SCpnt->host->host_active);
@@ -772,13 +772,13 @@
 	DECLARE_COMPLETION(wait);
 	request_queue_t *q = &SRpnt->sr_device->request_queue;
 	
-	SRpnt->sr_request.waiting = &wait;
-	SRpnt->sr_request.rq_status = RQ_SCSI_BUSY;
+	SRpnt->sr_request->waiting = &wait;
+	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
 	scsi_do_req (SRpnt, (void *) cmnd,
 		buffer, bufflen, scsi_wait_done, timeout, retries);
 	generic_unplug_device(q);
 	wait_for_completion(&wait);
-	SRpnt->sr_request.waiting = NULL;
+	SRpnt->sr_request->waiting = NULL;
 	if( SRpnt->sr_command != NULL )
 	{
 		scsi_release_command(SRpnt->sr_command);
@@ -929,8 +929,7 @@
 	SCpnt->cmd_len = SRpnt->sr_cmd_len;
 	SCpnt->use_sg = SRpnt->sr_use_sg;
 
-	memcpy((void *) &SCpnt->request, (const void *) &SRpnt->sr_request,
-	       sizeof(SRpnt->sr_request));
+        SCpnt->request = SRpnt->sr_request;
 	memcpy((void *) SCpnt->data_cmnd, (const void *) SRpnt->sr_cmnd, 
 	       sizeof(SCpnt->data_cmnd));
 	SCpnt->reset_chain = NULL;
@@ -1488,7 +1487,7 @@
 		SCpnt->target = SDpnt->id;
 		SCpnt->lun = SDpnt->lun;
 		SCpnt->channel = SDpnt->channel;
-		SCpnt->request.rq_status = RQ_INACTIVE;
+		SCpnt->request = NULL;
 		SCpnt->use_sg = 0;
 		SCpnt->old_use_sg = 0;
 		SCpnt->old_cmd_len = 0;
@@ -2060,16 +2059,16 @@
 			     SCpnt = SCpnt->next) {
 				online_status = SDpnt->online;
 				SDpnt->online = FALSE;
-				if (SCpnt->request.rq_status != RQ_INACTIVE) {
+				if (SCpnt->request && SCpnt->request->rq_status != RQ_INACTIVE) {
 					printk(KERN_ERR "SCSI device not inactive - rq_status=%d, target=%d, pid=%ld, state=%d, owner=%d.\n",
-					       SCpnt->request.rq_status, SCpnt->target, SCpnt->pid,
+					       SCpnt->request->rq_status, SCpnt->target, SCpnt->pid,
 					     SCpnt->state, SCpnt->owner);
 					for (SDpnt1 = shpnt->host_queue; SDpnt1;
 					     SDpnt1 = SDpnt1->next) {
 						for (SCpnt = SDpnt1->device_queue; SCpnt;
 						     SCpnt = SCpnt->next)
-							if (SCpnt->request.rq_status == RQ_SCSI_DISCONNECTING)
-								SCpnt->request.rq_status = RQ_INACTIVE;
+							if (SCpnt->request->rq_status == RQ_SCSI_DISCONNECTING)
+								SCpnt->request->rq_status = RQ_INACTIVE;
 					}
 					SDpnt->online = online_status;
 					printk(KERN_ERR "Device busy???\n");
@@ -2080,7 +2079,8 @@
 				 * continue on.
 				 */
 				SCpnt->state = SCSI_STATE_DISCONNECTING;
-				SCpnt->request.rq_status = RQ_SCSI_DISCONNECTING;	/* Mark as busy */
+                                if(SCpnt->request)
+                                        SCpnt->request->rq_status = RQ_SCSI_DISCONNECTING;	/* Mark as busy */
 			}
 		}
 	}
@@ -2390,11 +2390,11 @@
 				       SCpnt->target,
 				       SCpnt->lun,
 
-				       kdevname(SCpnt->request.rq_dev),
-				       SCpnt->request.sector,
-				       SCpnt->request.nr_sectors,
-				       (long)SCpnt->request.current_nr_sectors,
-				       SCpnt->request.rq_status,
+				       kdevname(SCpnt->request->rq_dev),
+				       SCpnt->request->sector,
+				       SCpnt->request->nr_sectors,
+				       (long)SCpnt->request->current_nr_sectors,
+				       SCpnt->request->rq_status,
 				       SCpnt->use_sg,
 
 				       SCpnt->retries,
@@ -2711,16 +2711,18 @@
 scsi_reset_provider(Scsi_Device *dev, int flag)
 {
 	Scsi_Cmnd SC, *SCpnt = &SC;
+        struct request req;
 	int rtn;
 
+        SCpnt->request = &req;
 	memset(&SCpnt->eh_timeout, 0, sizeof(SCpnt->eh_timeout));
 	SCpnt->host                    	= dev->host;
 	SCpnt->device                  	= dev;
 	SCpnt->target                  	= dev->id;
 	SCpnt->lun                     	= dev->lun;
 	SCpnt->channel                 	= dev->channel;
-	SCpnt->request.rq_status       	= RQ_SCSI_BUSY;
-	SCpnt->request.waiting        	= NULL;
+	SCpnt->request->rq_status      	= RQ_SCSI_BUSY;
+	SCpnt->request->waiting        	= NULL;
 	SCpnt->use_sg                  	= 0;
 	SCpnt->old_use_sg              	= 0;
 	SCpnt->old_cmd_len             	= 0;
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/scsi.h	Tue May 21 18:22:18 2002
@@ -656,7 +656,7 @@
 	struct Scsi_Host *sr_host;
 	Scsi_Device *sr_device;
 	Scsi_Cmnd *sr_command;
-	struct request sr_request;	/* A copy of the command we are
+	struct request *sr_request;	/* A copy of the command we are
 				   working on */
 	unsigned sr_bufflen;	/* Size of data buffer */
 	void *sr_buffer;		/* Data buffer */
@@ -767,8 +767,8 @@
 				   transferred less actual number
 				   transferred (0 if not supported) */
 
-	struct request request;	/* A copy of the command we are
-				   working on */
+	struct request *request;	/* The command we are
+				   	   working on */
 
 	unsigned char sense_buffer[SCSI_SENSE_BUFFERSIZE];		/* obtained by REQUEST SENSE
 						 * when CHECK CONDITION is
diff -Nru a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
--- a/drivers/scsi/scsi_debug.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/scsi_debug.c	Tue May 21 18:22:18 2002
@@ -695,7 +695,7 @@
 	{
 		int delay = SCSI_SETUP_LATENCY;
 
-		delay += SCpnt->request.nr_sectors * SCSI_DATARATE;
+		delay += SCpnt->request->nr_sectors * SCSI_DATARATE;
 		if (delay)
 			usleep(delay);
 	}
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/scsi_error.c	Tue May 21 18:22:18 2002
@@ -320,7 +320,7 @@
 		return;
 	}
 
-	SCpnt->request.rq_status = RQ_SCSI_DONE;
+	SCpnt->request->rq_status = RQ_SCSI_DONE;
 
 	SCpnt->owner = SCSI_OWNER_ERROR_HANDLER;
 	SCpnt->eh_state = SUCCESS;
@@ -347,7 +347,7 @@
 STATIC
 void scsi_eh_action_done(Scsi_Cmnd * SCpnt, int answer)
 {
-	SCpnt->request.rq_status = RQ_SCSI_DONE;
+	SCpnt->request->rq_status = RQ_SCSI_DONE;
 
 	SCpnt->owner = SCSI_OWNER_ERROR_HANDLER;
 	SCpnt->eh_state = (answer ? SUCCESS : FAILED);
@@ -602,7 +602,7 @@
 		 * Set up the semaphore so we wait for the command to complete.
 		 */
 		SCpnt->host->eh_action = &sem;
-		SCpnt->request.rq_status = RQ_SCSI_BUSY;
+		SCpnt->request->rq_status = RQ_SCSI_BUSY;
 
 		spin_lock_irqsave(SCpnt->host->host_lock, flags);
 		host->hostt->queuecommand(SCpnt, scsi_eh_done);
@@ -634,7 +634,7 @@
 				SCpnt->host->hostt->eh_abort_handler(SCpnt);
 			spin_unlock_irqrestore(SCpnt->host->host_lock, flags);
 			
-			SCpnt->request.rq_status = RQ_SCSI_DONE;
+			SCpnt->request->rq_status = RQ_SCSI_DONE;
 			SCpnt->owner = SCSI_OWNER_ERROR_HANDLER;
 			
 			SCpnt->eh_state = FAILED;
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/scsi_lib.c	Tue May 21 18:22:18 2002
@@ -79,9 +79,6 @@
 	rq->flags = REQ_SPECIAL | REQ_BARRIER;
 
 	rq->special = data;
-	rq->q = NULL;
-	rq->bio = rq->biotail = NULL;
-	rq->nr_phys_segments = 0;
 
 	/*
 	 * We have the option of inserting the head or the tail of the queue.
@@ -120,7 +117,7 @@
 {
 	request_queue_t *q = &SCpnt->device->request_queue;
 
-	__scsi_insert_special(q, &SCpnt->request, SCpnt, at_head);
+	__scsi_insert_special(q, SCpnt->request, SCpnt, at_head);
 	return 0;
 }
 
@@ -148,7 +145,7 @@
 {
 	request_queue_t *q = &SRpnt->sr_device->request_queue;
 
-	__scsi_insert_special(q, &SRpnt->sr_request, SRpnt, at_head);
+	__scsi_insert_special(q, SRpnt->sr_request, SRpnt, at_head);
 	return 0;
 }
 
@@ -259,8 +256,8 @@
 		 * in which case we need to request the blocks that come after
 		 * the bad sector.
 		 */
-		SCpnt->request.special = (void *) SCpnt;
-		_elv_add_request(q, &SCpnt->request, 0, 0);
+		SCpnt->request->special = (void *) SCpnt;
+		_elv_add_request(q, SCpnt->request, 0, 0);
 	}
 
 	/*
@@ -356,15 +353,18 @@
 				     int frequeue)
 {
 	request_queue_t *q = &SCpnt->device->request_queue;
-	struct request *req = &SCpnt->request;
+	struct request *req = SCpnt->request;
+	int flags;
 
 	ASSERT_LOCK(q->queue_lock, 0);
 
+	spin_lock_irqsave(q->queue_lock, flags);
 	/*
 	 * If there are blocks left over at the end, set up the command
 	 * to queue the remainder of them.
 	 */
 	if (end_that_request_first(req, uptodate, sectors)) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
 		if (!requeue)
 			return SCpnt;
 
@@ -376,15 +376,12 @@
 		return SCpnt;
 	}
 
-	/*
-	 * This request is done.  If there is someone blocked waiting for this
-	 * request, wake them up.
-	 */
-	if (req->waiting)
-		complete(req->waiting);
-
 	add_blkdev_randomness(major(req->rq_dev));
 
+	end_that_request_last(req);
+
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
 	/*
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
@@ -441,7 +438,7 @@
  */
 static void scsi_release_buffers(Scsi_Cmnd * SCpnt)
 {
-	struct request *req = &SCpnt->request;
+	struct request *req = SCpnt->request;
 
 	ASSERT_LOCK(SCpnt->host->host_lock, 0);
 
@@ -491,7 +488,7 @@
 	int result = SCpnt->result;
 	int this_count = SCpnt->bufflen >> 9;
 	request_queue_t *q = &SCpnt->device->request_queue;
-	struct request *req = &SCpnt->request;
+	struct request *req = SCpnt->request;
 
 	/*
 	 * We must do one of several things here:
@@ -675,7 +672,7 @@
 	if (result) {
 		struct Scsi_Device_Template *STpnt;
 
-		STpnt = scsi_get_request_dev(&SCpnt->request);
+		STpnt = scsi_get_request_dev(SCpnt->request);
 		printk("SCSI %s error : host %d channel %d id %d lun %d return code = %x\n",
 		       (STpnt ? STpnt->name : "device"),
 		       SCpnt->device->host->host_no,
@@ -868,7 +865,7 @@
 		 * the remainder of a partially fulfilled request that can 
 		 * come up when there is a medium error.  We have to treat
 		 * these two cases differently.  We differentiate by looking
-		 * at request.cmd, as this tells us the real story.
+		 * at request->cmd, as this tells us the real story.
 		 */
 		if (req->flags & REQ_SPECIAL) {
 			STpnt = NULL;
@@ -904,6 +901,9 @@
 			 */
 			if (!SCpnt)
 				break;
+
+			/* pull a tag out of the request if we have one */
+			SCpnt->tag = req->tag;
 		} else {
 			blk_dump_rq_flags(req, "SCSI bad req");
 			break;
@@ -926,16 +926,8 @@
 		 */
 		blkdev_dequeue_request(req);
 
-		if (req != &SCpnt->request && req != &SRpnt->sr_request ) {
-			memcpy(&SCpnt->request, req, sizeof(struct request));
+		SCpnt->request = req;
 
-			/*
-			 * We have copied the data out of the request block -
-			 * it is now in a field in SCpnt.  Release the request
-			 * block.
-			 */
-			blkdev_release_request(req);
-		}
 		/*
 		 * Now it is finally safe to release the lock.  We are
 		 * not going to noodle the request list until this
@@ -945,7 +937,7 @@
 		req = NULL;
 		spin_unlock_irq(q->queue_lock);
 
-		if (SCpnt->request.flags & REQ_CMD) {
+		if (SCpnt->request->flags & REQ_CMD) {
 			/*
 			 * This will do a couple of things:
 			 *  1) Fill in the actual SCSI command.
@@ -959,7 +951,7 @@
 			 * request to be rejected immediately.
 			 */
 			if (STpnt == NULL)
-				STpnt = scsi_get_request_dev(&SCpnt->request);
+				STpnt = scsi_get_request_dev(SCpnt->request);
 
 			/* 
 			 * This sets up the scatter-gather table (allocating if
@@ -973,9 +965,9 @@
 					SDpnt->starved = 1;
 					SHpnt->some_device_starved = 1;
 				}
-				SCpnt->request.special = SCpnt;
-				SCpnt->request.flags |= REQ_SPECIAL;
-				_elv_add_request(q, &SCpnt->request, 0, 0);
+				SCpnt->request->special = SCpnt;
+				SCpnt->request->flags |= REQ_SPECIAL;
+				_elv_add_request(q, SCpnt->request, 0, 0);
 				break;
 			}
 
@@ -985,7 +977,7 @@
 			if (!STpnt->init_command(SCpnt)) {
 				scsi_release_buffers(SCpnt);
 				SCpnt = __scsi_end_request(SCpnt, 0, 
-							   SCpnt->request.nr_sectors, 0, 0);
+							   SCpnt->request->nr_sectors, 0, 0);
 				if( SCpnt != NULL )
 				{
 					panic("Should not have leftover blocks\n");
diff -Nru a/drivers/scsi/scsi_merge.c b/drivers/scsi/scsi_merge.c
--- a/drivers/scsi/scsi_merge.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/scsi_merge.c	Tue May 21 18:22:18 2002
@@ -58,7 +58,7 @@
  */
 int scsi_init_io(Scsi_Cmnd *SCpnt)
 {
-	struct request     *req = &SCpnt->request;
+	struct request     *req = SCpnt->request;
 	struct scatterlist *sgpnt;
 	int count, gfp_mask;
 
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/sd.c	Tue May 21 18:22:18 2002
@@ -324,13 +324,13 @@
 	/*
 	 * don't support specials for nwo
 	 */
-	if (!(SCpnt->request.flags & REQ_CMD))
+	if (!(SCpnt->request->flags & REQ_CMD))
 		return 0;
 
-	part_nr = SD_PARTITION(SCpnt->request.rq_dev);
-	dsk_nr = DEVICE_NR(SCpnt->request.rq_dev);
+	part_nr = SD_PARTITION(SCpnt->request->rq_dev);
+	dsk_nr = DEVICE_NR(SCpnt->request->rq_dev);
 
-	block = SCpnt->request.sector;
+	block = SCpnt->request->sector;
 	this_count = SCpnt->request_bufflen >> 9;
 
 	SCSI_LOG_HLQUEUE(1, printk("sd_command_init: dsk_nr=%d, block=%d, "
@@ -341,9 +341,9 @@
 	/* >>>>> this change is not in the lk 2.5 series */
 	if (part_nr >= (sd_template.dev_max << 4) || (part_nr & 0xf) ||
 	    !sdp || !sdp->online ||
- 	    block + SCpnt->request.nr_sectors > sd[part_nr].nr_sects) {
+ 	    block + SCpnt->request->nr_sectors > sd[part_nr].nr_sects) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", 
-				 SCpnt->request.nr_sectors));
+				 SCpnt->request->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
@@ -372,7 +372,7 @@
 	 * for this.
 	 */
 	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (SCpnt->request.nr_sectors & 1)) {
+		if ((block & 1) || (SCpnt->request->nr_sectors & 1)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -381,7 +381,7 @@
 		}
 	}
 	if (sdp->sector_size == 2048) {
-		if ((block & 3) || (SCpnt->request.nr_sectors & 3)) {
+		if ((block & 3) || (SCpnt->request->nr_sectors & 3)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -390,7 +390,7 @@
 		}
 	}
 	if (sdp->sector_size == 4096) {
-		if ((block & 7) || (SCpnt->request.nr_sectors & 7)) {
+		if ((block & 7) || (SCpnt->request->nr_sectors & 7)) {
 			printk(KERN_ERR "sd: Bad block number requested");
 			return 0;
 		} else {
@@ -398,25 +398,25 @@
 			this_count = this_count >> 3;
 		}
 	}
-	if (rq_data_dir(&SCpnt->request) == WRITE) {
+	if (rq_data_dir(SCpnt->request) == WRITE) {
 		if (!sdp->writeable) {
 			return 0;
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
-	} else if (rq_data_dir(&SCpnt->request) == READ) {
+	} else if (rq_data_dir(SCpnt->request) == READ) {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = SCSI_DATA_READ;
 	} else {
 		printk(KERN_ERR "sd: Unknown command %lx\n", 
-		       SCpnt->request.flags);
-/* overkill 	panic("Unknown sd command %lx\n", SCpnt->request.flags); */
+		       SCpnt->request->flags);
+/* overkill 	panic("Unknown sd command %lx\n", SCpnt->request->flags); */
 		return 0;
 	}
 
 	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n", 
-		nbuff, (rq_data_dir(&SCpnt->request) == WRITE) ? 
-		"writing" : "reading", this_count, SCpnt->request.nr_sectors));
+		nbuff, (rq_data_dir(SCpnt->request) == WRITE) ? 
+		"writing" : "reading", this_count, SCpnt->request->nr_sectors));
 
 	SCpnt->cmnd[1] = (SCpnt->device->scsi_level <= SCSI_2) ?
 			 ((SCpnt->lun << 5) & 0xe0) : 0;
@@ -662,7 +662,7 @@
 #if CONFIG_SCSI_LOGGING
 	char nbuff[6];
 
-	SCSI_LOG_HLCOMPLETE(1, sd_dskname(DEVICE_NR(SCpnt->request.rq_dev), 
+	SCSI_LOG_HLCOMPLETE(1, sd_dskname(DEVICE_NR(SCpnt->request->rq_dev), 
 			    nbuff));
 	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: res=0x%x\n", 
 				      nbuff, result));
@@ -688,8 +688,8 @@
 			(SCpnt->sense_buffer[4] << 16) |
 			(SCpnt->sense_buffer[5] << 8) |
 			SCpnt->sense_buffer[6];
-			if (SCpnt->request.bio != NULL)
-				block_sectors = bio_sectors(SCpnt->request.bio);
+			if (SCpnt->request->bio != NULL)
+				block_sectors = bio_sectors(SCpnt->request->bio);
 			switch (SCpnt->device->sector_size) {
 			case 1024:
 				error_sector <<= 1;
@@ -714,7 +714,7 @@
 			}
 
 			error_sector &= ~(block_sectors - 1);
-			good_sectors = error_sector - SCpnt->request.sector;
+			good_sectors = error_sector - SCpnt->request->sector;
 			if (good_sectors < 0 || good_sectors >= this_count)
 				good_sectors = 0;
 			break;
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/sg.c	Tue May 21 18:22:18 2002
@@ -695,7 +695,7 @@
 
     srp->my_cmdp = SRpnt;
     q = &SRpnt->sr_device->request_queue;
-    SRpnt->sr_request.rq_dev = sdp->i_rdev;
+    SRpnt->sr_request->rq_dev = sdp->i_rdev;
     SRpnt->sr_sense_buffer[0] = 0;
     SRpnt->sr_cmd_len = hp->cmd_len;
     if (! (hp->flags & SG_FLAG_LUN_INHIBIT)) {
@@ -1222,7 +1222,7 @@
     SRpnt->sr_bufflen = 0;
     SRpnt->sr_buffer = NULL;
     SRpnt->sr_underflow = 0;
-    SRpnt->sr_request.rq_dev = mk_kdev(0, 0);  /* "sg" _disowns_ request blk */
+    SRpnt->sr_request->rq_dev = mk_kdev(0, 0);  /* "sg" _disowns_ request blk */
 
     srp->my_cmdp = NULL;
     srp->done = 1;
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/sr.c	Tue May 21 18:22:18 2002
@@ -196,11 +196,11 @@
 	int this_count = SCpnt->bufflen >> 9;
 	int good_sectors = (result == 0 ? this_count : 0);
 	int block_sectors = 0;
-	int device_nr = DEVICE_NR(SCpnt->request.rq_dev);
+	int device_nr = DEVICE_NR(SCpnt->request->rq_dev);
 	Scsi_CD *SCp = &scsi_CDs[device_nr];
 
 #ifdef DEBUG
-	printk("sr.c done: %x %p\n", result, SCpnt->request.bh->b_data);
+	printk("sr.c done: %x %p\n", result, SCpnt->request->bh->b_data);
 #endif
 	/*
 	   Handle MEDIUM ERRORs or VOLUME OVERFLOWs that indicate partial success.
@@ -218,14 +218,14 @@
 		(SCpnt->sense_buffer[4] << 16) |
 		(SCpnt->sense_buffer[5] << 8) |
 		SCpnt->sense_buffer[6];
-		if (SCpnt->request.bio != NULL)
-			block_sectors = bio_sectors(SCpnt->request.bio);
+		if (SCpnt->request->bio != NULL)
+			block_sectors = bio_sectors(SCpnt->request->bio);
 		if (block_sectors < 4)
 			block_sectors = 4;
 		if (SCp->device->sector_size == 2048)
 			error_sector <<= 2;
 		error_sector &= ~(block_sectors - 1);
-		good_sectors = error_sector - SCpnt->request.sector;
+		good_sectors = error_sector - SCpnt->request->sector;
 		if (good_sectors < 0 || good_sectors >= this_count)
 			good_sectors = 0;
 		/*
@@ -265,14 +265,14 @@
 	int dev, devm, block=0, this_count, s_size;
 	Scsi_CD *SCp;
 
-	devm = minor(SCpnt->request.rq_dev);
-	dev = DEVICE_NR(SCpnt->request.rq_dev);
+	devm = minor(SCpnt->request->rq_dev);
+	dev = DEVICE_NR(SCpnt->request->rq_dev);
 	SCp = &scsi_CDs[dev];
 
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %d, block = %d\n", devm, block));
 
 	if (dev >= sr_template.nr_dev || !SCp->device || !SCp->device->online) {
-		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", SCpnt->request.nr_sectors));
+		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", SCpnt->request->nr_sectors));
 		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
@@ -285,8 +285,8 @@
 		return 0;
 	}
 
-	if (!(SCpnt->request.flags & REQ_CMD)) {
-		blk_dump_rq_flags(&SCpnt->request, "sr unsup command");
+	if (!(SCpnt->request->flags & REQ_CMD)) {
+		blk_dump_rq_flags(SCpnt->request, "sr unsup command");
 		return 0;
 	}
 
@@ -307,23 +307,23 @@
 		return 0;
 	}
 
-	if (rq_data_dir(&SCpnt->request) == WRITE) {
+	if (rq_data_dir(SCpnt->request) == WRITE) {
 		if (!SCp->device->writeable)
 			return 0;
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = SCSI_DATA_WRITE;
-	} else if (rq_data_dir(&SCpnt->request) == READ) {
+	} else if (rq_data_dir(SCpnt->request) == READ) {
 		SCpnt->cmnd[0] = READ_10;
 		SCpnt->sc_data_direction = SCSI_DATA_READ;
 	} else {
-		blk_dump_rq_flags(&SCpnt->request, "Unknown sr command");
+		blk_dump_rq_flags(SCpnt->request, "Unknown sr command");
 		return 0;
 	}
 
 	/*
 	 * request doesn't start on hw block boundary, add scatter pads
 	 */
-	if ((SCpnt->request.sector % (s_size >> 9)) || (SCpnt->request_bufflen % s_size)) {
+	if ((SCpnt->request->sector % (s_size >> 9)) || (SCpnt->request_bufflen % s_size)) {
 		printk("sr: unaligned transfer\n");
 		return 0;
 	}
@@ -333,13 +333,13 @@
 
 	SCSI_LOG_HLQUEUE(2, printk("sr%d : %s %d/%ld 512 byte blocks.\n",
                                    devm,
-		   (rq_data_dir(&SCpnt->request) == WRITE) ? "writing" : "reading",
-				 this_count, SCpnt->request.nr_sectors));
+		   (rq_data_dir(SCpnt->request) == WRITE) ? "writing" : "reading",
+				 this_count, SCpnt->request->nr_sectors));
 
 	SCpnt->cmnd[1] = (SCpnt->device->scsi_level <= SCSI_2) ?
 			 ((SCpnt->lun << 5) & 0xe0) : 0;
 
-	block = SCpnt->request.sector / (s_size >> 9);
+	block = SCpnt->request->sector / (s_size >> 9);
 
 	if (this_count > 0xffff)
 		this_count = 0xffff;
@@ -495,7 +495,7 @@
 		cmd[1] = (SCp->device->scsi_level <= SCSI_2) ?
 			 ((SCp->device->lun << 5) & 0xe0) : 0;
 		memset((void *) &cmd[2], 0, 8);
-		SRpnt->sr_request.rq_status = RQ_SCSI_BUSY;	/* Mark as really busy */
+		SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;	/* Mark as really busy */
 		SRpnt->sr_cmd_len = 0;
 
 		memset(buffer, 0, 8);
diff -Nru a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
--- a/drivers/scsi/sr_ioctl.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/sr_ioctl.c	Tue May 21 18:22:18 2002
@@ -92,7 +92,7 @@
 	SRpnt->sr_data_direction = readwrite;
 
 	/* use ISA DMA buffer if necessary */
-	SRpnt->sr_request.buffer = buffer;
+	SRpnt->sr_request->buffer = buffer;
 	if (buffer && SRpnt->sr_host->unchecked_isa_dma &&
 	    (virt_to_phys(buffer) + buflength - 1 > ISA_DMA_THRESHOLD)) {
 		bounce_buffer = (char *) kmalloc(buflength, GFP_DMA);
@@ -111,7 +111,7 @@
 	scsi_wait_req(SRpnt, (void *) sr_cmd, (void *) buffer, buflength,
 		      IOCTL_TIMEOUT, IOCTL_RETRIES);
 
-	req = &SRpnt->sr_request;
+	req = SRpnt->sr_request;
 	if (SRpnt->sr_buffer && req->buffer && SRpnt->sr_buffer != req->buffer) {
 		memcpy(req->buffer, SRpnt->sr_buffer, SRpnt->sr_bufflen);
 		kfree(SRpnt->sr_buffer);
diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/st.c	Tue May 21 18:22:18 2002
@@ -241,7 +241,7 @@
 		scode = 0;
 	}
 
-	dev = TAPE_NR(SRpnt->sr_request.rq_dev);
+	dev = TAPE_NR(SRpnt->sr_request->rq_dev);
         DEB(
         if (debugging) {
                 printk(ST_DEB_MSG "st%d: Error: %x, cmd: %x %x %x %x %x %x Len: %d\n",
@@ -318,7 +318,7 @@
 	int remainder;
 	Scsi_Tape *STp;
 
-	st_nbr = TAPE_NR(SCpnt->request.rq_dev);
+	st_nbr = TAPE_NR(SCpnt->request->rq_dev);
 	read_lock(&st_dev_arr_lock);
 	STp = scsi_tapes[st_nbr];
 	read_unlock(&st_dev_arr_lock);
@@ -340,11 +340,11 @@
 			(STp->buffer)->midlevel_result = INT_MAX;	/* OK */
 	} else
 		(STp->buffer)->midlevel_result = SCpnt->result;
-	SCpnt->request.rq_status = RQ_SCSI_DONE;
+	SCpnt->request->rq_status = RQ_SCSI_DONE;
 	(STp->buffer)->last_SRpnt = SCpnt->sc_request;
 	DEB( STp->write_pending = 0; )
 
-	complete(SCpnt->request.waiting);
+	complete(SCpnt->request->waiting);
 }
 
 
@@ -383,16 +383,16 @@
 		bp = (STp->buffer)->b_data;
 	SRpnt->sr_data_direction = direction;
 	SRpnt->sr_cmd_len = 0;
-	SRpnt->sr_request.waiting = &(STp->wait);
-	SRpnt->sr_request.rq_status = RQ_SCSI_BUSY;
-	SRpnt->sr_request.rq_dev = STp->devt;
+	SRpnt->sr_request->waiting = &(STp->wait);
+	SRpnt->sr_request->rq_status = RQ_SCSI_BUSY;
+	SRpnt->sr_request->rq_dev = STp->devt;
 
 	scsi_do_req(SRpnt, (void *) cmd, bp, bytes,
 		    st_sleep_done, timeout, retries);
 
 	if (do_wait) {
-		wait_for_completion(SRpnt->sr_request.waiting);
-		SRpnt->sr_request.waiting = NULL;
+		wait_for_completion(SRpnt->sr_request->waiting);
+		SRpnt->sr_request->waiting = NULL;
 		(STp->buffer)->syscall_result = st_chk_result(STp, SRpnt);
 	}
 	return SRpnt;
@@ -415,7 +415,7 @@
         ) /* end DEB */
 
 	wait_for_completion(&(STp->wait));
-	(STp->buffer)->last_SRpnt->sr_request.waiting = NULL;
+	(STp->buffer)->last_SRpnt->sr_request->waiting = NULL;
 
 	(STp->buffer)->syscall_result = st_chk_result(STp, (STp->buffer)->last_SRpnt);
 	scsi_release_request((STp->buffer)->last_SRpnt);
diff -Nru a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
--- a/drivers/scsi/sun3_NCR5380.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/sun3_NCR5380.c	Tue May 21 18:22:18 2002
@@ -1217,7 +1217,7 @@
 	       HOSTNO, NCR5380_read(BUS_AND_STATUS_REG),
 	       NCR5380_read(STATUS_REG));
 
-    if((sun3scsi_dma_finish(hostdata->connected->request.cmd))) {
+    if((sun3scsi_dma_finish(hostdata->connected->request->cmd))) {
 	    printk("scsi%d: overrun in UDC counter -- not prepared to deal with this!\n", HOSTNO);
 	    printk("please e-mail sammy@oh.verio.com with a description of how this\n");
 	    printk("error was produced.\n");
@@ -2016,9 +2016,9 @@
 		if((count > SUN3_DMA_MINSIZE) && (sun3_dma_setup_done
 						  != cmd))
 		{
-			if((cmd->request.cmd == 0) || (cmd->request.cmd == 1)) {
+			if((cmd->request->cmd == 0) || (cmd->request->cmd == 1)) {
 				sun3scsi_dma_setup(d, count,
-						   cmd->request.cmd);
+						   cmd->request->cmd);
 				sun3_dma_setup_done = cmd;
 			}
 		}
@@ -2628,7 +2628,7 @@
 						  != tmp))
 		{
 			sun3scsi_dma_setup(d, count,
-					   tmp->request.cmd);
+					   tmp->request->cmd);
 			sun3_dma_setup_done = tmp;
 		}
 #endif
diff -Nru a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
--- a/drivers/scsi/sun3_scsi.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/sun3_scsi.c	Tue May 21 18:22:18 2002
@@ -519,7 +519,7 @@
 static inline unsigned long sun3scsi_dma_xfer_len(unsigned long wanted, Scsi_Cmnd *cmd,
 				    int write_flag)
 {
-	if((cmd->request.cmd == 0) || (cmd->request.cmd == 1))
+	if((cmd->request->cmd == 0) || (cmd->request->cmd == 1))
  		return wanted;
 	else
 		return 0;
diff -Nru a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c	Tue May 21 18:22:18 2002
+++ b/drivers/scsi/u14-34f.c	Tue May 21 18:22:18 2002
@@ -1206,7 +1206,7 @@
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type)) {
       HD(j)->cp_stat[i] = READY;
-      flush_dev(SCpnt->device, SCpnt->request.sector, j, FALSE);
+      flush_dev(SCpnt->device, SCpnt->request->sector, j, FALSE);
       return 0;
       }
 
@@ -1529,11 +1529,11 @@
 
       if (!(cpp->xdir == DTD_IN)) input_only = FALSE;
 
-      if (SCpnt->request.sector < minsec) minsec = SCpnt->request.sector;
-      if (SCpnt->request.sector > maxsec) maxsec = SCpnt->request.sector;
+      if (SCpnt->request->sector < minsec) minsec = SCpnt->request->sector;
+      if (SCpnt->request->sector > maxsec) maxsec = SCpnt->request->sector;
 
-      sl[n] = SCpnt->request.sector;
-      ioseek += SCpnt->request.nr_sectors;
+      sl[n] = SCpnt->request->sector;
+      ioseek += SCpnt->request->nr_sectors;
 
       if (!n) continue;
 
@@ -1561,7 +1561,7 @@
 
    if (!input_only) for (n = 0; n < n_ready; n++) {
       k = il[n]; cpp = &HD(j)->cp[k]; SCpnt = cpp->SCpnt;
-      ll[n] = SCpnt->request.nr_sectors; pl[n] = SCpnt->pid;
+      ll[n] = SCpnt->request->nr_sectors; pl[n] = SCpnt->pid;
 
       if (!n) continue;
 
@@ -1589,7 +1589,7 @@
                 " cur %ld s:%c r:%c rev:%c in:%c ov:%c xd %d.\n",
                 (ihdlr ? "ihdlr" : "qcomm"), SCpnt->channel, SCpnt->target,
                 SCpnt->lun, SCpnt->pid, k, flushcount, n_ready,
-                SCpnt->request.sector, SCpnt->request.nr_sectors, cursec,
+                SCpnt->request->sector, SCpnt->request->nr_sectors, cursec,
                 YESNO(s), YESNO(r), YESNO(rev), YESNO(input_only),
                 YESNO(overlap), cpp->xdir);
          }
@@ -1718,7 +1718,7 @@
 
    if (linked_comm && SCpnt->device->queue_depth > 2
                                      && TLDEV(SCpnt->device->type))
-      flush_dev(SCpnt->device, SCpnt->request.sector, j, TRUE);
+      flush_dev(SCpnt->device, SCpnt->request->sector, j, TRUE);
 
    tstatus = status_byte(spp->target_status);
 

--==_Exmh_-17832539770--


