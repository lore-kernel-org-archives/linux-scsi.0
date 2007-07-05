From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [patch 2/3] SCSI: sr: remove gendisk from private data struct
Date: Thu, 5 Jul 2007 14:07:03 -0700
Message-ID: <20070705140703.a77d9f54.kristen.c.accardi@intel.com>
References: <20070705205548.731821111@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:43767 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762948AbXGEVKV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jul 2007 17:10:21 -0400
In-Reply-To: <20070705205548.731821111@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Since gendisk is now part of scsi_device, don't store this struct
in private data struct

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Index: 2.6-git/drivers/scsi/sr.c
===================================================================
--- 2.6-git.orig/drivers/scsi/sr.c
+++ 2.6-git/drivers/scsi/sr.c
@@ -265,9 +265,9 @@ static void rw_intr(struct scsi_cmnd * S
 			 * last 75 2K sectors, we decrease the saved size
 			 * value.
 			 */
-			if (error_sector < get_capacity(cd->disk) &&
+			if (error_sector < get_capacity(cd->device->disk) &&
 			    cd->capacity - error_sector < 4 * 75)
-				set_capacity(cd->disk, error_sector);
+				set_capacity(cd->device->disk, error_sector);
 			break;
 
 		case RECOVERED_ERROR:
@@ -302,7 +302,7 @@ static int sr_init_command(struct scsi_c
 	struct scsi_cd *cd = scsi_cd(SCpnt->request->rq_disk);
 
 	SCSI_LOG_HLQUEUE(1, printk("Doing sr request, dev = %s, block = %d\n",
-				cd->disk->disk_name, block));
+				cd->device->disk->disk_name, block));
 
 	if (!cd->device || !scsi_device_online(cd->device)) {
 		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n",
@@ -571,9 +571,7 @@ static int sr_probe(struct device *dev)
 	disk->flags = GENHD_FL_CD;
 
 	cd->device = sdev;
-	cd->disk = disk;
 	cd->driver = &sr_template;
-	cd->disk = disk;
 	cd->capacity = 0x1fffff;
 	cd->device->changed = 1;	/* force recheck CD type */
 	cd->use = 1;
@@ -603,7 +601,10 @@ static int sr_probe(struct device *dev)
 
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
+	if (sdev->media_change_notify)
+		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
 	add_disk(disk);
+	sdev->disk = disk;
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
@@ -688,7 +689,7 @@ static void get_sectorsize(struct scsi_c
 		 * Add this so that we have the ability to correctly gauge
 		 * what the device is capable of.
 		 */
-		set_capacity(cd->disk, cd->capacity);
+		set_capacity(cd->device->disk, cd->capacity);
 	}
 
 	queue = cd->device->request_queue;
@@ -850,7 +851,7 @@ static int sr_packet(struct cdrom_device
 static void sr_kref_release(struct kref *kref)
 {
 	struct scsi_cd *cd = container_of(kref, struct scsi_cd, kref);
-	struct gendisk *disk = cd->disk;
+	struct gendisk *disk = cd->device->disk;
 
 	spin_lock(&sr_index_lock);
 	clear_bit(disk->first_minor, sr_index_bits);
@@ -869,7 +870,7 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
-	del_gendisk(cd->disk);
+	del_gendisk(cd->device->disk);
 
 	mutex_lock(&sr_ref_mutex);
 	kref_put(&cd->kref, sr_kref_release);
Index: 2.6-git/drivers/scsi/sr.h
===================================================================
--- 2.6-git.orig/drivers/scsi/sr.h
+++ 2.6-git/drivers/scsi/sr.h
@@ -38,10 +38,9 @@ typedef struct scsi_cd {
 	unsigned readcd_known:1;	/* drive supports READ_CD (0xbe) */
 	unsigned readcd_cdda:1;	/* reading audio data using READ_CD */
 	struct cdrom_device_info cdi;
-	/* We hold gendisk and scsi_device references on probe and use
+	/* We hold scsi_device references on probe and use
 	 * the refs on this kref to decide when to release them */
 	struct kref kref;
-	struct gendisk *disk;
 } Scsi_CD;
 
 int sr_do_ioctl(Scsi_CD *, struct packet_command *);

-- 
