From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC] scsi host sysfs support again [3/4]
Date: Mon, 5 May 2003 01:37:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030505083723.GE8416@beaverton.ibm.com>
References: <20030505083315.GB8416@beaverton.ibm.com> <20030505083445.GC8416@beaverton.ibm.com> <20030505083540.GD8416@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:11667 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262038AbTEEIWc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2003 04:22:32 -0400
Content-Disposition: inline
In-Reply-To: <20030505083540.GD8416@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
Change scsi host to class device model. Change scsi host and scsi device
to release when ref count goes to zero.
EDESC


 drivers/scsi/hosts.c     |   23 +++++------------------
 drivers/scsi/hosts.h     |   20 ++++++++++++++------
 drivers/scsi/scsi_scan.c |    4 +---
 3 files changed, 20 insertions(+), 27 deletions(-)

diff -puN drivers/scsi/hosts.h~scsi_shosts-sysfs drivers/scsi/hosts.h
--- sysfs-scsi-misc-2.5/drivers/scsi/hosts.h~scsi_shosts-sysfs	Thu May  1 18:10:59 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.h	Thu May  1 18:17:11 2003
@@ -482,9 +482,10 @@ struct Scsi_Host
     unsigned int max_host_blocked;
 
     /* 
-     * Support for driverfs filesystem
+     * Support for sysfs
      */
-    struct device *host_gendev;
+    struct device host_gendev;
+    struct class_device class_dev;
 
     /*
      * We should ensure that this is aligned, both for better performance
@@ -495,8 +496,11 @@ struct Scsi_Host
         __attribute__ ((aligned (sizeof(unsigned long))));
 };
 
-#define	to_scsi_host(d)	d->driver_data	/* Major logical breakage, but we compile again... */
-	
+#define		dev_to_shost(d)		\
+	container_of(d, struct Scsi_Host, host_gendev)
+#define		class_to_shost(d)	\
+	container_of(d, struct Scsi_Host, class_dev)
+
 /*
  * These two functions are used to allocate and free a pseudo device
  * which will connect to the host adapter itself rather than any
@@ -519,12 +523,12 @@ static inline void scsi_assign_lock(stru
 static inline void scsi_set_device(struct Scsi_Host *shost,
                                    struct device *dev)
 {
-        shost->host_gendev = dev;
+        shost->host_gendev.parent = dev;
 }
 
 static inline struct device *scsi_get_device(struct Scsi_Host *shost)
 {
-        return shost->host_gendev;
+        return shost->host_gendev.parent;
 }
 
 struct Scsi_Device_Template
@@ -591,6 +595,10 @@ static inline Scsi_Device *scsi_find_dev
  */
 extern int scsi_upper_driver_register(struct Scsi_Device_Template *);
 extern void scsi_upper_driver_unregister(struct Scsi_Device_Template *);
+extern int scsi_sysfs_add_host(struct Scsi_Host *, struct device *);
+extern void scsi_sysfs_remove_host(struct Scsi_Host *);
+
+extern void scsi_free_sdev(struct scsi_device *);
 
 extern struct class shost_class;
 
diff -puN drivers/scsi/hosts.c~scsi_shosts-sysfs drivers/scsi/hosts.c
--- sysfs-scsi-misc-2.5/drivers/scsi/hosts.c~scsi_shosts-sysfs	Thu May  1 18:10:59 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.c	Thu May  1 18:10:59 2003
@@ -193,16 +193,6 @@ static int scsi_host_legacy_release(stru
 	return 0;
 }
 
-static int scsi_remove_legacy_host(struct Scsi_Host *shost)
-{
-	int error;
-
-	error = scsi_remove_host(shost);
-	if (!error)
-		(*shost->hostt->release)(shost);
-	return 0;
-}
-
 static int scsi_check_device_busy(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -268,11 +258,8 @@ int scsi_remove_host(struct Scsi_Host *s
 	list_for_each_entry(sdev, &shost->my_devices, siblings)
 		sdev->online = FALSE;
 
-	list_for_each_entry(sdev, &shost->my_devices, siblings)
-		if (scsi_check_device_busy(sdev))
-			return 1;
-
 	scsi_forget_host(shost);
+	scsi_sysfs_remove_host(shost);
 	return 0;
 }
 
@@ -293,9 +280,9 @@ int scsi_add_host(struct Scsi_Host *shos
 	printk(KERN_INFO "scsi%d : %s\n", shost->host_no,
 			sht->info ? sht->info(shost) : sht->name);
 
-	if (dev) {
-		shost->host_gendev = dev;
-	}
+	error = scsi_sysfs_add_host(shost, dev);
+	if (error)
+		return error;
 
 	scsi_scan_host(shost);
 			
@@ -531,7 +518,7 @@ out_of_space:
  **/
 int scsi_unregister_host(Scsi_Host_Template *shost_tp)
 {
-	scsi_tp_for_each_host(shost_tp, scsi_remove_legacy_host);
+	scsi_tp_for_each_host(shost_tp, scsi_remove_host);
 	return 0;
 
 }
diff -puN drivers/scsi/scsi_scan.c~scsi_shosts-sysfs drivers/scsi/scsi_scan.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_scan.c~scsi_shosts-sysfs	Thu May  1 18:10:59 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_scan.c	Thu May  1 18:10:59 2003
@@ -480,7 +480,7 @@ out:
  *     Undo the actions in scsi_alloc_sdev, including removing @sdev from
  *     the list, and freeing @sdev.
  **/
-static void scsi_free_sdev(struct scsi_device *sdev)
+void scsi_free_sdev(struct scsi_device *sdev)
 {
 	unsigned long flags;
 
@@ -1273,8 +1273,6 @@ int scsi_remove_device(struct scsi_devic
 		return -EINVAL;
 
 	scsi_device_unregister(sdev);
-
-	scsi_free_sdev(sdev);
 	return 0;
 }
 

_
