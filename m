From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] scsi_debug lk 2.6.0t6
Date: Wed, 08 Oct 2003 22:57:38 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F8409C2.8080608@torque.net>
References: <3F829CCF.3020104@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000802080606070402030003"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.triode.net.au ([202.147.124.1]:50875 "EHLO
	iggy.triode.net.au") by vger.kernel.org with ESMTP id S261463AbTJHM6o
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Oct 2003 08:58:44 -0400
In-Reply-To: <3F829CCF.3020104@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, patmans@us.ibm.com

This is a multi-part message in MIME format.
--------------000802080606070402030003
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

After playing around with:
# echo "0 - -" > /sys/class/scsi_host/host1/scan

(where host1 is owned by the scsi_debug driver),
I have made some more changes to the driver
(now version 1.72). These changes permit the number
of scsi devices that the driver simulates to be
increased via sysfs without necessarily adding new hosts.
[add_host can still be used to add or remove hosts.]

Here is an example:
# modprobe scsi_debug    # assume adds host 1
# echo 3 > /sys/bus/pseudo/drivers/scsi_debug/max_luns
# echo 2 > /sys/bus/pseudo/drivers/scsi_debug/max_tgts
# echo "0 - -" > /sys/class/scsi_host/host1/scan

The modprobe line adds one scsi device and the echo "0 - -"
line adds 5 more scsi devices to host 1.

Retired the documentation in this page:
   http://www.torque.net/sg/sdebug25.html
and replaced it with this reworked page:
   http://www.torque.net/sg/sdebug26.html

Doug Gilbert


Douglas Gilbert wrote:
> This small patch adds a "release" method to the "pseudo_0"
> device to stop the noise when the scsi_debug module is
> loaded.
> 
> Another annoyance that I was unable to get to the bottom
> of was during "rmmod scsi_debug" **:
>   Synchronizing SCSI cache for disk sda: <4>FAILED
>     status = 0, message = 00, host = 1, driver = 00
> That is a DID_NO_CONNECT error. So the LLD host is
> being shut down before the sd driver gets a chance to
> send through a SYNCHRONIZE CACHE command. If the user
> instigates a rmmod (as distinct from the hardware
> saying the host/device is gone), shouldn't a window
> be left open for such a flushing type command. This
> problem seems to have appeared recently.
> 
> 
> ** "echo -1 > add_host" in scsi_debug's driver directory
>    (i.e. remove a host) also causes the same error so the
>    problem is not perculiar to rmmod.
> 
> Doug Gilbert

New patch ...


--------------000802080606070402030003
Content-Type: text/plain;
 name="scsi_debug260t6_2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_debug260t6_2.diff"

--- linux/drivers/scsi/scsi_debug.c	2003-09-28 14:25:06.000000000 +1000
+++ linux/drivers/scsi/scsi_debug.c260t6dpg2	2003-10-08 22:11:02.372435144 +1000
@@ -55,7 +55,7 @@
 #include "scsi_logging.h"
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.70 (20030507)";
+static const char * scsi_debug_version_str = "Version: 1.72 (20031008)";
 
 /* Additional Sense Code (ASC) used */
 #define NO_ADDED_SENSE 0x0
@@ -249,6 +249,8 @@
 
 static int sdebug_add_adapter(void);
 static void sdebug_remove_adapter(void);
+static void sdebug_max_tgts_luns(void);
+
 static struct device pseudo_primary;
 static struct bus_type pseudo_lld_bus;
 
@@ -981,6 +983,18 @@
 				open_devip = devip;
 		}
 	}
+	if (NULL == open_devip) { /* try and make a new one */
+		open_devip = kmalloc(sizeof(*open_devip),GFP_KERNEL);
+                if (NULL == open_devip) {
+                        printk(KERN_ERR "%s: out of memory at line %d\n",
+                               __FUNCTION__, __LINE__);
+                        return NULL;
+                }
+                memset(open_devip, 0, sizeof(*open_devip));
+                open_devip->sdbg_host = sdbg_host;
+                list_add_tail(&open_devip->dev_list,
+                              &sdbg_host->dev_info_list);
+	}
         if (open_devip) {
 		open_devip->channel = sdev->channel;
 		open_devip->target = sdev->id;
@@ -1369,6 +1383,7 @@
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		scsi_debug_num_tgts = n;
+		sdebug_max_tgts_luns();
 		return count;
 	}
 	return -EINVAL;
@@ -1412,6 +1427,7 @@
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
 		scsi_debug_max_luns = n;
+		sdebug_max_tgts_luns();
 		return count;
 	}
 	return -EINVAL;
@@ -1541,7 +1557,7 @@
         }
 
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
-		printk(KERN_INFO "scsi_debug: ... built %d host(s)\n",
+		printk(KERN_INFO "scsi_debug_init: built %d host(s)\n",
 		       scsi_debug_add_host);
 	}
 	return 0;
@@ -1565,8 +1581,15 @@
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
@@ -1731,3 +1754,21 @@
         scsi_host_put(sdbg_host->shost);
         return 0;
 }
+
+static void sdebug_max_tgts_luns(void)
+{
+	struct sdebug_host_info * sdbg_host;
+        struct Scsi_Host *hpnt;
+
+        spin_lock(&sdebug_host_list_lock);
+        list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
+		hpnt = sdbg_host->shost;
+		if ((hpnt->this_id >= 0) && 
+		    (scsi_debug_num_tgts > hpnt->this_id))
+			hpnt->max_id = scsi_debug_num_tgts + 1;
+		else
+			hpnt->max_id = scsi_debug_num_tgts;
+		hpnt->max_lun = scsi_debug_max_luns;
+        }
+        spin_unlock(&sdebug_host_list_lock);
+}

--------------000802080606070402030003--

