From: Alan Stern <stern@rowland.harvard.edu>
Subject: PATCH: (as168) Sysfs attribute file for max_sectors
Date: Wed, 7 Jan 2004 11:16:07 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0401071113560.850-100000@ida.rowland.org>
References: <1073418475.2047.82.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:16132 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266240AbUAGQQI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2004 11:16:08 -0500
In-Reply-To: <1073418475.2047.82.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On 6 Jan 2004, James Bottomley wrote:

> Not really.  For most drivers, the max_sectors is a driver table
> parameter and the user shouldn't be changing it.
> 
> The value can be acceptably exported read only in scsi_sysfs.c;  then,
> you could use the attribute overriding code to make this read/write for
> usb-storage only.

Is this patch okay?  (Along with exporting max_sectors read-only, it fixes
two small typos.)

Alan Stern


===== scsi_sysfs.c 1.24 vs edited =====
--- 1.24/drivers/scsi/scsi_sysfs.c	Wed Nov 26 18:52:56 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Wed Jan  7 11:11:44 2004
@@ -200,7 +200,7 @@
 
 
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
@@ -217,7 +217,7 @@
 static DEVICE_ATTR(field, S_IRUGO | S_IWUSR, sdev_show_##field, sdev_store_##field)
 
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write bit field.
  */
 #define sdev_rw_attr_bit(field)						\
@@ -283,6 +283,16 @@
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
+static ssize_t
+sdev_show_max_sectors(struct device *dev, char *buf)
+{
+	struct scsi_device *sdev;
+	sdev = to_scsi_device(dev);
+	return snprintf (buf, 20, "%d\n", sdev->request_queue->max_sectors);
+}
+static DEVICE_ATTR(max_sectors, S_IRUGO, sdev_show_max_sectors, NULL);
+
+
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
 	&dev_attr_device_blocked,
@@ -295,6 +305,7 @@
 	&dev_attr_online,
 	&dev_attr_rescan,
 	&dev_attr_delete,
+	&dev_attr_max_sectors,
 	NULL
 };
 

