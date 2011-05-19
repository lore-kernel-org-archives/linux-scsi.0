From: Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
Date: Thu, 19 May 2011 15:33:11 -0600
Message-ID: <1305840792-25877-9-git-send-email-jim.cromie@gmail.com>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, Jim Cromie <jim.cromie@gmail.com>, Doug Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Benny Halevy <bhalevy@panasas.com>, Boaz Harrosh <bharrosh@panasas.com>, osd-dev@open-osd.org, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
List-Id: linux-scsi@vger.kernel.org

cc: Doug Gilbert <dgilbert@interlog.com>
cc: linux-scsi@vger.kernel.org
cc: Benny Halevy <bhalevy@panasas.com>
cc: Boaz Harrosh <bharrosh@panasas.com>
cc: osd-dev@open-osd.org
cc: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
cc: linux-scsi@vger.kernel.org
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/scsi/osd/osd_uld.c |    6 +++---
 drivers/scsi/pmcraid.c     |    3 +--
 drivers/scsi/sg.c          |    6 +++---
 drivers/scsi/st.c          |    7 +++----
 4 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index b31a8e3..18dcd38 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -528,6 +528,7 @@ static struct scsi_driver osd_driver = {
 static int __init osd_uld_init(void)
 {
 	int err;
+	dev_t devt = MKDEV(SCSI_OSD_MAJOR, 0);
 
 	err = class_register(&osd_uld_class);
 	if (err) {
@@ -535,8 +536,7 @@ static int __init osd_uld_init(void)
 		return err;
 	}
 
-	err = register_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0),
-				     SCSI_OSD_MAX_MINOR, osd_name);
+	err = register_chrdev_ids(&devt, SCSI_OSD_MAX_MINOR, osd_name);
 	if (err) {
 		OSD_ERR("Unable to register major %d for osd ULD => %d\n",
 			SCSI_OSD_MAJOR, err);
@@ -553,7 +553,7 @@ static int __init osd_uld_init(void)
 	return 0;
 
 err_out_chrdev:
-	unregister_chrdev_region(MKDEV(SCSI_OSD_MAJOR, 0), SCSI_OSD_MAX_MINOR);
+	unregister_chrdev_region(devt, SCSI_OSD_MAX_MINOR);
 err_out:
 	class_unregister(&osd_uld_class);
 	return err;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 7f636b1..61a2207 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -6100,8 +6100,7 @@ static int __init pmcraid_init(void)
 			 PMCRAID_DRIVER_NAME,
 			 PMCRAID_DRIVER_VERSION, PMCRAID_DRIVER_DATE);
 
-	error = alloc_chrdev_region(&dev, 0,
-				    PMCRAID_MAX_ADAPTERS,
+	error = register_chrdev_ids(&dev, PMCRAID_MAX_ADAPTERS,
 				    PMCRAID_DEVFILE);
 
 	if (error) {
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 909ed9e..e741988 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1575,6 +1575,7 @@ static int __init
 init_sg(void)
 {
 	int rc;
+	dev_t devt = MKDEV(SCSI_GENERIC_MAJOR, 0);
 
 	if (scatter_elem_sz < PAGE_SIZE) {
 		scatter_elem_sz = PAGE_SIZE;
@@ -1585,8 +1586,7 @@ init_sg(void)
 	else
 		def_reserved_size = sg_big_buff;
 
-	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), 
-				    SG_MAX_DEVS, "sg");
+	rc = register_chrdev_ids(&devt, SG_MAX_DEVS, "sg");
 	if (rc)
 		return rc;
         sg_sysfs_class = class_create(THIS_MODULE, "scsi_generic");
@@ -1604,7 +1604,7 @@ init_sg(void)
 	}
 	class_destroy(sg_sysfs_class);
 err_out:
-	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
+	unregister_chrdev_region(devt, SG_MAX_DEVS);
 	return rc;
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 1871b8a..5cce227 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4260,6 +4260,7 @@ static void scsi_tape_release(struct kref *kref)
 static int __init init_st(void)
 {
 	int err;
+	dev_t devt = MKDEV(SCSI_TAPE_MAJOR, 0);
 
 	validate_options();
 
@@ -4272,8 +4273,7 @@ static int __init init_st(void)
 		return PTR_ERR(st_sysfs_class);
 	}
 
-	err = register_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
-				     ST_MAX_TAPE_ENTRIES, "st");
+	err = register_chrdev_ids(&devt, ST_MAX_TAPE_ENTRIES, "st");
 	if (err) {
 		printk(KERN_ERR "Unable to get major %d for SCSI tapes\n",
 		       SCSI_TAPE_MAJOR);
@@ -4293,8 +4293,7 @@ static int __init init_st(void)
 err_scsidrv:
 	scsi_unregister_driver(&st_template.gendrv);
 err_chrdev:
-	unregister_chrdev_region(MKDEV(SCSI_TAPE_MAJOR, 0),
-				 ST_MAX_TAPE_ENTRIES);
+	unregister_chrdev_region(devt, ST_MAX_TAPE_ENTRIES);
 err_class:
 	class_destroy(st_sysfs_class);
 	return err;
-- 
1.7.4.4
