From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] add cache synchronisation to sd
Date: Sun, 29 Sep 2002 17:06:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209292106.g8TL6b825650@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_18137315840"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA17799
	for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2002 14:06:42 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id OAA17660
	for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2002 14:06:39 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g8TL6b825650
	for <linux-scsi@vger.kernel.org>; Sun, 29 Sep 2002 17:06:37 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_18137315840
Content-Type: text/plain; charset=us-ascii

Not that I agree with running ordinary (non UPS battery backed) devices with 
writeback caches, but I know most modern SCSI devices come with writeback 
caches, so this code (like the corresponding IDE code) detects the cache 
setting on attach and flushes the drive cache on shutdown.

James


--==_Exmh_18137315840
Content-Type: text/plain ; name="sd-cache-fix.diff"; charset=us-ascii
Content-Description: sd-cache-fix.diff
Content-Disposition: attachment; filename="sd-cache-fix.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	v2.5.39 -> 1.640  
#	   drivers/scsi/sd.c	1.27.1.30 -> 1.36   
#	   drivers/scsi/sd.h	1.2.1.2 -> 1.5    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/09/27	torvalds@penguin.transmeta.com	1.636
# Linux v2.5.39
# --------------------------------------------
# 02/09/28	jejb@mulgrave.(none)	1.637
# Merge mulgrave.(none):/home/jejb/BK/scsi-sd-cache-2.5
# into mulgrave.(none):/home/jejb/BK/scsi-sd-cache-new-2.5
# --------------------------------------------
# 02/09/28	jejb@mulgrave.(none)	1.638
# sd cache settings: upport
# --------------------------------------------
# 02/09/29	jejb@mulgrave.(none)	1.639
# sd cache small fix
# --------------------------------------------
# 02/09/29	jejb@mulgrave.(none)	1.640
# correct tab stops
# --------------------------------------------
#
diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c
--- a/drivers/scsi/sd.c	Sun Sep 29 17:01:33 2002
+++ b/drivers/scsi/sd.c	Sun Sep 29 17:01:33 2002
@@ -42,6 +42,7 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/reboot.h>
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
 
@@ -98,6 +99,10 @@
 static int sd_detect(Scsi_Device *);
 static void sd_detach(Scsi_Device *);
 static int sd_init_command(Scsi_Cmnd *);
+static int sd_synchronize_cache(int, int);
+static int sd_notifier(struct notifier_block *, unsigned long, void *);
+
+static struct notifier_block sd_notifier_block = {sd_notifier, NULL, 0}; 
 
 static struct Scsi_Device_Template sd_template = {
 	module:THIS_MODULE,
@@ -574,6 +579,11 @@
 		__MOD_DEC_USE_COUNT(sdp->host->hostt->module);
 	if (sd_template.module)
 		__MOD_DEC_USE_COUNT(sd_template.module);
+
+	/* check that we actually have a write back cache to synchronize */
+	if(sdkp->WCE)
+		sd_synchronize_cache(dsk_nr, 1);
+		       
 	return 0;
 }
 
@@ -881,6 +891,74 @@
 }
 
 /*
+ * sd_read_cache_type - called only from sd_init_onedisk()
+ */
+static void
+sd_read_cache_type(Scsi_Disk *sdkp, char *diskname,
+		   Scsi_Request *SRpnt, unsigned char *buffer) {
+
+	unsigned char cmd[10];
+	Scsi_Device *sdp = sdkp->device;
+	int the_result, retries;
+
+	retries = 3;
+	do {
+
+		memset((void *) &cmd[0], 0, 10);
+		cmd[0] = MODE_SENSE;
+		cmd[1] = (sdp->scsi_level <= SCSI_2) ?
+			 ((sdp->lun << 5) & 0xe0) : 0;
+		cmd[1] |= 0x08;	/* DBD */
+		cmd[2] = 0x08;	/* current values, cache page */
+		cmd[4] = 128;	/* allocation length */
+
+
+		memset((void *) buffer, 0, 24);
+		SRpnt->sr_cmd_len = 0;
+		SRpnt->sr_sense_buffer[0] = 0;
+		SRpnt->sr_sense_buffer[2] = 0;
+
+		SRpnt->sr_data_direction = SCSI_DATA_READ;
+		scsi_wait_req(SRpnt, (void *) cmd, (void *) buffer,
+			    24, SD_TIMEOUT, MAX_RETRIES);
+
+		the_result = SRpnt->sr_result;
+		retries--;
+
+	} while (the_result && retries);
+
+	if (the_result) {
+		printk(KERN_ERR "%s : MODE SENSE failed.\n"
+		       "%s : status = %x, message = %02x, host = %d, driver = %02x \n",
+		       diskname, diskname,
+		       status_byte(the_result),
+		       msg_byte(the_result),
+		       host_byte(the_result),
+		       driver_byte(the_result)
+		    );
+		if (driver_byte(the_result) & DRIVER_SENSE)
+			print_req_sense("sd", SRpnt);
+		else
+			printk(KERN_ERR "%s : sense not available. \n", diskname);
+
+		printk(KERN_ERR "%s : assuming drive cache: write through\n", diskname);
+		sdkp->WCE = 0;
+		sdkp->RCD = 0;
+	} else {
+		const char *types[] = { "write through", "none", "write back", "write back, no read (daft)" };
+		int ct = 0;
+		int offset = buffer[3] + 4; /* offset to start of mode page */
+
+		sdkp->WCE = (buffer[offset + 2] & 0x04) == 0x04;
+		sdkp->RCD = (buffer[offset + 2] & 0x01) == 0x01;
+
+		ct =  sdkp->RCD + 2*sdkp->WCE;
+
+		printk(KERN_NOTICE "SCSI device %s: drive cache: %s\n", diskname, types[ct]);
+	}
+}
+
+/*
  * read disk capacity - called only in sd_init_onedisk()
  */
 static void
@@ -1118,6 +1196,7 @@
 	sdkp->write_prot = 0;
 
 	sd_spinup_disk(sdkp, diskname, SRpnt, buffer);
+	sd_read_cache_type(sdkp, diskname, SRpnt, buffer);
 
 	if (sdkp->media_present)
 		sd_read_capacity(sdkp, diskname, SRpnt, buffer);
@@ -1442,6 +1521,7 @@
 		sd_template.scsi_driverfs_driver.name = (char *)sd_template.tag;
 		sd_template.scsi_driverfs_driver.bus = &scsi_driverfs_bus_type;
 		driver_register(&sd_template.scsi_driverfs_driver);
+		register_reboot_notifier(&sd_notifier_block);
 	}
 	return rc;
 }
@@ -1470,6 +1550,86 @@
 		blk_dev[SD_MAJOR(k)].queue = NULL;
 	sd_template.dev_max = 0;
 	remove_driver(&sd_template.scsi_driverfs_driver);
+
+	unregister_reboot_notifier(&sd_notifier_block);
+}
+
+static int sd_notifier(struct notifier_block *nbt, unsigned long event, void *buf)
+{
+	int i;
+
+	if (!(event == SYS_RESTART || event == SYS_HALT 
+	      || event == SYS_POWER_OFF))
+		return NOTIFY_DONE;
+	for (i = 0; i < sd_template.dev_max; i++) {
+		Scsi_Disk *sdkp = sd_get_sdisk(i);
+
+		if (!sdkp || !sdkp->device)
+			continue;
+		if (sdkp->WCE)
+			sd_synchronize_cache(i, 1);
+	}
+
+	return NOTIFY_OK;
+}
+
+/* send a SYNCHRONIZE CACHE instruction down to the device through the
+ * normal SCSI command structure.  Wait for the command to complete (must
+ * have user context) */
+static int sd_synchronize_cache(int index, int verbose)
+{
+	Scsi_Request *SRpnt;
+	Scsi_Disk *sdkp = sd_get_sdisk(index);
+	Scsi_Device *SDpnt = sdkp->device;
+	int retries, the_result;
+
+	if(verbose) {
+		char buf[16];
+
+		sd_dskname(index, buf);
+
+		printk("%s: synchronizing cache...", buf);
+	}
+
+	SRpnt = scsi_allocate_request(SDpnt);
+	if(!SRpnt) {
+		if(verbose)
+			printk("FAILED\n  No memory for request\n");
+		return 0;
+	}
+		
+
+	for(retries = 3; retries > 0; --retries) {
+		unsigned char cmd[10] = { 0 };
+
+		cmd[0] = SYNCHRONIZE_CACHE;
+		cmd[1] = SDpnt->scsi_level <= SCSI_2 ? (SDpnt->lun << 5) & 0xe0 : 0;
+		/* leave the rest of the command zero to indicate 
+		 * flush everything */
+		scsi_wait_req(SRpnt, (void *)cmd, NULL, 0,
+			      SD_TIMEOUT, MAX_RETRIES);
+
+		if(SRpnt->sr_result == 0)
+			break;
+	}
+
+	the_result = SRpnt->sr_result;
+	scsi_release_request(SRpnt);
+	if(verbose) {
+		if(the_result == 0) {
+			printk("OK\n");
+		} else {
+			printk("FAILED\n  status = %x, message = %02x, host = %d, driver = %02x\n  ",
+			       status_byte(the_result),
+			       msg_byte(the_result),
+			       host_byte(the_result),
+			       driver_byte(the_result));
+			if (driver_byte(the_result) & DRIVER_SENSE)
+				print_req_sense("sd", SRpnt);
+
+		}
+	}
+	return (the_result == 0);
 }
 
 static Scsi_Disk * sd_get_sdisk(int index)
diff -Nru a/drivers/scsi/sd.h b/drivers/scsi/sd.h
--- a/drivers/scsi/sd.h	Sun Sep 29 17:01:33 2002
+++ b/drivers/scsi/sd.h	Sun Sep 29 17:01:33 2002
@@ -26,6 +26,8 @@
 	unsigned char media_present;
 	unsigned char write_prot;
 	unsigned has_been_registered:1;
+	unsigned WCE:1;         /* state of disk WCE bit */
+	unsigned RCD:1;         /* state of disk RCD bit */
 } Scsi_Disk;
 
 extern int revalidate_scsidisk(kdev_t dev, int maxusage);

--==_Exmh_18137315840--


