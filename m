From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug lk 2.5.64
Date: Thu, 06 Mar 2003 08:36:30 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E666DDE.9080801@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080805000504080004010008"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-242-113.stlucia.uq.net.au [203.101.242.113])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h25MbrGf015586
	for <linux-scsi@vger.kernel.org>; Thu, 6 Mar 2003 08:37:53 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------080805000504080004010008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Attached is an interim patch for the scsi_debug driver
in lk 2.5.64 . It corrects the sysfs show() and store()
signatures.

There are two pending patches on scsi_debug that I plan
to incorporate soon:
   - re-arrange driver to use sysfs "probe()" function.
     An oops in sysfs during an rmmod operation is still
     to be cleared up. [from Mike Anderson]
   - injected recovered errors [from Kurt Garloff]

Doug Gilbert

--------------080805000504080004010008
Content-Type: text/plain;
 name="scsi_debug_2564_168.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="scsi_debug_2564_168.diff"

--- linux/drivers/scsi/scsi_debug.c	2003-02-11 09:39:20.000000000 +1100
+++ linux/drivers/scsi/scsi_debug.c2564_168	2003-03-04 22:57:07.000000000 +1100
@@ -54,7 +54,7 @@
 
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.67 (20021221)";
+static const char * scsi_debug_version_str = "Version: 1.68 (20030304)";
 
 #ifndef SCSI_CMD_READ_16
 #define SCSI_CMD_READ_16 0x88
@@ -1192,20 +1192,17 @@
 	return len;
 }
 
-static ssize_t sdebug_delay_read(struct device_driver * ddp, char * buf, 
-				 size_t count, loff_t off)
+static ssize_t sdebug_delay_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_delay);
+        return snprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_delay);
 }
 
-static ssize_t sdebug_delay_write(struct device_driver * ddp, 
-				  const char * buf, size_t count, loff_t off)
+static ssize_t sdebug_delay_store(struct device_driver * ddp, 
+				  const char * buf, size_t count)
 {
         int delay;
 	char work[20];
 
-        if (off)
-                return 0;
         if (1 == sscanf(buf, "%10s", work)) {
 		if ((1 == sscanf(work, "%d", &delay)) && (delay >= 0)) {
 			scsi_debug_delay = delay;
@@ -1214,23 +1211,20 @@
 	}
 	return -EINVAL;
 }
-DRIVER_ATTR(delay, S_IRUGO | S_IWUSR, sdebug_delay_read, 
-	    sdebug_delay_write)
+DRIVER_ATTR(delay, S_IRUGO | S_IWUSR, sdebug_delay_show, 
+	    sdebug_delay_store)
 
-static ssize_t sdebug_opts_read(struct device_driver * ddp, char * buf, 
-				size_t count, loff_t off)
+static ssize_t sdebug_opts_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "0x%x\n", scsi_debug_opts);
+        return snprintf(buf, PAGE_SIZE, "0x%x\n", scsi_debug_opts);
 }
 
-static ssize_t sdebug_opts_write(struct device_driver * ddp, 
-				 const char * buf, size_t count, loff_t off)
+static ssize_t sdebug_opts_store(struct device_driver * ddp, 
+				 const char * buf, size_t count)
 {
         int opts;
 	char work[20];
 
-        if (off)
-                return 0;
         if (1 == sscanf(buf, "%10s", work)) {
 		if (0 == strnicmp(work,"0x", 2)) {
 			if (1 == sscanf(&work[2], "%x", &opts))
@@ -1245,58 +1239,50 @@
 	scsi_debug_opts = opts;
 	return count;
 }
-DRIVER_ATTR(opts, S_IRUGO | S_IWUSR, sdebug_opts_read, 
-	    sdebug_opts_write)
+DRIVER_ATTR(opts, S_IRUGO | S_IWUSR, sdebug_opts_show, 
+	    sdebug_opts_store)
 
-static ssize_t sdebug_num_devs_read(struct device_driver * ddp, char * buf, 
-				    size_t count, loff_t off)
+static ssize_t sdebug_num_devs_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_num_devs);
+        return snprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_num_devs);
 }
-DRIVER_ATTR(num_devs, S_IRUGO, sdebug_num_devs_read, NULL) 
+DRIVER_ATTR(num_devs, S_IRUGO, sdebug_num_devs_show, NULL) 
 
-static ssize_t sdebug_dev_size_mb_read(struct device_driver * ddp, char * buf, 
-				       size_t count, loff_t off)
+static ssize_t sdebug_dev_size_mb_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_dev_size_mb);
+        return snprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_dev_size_mb);
 }
-DRIVER_ATTR(dev_size_mb, S_IRUGO, sdebug_dev_size_mb_read, NULL) 
+DRIVER_ATTR(dev_size_mb, S_IRUGO, sdebug_dev_size_mb_show, NULL) 
 
-static ssize_t sdebug_every_nth_read(struct device_driver * ddp, char * buf, 
-				     size_t count, loff_t off)
+static ssize_t sdebug_every_nth_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_every_nth);
+        return snprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_every_nth);
 }
-DRIVER_ATTR(every_nth, S_IRUGO, sdebug_every_nth_read, NULL) 
+DRIVER_ATTR(every_nth, S_IRUGO, sdebug_every_nth_show, NULL) 
 
-static ssize_t sdebug_max_luns_read(struct device_driver * ddp, char * buf, 
-				    size_t count, loff_t off)
+static ssize_t sdebug_max_luns_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_max_luns);
+        return snprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_max_luns);
 }
-DRIVER_ATTR(max_luns, S_IRUGO, sdebug_max_luns_read, NULL) 
+DRIVER_ATTR(max_luns, S_IRUGO, sdebug_max_luns_show, NULL) 
 
-static ssize_t sdebug_scsi_level_read(struct device_driver * ddp, char * buf, 
-				      size_t count, loff_t off)
+static ssize_t sdebug_scsi_level_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_scsi_level);
+        return snprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_scsi_level);
 }
-DRIVER_ATTR(scsi_level, S_IRUGO, sdebug_scsi_level_read, NULL) 
+DRIVER_ATTR(scsi_level, S_IRUGO, sdebug_scsi_level_show, NULL) 
 
-static ssize_t sdebug_add_host_read(struct device_driver * ddp, char * buf, 
-				    size_t count, loff_t off)
+static ssize_t sdebug_add_host_show(struct device_driver * ddp, char * buf) 
 {
-        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_add_host);
+        return snprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_add_host);
 }
 
-static ssize_t sdebug_add_host_write(struct device_driver * ddp, 
-				  const char * buf, size_t count, loff_t off)
+static ssize_t sdebug_add_host_store(struct device_driver * ddp, 
+				     const char * buf, size_t count)
 {
         int delta_hosts, k;
 	char work[20];
 
-        if (off)
-                return 0;
         if (1 != sscanf(buf, "%10s", work))
 		return -EINVAL;
 	{	/* temporary hack around sscanf() problem with -ve nums */
@@ -1336,8 +1322,8 @@
 	}
 	return count;
 }
-DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_read, 
-	    sdebug_add_host_write)
+DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_show, 
+	    sdebug_add_host_store)
 
 static void do_create_driverfs_files()
 {

--------------080805000504080004010008--

