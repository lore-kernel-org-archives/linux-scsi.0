From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: make sysfs scsi queue_depth read/write [patch]
Date: Wed, 14 Jan 2004 12:41:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114114132.GA12621@cistron.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 10fwd.cistron-office.nl ([62.216.29.197]:10958 "EHLO
	smtp.cistron-office.nl") by vger.kernel.org with ESMTP
	id S265828AbUANLlh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 06:41:37 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

[please keep me Cc:'ed, I'm not on linux-scsi]

I have been testing with a 3ware controller over the last few weeks.
It turns out that in RAID5 mode, it performs much better if the
queue depth is limited to 64 instead of the default 254.

So I patched the 3ware driver to make this tunable through a kernel/module
command line option, documented my findings, and send all that
stuff to the (very responsive) 3ware folks who are now looking at it
to see if this fixes a problem or just the symptoms of a
bigger problem.

Then it occured to me that it would be much easier to set this
limit (which is per device, not per host anyway) though sysfs.
Since a lot of SCSI drivers have options to set the queue depth,
it probably fills a need.

Below is a patch that makes /sys/block/<dev>/device/queue_depth
a read/write variable. Minimum limit is 1, maximum limit is the
value set in host->cmd_per_lun, so it should be perfectly safe.

Since the patch is trivial and it fixes a real problem (in my case,
tuning this gains 200% performance) please consider this for
2.6.NEXT (or 2.6.mm-next).

Thanks,

Mike.

--- linux-2.6.1/drivers/scsi/scsi_sysfs.c.ORIG	2004-01-09 07:59:10.000000000 +0100
+++ linux-2.6.1/drivers/scsi/scsi_sysfs.c	2004-01-14 12:26:23.000000000 +0100
@@ -259,7 +259,6 @@
  * Create the actual show/store functions and data structures.
  */
 sdev_rd_attr (device_blocked, "%d\n");
-sdev_rd_attr (queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
@@ -283,6 +282,22 @@
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
+sdev_show_function(queue_depth, "%d\n")
+static ssize_t sdev_store_queue_depth(struct device *dev, const char *buf,
+				 size_t count)
+{
+	int val;
+	struct scsi_device *sdev;
+	if (sscanf(buf, "%d", &val) != 1)
+		return -EINVAL;
+	sdev = to_scsi_device(dev);
+	if (!sdev || val < 1 || val > sdev->host->cmd_per_lun)
+		return -EINVAL;
+	sdev->queue_depth = val;
+	return count;
+}
+static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth, sdev_store_queue_depth)
+
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
 	&dev_attr_device_blocked,



