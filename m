From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] scsi_debug on 2.5.44+scsi-misc
Date: Wed, 30 Oct 2002 13:55:10 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DBF4A0E.4000200@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-70.triode.net.au [202.147.125.70])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id g9U33iC15129
	for <linux-scsi@vger.kernel.org>; Wed, 30 Oct 2002 14:03:44 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is a patch for scsi_debug against 2.5.44 plus James's
scsi-misc BK tree. Changes:
   - add SYNCHRONIZE_CACHE command support
   - clean up module removal noise
   - add some more parameters for driverfs

Doug Gilbert

--- linux/drivers/scsi/scsi_debug.c	2002-10-30 11:18:09.000000000 +1100
+++ linux/drivers/scsi/scsi_debug.c163	2002-10-30 11:59:07.000000000 +1100
@@ -49,7 +49,7 @@
 
 #include "scsi_debug.h"
 
-static const char * scsi_debug_version_str = "Version: 1.62 (20020812)";
+static const char * scsi_debug_version_str = "Version: 1.63 (20021030)";
 
 #define DRIVERFS_SUPPORT 1	/* comment out whole line to disable */
 
@@ -131,7 +131,7 @@
 
 static unsigned char * fake_storep;	/* ramdisk storage */
 
-static unsigned char broken_buff[SDEBUG_SENSE_LEN];
+static unsigned char spare_buff[SDEBUG_SENSE_LEN];
 
 static int num_aborts = 0;
 static int num_dev_resets = 0;
@@ -215,8 +215,7 @@
 	else 
 		buff = (unsigned char *) SCpnt->request_buffer;
 	if (NULL == buff) {
-		printk(KERN_WARNING "scsi_debug:qc: buff was NULL??\n");
-		buff = broken_buff;	/* just point at dummy */
+		buff = spare_buff;	/* assume cmd moves no data */
 		bufflen = SDEBUG_SENSE_LEN;
 	}
 
@@ -380,6 +379,9 @@
 	case MODE_SENSE_10:
 		errsts = resp_mode_sense(cmd, target, buff, bufflen, devip);
 		break;
+	case SYNCHRONIZE_CACHE:
+		memset(buff, 0, bufflen);
+		break;
 	default:
 #if 0
 		printk(KERN_INFO "scsi_debug: Unsupported command, "
@@ -643,6 +645,7 @@
 	case 0x3f:	/* Read all Mode pages */
 		len = resp_err_recov_pg(ap, pcontrol, target);
 		len += resp_disconnect_pg(ap + len, pcontrol, target);
+		len += resp_format_pg(ap + len, pcontrol, target);
 		len += resp_caching_pg(ap + len, pcontrol, target);
 		len += resp_ctrl_m_pg(ap + len, pcontrol, target);
 		offset += len;
@@ -1324,15 +1327,35 @@
 
 DRIVER_ATTR(num_devs, S_IRUGO, sdebug_num_devs_read, NULL) 
 
+static ssize_t sdebug_dev_size_mb_read(struct device_driver * ddp, char * buf, 
+				       size_t count, loff_t off)
+{
+        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_dev_size_mb);
+}
+
+DRIVER_ATTR(dev_size_mb, S_IRUGO, sdebug_dev_size_mb_read, NULL) 
+
+static ssize_t sdebug_every_nth_read(struct device_driver * ddp, char * buf, 
+				     size_t count, loff_t off)
+{
+        return off ? 0 : snprintf(buf, count, "%d\n", scsi_debug_every_nth);
+}
+
+DRIVER_ATTR(every_nth, S_IRUGO, sdebug_every_nth_read, NULL) 
+
 static void do_create_driverfs_files()
 {
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_delay);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_opts);
 	driver_create_file(&sdebug_driverfs_driver, &driver_attr_num_devs);
+	driver_create_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
+	driver_create_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
 }
 
 static void do_remove_driverfs_files()
 {
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
+	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_num_devs);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_opts);
 	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_delay);

