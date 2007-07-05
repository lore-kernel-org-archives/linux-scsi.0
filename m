From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 3/3] SCSI: st: remove gendisk from private data struct
Date: Thu, 5 Jul 2007 14:07:11 -0700
Message-ID: <20070705140711.357b7a09.kristen.c.accardi@intel.com>
References: <20070705205548.731821111@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23125 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762974AbXGEVK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 17:10:29 -0400
In-Reply-To: <20070705205548.731821111@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since gendisk is now part of scsi_device, don't store this struct
in private data struct

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/scsi/st.c
===================================================================
--- 2.6-git.orig/drivers/scsi/st.c
+++ 2.6-git/drivers/scsi/st.c
@@ -306,7 +306,7 @@ static char * st_incompatible(struct scs
 
 static inline char *tape_name(struct scsi_tape *tape)
 {
-	return tape->disk->disk_name;
+	return tape->device->disk->disk_name;
 }
 
 
@@ -3549,7 +3549,8 @@ static int st_ioctl(struct inode *inode,
 			    !capable(CAP_SYS_RAWIO))
 				i = -EPERM;
 			else
-				i = scsi_cmd_ioctl(file, STp->disk, cmd_in, p);
+				i = scsi_cmd_ioctl(file, STp->device->disk,
+						cmd_in, p);
 			if (i != -ENOTTY)
 				return i;
 			break;
@@ -3961,7 +3962,6 @@ static int st_probe(struct device *dev)
 		goto out_put_disk;
 	}
 	kref_init(&tpnt->kref);
-	tpnt->disk = disk;
 	sprintf(disk->disk_name, "st%d", i);
 	disk->private_data = &tpnt->driver;
 	disk->queue = SDp->request_queue;
@@ -4063,6 +4063,8 @@ static int st_probe(struct device *dev)
 			goto out_free_tape;
 	}
 
+	SDp->disk = disk;
+
 	sdev_printk(KERN_NOTICE, SDp,
 		    "Attached scsi tape %s\n", tape_name(tpnt));
 	sdev_printk(KERN_INFO, SDp, "%s: try direct i/o: %s (alignment %d B)\n",
@@ -4151,7 +4153,7 @@ static int st_remove(struct device *dev)
 static void scsi_tape_release(struct kref *kref)
 {
 	struct scsi_tape *tpnt = to_scsi_tape(kref);
-	struct gendisk *disk = tpnt->disk;
+	struct gendisk *disk = tpnt->device->disk;
 
 	tpnt->device = NULL;
 
@@ -4348,7 +4350,7 @@ static int do_create_class_files(struct 
 		   first modes always get the same names */
 		i = mode << (4 - ST_NBR_MODE_BITS);
 		snprintf(name, 10, "%s%s%s", rew ? "n" : "",
-			 STp->disk->disk_name, st_formats[i]);
+			 STp->device->disk->disk_name, st_formats[i]);
 		st_class_member =
 			class_device_create(st_sysfs_class, NULL,
 					    MKDEV(SCSI_TAPE_MAJOR,
Index: 2.6-git/drivers/scsi/st.h
===================================================================
--- 2.6-git.orig/drivers/scsi/st.h
+++ 2.6-git/drivers/scsi/st.h
@@ -167,7 +167,6 @@ struct scsi_tape {
 	unsigned char last_cmnd[6];
 	unsigned char last_sense[16];
 #endif
-	struct gendisk *disk;
 	struct kref     kref;
 };
 

-- 
