From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH / RFC] osst, st, sg sysfs removes
Date: Thu, 9 Jan 2003 14:21:07 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030109222107.GA5041@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matt_Domsch@Dell.com, wrlk@riede.org, Kai.Makisara@metla.fi, dougg@torque.net, mochel@osdl.org

This patch is against 2.5.55

This patch is in response to the mail I sent the other day on the use of
to_scsi_device with our sysfs bus/scsi/devices directory containing more
than struct scsi_device objects. A link to the thread is below.

http://marc.theaimsgroup.com/?l=linux-scsi&m=104198504307087&w=2

This patch is just a removal of osst, st, and sg's sysfs nodes in the
devices directory. Current I do not have a place to replicate this
capability. It was unclear if osst and st entries where being used. The
correct place for osst and st is to have a char tree like the block tree
and have a pointer from the scsi device to the char entry. I do not know
of the proper place for sg yet. While sg is a char device it cannot
follow the same model as it can be associated with a scsi device along
with another char device.

Doug, The removal of the sg :gen has broken lscsi -g I will work on an
option to get this working again.

-andmike
--
Michael Anderson
andmike@us.ibm.com

 osst.c |   53 -----------------------------------------------------
 osst.h |    2 --
 sg.c   |   35 -----------------------------------
 st.c   |   53 -----------------------------------------------------
 st.h   |    2 --
 5 files changed, 145 deletions(-)
------

--- 1.37/drivers/scsi/osst.c	Thu Dec 26 16:25:32 2002
+++ edited/drivers/scsi/osst.c	Thu Jan  9 09:06:43 2003
@@ -5324,22 +5324,6 @@
 
 #endif
 
-/* Driverfs file support */
-static ssize_t osst_device_kdev_read(struct device *driverfs_dev, char *page, size_t count, loff_t off)
-{
-	kdev_t kdev; 
-	kdev.value=(int)(long)driverfs_dev->driver_data;
-	return off ? 0 : sprintf(page, "%x\n",kdev.value);
-}
-static DEVICE_ATTR(kdev,S_IRUGO,osst_device_kdev_read,NULL);
-
-static ssize_t osst_device_type_read(struct device *driverfs_dev, char *page, size_t count, loff_t off) 
-{
-	return off ? 0 : sprintf (page, "CHR\n");
-}
-static DEVICE_ATTR(type,S_IRUGO,osst_device_type_read,NULL);
-
-
 static struct file_operations osst_fops = {
 	.owner =        THIS_MODULE,
 	.read =         osst_read,
@@ -5529,18 +5513,6 @@
 		
 		/*  Rewind entry  */
 		sprintf (name, "ot%s", formats[mode]);
-		sprintf(tpnt->driverfs_dev_r[mode].bus_id, "%s:%s", 
-				SDp->sdev_driverfs_dev.bus_id, name);
-		sprintf(tpnt->driverfs_dev_r[mode].name, "%s%s", 
-				SDp->sdev_driverfs_dev.name, name);
-		tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
-		tpnt->driverfs_dev_r[mode].bus = SDp->sdev_driverfs_dev.bus;
-		tpnt->driverfs_dev_r[mode].driver_data =
-			(void *)(long)__mkdev(OSST_MAJOR, dev_num + (mode << 5));
-		device_register(&tpnt->driverfs_dev_r[mode]);
-		device_create_file(&tpnt->driverfs_dev_r[mode], 
-				&dev_attr_type);
-		device_create_file(&tpnt->driverfs_dev_r[mode], &dev_attr_kdev);
 		tpnt->de_r[mode] =
 			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
 					OSST_MAJOR, dev_num + (mode << 5),
@@ -5548,19 +5520,6 @@
 					&osst_fops, NULL);
 		/*  No-rewind entry  */
 		sprintf (name, "ot%sn", formats[mode]);
-		sprintf(tpnt->driverfs_dev_n[mode].bus_id, "%s:%s", 
-				SDp->sdev_driverfs_dev.bus_id, name);
-		sprintf(tpnt->driverfs_dev_n[mode].name, "%s%s", 
-				SDp->sdev_driverfs_dev.name, name);
-		tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
-		tpnt->driverfs_dev_n[mode].bus = SDp->sdev_driverfs_dev.bus;
-		tpnt->driverfs_dev_n[mode].driver_data =
-			(void *)(long)__mkdev(OSST_MAJOR, dev_num + (mode << 5) + 128);
-		device_register(&tpnt->driverfs_dev_n[mode]);
-		device_create_file(&tpnt->driverfs_dev_n[mode], 
-				&dev_attr_type);
-		device_create_file(&tpnt->driverfs_dev_n[mode], 
-				&dev_attr_kdev);
 		tpnt->de_n[mode] =
 			devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
 					OSST_MAJOR, dev_num + (mode << 5) + 128,
@@ -5606,18 +5565,6 @@
 		scsi_slave_detach(SDp);
 		osst_nr_dev--;
 		write_unlock(&os_scsi_tapes_lock);
-		for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-			device_remove_file(&tpnt->driverfs_dev_r[mode],
-					&dev_attr_type);
-			device_remove_file(&tpnt->driverfs_dev_r[mode],
-					&dev_attr_kdev);
-			device_unregister(&tpnt->driverfs_dev_r[mode]);
-			device_remove_file(&tpnt->driverfs_dev_n[mode],
-					&dev_attr_type);
-			device_remove_file(&tpnt->driverfs_dev_n[mode],
-					&dev_attr_kdev);
-			device_unregister(&tpnt->driverfs_dev_n[mode]);
-			}
 		if (tpnt->header_cache != NULL) vfree(tpnt->header_cache);
 		if (tpnt->buffer) {
 			normalize_buffer(tpnt->buffer);
--- 1.8/drivers/scsi/osst.h	Sat Nov 23 10:53:29 2002
+++ edited/drivers/scsi/osst.h	Thu Jan  9 09:06:43 2003
@@ -559,8 +559,6 @@
   int current_mode;
   devfs_handle_t de_r[ST_NBR_MODES];  /*  Rewind entries     */
   devfs_handle_t de_n[ST_NBR_MODES];  /*  No-rewind entries  */
-  struct device driverfs_dev_r[ST_NBR_MODES];
-  struct device driverfs_dev_n[ST_NBR_MODES];
 
   /* Status variables */
   int partition;
--- 1.44/drivers/scsi/sg.c	Fri Dec 20 18:00:00 2002
+++ edited/drivers/scsi/sg.c	Thu Jan  9 09:06:43 2003
@@ -187,7 +187,6 @@
 	volatile char detached;	/* 0->attached, 1->detached pending removal */
 	volatile char exclude;	/* opened for exclusive access */
 	char sgdebug;		/* 0->off, 1->sense, 9->dump dev, 10-> all devs */
-	struct device sg_driverfs_dev;
 	struct gendisk *disk;
 } Sg_device;
 
@@ -1348,26 +1347,6 @@
 __setup("sg_def_reserved_size=", sg_def_reserved_size_setup);
 #endif
 
-/* Driverfs file support */
-static ssize_t
-sg_device_kdev_read(struct device *driverfs_dev, char *page,
-		    size_t count, loff_t off)
-{
-	Sg_device *sdp = list_entry(driverfs_dev, Sg_device, sg_driverfs_dev);
-	return off ? 0 : sprintf(page, "%x\n", MKDEV(sdp->disk->major,
-						     sdp->disk->first_minor));
-}
-static DEVICE_ATTR(kdev,S_IRUGO,sg_device_kdev_read,NULL);
-
-static ssize_t
-sg_device_type_read(struct device *driverfs_dev, char *page,
-		    size_t count, loff_t off)
-{
-	return off ? 0 : sprintf(page, "CHR\n");
-}
-
-static DEVICE_ATTR(type,S_IRUGO,sg_device_type_read,NULL);
-
 static int
 sg_attach(Scsi_Device * scsidp)
 {
@@ -1456,21 +1435,10 @@
 	sdp->detached = 0;
 	sdp->sg_tablesize = scsidp->host ? scsidp->host->sg_tablesize : 0;
 
-	memset(&sdp->sg_driverfs_dev, 0, sizeof (struct device));
-	sprintf(sdp->sg_driverfs_dev.bus_id, "%s:gen",
-		scsidp->sdev_driverfs_dev.bus_id);
-	sprintf(sdp->sg_driverfs_dev.name, "%sgeneric",
-		scsidp->sdev_driverfs_dev.name);
-	sdp->sg_driverfs_dev.parent = &scsidp->sdev_driverfs_dev;
-	sdp->sg_driverfs_dev.bus = scsidp->sdev_driverfs_dev.bus;
-
 	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
 
-	device_register(&sdp->sg_driverfs_dev);
-	device_create_file(&sdp->sg_driverfs_dev, &dev_attr_type);
-	device_create_file(&sdp->sg_driverfs_dev, &dev_attr_kdev);
 	sdp->de = devfs_register(scsidp->de, "generic", DEVFS_FL_DEFAULT,
 				 SCSI_GENERIC_MAJOR, k,
 				 S_IFCHR | S_IRUSR | S_IWUSR | S_IRGRP,
@@ -1553,9 +1521,6 @@
 	if (sdp) {
 		devfs_unregister(sdp->de);
 		sdp->de = NULL;
-		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_type);
-		device_remove_file(&sdp->sg_driverfs_dev, &dev_attr_kdev);
-		device_unregister(&sdp->sg_driverfs_dev);
 		put_disk(sdp->disk);
 		sdp->disk = NULL;
 		if (NULL == sdp->headfp)
--- 1.52/drivers/scsi/st.c	Sat Dec 21 08:53:05 2002
+++ edited/drivers/scsi/st.c	Thu Jan  9 09:06:43 2003
@@ -3614,24 +3614,6 @@
 
 #endif
 
-/* Driverfs file support */
-static ssize_t st_device_kdev_read(struct device *driverfs_dev, 
-				   char *page, size_t count, loff_t off)
-{
-	kdev_t kdev; 
-	kdev.value=(int)(long)driverfs_dev->driver_data;
-	return off ? 0 : sprintf(page, "%x\n",kdev.value);
-}
-static DEVICE_ATTR(kdev,S_IRUGO,st_device_kdev_read,NULL);
-
-static ssize_t st_device_type_read(struct device *driverfs_dev, 
-				   char *page, size_t count, loff_t off) 
-{
-	return off ? 0 : sprintf (page, "CHR\n");
-}
-static DEVICE_ATTR(type,S_IRUGO,st_device_type_read,NULL);
-
-
 static struct file_operations st_fops =
 {
 	.owner =	THIS_MODULE,
@@ -3810,18 +3792,6 @@
 
 	    /*  Rewind entry  */
 	    sprintf (name, "mt%s", formats[mode]);
-	    sprintf(tpnt->driverfs_dev_r[mode].bus_id, "%s:%s", 
-		    SDp->sdev_driverfs_dev.bus_id, name);
-	    sprintf(tpnt->driverfs_dev_r[mode].name, "%s%s", 
-		    SDp->sdev_driverfs_dev.name, name);
-	    tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_r[mode].bus = SDp->sdev_driverfs_dev.bus;
-	    tpnt->driverfs_dev_r[mode].driver_data =
-			(void *)(long)__mkdev(SCSI_TAPE_MAJOR, dev_num + (mode << 5));
-	    device_register(&tpnt->driverfs_dev_r[mode]);
-	    device_create_file(&tpnt->driverfs_dev_r[mode], 
-			       &dev_attr_type);
-	    device_create_file(&tpnt->driverfs_dev_r[mode], &dev_attr_kdev);
 	    tpnt->de_r[mode] =
 		devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
 				SCSI_TAPE_MAJOR, dev_num + (mode << 5),
@@ -3829,19 +3799,6 @@
 				&st_fops, NULL);
 	    /*  No-rewind entry  */
 	    sprintf (name, "mt%sn", formats[mode]);
-	    sprintf(tpnt->driverfs_dev_n[mode].bus_id, "%s:%s", 
-		    SDp->sdev_driverfs_dev.bus_id, name);
-	    sprintf(tpnt->driverfs_dev_n[mode].name, "%s%s", 
-		    SDp->sdev_driverfs_dev.name, name);
-	    tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_n[mode].bus = SDp->sdev_driverfs_dev.bus;
-	    tpnt->driverfs_dev_n[mode].driver_data =
-			(void *)(long)__mkdev(SCSI_TAPE_MAJOR, dev_num + (mode << 5) + 128);
-	    device_register(&tpnt->driverfs_dev_n[mode]);
-	    device_create_file(&tpnt->driverfs_dev_n[mode], 
-			       &dev_attr_type);
-	    device_create_file(&tpnt->driverfs_dev_n[mode], 
-			       &dev_attr_kdev);
 	    tpnt->de_n[mode] =
 		devfs_register (SDp->de, name, DEVFS_FL_DEFAULT,
 				SCSI_TAPE_MAJOR, dev_num + (mode << 5) + 128,
@@ -3885,16 +3842,6 @@
 				tpnt->de_r[mode] = NULL;
 				devfs_unregister (tpnt->de_n[mode]);
 				tpnt->de_n[mode] = NULL;
-				device_remove_file(&tpnt->driverfs_dev_r[mode],
-						   &dev_attr_type);
-				device_remove_file(&tpnt->driverfs_dev_r[mode],
-						   &dev_attr_kdev);
-				device_unregister(&tpnt->driverfs_dev_r[mode]);
-				device_remove_file(&tpnt->driverfs_dev_n[mode],
-						   &dev_attr_type);
-				device_remove_file(&tpnt->driverfs_dev_n[mode],
-						   &dev_attr_kdev);
-				device_unregister(&tpnt->driverfs_dev_n[mode]);
 			}
 			tpnt->device = NULL;
 
--- 1.11/drivers/scsi/st.h	Fri Nov  1 04:28:10 2002
+++ edited/drivers/scsi/st.h	Thu Jan  9 09:06:43 2003
@@ -107,8 +107,6 @@
 	int current_mode;
 	devfs_handle_t de_r[ST_NBR_MODES];  /*  Rewind entries     */
 	devfs_handle_t de_n[ST_NBR_MODES];  /*  No-rewind entries  */
-	struct device driverfs_dev_r[ST_NBR_MODES];
-	struct device driverfs_dev_n[ST_NBR_MODES];
 
 	/* Status variables */
 	int partition;

