From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove sd_disks global array from sd.c
Date: Sun, 27 Oct 2002 17:09:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027170949.B15779@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Add a pointer to struct scsi_disk instead.  This also obsoletes
sd_dskname().


--- 1.77/drivers/scsi/sd.c	Fri Oct 25 21:20:04 2002
+++ edited/drivers/scsi/sd.c	Sun Oct 27 15:54:59 2002
@@ -85,6 +85,7 @@
 
 struct scsi_disk {
 	struct scsi_device *device;
+	struct gendisk	*disk;
 	sector_t	capacity;	/* size in 512-byte sectors */
 	u8		media_present;
 	u8		write_prot;
@@ -258,25 +259,6 @@
 	}
 }
 
-static void sd_dskname(unsigned int dsk_nr, char *buffer)
-{
-	if (dsk_nr < 26)
-		sprintf(buffer, "sd%c", 'a' + dsk_nr);
-	else {
-		unsigned int min1;
-		unsigned int min2;
-		/*
-		 * For larger numbers of disks, we need to go to a new
-		 * naming scheme.
-		 */
-		min1 = dsk_nr / 26;
-		min2 = dsk_nr % 26;
-		sprintf(buffer, "sd%c%c", 'a' + min1 - 1, 'a' + min2);
-	}
-}
-
-static struct gendisk **sd_disks;
-
 /**
  *	sd_init_command - build a scsi (read or write) command from
  *	information in the request structure.
@@ -1271,11 +1253,8 @@
 			sd_dsk_arr[k] = sdkp;
 		}
 	}
-	init_mem_lth(sd_disks, sd_template.dev_max);
-	if (sd_disks)
-		zero_mem_lth(sd_disks, sd_template.dev_max);
 
-	if (!sd_dsk_arr || !sd_disks)
+	if (!sd_dsk_arr)
 		goto cleanup_mem;
 
 	return 0;
@@ -1284,8 +1263,6 @@
 #undef zero_mem_lth
 
 cleanup_mem:
-	vfree(sd_disks);
-	sd_disks = NULL;
 	if (sd_dsk_arr) {
                 for (k = 0; k < sd_template.dev_max; ++k)
 			vfree(sd_dsk_arr[k]);
@@ -1394,8 +1371,7 @@
 
 	set_capacity(gd, sdkp->capacity);
 	add_disk(gd);
-
-	sd_disks[dsk_nr] = gd;
+	sdkp->disk = gd;
 
 	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
 	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
@@ -1461,12 +1437,11 @@
 	sdkp->capacity = 0;
 	/* sdkp->detaching = 1; */
 
-	del_gendisk(sd_disks[dsk_nr]);
+	del_gendisk(sdkp->disk);
 	sdp->attached--;
 	sd_template.dev_noticed--;
 	sd_template.nr_dev--;
-	put_disk(sd_disks[dsk_nr]);
-	sd_disks[dsk_nr] = NULL;
+	put_disk(sdkp->disk);
 }
 
 /**
@@ -1556,13 +1531,8 @@
 	if (!SDpnt->online)
 		return 0;
 
-	if(verbose) {
-		char buf[16];
-
-		sd_dskname(index, buf);
-
-		printk("%s ", buf);
-	}
+	if (verbose)
+		printk("%s ", sdkp->disk->disk_name);
 
 	SRpnt = scsi_allocate_request(SDpnt);
 	if(!SRpnt) {
