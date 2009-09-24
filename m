From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/4] sd.c: Make initialisation less verbose
Date: Thu, 24 Sep 2009 16:20:56 -0600
Message-ID: <20090924222056.GE7943@parisc-linux.org>
References: <20090920225348.GB3690@parisc-linux.org> <Pine.LNX.4.44L0.0909202104300.14465-100000@netrider.rowland.org> <20090924221702.GA7943@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41293 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZIXWUw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 18:20:52 -0400
Content-Disposition: inline
In-Reply-To: <20090924221702.GA7943@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

Introduce a new function, sd_print_info() to print the information we
normally want to display to the user on revalidation.

Move the capacity display from sd_read_capacity() to sd_print_info().
Move the write protect display from sd_read_write_protect_flag() to
sd_print_info().
Delete the printk reporting Mode Sense as it is not generally useful.

Move the display of 'Removable' to the same line as reporting the Write
Protect status.

Only print the line about write cache once.
---
 drivers/scsi/sd.c |   78 ++++++++++++++++++++++++++++++-----------------------
 1 files changed, 44 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a89c421..beec7f3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1441,7 +1441,6 @@ sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer)
 {
 	int sector_size;
 	struct scsi_device *sdp = sdkp->device;
-	sector_t old_capacity = sdkp->capacity;
 
 	if (sd_try_rc16_first(sdp)) {
 		sector_size = read_capacity_16(sdkp, sdp, buffer);
@@ -1524,28 +1523,6 @@ got_data:
 	}
 	blk_queue_logical_block_size(sdp->request_queue, sector_size);
 
-	{
-		char cap_str_2[10], cap_str_10[10];
-		u64 sz = (u64)sdkp->capacity << ilog2(sector_size);
-
-		string_get_size(sz, STRING_UNITS_2, cap_str_2,
-				sizeof(cap_str_2));
-		string_get_size(sz, STRING_UNITS_10, cap_str_10,
-				sizeof(cap_str_10));
-
-		if (sdkp->first_scan || old_capacity != sdkp->capacity) {
-			sd_printk(KERN_NOTICE, sdkp,
-				  "%llu %d-byte logical blocks: (%s/%s)\n",
-				  (unsigned long long)sdkp->capacity,
-				  sector_size, cap_str_10, cap_str_2);
-
-			if (sdkp->hw_sector_size != sector_size)
-				sd_printk(KERN_NOTICE, sdkp,
-					  "%u-byte physical blocks\n",
-					  sdkp->hw_sector_size);
-		}
-	}
-
 	/* Rescale capacity to 512-byte units */
 	if (sector_size == 4096)
 		sdkp->capacity <<= 3;
@@ -1581,7 +1558,6 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	int res;
 	struct scsi_device *sdp = sdkp->device;
 	struct scsi_mode_data data;
-	int old_wp = sdkp->write_prot;
 
 	set_disk_ro(sdkp->disk, 0);
 	if (sdp->skip_ms_page_3f) {
@@ -1622,13 +1598,6 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 	} else {
 		sdkp->write_prot = ((data.device_specific & 0x80) != 0);
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
-		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
-			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-				  sdkp->write_prot ? "on" : "off");
-			sd_printk(KERN_DEBUG, sdkp,
-				  "Mode Sense: %02x %02x %02x %02x\n",
-				  buffer[0], buffer[1], buffer[2], buffer[3]);
-		}
 	}
 }
 
@@ -1742,7 +1711,9 @@ bad_sense:
 		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
 
 defaults:
-	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
+	if (sdkp->first_scan)
+		sd_printk(KERN_ERR, sdkp,
+				"Assuming drive cache: write through\n");
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->DPOFUA = 0;
@@ -1852,6 +1823,43 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
 	return 0;
 }
 
+static
+void sd_print_info(struct scsi_disk *sdkp, sector_t old_capacity, int old_wp)
+{
+	unsigned sector_size = sdkp->device->sector_size;
+	char cap_str_2[10], cap_str_10[10];
+	u64 sz = (u64)sdkp->capacity * 512;
+
+	string_get_size(sz, STRING_UNITS_2, cap_str_2,
+			sizeof(cap_str_2));
+	string_get_size(sz, STRING_UNITS_10, cap_str_10,
+			sizeof(cap_str_10));
+
+	if (sdkp->first_scan || old_capacity != sdkp->capacity) {
+		u64 new_blocks = sdkp->capacity;
+		if (sector_size < 512)
+			new_blocks *= 512 / sector_size;
+		else if (sector_size > 512)
+			new_blocks = sector_div(sdkp->capacity,
+							512 / sector_size);
+
+		sd_printk(KERN_NOTICE, sdkp,
+			  "%llu %d-byte logical blocks: (%s/%s)\n",
+			  new_blocks, sector_size, cap_str_10, cap_str_2);
+
+		if (sdkp->hw_sector_size != sector_size)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "%u-byte physical blocks\n",
+				  sdkp->hw_sector_size);
+	}
+
+	if (sdkp->first_scan || old_wp != sdkp->write_prot) {
+		sd_printk(KERN_NOTICE, sdkp, "%s disk, Write Protect is %s\n",
+			  sdkp->device->removable ? "Removable" : "Fixed",
+			  sdkp->write_prot ? "on" : "off");
+	}
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -1861,6 +1869,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 {
 	struct scsi_disk *sdkp = scsi_disk(disk);
 	struct scsi_device *sdp = sdkp->device;
+	sector_t old_capacity = sdkp->capacity;
+	int old_wp = sdkp->write_prot;
 	unsigned char *buffer;
 	unsigned ordered;
 
@@ -1900,6 +1910,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_app_tag_own(sdkp, buffer);
 	}
 
+	sd_print_info(sdkp, old_capacity, old_wp);
+
 	sdkp->first_scan = 0;
 
 	/*
@@ -2019,8 +2031,6 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 
 	sd_revalidate_disk(gd);
 
-	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
-		  sdp->removable ? "removable " : "");
 	put_device(&sdkp->dev);
 }
 
-- 
1.6.3.3

