From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] removel useless mod use count manipulation
Date: Sat, 16 Nov 2002 20:40:09 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021116204009.A24052@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

There's a bunch of useless mod usecount handling in scsi:

o MOD_INC_USE_COUNT/MOD_DEC_USE_COUNT in exported functions that
  are only used outside this module - a module that has exported
  symbols use by other modules can't be unloaded at all
o GET_USE_COUNT checks in scsi_unregister_device/scsi_unregister_host -
  the scsi layer shouldn't care about the mod use count of the modules
  implementing drivers, and as they are usually called from the mod
  unload handler the check is totally pointless (if it ever triggers
  the scsi midlayer could try to scramble at freed memory).  Also
  GET_USE_COUNT is disfunct with the new module loader
o lacking ->owner in megaraid's chardev leading to junk
o double-increment of the modules use count in upper layer drivers
  (chardev/bdev open already gets a reference on ->owner for us)

I also had a patch to get the increment on the host driver module
in upper layer ->open right, but as Rusty's new loader changed the
interface for that I'll submit that one once the new loader appears
in the scsi tree.

===== drivers/scsi/NCR53C9x.c 1.12 vs edited =====
--- 1.12/drivers/scsi/NCR53C9x.c	Wed Oct  9 12:20:19 2002
+++ edited/drivers/scsi/NCR53C9x.c	Sat Nov 16 19:16:14 2002
@@ -732,9 +732,6 @@
 	/* Reset the thing before we try anything... */
 	esp_bootup_reset(esp, eregs);
 
-#ifdef MODULE
-	MOD_INC_USE_COUNT;
-#endif
 	esps_in_use++;
 }
 
@@ -3638,7 +3635,6 @@
 void cleanup_module(void) {}
 void esp_release(void)
 {
-	MOD_DEC_USE_COUNT;
 	esps_in_use--;
 	esps_running = esps_in_use;
 }
===== drivers/scsi/hosts.c 1.27 vs edited =====
--- 1.27/drivers/scsi/hosts.c	Thu Nov 14 13:19:04 2002
+++ edited/drivers/scsi/hosts.c	Sat Nov 16 19:14:08 2002
@@ -220,12 +220,6 @@
 	struct scsi_cmnd *scmd;
 
 	/*
-	 * Current policy is all shosts go away on unregister.
-	 */
-	if (shost->hostt->module && GET_USE_COUNT(shost->hostt->module))
-		return 1;
-
-	/*
 	 * FIXME Do ref counting.  We force all of the devices offline to
 	 * help prevent race conditions where other hosts/processors could
 	 * try and get in and queue a command.
@@ -520,8 +514,6 @@
 
 	cur_cnt = scsi_hosts_registered;
 
-	MOD_INC_USE_COUNT;
-
 	/*
 	 * The detect routine must carefully spinunlock/spinlock if it
 	 * enables interrupts, since all interrupt handlers do spinlock as
@@ -604,8 +596,6 @@
 	if (pcount != scsi_hosts_registered)
 		printk(KERN_INFO "scsi : %d host%s left.\n", scsi_hosts_registered,
 		       (scsi_hosts_registered == 1) ? "" : "s");
-
-	MOD_DEC_USE_COUNT;
 
 	unlock_kernel();
 	return 0;
===== drivers/scsi/megaraid.c 1.27 vs edited =====
--- 1.27/drivers/scsi/megaraid.c	Thu Oct 31 23:59:07 2002
+++ edited/drivers/scsi/megaraid.c	Sat Nov 16 19:15:23 2002
@@ -760,9 +760,8 @@
 /* For controller re-ordering */ 
 
 static struct file_operations megadev_fops = {
-	ioctl:megadev_ioctl_entry,
-	open:megadev_open,
-	release:megadev_close,
+	.owner		= THIS_MODULE,
+	.ioctl		= megadev_ioctl_entry,
 };
 
 /*
@@ -4333,15 +4332,6 @@
 	}
 }
 
-/*
- * Routines for the character/ioctl interface to the driver
- */
-static int megadev_open (struct inode *inode, struct file *filep)
-{
-	MOD_INC_USE_COUNT;
-	return 0;		/* success */
-}
-
 static int megadev_ioctl_entry (struct inode *inode, struct file *filep,
 		     unsigned int cmd, unsigned long arg)
 {
@@ -4851,16 +4841,6 @@
 
 	return scb;
 }
-
-static int
-megadev_close (struct inode *inode, struct file *filep)
-{
-#ifdef MODULE
-	MOD_DEC_USE_COUNT;
-#endif
-	return 0;
-}
-
 
 static int
 mega_support_ext_cdb(mega_host_config *this_hba)
===== drivers/scsi/osst.c 1.27 vs edited =====
--- 1.27/drivers/scsi/osst.c	Mon Nov 11 03:32:34 2002
+++ edited/drivers/scsi/osst.c	Sat Nov 16 19:20:34 2002
@@ -4176,8 +4176,6 @@
 
 	if (STp->device->host->hostt->module)
 		 __MOD_INC_USE_COUNT(STp->device->host->hostt->module);
-	if (osst_template.module)
-		 __MOD_INC_USE_COUNT(osst_template.module);
 	STp->device->access_count++;
 
 	if (mode != STp->current_mode) {
@@ -4520,8 +4518,6 @@
 
 	if (STp->device->host->hostt->module)
 	    __MOD_DEC_USE_COUNT(STp->device->host->hostt->module);
-	if (osst_template.module)
-	    __MOD_DEC_USE_COUNT(osst_template.module);
 
 	return retval;
 }
@@ -4651,8 +4647,6 @@
 
 	if (STp->device->host->hostt->module)
 		__MOD_DEC_USE_COUNT(STp->device->host->hostt->module);
-	if(osst_template.module)
-		__MOD_DEC_USE_COUNT(osst_template.module);
 
 	return result;
 }
===== drivers/scsi/scsi.c 1.61 vs edited =====
--- 1.61/drivers/scsi/scsi.c	Thu Nov 14 13:19:04 2002
+++ edited/drivers/scsi/scsi.c	Sat Nov 16 19:08:34 2002
@@ -2404,8 +2404,6 @@
 		}
 	}
 
-	MOD_INC_USE_COUNT;
-
 	if (out_of_space) {
 		scsi_unregister_device(tpnt);	/* easiest way to clean up?? */
 		return 1;
@@ -2422,12 +2420,6 @@
 	struct Scsi_Device_Template *prev_spnt;
 	
 	lock_kernel();
-	/*
-	 * If we are busy, this is not going to fly.
-	 */
-	if (GET_USE_COUNT(tpnt->module) != 0)
-		goto error_out;
-
 	driver_unregister(&tpnt->scsi_driverfs_driver);
 
 	/*
@@ -2458,16 +2450,12 @@
 		prev_spnt->next = spnt->next;
 	up_write(&scsi_devicelist_mutex);
 
-	MOD_DEC_USE_COUNT;
 	unlock_kernel();
 	/*
 	 * Final cleanup for the driver is done in the driver sources in the
 	 * cleanup function.
 	 */
 	return 0;
-error_out:
-	unlock_kernel();
-	return -1;
 }
 
 #ifdef CONFIG_PROC_FS
===== drivers/scsi/sd.c 1.91 vs edited =====
--- 1.91/drivers/scsi/sd.c	Sat Nov  9 18:48:20 2002
+++ edited/drivers/scsi/sd.c	Sat Nov 16 19:19:05 2002
@@ -453,8 +453,6 @@
 	 */
 	if (sdp->host->hostt->module)
 		__MOD_INC_USE_COUNT(sdp->host->hostt->module);
-	if (sd_template.module)
-		__MOD_INC_USE_COUNT(sd_template.module);
 	sdp->access_count++;
 
 	if (sdp->removable) {
@@ -498,8 +496,6 @@
 	sdp->access_count--;
 	if (sdp->host->hostt->module)
 		__MOD_DEC_USE_COUNT(sdp->host->hostt->module);
-	if (sd_template.module)
-		__MOD_DEC_USE_COUNT(sd_template.module);
 	return retval;	
 }
 
@@ -536,8 +532,6 @@
 	}
 	if (sdp->host->hostt->module)
 		__MOD_DEC_USE_COUNT(sdp->host->hostt->module);
-	if (sd_template.module)
-		__MOD_DEC_USE_COUNT(sd_template.module);
 
 	return 0;
 }
===== drivers/scsi/sg.c 1.39 vs edited =====
--- 1.39/drivers/scsi/sg.c	Wed Nov  6 21:06:38 2002
+++ edited/drivers/scsi/sg.c	Sat Nov 16 19:20:02 2002
@@ -1304,8 +1304,6 @@
 				if (sdp->device->host->hostt->module)
 					__MOD_DEC_USE_COUNT(sdp->device->host->hostt->module);
 			}
-			if (sg_template.module)
-				__MOD_DEC_USE_COUNT(sg_template.module);
 			sfp = NULL;
 		}
 	} else if (srp && srp->orphan) {
@@ -1529,8 +1527,6 @@
 				}
 				if (sfp->closed) {
 					sdp->device->access_count--;
-					if (sg_template.module)
-						__MOD_DEC_USE_COUNT(sg_template.module);
 					if (sdp->device->host->hostt->module)
 						__MOD_DEC_USE_COUNT(
 							sdp->device->host->
@@ -2522,8 +2518,6 @@
 		sfp->closed = 1;	/* flag dirty state on this fd */
 		sdp->device->access_count++;
 		/* MOD_INC's to inhibit unloading sg and associated adapter driver */
-		if (sg_template.module)
-			__MOD_INC_USE_COUNT(sg_template.module);
 		if (sdp->device->host->hostt->module)
 			__MOD_INC_USE_COUNT(sdp->device->host->hostt->module);
 		SCSI_LOG_TIMEOUT(1, printk("sg_remove_sfp: worrisome, %d writes pending\n",
===== drivers/scsi/sr.c 1.65 vs edited =====
--- 1.65/drivers/scsi/sr.c	Wed Nov  6 21:04:59 2002
+++ edited/drivers/scsi/sr.c	Sat Nov 16 19:20:31 2002
@@ -130,8 +130,6 @@
 	cd->device->access_count--;
 	if (cd->device->host->hostt->module)
 		__MOD_DEC_USE_COUNT(cd->device->host->hostt->module);
-	if (sr_template.module)
-		__MOD_DEC_USE_COUNT(sr_template.module);
 }
 
 static struct cdrom_device_ops sr_dops = {
@@ -473,8 +471,6 @@
 	cd->device->access_count++;
 	if (cd->device->host->hostt->module)
 		__MOD_INC_USE_COUNT(cd->device->host->hostt->module);
-	if (sr_template.module)
-		__MOD_INC_USE_COUNT(sr_template.module);
 
 	/* If this device did not have media in the drive at boot time, then
 	 * we would have been unable to get the sector size.  Check to see if
===== drivers/scsi/wd33c93.c 1.5 vs edited =====
--- 1.5/drivers/scsi/wd33c93.c	Wed Oct 16 18:51:48 2002
+++ edited/drivers/scsi/wd33c93.c	Sat Nov 16 19:13:37 2002
@@ -1853,7 +1853,6 @@
    printk("\n");
    printk("           Version %s - %s, Compiled %s at %s\n",
                WD33C93_VERSION,WD33C93_DATE,__DATE__,__TIME__);
-   MOD_INC_USE_COUNT;
 }
 
 
@@ -2031,7 +2030,6 @@
 #endif
 void wd33c93_release(void)
 {
-   MOD_DEC_USE_COUNT;
 }
 
 MODULE_LICENSE("GPL");
