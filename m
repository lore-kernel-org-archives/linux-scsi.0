From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: megaraid 2.00rc5 -> kernel 2.5.41 diff
Date: Tue, 8 Oct 2002 11:56:38 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210081155390.32358-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tux.us.dell.com (tux.us.dell.com [143.166.152.29])
	by smtp2.us.dell.com (8.12.1/8.12.5) with ESMTP id g98GsWre025058
	for <linux-scsi@vger.kernel.org>; Tue, 8 Oct 2002 11:54:32 -0500
Received: from humbolt.us.dell.com ([10.180.92.254])
	by tux.us.dell.com (8.11.0/8.11.0) with ESMTP id g98Gucj07279
	for <linux-scsi@vger.kernel.org>; Tue, 8 Oct 2002 11:56:38 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Below is a patch listing the changes I made to megaraid 2.00rc5 to make it 
build and run on kernel 2.5.41.

The changes are pretty straightforward:
* include scsicam.h for scsi_bios_ptable
* name it 'megaraid2'
* use scsi_assign_lock()
* use page_address()
* use megaraid_biosparam() and mega_partsize() from the 1.18
driver currently in 2.5.41
* drop can_do_varyio and use_new_eh_code in SHT
* switch to named initializers in SHT

No doubt additional changes will be necessary, but this "works for me".

Feedback welcome.

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

--- /home/mdomsch/megaraid/megaraid-v2.00rc5/megaraid.c	Sun Sep 22 12:59:17 2002
+++ linux-2.5-megaraid/drivers/scsi/megaraid2.c	Tue Oct  8 11:36:36 2002
@@ -15,6 +15,7 @@
  *	  - lots of cleanups.
  *
  * Version : v2.00rc5 (Sep 20, 2002) - Atul Mukker <Atul.Mukker@lsil.com>
+ *  for kernel 2.5.41 by Matt Domsch <Matt_Domsch@dell.com>
  *
  * Description: Linux device driver for LSI Logic MegaRAID controller
  *
@@ -42,8 +43,9 @@
 #include "sd.h"
 #include "scsi.h"
 #include "hosts.h"
+#include <scsi/scsicam.h>
 
-#include "megaraid.h"
+#include "megaraid2.h"
 
 MODULE_AUTHOR ("LSI Logic Corporation");
 MODULE_DESCRIPTION ("LSI Logic MegaRAID driver");
@@ -380,7 +382,7 @@
 
 		adapter->flag = flag;
 		spin_lock_init(&adapter->lock);
-		host->lock = &adapter->lock;
+		scsi_assign_lock(host, &adapter->lock);
 
 		host->cmd_per_lun = max_cmd_per_lun;
 		host->max_sectors = max_sectors_per_io;
@@ -2032,7 +2034,8 @@
 				if( cmd->use_sg ) {
 					sgl = (struct scatterlist *)
 						cmd->request_buffer;
-					c = *(u8 *)sgl[0].address;
+					/* MLD - is this right??  */
+					c = *(u8 *)page_address(sgl[0].page);
 				}
 				else {
 					c = *(u8 *)cmd->request_buffer;
@@ -2156,8 +2159,6 @@
 
 	list_for_each(pos, &adapter->completed_list) {
 		cmd = list_entry(pos, Scsi_Cmnd, SCp);
-
-		prefetch(cmd->request.bh);
 		cmd->scsi_done(cmd);
 	}
 
@@ -3799,23 +3800,17 @@
 #endif
 
 
-/**
- * megaraid_biosparam()
- * @disk
- * @dev
- * @geom
- *
+/*-------------------------------------------------------------
  * Return the disk geometry for a particular disk
  * Input:
- *	Disk *disk - Disk geometry
- *	kdev_t dev - Device node
- *	int *geom  - Returns geometry fields
- *		geom[0] = heads
- *		geom[1] = sectors
- *		geom[2] = cylinders
- */
-static int
-megaraid_biosparam(Disk *disk, kdev_t dev, int *geom)
+ *   Disk *disk - Disk geometry
+ *   struct block_device *dev - Device node
+ *   int *geom  - Returns geometry fields
+ *     geom[0] = heads
+ *     geom[1] = sectors
+ *     geom[2] = cylinders
+ *-------------------------------------------------------------*/
+static int megaraid_biosparam (Disk * disk, struct block_device *bdev, int *geom)
 {
 	int heads, sectors, cylinders;
 	adapter_t *adapter;
@@ -3823,16 +3818,13 @@
 	/* Get pointer to host config structure */
 	adapter = (adapter_t *)disk->device->host->hostdata;
 
-	if (IS_RAID_CH(adapter, disk->device->channel)) {
+	if( IS_RAID_CH(adapter, disk->device->channel)) {
 			/* Default heads (64) & sectors (32) */
 			heads = 64;
 			sectors = 32;
 			cylinders = disk->capacity / (heads * sectors);
 
-			/*
-			 * Handle extended translation size for logical drives
-			 * > 1Gb
-			 */
+			/* Handle extended translation size for logical drives > 1Gb */
 			if (disk->capacity >= 0x200000) {
 				heads = 255;
 				sectors = 63;
@@ -3845,11 +3837,10 @@
 			geom[2] = cylinders;
 	}
 	else {
-		if (!mega_partsize(disk, dev, geom))
-			return 0;
+		if( mega_partsize(disk, bdev, geom) == 0 ) return 0;
 
 		printk(KERN_WARNING
-		"megaraid: invalid partition on this disk on channel %d\n",
+				"megaraid: invalid partition on this disk on channel %d\n",
 				disk->device->channel);
 
 		/* Default heads (64) & sectors (32) */
@@ -3872,50 +3863,38 @@
 
 	return 0;
 }
-
 /*
- * mega_partsize()
- * @disk
- * @geom
+ * Function : static int mega_partsize(Disk * disk, struct block_device *bdev, int *geom)
  *
  * Purpose : to determine the BIOS mapping used to create the partition
- *	table, storing the results (cyls, hds, and secs) in geom
+ *			table, storing the results (cyls, hds, and secs) in geom
  *
  * Note:	Code is picked from scsicam.h
  *
  * Returns : -1 on failure, 0 on success.
  */
 static int
-mega_partsize(Disk *disk, kdev_t dev, int *geom)
+mega_partsize(Disk * disk, struct block_device *bdev, int *geom)
 {
-	struct buffer_head *bh;
 	struct partition *p, *largest = NULL;
 	int i, largest_cyl;
 	int heads, cyls, sectors;
 	int capacity = disk->capacity;
+	unsigned char *buf;
 
-	int ma = MAJOR(dev);
-	int mi = (MINOR(dev) & ~0xf);
-
-	int block = 1024; 
-
-	if (blksize_size[ma])
-		block = blksize_size[ma][mi];
-		
-	if (!(bh = bread(MKDEV(ma,mi), 0, block)))
+	if (!(buf = scsi_bios_ptable(bdev)))
 		return -1;
 
-	if (*(unsigned short *)(bh->b_data + 510) == 0xAA55 ) {
+	if( *(unsigned short *)(buf + 64) == 0xAA55 ) {
 
-		for (largest_cyl = -1,
-			p = (struct partition *)(0x1BE + bh->b_data), i = 0;
-			i < 4; ++i, ++p) {
+		for( largest_cyl = -1, p = (struct partition *)buf,
+				i = 0; i < 4; ++i, ++p) {
 
 			if (!p->sys_ind) continue;
 
 			cyls = p->end_cyl + ((p->end_sector & 0xc0) << 2);
 
-			if (cyls >= largest_cyl) {
+			if(cyls >= largest_cyl) {
 				largest_cyl = cyls;
 				largest = p;
 			}
@@ -3926,8 +3905,8 @@
 		heads = largest->end_head + 1;
 		sectors = largest->end_sector & 0x3f;
 
-		if (!heads || !sectors) {
-			brelse(bh);
+		if (heads == 0 || sectors == 0) {
+			kfree(buf);
 			return -1;
 		}
 
@@ -3937,14 +3916,13 @@
 		geom[1] = sectors;
 		geom[2] = cyls;
 
-		brelse(bh);
+		kfree(buf);
 		return 0;
 	}
 
-	brelse(bh);
+	kfree(buf);
 	return -1;
 }
-
 
 /**
  * megaraid_reboot_notify()
--- /home/mdomsch/megaraid/megaraid-v2.00rc5/megaraid.h	Sun Sep 22 12:48:47 2002
+++ linux-2.5-megaraid/drivers/scsi/megaraid2.h	Mon Oct  7 23:19:15 2002
@@ -123,29 +123,27 @@
 
 #define MEGARAID						\
 {								\
-	name:				"MegaRAID",		\
-	proc_info:			megaraid_proc_info,	\
-	detect:				megaraid_detect,	\
-	release:			megaraid_release,	\
-	info:				megaraid_info,		\
-	command:			megaraid_command,	\
-	queuecommand:			megaraid_queue,		\
-	bios_param:			megaraid_biosparam,	\
-	max_sectors:			MAX_SECTORS_PER_IO,	\
-	can_queue:			MAX_COMMANDS,		\
-	this_id:			DEFAULT_INITIATOR_ID,	\
-	sg_tablesize:			MAX_SGLIST,		\
-	cmd_per_lun:			DEF_CMD_PER_LUN,	\
-	present:  			0,			\
-	unchecked_isa_dma:		0,			\
-	use_clustering:			ENABLE_CLUSTERING,	\
-	use_new_eh_code:		1,			\
-	eh_abort_handler:		megaraid_abort,		\
-	eh_device_reset_handler:	megaraid_reset,		\
-	eh_bus_reset_handler:		megaraid_reset,		\
-	eh_host_reset_handler:		megaraid_reset,		\
-	highmem_io:			1,			\
-	can_do_varyio:			1			\
+	.name =				"MegaRAID",		\
+	.proc_info =			megaraid_proc_info,	\
+	.detect =				megaraid_detect,	\
+	.release =			megaraid_release,	\
+	.info =				megaraid_info,		\
+	.command =			megaraid_command,	\
+	.queuecommand =			megaraid_queue,		\
+	.bios_param =			megaraid_biosparam,	\
+	.max_sectors =			MAX_SECTORS_PER_IO,	\
+	.can_queue =			MAX_COMMANDS,		\
+	.this_id =			DEFAULT_INITIATOR_ID,	\
+	.sg_tablesize =			MAX_SGLIST,		\
+	.cmd_per_lun =			DEF_CMD_PER_LUN,	\
+	.present =  			0,			\
+	.unchecked_isa_dma =		0,			\
+	.use_clustering =			ENABLE_CLUSTERING,	\
+	.eh_abort_handler =		megaraid_abort,		\
+	.eh_device_reset_handler =	megaraid_reset,		\
+	.eh_bus_reset_handler =		megaraid_reset,		\
+	.eh_host_reset_handler =		megaraid_reset,		\
+	.highmem_io =			1,			\
 }
 
 
@@ -1100,7 +1098,7 @@
 static int megaraid_abort(Scsi_Cmnd *);
 static int megaraid_reset(Scsi_Cmnd *);
 static int megaraid_abort_and_reset(adapter_t *, Scsi_Cmnd *, int);
-static int megaraid_biosparam (Disk *, kdev_t, int *);
+static int megaraid_biosparam (Disk * disk, struct block_device *bdev, int *geom);
 static int megaraid_proc_info (char *, char **, off_t, int, int, int);
 static int mega_print_inquiry(char *, char *);
 
@@ -1161,7 +1159,7 @@
 static mega_ext_passthru* mega_prepare_extpassthru(adapter_t *,
 		scb_t *, Scsi_Cmnd *, int, int);
 static void mega_enum_raid_scsi(adapter_t *);
-static int mega_partsize(Disk *, kdev_t, int *);
+static int mega_partsize(Disk * disk, struct block_device *bdev, int *geom);
 static void mega_get_boot_drv(adapter_t *);
 static inline int mega_get_ldrv_num(adapter_t *, Scsi_Cmnd *, int);
 static int mega_support_random_del(adapter_t *);

