From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug lk 2.6.0t6
Date: Tue, 07 Oct 2003 21:00:31 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F829CCF.3020104@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010306080203060907010001"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:13717 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S262127AbTJGLBV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2003 07:01:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com

This is a multi-part message in MIME format.
--------------010306080203060907010001
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This small patch adds a "release" method to the "pseudo_0"
device to stop the noise when the scsi_debug module is
loaded.

Another annoyance that I was unable to get to the bottom
of was during "rmmod scsi_debug" **:
   Synchronizing SCSI cache for disk sda: <4>FAILED
     status = 0, message = 00, host = 1, driver = 00
That is a DID_NO_CONNECT error. So the LLD host is
being shut down before the sd driver gets a chance to
send through a SYNCHRONIZE CACHE command. If the user
instigates a rmmod (as distinct from the hardware
saying the host/device is gone), shouldn't a window
be left open for such a flushing type command. This
problem seems to have appeared recently.


** "echo -1 > add_host" in scsi_debug's driver directory
    (i.e. remove a host) also causes the same error so the
    problem is not perculiar to rmmod.

Doug Gilbert

--------------010306080203060907010001
Content-Type: text/plain;
 name="scsi_debug260t6.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_debug260t6.diff"

--- linux/drivers/scsi/scsi_debug.c	2003-09-28 14:25:06.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c260t6dpg	2003-10-07 17:04:51.000000000 +1000
@@ -55,7 +55,7 @@
 #include "scsi_logging.h"
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.70 (20030507)";
+static const char * scsi_debug_version_str = "Version: 1.71 (20031007)";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDED_SENSE 0x0
@@ -1541,7 +1541,7 @@
         }
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
-		printk(KERN_INFO "scsi_debug: ... built %d host(s)\n",
+		printk(KERN_INFO "scsi_debug_init: built %d host(s)\n",
 		       scsi_debug_add_host);
 	}
 	return 0;
@@ -1565,8 +1565,15 @@
 device_initcall(scsi_debug_init);
 module_exit(scsi_debug_exit);
 
+void pseudo_0_release(struct device * dev)
+{
+	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
+		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
+}
+
 static struct device pseudo_primary = {
 	.bus_id		= "pseudo_0",
+	.release	= pseudo_0_release,
 };
 
 static int pseudo_lld_bus_match(struct device *dev, 

--------------010306080203060907010001--

