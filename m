From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] fix return value of scsi_device rescan attribute
Date: Wed, 25 Jun 2003 09:17:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030625091706.A23194@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:3012 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264610AbTFYQHb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2003 12:07:31 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

When writing to the rescan attribute, return count as result, otherwise
some user apps might retry the write forever.

And remove the read capability of the attribute.

diff -purN -X /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi_sysfs.c rescan-cleanup-bl-2.5/drivers/scsi/scsi_sysfs.c
--- bleed-2.5/drivers/scsi/scsi_sysfs.c	Mon Jun 23 16:12:30 2003
+++ rescan-cleanup-bl-2.5/drivers/scsi/scsi_sysfs.c	Wed Jun 25 10:03:48 2003
@@ -195,19 +195,13 @@ sdev_rd_attr (rev, "%.4s\n");
 sdev_rw_attr_bit (online);
 
 static ssize_t
-show_rescan_field (struct device *dev, char *buf)
-{
-	return 0; 
-}
-
-static ssize_t
 store_rescan_field (struct device *dev, const char *buf, size_t count) 
 {
 	scsi_rescan_device(dev);
-	return 0;
+	return count;
 }
 
-static DEVICE_ATTR(rescan, S_IRUGO | S_IWUSR, show_rescan_field, store_rescan_field)
+static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field)
 
 /* Default template for device attributes.  May NOT be modified */
 struct device_attribute *scsi_sysfs_sdev_attrs[] = {

-- Patrick Mansfield
