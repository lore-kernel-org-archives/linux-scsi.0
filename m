From: Christoph Hellwig <hch@lst.de>
Subject: references on sdev_class & shost_class
Date: Fri, 26 Sep 2003 18:05:58 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030926160558.GA24575@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:32390 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261380AbTIZQGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 12:06:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: andmike@us.ibm.com
Cc: linux-scsi@vger.kernel.org

Hi Mike,

what's the rationale behind all this class_get's on the scsi
host and device classes?  I stumbled over that code when merging
up the final bits for proper scsi_device reference counting and
it looks strange.

If we every don't get a reference to the class in scsi_device_put
or scsi_remove_device we leak references to scsi_devices which
would be very bad.

But how could we actually fail to acquire a reference?  This means
scsi_mod would be unloading which seems impossible as all scsi hosts
and devices are allocated by modules that use symbols from scsi_mod.

Should we just rip this stuff out like below?


--- 1.94/drivers/scsi/hosts.c	Sun Sep 21 19:52:38 2003
+++ edited/drivers/scsi/hosts.c	Fri Sep 26 17:51:08 2003
@@ -323,23 +323,20 @@
  **/
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
-	struct class *class = class_get(&shost_class);
+	struct class *class = &shost_class;
 	struct class_device *cdev;
 	struct Scsi_Host *shost = ERR_PTR(-ENXIO), *p;
 
-	if (class) {
-		down_read(&class->subsys.rwsem);
-		list_for_each_entry(cdev, &class->children, node) {
-			p = class_to_shost(cdev);
-			if (p->host_no == hostnum) {
-				shost = scsi_host_get(p);
-				break;
-			}
+	down_read(&class->subsys.rwsem);
+	list_for_each_entry(cdev, &class->children, node) {
+		p = class_to_shost(cdev);
+		if (p->host_no == hostnum) {
+			shost = scsi_host_get(p);
+			break;
 		}
-		up_read(&class->subsys.rwsem);
 	}
+	up_read(&class->subsys.rwsem);
 
-	class_put(&shost_class);
 	return shost;
 }
 
--- 1.128/drivers/scsi/scsi.c	Sat Sep 20 11:35:19 2003
+++ edited/drivers/scsi/scsi.c	Fri Sep 26 17:51:33 2003
@@ -885,10 +885,6 @@
 
 int scsi_device_get(struct scsi_device *sdev)
 {
-	struct class *class = class_get(&sdev_class);
-
-	if (!class)
-		goto out;
 	if (test_bit(SDEV_DEL, &sdev->sdev_state))
 		goto out;
 	if (!try_module_get(sdev->host->hostt->module))
@@ -896,29 +892,21 @@
 	if (!get_device(&sdev->sdev_gendev))
 		goto out_put_module;
 	atomic_inc(&sdev->access_count);
-	class_put(&sdev_class);
 	return 0;
 
  out_put_module:
 	module_put(sdev->host->hostt->module);
  out:
-	class_put(&sdev_class);
 	return -ENXIO;
 }
 
 void scsi_device_put(struct scsi_device *sdev)
 {
-	struct class *class = class_get(&sdev_class);
-
-	if (!class)
-		return;
-
 	module_put(sdev->host->hostt->module);
 	if (atomic_dec_and_test(&sdev->access_count))
 		if (test_bit(SDEV_DEL, &sdev->sdev_state))
 			device_del(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
-	class_put(&sdev_class);
 }
 
 int scsi_device_cancel_cb(struct device *dev, void *data)
===== drivers/scsi/scsi_sysfs.c 1.33 vs edited =====
--- 1.33/drivers/scsi/scsi_sysfs.c	Sun Sep 21 12:36:43 2003
+++ edited/drivers/scsi/scsi_sysfs.c	Fri Sep 26 17:52:07 2003
@@ -403,22 +403,15 @@
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	struct class *class = class_get(&sdev_class);
-
 	class_device_unregister(&sdev->sdev_classdev);
 
-	if (class) {
-		down_write(&class->subsys.rwsem);
-		set_bit(SDEV_DEL, &sdev->sdev_state);
-		if (sdev->host->hostt->slave_destroy)
-			sdev->host->hostt->slave_destroy(sdev);
-		if (atomic_read(&sdev->access_count))
-			device_del(&sdev->sdev_gendev);
-		up_write(&class->subsys.rwsem);
-	}
+	set_bit(SDEV_DEL, &sdev->sdev_state);
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	if (atomic_read(&sdev->access_count))
+		device_del(&sdev->sdev_gendev);
 
 	put_device(&sdev->sdev_gendev);
-
 	class_put(&sdev_class);
 }
 
