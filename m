From: Pete Zaitcev <zaitcev@redhat.com>
Subject: Cleanup for sd in 2.4.19
Date: Thu, 8 Aug 2002 01:58:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020808015806.B10154@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from zaitcev@localhost)
	by devserv.devel.redhat.com (8.11.6/8.11.0) id g785w6i13675
	for linux-scsi@vger.kernel.org; Thu, 8 Aug 2002 01:58:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

A pure cleanup here. I know that something that works should not
be fixed, but cheesh. There are limits to everything. I cannot wait
until James destroys all this crap, it's just too painful to read.

-- Pete

--- linux-2.4.18-7.94/drivers/scsi/sd.c	Wed Aug  7 14:28:03 2002
+++ linux-2.4.18-7.94-s31/drivers/scsi/sd.c	Wed Aug  7 22:22:02 2002
@@ -119,7 +119,7 @@
 static int check_scsidisk_media_change(kdev_t);
 static int fop_revalidate_scsidisk(kdev_t);
 
-static int sd_init_onedisk(int);
+static void sd_init_onedisk(int);
 
 
 static int sd_init(void);
@@ -718,7 +718,6 @@
 {
 	int retval;
 	int target;
-	int flag = 0;
 	Scsi_Device * SDev;
 
 	target = DEVICE_NR(full_dev);
@@ -774,12 +773,11 @@
 	rscsi_disks[target].ready = 1;	/* FLOPTICAL */
 
 	retval = SDev->changed;
-	if (!flag)
-		SDev->changed = 0;
+	SDev->changed = 0;
 	return retval;
 }
 
-static int sd_init_onedisk(int i)
+static void sd_init_onedisk(int i)
 {
 	unsigned char cmd[10];
 	char nbuff[6];
@@ -799,7 +797,7 @@
 	 * of the other niceties.
 	 */
 	if (rscsi_disks[i].device->online == FALSE)
-		return i;
+		return;
 
 	/*
 	 * We need to retry the READ_CAPACITY because a UNIT_ATTENTION is
@@ -810,14 +808,14 @@
 	SRpnt = scsi_allocate_request(rscsi_disks[i].device);
 	if (!SRpnt) {
 		printk(KERN_WARNING "(sd_init_onedisk:) Request allocation failure.\n");
-		return i;
+		return;
 	}
 
 	buffer = (unsigned char *) scsi_malloc(512);
 	if (!buffer) {
 		printk(KERN_WARNING "(sd_init_onedisk:) Memory allocation failure.\n");
 		scsi_release_request(SRpnt);
-		return i;
+		return;
 	}
 
 	spintime = 0;
@@ -1095,7 +1093,7 @@
 	SRpnt = NULL;
 
 	scsi_free(buffer, 512);
-	return i;
+	return;
 }
 
 /*
@@ -1346,7 +1344,6 @@
 #define ALLOW_REVALIDATE rscsi_disks[target].device->allow_revalidate
 #define USAGE rscsi_disks[target].device->access_count
 #define CAPACITY rscsi_disks[target].capacity
-#define MAYBE_REINIT  sd_init_onedisk(target)
 
 /* This routine is called to flush all partitions and partition tables
  * for a changed scsi disk, and then re-read the new partition table.
@@ -1393,10 +1390,7 @@
 			sd_blocksizes[index] = 1024;
 	}
 
-#ifdef MAYBE_REINIT
-	MAYBE_REINIT;
-#endif
-
+	sd_init_onedisk(target);
 	grok_partitions(&SD_GENDISK(target), target % SCSI_DISKS_PER_MAJOR,
 			1<<4, CAPACITY);
 
