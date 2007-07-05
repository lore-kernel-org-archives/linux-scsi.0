From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 1/3] SCSI: osst: remove gendisk from private data struct
Date: Thu, 5 Jul 2007 14:06:48 -0700
Message-ID: <20070705140648.2c55c67e.kristen.c.accardi@intel.com>
References: <20070705205548.731821111@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9974 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762890AbXGEVKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 17:10:06 -0400
In-Reply-To: <20070705205548.731821111@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since gendisk is now part of scsi_device, don't store this struct
in private data struct

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/scsi/osst.c
===================================================================
--- 2.6-git.orig/drivers/scsi/osst.c
+++ 2.6-git/drivers/scsi/osst.c
@@ -191,7 +191,7 @@ static int osst_write_error_recovery(str
 
 static inline char *tape_name(struct osst_tape *tape)
 {
-	return tape->drive->disk_name;
+	return tape->device->disk->disk_name;
 }
 

 /* Routines that handle the interaction with mid-layer SCSI routines */
@@ -5803,7 +5803,6 @@ static int osst_probe(struct device *dev
 	drive->private_data = &tpnt->driver;
 	sprintf(drive->disk_name, "osst%d", dev_num);
 	tpnt->driver = &osst_template;
-	tpnt->drive = drive;
 	tpnt->in_use = 0;
 	tpnt->capacity = 0xfffff;
 	tpnt->dirty = 0;
@@ -5885,6 +5884,8 @@ static int osst_probe(struct device *dev
 			goto out_free_sysfs1;
 	}
 
+	SDp->disk = drive;
+
 	sdev_printk(KERN_INFO, SDp,
 		"osst :I: Attached OnStream %.5s tape as %s\n",
 		SDp->model, tape_name(tpnt));
@@ -5915,7 +5916,7 @@ static int osst_remove(struct device *de
 			osst_sysfs_destroy(MKDEV(OSST_MAJOR, i));
 			osst_sysfs_destroy(MKDEV(OSST_MAJOR, i+128));
 			tpnt->device = NULL;
-			put_disk(tpnt->drive);
+			put_disk(tpnt->device->disk);
 			os_scsi_tapes[i] = NULL;
 			osst_nr_dev--;
 			write_unlock(&os_scsi_tapes_lock);
@@ -5988,7 +5989,7 @@ static void __exit exit_osst (void)
 				normalize_buffer(STp->buffer);
 				kfree(STp->buffer);
 			}
-			put_disk(STp->drive);
+			put_disk(STp->device->disk);
 			kfree(STp);
 		}
 		kfree(os_scsi_tapes);
Index: 2.6-git/drivers/scsi/osst.h
===================================================================
--- 2.6-git.orig/drivers/scsi/osst.h
+++ 2.6-git/drivers/scsi/osst.h
@@ -623,7 +623,6 @@ struct osst_tape {
   unsigned char last_cmnd[6];
   unsigned char last_sense[16];
 #endif
-  struct gendisk *drive;
 } ;
 
 /* scsi tape command */

-- 
