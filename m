From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug dsense lk2.6.11-rc1
Date: Thu, 13 Jan 2005 18:49:02 +1000
Message-ID: <41E635FE.20100@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060706040605000104040607"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:52628 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261307AbVAMItD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Jan 2005 03:49:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------060706040605000104040607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The dsense switch in the scsi_debug driver selects
whether fixed (default) or descriptor format sense
data is returned when an error/warning occurs. Due
to an oversight dsense was not sysfs visible.

James, will the new generic device transport class be
useful for the scsi_debug driver. At the moment it uses
a "pseudo" device and bus type. When I tried to replicate
that structure in another virtual driver (for a SES target)
I found that the two drivers didn't play well together.


Changelog:
    - make dsense visible to sysfs

Signed-off-by: Douglas Gilbert <dougg@torque.net>

--------------060706040605000104040607
Content-Type: text/x-patch;
 name="sdebug2611rc1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sdebug2611rc1.diff"

--- linux/drivers/scsi/scsi_debug.c	2005-01-13 14:41:44.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c2611rc1dpg	2005-01-13 14:34:43.000000000 +1000
@@ -11,7 +11,7 @@
  *  (or disk like devices) sharing a common amount of RAM
  *
  *
- *  For documentation see http://www.torque.net/sg/sdebug25.html
+ *  For documentation see http://www.torque.net/sg/sdebug26.html
  *
  *   D. Gilbert (dpg) work for Magneto-Optical device test [20010421]
  *   dpg: work for devfs large number of disks [20010809]
@@ -56,7 +56,7 @@
 #include "scsi_debug.h"
 
 #define SCSI_DEBUG_VERSION "1.75"
-static const char * scsi_debug_version_date = "20041023";
+static const char * scsi_debug_version_date = "20050113";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDED_SENSE 0x0
@@ -1675,6 +1675,7 @@
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_add_host);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_delay);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
+	driver_create_file(&sdebug_driverfs_driver, &driver_attr_dsense);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_num_tgts);
@@ -1693,6 +1694,7 @@
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_num_tgts);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dsense);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_delay);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_add_host);

--------------060706040605000104040607--
