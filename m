From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 03:49:12 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107034912.A5155@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Okay, we're finally at the point where ->detect has become entirely
superflous.  In sd, sr and st it does nothing but return different
values that are ignored anyway, in sg it increments a variable
that is never read (and thus removed in this patch aswell), only
in osst it increments a variable that is actually checked for beeing
non-zero.  But if it was zero we'd never reached that place anyway
(same check in the beginning of osst_detect and osst_attach).

This make the upper layer interface a lot nicer and avoids the
race condition where a device is remove between detect and attach
(which currently wouldn't matter anyway as we aren't doing anything
in detect anymore)



--- 1.33/drivers/scsi/hosts.h	Wed Nov  6 17:53:34 2002
+++ edited/drivers/scsi/hosts.h	Thu Nov  7 02:07:35 2002
@@ -554,7 +554,6 @@
     const char * tag;
     struct module * module;	  /* Used for loadable modules */
     unsigned char scsi_type;
-    int (*detect)(Scsi_Device *); /* Returns 1 if we can attach this device */
     int (*attach)(Scsi_Device *); /* Attach devices to arrays */
     void (*detach)(Scsi_Device *);
     int (*init_command)(Scsi_Cmnd *);     /* Used by new queueing code. 
===== drivers/scsi/osst.c 1.25 vs edited =====
--- 1.25/drivers/scsi/osst.c	Tue Nov  5 12:26:53 2002
+++ edited/drivers/scsi/osst.c	Thu Nov  7 02:07:19 2002
@@ -153,10 +153,8 @@
 
 static int osst_init(void);
 static int osst_attach(Scsi_Device *);
-static int osst_detect(Scsi_Device *);
 static void osst_detach(Scsi_Device *);
 
-static int osst_dev_noticed;
 static int osst_nr_dev;
 static int osst_dev_max;
 
@@ -166,7 +164,6 @@
        name:		"OnStream tape",
        tag:		"osst",
        scsi_type:	TYPE_TAPE,
-       detect:		osst_detect,
        attach:		osst_attach,
        detach:		osst_detach
 };
@@ -5564,15 +5561,6 @@
 	return 0;
 };
 
-static int osst_detect(Scsi_Device * SDp)
-{
-	if (SDp->type != TYPE_TAPE) return 0;
-	if ( ! osst_supports(SDp) ) return 0;
-	
-	osst_dev_noticed++;
-	return 1;
-}
-
 static int osst_registered = 0;
 
 /* Driver initialization (not __initfunc because may be called later) */
@@ -5580,9 +5568,6 @@
 {
 	int i;
 
-	if (osst_dev_noticed == 0)
-		return 0;
-
 	if (!osst_registered) {
 		if (register_chrdev(MAJOR_NR,"osst",&osst_fops)) {
 			printk(KERN_ERR "osst :W: Unable to get major %d for OnStream tapes\n",MAJOR_NR);
@@ -5653,7 +5638,6 @@
 		os_scsi_tapes[i] = NULL;
 		scsi_slave_detach(SDp);
 		osst_nr_dev--;
-		osst_dev_noticed--;
 		return;
 	}
   }
===== drivers/scsi/scsi.c 1.57 vs edited =====
--- 1.57/drivers/scsi/scsi.c	Wed Nov  6 17:53:34 2002
+++ edited/drivers/scsi/scsi.c	Thu Nov  7 02:10:15 2002
@@ -1958,17 +1958,6 @@
 }
 #endif
 
-void scsi_detect_device(struct scsi_device *sdev)
-{
-	struct Scsi_Device_Template *sdt;
-
-	down_read(&scsi_devicelist_mutex);
-	for (sdt = scsi_devicelist; sdt; sdt = sdt->next)
-		if (sdt->detect)
-			(*sdt->detect)(sdev);
-	up_read(&scsi_devicelist_mutex);
-}
-
 int scsi_attach_device(struct scsi_device *sdev)
 {
 	struct Scsi_Device_Template *sdt;
@@ -2089,22 +2078,6 @@
 
 	driver_register(&tpnt->scsi_driverfs_driver);
 
-	/*
-	 * First scan the devices that we know about, and see if we notice them.
-	 */
-
-	for (shpnt = scsi_host_get_next(NULL); shpnt;
-	     shpnt = scsi_host_get_next(shpnt)) {
-		for (SDpnt = shpnt->host_queue; SDpnt;
-		     SDpnt = SDpnt->next) {
-			if (tpnt->detect)
-				(*tpnt->detect) (SDpnt);
-		}
-	}
-
-	/*
-	 * Now actually connect the devices to the new driver.
-	 */
 	for (shpnt = scsi_host_get_next(NULL); shpnt;
 	     shpnt = scsi_host_get_next(shpnt)) {
 		for (SDpnt = shpnt->host_queue; SDpnt;
===== drivers/scsi/scsi.h 1.34 vs edited =====
--- 1.34/drivers/scsi/scsi.h	Tue Nov  5 12:26:24 2002
+++ edited/drivers/scsi/scsi.h	Thu Nov  7 02:08:24 2002
@@ -480,7 +480,6 @@
 			int timeout, int retries);
 extern int scsi_dev_init(void);
 extern int scsi_mlqueue_insert(struct scsi_cmnd *, int);
-extern void scsi_detect_device(struct scsi_device *);
 extern int scsi_attach_device(struct scsi_device *);
 extern void scsi_detach_device(struct scsi_device *);
 
===== drivers/scsi/scsi_scan.c 1.33 vs edited =====
--- 1.33/drivers/scsi/scsi_scan.c	Tue Nov  5 12:27:24 2002
+++ edited/drivers/scsi/scsi_scan.c	Thu Nov  7 02:08:41 2002
@@ -1478,8 +1478,6 @@
 	 * function */
 	sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
 
-	scsi_detect_device(sdev);
-
 	if (sdevnew != NULL)
 		*sdevnew = sdev;
 
===== drivers/scsi/sd.c 1.89 vs edited =====
--- 1.89/drivers/scsi/sd.c	Tue Nov  5 12:29:12 2002
+++ edited/drivers/scsi/sd.c	Thu Nov  7 02:04:51 2002
@@ -94,7 +94,6 @@
 static void sd_rw_intr(struct scsi_cmnd * SCpnt);
 
 static int sd_attach(struct scsi_device *);
-static int sd_detect(struct scsi_device *);
 static void sd_detach(struct scsi_device *);
 static int sd_init_command(struct scsi_cmnd *);
 static int sd_synchronize_cache(struct scsi_disk *, int);
@@ -107,7 +106,6 @@
 	.name		= "disk",
 	.tag		= "sd",
 	.scsi_type	= TYPE_DISK,
-	.detect		= sd_detect,
 	.attach		= sd_attach,
 	.detach		= sd_detach,
 	.init_command	= sd_init_command,
@@ -1163,23 +1161,6 @@
 	scsi_release_request(SRpnt);
 
 	kfree(buffer);
-}
-
-/**
- *	sd_detect - called at the start of driver initialization, once 
- *	for each scsi device (not just disks) present.
- *
- *	Returns 0 if not interested in this scsi device (e.g. scanner);
- *	1 if this device is of interest (e.g. a disk).
- *
- *	Note: this function is invoked from the scsi mid-level.
- **/
-static int sd_detect(struct scsi_device * sdp)
-{
-	SCSI_LOG_HLQUEUE(3, printk("sd_detect: type=%d\n", sdp->type));
-	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD)
-		return 0;
-	return 1;
 }
 
 /**
===== drivers/scsi/sg.c 1.38 vs edited =====
--- 1.38/drivers/scsi/sg.c	Tue Nov  5 12:30:41 2002
+++ edited/drivers/scsi/sg.c	Thu Nov  7 02:06:38 2002
@@ -111,7 +111,6 @@
 #define SG_DEV_ARR_LUMP 6	/* amount to over allocate sg_dev_arr by */
 
 static int sg_attach(Scsi_Device *);
-static int sg_detect(Scsi_Device *);
 static void sg_detach(Scsi_Device *);
 
 static Scsi_Request *dummy_cmdp;	/* only used for sizeof */
@@ -124,7 +123,6 @@
 	.name = "generic",
 	.tag = "sg",
 	.scsi_type = 0xff,
-	.detect = sg_detect,
 	.attach = sg_attach,
 	.detach = sg_detach
 };
@@ -233,7 +231,6 @@
 #endif
 
 static Sg_device **sg_dev_arr = NULL;
-static int sg_dev_noticed;
 static int sg_dev_max;
 static int sg_nr_dev;
 
@@ -1338,13 +1335,6 @@
 	.fasync = sg_fasync,
 };
 
-static int
-sg_detect(Scsi_Device * scsidp)
-{
-	sg_dev_noticed++;
-	return 1;
-}
-
 #ifndef MODULE
 static int __init
 sg_def_reserved_size_setup(char *str)
@@ -1563,7 +1553,6 @@
 		}
 		scsi_slave_detach(scsidp);
 		sg_nr_dev--;
-		sg_dev_noticed--;	/* from <dan@lectra.fr> */
 		break;
 	}
 	write_unlock_irqrestore(&sg_dev_arr_lock, iflags);
===== drivers/scsi/sr.c 1.64 vs edited =====
--- 1.64/drivers/scsi/sr.c	Tue Nov  5 12:37:40 2002
+++ edited/drivers/scsi/sr.c	Thu Nov  7 02:04:59 2002
@@ -66,7 +66,6 @@
 	 CDC_CD_R|CDC_CD_RW|CDC_DVD|CDC_DVD_R|CDC_GENERIC_PACKET)
 
 static int sr_attach(struct scsi_device *);
-static int sr_detect(struct scsi_device *);
 static void sr_detach(struct scsi_device *);
 static int sr_init_command(struct scsi_cmnd *);
 
@@ -75,7 +74,6 @@
 	.name		= "cdrom",
 	.tag		= "sr",
 	.scsi_type	= TYPE_ROM,
-	.detect		= sr_detect,
 	.attach		= sr_attach,
 	.detach		= sr_detach,
 	.init_command	= sr_init_command
@@ -487,14 +485,6 @@
 		get_sectorsize(cd);
 
 	return 0;
-}
-
-static int sr_detect(struct scsi_device * SDp)
-{
-
-	if (SDp->type != TYPE_ROM && SDp->type != TYPE_WORM)
-		return 0;
-	return 1;
 }
 
 static int sr_attach(struct scsi_device *sdev)
===== drivers/scsi/st.c 1.40 vs edited =====
--- 1.40/drivers/scsi/st.c	Tue Nov  5 12:36:00 2002
+++ edited/drivers/scsi/st.c	Thu Nov  7 02:05:21 2002
@@ -170,7 +170,6 @@
 static int sgl_unmap_user_pages(struct scatterlist *, const unsigned int, int);
 
 static int st_attach(Scsi_Device *);
-static int st_detect(Scsi_Device *);
 static void st_detach(Scsi_Device *);
 
 static struct Scsi_Device_Template st_template = {
@@ -178,7 +177,6 @@
 	.name =		"tape", 
 	.tag =		"st", 
 	.scsi_type =	TYPE_TAPE,
-	.detect =	st_detect, 
 	.attach =	st_attach, 
 	.detach =	st_detach
 };
@@ -3884,13 +3882,6 @@
 
 	return 0;
 };
-
-static int st_detect(Scsi_Device * SDp)
-{
-	if (SDp->type != TYPE_TAPE || st_incompatible(SDp))
-		return 0;
-	return 1;
-}
 
 static void st_detach(Scsi_Device * SDp)
 {
