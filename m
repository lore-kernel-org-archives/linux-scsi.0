From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] rationalize allocation and freeing of struct scsi_device
Date: Sun, 17 Nov 2002 23:49:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021117234901.A9784@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Currently allocation and freeing of struct scsi_device is a mess.
We have two nice functions in scsi_scan.c (scsi_allocate_sdev/
scsi_free_sdev) that are the right interfaces to deal with it, so I moved
them to scsi and made them non-static.  I've changed all functions
allocation freeing them to use it.


--- 1.29/drivers/scsi/hosts.c	Sat Nov 16 20:26:02 2002
+++ edited/drivers/scsi/hosts.c	Sun Nov 17 21:47:02 2002
@ -289,17 +289,8 @@
 		device_unregister(&sdev->sdev_driverfs_dev);
 	}
 
-	/* Next we free up the Scsi_Cmnd structures for this host */
-
-	for (sdev = shost->host_queue; sdev;
-	     sdev = shost->host_queue) {
-		blk_cleanup_queue(&sdev->request_queue);
-		/* Next free up the Scsi_Device structures for this host */
-		shost->host_queue = sdev->next;
-		if (sdev->inquiry)
-			kfree(sdev->inquiry);
-		kfree(sdev);
-	}
+	for (sdev = shost->host_queue; sdev; sdev = shost->host_queue)
+		scsi_free_sdev(sdev);
 
 	return 0;
 }
@@ -677,6 +675,67 @@
 		if (shost_hn)
 			shost_hn++;
 	}
+}
+
+/*
+ * Function:    scsi_get_host_dev()
+ *
+ * Purpose:     Create a Scsi_Device that points to the host adapter itself.
+ *
+ * Arguments:   SHpnt   - Host that needs a Scsi_Device
+ *
+ * Lock status: None assumed.
+ *
+ * Returns:     The Scsi_Device or NULL
+ *
+ * Notes:
+ *	Attach a single Scsi_Device to the Scsi_Host - this should
+ *	be made to look like a "pseudo-device" that points to the
+ *	HA itself.  For the moment, we include it at the head of
+ *	the host_queue itself - I don't think we want to show this
+ *	to the HA in select_queue_depths(), as this would probably confuse
+ *	matters.
+ *
+ *	Note - this device is not accessible from any high-level
+ *	drivers (including generics), which is probably not
+ *	optimal.  We can add hooks later to attach 
+ */
+struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	sdev = scsi_alloc_sdev(shost, 0, shost->this_id, 0);
+	if (sdev) {
+		scsi_build_commandblocks(sdev);
+		if (sdev->current_queue_depth == 0)
+			goto fail;
+		sdev->borken = 0;
+	}
+
+	return sdev;
+
+fail:
+	kfree(sdev);
+	return NULL;
+}
+
+/*
+ * Function:    scsi_free_host_dev()
+ *
+ * Purpose:     Free a scsi_device that points to the host adapter itself.
+ *
+ * Arguments:   SHpnt   - Host that needs a Scsi_Device
+ *
+ * Lock status: None assumed.
+ *
+ * Returns:     Nothing
+ *
+ * Notes:
+ */
+void scsi_free_host_dev(struct scsi_device *sdev)
+{
+	BUG_ON(sdev->id != sdev->host->this_id);
+	scsi_free_sdev(sdev);
 }
 
 void scsi_host_busy_inc(struct Scsi_Host *shost, Scsi_Device *sdev)
--- 1.63/drivers/scsi/scsi.c	Sat Nov 16 14:53:49 2002
+++ edited/drivers/scsi/scsi.c	Sun Nov 17 22:39:03 2002
@@ -155,7 +155,6 @@
 	"Enclosure        ",
 };
 
-static char * scsi_null_device_strs = "nullnullnullnull";
 static const char * const spaces = "                "; /* 16 of them */
 
 static unsigned scsi_default_dev_flags;
@@ -2266,95 +2265,3 @@
 
 module_init(init_scsi);
 module_exit(exit_scsi);
-
-/*
- * Function:    scsi_get_host_dev()
- *
- * Purpose:     Create a Scsi_Device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a Scsi_Device
- *
- * Lock status: None assumed.
- *
- * Returns:     The Scsi_Device or NULL
- *
- * Notes:
- */
-Scsi_Device * scsi_get_host_dev(struct Scsi_Host * SHpnt)
-{
-        Scsi_Device * SDpnt;
-
-        /*
-         * Attach a single Scsi_Device to the Scsi_Host - this should
-         * be made to look like a "pseudo-device" that points to the
-         * HA itself.  For the moment, we include it at the head of
-         * the host_queue itself - I don't think we want to show this
-         * to the HA in select_queue_depths(), as this would probably confuse
-         * matters.
-         * Note - this device is not accessible from any high-level
-         * drivers (including generics), which is probably not
-         * optimal.  We can add hooks later to attach 
-         */
-        SDpnt = (Scsi_Device *) kmalloc(sizeof(Scsi_Device),
-                                        GFP_ATOMIC);
-        if(SDpnt == NULL)
-        	return NULL;
-        	
-        memset(SDpnt, 0, sizeof(Scsi_Device));
-	SDpnt->vendor = scsi_null_device_strs;
-	SDpnt->model = scsi_null_device_strs;
-	SDpnt->rev = scsi_null_device_strs;
-
-        SDpnt->host = SHpnt;
-        SDpnt->id = SHpnt->this_id;
-        SDpnt->type = -1;
-	SDpnt->new_queue_depth = 1;
-        
-	scsi_build_commandblocks(SDpnt);
-	if(SDpnt->current_queue_depth == 0) {
-		kfree(SDpnt);
-		return NULL;
-	}
-
-	scsi_initialize_queue(SDpnt, SHpnt);
-
-	SDpnt->online = TRUE;
-
-        /*
-         * Initialize the object that we will use to wait for command blocks.
-         */
-	init_waitqueue_head(&SDpnt->scpnt_wait);
-        return SDpnt;
-}
-
-/*
- * Function:    scsi_free_host_dev()
- *
- * Purpose:     Create a Scsi_Device that points to the host adapter itself.
- *
- * Arguments:   SHpnt   - Host that needs a Scsi_Device
- *
- * Lock status: None assumed.
- *
- * Returns:     Nothing
- *
- * Notes:
- */
-void scsi_free_host_dev(Scsi_Device * SDpnt)
-{
-        if( (unsigned char) SDpnt->id != (unsigned char) SDpnt->host->this_id )
-        {
-                panic("Attempt to delete wrong device\n");
-        }
-
-        blk_cleanup_queue(&SDpnt->request_queue);
-
-        /*
-         * We only have a single SCpnt attached to this device.  Free
-         * it now.
-         */
-	scsi_release_commandblocks(SDpnt);
-	if (SDpnt->inquiry)
-		kfree(SDpnt->inquiry);
-        kfree(SDpnt);
-}
===== drivers/scsi/scsi.h 1.41 vs edited =====
--- 1.41/drivers/scsi/scsi.h	Sat Nov 16 20:26:02 2002
+++ edited/drivers/scsi/scsi.h	Sun Nov 17 21:44:35 2002
@@ -516,6 +516,13 @@
 static inline void scsi_proc_host_add(struct Scsi_Host *);
 static inline void scsi_proc_host_rm(struct Scsi_Host *);
 #endif /* CONFIG_PROC_FS */
+
+/*
+ * Prototypes for functions in scsi_scan.c
+ */
+extern struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *,
+			uint, uint, uint);
+extern void scsi_free_sdev(struct scsi_device *);
 
 /*
  * Prototypes for functions in constants.c
--- 1.8/drivers/scsi/scsi_proc.c	Sat Nov 16 20:26:02 2002
+++ edited/drivers/scsi/scsi_proc.c	Sun Nov 17 21:49:06 2002
@@ -607,25 +607,9 @@
 
 		if (sdev->attached == 0) {
 			devfs_unregister (sdev->de);
-
-			/* Now we can remove the device structure */
-			if (sdev->next != NULL)
-				sdev->next->prev = sdev->prev;
-
-			if (sdev->prev != NULL)
-				sdev->prev->next = sdev->next;
-
-			if (shost->host_queue == sdev) {
-				shost->host_queue = sdev->next;
-			}
-			blk_cleanup_queue(&sdev->request_queue);
-			if (sdev->inquiry)
-				kfree(sdev->inquiry);
-			kfree((char *) sdev);
-		} else {
-			goto out;
+			scsi_free_sdev(sdev);
+			err = 0;
 		}
-		err = 0;
 	}
 out:
 	
--- 1.36/drivers/scsi/scsi_scan.c	Sat Nov 16 18:56:15 2002
+++ edited/drivers/scsi/scsi_scan.c	Sun Nov 17 21:47:20 2002
@@ -465,12 +465,12 @@
  * Return value:
  *     Scsi_Device pointer, or NULL on failure.
  **/
-static Scsi_Device *scsi_alloc_sdev(struct Scsi_Host *shost, uint channel,
+struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *shost, uint channel,
 				    uint id, uint lun)
 {
-	Scsi_Device *sdev;
+	struct scsi_device *sdev;
 
-	sdev = (Scsi_Device *) kmalloc(sizeof(Scsi_Device), GFP_ATOMIC);
+	sdev = kmalloc(sizeof(*sdev), GFP_ATOMIC);
 	if (sdev == NULL)
 		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	else {
@@ -522,7 +522,7 @@
  *     Undo the actions in scsi_alloc_sdev, including removing @sdev from
  *     the list, and freeing @sdev.
  **/
-static void scsi_free_sdev(Scsi_Device *sdev)
+void scsi_free_sdev(struct scsi_device *sdev)
 {
 	if (sdev->prev != NULL)
 		sdev->prev->next = sdev->next;
