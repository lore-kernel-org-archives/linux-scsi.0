From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] cpnvert scsi_debug to use virtual host bus
Date: Fri, 11 Feb 2005 17:38:11 -0800
Message-ID: <420D5E03.2020409@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080500080402020206070409"
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44439 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S261961AbVBLBiS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2005 20:38:18 -0500
Received: from [192.168.0.2] ([199.108.226.254])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j1C1cGrT012340
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2005 19:38:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------080500080402020206070409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The attach patch converts scsi_debug to use the virtual scsi bus.
It was built against scsi-rc-fixes-2.6.

The interface has changed a little. Here is an
example of adding and removing a single host:

cd /sys/bus/scsi_host/drivers/scsi_debug
[root@mina scsi_debug]# ls
add_host  dev_size_mb  every_nth  module     num_parts  opts   scsi_level
delay     dsense       max_luns   num_hosts  num_tgts   ptype
[root@mina scsi_debug]# echo 1 > add_host
[root@mina scsi_debug]# ls
add_host  dev_size_mb  every_nth  module     num_parts  opts   scsi_level
delay     dsense       max_luns   num_hosts  num_tgts   ptype  virt_host4
[root@mina scsi_debug]# cd virt_host4/
[root@mina virt_host4]# ls
detach_state  driver  host4  power  remove_host
[root@mina virt_host4]# echo 1 > remove_host


Mike

--------------080500080402020206070409
Content-Type: text/x-patch;
 name="use-ml-virtual-bus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use-ml-virtual-bus.patch"

--- scsi-rc-fixes-2.6.orig/drivers/scsi/scsi_debug.c	2005-02-04 22:11:25.000000000 -0800
+++ scsi-rc-fixes-2.6.work/drivers/scsi/scsi_debug.c	2005-02-11 00:54:13.000000000 -0800
@@ -44,6 +44,7 @@
 #include <linux/blkdev.h>
 #include "scsi.h"
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_driver.h>
 #include <scsi/scsicam.h>
 
 #include <linux/stat.h>
@@ -112,7 +113,7 @@ static const char * scsi_debug_version_d
  * or "peripheral device" addressing (value 0) */
 #define SAM2_LUN_ADDRESS_METHOD 0
 
-static int scsi_debug_add_host = DEF_NUM_HOST;
+static int scsi_debug_num_hosts;
 static int scsi_debug_delay = DEF_DELAY;
 static int scsi_debug_dev_size_mb = DEF_DEV_SIZE_MB;
 static int scsi_debug_every_nth = DEF_EVERY_NTH;
@@ -161,13 +162,9 @@ struct sdebug_dev_info {
 struct sdebug_host_info {
 	struct list_head host_list;
 	struct Scsi_Host *shost;
-	struct device dev;
 	struct list_head dev_info_list;
 };
 
-#define to_sdebug_host(d)	\
-	container_of(d, struct sdebug_host_info, dev)
-
 static LIST_HEAD(sdebug_host_list);
 static DEFINE_SPINLOCK(sdebug_host_list_lock);
 
@@ -218,21 +215,12 @@ static DEFINE_RWLOCK(atomic_rw);
 
 static char sdebug_proc_name[] = "scsi_debug";
 
-static int sdebug_driver_probe(struct device *);
-static int sdebug_driver_remove(struct device *);
-static struct bus_type pseudo_lld_bus;
-
-static struct device_driver sdebug_driverfs_driver = {
-	.name 		= sdebug_proc_name,
-	.bus		= &pseudo_lld_bus,
-	.probe          = sdebug_driver_probe,
-	.remove         = sdebug_driver_remove,
-};
-
 static const int check_condition_result =
 		(DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
 /* function declarations */
+static int sdebug_driver_probe(struct scsi_virt_host *);
+static int sdebug_driver_remove(struct scsi_virt_host *);
 static int resp_inquiry(struct scsi_cmnd * SCpnt, int target,
 			struct sdebug_dev_info * devip);
 static int resp_requests(struct scsi_cmnd * SCpnt,
@@ -266,17 +254,11 @@ static void stop_all_queued(void);
 static int stop_queued_cmnd(struct scsi_cmnd * cmnd);
 static int inquiry_evpd_83(unsigned char * arr, int dev_id_num,
                            const char * dev_id_str, int dev_id_str_len);
-static void do_create_driverfs_files(void);
-static void do_remove_driverfs_files(void);
 
-static int sdebug_add_adapter(void);
-static void sdebug_remove_adapter(void);
+static int sdebug_add_adapter(struct sdebug_host_info * sdbg_host);
+static void sdebug_remove_adapter(struct sdebug_host_info * sdbg_host);
 static void sdebug_max_tgts_luns(void);
 
-static struct device pseudo_primary;
-static struct bus_type pseudo_lld_bus;
-
-
 static
 int scsi_debug_queuecommand(struct scsi_cmnd * SCpnt, done_funct_t done)
 {
@@ -1054,7 +1036,7 @@ static struct sdebug_dev_info * devInfoR
 
 	if (devip)
 		return devip;
-	sdbg_host = *(struct sdebug_host_info **) sdev->host->hostdata;
+	sdbg_host = (struct sdebug_host_info *) sdev->host->hostdata;
         if(! sdbg_host) {
                 printk(KERN_ERR "Host info NULL\n");
 		return NULL;
@@ -1181,7 +1163,7 @@ static int scsi_debug_bus_reset(struct s
 		printk(KERN_INFO "scsi_debug: bus_reset\n");
 	++num_bus_resets;
 	if (SCpnt && ((sdp = SCpnt->device)) && ((hp = sdp->host))) {
-		sdbg_host = *(struct sdebug_host_info **) hp->hostdata;
+		sdbg_host = (struct sdebug_host_info *) hp->hostdata;
 		if (sdbg_host) {
 			list_for_each_entry(dev_info,
                                             &sdbg_host->dev_info_list,
@@ -1379,7 +1361,6 @@ static int schedule_resp(struct scsi_cmn
  * of sysfs parameters (which module_param doesn't yet support).
  * Sysfs parameters defined explicitly below.
  */
-module_param_named(add_host, scsi_debug_add_host, int, 0); /* perm=0644 */
 module_param_named(delay, scsi_debug_delay, int, 0); /* perm=0644 */
 module_param_named(dev_size_mb, scsi_debug_dev_size_mb, int, 0);
 module_param_named(dsense, scsi_debug_dsense, int, 0);
@@ -1633,78 +1614,42 @@ static ssize_t sdebug_scsi_level_show(st
 }
 DRIVER_ATTR(scsi_level, S_IRUGO, sdebug_scsi_level_show, NULL);
 
-static ssize_t sdebug_add_host_show(struct device_driver * ddp, char * buf)
+static ssize_t sdebug_num_hosts_show(struct device_driver * ddp, char * buf)
 {
-        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_add_host);
+        return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_num_hosts);
 }
+DRIVER_ATTR(num_hosts, S_IRUGO, sdebug_num_hosts_show, NULL);
 
-static ssize_t sdebug_add_host_store(struct device_driver * ddp,
-				     const char * buf, size_t count)
-{
-        int delta_hosts;
-	char work[20];
+static struct attribute *sdebug_attrs[] = {
+	&driver_attr_num_hosts.attr,
+	&driver_attr_delay.attr,
+	&driver_attr_dev_size_mb.attr,
+	&driver_attr_dsense.attr,
+	&driver_attr_every_nth.attr,
+	&driver_attr_max_luns.attr,
+	&driver_attr_num_tgts.attr,
+	&driver_attr_num_parts.attr,
+	&driver_attr_ptype.attr,
+	&driver_attr_opts.attr,
+	&driver_attr_scsi_level.attr,
+	NULL,
+};
 
-        if (1 != sscanf(buf, "%10s", work))
-		return -EINVAL;
-	{	/* temporary hack around sscanf() problem with -ve nums */
-		int neg = 0;
-
-		if ('-' == *work)
-			neg = 1;
-		if (1 != sscanf(work + neg, "%d", &delta_hosts))
-			return -EINVAL;
-		if (neg)
-			delta_hosts = -delta_hosts;
-	}
-	if (delta_hosts > 0) {
-		do {
-			sdebug_add_adapter();
-		} while (--delta_hosts);
-	} else if (delta_hosts < 0) {
-		do {
-			sdebug_remove_adapter();
-		} while (++delta_hosts);
-	}
-	return count;
-}
-DRIVER_ATTR(add_host, S_IRUGO | S_IWUSR, sdebug_add_host_show, 
-	    sdebug_add_host_store);
+static struct attribute_group sdebug_attr_group = {
+	.attrs = sdebug_attrs,
+};
 
-static void do_create_driverfs_files(void)
-{
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_add_host);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_delay);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_dsense);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_num_tgts);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_num_parts);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_ptype);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_opts);
-	driver_create_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
-}
-
-static void do_remove_driverfs_files(void)
-{
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_scsi_level);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_opts);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_ptype);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_num_parts);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_num_tgts);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_max_luns);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_every_nth);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dsense);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_dev_size_mb);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_delay);
-	driver_remove_file(&sdebug_driverfs_driver, &driver_attr_add_host);
-}
+static struct scsi_host_driver sdebug_driverfs_driver = {
+	.owner		= THIS_MODULE,
+	.name 		= sdebug_proc_name,
+	.attrs		= &sdebug_attr_group,
+	.probe          = sdebug_driver_probe,
+	.remove         = sdebug_driver_remove,
+};
 
 static int __init scsi_debug_init(void)
 {
 	unsigned long sz;
-	int host_to_add;
-	int k;
 
 	if (scsi_debug_dev_size_mb < 1)
 		scsi_debug_dev_size_mb = 1;  /* force minimum 1 MB ramdisk */
@@ -1740,42 +1685,19 @@ static int __init scsi_debug_init(void)
 
 	init_all_queued();
 
-	device_register(&pseudo_primary);
-	bus_register(&pseudo_lld_bus);
-	driver_register(&sdebug_driverfs_driver);
-	do_create_driverfs_files();
-
+	scsi_register_host_driver(&sdebug_driverfs_driver);
 	sdebug_driver_template.proc_name = (char *)sdebug_proc_name;
 
-	host_to_add = scsi_debug_add_host;
-        scsi_debug_add_host = 0;
-
-        for (k = 0; k < host_to_add; k++) {
-                if (sdebug_add_adapter()) {
-                        printk(KERN_ERR "scsi_debug_init: "
-                               "sdebug_add_adapter failed k=%d\n", k);
-                        break;
-                }
-        }
-
 	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts) {
-		printk(KERN_INFO "scsi_debug_init: built %d host(s)\n",
-		       scsi_debug_add_host);
+		printk(KERN_INFO "scsi_debug driver\n");
 	}
 	return 0;
 }
 
 static void __exit scsi_debug_exit(void)
 {
-	int k = scsi_debug_add_host;
-
 	stop_all_queued();
-	for (; k; k--)
-		sdebug_remove_adapter();
-	do_remove_driverfs_files();
-	driver_unregister(&sdebug_driverfs_driver);
-	bus_unregister(&pseudo_lld_bus);
-	device_unregister(&pseudo_primary);
+	scsi_unregister_host_driver(&sdebug_driverfs_driver);
 
 	vfree(fake_storep);
 }
@@ -1783,52 +1705,13 @@ static void __exit scsi_debug_exit(void)
 device_initcall(scsi_debug_init);
 module_exit(scsi_debug_exit);
 
-void pseudo_0_release(struct device * dev)
-{
-	if (SCSI_DEBUG_OPT_NOISE & scsi_debug_opts)
-		printk(KERN_INFO "scsi_debug: pseudo_0_release() called\n");
-}
-
-static struct device pseudo_primary = {
-	.bus_id		= "pseudo_0",
-	.release	= pseudo_0_release,
-};
-
-static int pseudo_lld_bus_match(struct device *dev,
-                          struct device_driver *dev_driver)
-{
-        return 1;
-}
-
-static struct bus_type pseudo_lld_bus = {
-        .name = "pseudo",
-        .match = pseudo_lld_bus_match,
-};
-
-static void sdebug_release_adapter(struct device * dev)
-{
-        struct sdebug_host_info *sdbg_host;
-
-	sdbg_host = to_sdebug_host(dev);
-        kfree(sdbg_host);
-}
-
-static int sdebug_add_adapter(void)
+static int sdebug_add_adapter(struct sdebug_host_info * sdbg_host)
 {
 	int k, devs_per_host;
         int error = 0;
-        struct sdebug_host_info *sdbg_host;
         struct sdebug_dev_info *sdbg_devinfo;
         struct list_head *lh, *lh_sf;
 
-        sdbg_host = kmalloc(sizeof(*sdbg_host),GFP_KERNEL);
-
-        if (NULL == sdbg_host) {
-                printk(KERN_ERR "%s: out of memory at line %d\n",
-                       __FUNCTION__, __LINE__);
-                return -ENOMEM;
-        }
-
         memset(sdbg_host, 0, sizeof(*sdbg_host));
         INIT_LIST_HEAD(&sdbg_host->dev_info_list);
 
@@ -1851,17 +1734,7 @@ static int sdebug_add_adapter(void)
         list_add_tail(&sdbg_host->host_list, &sdebug_host_list);
         spin_unlock(&sdebug_host_list_lock);
 
-        sdbg_host->dev.bus = &pseudo_lld_bus;
-        sdbg_host->dev.parent = &pseudo_primary;
-        sdbg_host->dev.release = &sdebug_release_adapter;
-        sprintf(sdbg_host->dev.bus_id, "adapter%d", scsi_debug_add_host);
-
-        error = device_register(&sdbg_host->dev);
-
-        if (error)
-		goto clean;
-
-	++scsi_debug_add_host;
+	++scsi_debug_num_hosts;
         return error;
 
 clean:
@@ -1872,77 +1745,64 @@ clean:
 		kfree(sdbg_devinfo);
 	}
 
-	kfree(sdbg_host);
         return error;
 }
 
-static void sdebug_remove_adapter(void)
+static void sdebug_remove_adapter(struct sdebug_host_info * sdbg_host)
 {
-        struct sdebug_host_info * sdbg_host = NULL;
-
         spin_lock(&sdebug_host_list_lock);
-        if (!list_empty(&sdebug_host_list)) {
-                sdbg_host = list_entry(sdebug_host_list.prev,
-                                       struct sdebug_host_info, host_list);
-		list_del(&sdbg_host->host_list);
-	}
+	list_del(&sdbg_host->host_list);
         spin_unlock(&sdebug_host_list_lock);
 
-	if (!sdbg_host)
-		return;
-
-        device_unregister(&sdbg_host->dev);
-        --scsi_debug_add_host;
+        --scsi_debug_num_hosts;
 }
 
-static int sdebug_driver_probe(struct device * dev)
+static int sdebug_driver_probe(struct scsi_virt_host * vhost)
 {
         int error = 0;
         struct sdebug_host_info *sdbg_host;
         struct Scsi_Host *hpnt;
 
-	sdbg_host = to_sdebug_host(dev);
-
-        hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(sdbg_host));
+        hpnt = scsi_host_alloc(&sdebug_driver_template, sizeof(*sdbg_host));
         if (NULL == hpnt) {
                 printk(KERN_ERR "%s: scsi_register failed\n", __FUNCTION__);
                 error = -ENODEV;
 		return error;
         }
 
-        sdbg_host->shost = hpnt;
-	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
+	sdbg_host = (struct sdebug_host_info *)hpnt->hostdata;
+	if (sdebug_add_adapter(sdbg_host))
+		goto failed;
+	sdbg_host->shost = hpnt;
+	dev_set_drvdata(&vhost->dev, sdbg_host);
+
 	if ((hpnt->this_id >= 0) && (scsi_debug_num_tgts > hpnt->this_id))
 		hpnt->max_id = scsi_debug_num_tgts + 1;
 	else
 		hpnt->max_id = scsi_debug_num_tgts;
 	hpnt->max_lun = scsi_debug_max_luns;
 
-        error = scsi_add_host(hpnt, &sdbg_host->dev);
-        if (error) {
-                printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
-                error = -ENODEV;
-		scsi_host_put(hpnt);
-        } else
-		scsi_scan_host(hpnt);
-
+        error = scsi_add_host(hpnt, &vhost->dev);
+        if (error)
+		goto failed;
 
+	scsi_scan_host(hpnt);
         return error;
+
+ failed:
+	printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
+	scsi_host_put(hpnt);
+	return -ENODEV;
 }
 
-static int sdebug_driver_remove(struct device * dev)
+static int sdebug_driver_remove(struct scsi_virt_host * vhost)
 {
         struct list_head *lh, *lh_sf;
         struct sdebug_host_info *sdbg_host;
         struct sdebug_dev_info *sdbg_devinfo;
 
-	sdbg_host = to_sdebug_host(dev);
-
-	if (!sdbg_host) {
-		printk(KERN_ERR "%s: Unable to locate host info\n",
-		       __FUNCTION__);
-		return -ENODEV;
-	}
+	sdbg_host = dev_get_drvdata(&vhost->dev);
+	sdebug_remove_adapter(sdbg_host);
 
         scsi_remove_host(sdbg_host->shost);
 

--------------080500080402020206070409--
