From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: make sysfs scsi queue_depth read/write [patch]
Date: Wed, 14 Jan 2004 13:21:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114122147.GA15152@cistron.nl>
References: <20040114114132.GA12621@cistron.nl> <20040114115524.A29732@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 10fwd.cistron-office.nl ([62.216.29.197]:57038 "EHLO
	smtp.cistron-office.nl") by vger.kernel.org with ESMTP
	id S261188AbUANMVy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 07:21:54 -0500
Content-Disposition: inline
In-Reply-To: <20040114115524.A29732@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

According to Christoph Hellwig:
> Patch looks okay [...]
> This needs some locking.  Currently we have a single global lock protecting
> queue_depth updates, but none for reads.   (which looks a bit racy already,
> but no need to make it worse..)

Well, queue_depth is 32 bits, I think reading/writing to that is
atomic on most/all CPUs. We're not doing read/modify/write, just
an assignment, so it probably doesn't need locking.

Anyway, how about this:

--- linux-2.6.1/drivers/scsi/scsi.c.ORIG	2004-01-14 03:52:53.000000000 +0100
+++ linux-2.6.1/drivers/scsi/scsi.c	2004-01-14 13:12:37.000000000 +0100
@@ -889,6 +892,8 @@
 			sdev->ordered_tags = 0;
 			sdev->simple_tags = 1;
 			break;
+		case -1: /* Just set queue depth */
+			break;
 		default:
 			printk(KERN_WARNING "(scsi%d:%d:%d:%d) "
 				"scsi_adjust_queue_depth, bad queue type, "
--- linux-2.6.1/drivers/scsi/scsi_sysfs.c.ORIG	2004-01-09 07:59:10.000000000 +0100
+++ linux-2.6.1/drivers/scsi/scsi_sysfs.c	2004-01-14 13:13:47.000000000 +0100
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
+	if (val < 1 || val > sdev->host->cmd_per_lun)
+		return -EINVAL;
+	scsi_adjust_queue_depth(sdev, -1, val);
+	return count;
+}
+static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth, sdev_store_queue_depth)
+
 /* Default template for device attributes.  May NOT be modified */
 static struct device_attribute *scsi_sysfs_sdev_attrs[] = {
 	&dev_attr_device_blocked,


Mike.
