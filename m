From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove sd_find_target
Date: Fri, 25 Oct 2002 05:00:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021025050014.A29065@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, benh@kernel.crashing.org
Cc: linux-scsi@vger.kernel.org

My removal of the global arrays in sd.c will break this function,
but Ben promised to rewrite the code using it properly.  Remove
it now to get some more pressure on him :)


--- 1.23/arch/ppc/platforms/pmac_setup.c	Mon Sep 16 00:52:02 2002
+++ edited/arch/ppc/platforms/pmac_setup.c	Fri Oct 25 03:52:07 2002
@@ -406,7 +406,7 @@
 void __init
 find_boot_device(void)
 {
-#if defined(CONFIG_SCSI) && defined(CONFIG_BLK_DEV_SD)
+#if 0 /*defined(CONFIG_SCSI) && defined(CONFIG_BLK_DEV_SD)*/
 	if (boot_host != NULL) {
 		boot_dev = sd_find_target(boot_host, boot_target);
 		if (!kdev_same(boot_dev, NODEV))
--- 1.75/drivers/scsi/sd.c	Mon Oct 21 16:52:13 2002
+++ edited/drivers/scsi/sd.c	Fri Oct 25 03:38:53 2002
@@ -121,49 +121,6 @@
 
 static Scsi_Disk * sd_get_sdisk(int index);
 
-#if defined(CONFIG_PPC32)
-/**
- *	sd_find_target - find kdev_t of first scsi disk that matches
- *	given host and scsi_id. 
- *	@host: Scsi_Host object pointer that owns scsi device of interest
- *	@scsi_id: scsi (target) id number of device of interest
- *
- *	Returns kdev_t of first scsi device that matches arguments or
- *	NODEV of no match.
- *
- *	Notes: Looks like a hack, should scan for <host,channel,id,lin>
- *	tuple.
- *	[Architectural dependency: ppc only.] Moved here from 
- *	arch/ppc/pmac_setup.c.
- **/
-kdev_t __init
-sd_find_target(void *hp, int scsi_id)
-{
-	Scsi_Disk *sdkp;
-	Scsi_Device *sdp;
-	struct Scsi_Host *shp = hp;
-	int dsk_nr;
-	kdev_t retval = NODEV;
-	unsigned long iflags;
-
-	SCSI_LOG_HLQUEUE(3, printk("sd_find_target: host_nr=%d, "
-			    "scsi_id=%d\n", shp->host_no, scsi_id));
-	read_lock_irqsave(&sd_dsk_arr_lock, iflags);
-	for (dsk_nr = 0; dsk_nr < sd_template.dev_max; ++dsk_nr) {
-		sdkp = sd_dsk_arr[dsk_nr];
-		if (sdkp == NULL)
-			continue;
-		sdp = sdkp->device;
-		if (sdp && (sdp->host == shp) && (sdp->id == scsi_id)) {
-			retval = MKDEV_SD(dsk_nr);
-			break;
-		}
-	}
-	read_unlock_irqrestore(&sd_dsk_arr_lock, iflags);
-	return retval;
-}
-#endif
-
 /**
  *	sd_ioctl - process an ioctl
  *	@inode: only i_rdev member may be used
--- 1.8/drivers/scsi/sd.h	Mon Oct 21 16:34:15 2002
+++ edited/drivers/scsi/sd.h	Fri Oct 25 03:51:03 2002
@@ -30,11 +30,6 @@
 } Scsi_Disk;
 
 extern int revalidate_scsidisk(kdev_t dev, int maxusage);
-
-/*
- * Used by pmac to find the device associated with a target.
- */
-extern kdev_t sd_find_target(void *host, int tgt);
 
 #define N_SD_MAJORS	8
 
