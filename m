From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 2.5.x (scsi-for-linus-2.5) remove scsi_device attr type
Date: Wed, 6 Nov 2002 17:30:23 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021106173023.A20706@eng2.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "J . E . J . Bottomley" <James.Bottomley@SteelEye.com>

This patch removes the "type" sysfs attribute for a scsi_device.

The field is not safely removed on removal of a scsi_device, and
so causes problems with rmmod adapter, or on removal via proc of a
scsi_device (remove-single-device), since sysfs correclty keeps
the associated structure around long after we free it since its ref
counts are not zero (contained in scsi_device).

I have some code to add a bunch of scsi_device attributes, what we really
need before that is a scsi_remove_sdev(sdev) that would include doing
common things like kfree(sdev->inquiry), device_unregister(sdev), etc
some of which are not properly handled right now.

Anyway, if you want to rmmod scsi-adapter/insmod scsi-adapter, you can
use this plus other sysfs patches.

--- 1.33/drivers/scsi/scsi_scan.c	Wed Nov  6 11:46:48 2002
+++ edited/drivers/scsi/scsi_scan.c	Wed Nov  6 17:04:56 2002
@@ -307,73 +307,6 @@
 }
 
 /**
- * scsi_device_type_read - copy out the SCSI type
- * @driverfs_dev:	driverfs device to check
- * @page:		copy data into this area
- * @count:		number of bytes to copy
- * @off:		start at this offset in page
- *
- * Description:
- *     Called via driverfs when the "type" (in scsi_device_type_file)
- *     field is read. Copy the appropriate SCSI type string into @page,
- *     followed by a newline and a '\0'. Go through gyrations so we don't
- *     write more than @count, and we don't write past @off.
- *
- * Notes:
- *     This is for the top-most scsi entry in driverfs, the upper-level
- *     drivers have their own type file. XXX This is not part of scanning,
- *     other than we reference the attr struct in this file, move to
- *     scsi.c or scsi_lib.c.
- *
- * Return:
- *     number of bytes written into page.
- **/
-static ssize_t scsi_device_type_read(struct device *driverfs_dev, char *page,
-	size_t count, loff_t off)
-{
-	struct scsi_device *sdev = to_scsi_device(driverfs_dev);
-	const char *type;
-	size_t size, len;
-
-	if ((sdev->type > MAX_SCSI_DEVICE_CODE) ||
-	    (scsi_device_types[(int)sdev->type] == NULL))
-		type = "Unknown";
-	else
-		type = scsi_device_types[(int)sdev->type];
-	size = strlen(type);
-	/*
-	 * Check if off is past size + 1 for newline + 1 for a '\0'.
-	 */
-	if (off >= (size + 2))
-		return 0;
-	if (size > off) {
-		len = min((size_t) (size - off), count);
-		memcpy(page + off, type + off, len);
-	} else
-		len = 0;
-	if (((len + off) == size) && (len < count))
-		/*
-		 * We are at the end of the string and have space, add a
-		 * new line.
-		 */
-		*(page + off + len++) = '\n';
-	if (((len + off) == (size + 1)) && (len < count))
-		/*
-		 * We are past the newline and have space, add a
-		 * terminating '\0'.
-		 */
-		*(page + off + len++) = '\0';
-	return len;
-}
-
-/*
- * Create dev_attr_type. This is different from the dev_attr_type in scsi
- * upper level drivers.
- */
-static DEVICE_ATTR(type,S_IRUGO,scsi_device_type_read,NULL);
-
-
-/**
  * print_inquiry - printk the inquiry information
  * @inq_result:	printk this SCSI INQUIRY
  *
@@ -1439,11 +1372,6 @@
 	sdev->sdev_driverfs_dev.parent = &sdev->host->host_driverfs_dev;
 	sdev->sdev_driverfs_dev.bus = &scsi_driverfs_bus_type;
 	device_register(&sdev->sdev_driverfs_dev);
-
-	/*
-	 * Create driverfs file entries
-	 */
-	device_create_file(&sdev->sdev_driverfs_dev, &dev_attr_type);
 
 	sprintf(devname, "host%d/bus%d/target%d/lun%d",
 		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
