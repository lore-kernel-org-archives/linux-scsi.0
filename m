From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 11:17:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517111723.A14681@lst.de>
References: <20030516182039.A7369@lst.de> <20030516235718.GA3260@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:56332 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261322AbTEQJEg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 05:04:36 -0400
Content-Disposition: inline
In-Reply-To: <20030516235718.GA3260@beaverton.ibm.com>; from andmike@us.ibm.com on Fri, May 16, 2003 at 04:57:18PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Fri, May 16, 2003 at 04:57:18PM -0700, Mike Anderson wrote:
> I ran your patch and I dead locked on st_probe. This is due to the code
> in st_probe and osst_probe that do device registers on the
> sdev_driverfs_dev.bus which is the bus that the probe is being called
> from already. I had an old patch that removed these before due the driver
> model requirement that objects on the device list must be of one type.
> At the time I did not have a place to move these attributes.

Okay, here's the patch to remove the strange kdev and type attributes
that caused this problems.  All the useful attributes are still left,
they're attributes of the right struct device.


--- 1.44/drivers/scsi/osst.c	Fri May 16 12:15:24 2003
+++ edited/drivers/scsi/osst.c	Fri May 16 13:18:52 2003
@@ -5323,22 +5323,6 @@
 
 #endif
 
-/* Driverfs file support */
-static ssize_t osst_device_kdev_read(struct device *driverfs_dev, char *page)
-{
-	kdev_t kdev; 
-	kdev.value=(int)(long)driverfs_dev->driver_data;
-	return sprintf(page, "%x\n",kdev.value);
-}
-static DEVICE_ATTR(kdev,S_IRUGO,osst_device_kdev_read,NULL);
-
-static ssize_t osst_device_type_read(struct device *driverfs_dev, char *page) 
-{
-	return sprintf (page, "CHR\n");
-}
-static DEVICE_ATTR(type,S_IRUGO,osst_device_type_read,NULL);
-
-
 static struct file_operations osst_fops = {
 	.owner =        THIS_MODULE,
 	.read =         osst_read,
@@ -5519,45 +5503,16 @@
 	write_unlock(&os_scsi_tapes_lock);
 
 	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-		char name[8], devfs_name[64];
+		char devfs_name[64];
 
 		/*  Rewind entry  */
-		sprintf(name, "ot%s", osst_formats[mode]);
 		sprintf(devfs_name, "%s/ot%s", SDp->devfs_name, osst_formats[mode]);
-
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
 		devfs_register(NULL, devfs_name, 0,
 					OSST_MAJOR, dev_num + (mode << 5),
 					S_IFCHR | S_IRUGO | S_IWUGO,
 					&osst_fops, NULL);
 		/*  No-rewind entry  */
-		sprintf (name, "ot%sn", osst_formats[mode]);
 		sprintf(devfs_name, "%s/ot%sn", SDp->devfs_name, osst_formats[mode]);
-
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
 		devfs_register(NULL, devfs_name, 0,
 					OSST_MAJOR, dev_num + (mode << 5) + 128,
 					S_IFCHR | S_IRUGO | S_IWUGO,
@@ -5598,18 +5553,6 @@
 		os_scsi_tapes[i] = NULL;
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
--- 1.10/drivers/scsi/osst.h	Fri May 16 12:15:25 2003
+++ edited/drivers/scsi/osst.h	Fri May 16 13:17:56 2003
@@ -555,8 +555,6 @@
   /* Mode characteristics */
   ST_mode modes[ST_NBR_MODES];
   int current_mode;
-  struct device driverfs_dev_r[ST_NBR_MODES];
-  struct device driverfs_dev_n[ST_NBR_MODES];
 
   /* Status variables */
   int partition;
--- 1.62/drivers/scsi/st.c	Fri May 16 12:15:25 2003
+++ edited/drivers/scsi/st.c	Fri May 16 13:17:37 2003
@@ -3674,22 +3674,6 @@
 
 #endif
 
-/* Driverfs file support */
-static ssize_t st_device_kdev_read(struct device *dev, char *page)
-{
-	kdev_t kdev; 
-	kdev.value=(unsigned long)dev->driver_data;
-	return sprintf(page, "%x\n",kdev.value);
-}
-static DEVICE_ATTR(kdev,S_IRUGO,st_device_kdev_read,NULL);
-
-static ssize_t st_device_type_read(struct device *ev, char * page)
-{
-	return sprintf (page, "CHR\n");
-}
-static DEVICE_ATTR(type,S_IRUGO,st_device_type_read,NULL);
-
-
 static struct file_operations st_fops =
 {
 	.owner =	THIS_MODULE,
@@ -3860,45 +3844,16 @@
 	write_unlock(&st_dev_arr_lock);
 
 	for (mode = 0; mode < ST_NBR_MODES; ++mode) {
-	    char name[8], devfs_name[64];
+	    char devfs_name[64];
 
 	    /*  Rewind entry  */
-	    sprintf(name, "mt%s", st_formats[mode]);
 	    sprintf(devfs_name, "%s/mt%s", SDp->devfs_name, st_formats[mode]);
-	    
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
 	    devfs_register(NULL, devfs_name, 0,
 				SCSI_TAPE_MAJOR, dev_num + (mode << 5),
 				S_IFCHR | S_IRUGO | S_IWUGO,
 				&st_fops, NULL);
 	    /*  No-rewind entry  */
-	    sprintf (name, "mt%sn", st_formats[mode]);
 	    sprintf(devfs_name, "%s/mt%sn", SDp->devfs_name, st_formats[mode]);
-
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
 	    devfs_register(NULL, devfs_name, 0,
 				SCSI_TAPE_MAJOR, dev_num + (mode << 5) + 128,
 				S_IFCHR | S_IRUGO | S_IWUGO,
@@ -3939,16 +3894,6 @@
 			for (mode = 0; mode < ST_NBR_MODES; ++mode) {
 				devfs_remove("%s/mt%s", SDp->devfs_name, st_formats[mode]);
 				devfs_remove("%s/mt%sn", SDp->devfs_name, st_formats[mode]);
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
 
--- 1.14/drivers/scsi/st.h	Fri May 16 12:15:25 2003
+++ edited/drivers/scsi/st.h	Fri May 16 13:15:55 2003
@@ -103,8 +103,6 @@
 	/* Mode characteristics */
 	ST_mode modes[ST_NBR_MODES];
 	int current_mode;
-	struct device driverfs_dev_r[ST_NBR_MODES];
-	struct device driverfs_dev_n[ST_NBR_MODES];
 
 	/* Status variables */
 	int partition;
