From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] tmscsim: scsi device attributes
Date: Fri, 22 Oct 2004 13:40:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041022124007.GC4201@parcelfarce.linux.theplanet.co.uk>
References: <Pine.LNX.4.60.0410212223120.7042@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:50319 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S271301AbUJVMkK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Oct 2004 08:40:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0410212223120.7042@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thu, Oct 21, 2004 at 10:31:25PM +0200, Guennadi Liakhovetski wrote:
> A write method to adjust per-device queue-depth

How about something more along the following lines?  I haven't converted
sym2 to the generic queue code yet, so it's untested (and is obviously
broken because nothing initialises max_queue_depth).

Index: drivers/scsi/scsi_sysfs.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_sysfs.c,v
retrieving revision 1.15
diff -u -p -r1.15 scsi_sysfs.c
--- drivers/scsi/scsi_sysfs.c	21 Oct 2004 18:59:23 -0000	1.15
+++ drivers/scsi/scsi_sysfs.c	22 Oct 2004 12:29:51 -0000
@@ -15,6 +15,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
 
 #include "scsi_priv.h"
@@ -248,7 +249,7 @@ static DEVICE_ATTR(field, S_IRUGO, sdev_
 
 
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr: create a function and attribute variable for a
  * read/write field.
  */
 #define sdev_rw_attr(field, format_string)				\
@@ -268,7 +269,7 @@ static DEVICE_ATTR(field, S_IRUGO | S_IW
  * so leave this code in */
 #if 0
 /*
- * sdev_rd_attr: create a function and attribute variable for a
+ * sdev_rw_attr_bit: create a function and attribute variable for a
  * read/write bit field.
  */
 #define sdev_rw_attr_bit(field)						\
@@ -310,12 +311,28 @@ static int scsi_sdev_check_buf_bit(const
  * Create the actual show/store functions and data structures.
  */
 sdev_rd_attr (device_blocked, "%d\n");
-sdev_rd_attr (queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
 sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
 sdev_rd_attr (rev, "%.4s\n");
+
+sdev_show_function(queue_depth, "%d\n")
+
+static ssize_t
+sdev_store_queue_depth(struct device *dev, const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int new_depth = simple_strtoul(buf, NULL, 0);
+
+	if (new_depth > sdev->max_queue_depth)
+		return -EINVAL;
+
+	scsi_activate_tcq(sdev, new_depth);
+	return count;
+}
+
+static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR, sdev_show_queue_depth, sdev_store_queue_depth);
 
 static ssize_t
 sdev_show_timeout (struct device *dev, char *buf)
Index: include/scsi/scsi_device.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_device.h,v
retrieving revision 1.13
diff -u -p -r1.13 scsi_device.h
--- include/scsi/scsi_device.h	21 Oct 2004 19:00:10 -0000	1.13
+++ include/scsi/scsi_device.h	22 Oct 2004 12:29:59 -0000
@@ -50,6 +50,7 @@ struct scsi_device {
 	struct list_head starved_entry;
 	struct scsi_cmnd *current_cmnd;	/* currently active command */
 	unsigned short queue_depth;	/* How deep of a queue we want */
+	unsigned short max_queue_depth;	/* The limit for the above */
 	unsigned short last_queue_full_depth; /* These two are used by */
 	unsigned short last_queue_full_count; /* scsi_track_queue_full() */
 	unsigned long last_queue_full_time;/* don't let QUEUE_FULLs on the same

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
