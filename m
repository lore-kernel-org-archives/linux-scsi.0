From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix scsi device/driver model integration
Date: Wed, 2 Oct 2002 19:28:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021002192856.A4718@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, andmike@us.ibm.com
Cc: linux-scsi@vger.kernel.org

In current 2.5 each scsi highlevel driver registers with the driver
model individually.   This is rather messy and in fact one driver
was left out in the change.  Make scsi_{,un}register_device do
it instead and deregister with the driver model first as we registered
last.

Also convert sd and sr to new initializers as my eyes burned :)


--- 1.37/drivers/scsi/scsi.c	Mon Sep 30 23:43:42 2002
+++ edited/drivers/scsi/scsi.c	Wed Oct  2 19:04:09 2002
@@ -2294,13 +2294,18 @@
 	 */
 	if (tpnt->finish && tpnt->nr_dev)
 		(*tpnt->finish) ();
+
+	tpnt->scsi_driverfs_driver.name = (char *)tpnt->tag;
+	tpnt->scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
+	driver_register(&tpnt->scsi_driverfs_driver);
+
 	MOD_INC_USE_COUNT;
 
 	if (out_of_space) {
 		scsi_unregister_device(tpnt);	/* easiest way to clean up?? */
 		return 1;
-	} else
-		return 0;
+	}
+	return 0;
 }
 
 int scsi_unregister_device(struct Scsi_Device_Template *tpnt)
@@ -2316,6 +2321,8 @@
 	 */
 	if (GET_USE_COUNT(tpnt->module) != 0)
 		goto error_out;
+
+	remove_driver(&tpnt->scsi_driverfs_driver);
 
 	/*
 	 * Next, detach the devices from the driver.
--- 1.59/drivers/scsi/sd.c	Mon Sep 30 16:23:02 2002
+++ edited/drivers/scsi/sd.c	Wed Oct  2 19:04:54 2002
@@ -100,23 +100,20 @@
 static int sd_init_command(Scsi_Cmnd *);
 
 static struct Scsi_Device_Template sd_template = {
-	module:THIS_MODULE,
-	name:"disk",
-	tag:"sd",
-	scsi_type:TYPE_DISK,
-	major:SCSI_DISK0_MAJOR,
-        /*
-         * Secondary range of majors that this driver handles.
-         */
-	min_major:SCSI_DISK1_MAJOR,
-	max_major:SCSI_DISK7_MAJOR,
-	blk:1,
-	detect:sd_detect,
-	init:sd_init,
-	finish:sd_finish,
-	attach:sd_attach,
-	detach:sd_detach,
-	init_command:sd_init_command,
+	.module		= THIS_MODULE,
+	.name		= "disk",
+	.tag		= "sd",
+	.scsi_type	= TYPE_DISK,
+	.major		= SCSI_DISK0_MAJOR,
+	.min_major	= SCSI_DISK1_MAJOR,
+	.max_major	= SCSI_DISK7_MAJOR,
+	.blk		= 1,
+	.detect		= sd_detect,
+	.init		= sd_init,
+	.finish		= sd_finish,
+	.attach		= sd_attach,
+	.detach		= sd_detach,
+	.init_command	= sd_init_command,
 };
 
 static void sd_rw_intr(Scsi_Cmnd * SCpnt);
@@ -1425,16 +1422,8 @@
  **/
 static int __init init_sd(void)
 {
-	int rc;
 	SCSI_LOG_HLQUEUE(3, printk("init_sd: sd driver entry point\n"));
-	sd_template.module = THIS_MODULE;
-	rc = scsi_register_device(&sd_template);
-	if (!rc) {
-		sd_template.scsi_driverfs_driver.name = (char *)sd_template.tag;
-		sd_template.scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
-		driver_register(&sd_template.scsi_driverfs_driver);
-	}
-	return rc;
+	return scsi_register_device(&sd_template);
 }
 
 /**
@@ -1460,7 +1449,6 @@
 	for (k = 0; k < N_USED_SD_MAJORS; k++)
 		blk_dev[SD_MAJOR(k)].queue = NULL;
 	sd_template.dev_max = 0;
-	remove_driver(&sd_template.scsi_driverfs_driver);
 }
 
 static Scsi_Disk * sd_get_sdisk(int index)
--- 1.25/drivers/scsi/sg.c	Mon Sep 30 23:41:07 2002
+++ edited/drivers/scsi/sg.c	Wed Oct  2 19:00:56 2002
@@ -1612,17 +1612,9 @@
 static int __init
 init_sg(void)
 {
-	int rc;
 	if (def_reserved_size >= 0)
 		sg_big_buff = def_reserved_size;
-	rc = scsi_register_device(&sg_template);
-	if (!rc) {
-		sg_template.scsi_driverfs_driver.name =
-		    (char *) sg_template.tag;
-		sg_template.scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
-		driver_register(&sg_template.scsi_driverfs_driver);
-	}
-	return rc;
+	return scsi_register_device(&sg_template);
 }
 
 static void __exit
@@ -1638,7 +1630,6 @@
 		sg_dev_arr = NULL;
 	}
 	sg_template.dev_max = 0;
-	remove_driver(&sg_template.scsi_driverfs_driver);
 }
 
 static int
--- 1.46/drivers/scsi/sr.c	Mon Sep 30 16:23:02 2002
+++ edited/drivers/scsi/sr.c	Wed Oct  2 19:06:23 2002
@@ -71,20 +71,19 @@
 
 static int sr_init_command(Scsi_Cmnd *);
 
-static struct Scsi_Device_Template sr_template =
-{
-	module:THIS_MODULE,
-	name:"cdrom",
-	tag:"sr",
-	scsi_type:TYPE_ROM,
-	major:SCSI_CDROM_MAJOR,
-	blk:1,
-	detect:sr_detect,
-	init:sr_init,
-	finish:sr_finish,
-	attach:sr_attach,
-	detach:sr_detach,
-	init_command:sr_init_command
+static struct Scsi_Device_Template sr_template = {
+	.module		= THIS_MODULE,
+	.name		= "cdrom",
+	.tag		= "sr",
+	.scsi_type	= TYPE_ROM,
+	.major		= SCSI_CDROM_MAJOR,
+	.blk		= 1,
+	.detect		= sr_detect,
+	.init		= sr_init,
+	.finish		= sr_finish,
+	.attach		= sr_attach,
+	.detach		= sr_detach,
+	.init_command	= sr_init_command
 };
 
 static Scsi_CD *scsi_CDs;
@@ -845,14 +844,7 @@
 
 static int __init init_sr(void)
 {
-	int rc;
-	rc = scsi_register_device(&sr_template);
-	if (!rc) {
-		sr_template.scsi_driverfs_driver.name = (char *)sr_template.tag;
-		sr_template.scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
-		driver_register(&sr_template.scsi_driverfs_driver);
-	}
-	return rc;
+	return scsi_register_device(&sr_template);
 }
 
 static void __exit exit_sr(void)
@@ -864,7 +856,6 @@
 		kfree(scsi_CDs);
 
 	sr_template.dev_max = 0;
-	remove_driver(&sr_template.scsi_driverfs_driver);
 }
 
 module_init(init_sr);
--- 1.28/drivers/scsi/st.c	Mon Sep 30 00:29:16 2002
+++ edited/drivers/scsi/st.c	Wed Oct  2 19:01:04 2002
@@ -3941,14 +3941,8 @@
 		st_max_sg_segs);
 
 	if (register_chrdev(SCSI_TAPE_MAJOR, "st", &st_fops) >= 0) {
-		if (scsi_register_device(&st_template) == 0) {
-			st_template.scsi_driverfs_driver.name = 
-				(char *)st_template.tag;
-			st_template.scsi_driverfs_driver.bus = 
-				&scsi_driverfs_bus_type;
-			driver_register(&st_template.scsi_driverfs_driver);
+		if (scsi_register_device(&st_template) == 0)
 			return 0;
-		}
 	}
 
 	printk(KERN_ERR "Unable to get major %d for SCSI tapes\n", MAJOR_NR);
@@ -3968,7 +3962,6 @@
 		kfree(scsi_tapes);
 	}
 	st_template.dev_max = 0;
-	remove_driver(&st_template.scsi_driverfs_driver);
 	printk(KERN_INFO "st: Unloaded.\n");
 }
 
