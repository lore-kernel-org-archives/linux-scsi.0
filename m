From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] rationalize allocation and freeing of struct scsi_device
Date: Sat, 9 Nov 2002 01:57:10 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021109015710.A23795@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Currently allocation and freeing of struct scsi_device is a mess.
We have two nice functions in scsi_scan.c (scsi_allocate_sdev/
scsi_free_sdev) that are the right interfaces to deal with it, so I mov=
ed
them to scsi and made them non-static.  I've changed all functions
allocation freeing them to use it.  There's also a new helper
scsi_release_sdev that deals with getting rid of a currently
attached sdev.


--- 1.23/drivers/scsi/hosts.c	Tue Nov  5 12:18:22 2002
+++ edited/drivers/scsi/hosts.c	Fri Nov  8 20:11:00 2002
@@ -182,33 +182,13 @@
 		}
 	}
=20
-	/*
-	 * Next we detach the high level drivers from the Scsi_Device
-	 * structures
-	 */
-	for (sdev =3D shost->host_queue; sdev; sdev =3D sdev->next) {
-		scsi_detach_device(sdev);
-
+	for (sdev =3D shost->host_queue; sdev; sdev =3D shost->host_queue) {
 		/* If something still attached, punt */
-		if (sdev->attached) {
+		if (scsi_release_sdev(sdev)) {
 			printk(KERN_ERR "Attached usage count =3D %d\n",
 			       sdev->attached);
 			return 1;
 		}
-		devfs_unregister(sdev->de);
-		device_unregister(&sdev->sdev_driverfs_dev);
-	}
-
-	/* Next we free up the Scsi_Cmnd structures for this host */
-
-	for (sdev =3D shost->host_queue; sdev;
-	     sdev =3D shost->host_queue) {
-		blk_cleanup_queue(&sdev->request_queue);
-		/* Next free up the Scsi_Device structures for this host */
-		shost->host_queue =3D sdev->next;
-		if (sdev->inquiry)
-			kfree(sdev->inquiry);
-		kfree(sdev);
 	}
=20
 	return 0;
=3D=3D=3D=3D=3D drivers/scsi/scsi.c 1.59 vs edited =3D=3D=3D=3D=3D
--- 1.59/drivers/scsi/scsi.c	Wed Nov  6 21:10:15 2002
+++ edited/drivers/scsi/scsi.c	Fri Nov  8 20:11:43 2002
@@ -1926,31 +1926,9 @@
 			goto out;	/* there is no such device attached */
=20
 		err =3D -EBUSY;
-		if (scd->access_count)
+		if (scsi_release_sdev(scd))
 			goto out;
=20
-		scsi_detach_device(scd);
-
-		if (scd->attached =3D=3D 0) {
-			devfs_unregister (scd->de);
-
-			/* Now we can remove the device structure */
-			if (scd->next !=3D NULL)
-				scd->next->prev =3D scd->prev;
-
-			if (scd->prev !=3D NULL)
-				scd->prev->next =3D scd->next;
-
-			if (HBA_ptr->host_queue =3D=3D scd) {
-				HBA_ptr->host_queue =3D scd->next;
-			}
-			blk_cleanup_queue(&scd->request_queue);
-			if (scd->inquiry)
-				kfree(scd->inquiry);
-			kfree((char *) scd);
-		} else {
-			goto out;
-		}
 		err =3D 0;
 	}
 out:
@@ -1960,6 +1938,138 @@
 }
 #endif
=20
+/**
+ * scsi_initialize_merge_fn() -=C6=A3initialize merge function for a h=
ost
+ * @sd:		host descriptor
+ */
+static void scsi_initialize_merge_fn(struct scsi_device *sd)
+{
+	request_queue_t *q =3D &sd->request_queue;
+	struct Scsi_Host *sh =3D sd->host;
+	u64 bounce_limit;
+
+	if (sh->highmem_io) {
+		if (sh->pci_dev && PCI_DMA_BUS_IS_PHYS) {
+			bounce_limit =3D sh->pci_dev->dma_mask;
+		} else {
+			/*
+			 * Platforms with virtual-DMA translation
+ 			 * hardware have no practical limit.
+			 */
+			bounce_limit =3D BLK_BOUNCE_ANY;
+		}
+	} else if (sh->unchecked_isa_dma) {
+		bounce_limit =3D BLK_BOUNCE_ISA;
+	} else {
+		bounce_limit =3D BLK_BOUNCE_HIGH;
+	}
+
+	blk_queue_bounce_limit(q, bounce_limit);
+}
+
+/**
+ * scsi_alloc_sdev - allocate and setup a Scsi_Device
+ *
+ * Description:
+ *     Allocate, initialize for io, and return a pointer to a Scsi_Dev=
ice.
+ *     Stores the @shost, @channel, @id, and @lun in the Scsi_Device, =
and
+ *     adds Scsi_Device to the appropriate list.
+ *
+ * Return value:
+ *     Scsi_Device pointer, or NULL on failure.
+ **/
+struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *shost,
+				    uint channel, uint id, uint lun)
+{
+	struct scsi_device *sdev;
+
+	sdev =3D kmalloc(sizeof(Scsi_Device), GFP_ATOMIC);
+	if (!sdev) {
+		printk(KERN_ERR "%s: Allocation failure during SCSI "
+				"scanning, some SCSI devices might not "
+				"be configured\n", __FUNCTION__);
+		return NULL;
+	}
+
+	memset(sdev, 0, sizeof(Scsi_Device));
+	sdev->vendor =3D scsi_null_device_strs;
+	sdev->model =3D scsi_null_device_strs;
+	sdev->rev =3D scsi_null_device_strs;
+	sdev->host =3D shost;
+	sdev->id =3D id;
+	sdev->lun =3D lun;
+	sdev->channel =3D channel;
+	sdev->online =3D TRUE;
+
+	/*
+	 * Some low level driver could use device->type
+	 */
+	sdev->type =3D -1;
+
+	/*
+	 * Assume that the device will have handshaking problems,
+	 * and then fix this field later if it turns out it
+	 * doesn't
+	 */
+	sdev->borken =3D 1;
+	scsi_initialize_queue(sdev, shost);
+	sdev->request_queue.queuedata =3D sdev;
+
+	scsi_initialize_merge_fn(sdev);
+	init_waitqueue_head(&sdev->scpnt_wait);
+
+	/*
+	 * Add it to the end of the shost->host_queue list.
+	 */
+	if (shost->host_queue !=3D NULL) {
+		sdev->prev =3D shost->host_queue;
+		while (sdev->prev->next !=3D NULL)
+			sdev->prev =3D sdev->prev->next;
+		sdev->prev->next =3D sdev;
+	} else
+		shost->host_queue =3D sdev;
+
+	return sdev;
+}
+
+/**
+ * scsi_free_sdev - cleanup and free a Scsi_Device
+ * @sdev:	cleanup and free this Scsi_Device
+ *
+ * Description:
+ *	Undo the actions in scsi_alloc_sdev, including removing @sdev from
+ *	the list, and freeing @sdev.
+ **/
+void scsi_free_sdev(struct scsi_device *sdev)
+{
+	if (sdev->next)
+		sdev->next->prev =3D sdev->prev;
+	if (sdev->prev)
+		sdev->prev->next =3D sdev->next;
+	else
+		sdev->host->host_queue =3D sdev->next;
+
+	blk_cleanup_queue(&sdev->request_queue);
+	kfree(sdev->inquiry);
+	kfree(sdev);
+}
+
+int scsi_release_sdev(struct scsi_device *sdev)
+{
+	if (sdev->access_count)
+		return -EBUSY;
+
+	scsi_detach_device(sdev);
+	if (sdev->attached)
+		return -EBUSY;
+
+	devfs_unregister(sdev->de);
+	device_unregister(&sdev->sdev_driverfs_dev);
+
+	scsi_free_sdev(sdev);
+	return 0;
+}
+
 int scsi_attach_device(struct scsi_device *sdev)
 {
 	struct Scsi_Device_Template *sdt;
@@ -2429,58 +2539,40 @@
  * Returns:     The Scsi_Device or NULL
  *
  * Notes:
+ *	Attach a single Scsi_Device to the Scsi_Host - this should
+ *	be made to look like a "pseudo-device" that points to the
+ *	HA itself.  For the moment, we include it at the head of
+ *	the host_queue itself - I don't think we want to show this
+ *	to the HA in select_queue_depths(), as this would probably confuse
+ *	matters.
+ *
+ *	Note - this device is not accessible from any high-level
+ *	drivers (including generics), which is probably not
+ *	optimal.  We can add hooks later to attach=20
  */
-Scsi_Device * scsi_get_host_dev(struct Scsi_Host * SHpnt)
+struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
 {
-        Scsi_Device * SDpnt;
+	struct scsi_device *sdev;
=20
-        /*
-         * Attach a single Scsi_Device to the Scsi_Host - this should
-         * be made to look like a "pseudo-device" that points to the
-         * HA itself.  For the moment, we include it at the head of
-         * the host_queue itself - I don't think we want to show this
-         * to the HA in select_queue_depths(), as this would probably =
confuse
-         * matters.
-         * Note - this device is not accessible from any high-level
-         * drivers (including generics), which is probably not
-         * optimal.  We can add hooks later to attach=20
-         */
-        SDpnt =3D (Scsi_Device *) kmalloc(sizeof(Scsi_Device),
-                                        GFP_ATOMIC);
-        if(SDpnt =3D=3D NULL)
-        	return NULL;
-        =09
-        memset(SDpnt, 0, sizeof(Scsi_Device));
-	SDpnt->vendor =3D scsi_null_device_strs;
-	SDpnt->model =3D scsi_null_device_strs;
-	SDpnt->rev =3D scsi_null_device_strs;
-
-        SDpnt->host =3D SHpnt;
-        SDpnt->id =3D SHpnt->this_id;
-        SDpnt->type =3D -1;
-	SDpnt->new_queue_depth =3D 1;
-       =20
-	scsi_build_commandblocks(SDpnt);
-	if(SDpnt->current_queue_depth =3D=3D 0) {
-		kfree(SDpnt);
-		return NULL;
+	sdev =3D scsi_alloc_sdev(shost, 0, shost->this_id, 0);
+	if (sdev) {
+		scsi_build_commandblocks(sdev);
+		if (sdev->current_queue_depth =3D=3D 0)
+			goto fail;
+		sdev->borken =3D 0;
 	}
=20
-	scsi_initialize_queue(SDpnt, SHpnt);
+	return sdev;
=20
-	SDpnt->online =3D TRUE;
-
-        /*
-         * Initialize the object that we will use to wait for command =
blocks.
-         */
-	init_waitqueue_head(&SDpnt->scpnt_wait);
-        return SDpnt;
+fail:
+	kfree(sdev);
+	return NULL;
 }
=20
 /*
  * Function:    scsi_free_host_dev()
  *
- * Purpose:     Create a Scsi_Device that points to the host adapter i=
tself.
+ * Purpose:     Free a scsi_device that points to the host adapter its=
elf.
  *
  * Arguments:   SHpnt   - Host that needs a Scsi_Device
  *
@@ -2490,23 +2582,10 @@
  *
  * Notes:
  */
-void scsi_free_host_dev(Scsi_Device * SDpnt)
+void scsi_free_host_dev(struct scsi_device *sdev)
 {
-        if( (unsigned char) SDpnt->id !=3D (unsigned char) SDpnt->host=
->this_id )
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
+	BUG_ON(sdev->id !=3D sdev->host->this_id);
+	scsi_free_sdev(sdev);
 }
=20
 /*
=3D=3D=3D=3D=3D drivers/scsi/scsi.h 1.36 vs edited =3D=3D=3D=3D=3D
--- 1.36/drivers/scsi/scsi.h	Wed Nov  6 21:08:24 2002
+++ edited/drivers/scsi/scsi.h	Fri Nov  8 20:11:52 2002
@@ -397,6 +397,8 @@
 typedef struct scsi_cmnd Scsi_Cmnd;
 typedef struct scsi_request Scsi_Request;
=20
+struct Scsi_Host;
+
 #define SCSI_CMND_MAGIC 0xE25C23A5
 #define SCSI_REQ_MAGIC  0x75F6D354
=20
@@ -483,6 +485,10 @@
 extern int scsi_mlqueue_insert(struct scsi_cmnd *, int);
 extern int scsi_attach_device(struct scsi_device *);
 extern void scsi_detach_device(struct scsi_device *);
+extern struct scsi_device *scsi_alloc_sdev(struct Scsi_Host *,
+			uint, uint, uint);
+extern void scsi_free_sdev(struct scsi_device *);
+extern int scsi_release_sdev(struct scsi_device *);
=20
 /*
  * Newer request-based interfaces.
=3D=3D=3D=3D=3D drivers/scsi/scsi_scan.c 1.34 vs edited =3D=3D=3D=3D=3D
--- 1.34/drivers/scsi/scsi_scan.c	Wed Nov  6 21:08:41 2002
+++ edited/drivers/scsi/scsi_scan.c	Fri Nov  8 04:57:45 2002
@@ -210,8 +210,6 @@
 #define SCSI_SCAN_TARGET_PRESENT	1
 #define SCSI_SCAN_LUN_PRESENT		2
=20
-static char *scsi_null_device_strs =3D "nullnullnullnull";
-
 #define MAX_SCSI_LUNS	512
=20
 #ifdef CONFIG_SCSI_MULTI_LUN
@@ -480,118 +478,6 @@
 		return device_list[i].flags;
 	}
 	return 0;
-}
-
-/**
- * scsi_initialize_merge_fn() -=C6=A3initialize merge function for a h=
ost
- * @sd:		host descriptor
- */
-static void scsi_initialize_merge_fn(struct scsi_device *sd)
-{
-	request_queue_t *q =3D &sd->request_queue;
-	struct Scsi_Host *sh =3D sd->host;
-	u64 bounce_limit;
-
-	if (sh->highmem_io) {
-		if (sh->pci_dev && PCI_DMA_BUS_IS_PHYS) {
-			bounce_limit =3D sh->pci_dev->dma_mask;
-		} else {
-			/*
-			 * Platforms with virtual-DMA translation
- 			 * hardware have no practical limit.
-			 */
-			bounce_limit =3D BLK_BOUNCE_ANY;
-		}
-	} else if (sh->unchecked_isa_dma) {
-		bounce_limit =3D BLK_BOUNCE_ISA;
-	} else {
-		bounce_limit =3D BLK_BOUNCE_HIGH;
-	}
-
-	blk_queue_bounce_limit(q, bounce_limit);
-}
-
-/**
- * scsi_alloc_sdev - allocate and setup a Scsi_Device
- *
- * Description:
- *     Allocate, initialize for io, and return a pointer to a Scsi_Dev=
ice.
- *     Stores the @shost, @channel, @id, and @lun in the Scsi_Device, =
and
- *     adds Scsi_Device to the appropriate list.
- *
- * Return value:
- *     Scsi_Device pointer, or NULL on failure.
- **/
-static Scsi_Device *scsi_alloc_sdev(struct Scsi_Host *shost, uint chan=
nel,
-				    uint id, uint lun)
-{
-	Scsi_Device *sdev;
-
-	sdev =3D (Scsi_Device *) kmalloc(sizeof(Scsi_Device), GFP_ATOMIC);
-	if (sdev =3D=3D NULL)
-		printk(ALLOC_FAILURE_MSG, __FUNCTION__);
-	else {
-		memset(sdev, 0, sizeof(Scsi_Device));
-		sdev->vendor =3D scsi_null_device_strs;
-		sdev->model =3D scsi_null_device_strs;
-		sdev->rev =3D scsi_null_device_strs;
-		sdev->host =3D shost;
-		sdev->id =3D id;
-		sdev->lun =3D lun;
-		sdev->channel =3D channel;
-		sdev->online =3D TRUE;
-		/*
-		 * Some low level driver could use device->type
-		 */
-		sdev->type =3D -1;
-		/*
-		 * Assume that the device will have handshaking problems,
-		 * and then fix this field later if it turns out it
-		 * doesn't
-		 */
-		sdev->borken =3D 1;
-		scsi_initialize_queue(sdev, shost);
-		sdev->request_queue.queuedata =3D (void *) sdev;
-
-		scsi_initialize_merge_fn(sdev);
-		init_waitqueue_head(&sdev->scpnt_wait);
-
-		/*
-		 * Add it to the end of the shost->host_queue list.
-		 */
-		if (shost->host_queue !=3D NULL) {
-			sdev->prev =3D shost->host_queue;
-			while (sdev->prev->next !=3D NULL)
-				sdev->prev =3D sdev->prev->next;
-			sdev->prev->next =3D sdev;
-		} else
-			shost->host_queue =3D sdev;
-
-	}
-	return (sdev);
-}
-
-/**
- * scsi_free_sdev - cleanup and free a Scsi_Device
- * @sdev:	cleanup and free this Scsi_Device
- *
- * Description:
- *     Undo the actions in scsi_alloc_sdev, including removing @sdev f=
rom
- *     the list, and freeing @sdev.
- **/
-static void scsi_free_sdev(Scsi_Device *sdev)
-{
-	if (sdev->prev !=3D NULL)
-		sdev->prev->next =3D sdev->next;
-	else
-		sdev->host->host_queue =3D sdev->next;
-	if (sdev->next !=3D NULL)
-		sdev->next->prev =3D sdev->prev;
-
-	blk_cleanup_queue(&sdev->request_queue);
-	if (sdev->inquiry !=3D NULL)
-		kfree(sdev->inquiry);
-	kfree(sdev);
 }
=20
 /**
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
