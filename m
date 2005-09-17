From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.14-rc1 4/13] ieee1394/sbp2: safer default parameter
Date: Sun, 18 Sep 2005 01:12:20 +0200 (CEST)
Message-ID: <200509172312.j8HNCNcH030458@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:28096 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751224AbVIQXMu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 19:12:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, bcollins@debian.org, scjody@steamballoon.com, dan@dennedy.org, James.Bottomley@SteelEye.com

sbp2:
Set serialize_io=1 by default. This is safer and required by seemingly more and
more hardware. It causes little or no performance loss for S400 devices.
Performance of S800 1394b devices may drop by 25...30%. Therefore make the
parameter's description and dmesg message clearer about performance impact.

Update description of the max_speed parameter too. IEEE1394_SPEED_MAX is
currently S800.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>


--- linux-2.6.14-rc1.orig/drivers/ieee1394/sbp2.c	2005-09-13 05:12:09.000000000 +0200
+++ linux-2.6.14-rc1/drivers/ieee1394/sbp2.c	2005-09-17 16:51:56.000000000 +0200
@@ -97,16 +97,18 @@ static char version[] __devinitdata =
  */
 static int max_speed = IEEE1394_SPEED_MAX;
 module_param(max_speed, int, 0644);
-MODULE_PARM_DESC(max_speed, "Force max speed (3 = 800mb, 2 = 400mb default, 1 = 200mb, 0 = 100mb)");
+MODULE_PARM_DESC(max_speed, "Force max speed (3 = 800mb, 2 = 400mb, 1 = 200mb, 0 = 100mb)");
 
 /*
  * Set serialize_io to 1 if you'd like only one scsi command sent
  * down to us at a time (debugging). This might be necessary for very
  * badly behaved sbp2 devices.
+ *
+ * TODO: Make this configurable per device.
  */
-static int serialize_io;
+static int serialize_io = 1;
 module_param(serialize_io, int, 0444);
-MODULE_PARM_DESC(serialize_io, "Serialize all I/O coming down from the scsi drivers (default = 0)");
+MODULE_PARM_DESC(serialize_io, "Serialize I/O coming from scsi drivers (default = 1, faster = 0)");
 
 /*
  * Bump up max_sectors if you'd like to support very large sized
@@ -2837,7 +2859,8 @@ static int sbp2_module_init(void)
 
 	/* Module load debug option to force one command at a time (serializing I/O) */
 	if (serialize_io) {
-		SBP2_ERR("Driver forced to serialize I/O (serialize_io = 1)");
+		SBP2_INFO("Driver forced to serialize I/O (serialize_io=1)");
+		SBP2_INFO("Try serialize_io=0 for better performance");
 		scsi_driver_template.can_queue = 1;
 		scsi_driver_template.cmd_per_lun = 1;
 	}

