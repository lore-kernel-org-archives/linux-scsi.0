From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] turn scsi_allocate_device into readable code
Date: Thu, 21 Nov 2002 16:16:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021121161647.B14037@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.23/drivers/scsi/cpqfcTSinit.c	Fri Oct 25 03:13:39 2002
+++ edited/drivers/scsi/cpqfcTSinit.c	Thu Nov 21 15:51:32 2002
@@ -1604,7 +1604,7 @@
   scsi_cdb[0] = RELEASE;
 
   // allocate with wait = true, interruptible = false 
-  SCpnt = scsi_allocate_device(ScsiDev, 1, 0);
+  SCpnt = scsi_allocate_device(ScsiDev, 1);
   {
     CPQFC_DECLARE_COMPLETION(wait);
     
--- 1.15/drivers/scsi/gdth.c	Fri Nov  8 08:47:03 2002
+++ edited/drivers/scsi/gdth.c	Thu Nov 21 15:51:32 2002
@@ -4599,7 +4599,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020322
     sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    scp  = scsi_allocate_device(sdev, 1, FALSE);
+    scp  = scsi_allocate_device(sdev, 1);
     scp->cmd_len = 12;
     scp->use_sg = 0;
 #else
@@ -4673,7 +4673,7 @@
         memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 #if LINUX_VERSION_CODE >= 0x020322
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        scp  = scsi_allocate_device(sdev, 1, FALSE);
+        scp  = scsi_allocate_device(sdev, 1);
         scp->cmd_len = 12;
         scp->use_sg = 0;
 #else
--- 1.6/drivers/scsi/gdth_proc.c	Sat Apr 13 19:42:56 2002
+++ edited/drivers/scsi/gdth_proc.c	Thu Nov 21 15:51:33 2002
@@ -48,7 +48,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020322
     sdev = scsi_get_host_dev(gdth_ctr_vtab[vh]);
-    scp  = scsi_allocate_device(sdev, 1, FALSE);
+    scp  = scsi_allocate_device(sdev, 1);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
@@ -712,7 +712,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020322
     sdev = scsi_get_host_dev(gdth_ctr_vtab[vh]);
-    scp  = scsi_allocate_device(sdev, 1, FALSE);
+    scp  = scsi_allocate_device(sdev, 1);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
--- 1.69/drivers/scsi/scsi.c	Mon Nov 18 17:14:23 2002
+++ edited/drivers/scsi/scsi.c	Thu Nov 21 15:51:33 2002
@@ -347,6 +347,41 @@
 }
 
 /*
+ * FIXME(eric) - this is not at all optimal.  Given that
+ * single lun devices are rare and usually slow
+ * (i.e. CD changers), this is good enough for now, but
+ * we may want to come back and optimize this later.
+ *
+ * Scan through all of the devices attached to this
+ * host, and see if any are active or not.  If so,
+ * we need to defer this command.
+ *
+ * We really need a busy counter per device.  This would
+ * allow us to more easily figure out whether we should
+ * do anything here or not.
+ */
+static int check_all_luns(struct Scsi_Host *shost, struct scsi_device *myself)
+{
+	struct scsi_device *sdev;
+
+	for (sdev = shost->host_queue; sdev; sdev = sdev->next) {
+		/*
+		 * Only look for other devices on the same bus
+		 * with the same target ID.
+		 */
+		if (sdev->channel != myself->channel || sdev->id != myself->id)
+			continue;
+		if (sdev == myself)
+			continue;
+
+		if (atomic_read(&sdev->device_active))
+			return 1;
+	}
+
+	return 0;
+}
+
+/*
  * Function:    scsi_allocate_device
  *
  * Purpose:     Allocate a command descriptor.
@@ -372,172 +407,87 @@
  *              This function is deprecated, and drivers should be
  *              rewritten to use Scsi_Request instead of Scsi_Cmnd.
  */
-
-Scsi_Cmnd *scsi_allocate_device(Scsi_Device * device, int wait, 
-                                int interruptable)
+struct scsi_cmnd *scsi_allocate_device(struct scsi_device *sdev, int wait)
 {
- 	struct Scsi_Host *host;
-  	Scsi_Cmnd *SCpnt = NULL;
-	Scsi_Device *SDpnt;
+	DECLARE_WAITQUEUE(wq, current);
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_cmnd *scmnd;
 	unsigned long flags;
-  
-  	if (!device)
-  		panic("No device passed to scsi_allocate_device().\n");
-  
-  	host = device->host;
-  
+
 	spin_lock_irqsave(&device_request_lock, flags);
- 
-	while (1 == 1) {
-		SCpnt = NULL;
-		if (!device->device_blocked) {
-			if (device->single_lun) {
-				/*
-				 * FIXME(eric) - this is not at all optimal.  Given that
-				 * single lun devices are rare and usually slow
-				 * (i.e. CD changers), this is good enough for now, but
-				 * we may want to come back and optimize this later.
-				 *
-				 * Scan through all of the devices attached to this
-				 * host, and see if any are active or not.  If so,
-				 * we need to defer this command.
-				 *
-				 * We really need a busy counter per device.  This would
-				 * allow us to more easily figure out whether we should
-				 * do anything here or not.
-				 */
-				for (SDpnt = host->host_queue;
-				     SDpnt;
-				     SDpnt = SDpnt->next) {
-					/*
-					 * Only look for other devices on the same bus
-					 * with the same target ID.
-					 */
-					if (SDpnt->channel != device->channel
-					    || SDpnt->id != device->id
-					    || SDpnt == device) {
- 						continue;
-					}
-                                        if( atomic_read(&SDpnt->device_active) != 0)
-                                        {
-                                                break;
-                                        }
-				}
-				if (SDpnt) {
-					/*
-					 * Some other device in this cluster is busy.
-					 * If asked to wait, we need to wait, otherwise
-					 * return NULL.
-					 */
-					SCpnt = NULL;
-					goto busy;
-				}
-			}
-			/*
-			 * Now we can check for a free command block for this device.
-			 */
-			for (SCpnt = device->device_queue; SCpnt; SCpnt = SCpnt->next) {
-				if (SCpnt->request == NULL)
-					break;
-			}
-		}
+	while (1) {
+		if (sdev->device_blocked)
+			goto busy;
+		if (sdev->single_lun && check_all_luns(shost, sdev))
+			goto busy;
+
 		/*
-		 * If we couldn't find a free command block, and we have been
-		 * asked to wait, then do so.
+		 * Now we can check for a free command block for this device.
 		 */
-		if (SCpnt) {
-			break;
-		}
-      busy:
+		for (scmnd = sdev->device_queue; scmnd; scmnd = scmnd->next)
+			if (!scmnd->request)
+				goto found;
+
+busy:
+		if (!wait)
+			goto fail;
+
 		/*
-		 * If we have been asked to wait for a free block, then
-		 * wait here.
+		 * We need to wait for a free commandblock.  We need to
+		 * insert ourselves into the list before we release the
+		 * lock.  This way if a block were released the same
+		 * microsecond that we released the lock, the call
+		 * to schedule() wouldn't block (well, it might switch,
+		 * but the current task will still be schedulable.
 		 */
-		if (wait) {
-                        DECLARE_WAITQUEUE(wait, current);
-
-                        /*
-                         * We need to wait for a free commandblock.  We need to
-                         * insert ourselves into the list before we release the
-                         * lock.  This way if a block were released the same
-                         * microsecond that we released the lock, the call
-                         * to schedule() wouldn't block (well, it might switch,
-                         * but the current task will still be schedulable.
-                         */
-                        add_wait_queue(&device->scpnt_wait, &wait);
-                        if( interruptable ) {
-                                set_current_state(TASK_INTERRUPTIBLE);
-                        } else {
-                                set_current_state(TASK_UNINTERRUPTIBLE);
-                        }
-
-                        spin_unlock_irqrestore(&device_request_lock, flags);
-
-			/*
-			 * This should block until a device command block
-			 * becomes available.
-			 */
-                        schedule();
-
-			spin_lock_irqsave(&device_request_lock, flags);
-
-                        remove_wait_queue(&device->scpnt_wait, &wait);
-                        /*
-                         * FIXME - Isn't this redundant??  Someone
-                         * else will have forced the state back to running.
-                         */
-                        set_current_state(TASK_RUNNING);
-                        /*
-                         * In the event that a signal has arrived that we need
-                         * to consider, then simply return NULL.  Everyone
-                         * that calls us should be prepared for this
-                         * possibility, and pass the appropriate code back
-                         * to the user.
-                         */
-                        if( interruptable ) {
-                                if (signal_pending(current)) {
-                                        spin_unlock_irqrestore(&device_request_lock, flags);
-                                        return NULL;
-                                }
-                        }
-		} else {
-                        spin_unlock_irqrestore(&device_request_lock, flags);
-			return NULL;
-		}
-	}
-
-	SCpnt->request = NULL;
-	atomic_inc(&SCpnt->host->host_active);
-	atomic_inc(&SCpnt->device->device_active);
-
-	SCpnt->buffer  = NULL;
-	SCpnt->bufflen = 0;
-	SCpnt->request_buffer = NULL;
-	SCpnt->request_bufflen = 0;
-
-	SCpnt->use_sg = 0;	/* Reset the scatter-gather flag */
-	SCpnt->old_use_sg = 0;
-	SCpnt->transfersize = 0;	/* No default transfer size */
-	SCpnt->cmd_len = 0;
+		add_wait_queue(&sdev->scpnt_wait, &wq);
+		set_current_state(TASK_UNINTERRUPTIBLE);
 
-	SCpnt->sc_data_direction = SCSI_DATA_UNKNOWN;
-	SCpnt->sc_request = NULL;
-	SCpnt->sc_magic = SCSI_CMND_MAGIC;
-
-        SCpnt->result = 0;
-	SCpnt->underflow = 0;	/* Do not flag underflow conditions */
-	SCpnt->old_underflow = 0;
-	SCpnt->resid = 0;
-	SCpnt->state = SCSI_STATE_INITIALIZING;
-	SCpnt->owner = SCSI_OWNER_HIGHLEVEL;
+		spin_unlock_irqrestore(&device_request_lock, flags);
+		schedule();
+		spin_lock_irqsave(&device_request_lock, flags);
+
+		remove_wait_queue(&sdev->scpnt_wait, &wq);
+		set_current_state(TASK_RUNNING);
+	}
+
+found:
+	scmnd->request = NULL;
+	atomic_inc(&scmnd->host->host_active);
+	atomic_inc(&scmnd->device->device_active);
+
+	scmnd->buffer  = NULL;
+	scmnd->bufflen = 0;
+	scmnd->request_buffer = NULL;
+	scmnd->request_bufflen = 0;
+
+	scmnd->use_sg = 0;	/* Reset the scatter-gather flag */
+	scmnd->old_use_sg = 0;
+	scmnd->transfersize = 0;	/* No default transfer size */
+	scmnd->cmd_len = 0;
+
+	scmnd->sc_data_direction = SCSI_DATA_UNKNOWN;
+	scmnd->sc_request = NULL;
+	scmnd->sc_magic = SCSI_CMND_MAGIC;
+
+	scmnd->result = 0;
+	scmnd->underflow = 0;	/* Do not flag underflow conditions */
+	scmnd->old_underflow = 0;
+	scmnd->resid = 0;
+	scmnd->state = SCSI_STATE_INITIALIZING;
+	scmnd->owner = SCSI_OWNER_HIGHLEVEL;
 
 	spin_unlock_irqrestore(&device_request_lock, flags);
 
 	SCSI_LOG_MLQUEUE(5, printk("Activating command for device %d (%d)\n",
-				   SCpnt->target,
-				atomic_read(&SCpnt->host->host_active)));
+				scmnd->target,
+				atomic_read(&scmnd->host->host_active)));
+
+	return scmnd;
 
-	return SCpnt;
+fail:
+	spin_unlock_irqrestore(&device_request_lock, flags);
+	return NULL;
 }
 
 inline void __scsi_release_command(Scsi_Cmnd * SCpnt)
--- 1.44/drivers/scsi/scsi.h	Sun Nov 17 22:44:35 2002
+++ edited/drivers/scsi/scsi.h	Thu Nov 21 15:51:33 2002
@@ -471,7 +471,7 @@
 extern void scsi_done(Scsi_Cmnd * SCpnt);
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);
-extern Scsi_Cmnd *scsi_allocate_device(Scsi_Device *, int, int);
+extern Scsi_Cmnd *scsi_allocate_device(Scsi_Device *, int);
 extern void __scsi_release_command(Scsi_Cmnd *);
 extern void scsi_release_command(Scsi_Cmnd *);
 extern void scsi_do_cmd(Scsi_Cmnd *, const void *cmnd,
--- 1.50/drivers/scsi/scsi_lib.c	Wed Nov 20 09:33:50 2002
+++ edited/drivers/scsi/scsi_lib.c	Thu Nov 21 15:52:29 2002
@@ -797,8 +797,7 @@
 		SRpnt = (Scsi_Request *) req->special;
 		
 		if( SRpnt->sr_magic == SCSI_REQ_MAGIC ) {
-			SCpnt = scsi_allocate_device(SRpnt->sr_device, 
-						     FALSE, FALSE);
+			SCpnt = scsi_allocate_device(SRpnt->sr_device, 0);
 			if (!SCpnt)
 				return BLKPREP_DEFER;
 			scsi_init_cmd_from_req(SCpnt, SRpnt);
@@ -809,9 +808,9 @@
 		 * Now try and find a command block that we can use.
 		 */
 		if (req->special) {
-				SCpnt = (Scsi_Cmnd *) req->special;
+			SCpnt = (Scsi_Cmnd *) req->special;
 		} else {
-			SCpnt = scsi_allocate_device(SDpnt, FALSE, FALSE);
+			SCpnt = scsi_allocate_device(SDpnt, 0);
 		}
 		/*
 		 * if command allocation failure, wait a bit
