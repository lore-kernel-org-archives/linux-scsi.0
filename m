From: Daniel Stekloff <dsteklof@us.ibm.com>
Subject: [PATCH] sdev_printk for ULDs, example with sd
Date: Thu, 22 Jan 2004 11:44:48 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200401221144.48488.dsteklof@us.ibm.com>
References: <200401191355.37522.dsteklof@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:53737 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S266416AbUAVTtP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 14:49:15 -0500
In-Reply-To: <200401191355.37522.dsteklof@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org


Hi,

In my recent post concerning sdev_printk I mentioned sdev_printk was useful 
for the mid-layer and LLDs. The macro is also useful for Upper Level Drivers 
as well. He's a patch adding sdev_printk to sd. Sample output includes:

scsi <1:0:0:0>: SCSI device sda: 35548320 512-byte hdwr sectors (18201 MB)
scsi <1:0:0:0>: SCSI device sda: drive cache: write through
 sda: sda1 sda2 sda3 sda4 < sda5 >
scsi <1:0:0:0>: Attached scsi disk sda
scsi <1:0:1:0>: SCSI device sdb: 71096640 512-byte hdwr sectors (36401 MB)
scsi <1:0:1:0>: SCSI device sdb: drive cache: write through
 sdb: sdb1
scsi <1:0:1:0>: Attached scsi disk sdb


I know these macros aren't exciting. I know too that there's much more 
interesting things going on enhancing and instrumenting the SCSI subsystem. 
The macro also isn't perfect, it doesn't take into account multi-line printks 
and the prefix isn't configurable except by editing the macro.  I believe, 
however, that the sdev_printk macro is useful for the following reasons:

1) It provides consistency to SCSI log messages. Not only does it create the 
same format for displaying the scsi device information but the macro assists 
using logging levels KERN_INFO, etc. The standard format helps identify 
messages in the log stream that could help with automation and even simply 
reading the messages.

2) It provides a mechanism to easily identify the log message to a specific 
scsi device.

3) It provides a single point to change scsi device identification in the 
future. Should additional or different information be useful to identify scsi 
device's in log messages, someone could simply change the macro rather than a 
large number of individual printks.

All comments are welcome. If acceptable, please apply. This patch applies over 
my previous patch, which is against the latest scsi-misc-2.6.

Previous recent sdev_printk patch post:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107454960106928&w=2


sd example patch follows:
----------------------------

--- scsi-misc-2.6-sdevpk-mid/include/scsi/scsi_device.h	2004-01-22 
11:14:38.925748984 -0800
+++ scsi-misc-2.6-sdevpk/include/scsi/scsi_device.h	2004-01-21 
16:54:38.000000000 -0800
@@ -124,6 +124,8 @@
 	sdev_printk(KERN_ERR , sdev , format , ## arg)
 #define sdev_info(sdev, format, arg...)           \
 	sdev_printk(KERN_INFO , sdev , format , ## arg)
+#define sdev_notice(sdev, format, arg...)           \
+	sdev_printk(KERN_NOTICE , sdev , format , ## arg)
 #define sdev_warn(sdev, format, arg...)           \
 	sdev_printk(KERN_WARNING , sdev , format , ## arg)
 
--- scsi-misc-2.6-sdevpk-mid/drivers/scsi/sd.c	2004-01-22 11:12:18.157149064 
-0800
+++ scsi-misc-2.6-sdevpk/drivers/scsi/sd.c	2004-01-21 17:06:50.000000000 -0800
@@ -217,14 +217,15 @@
 	block = SCpnt->request->sector;
 	this_count = SCpnt->request_bufflen >> 9;
 
-	SCSI_LOG_HLQUEUE(1, printk("sd_init_command: disk=%s, block=%llu, "
-			    "count=%d\n", disk->disk_name, (unsigned long long)block, 
this_count));
+	SCSI_LOG_HLQUEUE(1, sdev_info(sdp, "sd_init_command: disk=%s,"
+			" block=%llu, count=%d\n", disk->disk_name, 
+			(unsigned long long)block, this_count));
 
 	if (!sdp || !sdp->online ||
  	    block + SCpnt->request->nr_sectors > get_capacity(disk)) {
-		SCSI_LOG_HLQUEUE(2, printk("Finishing %ld sectors\n", 
+		SCSI_LOG_HLQUEUE(2, sdev_info(sdp, "Finishing %ld sectors\n", 
 				 SCpnt->request->nr_sectors));
-		SCSI_LOG_HLQUEUE(2, printk("Retry with 0x%p\n", SCpnt));
+		SCSI_LOG_HLQUEUE(2, sdev_info(sdp, "Retry with 0x%p\n", SCpnt));
 		return 0;
 	}
 
@@ -236,7 +237,7 @@
 		/* printk("SCSI disk has been changed. Prohibiting further I/O.\n"); */
 		return 0;
 	}
-	SCSI_LOG_HLQUEUE(2, printk("%s : block=%llu\n",
+	SCSI_LOG_HLQUEUE(2, sdev_info(sdp, "%s : block=%llu\n",
 				   disk->disk_name, (unsigned long long)block));
 
 	/*
@@ -252,7 +253,7 @@
 	 */
 	if (sdp->sector_size == 1024) {
 		if ((block & 1) || (SCpnt->request->nr_sectors & 1)) {
-			printk(KERN_ERR "sd: Bad block number requested");
+			sdev_err(sdp, "sd: Bad block number requested");
 			return 0;
 		} else {
 			block = block >> 1;
@@ -261,7 +262,7 @@
 	}
 	if (sdp->sector_size == 2048) {
 		if ((block & 3) || (SCpnt->request->nr_sectors & 3)) {
-			printk(KERN_ERR "sd: Bad block number requested");
+			sdev_err(sdp, "sd: Bad block number requested");
 			return 0;
 		} else {
 			block = block >> 2;
@@ -270,7 +271,7 @@
 	}
 	if (sdp->sector_size == 4096) {
 		if ((block & 7) || (SCpnt->request->nr_sectors & 7)) {
-			printk(KERN_ERR "sd: Bad block number requested");
+			sdev_err(sdp, "sd: Bad block number requested");
 			return 0;
 		} else {
 			block = block >> 3;
@@ -287,13 +288,13 @@
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
-		printk(KERN_ERR "sd: Unknown command %lx\n", 
+		sdev_err(sdp, "sd: Unknown command %lx\n", 
 		       SCpnt->request->flags);
 /* overkill 	panic("Unknown sd command %lx\n", SCpnt->request->flags); */
 		return 0;
 	}
 
-	SCSI_LOG_HLQUEUE(2, printk("%s : %s %d/%ld 512 byte blocks.\n", 
+	SCSI_LOG_HLQUEUE(2, sdev_info(sdp, "%s : %s %d/%ld 512 byte blocks.\n", 
 		disk->disk_name, (rq_data_dir(SCpnt->request) == WRITE) ? 
 		"writing" : "reading", this_count, SCpnt->request->nr_sectors));
 
@@ -459,7 +460,8 @@
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdev = sdkp->device;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_release: disk=%s\n", disk->disk_name));
+	SCSI_LOG_HLQUEUE(3, sdev_info(sdev, "sd_release: disk=%s\n", 
+				disk->disk_name));
 
 	if (!--sdkp->openers && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
@@ -526,7 +528,7 @@
 	struct scsi_device *sdp = scsi_disk(disk)->device;
 	int error;
     
-	SCSI_LOG_IOCTL(1, printk("sd_ioctl: disk=%s, cmd=0x%x\n",
+	SCSI_LOG_IOCTL(1, sdev_info(sdp, "sd_ioctl: disk=%s, cmd=0x%x\n",
 						disk->disk_name, cmd));
 
 	/*
@@ -582,7 +584,7 @@
 	struct scsi_device *sdp = sdkp->device;
 	int retval;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_media_changed: disk=%s\n",
+	SCSI_LOG_HLQUEUE(3, sdev_info(sdp, "sd_media_changed: disk=%s\n",
 						disk->disk_name));
 
 	if (!sdp->removable)
@@ -666,13 +668,14 @@
 	sector_t block_sectors = 1;
 	sector_t error_sector;
 #ifdef CONFIG_SCSI_LOGGING
-	SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: %s: res=0x%x\n", 
+	SCSI_LOG_HLCOMPLETE(1, sdev_info(SCpnt->device, 
+				"sd_rw_intr: %s: res=0x%x\n", 
 				SCpnt->request->rq_disk->disk_name, result));
 	if (0 != result) {
-		SCSI_LOG_HLCOMPLETE(1, printk("sd_rw_intr: sb[0,2,asc,ascq]"
-				"=%x,%x,%x,%x\n", SCpnt->sense_buffer[0],
-			SCpnt->sense_buffer[2], SCpnt->sense_buffer[12],
-			SCpnt->sense_buffer[13]));
+		SCSI_LOG_HLCOMPLETE(1, sdev_info(SCpnt->device,
+				"sd_rw_intr: sb[0,2,asc,ascq]=%x,%x,%x,%x\n", 
+			SCpnt->sense_buffer[0], SCpnt->sense_buffer[2], 
+			SCpnt->sense_buffer[12], SCpnt->sense_buffer[13]));
 	}
 #endif
 	/*
@@ -938,7 +941,7 @@
 	} while (the_result && retries);
 
 	if (the_result && !longrc) {
-		printk(KERN_NOTICE "%s : READ CAPACITY failed.\n"
+		sdev_notice(sdp, "%s : READ CAPACITY failed.\n"
 		       "%s : status=%x, message=%02x, host=%d, driver=%02x \n",
 		       diskname, diskname,
 		       status_byte(the_result),
@@ -949,7 +952,8 @@
 		if (driver_byte(the_result) & DRIVER_SENSE)
 			print_req_sense("sd", SRpnt);
 		else
-			printk("%s : sense not available. \n", diskname);
+			sdev_info(sdp, "%s : sense not available. \n", 
+				diskname);
 
 		/* Set dirty bit for removable devices if not ready -
 		 * sometimes drives will not report this properly. */
@@ -965,14 +969,14 @@
 		return;
 	} else if (the_result && longrc) {
 		/* READ CAPACITY(16) has been failed */
-		printk(KERN_NOTICE "%s : READ CAPACITY(16) failed.\n"
+		sdev_notice(sdp, "%s : READ CAPACITY(16) failed.\n"
 		       "%s : status=%x, message=%02x, host=%d, driver=%02x \n",
 		       diskname, diskname,
 		       status_byte(the_result),
 		       msg_byte(the_result),
 		       host_byte(the_result),
 		       driver_byte(the_result));
-		printk(KERN_NOTICE "%s : use 0xffffffff as device size\n",
+		sdev_notice(sdp, "%s : use 0xffffffff as device size\n",
 		       diskname);
 		
 		sdkp->capacity = 1 + (sector_t) 0xffffffff;		
@@ -985,12 +989,12 @@
 		if (buffer[0] == 0xff && buffer[1] == 0xff &&
 		    buffer[2] == 0xff && buffer[3] == 0xff) {
 			if(sizeof(sdkp->capacity) > 4) {
-				printk(KERN_NOTICE "%s : very big device. try to use"
-				       " READ CAPACITY(16).\n", diskname);
+				sdev_notice(sdp, "%s : very big device."
+				" try to use READ CAPACITY(16).\n", diskname);
 				longrc = 1;
 				goto repeat;
 			} else {
-				printk(KERN_ERR "%s: too big for kernel.  Assuming maximum 2Tb\n", 
diskname);
+				sdev_err(sdp, "%s: too big for kernel.  Assuming maximum 2Tb\n", 
diskname);
 			}
 		}
 		sdkp->capacity = 1 + (((sector_t)buffer[0] << 24) |
@@ -1014,7 +1018,7 @@
 got_data:
 	if (sector_size == 0) {
 		sector_size = 512;
-		printk(KERN_NOTICE "%s : sector size 0 reported, "
+		sdev_notice(sdp, "%s : sector size 0 reported, "
 		       "assuming 512.\n", diskname);
 	}
 
@@ -1023,7 +1027,7 @@
 	    sector_size != 2048 &&
 	    sector_size != 4096 &&
 	    sector_size != 256) {
-		printk(KERN_NOTICE "%s : unsupported sector size "
+		sdev_notice(sdp, "%s : unsupported sector size "
 		       "%d.\n", diskname, sector_size);
 		/*
 		 * The user might want to re-format the drive with
@@ -1051,7 +1055,7 @@
 		mb -= sz - 974;
 		sector_div(mb, 1950);
 
-		printk(KERN_NOTICE "SCSI device %s: "
+		sdev_notice(sdp, "SCSI device %s: "
 		       "%llu %d-byte hdwr sectors (%llu MB)\n",
 		       diskname, (unsigned long long)sdkp->capacity,
 		       hard_sector, (unsigned long long)mb);
@@ -1090,7 +1094,8 @@
 	struct scsi_mode_data data;
 
 	if (sdkp->device->skip_ms_page_3f) {
-		printk(KERN_NOTICE "%s: assuming Write Enabled\n", diskname);
+		sdev_notice(sdkp->device, "%s: assuming Write Enabled\n", 
+				diskname);
 		return;
 	}
 
@@ -1116,13 +1121,13 @@
 		res = sd_do_mode_sense(SRpnt, 0, 0x3F, buffer, 255, &data);
 
 	if (!scsi_status_is_good(res)) {
-		printk(KERN_WARNING
+		sdev_warn(sdkp->device,
 		       "%s: test WP failed, assume Write Enabled\n", diskname);
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
-		printk(KERN_NOTICE "%s: Write Protect is %s\n", diskname,
+		sdev_notice(sdkp->device, "%s: Write Protect is %s\n", diskname,
 		       sdkp->write_prot ? "on" : "off");
-		printk(KERN_DEBUG "%s: Mode Sense: %02x %02x %02x %02x\n",
+		sdev_dbg(sdkp->device, "%s: Mode Sense: %02x %02x %02x %02x\n",
 		       diskname, buffer[0], buffer[1], buffer[2], buffer[3]);
 	}
 }
@@ -1181,7 +1186,7 @@
 
 		ct =  sdkp->RCD + 2*sdkp->WCE;
 
-		printk(KERN_NOTICE "SCSI device %s: drive cache: %s\n",
+		sdev_notice(sdkp->device, "SCSI device %s: drive cache: %s\n",
 		       diskname, types[ct]);
 
 		return;
@@ -1193,15 +1198,15 @@
 	     /* ASC 0x24 ASCQ 0x00: Invalid field in CDB */
 	     && SRpnt->sr_sense_buffer[12] == 0x24
 	     && SRpnt->sr_sense_buffer[13] == 0x00) {
-		printk(KERN_NOTICE "%s: cache data unavailable\n",
+		sdev_notice(sdkp->device, "%s: cache data unavailable\n",
 		       diskname);
 	} else {
-		printk(KERN_ERR "%s: asking for cache data failed\n",
+		sdev_err(sdkp->device, "%s: asking for cache data failed\n",
 		       diskname);
 	}
 
 defaults:
-	printk(KERN_ERR "%s: assuming drive cache: write through\n",
+	sdev_err(sdkp->device, "%s: assuming drive cache: write through\n",
 	       diskname);
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
@@ -1219,7 +1224,8 @@
 	struct scsi_request *sreq;
 	unsigned char *buffer;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_revalidate_disk: disk=%s\n", 
disk->disk_name));
+	SCSI_LOG_HLQUEUE(3, sdev_info(sdp, "sd_revalidate_disk: disk=%s\n", 
+					disk->disk_name));
 
 	/*
 	 * If the device is offline, don't try and read capacity or any
@@ -1230,14 +1236,14 @@
 
 	sreq = scsi_allocate_request(sdp, GFP_KERNEL);
 	if (!sreq) {
-		printk(KERN_WARNING "(sd_revalidate_disk:) Request allocation "
+		sdev_warn(sdp, "(sd_revalidate_disk:) Request allocation "
 		       "failure.\n");
 		goto out;
 	}
 
 	buffer = kmalloc(512, GFP_KERNEL | __GFP_DMA);
 	if (!buffer) {
-		printk(KERN_WARNING "(sd_revalidate_disk:) Memory allocation "
+		sdev_warn(sdp, "(sd_revalidate_disk:) Memory allocation "
 		       "failure.\n");
 		goto out_release_request;
 	}
@@ -1303,8 +1309,7 @@
 	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
 		goto out;
 
-	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
-			 sdp->host->host_no, sdp->channel, sdp->id, sdp->lun));
+	SCSI_LOG_HLQUEUE(3, sdev_info(sdp, "sd_attach\n"));
 
 	error = -ENOMEM;
 	sdkp = kmalloc(sizeof(*sdkp), GFP_KERNEL);
@@ -1362,10 +1367,8 @@
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
 
-	printk(KERN_NOTICE "Attached scsi %sdisk %s at scsi%d, channel %d, "
-	       "id %d, lun %d\n", sdp->removable ? "removable " : "",
-	       gd->disk_name, sdp->host->host_no, sdp->channel,
-	       sdp->id, sdp->lun);
+	sdev_notice(sdp, "Attached scsi %sdisk %s\n", 
+		sdp->removable ? "removable " : "", gd->disk_name);
 
 	return 0;
 
@@ -1435,7 +1438,7 @@
 	if (!sdp->online || !sdkp->WCE)
 		return;
 
-	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: ",
+	sdev_notice(sdp, "Synchronizing SCSI cache for disk %s: ",
 			sdkp->disk->disk_name);
 
 	sreq = scsi_allocate_request(sdp, GFP_KERNEL);



