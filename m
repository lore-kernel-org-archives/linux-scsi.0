From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] Replace scsi_host flags with scsi_device sdev_bflags
Date: Sat, 13 Mar 2004 17:49:06 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040313174906.A3101@beaverton.ibm.com>
References: <20040313174651.A3054@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:63181 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S263248AbUCNBu7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Mar 2004 20:50:59 -0500
Content-Disposition: inline
In-Reply-To: <20040313174651.A3054@beaverton.ibm.com>; from patmans@us.ibm.com on Sat, Mar 13, 2004 at 05:46:51PM -0800
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net

Replace the scsi_host flags with scsi_device sdev_bflags. Change USB to
set sdev_bflags in its new slave_alloc function.

diff -uprN -X /home/patman/dontdiff base-2.6/drivers/scsi/scsi_devinfo.c add_sdev_bflags-2.6/drivers/scsi/scsi_devinfo.c
--- base-2.6/drivers/scsi/scsi_devinfo.c	Fri Mar 12 16:07:10 2004
+++ add_sdev_bflags-2.6/drivers/scsi/scsi_devinfo.c	Fri Mar 12 16:16:47 2004
@@ -329,7 +329,7 @@ int scsi_get_device_flags(struct scsi_de
 	struct scsi_dev_info_list *devinfo;
 	unsigned int bflags;
 
-	bflags = sdev->host->hostt->flags;
+	bflags = sdev->sdev_bflags;
 	if (!bflags)
 		bflags = scsi_default_dev_flags;
 
diff -uprN -X /home/patman/dontdiff base-2.6/drivers/usb/storage/scsiglue.c add_sdev_bflags-2.6/drivers/usb/storage/scsiglue.c
--- base-2.6/drivers/usb/storage/scsiglue.c	Thu Mar 11 11:23:05 2004
+++ add_sdev_bflags-2.6/drivers/usb/storage/scsiglue.c	Fri Mar 12 16:16:47 2004
@@ -64,6 +64,17 @@ static const char* host_info(struct Scsi
 	return "SCSI emulation for USB Mass Storage devices";
 }
 
+static int slave_alloc (struct scsi_device *sdev)
+{
+	/*
+	 * Set default bflags. These can be overridden for individual
+	 * models and vendors via the scsi devinfo mechanism.
+	 */
+	sdev->sdev_bflags = (BLIST_MS_SKIP_PAGE_08 | BLIST_MS_SKIP_PAGE_3F |
+			     BLIST_USE_10_BYTE_MS);
+	return 0;
+}
+
 static int slave_configure (struct scsi_device *sdev)
 {
 	/* Scatter-gather buffers (all but the last) must have a length
@@ -365,6 +376,7 @@ struct scsi_host_template usb_stor_host_
 	/* unknown initiator id */
 	.this_id =			-1,
 
+	.slave_alloc =			slave_alloc,
 	.slave_configure =		slave_configure,
 
 	/* lots of sg segments can be handled */
@@ -384,10 +396,6 @@ struct scsi_host_template usb_stor_host_
 
 	/* sysfs device attributes */
 	.sdev_attrs =			sysfs_device_attr_list,
-
-	/* modify scsi_device bits on probe */
-	.flags = (BLIST_MS_SKIP_PAGE_08 | BLIST_MS_SKIP_PAGE_3F |
-		  BLIST_USE_10_BYTE_MS),
 
 	/* module management */
 	.module =			THIS_MODULE
diff -uprN -X /home/patman/dontdiff base-2.6/include/scsi/scsi_device.h add_sdev_bflags-2.6/include/scsi/scsi_device.h
--- base-2.6/include/scsi/scsi_device.h	Fri Mar 12 16:07:11 2004
+++ add_sdev_bflags-2.6/include/scsi/scsi_device.h	Fri Mar 12 16:16:47 2004
@@ -64,6 +64,10 @@ struct scsi_device {
 	unsigned char current_tag;	/* current tag */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
+	unsigned int	sdev_bflags; /* black/white flags as also found in
+				 * scsi_devinfo.[hc]. For now used only to
+				 * pass settings from slave_alloc to scsi
+				 * core. */
 	unsigned online:1;
 
 	unsigned writeable:1;
diff -uprN -X /home/patman/dontdiff base-2.6/include/scsi/scsi_host.h add_sdev_bflags-2.6/include/scsi/scsi_host.h
--- base-2.6/include/scsi/scsi_host.h	Fri Mar 12 16:07:11 2004
+++ add_sdev_bflags-2.6/include/scsi/scsi_host.h	Fri Mar 12 16:16:47 2004
@@ -345,12 +345,6 @@ struct scsi_host_template {
 	 * module_init/module_exit.
 	 */
 	struct list_head legacy_hosts;
-
-	/*
-	 * Default flags settings, these modify the setting of scsi_device
-	 * bits.
-	 */
-	unsigned int flags;
 };
 
 /*
