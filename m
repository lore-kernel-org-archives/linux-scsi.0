From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support [2/4]
Date: Mon, 14 Apr 2003 11:40:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030414184008.GC4162@beaverton.ibm.com>
References: <20030414183759.GA4162@beaverton.ibm.com> <20030414183918.GB4162@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:3463 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S263715AbTDNS0X (for <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2003 14:26:23 -0400
Content-Disposition: inline
In-Reply-To: <20030414183918.GB4162@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, mochel@osdl.org, linux-hotplug-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This patch changes the structure of sdebug_host_info and changes the
method / order of driver model cleanup.
EDESC


 drivers/scsi/scsi_debug.c |  199 ++++++++++++++++++++++------------------------
 drivers/scsi/scsi_debug.h |    2 
 2 files changed, 100 insertions(+), 101 deletions(-)

diff -puN drivers/scsi/scsi_debug.c~scsi_debug-sysfs drivers/scsi/scsi_debug.c
--- sysfs-bleed-2.5/drivers/scsi/scsi_debug.c~scsi_debug-sysfs	Mon Apr 14 10:11:19 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_debug.c	Mon Apr 14 10:11:19 2003
@@ -144,10 +144,13 @@ struct sdebug_dev_info {
 struct sdebug_host_info {
 	struct list_head host_list;
 	struct Scsi_Host *shost;
-	struct device *dev;
+	struct device dev;
 	struct list_head dev_info_list;
 };
 
+#define to_sdebug_host(d)	\
+	container_of(d, struct sdebug_host_info, dev)
+
 static LIST_HEAD(sdebug_host_list);
 static spinlock_t sdebug_host_list_lock = SPIN_LOCK_UNLOCKED;
 
@@ -224,22 +227,6 @@ static struct bus_type pseudo_lld_bus;
 static int scsi_debug_register_driver(struct device_driver *);
 static int scsi_debug_unregister_driver(struct device_driver *);
 
-static struct sdebug_host_info * 
-		sdebug_shost_to_host_info(struct Scsi_Host *shost)
-{
-	struct sdebug_host_info * sdbg_host, * found = NULL;
-
-	spin_lock(&sdebug_host_list_lock);
-	list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
-		if (sdbg_host->shost == shost) {
-			found = sdbg_host;
-			break;
-		}
-	}
-	spin_unlock(&sdebug_host_list_lock);
-	return found;
-}
-
 static unsigned char * scatg2virt(const struct scatterlist * sclp)
 {
 	if (NULL == sclp)
@@ -938,9 +925,9 @@ static struct sdebug_dev_info * devInfoR
 
 	if (devip)
 		return devip;
-	sdbg_host = sdebug_shost_to_host_info(sdev->host);
+	sdbg_host = *(struct sdebug_host_info **) sdev->host->hostdata;
         if(! sdbg_host) {
-                printk(KERN_ERR "Unable to locate host info\n");
+                printk(KERN_ERR "Host info NULL\n");
 		return NULL;
         }
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
@@ -1040,7 +1027,7 @@ static int scsi_debug_bus_reset(struct s
 		printk(KERN_INFO "scsi_debug: bus_reset\n");
 	++num_bus_resets;
 	if (SCpnt && ((sdp = SCpnt->device)) && ((hp = sdp->host))) {
-		sdbg_host = sdebug_shost_to_host_info(hp);
+		sdbg_host = ( struct sdebug_host_info *) hp->hostdata;
 		if (sdbg_host) {
 			list_for_each_entry(dev_info,
                                             &sdbg_host->dev_info_list,
@@ -1521,8 +1508,11 @@ static int __init scsi_debug_init(void)
 
 static void __exit scsi_debug_exit(void)
 {
-	/* free up adapters here ?? */
+	int k;
+
 	stop_all_queued();
+	for (k = 0; k < scsi_debug_add_host; k++)
+		sdebug_remove_adapter();
 	do_remove_driverfs_files();
 	scsi_debug_unregister_driver(&sdebug_driverfs_driver);
 	bus_unregister(&pseudo_lld_bus);
@@ -1566,35 +1556,74 @@ static int scsi_debug_unregister_driver(
 
 static void sdebug_release_adapter(struct device * dev)
 {
-        kfree(dev);
+        struct sdebug_host_info *sdbg_host;
+
+	sdbg_host = to_sdebug_host(dev);
+        kfree(sdbg_host);
 }
 
 static int sdebug_add_adapter()
 {
-        struct device * dev;
-        int error;
+	int k, devs_per_host;
+        int error = 0;
+        struct sdebug_host_info *sdbg_host;
+        struct sdebug_dev_info *sdbg_devinfo;
+        struct list_head *lh, *lh_sf;
 
-        dev = kmalloc(sizeof(*dev),GFP_KERNEL);
-        if (NULL == dev) {
+        sdbg_host = kmalloc(sizeof(*sdbg_host),GFP_KERNEL);
+
+        if (NULL == sdbg_host) {
                 printk(KERN_ERR "%s: out of memory at line %d\n",
                        __FUNCTION__, __LINE__);
                 return -ENOMEM;
         }
-        memset(dev, 0, sizeof(*dev));
 
-        dev->bus = &pseudo_lld_bus;
-        dev->parent = &pseudo_primary;
-        dev->release = &sdebug_release_adapter;
-        sprintf(dev->name, "scsi debug adapter");
-        sprintf(dev->bus_id, "adapter%d", scsi_debug_add_host);
+        memset(sdbg_host, 0, sizeof(*sdbg_host));
+        INIT_LIST_HEAD(&sdbg_host->dev_info_list);
+
+	devs_per_host = scsi_debug_num_tgts * scsi_debug_max_luns;
+        for (k = 0; k < devs_per_host; k++) {
+                sdbg_devinfo = kmalloc(sizeof(*sdbg_devinfo),GFP_KERNEL);
+                if (NULL == sdbg_devinfo) {
+                        printk(KERN_ERR "%s: out of memory at line %d\n",
+                               __FUNCTION__, __LINE__);
+                        error = -ENOMEM;
+			goto clean1;
+                }
+                memset(sdbg_devinfo, 0, sizeof(*sdbg_devinfo));
+                sdbg_devinfo->sdbg_host = sdbg_host;
+                list_add_tail(&sdbg_devinfo->dev_list,
+                              &sdbg_host->dev_info_list);
+        }
+
+        spin_lock(&sdebug_host_list_lock);
+        list_add_tail(&sdbg_host->host_list, &sdebug_host_list);
+        spin_unlock(&sdebug_host_list_lock);
 
-        error = device_register(dev);
+        sdbg_host->dev.bus = &pseudo_lld_bus;
+        sdbg_host->dev.parent = &pseudo_primary;
+        sdbg_host->dev.release = &sdebug_release_adapter;
+        sprintf(sdbg_host->dev.name, "scsi debug adapter");
+        sprintf(sdbg_host->dev.bus_id, "adapter%d", scsi_debug_add_host);
+
+        error = device_register(&sdbg_host->dev);
 
         if (error)
-                kfree(dev);
-        else
-                ++scsi_debug_add_host;
+		goto clean2;
 
+	++scsi_debug_add_host;
+        return error;
+
+clean2:
+	list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
+		sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
+					  dev_list);
+		list_del(&sdbg_devinfo->dev_list);
+		kfree(sdbg_devinfo);
+	}
+
+clean1:
+	kfree(sdbg_host);
         return error;
 }
 
@@ -1603,51 +1632,29 @@ static void sdebug_remove_adapter()
         struct sdebug_host_info * sdbg_host = NULL;
 
         spin_lock(&sdebug_host_list_lock);
-        if (!list_empty(&sdebug_host_list))
+        if (!list_empty(&sdebug_host_list)) {
                 sdbg_host = list_entry(sdebug_host_list.prev,
                                        struct sdebug_host_info, host_list);
+		list_del(&sdbg_host->host_list);
+	}
         spin_unlock(&sdebug_host_list_lock);
 
-        device_unregister(sdbg_host->dev);
+	if (!sdbg_host)
+		return;
+
+        device_unregister(&sdbg_host->dev);
         --scsi_debug_add_host;
 }
 
 static int sdebug_driver_probe(struct device * dev)
 {
-	int k, devs_per_host;
         int error = 0;
         struct sdebug_host_info *sdbg_host;
-        struct sdebug_dev_info *sdbg_devinfo;
-        struct list_head *lh, *lh_sf;
         struct Scsi_Host *hpnt;
 
-        sdbg_host = kmalloc(sizeof(*sdbg_host),GFP_KERNEL);
-        if (NULL == sdbg_host) {
-                printk(KERN_ERR "%s: out of memory at line %d\n",
-                       __FUNCTION__, __LINE__);
-                return -ENOMEM;
-        }
-        memset(sdbg_host, 0, sizeof(*sdbg_host));
-
-        INIT_LIST_HEAD(&sdbg_host->dev_info_list);
+	sdbg_host = to_sdebug_host(dev);
 
-	devs_per_host = scsi_debug_num_tgts * scsi_debug_max_luns;
-        for (k = 0; k < devs_per_host; k++) {
-                sdbg_devinfo = kmalloc(sizeof(*sdbg_devinfo),GFP_KERNEL);
-                if (NULL == sdbg_devinfo) {
-                        printk(KERN_ERR "%s: out of memory at line %d\n",
-                               __FUNCTION__, __LINE__);
-                        error = -ENOMEM;
-                }
-                memset(sdbg_devinfo, 0, sizeof(*sdbg_devinfo));
-                sdbg_devinfo->sdbg_host = sdbg_host;
-                list_add_tail(&sdbg_devinfo->dev_list,
-                              &sdbg_host->dev_info_list);
-        }
-
-        list_add_tail(&sdbg_host->host_list, &sdebug_host_list);
-
-        hpnt = scsi_register(&sdebug_driver_template, 0);
+        hpnt = scsi_register(&sdebug_driver_template, sizeof(sdbg_host));
         if (NULL == hpnt) {
                 printk(KERN_ERR "%s: scsi_register failed\n", __FUNCTION__);
                 error = -ENODEV;
@@ -1655,14 +1662,14 @@ static int sdebug_driver_probe(struct de
         }
 
         sdbg_host->shost = hpnt;
-        sdbg_host->dev = dev;
+	*((struct sdebug_host_info **)hpnt->hostdata) = sdbg_host;
 	if ((hpnt->this_id >= 0) && (scsi_debug_num_tgts > hpnt->this_id))
 		hpnt->max_id = scsi_debug_num_tgts + 1;
 	else
 		hpnt->max_id = scsi_debug_num_tgts;
 	hpnt->max_lun = scsi_debug_max_luns;
 
-        error = scsi_add_host(hpnt, sdbg_host->dev);
+        error = scsi_add_host(hpnt, &sdbg_host->dev);
         if (error) {
                 printk(KERN_ERR "%s: scsi_add_host failed\n", __FUNCTION__);
                 error = -ENODEV;
@@ -1675,47 +1682,24 @@ static int sdebug_driver_probe(struct de
 clean2:
         scsi_unregister(hpnt);
 clean1:
-        list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
-                sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
-                                          dev_list);
-                list_del(&sdbg_devinfo->dev_list);
-                kfree(sdbg_devinfo);
-        }
-
         kfree(sdbg_host);
 
         return error;
 }
 
-static int sdebug_driver_remove(struct device * dev)
+static int scsi_debug_release(struct Scsi_Host * shost)
 {
         struct list_head *lh, *lh_sf;
         struct sdebug_dev_info *sdbg_devinfo;
-        struct sdebug_host_info *sdbg_host, *found = NULL;
-
-        spin_lock(&sdebug_host_list_lock);
-        list_for_each_entry(sdbg_host, &sdebug_host_list, host_list) {
-                if (sdbg_host->dev == dev) {
-                        list_del(&sdbg_host->host_list);
-                        found = sdbg_host;
-                        break;
-                }
-        }
-        spin_unlock(&sdebug_host_list_lock);
-
-        if (!found) {
-                printk(KERN_ERR "%s: sdebug_host_info not found\n",
-                       __FUNCTION__);
-                return -ENODEV;
-        }
+        struct sdebug_host_info *sdbg_host;
 
+	sdbg_host = *(struct sdebug_host_info **)shost->hostdata;
+        scsi_unregister(shost);
 
-        if (scsi_remove_host(sdbg_host->shost)) {
-                printk(KERN_ERR "%s: scsi_remove_host failed\n", __FUNCTION__);
-                return -EBUSY;
-        }
-
-        scsi_unregister(sdbg_host->shost);
+	if (!sdbg_host) {
+		printk(KERN_ERR "Unable to locate host info\n");
+		return 0;
+	}
 
         list_for_each_safe(lh, lh_sf, &sdbg_host->dev_info_list) {
                 sdbg_devinfo = list_entry(lh, struct sdebug_dev_info,
@@ -1724,7 +1708,20 @@ static int sdebug_driver_remove(struct d
                 kfree(sdbg_devinfo);
         }
 
-        kfree(sdbg_host);
+        return 0;
+
+}
+
+static int sdebug_driver_remove(struct device * dev)
+{
+        struct sdebug_host_info *sdbg_host;
+
+	sdbg_host = to_sdebug_host(dev);
+
+        if (sdbg_host && scsi_remove_host(sdbg_host->shost)) {
+                printk(KERN_ERR "%s: scsi_remove_host failed\n", __FUNCTION__);
+                return -EBUSY;
+        }
 
         return 0;
 }
diff -puN drivers/scsi/scsi_debug.h~scsi_debug-sysfs drivers/scsi/scsi_debug.h
--- sysfs-bleed-2.5/drivers/scsi/scsi_debug.h~scsi_debug-sysfs	Mon Apr 14 10:11:19 2003
+++ sysfs-bleed-2.5-andmike/drivers/scsi/scsi_debug.h	Mon Apr 14 10:11:19 2003
@@ -16,6 +16,7 @@ static int scsi_debug_device_reset(struc
 static int scsi_debug_host_reset(struct scsi_cmnd *);
 static int scsi_debug_proc_info(char *, char **, off_t, int, int, int);
 static const char * scsi_debug_info(struct Scsi_Host *);
+static int scsi_debug_release(struct Scsi_Host *);
 
 /*
  * This driver is written for the lk 2.5 series
@@ -27,6 +28,7 @@ static const char * scsi_debug_info(stru
 static Scsi_Host_Template sdebug_driver_template = {
 	.proc_info =		scsi_debug_proc_info,
 	.name =			"SCSI DEBUG",
+	.release =		scsi_debug_release,
 	.info =			scsi_debug_info,
 	.slave_alloc =		scsi_debug_slave_alloc,
 	.slave_configure =	scsi_debug_slave_configure,

_
