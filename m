From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [2/2]
Date: Thu, 8 May 2003 23:35:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030509063545.GC3259@beaverton.ibm.com>
References: <20030509063321.GA3259@beaverton.ibm.com> <20030509063453.GB3259@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:3582 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262305AbTEIGUl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2003 02:20:41 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e32.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h496XDkc266750
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2003 02:33:13 -0400
Received: from hmsbounty (sig-9-65-19-60.mts.ibm.com [9.65.19.60])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h496XBKU120818
	for <linux-scsi@vger.kernel.org>; Fri, 9 May 2003 00:33:12 -0600
Content-Disposition: inline
In-Reply-To: <20030509063453.GB3259@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
scsi shost sysfs cleanups for scsi-misc-2.5
- Add LLDD short name to scsi_host struct device.
- scsi_host_release now calls scsi_free_shost.
- Switched from device_register / device_unregister and class_register
/ class_register to initialize, add, del, put pairs.
- Moved some function from scsi_register and scsi_unregister.
- Filled in scsi_host_put and scsi_host_get.
EDESC


 drivers/scsi/hosts.c      |   33 ++++++++++++++++++++++++++++-----
 drivers/scsi/hosts.h      |    2 ++
 drivers/scsi/scsi_sysfs.c |   19 +++++++++++--------
 3 files changed, 41 insertions(+), 13 deletions(-)

diff -puN drivers/scsi/scsi_sysfs.c~scsi_shost_sysfs-misc-fix drivers/scsi/scsi_sysfs.c
--- sysfs-scsi-misc-2.5/drivers/scsi/scsi_sysfs.c~scsi_shost_sysfs-misc-fix	Thu May  8 22:46:53 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/scsi_sysfs.c	Thu May  8 22:46:53 2003
@@ -317,7 +317,8 @@ static void scsi_host_release(struct dev
 	shost = dev_to_shost(dev);
 	if (!shost)
 		return;
-	shost->hostt->release(shost);
+
+	scsi_free_shost(shost);
 }
 
 /**
@@ -329,13 +330,15 @@ int scsi_sysfs_add_host(struct Scsi_Host
 {
 	int i, error;
 
-	sprintf(shost->host_gendev.bus_id,"host%d",
+	snprintf(shost->host_gendev.bus_id, BUS_ID_SIZE, "host%d",
 		shost->host_no);
+	snprintf(shost->host_gendev.name, DEVICE_NAME_SIZE, "%s",
+		shost->hostt->proc_name);
 	if (!shost->host_gendev.parent)
 		shost->host_gendev.parent = (dev) ? dev : &legacy_bus;
 	shost->host_gendev.release = scsi_host_release;
 
-	error = device_register(&shost->host_gendev);
+	error = device_add(&shost->host_gendev);
 	if (error)
 		return error;
 
@@ -343,7 +346,7 @@ int scsi_sysfs_add_host(struct Scsi_Host
 	shost->class_dev.class = &shost_class;
 	snprintf(shost->class_dev.class_id, BUS_ID_SIZE, "host%d",
 		  shost->host_no);
-	error = class_device_register(&shost->class_dev);
+	error = class_device_add(&shost->class_dev);
 	if (error)
 		goto clean_device;
 
@@ -356,9 +359,9 @@ int scsi_sysfs_add_host(struct Scsi_Host
 	return error;
 
 clean_class:
-	class_device_unregister(&shost->class_dev);
+	class_device_del(&shost->class_dev);
 clean_device:
-	device_unregister(&shost->host_gendev);
+	device_del(&shost->host_gendev);
 
 	return error;
 }
@@ -369,7 +372,7 @@ clean_device:
  **/
 void scsi_sysfs_remove_host(struct Scsi_Host *shost)
 {
-	class_device_unregister(&shost->class_dev);
-	device_unregister(&shost->host_gendev);
+	class_device_del(&shost->class_dev);
+	device_del(&shost->host_gendev);
 }
 
diff -puN drivers/scsi/hosts.c~scsi_shost_sysfs-misc-fix drivers/scsi/hosts.c
--- sysfs-scsi-misc-2.5/drivers/scsi/hosts.c~scsi_shost_sysfs-misc-fix	Thu May  8 22:46:53 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.c	Thu May  8 22:46:53 2003
@@ -212,6 +212,7 @@ int scsi_remove_host(struct Scsi_Host *s
 	list_for_each_entry(sdev, &shost->my_devices, siblings)
 		sdev->online = FALSE;
 
+	scsi_proc_host_rm(shost);
 	scsi_forget_host(shost);
 	scsi_sysfs_remove_host(shost);
 	return 0;
@@ -238,6 +239,8 @@ int scsi_add_host(struct Scsi_Host *shos
 	if (error)
 		return error;
 
+	scsi_proc_host_add(shost);
+
 	scsi_scan_host(shost);
 			
 	list_for_each_entry (sdev, &shost->my_devices, siblings) {
@@ -255,6 +258,15 @@ int scsi_add_host(struct Scsi_Host *shos
  **/
 void scsi_unregister(struct Scsi_Host *shost)
 {
+	scsi_host_put(shost);
+}
+
+/**
+ * scsi_free_sdev - free a scsi hosts resources
+ * @shost:	scsi host to free 
+ **/
+void scsi_free_shost(struct Scsi_Host *shost)
+{
 	/* Remove shost from scsi_host_list */
 	spin_lock(&scsi_host_list_lock);
 	list_del(&shost->sh_list);
@@ -273,7 +285,6 @@ void scsi_unregister(struct Scsi_Host *s
 	}
 
 	shost->hostt->present--;
-	scsi_proc_host_rm(shost);
 	scsi_destroy_command_freelist(shost);
 	kfree(shost);
 }
@@ -394,7 +405,8 @@ found:
 	rval = scsi_setup_command_freelist(shost);
 	if (rval)
 		goto fail;
-	scsi_proc_host_add(shost);
+	device_initialize(&shost->host_gendev);
+	class_device_initialize(&shost->class_dev);
 
 	shost->eh_notify = &sem;
 	kernel_thread((int (*)(void *)) scsi_error_handler, (void *) shost, 0);
@@ -523,15 +535,26 @@ struct Scsi_Host *scsi_host_hn_get(unsig
 }
 
 /**
+ * *scsi_host_get - inc a Scsi_Host ref count
+ * @shost:	Pointer to Scsi_Host to inc.
+ **/
+void scsi_host_get(struct Scsi_Host *shost)
+{
+
+	get_device(&shost->host_gendev);
+	class_device_get(&shost->class_dev);
+	return;
+}
+
+/**
  * *scsi_host_put - dec a Scsi_Host ref count
  * @shost:	Pointer to Scsi_Host to dec.
  **/
 void scsi_host_put(struct Scsi_Host *shost)
 {
 
-	/* XXX Get list lock */
-	/* XXX dec ref count */
-	/* XXX Release list lock */
+	put_device(&shost->host_gendev);
+	class_device_put(&shost->class_dev);
 	return;
 }
 
diff -puN drivers/scsi/hosts.h~scsi_shost_sysfs-misc-fix drivers/scsi/hosts.h
--- sysfs-scsi-misc-2.5/drivers/scsi/hosts.h~scsi_shost_sysfs-misc-fix	Thu May  8 22:46:53 2003
+++ sysfs-scsi-misc-2.5-andmike/drivers/scsi/hosts.h	Thu May  8 22:46:53 2003
@@ -556,6 +556,7 @@ extern int scsi_unregister_device(struct
  */
 extern struct Scsi_Host * scsi_register(Scsi_Host_Template *, int);
 extern void scsi_unregister(struct Scsi_Host *);
+extern void scsi_free_shost(struct Scsi_Host *);
 
 /*
  * HBA registration/unregistration.
@@ -570,6 +571,7 @@ extern int scsi_register_host(Scsi_Host_
 extern int scsi_unregister_host(Scsi_Host_Template *);
 
 extern struct Scsi_Host *scsi_host_hn_get(unsigned short);
+extern void scsi_host_get(struct Scsi_Host *);
 extern void scsi_host_put(struct Scsi_Host *);
 
 /**

_
