From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sg version 3.5.28 for lk 2.5.64
Date: Sun, 09 Mar 2003 23:23:39 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E6B405B.3010509@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090703040806020409090201"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (d-242-8.stlucia.uq.net.au [203.101.242.8])
	by bunyip.cc.uq.edu.au (8.12.8/8.12.8) with ESMTP id h29DNWGf024613
	for <linux-scsi@vger.kernel.org>; Sun, 9 Mar 2003 23:23:33 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------090703040806020409090201
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Changelog:
   - remove hosts, host_strs and host_hdr from sg's
     procfs interface **
   - add sysfs interface for allow_dio, def_reserved_size
     and version ***
   - switch boot time and module parameters to Rusty's
     moduleparam.h interface. This means, for example,
     the boot time "sg_def_reserved_size" parameter
     changes to "sg.def_reserved_size".


** Christoph moved the host listing functionality into
    a more central sysfs position (i.e. not dependent on
    sg). However scsi_debug is the only LLD that I can
    get to post any "host" info under the new arrangement.

    Should devices, device_strs and device_hdrs also be
    moved out of sg's procfs interface?

*** I find sg's "debug" in its procfs interface very
     useful for debugging (sg itself amongst other things).
     However it does not seem suitable for sysfs. Should
     it move?

Doug Gilbert


--------------090703040806020409090201
Content-Type: text/plain;
 name="sg_2564_3528.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sg_2564_3528.diff"

--- linux/drivers/scsi/sg.c	2003-03-01 12:23:04.000000000 +1000
+++ linux/drivers/scsi/sg.c2564_3528	2003-03-08 22:41:31.000000000 +1000
@@ -18,10 +18,8 @@
  *
  */
 #include <linux/config.h>
-#ifdef CONFIG_PROC_FS
-static char *sg_version_str = "Version: 3.5.27 (20030130)";
-#endif
-static int sg_version_num = 30527;	/* 2 digits for each component */
+static char *sg_version_str = "3.5.28 [20030308]";
+static int sg_version_num = 30528;	/* 2 digits for each component */
 /*
  *  D. P. Gilbert (dgilbert@interlog.com, dougg@triode.net.au), notes:
  *      - scsi logging is available via SCSI_LOG_TIMEOUT macros. First
@@ -56,6 +54,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/smp_lock.h>
+#include <linux/moduleparam.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
@@ -1327,27 +1326,6 @@
 	.fasync = sg_fasync,
 };
 
-#ifndef MODULE
-static int __init
-sg_def_reserved_size_setup(char *str)
-{
-	int tmp;
-
-	if (get_option(&str, &tmp) == 1) {
-		def_reserved_size = tmp;
-		if (tmp >= 0)
-			sg_big_buff = tmp;
-		return 1;
-	} else {
-		printk(KERN_WARNING "sg_def_reserved_size : usage "
-		       "sg_def_reserved_size=n (n could be 65536, 131072 or 262144)\n");
-		return 0;
-	}
-}
-
-__setup("sg_def_reserved_size=", sg_def_reserved_size_setup);
-#endif
-
 /* Driverfs file support */
 static ssize_t
 sg_device_kdev_read(struct device *driverfs_dev, char *page)
@@ -1564,16 +1542,77 @@
 		scsi_sleep(2);	/* dirty detach so delay device destruction */
 }
 
+/* Set 'perm' (4th argument) to 0 to disable module_param's definition
+ * of sysfs parameters (which module_param doesn't yet support).
+ * Sysfs parameters defined explicitly below.
+ */
+module_param_named(def_reserved_size, def_reserved_size, int, 0);
+module_param_named(allow_dio, sg_allow_dio, int, 0);
+
 MODULE_AUTHOR("Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI generic (sg) driver");
-
-#ifdef MODULE_LICENSE
 MODULE_LICENSE("GPL");
-#endif
 
-MODULE_PARM(def_reserved_size, "i");
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 
+static ssize_t sg_allow_dio_show(struct device_driver * ddp, char * buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", sg_allow_dio);
+}
+static ssize_t sg_allow_dio_store(struct device_driver * ddp,
+				  const char * buf, size_t count)
+{
+	if (1 == sscanf(buf, "%d", &sg_allow_dio)) {
+		sg_allow_dio = sg_allow_dio ? 1 : 0;
+		return count;
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(allow_dio, S_IRUGO | S_IWUSR, sg_allow_dio_show, 
+	    sg_allow_dio_store)
+
+static ssize_t sg_def_reserved_show(struct device_driver * ddp, char * buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", sg_big_buff);
+}
+static ssize_t sg_def_reserved_store(struct device_driver * ddp,
+				     const char * buf, size_t count)
+{
+	if (1 == sscanf(buf, "%d", &def_reserved_size)) {
+		if (def_reserved_size >= 0) {
+			sg_big_buff = def_reserved_size;
+			return count;
+		}
+	}
+	return -EINVAL;
+}
+DRIVER_ATTR(def_reserved_size, S_IRUGO | S_IWUSR, sg_def_reserved_show, 
+	    sg_def_reserved_store)
+
+static ssize_t sg_version_show(struct device_driver * ddp, char * buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%s\n", sg_version_str);
+}
+DRIVER_ATTR(version, S_IRUGO, sg_version_show, NULL)
+
+static void do_create_driverfs_files(void)
+{
+	struct device_driver * driverfs = &sg_template.scsi_driverfs_driver;
+
+	driver_create_file(driverfs, &driver_attr_allow_dio);
+	driver_create_file(driverfs, &driver_attr_def_reserved_size);
+	driver_create_file(driverfs, &driver_attr_version);
+}
+
+static void do_remove_driverfs_files(void)
+{
+	struct device_driver * driverfs = &sg_template.scsi_driverfs_driver;
+
+	driver_remove_file(driverfs, &driver_attr_version);
+	driver_remove_file(driverfs, &driver_attr_def_reserved_size);
+	driver_remove_file(driverfs, &driver_attr_allow_dio);
+}
+
 static int __init
 init_sg(void)
 {
@@ -1591,12 +1630,14 @@
 #ifdef CONFIG_PROC_FS
 	sg_proc_init();
 #endif				/* CONFIG_PROC_FS */
+	do_create_driverfs_files();
 	return 0;
 }
 
 static void __exit
 exit_sg(void)
 {
+	do_remove_driverfs_files();
 #ifdef CONFIG_PROC_FS
 	sg_proc_cleanup();
 #endif				/* CONFIG_PROC_FS */
@@ -2656,10 +2697,6 @@
 static struct proc_dir_entry *sg_proc_sgp = NULL;
 
 static char sg_proc_sg_dirname[] = "sg";
-static const char *sg_proc_leaf_names[] = { "allow_dio", "def_reserved_size",
-	"debug", "devices", "device_hdr", "device_strs",
-	"hosts", "host_hdr", "host_strs", "version"
-};
 
 static int sg_proc_adio_read(char *buffer, char **start, off_t offset,
 			     int size, int *eof, void *data);
@@ -2693,13 +2730,21 @@
 				int size, int *eof, void *data);
 static int sg_proc_version_info(char *buffer, int *len, off_t * begin,
 				off_t offset, int size);
-static read_proc_t *sg_proc_leaf_reads[] = {
-	sg_proc_adio_read, sg_proc_dressz_read, sg_proc_debug_read,
-	sg_proc_dev_read, sg_proc_devhdr_read, sg_proc_devstrs_read,
-	sg_proc_version_read
+
+struct sg_proc_leaf {
+	const char * name;
+	read_proc_t * rf;
+	write_proc_t * wf;
 };
-static write_proc_t *sg_proc_leaf_writes[] = {
-	sg_proc_adio_write, sg_proc_dressz_write, 0, 0, 0, 0, 0, 0, 0, 0
+
+static struct sg_proc_leaf sg_proc_leaf_arr[] = {
+	{"allow_dio", sg_proc_adio_read, sg_proc_adio_write},
+	{"def_reserved_size", sg_proc_dressz_read, sg_proc_dressz_write},
+	{"debug", sg_proc_debug_read, NULL},
+	{"devices", sg_proc_dev_read, NULL},
+	{"device_hdr", sg_proc_devhdr_read, NULL},
+	{"device_strs", sg_proc_devstrs_read, NULL},
+	{"version", sg_proc_version_read, NULL}
 };
 
 #define PRINT_PROC(fmt,args...)                                 \
@@ -2729,9 +2774,10 @@
 sg_proc_init()
 {
 	int k, mask;
-	int leaves =
-	    sizeof (sg_proc_leaf_names) / sizeof (sg_proc_leaf_names[0]);
+	int num_leaves =
+	    sizeof (sg_proc_leaf_arr) / sizeof (sg_proc_leaf_arr[0]);
 	struct proc_dir_entry *pdep;
+	struct sg_proc_leaf * leaf;
 
 	if (!proc_scsi)
 		return 1;
@@ -2739,14 +2785,14 @@
 					S_IFDIR | S_IRUGO | S_IXUGO, proc_scsi);
 	if (!sg_proc_sgp)
 		return 1;
-	for (k = 0; k < leaves; ++k) {
-		mask = sg_proc_leaf_writes[k] ? S_IRUGO | S_IWUSR : S_IRUGO;
-		pdep =
-		    create_proc_entry(sg_proc_leaf_names[k], mask, sg_proc_sgp);
+	for (k = 0; k < num_leaves; ++k) {
+		leaf = &sg_proc_leaf_arr[k];
+		mask = leaf->wf ? S_IRUGO | S_IWUSR : S_IRUGO;
+		pdep = create_proc_entry(leaf->name, mask, sg_proc_sgp);
 		if (pdep) {
-			pdep->read_proc = sg_proc_leaf_reads[k];
-			if (sg_proc_leaf_writes[k])
-				pdep->write_proc = sg_proc_leaf_writes[k];
+			pdep->read_proc = leaf->rf;
+			if (leaf->wf)
+				pdep->write_proc = leaf->wf;
 		}
 	}
 	return 0;
@@ -2756,13 +2802,13 @@
 sg_proc_cleanup()
 {
 	int k;
-	int leaves =
-	    sizeof (sg_proc_leaf_names) / sizeof (sg_proc_leaf_names[0]);
+	int num_leaves =
+	    sizeof (sg_proc_leaf_arr) / sizeof (sg_proc_leaf_arr[0]);
 
 	if ((!proc_scsi) || (!sg_proc_sgp))
 		return;
-	for (k = 0; k < leaves; ++k)
-		remove_proc_entry(sg_proc_leaf_names[k], sg_proc_sgp);
+	for (k = 0; k < num_leaves; ++k)
+		remove_proc_entry(sg_proc_leaf_arr[k].name, sg_proc_sgp);
 	remove_proc_entry(sg_proc_sg_dirname, proc_scsi);
 }
 

--------------090703040806020409090201--

