From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fixes and cleanups for the new command allocation code
Date: Tue, 4 Feb 2003 16:23:27 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030204162326.A30755@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

I had some discussion with JAmes on the new command block allocation
code and we agreed that each struct Scsi_Host should have a pointer to
it's command pool because

 (a) this way we don't need a GFP_DMA pool for the large number of
     systems that don't have old-style ISA HBAs
 (b) easily get the right pool for allocation/freeing (the current code
     gets this wrong in at least two places)
 (c) easily allow adding more pools if there's a reason to do so.

To implement this there are two new functions

	extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
	extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);

called in the HBA setup/teardown code, they also nicely abstract away
all knowledge of the command handling from hosts.c.

In addition to that I've removed all dead code from the old command
block allocator (and there is _lots_ of that!), moved the new command
block allocator to scsi.c where the rest of the scsi command block
handling lives, properly commented it and adopted it to Linux coding
style conventions.  struct scsi_core_data is gone, the old
scsi_get_command and scsi_setup_command are now private to scsi.c, in
addition to the above two functions only the new scsi_get_command (
previously scsi_getset command, but that name is misleading) and
scsi_put_command are public.


 53c700.c      |    6 
 advansys.c    |   19 -
 cpqfcTSinit.c |    2 
 gdth.c        |    4 
 gdth_proc.c   |    4 
 hosts.c       |   38 +--
 hosts.h       |    4 
 scsi.c        |  594 +++++++++++++++-------------------------------------------
 scsi.h        |   62 ------
 scsi_lib.c    |  147 --------------
 scsi_scan.c   |    3 
 scsi_syms.c   |    8 
 scsi_sysfs.c  |    2 
 13 files changed, 196 insertions(+), 697 deletions(-)


--- 1.23/drivers/scsi/53c700.c	Tue Jan 28 17:15:50 2003
+++ edited/drivers/scsi/53c700.c	Tue Feb  4 15:41:41 2003
@@ -1718,10 +1718,10 @@
 	hostdata = (struct NCR_700_Host_Parameters *)host->hostdata[0];
 	len += sprintf(&buf[len], "Total commands outstanding: %d\n", hostdata->command_slot_count);
 	len += sprintf(&buf[len],"\
-Target	Depth  Active  Next Tag\n\
-======	=====  ======  ========\n");
+Target	Active  Next Tag\n\
+======	======  ========\n");
 	list_for_each_entry(SDp, &host->my_devices, siblings) {
-		len += sprintf(&buf[len]," %2d:%2d   %4d    %4d      %4d\n", SDp->id, SDp->lun, SDp->current_queue_depth, NCR_700_get_depth(SDp), SDp->current_tag);
+		len += sprintf(&buf[len]," %2d:%2d   %4d      %4d\n", SDp->id, SDp->lun, NCR_700_get_depth(SDp), SDp->current_tag);
 	}
 	if((len -= offset) <= 0)
 		return 0;
===== drivers/scsi/advansys.c 1.25 vs edited =====
--- 1.25/drivers/scsi/advansys.c	Fri Jan  3 19:58:49 2003
+++ edited/drivers/scsi/advansys.c	Tue Feb  4 15:41:09 2003
@@ -8417,25 +8417,6 @@
         chip_scsi_id = boardp->dvc_var.adv_dvc_var.chip_scsi_id;
     }
 
-    if (boardp->flags & ASC_SELECT_QUEUE_DEPTHS) {
-        len = asc_prt_line(cp, leftlen, " queue_depth:");
-        ASC_PRT_NEXT();
-        for (i = 0; i <= ADV_MAX_TID; i++) {
-            if ((chip_scsi_id == i) ||
-                ((boardp->init_tidmask & ADV_TID_TO_TIDMASK(i)) == 0)) {
-                continue;
-            }
-            if (boardp->device[i] == NULL) {
-                continue;
-            }
-            len = asc_prt_line(cp, leftlen, " %X:%d",
-                i, boardp->device[i]->current_queue_depth);
-            ASC_PRT_NEXT();
-        }
-        len = asc_prt_line(cp, leftlen, "\n");
-        ASC_PRT_NEXT();
-    }
-
     return totlen;
 }
 
===== drivers/scsi/cpqfcTSinit.c 1.29 vs edited =====
--- 1.29/drivers/scsi/cpqfcTSinit.c	Tue Jan 28 17:19:32 2003
+++ edited/drivers/scsi/cpqfcTSinit.c	Thu Jan 30 16:14:26 2003
@@ -1604,7 +1604,7 @@
 
   scsi_cdb[0] = RELEASE;
 
-  SCpnt = scsi_getset_command(ScsiDev, GFP_KERNEL);
+  SCpnt = scsi_get_command(ScsiDev, GFP_KERNEL);
   {
     CPQFC_DECLARE_COMPLETION(wait);
     
===== drivers/scsi/gdth.c 1.19 vs edited =====
--- 1.19/drivers/scsi/gdth.c	Tue Jan 28 17:19:33 2003
+++ edited/drivers/scsi/gdth.c	Thu Jan 30 16:14:28 2003
@@ -4637,7 +4637,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020322
     sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-    scp  = scsi_getset_command(sdev, GFP_KERNEL);
+    scp  = scsi_get_command(sdev, GFP_KERNEL);
     scp->cmd_len = 12;
     scp->use_sg = 0;
 #else
@@ -4711,7 +4711,7 @@
         memset(cmnd, 0xff, MAX_COMMAND_SIZE);
 #if LINUX_VERSION_CODE >= 0x020322
         sdev = scsi_get_host_dev(gdth_ctr_tab[hanum]);
-        scp  = scsi_getset_command(sdev, GFP_KERNEL);
+        scp  = scsi_get_command(sdev, GFP_KERNEL);
         scp->cmd_len = 12;
         scp->use_sg = 0;
 #else
===== drivers/scsi/gdth_proc.c 1.10 vs edited =====
--- 1.10/drivers/scsi/gdth_proc.c	Wed Jan  8 21:20:49 2003
+++ edited/drivers/scsi/gdth_proc.c	Thu Jan 30 16:14:22 2003
@@ -48,7 +48,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020322
     sdev = scsi_get_host_dev(gdth_ctr_vtab[vh]);
-    scp  = scsi_getset_command(sdev, GFP_KERNEL);
+    scp  = scsi_get_command(sdev, GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
@@ -712,7 +712,7 @@
 
 #if LINUX_VERSION_CODE >= 0x020322
     sdev = scsi_get_host_dev(gdth_ctr_vtab[vh]);
-    scp  = scsi_getset_command(sdev, GFP_KERNEL);
+    scp  = scsi_get_command(sdev, GFP_KERNEL);
     if (!scp)
         return -ENOMEM;
     scp->cmd_len = 12;
===== drivers/scsi/hosts.c 1.47 vs edited =====
--- 1.47/drivers/scsi/hosts.c	Tue Jan 28 17:19:33 2003
+++ edited/drivers/scsi/hosts.c	Thu Jan 30 16:49:48 2003
@@ -346,17 +346,8 @@
 	}
 
 	shost->hostt->present--;
-
-	/* Cleanup proc */
 	scsi_proc_host_rm(shost);
-
-	while (!list_empty(&shost->free_list)) {
-		struct scsi_cmnd *cmd;
-		cmd = list_entry(shost->free_list.next,struct scsi_cmnd,list);
-		list_del_init(&cmd->list);
-		kmem_cache_free(scsi_core->scsi_cmd_cache, cmd);
-	}
-
+	scsi_destroy_command_freelist(shost);
 	kfree(shost);
 }
 
@@ -377,8 +368,7 @@
 struct Scsi_Host * scsi_register(Scsi_Host_Template *shost_tp, int xtr_bytes)
 {
 	struct Scsi_Host *shost, *shost_scr;
-	struct scsi_cmnd *cmd = NULL;
-	int gfp_mask;
+	int gfp_mask, rval;
 	DECLARE_COMPLETION(sem);
 
         /* Check to see if this host has any error handling facilities */
@@ -445,7 +435,7 @@
 	shost->unchecked_isa_dma = shost_tp->unchecked_isa_dma;
 	shost->use_clustering = shost_tp->use_clustering;
 	if (!blk_nohighio)
-	shost->highmem_io = shost_tp->highmem_io;
+		shost->highmem_io = shost_tp->highmem_io;
 
 	shost->max_sectors = shost_tp->max_sectors;
 	shost->use_blk_tcq = shost_tp->use_blk_tcq;
@@ -467,16 +457,9 @@
 found:
 	spin_unlock(&scsi_host_list_lock);
 
-	spin_lock_init(&shost->free_list_lock);
-	INIT_LIST_HEAD(&shost->free_list);
-
-	/* Get one backup command for this host. */
-	cmd = scsi_get_command(shost, GFP_KERNEL);
-	if (cmd)
-		list_add(&cmd->list, &shost->free_list);		
-	else
-		printk(KERN_NOTICE "The system is running low in memory.\n");
-
+	rval = scsi_setup_command_freelist(shost);
+	if (rval)
+		goto fail;
 	scsi_proc_host_add(shost);
 
 	shost->eh_notify = &sem;
@@ -487,10 +470,15 @@
 	 */
 	wait_for_completion(&sem);
 	shost->eh_notify = NULL;
-
 	shost->hostt->present++;
-
 	return shost;
+
+fail:
+	spin_lock(&scsi_host_list_lock);
+	list_del(&shost->sh_list);
+	spin_unlock(&scsi_host_list_lock);
+	kfree(shost);
+	return NULL;
 }
 
 /**
===== drivers/scsi/hosts.h 1.50 vs edited =====
--- 1.50/drivers/scsi/hosts.h	Tue Jan 28 17:52:50 2003
+++ edited/drivers/scsi/hosts.h	Thu Jan 30 16:52:15 2003
@@ -29,6 +29,9 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 
+struct scsi_host_cmd_pool;
+
+
 /* It is senseless to set SG_ALL any higher than this - the performance
  *  does not get any better, and it wastes memory
  */
@@ -375,6 +378,7 @@
     struct list_head      sh_list;
     struct list_head	  my_devices;
 
+    struct scsi_host_cmd_pool *cmd_pool;
     spinlock_t            free_list_lock;
     struct list_head      free_list;   /* backup store of cmd structs */
 
===== drivers/scsi/scsi.c 1.85 vs edited =====
--- 1.85/drivers/scsi/scsi.c	Tue Jan 14 21:20:11 2003
+++ edited/drivers/scsi/scsi.c	Tue Feb  4 15:58:19 2003
@@ -145,7 +145,6 @@
  * Function prototypes.
  */
 extern void scsi_times_out(Scsi_Cmnd * SCpnt);
-void scsi_build_commandblocks(Scsi_Device * SDpnt);
 
 #ifdef MODULE
 MODULE_PARM(scsi_logging_level, "i");
@@ -196,14 +195,6 @@
 }
 
 /*
- * This lock protects the freelist for all devices on the system.
- * We could make this finer grained by having a single lock per
- * device if it is ever found that there is excessive contention
- * on this lock.
- */
-static spinlock_t device_request_lock = SPIN_LOCK_UNLOCKED;
-
-/*
  * Function:    scsi_allocate_request
  *
  * Purpose:     Allocate a request descriptor.
@@ -273,231 +264,6 @@
 }
 
 /*
- * FIXME(eric) - this is not at all optimal.  Given that
- * single lun devices are rare and usually slow
- * (i.e. CD changers), this is good enough for now, but
- * we may want to come back and optimize this later.
- *
- * Scan through all of the devices attached to this
- * host, and see if any are active or not.  If so,
- * we need to defer this command.
- *
- * We really need a busy counter per device.  This would
- * allow us to more easily figure out whether we should
- * do anything here or not.
- */
-static int check_all_luns(struct Scsi_Host *shost, struct scsi_device *myself)
-{
-	struct scsi_device *sdev;
-
-	list_for_each_entry(sdev, &myself->same_target_siblings,
-		       	same_target_siblings) {
-		if (atomic_read(&sdev->device_active))
-			return 1;
-	}
-
-	return 0;
-}
-
-/*
- * Function:    scsi_allocate_device
- *
- * Purpose:     Allocate a command descriptor.
- *
- * Arguments:   device    - device for which we want a command descriptor
- *              wait      - 1 if we should wait in the event that none
- *                          are available.
- *              interruptible - 1 if we should unblock and return NULL
- *                          in the event that we must wait, and a signal
- *                          arrives.
- *
- * Lock status: No locks assumed to be held.  This function is SMP-safe.
- *
- * Returns:     Pointer to command descriptor.
- *
- * Notes:       Prior to the new queue code, this function was not SMP-safe.
- *
- *              If the wait flag is true, and we are waiting for a free
- *              command block, this function will interrupt and return
- *              NULL in the event that a signal arrives that needs to
- *              be handled.
- *
- *              This function is deprecated, and drivers should be
- *              rewritten to use Scsi_Request instead of Scsi_Cmnd.
- */
-struct scsi_cmnd *scsi_allocate_device(struct scsi_device *sdev, int wait)
-{
-	DECLARE_WAITQUEUE(wq, current);
-	struct Scsi_Host *shost = sdev->host;
-	struct scsi_cmnd *scmnd;
-	unsigned long flags;
-
-	spin_lock_irqsave(&device_request_lock, flags);
-	while (1) {
-		if (sdev->device_blocked)
-			goto busy;
-		if (sdev->single_lun && check_all_luns(shost, sdev))
-			goto busy;
-
-		/*
-		 * Now we can check for a free command block for this device.
-		 */
-		for (scmnd = sdev->device_queue; scmnd; scmnd = scmnd->next)
-			if (!scmnd->request)
-				goto found;
-
-busy:
-		if (!wait)
-			goto fail;
-
-		/*
-		 * We need to wait for a free commandblock.  We need to
-		 * insert ourselves into the list before we release the
-		 * lock.  This way if a block were released the same
-		 * microsecond that we released the lock, the call
-		 * to schedule() wouldn't block (well, it might switch,
-		 * but the current task will still be schedulable.
-		 */
-		add_wait_queue(&sdev->scpnt_wait, &wq);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-
-		spin_unlock_irqrestore(&device_request_lock, flags);
-		schedule();
-		spin_lock_irqsave(&device_request_lock, flags);
-
-		remove_wait_queue(&sdev->scpnt_wait, &wq);
-		set_current_state(TASK_RUNNING);
-	}
-
-found:
-	scmnd->request = NULL;
-	atomic_inc(&scmnd->device->host->host_active);
-	atomic_inc(&scmnd->device->device_active);
-
-	scmnd->buffer  = NULL;
-	scmnd->bufflen = 0;
-	scmnd->request_buffer = NULL;
-	scmnd->request_bufflen = 0;
-
-	scmnd->use_sg = 0;	/* Reset the scatter-gather flag */
-	scmnd->old_use_sg = 0;
-	scmnd->transfersize = 0;	/* No default transfer size */
-	scmnd->cmd_len = 0;
-
-	scmnd->sc_data_direction = SCSI_DATA_UNKNOWN;
-	scmnd->sc_request = NULL;
-	scmnd->sc_magic = SCSI_CMND_MAGIC;
-
-	scmnd->result = 0;
-	scmnd->underflow = 0;	/* Do not flag underflow conditions */
-	scmnd->old_underflow = 0;
-	scmnd->resid = 0;
-	scmnd->state = SCSI_STATE_INITIALIZING;
-	scmnd->owner = SCSI_OWNER_HIGHLEVEL;
-
-	spin_unlock_irqrestore(&device_request_lock, flags);
-
-	SCSI_LOG_MLQUEUE(5, printk("Activating command for device %d (%d)\n",
-				scmnd->device->id,
-				atomic_read(&scmnd->device->host->host_active)));
-
-	return scmnd;
-
-fail:
-	spin_unlock_irqrestore(&device_request_lock, flags);
-	return NULL;
-}
-
-inline void __scsi_release_command(Scsi_Cmnd * SCpnt)
-{
-	unsigned long flags;
-        Scsi_Device * SDpnt;
-	int alloc_cmd = 0;
-
-	spin_lock_irqsave(&device_request_lock, flags);
-
-        SDpnt = SCpnt->device;
-
-	SCpnt->request = NULL;
-	SCpnt->state = SCSI_STATE_UNUSED;
-	SCpnt->owner = SCSI_OWNER_NOBODY;
-	atomic_dec(&SCpnt->device->host->host_active);
-	atomic_dec(&SDpnt->device_active);
-
-	SCSI_LOG_MLQUEUE(5, printk("Deactivating command for device %d (active=%d, failed=%d)\n",
-				   SCpnt->device->id,
-				   atomic_read(&SCpnt->device->host->host_active),
-				   SCpnt->device->host->host_failed));
-
-	if(SDpnt->current_queue_depth > SDpnt->new_queue_depth) {
-		Scsi_Cmnd *prev, *next;
-		/*
-		 * Release the command block and decrement the queue
-		 * depth.
-		 */
-		for(prev = NULL, next = SDpnt->device_queue;
-				next != SCpnt;
-				prev = next, next = next->next) ;
-		if(prev == NULL)
-			SDpnt->device_queue = next->next;
-		else
-			prev->next = next->next;
-		kfree((char *)SCpnt);
-		SDpnt->current_queue_depth--;
-	} else if(SDpnt->current_queue_depth < SDpnt->new_queue_depth) {
-		alloc_cmd = 1;
-		SDpnt->current_queue_depth++;
-	}
-	spin_unlock_irqrestore(&device_request_lock, flags);
-
-        /*
-         * Wake up anyone waiting for this device.  Do this after we
-         * have released the lock, as they will need it as soon as
-         * they wake up.  
-         */
-	wake_up(&SDpnt->scpnt_wait);
-
-	/*
-	 * We are happy to release command blocks in the scope of the
-	 * device_request_lock since that's nice and quick, but allocation
-	 * can take more time so do it outside that scope instead.
-	 */
-	if(alloc_cmd) {
-		Scsi_Cmnd *newSCpnt;
-
-		newSCpnt = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
-				(SDpnt->host->unchecked_isa_dma ?
-				 GFP_DMA : 0));
-		if(newSCpnt) {
-			memset(newSCpnt, 0, sizeof(Scsi_Cmnd));
-			init_timer(&newSCpnt->eh_timeout);
-			newSCpnt->device = SDpnt;
-			newSCpnt->request = NULL;
-			newSCpnt->use_sg = 0;
-			newSCpnt->old_use_sg = 0;
-			newSCpnt->old_cmd_len = 0;
-			newSCpnt->underflow = 0;
-			newSCpnt->old_underflow = 0;
-			newSCpnt->transfersize = 0;
-			newSCpnt->resid = 0;
-			newSCpnt->serial_number = 0;
-			newSCpnt->serial_number_at_timeout = 0;
-			newSCpnt->host_scribble = NULL;
-			newSCpnt->state = SCSI_STATE_UNUSED;
-			newSCpnt->owner = SCSI_OWNER_NOBODY;
-			spin_lock_irqsave(&device_request_lock, flags);
-			newSCpnt->next = SDpnt->device_queue;
-			SDpnt->device_queue = newSCpnt;
-			spin_unlock_irqrestore(&device_request_lock, flags);
-		} else {
-			spin_lock_irqsave(&device_request_lock, flags);
-			SDpnt->current_queue_depth--;
-			spin_unlock_irqrestore(&device_request_lock, flags);
-		}
-	}
-}
-
-/*
  * Function:    scsi_mlqueue_insert()
  *
  * Purpose:     Insert a command in the midlevel queue.
@@ -516,7 +282,7 @@
  * Notes:       This could be called either from an interrupt context or a
  *              normal process context.
  */
-int scsi_mlqueue_insert(Scsi_Cmnd * cmd, int reason)
+static int scsi_mlqueue_insert(Scsi_Cmnd * cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
@@ -578,43 +344,170 @@
 	return 0;
 }
 
+struct scsi_host_cmd_pool {
+	kmem_cache_t	*slab;
+	unsigned int	users;
+	char		*name;
+	unsigned int	slab_flags;
+	unsigned int	gfp_mask;
+};
+
+static struct scsi_host_cmd_pool scsi_cmd_pool = {
+	.name		= "scsi_cmd_cache",
+	.slab_flags	= SLAB_HWCACHE_ALIGN,
+};
+
+static struct scsi_host_cmd_pool scsi_cmd_dma_pool = {
+	.name		= "scsi_cmd_cache(DMA)",
+	.slab_flags	= SLAB_HWCACHE_ALIGN|SLAB_CACHE_DMA,
+	.gfp_mask	= __GFP_DMA,
+};
+
+static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
+					    int gfp_mask)
+{
+	struct scsi_cmnd *cmd;
+	
+	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
+			gfp_mask | shost->cmd_pool->gfp_mask);
+
+	if (unlikely(!cmd)) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&shost->free_list_lock, flags);
+		if (likely(!list_empty(&shost->free_list))) {
+			cmd = list_entry(shost->free_list.next,
+					 struct scsi_cmnd, list);
+			list_del_init(&cmd->list);
+		}
+		spin_unlock_irqrestore(&shost->free_list_lock, flags);
+	}
+
+	return cmd;
+}
+
+/*
+ * Function:	scsi_get_command()
+ *
+ * Purpose:	Allocate and setup a scsi command block
+ *
+ * Arguments:	dev	- parent scsi device
+ *		gfp_mask- allocator flags
+ *
+ * Returns:	The allocated scsi command structure.
+ */
+struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int gfp_mask)
+{
+	struct scsi_cmnd *cmd = __scsi_get_command(dev->host, gfp_mask);
+
+	if (likely(cmd)) {
+		memset(cmd, 0, sizeof(*cmd));
+		cmd->device = dev;
+		cmd->state = SCSI_STATE_UNUSED;
+		cmd->owner = SCSI_OWNER_NOBODY;
+		init_timer(&cmd->eh_timeout);
+		INIT_LIST_HEAD(&cmd->list);
+	}
+
+	return cmd;
+}				
+
 /*
- * Function:    scsi_release_command
+ * Function:	scsi_put_command()
  *
- * Purpose:     Release a command block.
+ * Purpose:	Free a scsi command block
  *
- * Arguments:   SCpnt - command block we are releasing.
+ * Arguments:	cmd	- command block to free
  *
- * Notes:       The command block can no longer be used by the caller once
- *              this funciton is called.  This is in effect the inverse
- *              of scsi_allocate_device.  Note that we also must perform
- *              a couple of additional tasks.  We must first wake up any
- *              processes that might have blocked waiting for a command
- *              block, and secondly we must hit the queue handler function
- *              to make sure that the device is busy.  Note - there is an
- *              option to not do this - there were instances where we could
- *              recurse too deeply and blow the stack if this happened
- *              when we were indirectly called from the request function
- *              itself.
- *
- *              The idea is that a lot of the mid-level internals gunk
- *              gets hidden in this function.  Upper level drivers don't
- *              have any chickens to wave in the air to get things to
- *              work reliably.
+ * Returns:	Nothing.
  *
- *              This function is deprecated, and drivers should be
- *              rewritten to use Scsi_Request instead of Scsi_Cmnd.
+ * Notes:	The command must not belong to any lists.
  */
-void scsi_release_command(Scsi_Cmnd * SCpnt)
+void scsi_put_command(struct scsi_cmnd *cmd)
 {
-        __scsi_release_command(SCpnt);
-        /*
-         * Finally, hit the queue request function to make sure that
-         * the device is actually busy if there are requests present.
-         * This won't block - if the device cannot take any more, life
-         * will go on.  
-         */
-        scsi_queue_next_request(SCpnt->device->request_queue, NULL);
+	struct Scsi_Host *shost = cmd->device->host;
+	unsigned long flags;
+	
+	spin_lock_irqsave(&shost->free_list_lock, flags);
+	if (unlikely(list_empty(&shost->free_list))) {
+		list_add(&cmd->list, &shost->free_list);
+		cmd = NULL;
+	}
+	spin_unlock_irqrestore(&shost->free_list_lock, flags);
+
+	if (likely(cmd))
+		kmem_cache_free(shost->cmd_pool->slab, cmd);
+}
+
+/*
+ * Function:	scsi_setup_command_freelist()
+ *
+ * Purpose:	Setup the command freelist for a scsi host.
+ *
+ * Arguments:	shost	- host to allocate the freelist for.
+ *
+ * Returns:	Nothing.
+ */
+int scsi_setup_command_freelist(struct Scsi_Host *shost)
+{
+	struct scsi_host_cmd_pool *pool;
+	struct scsi_cmnd *cmd;
+
+	spin_lock_init(&shost->free_list_lock);
+	INIT_LIST_HEAD(&shost->free_list);
+
+	/*
+	 * Select a command slab for this host and create it if not
+	 * yet existant.
+	 */
+	pool = (shost->unchecked_isa_dma ? &scsi_cmd_dma_pool : &scsi_cmd_pool);
+	if (!pool->users) {
+		pool->slab = kmem_cache_create(pool->name,
+				sizeof(struct scsi_cmnd), 0,
+				pool->slab_flags, NULL, NULL);
+		if (!pool->slab)
+			return -ENOMEM;
+	}
+
+	pool->users++;
+	shost->cmd_pool = pool;
+
+	/*
+	 * Get one backup command for this host.
+	 */
+	cmd = kmem_cache_alloc(shost->cmd_pool->slab,
+			GFP_KERNEL | shost->cmd_pool->gfp_mask);
+	if (!cmd)
+		goto fail;
+	list_add(&cmd->list, &shost->free_list);		
+	return 0;
+
+fail:
+	if (!--pool->users)
+		kmem_cache_destroy(pool->slab);
+	return -ENOMEM;
+
+}
+
+/*
+ * Function:	scsi_destroy_command_freelist()
+ *
+ * Purpose:	Release the command freelist for a scsi host.
+ *
+ * Arguments:	shost	- host that's freelist is going to be destroyed
+ */
+void scsi_destroy_command_freelist(struct Scsi_Host *shost)
+{
+	while (!list_empty(&shost->free_list)) {
+		struct scsi_cmnd *cmd;
+
+		cmd = list_entry(shost->free_list.next, struct scsi_cmnd, list);
+		list_del_init(&cmd->list);
+		kmem_cache_free(shost->cmd_pool->slab, cmd);
+	}
+
+	if (!--shost->cmd_pool->users)
+		kmem_cache_destroy(shost->cmd_pool->slab);
 }
 
 /*
@@ -1340,94 +1233,6 @@
 }
 
 /*
- * Function:    scsi_release_commandblocks()
- *
- * Purpose:     Release command blocks associated with a device.
- *
- * Arguments:   SDpnt   - device
- *
- * Returns:     Nothing
- *
- * Lock status: No locking assumed or required.
- *
- * Notes:
- */
-void scsi_release_commandblocks(Scsi_Device * SDpnt)
-{
-	Scsi_Cmnd *SCpnt, *SCnext;
-	unsigned long flags;
-
- 	spin_lock_irqsave(&device_request_lock, flags);
-	for (SCpnt = SDpnt->device_queue; SCpnt; SCpnt = SCnext) {
-		SDpnt->device_queue = SCnext = SCpnt->next;
-		kfree((char *) SCpnt);
-	}
-	SDpnt->current_queue_depth = 0;
-	SDpnt->new_queue_depth = 0;
-	spin_unlock_irqrestore(&device_request_lock, flags);
-}
-
-/*
- * Function:    scsi_build_commandblocks()
- *
- * Purpose:     Allocate command blocks associated with a device.
- *
- * Arguments:   SDpnt   - device
- *
- * Returns:     Nothing
- *
- * Lock status: No locking assumed or required.
- *
- * Notes:	We really only allocate one command here.  We will allocate
- *		more commands as needed once the device goes into real use.
- */
-void scsi_build_commandblocks(Scsi_Device * SDpnt)
-{
-	unsigned long flags;
-	Scsi_Cmnd *SCpnt;
-
-	if (SDpnt->current_queue_depth != 0)
-		return;
-		
-	SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
-			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
-	if (NULL == SCpnt) {
-		/*
-		 * Since we don't currently have *any* command blocks on this
-		 * device, go ahead and try an atomic allocation...
-		 */
-		SCpnt = (Scsi_Cmnd *) kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC |
-			(SDpnt->host->unchecked_isa_dma ? GFP_DMA : 0));
-		if (NULL == SCpnt)
-			return;	/* Oops, we aren't going anywhere for now */
-	}
-
-	memset(SCpnt, 0, sizeof(Scsi_Cmnd));
-	init_timer(&SCpnt->eh_timeout);
-	SCpnt->device = SDpnt;
-	SCpnt->request = NULL;
-	SCpnt->use_sg = 0;
-	SCpnt->old_use_sg = 0;
-	SCpnt->old_cmd_len = 0;
-	SCpnt->underflow = 0;
-	SCpnt->old_underflow = 0;
-	SCpnt->transfersize = 0;
-	SCpnt->resid = 0;
-	SCpnt->serial_number = 0;
-	SCpnt->serial_number_at_timeout = 0;
-	SCpnt->host_scribble = NULL;
-	SCpnt->state = SCSI_STATE_UNUSED;
-	SCpnt->owner = SCSI_OWNER_NOBODY;
-	spin_lock_irqsave(&device_request_lock, flags);
-	if(SDpnt->new_queue_depth == 0)
-		SDpnt->new_queue_depth = 1;
-	SDpnt->current_queue_depth++;
-	SCpnt->next = SDpnt->device_queue;
-	SDpnt->device_queue = SCpnt;
-	spin_unlock_irqrestore(&device_request_lock, flags);
-}
-
-/*
  * Function:	scsi_adjust_queue_depth()
  *
  * Purpose:	Allow low level drivers to tell us to change the queue depth
@@ -1448,28 +1253,10 @@
  * 		the right thing depending on whether or not the device is
  * 		currently active and whether or not it even has the
  * 		command blocks built yet.
- *
- * 		If cmdblocks != 0 then we are a live device.  We just set the
- * 		new_queue_depth variable and when the scsi completion handler
- * 		notices that current_queue_depth != new_queue_depth it will
- * 		work to rectify the situation.  If new_queue_depth is less than
- * 		current_queue_depth, then it will free the completed command
- * 		instead of putting it back on the free list and dec
- * 		current_queue_depth.  Otherwise	it will try to allocate a new
- * 		command block for the device and put it on the free list along
- * 		with the command that is being
- *		completed.  Obviously, if the device isn't doing anything then
- *		neither is this code, so it will bring the devices queue depth
- *		back into line when the device is actually being used.  This
- *		keeps us from needing to fire off a kernel thread or some such
- *		nonsense (this routine can be called from interrupt code, so
- *		handling allocations here would be tricky and risky, making
- *		a kernel thread a much safer way to go if we wanted to handle
- *		the work immediately instead of letting it get done a little
- *		at a time in the completion handler).
  */
 void scsi_adjust_queue_depth(Scsi_Device *SDpnt, int tagged, int tags)
 {
+	static spinlock_t device_request_lock = SPIN_LOCK_UNLOCKED;
 	unsigned long flags;
 
 	/*
@@ -1506,12 +1293,6 @@
 			SDpnt->new_queue_depth = tags;
 			break;
 	}
-	/* TODO FIXME This is a hack and MUST go eventually.
-	   This fixes a problem in scsi_scan.c::scsi_alloc_sdev()
-	   else we cannot ever have ANY SCSI devices.
-	*/
-	SDpnt->current_queue_depth = 1;
-
 	spin_unlock_irqrestore(&device_request_lock, flags);
 }
 
@@ -1860,28 +1641,6 @@
  */
 int scsi_slave_attach(struct scsi_device *sdev)
 {
-	/* all this code is now handled elsewhere 
-	if (sdev->attached++ == 0) {
-		scsi_build_commandblocks(sdev);
-		if (sdev->current_queue_depth == 0) {
-			printk(KERN_ERR "scsi: Allocation failure during"
-			       " attach, some SCSI devices might not be"
-			       " configured\n");
-			return -ENOMEM;
-		}
-		if (sdev->host->hostt->slave_configure != NULL) {
-			if (sdev->host->hostt->slave_configure(sdev) != 0) {
-				printk(KERN_INFO "scsi: failed low level driver"
-				       " attach, some SCSI device might not be"
-				       " configured\n");
-				scsi_release_commandblocks(sdev);
-				return -ENOMEM;
-			}
-		} else if (sdev->host->cmd_per_lun != 0)
-			scsi_adjust_queue_depth(sdev, 0,
-						sdev->host->cmd_per_lun);
-	}
-		 */
 	sdev->attached++;
 	return 0;
 }
@@ -1898,11 +1657,6 @@
  */
 void scsi_slave_detach(struct scsi_device *sdev)
 {
-	/*
-	if (--sdev->attached == 0) {
-		scsi_release_commandblocks(sdev);
-	}
-	*/
 	sdev->attached--;
 }
 /*
@@ -1952,18 +1706,16 @@
 {
 	Scsi_Device *SDpnt;
 	struct Scsi_Host *shpnt;
-	struct list_head spnt, *prev_spnt;
-	
 
 	/*
 	 * Next, detach the devices from the driver.
 	 */
-
 	for (shpnt = scsi_host_get_next(NULL); shpnt;
 	     shpnt = scsi_host_get_next(shpnt)) {
 		list_for_each_entry(SDpnt, &shpnt->my_devices, siblings)
 			(*tpnt->detach) (SDpnt);
 	}
+
 	/*
 	 * Extract the template from the linked list.
 	 */
@@ -1972,11 +1724,6 @@
 	up_write(&scsi_devicelist_mutex);
 
 	scsi_upper_driver_unregister(tpnt);
-
-	/*
-	 * Final cleanup for the driver is done in the driver sources in the
-	 * cleanup function.
-	 */
 	return 0;
 }
 
@@ -2019,18 +1766,9 @@
 
 #endif
 
+/* FIXME(hch): add proper error handling */
 static int __init init_scsi(void)
 {
-	printk(KERN_INFO "SCSI subsystem driver " REVISION "\n");
-
-	scsi_core = kmalloc(sizeof(*scsi_core), GFP_KERNEL);
-	if (!scsi_core)
-		goto out_no_mem;
-	memset(scsi_core, 0, sizeof(*scsi_core));
-	
-	if (scsi_create_cmdcache(scsi_core))
-		goto out_no_mem;
-
 	scsi_init_queue();
 	scsi_init_procfs();
 	devfs_mk_dir(NULL, "scsi", NULL);
@@ -2039,10 +1777,6 @@
 	scsi_sysfs_register();
 	open_softirq(SCSI_SOFTIRQ, scsi_softirq, NULL);
 	return 0;
-
-out_no_mem:
-	printk(KERN_CRIT "Couldn't load SCSI Core -- out of memory!\n");
-	return -ENOMEM;
 }
 
 static void __exit exit_scsi(void)
@@ -2052,12 +1786,6 @@
 	devfs_remove("scsi");
 	scsi_exit_procfs();
 	scsi_exit_queue();
-
-	scsi_destroy_cmdcache(scsi_core);
-
-	if (scsi_core)
-		kfree(scsi_core);
-	scsi_core = NULL;
 }
 
 subsys_initcall(init_scsi);
===== drivers/scsi/scsi.h 1.57 vs edited =====
--- 1.57/drivers/scsi/scsi.h	Mon Jan 13 23:24:00 2003
+++ edited/drivers/scsi/scsi.h	Tue Feb  4 15:49:51 2003
@@ -446,8 +446,10 @@
  * Prototypes for functions in scsi.c
  */
 extern int scsi_dispatch_cmd(Scsi_Cmnd * SCpnt);
-extern void scsi_release_commandblocks(Scsi_Device * SDpnt);
-extern void scsi_build_commandblocks(Scsi_Device * SDpnt);
+extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
+extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
+extern struct scsi_cmnd *scsi_get_command(struct scsi_device *dev, int flags);
+extern void scsi_put_command(struct scsi_cmnd *cmd);
 extern void scsi_adjust_queue_depth(Scsi_Device *, int, int);
 extern int scsi_track_queue_full(Scsi_Device *, int);
 extern int scsi_slave_attach(struct scsi_device *);
@@ -458,13 +460,10 @@
 extern void scsi_finish_command(Scsi_Cmnd *);
 extern int scsi_retry_command(Scsi_Cmnd *);
 extern Scsi_Cmnd *scsi_allocate_device(Scsi_Device *, int);
-extern void __scsi_release_command(Scsi_Cmnd *);
-extern void scsi_release_command(Scsi_Cmnd *);
 extern void scsi_do_cmd(Scsi_Cmnd *, const void *cmnd,
 			void *buffer, unsigned bufflen,
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
-extern int scsi_mlqueue_insert(struct scsi_cmnd *, int);
 extern int scsi_attach_device(struct scsi_device *);
 extern void scsi_detach_device(struct scsi_device *);
 extern int scsi_get_device_flags(unsigned char *vendor, unsigned char *model);
@@ -582,7 +581,6 @@
 	struct list_head busy_cmnds;    /* list of Scsi_Cmnd structs in use */
 	Scsi_Cmnd *device_queue;	/* queue of SCSI Command structures */
         Scsi_Cmnd *current_cmnd;	/* currently active command */
-	unsigned short current_queue_depth;/* How deep of a queue we have */
 	unsigned short new_queue_depth; /* How deep of a queue we want */
 	unsigned short last_queue_full_depth; /* These two are used by */
 	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
@@ -770,15 +768,6 @@
 	unsigned volatile char internal_timeout;
 	struct scsi_cmnd *bh_next;	/* To enumerate the commands waiting 
 					   to be processed. */
-
-/* OBSOLETE, please do not use -- obosolete stuff. */
-/* Use cmd->device->{id, channel, lun} instead */
-/* 	unsigned int target; */
-/* 	unsigned int lun; */
-/* 	unsigned int channel; */
-/* OBSOLETE, use cmd->device->host instead */	
-/* 	struct Scsi_Host   *host; */
-
 	unsigned char cmd_len;
 	unsigned char old_cmd_len;
 	unsigned char sc_data_direction;
@@ -995,45 +984,4 @@
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
 
-/* -------------------------------------------------- */
-/* data decl: */
-
-/* All the SCSI Core specific global data, etc,
-   should go in here.
-*/
-
-struct scsi_core_data {
-	kmem_cache_t   *scsi_cmd_cache;
-	kmem_cache_t   *scsi_cmd_dma_cache;
-};
-
-extern struct scsi_core_data *scsi_core;
-
-/* -------------------------------------------------- */
-/* fn decl: */
-
-int scsi_create_cmdcache(struct scsi_core_data *scsi_core);
-int scsi_destroy_cmdcache(struct scsi_core_data *scsi_core);
-
-struct scsi_cmnd * scsi_get_command(struct Scsi_Host *host, int alloc_flags);
-void scsi_put_command(struct scsi_cmnd *cmd);
-void scsi_setup_command(struct scsi_device *dev, struct scsi_cmnd *cmd);
-
-/* -------------------------------------------------- */
-/* inline funcs: */
-
-/* scsi_getset_command: allocate, set and return a command struct,
-   when the device is known.
-*/
-static inline struct scsi_cmnd *scsi_getset_command(struct scsi_device *dev,
-						    int flags)
-{
-	struct scsi_cmnd *cmd;
-
-	if (!dev) return NULL;
-	if (!dev->host) return NULL;
-	scsi_setup_command(dev, (cmd = scsi_get_command(dev->host, flags)));
-	return cmd;
-}				
-
-#endif
+#endif /* _SCSI_H */
===== drivers/scsi/scsi_lib.c 1.64 vs edited =====
--- 1.64/drivers/scsi/scsi_lib.c	Tue Jan 28 23:09:29 2003
+++ edited/drivers/scsi/scsi_lib.c	Tue Feb  4 15:47:36 2003
@@ -35,8 +35,6 @@
 }; 	
 #undef SP
 
-struct scsi_core_data *scsi_core;
-
 /*
  * Function:    scsi_insert_special_cmd()
  *
@@ -815,8 +813,7 @@
 		SRpnt = (Scsi_Request *) req->special;
 		
 		if( SRpnt->sr_magic == SCSI_REQ_MAGIC ) {
-			SCpnt = scsi_getset_command(SRpnt->sr_device,
-						    GFP_ATOMIC);
+			SCpnt = scsi_get_command(SRpnt->sr_device, GFP_ATOMIC);
 			if (!SCpnt)
 				return BLKPREP_DEFER;
 			scsi_init_cmd_from_req(SCpnt, SRpnt);
@@ -829,7 +826,7 @@
 		if (req->special) {
 			SCpnt = (Scsi_Cmnd *) req->special;
 		} else {
-			SCpnt = scsi_getset_command(SDpnt, GFP_ATOMIC);
+			SCpnt = scsi_get_command(SDpnt, GFP_ATOMIC);
 		}
 		/*
 		 * if command allocation failure, wait a bit
@@ -1195,143 +1192,3 @@
 		kmem_cache_destroy(sgp->slab);
 	}
 }
-
-/* -------------------------------------------------- */
-
-int scsi_create_cmdcache(struct scsi_core_data *scsi_core)
-{
-	if (!scsi_core)
-		return -EFAULT;
-
-	scsi_core->scsi_cmd_cache
-		= kmem_cache_create("scsi_cmd_cache",
-				    sizeof(struct scsi_cmnd), 0,
-				    SLAB_NO_REAP|SLAB_HWCACHE_ALIGN,NULL,NULL);
-	if (!scsi_core->scsi_cmd_cache)
-		return -ENOMEM;
-
-	scsi_core->scsi_cmd_dma_cache
-		= kmem_cache_create("scsi_cmd_cache(DMA)",
-				    sizeof(struct scsi_cmnd), 0,
-				    SLAB_NO_REAP|SLAB_HWCACHE_ALIGN
-				    |SLAB_CACHE_DMA,
-				    NULL,NULL);
-	if (!scsi_core->scsi_cmd_dma_cache) {
-		scsi_destroy_cmdcache(scsi_core);
-		return -ENOMEM;
-	}
-	return 0;
-} /* end scsi_create_cmdcache() */
-
-/* -------------------------------------------------- */
-
-int scsi_destroy_cmdcache(struct scsi_core_data *scsi_core)
-{
-	if (!scsi_core)
-		return -EFAULT;
-
-	if (scsi_core->scsi_cmd_cache &&
-	    kmem_cache_destroy(scsi_core->scsi_cmd_cache)) {
-		goto bail;
-	} else {
-		scsi_core->scsi_cmd_cache = NULL;
-	}
-
-	if (scsi_core->scsi_cmd_dma_cache &&
-	    kmem_cache_destroy(scsi_core->scsi_cmd_dma_cache)) {
-		goto bail;
-	} else {
-		scsi_core->scsi_cmd_dma_cache = NULL;
-	}
-		
-	return 0;
-bail:
-	printk(KERN_CRIT "Failed to free scsi command cache"
-	       " -- memory leak\n");
-	return -EFAULT;
-} /* end scsi_destroy_cmdcache() */
-
-/* -------------------------------------------------- */
-
-struct scsi_cmnd * scsi_get_command(struct Scsi_Host *host, int alloc_flags)
-{
-	unsigned long flags;
-	struct scsi_cmnd *cmd = NULL;
-	
-	if (!host)
-		return NULL;
-
-	if (host->unchecked_isa_dma) {
-		cmd = kmem_cache_alloc(scsi_core->scsi_cmd_dma_cache,
-				       alloc_flags);
-	} else {
-		cmd = kmem_cache_alloc(scsi_core->scsi_cmd_cache, alloc_flags);
-	}
-
-	if (!cmd) {
-		spin_lock_irqsave(&host->free_list_lock, flags);
-		if (!list_empty(&host->free_list)) {
-			cmd = list_entry(host->free_list.next,
-					 struct scsi_cmnd, list);
-			list_del_init(&cmd->list);
-		}
-		spin_unlock_irqrestore(&host->free_list_lock, flags);
-	}
-
-	return cmd;
-} /* end scsi_get_command() */
-
-/* -------------------------------------------------- */
-/* scsi_put_command: free a scsi_cmnd struct.
-   Note: the command must not belong to any lists!
-*/
-void scsi_put_command(struct scsi_cmnd *cmd)
-{
-	unsigned long flags;
-	struct Scsi_Host *host;
-	
-	if (!cmd)
-		return;
-
-	if (!cmd->device || !cmd->device->host) {
-		printk(KERN_NOTICE "Trying to free a command which"
-		       " doesn't belong to scsi core?!\n");
-		 /* Memory leak, but let the system survive for now --
-		    they'll get it eventually! */
-		return;
-	}
-
-	host = cmd->device->host;
-
-	spin_lock_irqsave(&host->free_list_lock, flags);
-	if (list_empty(&host->free_list)) {
-		list_add(&cmd->list, &host->free_list);
-		cmd = NULL;
-	}
-	spin_unlock_irqrestore(&host->free_list_lock, flags);
-
-	if (cmd) {
-		if (host->unchecked_isa_dma)
-			kmem_cache_free(scsi_core->scsi_cmd_dma_cache, cmd);
-		else
-			kmem_cache_free(scsi_core->scsi_cmd_cache, cmd);
-	}
-} /* end scsi_put_command() */
-
-/* -------------------------------------------------- */
-/* scsi_setup_command: This will do post-alloc init of the command.
-   We want to do as little as possible here.
-*/
-void scsi_setup_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
-{
-	if (!cmd)
-		return;
-	memset(cmd, 0, sizeof(*cmd));
-	cmd->device = dev;
-	cmd->state = SCSI_STATE_UNUSED;
-	cmd->owner = SCSI_OWNER_NOBODY;
-	init_timer(&cmd->eh_timeout);
-	INIT_LIST_HEAD(&cmd->list);
-} /* end scsi_setup_command() */
-
-/* -------------------------------------------------- */
===== drivers/scsi/scsi_scan.c 1.55 vs edited =====
--- 1.55/drivers/scsi/scsi_scan.c	Tue Jan 28 17:52:51 2003
+++ edited/drivers/scsi/scsi_scan.c	Tue Feb  4 15:40:43 2003
@@ -471,9 +471,6 @@
 
 		sdev->request_queue->queuedata = sdev;
 		scsi_adjust_queue_depth(sdev, 0, sdev->host->cmd_per_lun);
-		if (sdev->current_queue_depth == 0) {
-			goto out_bail;
-		}
 		init_waitqueue_head(&sdev->scpnt_wait);
 
 		if (shost->hostt->slave_alloc)
===== drivers/scsi/scsi_syms.c 1.25 vs edited =====
--- 1.25/drivers/scsi/scsi_syms.c	Tue Jan 14 22:57:30 2003
+++ edited/drivers/scsi/scsi_syms.c	Thu Jan 30 16:16:07 2003
@@ -81,6 +81,9 @@
 EXPORT_SYMBOL(scsi_slave_detach);
 EXPORT_SYMBOL(scsi_device_get);
 EXPORT_SYMBOL(scsi_device_put);
+EXPORT_SYMBOL(scsi_get_command);
+EXPORT_SYMBOL(scsi_put_command);
+
 
 /*
  * This symbol is for the highlevel drivers (e.g. sg) only.
@@ -112,8 +115,3 @@
  * sysfs support
  */
 EXPORT_SYMBOL(shost_devclass);
-
-EXPORT_SYMBOL(scsi_get_command);
-EXPORT_SYMBOL(scsi_put_command);
-EXPORT_SYMBOL(scsi_setup_command);
-
===== drivers/scsi/scsi_sysfs.c 1.5 vs edited =====
--- 1.5/drivers/scsi/scsi_sysfs.c	Tue Jan 14 01:00:24 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Tue Feb  4 15:41:53 2003
@@ -210,7 +210,6 @@
  * Create the actual show/store functions and data structures.
  */
 sdev_rd_attr (device_blocked, "%d\n");
-sdev_rd_attr (current_queue_depth, "%d\n");
 sdev_rd_attr (new_queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
@@ -222,7 +221,6 @@
 
 static struct device_attribute * const sdev_attrs[] = {
 	&dev_attr_device_blocked,
-	&dev_attr_current_queue_depth,
 	&dev_attr_new_queue_depth,
 	&dev_attr_type,
 	&dev_attr_scsi_level,
