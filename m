From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi sysfs (upper 2/3)
Date: Tue, 26 Nov 2002 00:12:52 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021126081252.GB3280@beaverton.ibm.com>
References: <20021126081047.GA3280@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.194.22])
	by e33.co.us.ibm.com (8.12.2/8.12.2) with ESMTP id gAQ8CZrw056392
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 03:12:35 -0500
Received: from hmsbounty (sig-9-65-8-42.mts.ibm.com [9.65.8.42])
	by westrelay01.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id gAQ8BIUC047764
	for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2002 01:11:19 -0700
Content-Disposition: inline
In-Reply-To: <20021126081047.GA3280@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 [upper level]
 	- Minor changes to Scsi_Device_Template init.
 
-andmike
--
Michael Anderson
andmike@us.ibm.com

 sd.c |    5 +++--
 sg.c |    8 +++++---
 sr.c |    6 ++++--
 st.c |   10 ++++++----
 4 files changed, 18 insertions(+), 11 deletions(-)
------

diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Mon Nov 25 14:51:53 2002
+++ b/drivers/scsi/sd.c	Mon Nov 25 14:51:53 2002
@@ -105,11 +105,13 @@
 	.module		= THIS_MODULE,
 	.list		= LIST_HEAD_INIT(sd_template.list),
 	.name		= "disk",
-	.tag		= "sd",
 	.scsi_type	= TYPE_DISK,
 	.attach		= sd_attach,
 	.detach		= sd_detach,
 	.init_command	= sd_init_command,
+	.scsi_driverfs_driver = {
+		.name   = "sd",
+	},
 };
 
 static struct scsi_disk *sd_find_by_sdev(Scsi_Device *sd)
@@ -1343,7 +1345,6 @@
 	scsi_unregister_device(&sd_template);
 	for (i = 0; i < SD_MAJORS; i++)
 		unregister_blkdev(SD_MAJOR(i), "sd");
-	driver_unregister(&sd_template.scsi_driverfs_driver);
 }
 
 /*
diff -Nru a/drivers/scsi/sg.c b/drivers/scsi/sg.c
--- a/drivers/scsi/sg.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/sg.c	Mon Nov 25 14:51:52 2002
@@ -122,10 +122,12 @@
 	.module = THIS_MODULE,
 	.list = LIST_HEAD_INIT(sg_template.list),
 	.name = "generic",
-	.tag = "sg",
 	.scsi_type = 0xff,
 	.attach = sg_attach,
-	.detach = sg_detach
+	.detach = sg_detach,
+	.scsi_driverfs_driver = {
+		.name = "sg",
+	},
 };
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
@@ -1464,7 +1466,7 @@
 	sprintf(sdp->sg_driverfs_dev.name, "%sgeneric",
 		scsidp->sdev_driverfs_dev.name);
 	sdp->sg_driverfs_dev.parent = &scsidp->sdev_driverfs_dev;
-	sdp->sg_driverfs_dev.bus = &scsi_driverfs_bus_type;
+	sdp->sg_driverfs_dev.bus = scsidp->sdev_driverfs_dev.bus;
 
 	sg_nr_dev++;
 	sg_dev_arr[k] = sdp;
diff -Nru a/drivers/scsi/sr.c b/drivers/scsi/sr.c
--- a/drivers/scsi/sr.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/sr.c	Mon Nov 25 14:51:52 2002
@@ -73,11 +73,13 @@
 	.module		= THIS_MODULE,
 	.list		= LIST_HEAD_INIT(sr_template.list),
 	.name		= "cdrom",
-	.tag		= "sr",
 	.scsi_type	= TYPE_ROM,
 	.attach		= sr_attach,
 	.detach		= sr_detach,
-	.init_command	= sr_init_command
+	.init_command	= sr_init_command,
+	.scsi_driverfs_driver = {
+		.name   = "sr",
+	},
 };
 
 static int sr_nr_dev;	/* XXX(hch) bad hack, we want a bitmap instead */
diff -Nru a/drivers/scsi/st.c b/drivers/scsi/st.c
--- a/drivers/scsi/st.c	Mon Nov 25 14:51:52 2002
+++ b/drivers/scsi/st.c	Mon Nov 25 14:51:53 2002
@@ -176,10 +176,12 @@
 	.module =	THIS_MODULE,
 	.list =		LIST_HEAD_INIT(st_template.list),
 	.name =		"tape", 
-	.tag =		"st", 
 	.scsi_type =	TYPE_TAPE,
 	.attach =	st_attach, 
-	.detach =	st_detach
+	.detach =	st_detach,
+	.scsi_driverfs_driver = {
+		.name = "st",
+	},
 };
 
 static int st_compression(Scsi_Tape *, int);
@@ -3826,7 +3828,7 @@
 	    sprintf(tpnt->driverfs_dev_r[mode].name, "%s%s", 
 		    SDp->sdev_driverfs_dev.name, name);
 	    tpnt->driverfs_dev_r[mode].parent = &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_r[mode].bus = &scsi_driverfs_bus_type;
+	    tpnt->driverfs_dev_r[mode].bus = SDp->sdev_driverfs_dev.bus;
 	    tpnt->driverfs_dev_r[mode].driver_data =
 			(void *)(long)__mkdev(SCSI_TAPE_MAJOR, dev_num + (mode << 5));
 	    device_register(&tpnt->driverfs_dev_r[mode]);
@@ -3845,7 +3847,7 @@
 	    sprintf(tpnt->driverfs_dev_n[mode].name, "%s%s", 
 		    SDp->sdev_driverfs_dev.name, name);
 	    tpnt->driverfs_dev_n[mode].parent= &SDp->sdev_driverfs_dev;
-	    tpnt->driverfs_dev_n[mode].bus = &scsi_driverfs_bus_type;
+	    tpnt->driverfs_dev_n[mode].bus = SDp->sdev_driverfs_dev.bus;
 	    tpnt->driverfs_dev_n[mode].driver_data =
 			(void *)(long)__mkdev(SCSI_TAPE_MAJOR, dev_num + (mode << 5) + 128);
 	    device_register(&tpnt->driverfs_dev_n[mode]);

