From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi device template cleanups
Date: Tue, 5 Nov 2002 05:23:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021105052307.A18575@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Now that .init isn't implement anymore we can get rid of it and
do some more cleanup in the scsi device template:

* remove .blk - unused since 2.5.46
* remove .dev_noticed, only midlayer user is gone together with
  .init.  remaining instance now driver-private
* remove .nr_dev and .dev_max - they're purely driver internal
  and at least in sd and sr they'll be completly gone very soon.


--- 1.29/drivers/scsi/hosts.h	Sun Nov  3 08:24:37 2002
+++ edited/drivers/scsi/hosts.h	Tue Nov  5 04:07:50 2002
@@ -562,13 +562,7 @@
     const char * tag;
     struct module * module;	  /* Used for loadable modules */
     unsigned char scsi_type;
-    unsigned int nr_dev;	  /* Number currently attached */
-    unsigned int dev_noticed;	  /* Number of devices detected. */
-    unsigned int dev_max;	  /* Current size of arrays */
-    unsigned blk:1;		  /* 0 if character device */
     int (*detect)(Scsi_Device *); /* Returns 1 if we can attach this device */
-    int (*init)(void);		  /* Sizes arrays based upon number of devices
-		   *  detected */
     int (*attach)(Scsi_Device *); /* Attach devices to arrays */
     void (*detach)(Scsi_Device *);
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code. 
===== drivers/scsi/osst.c 1.23 vs edited =====
--- 1.23/drivers/scsi/osst.c	Mon Nov  4 12:06:03 2002
+++ edited/drivers/scsi/osst.c	Tue Nov  5 04:00:30 2002
@@ -156,6 +156,10 @@
 static int osst_detect(Scsi_Device *);
 static void osst_detach(Scsi_Device *);
 
+static int osst_dev_noticed;
+static int osst_nr_dev;
+static int osst_dev_max;
+
 struct Scsi_Device_Template osst_template =
 {
        module:		THIS_MODULE,
@@ -4154,7 +4158,7 @@
 	char *name;
 	int mode = TAPE_MODE(inode->i_rdev);
 
-	if (dev >= osst_template.dev_max || (STp = os_scsi_tapes[dev]) == NULL || !STp->device)
+	if (dev >= osst_dev_max || (STp = os_scsi_tapes[dev]) == NULL || !STp->device)
 		return (-ENXIO);
 
 	filp->private_data = STp;
@@ -4979,7 +4983,7 @@
 	int i, priority, b_size, order, got = 0, segs = 0;
 	OSST_buffer *tb;
 
-	if (osst_nbr_buffers >= osst_template.dev_max)
+	if (osst_nbr_buffers >= osst_dev_max)
 		return NULL;  /* Should never happen */
 
 	if (from_initialization)
@@ -5416,15 +5420,15 @@
 	if (!disk)
 		return 1;
 
-	if (osst_template.nr_dev >= osst_template.dev_max) {
+	if (osst_nr_dev >= osst_dev_max) {
 		 SDp->attached--;
 		 put_disk(disk);
 		 return 1;
 	}
 	
 	/* find a free minor number */
-	for (i=0; os_scsi_tapes[i] && i<osst_template.dev_max; i++);
-	if(i >= osst_template.dev_max) panic ("Scsi_devices corrupt (osst)");
+	for (i=0; os_scsi_tapes[i] && i<osst_dev_max; i++);
+	if(i >= osst_dev_max) panic ("Scsi_devices corrupt (osst)");
 
 	/* allocate a OS_Scsi_Tape for this device */
 	tpnt = (OS_Scsi_Tape *)kmalloc(sizeof(OS_Scsi_Tape), GFP_ATOMIC);
@@ -5548,7 +5552,7 @@
 	tpnt->density_changed = tpnt->compression_changed = tpnt->blksize_changed = FALSE;
 	init_MUTEX(&tpnt->lock);
 
-	osst_template.nr_dev++;
+	osst_nr_dev++;
 
 	printk(KERN_INFO
 		"osst :I: Attached OnStream %.5s tape at scsi%d, channel %d, id %d, lun %d as %s\n",
@@ -5562,7 +5566,7 @@
 	if (SDp->type != TYPE_TAPE) return 0;
 	if ( ! osst_supports(SDp) ) return 0;
 	
-	osst_template.dev_noticed++;
+	osst_dev_noticed++;
 	return 1;
 }
 
@@ -5573,7 +5577,7 @@
 {
 	int i;
 
-	if (osst_template.dev_noticed == 0)
+	if (osst_dev_noticed == 0)
 		return 0;
 
 	if (!osst_registered) {
@@ -5586,10 +5590,10 @@
 
 	if (os_scsi_tapes)
 		return 0;
-	osst_template.dev_max = OSST_MAX_TAPES;
-	if (osst_template.dev_max > 128 / ST_NBR_MODES)
+	osst_dev_max = OSST_MAX_TAPES;
+	if (osst_dev_max > 128 / ST_NBR_MODES)
 		printk(KERN_INFO "osst :I: Only %d tapes accessible.\n", 128 / ST_NBR_MODES);
-	os_scsi_tapes = kmalloc(osst_template.dev_max * sizeof(OS_Scsi_Tape *),
+	os_scsi_tapes = kmalloc(osst_dev_max * sizeof(OS_Scsi_Tape *),
 								GFP_ATOMIC);
 	if (!os_scsi_tapes) {
 		printk(KERN_ERR "osst :W: Unable to allocate array for OnStream SCSI tapes.\n");
@@ -5597,11 +5601,11 @@
 		return 1;
 	}
 
-	for (i=0; i < osst_template.dev_max; ++i)
+	for (i=0; i < osst_dev_max; ++i)
 		os_scsi_tapes[i] = NULL;
 
 	/* Allocate the buffer pointers */
-	osst_buffers = kmalloc(osst_template.dev_max * sizeof(OSST_buffer *),
+	osst_buffers = kmalloc(osst_dev_max * sizeof(OSST_buffer *),
 								GFP_ATOMIC);
 	if (!osst_buffers) {
 		printk(KERN_ERR "osst :W: Unable to allocate tape buffer pointers.\n");
@@ -5629,7 +5633,7 @@
   int mode;
 #endif
 
-  for(i=0; i<osst_template.dev_max; i++) {
+  for(i=0; i<osst_dev_max; i++) {
 	tpnt = os_scsi_tapes[i];
 	if(tpnt != NULL && tpnt->device == SDp) {
 		tpnt->device = NULL;
@@ -5645,8 +5649,8 @@
 		kfree(tpnt);
 		os_scsi_tapes[i] = NULL;
 		SDp->attached--;
-		osst_template.nr_dev--;
-		osst_template.dev_noticed--;
+		osst_nr_dev--;
+		osst_dev_noticed--;
 		return;
 	}
   }
@@ -5668,7 +5672,7 @@
 	unregister_chrdev(MAJOR_NR, "osst");
 	osst_registered--;
 	if (os_scsi_tapes) {
-		for (i=0; i < osst_template.dev_max; ++i) {
+		for (i=0; i < osst_dev_max; ++i) {
 			STp = os_scsi_tapes[i];
 			if (!STp)
 				continue;
@@ -5690,7 +5694,7 @@
 			kfree(osst_buffers);
 		}
 	}
-	osst_template.dev_max = 0;
+	osst_dev_max = 0;
 	printk(KERN_INFO "osst :I: Unloaded.\n");
 }
 
===== drivers/scsi/scsi.c 1.53 vs edited =====
--- 1.53/drivers/scsi/scsi.c	Mon Nov  4 12:04:51 2002
+++ edited/drivers/scsi/scsi.c	Tue Nov  5 03:51:49 2002
@@ -1990,9 +1990,6 @@
 
 	down_read(&scsi_devicelist_mutex);
 	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-		if (sdt->init && sdt->dev_noticed)
-			(*sdt->init) ();
-	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
 		if (sdt->attach)
 			(*sdt->attach) (sdev);
 	up_read(&scsi_devicelist_mutex);
@@ -2059,14 +2056,6 @@
 				SDpnt->attached += (*tpnt->detect) (SDpnt);
 		}
 	}
-
-	/*
-	 * If any of the devices would match this driver, then perform the
-	 * init function.
-	 */
-	if (tpnt->init && tpnt->dev_noticed)
-		if ((*tpnt->init) ())
-			return 1;
 
 	/*
 	 * Now actually connect the devices to the new driver.
===== drivers/scsi/sd.c 1.87 vs edited =====
--- 1.87/drivers/scsi/sd.c	Sun Nov  3 10:06:38 2002
+++ edited/drivers/scsi/sd.c	Tue Nov  5 04:08:01 2002
@@ -83,6 +83,7 @@
 	unsigned	RCD : 1;	/* state of disk RCD bit */
 };
 
+static int sd_nr_dev;	/* XXX(hch) bad hack, we want a bitmap instead */
 static LIST_HEAD(sd_devlist);
 static spinlock_t sd_devlist_lock = SPIN_LOCK_UNLOCKED;
 
@@ -106,7 +107,6 @@
 	.name		= "disk",
 	.tag		= "sd",
 	.scsi_type	= TYPE_DISK,
-	.blk		= 1,
 	.detect		= sd_detect,
 	.attach		= sd_attach,
 	.detach		= sd_detach,
@@ -1179,7 +1179,6 @@
 	SCSI_LOG_HLQUEUE(3, printk("sd_detect: type=%d\n", sdp->type));
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD)
 		return 0;
-	sd_template.dev_noticed++;
 	return 1;
 }
 
@@ -1228,7 +1227,7 @@
 	 * XXX  use find_first_zero_bit on it.  This will happen at the
 	 * XXX  same time template->nr_* goes away.		--hch
 	 */
-	dsk_nr = sd_template.nr_dev++;
+	dsk_nr = sd_nr_dev++;
 
 	sdkp->device = sdp;
 	sdkp->driver = &sd_template;
@@ -1314,8 +1313,7 @@
 	sd_devlist_remove(sdkp);
 	del_gendisk(sdkp->disk);
 	sdp->attached--;
-	sd_template.dev_noticed--;
-	sd_template.nr_dev--;
+	sd_nr_dev--;
 	put_disk(sdkp->disk);
 	kfree(sdkp);
 }
===== drivers/scsi/sg.c 1.35 vs edited =====
--- 1.35/drivers/scsi/sg.c	Fri Nov  1 07:28:19 2002
+++ edited/drivers/scsi/sg.c	Tue Nov  5 04:02:35 2002
@@ -235,6 +235,9 @@
 #endif
 
 static Sg_device **sg_dev_arr = NULL;
+static int sg_dev_noticed;
+static int sg_dev_max;
+static int sg_nr_dev;
 
 #define SZ_SG_HEADER sizeof(struct sg_header)
 #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
@@ -1340,7 +1343,7 @@
 static int
 sg_detect(Scsi_Device * scsidp)
 {
-	sg_template.dev_noticed++;
+	sg_dev_noticed++;
 	return 1;
 }
 
@@ -1353,13 +1356,13 @@
 	int tmp_dev_max;
 	Sg_device **tmp_da;
 
-	if ((sg_template.dev_noticed == 0) || sg_dev_arr)
+	if ((sg_dev_noticed == 0) || sg_dev_arr)
 		return 0;
 
 	SCSI_LOG_TIMEOUT(3, printk("sg_init\n"));
 
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	tmp_dev_max = sg_template.dev_noticed + SG_DEV_ARR_LUMP;
+	tmp_dev_max = sg_dev_noticed + SG_DEV_ARR_LUMP;
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
 	tmp_da = (Sg_device **)vmalloc(
@@ -1383,7 +1386,7 @@
 	}
 
 	memset(tmp_da, 0, tmp_dev_max * sizeof (Sg_device *));
-	sg_template.dev_max = tmp_dev_max;
+	sg_dev_max = tmp_dev_max;
 	sg_dev_arr = tmp_da;
 
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
@@ -1445,9 +1448,9 @@
 	if (!disk)
 		return 1;
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	if (sg_template.nr_dev >= sg_template.dev_max) {	/* try to resize */
+	if (sg_nr_dev >= sg_dev_max) {	/* try to resize */
 		Sg_device **tmp_da;
-		int tmp_dev_max = sg_template.nr_dev + SG_DEV_ARR_LUMP;
+		int tmp_dev_max = sg_nr_dev + SG_DEV_ARR_LUMP;
 
 		write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 		tmp_da = (Sg_device **)vmalloc(
@@ -1462,14 +1465,14 @@
 		write_lock_irqsave(&sg_dev_arr_lock, iflags);
 		memset(tmp_da, 0, tmp_dev_max * sizeof (Sg_device *));
 		memcpy(tmp_da, sg_dev_arr,
-		       sg_template.dev_max * sizeof (Sg_device *));
+		       sg_dev_max * sizeof (Sg_device *));
 		vfree((char *) sg_dev_arr);
 		sg_dev_arr = tmp_da;
-		sg_template.dev_max = tmp_dev_max;
+		sg_dev_max = tmp_dev_max;
 	}
 
 find_empty_slot:
-	for (k = 0; k < sg_template.dev_max; k++)
+	for (k = 0; k < sg_dev_max; k++)
 		if (!sg_dev_arr[k])
 			break;
 	if (k > SG_MAX_DEVS_MASK) {
@@ -1485,7 +1488,7 @@
 		put_disk(disk);
 		return 1;
 	}
-	if (k < sg_template.dev_max) {
+	if (k < sg_dev_max) {
 		if (NULL == sdp) {
 			write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 			sdp = (Sg_device *)vmalloc(sizeof(Sg_device));
@@ -1527,7 +1530,7 @@
 	sdp->sg_driverfs_dev.parent = &scsidp->sdev_driverfs_dev;
 	sdp->sg_driverfs_dev.bus = &scsi_driverfs_bus_type;
 
-	sg_template.nr_dev++;
+	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
@@ -1570,7 +1573,7 @@
 		return;
 	delay = 0;
 	write_lock_irqsave(&sg_dev_arr_lock, iflags);
-	for (k = 0; k < sg_template.dev_max; k++) {
+	for (k = 0; k < sg_dev_max; k++) {
 		sdp = sg_dev_arr[k];
 		if ((NULL == sdp) || (sdp->device != scsidp))
 			continue;	/* dirty but lowers nesting */
@@ -1608,8 +1611,8 @@
 			sg_dev_arr[k] = NULL;
 		}
 		scsidp->attached--;
-		sg_template.nr_dev--;
-		sg_template.dev_noticed--;	/* from <dan@lectra.fr> */
+		sg_nr_dev--;
+		sg_dev_noticed--;	/* from <dan@lectra.fr> */
 		break;
 	}
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
@@ -1660,7 +1663,7 @@
 		vfree((char *) sg_dev_arr);
 		sg_dev_arr = NULL;
 	}
-	sg_template.dev_max = 0;
+	sg_dev_max = 0;
 }
 
 static int
@@ -2552,7 +2555,7 @@
 		if (sdp->detached && (NULL == sdp->headfp)) {
 			int k, maxd;
 
-			maxd = sg_template.dev_max;
+			maxd = sg_dev_max;
 			for (k = 0; k < maxd; ++k) {
 				if (sdp == sg_dev_arr[k])
 					break;
@@ -2684,7 +2687,7 @@
 	unsigned long iflags;
 
 	read_lock_irqsave(&sg_dev_arr_lock, iflags);
-	for (k = sg_template.dev_max - 1; k >= 0; --k)
+	for (k = sg_dev_max - 1; k >= 0; --k)
 		if (sg_dev_arr[k] && sg_dev_arr[k]->device)
 			break;
 	read_unlock_irqrestore(&sg_dev_arr_lock, iflags);
@@ -2700,7 +2703,7 @@
 
 	if (sg_dev_arr && (dev >= 0)) {
 		read_lock_irqsave(&sg_dev_arr_lock, iflags);
-		if (dev < sg_template.dev_max)
+		if (dev < sg_dev_max)
 			sdp = sg_dev_arr[dev];
 		read_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 	}
@@ -2982,7 +2985,7 @@
 	}
 	max_dev = sg_last_dev();
 	PRINT_PROC("dev_max(currently)=%d max_active_device=%d (origin 1)\n",
-		   sg_template.dev_max, max_dev);
+		   sg_dev_max, max_dev);
 	PRINT_PROC(" def_reserved_size=%d\n", sg_big_buff);
 	for (j = 0; j < max_dev; ++j) {
 		if ((sdp = sg_get_dev(j))) {
===== drivers/scsi/sr.c 1.62 vs edited =====
--- 1.62/drivers/scsi/sr.c	Sun Nov  3 08:49:04 2002
+++ edited/drivers/scsi/sr.c	Tue Nov  5 04:08:08 2002
@@ -68,7 +68,6 @@
 static int sr_attach(struct scsi_device *);
 static int sr_detect(struct scsi_device *);
 static void sr_detach(struct scsi_device *);
-
 static int sr_init_command(struct scsi_cmnd *);
 
 static struct Scsi_Device_Template sr_template = {
@@ -76,13 +75,13 @@
 	.name		= "cdrom",
 	.tag		= "sr",
 	.scsi_type	= TYPE_ROM,
-	.blk		= 1,
 	.detect		= sr_detect,
 	.attach		= sr_attach,
 	.detach		= sr_detach,
 	.init_command	= sr_init_command
 };
 
+static int sr_nr_dev;	/* XXX(hch) bad hack, we want a bitmap instead */
 static LIST_HEAD(sr_devlist);
 static spinlock_t sr_devlist_lock = SPIN_LOCK_UNLOCKED;
 
@@ -495,7 +494,6 @@
 
 	if (SDp->type != TYPE_ROM && SDp->type != TYPE_WORM)
 		return 0;
-	sr_template.dev_noticed++;
 	return 1;
 }
 
@@ -524,7 +522,7 @@
 	 * XXX  use find_first_zero_bit on it.  This will happen at the
 	 * XXX  same time template->nr_* goes away.		--hch
 	 */
-	minor = sr_template.nr_dev++;
+	minor = sr_nr_dev++;
 
 	disk->major = MAJOR_NR;
 	disk->first_minor = minor;
@@ -810,7 +808,7 @@
 	unregister_cdrom(&cd->cdi);
 
 	SDp->attached--;
-	sr_template.nr_dev--;
+	sr_nr_dev--;
 
 	kfree(cd);
 }
===== drivers/scsi/st.c 1.38 vs edited =====
--- 1.38/drivers/scsi/st.c	Fri Nov  1 07:28:19 2002
+++ edited/drivers/scsi/st.c	Tue Nov  5 04:04:52 2002
@@ -74,6 +74,9 @@
 static int try_rdio = TRUE;
 static int try_wdio = TRUE;
 
+static int st_dev_max;
+static int st_nr_dev;
+
 MODULE_AUTHOR("Kai Makisara");
 MODULE_DESCRIPTION("SCSI Tape Driver");
 MODULE_LICENSE("GPL");
@@ -976,7 +979,7 @@
 	char *name;
 
 	write_lock(&st_dev_arr_lock);
-	if (dev >= st_template.dev_max || scsi_tapes == NULL ||
+	if (dev >= st_dev_max || scsi_tapes == NULL ||
 	    ((STp = scsi_tapes[dev]) == NULL)) {
 		write_unlock(&st_dev_arr_lock);
 		return (-ENXIO);
@@ -3680,15 +3683,15 @@
 	}
 
 	write_lock(&st_dev_arr_lock);
-	if (st_template.nr_dev >= st_template.dev_max) {
+	if (st_nr_dev >= st_dev_max) {
 		Scsi_Tape **tmp_da;
 		ST_buffer **tmp_ba;
 		int tmp_dev_max;
 
-		tmp_dev_max = st_template.nr_dev + ST_DEV_ARR_LUMP;
+		tmp_dev_max = st_nr_dev + ST_DEV_ARR_LUMP;
 		if (tmp_dev_max > ST_MAX_TAPES)
 			tmp_dev_max = ST_MAX_TAPES;
-		if (tmp_dev_max <= st_template.nr_dev) {
+		if (tmp_dev_max <= st_nr_dev) {
 			SDp->attached--;
 			write_unlock(&st_dev_arr_lock);
 			printk(KERN_ERR "st: Too many tape devices (max. %d).\n",
@@ -3714,18 +3717,18 @@
 		memset(tmp_da, 0, tmp_dev_max * sizeof(Scsi_Tape *));
 		if (scsi_tapes != NULL) {
 			memcpy(tmp_da, scsi_tapes,
-			       st_template.dev_max * sizeof(Scsi_Tape *));
+			       st_dev_max * sizeof(Scsi_Tape *));
 			kfree(scsi_tapes);
 		}
 		scsi_tapes = tmp_da;
 
-		st_template.dev_max = tmp_dev_max;
+		st_dev_max = tmp_dev_max;
 	}
 
-	for (i = 0; i < st_template.dev_max; i++)
+	for (i = 0; i < st_dev_max; i++)
 		if (scsi_tapes[i] == NULL)
 			break;
-	if (i >= st_template.dev_max)
+	if (i >= st_dev_max)
 		panic("scsi_devices corrupt (st)");
 
 	tpnt = kmalloc(sizeof(Scsi_Tape), GFP_ATOMIC);
@@ -3821,7 +3824,7 @@
 	    tpnt->blksize_changed = FALSE;
 	init_MUTEX(&tpnt->lock);
 
-	st_template.nr_dev++;
+	st_nr_dev++;
 	write_unlock(&st_dev_arr_lock);
 
 	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
@@ -3883,7 +3886,6 @@
 {
 	if (SDp->type != TYPE_TAPE || st_incompatible(SDp))
 		return 0;
-        st_template.dev_noticed++;
 	return 1;
 }
 
@@ -3893,7 +3895,7 @@
 	int i, mode;
 
 	write_lock(&st_dev_arr_lock);
-	for (i = 0; i < st_template.dev_max; i++) {
+	for (i = 0; i < st_dev_max; i++) {
 		tpnt = scsi_tapes[i];
 		if (tpnt != NULL && tpnt->device == SDp) {
 			tpnt->device = NULL;
@@ -3905,8 +3907,7 @@
 			}
 			scsi_tapes[i] = 0;
 			SDp->attached--;
-			st_template.nr_dev--;
-			st_template.dev_noticed--;
+			st_nr_dev--;
 			write_unlock(&st_dev_arr_lock);
 
 			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
@@ -3962,14 +3963,13 @@
 	scsi_unregister_device(&st_template);
 	unregister_chrdev(SCSI_TAPE_MAJOR, "st");
 	if (scsi_tapes != NULL) {
-		for (i=0; i < st_template.dev_max; ++i)
+		for (i=0; i < st_dev_max; ++i)
 			if (scsi_tapes[i]) {
 				put_disk(scsi_tapes[i]->disk);
 				kfree(scsi_tapes[i]);
 			}
 		kfree(scsi_tapes);
 	}
-	st_template.dev_max = 0;
 	printk(KERN_INFO "st: Unloaded.\n");
 }
 
