From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Thu, 6 Nov 2003 01:04:08 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031106090408.GA1398@beaverton.ibm.com>
References: <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk> <1067453148.3112.369.camel@compaq.xsintricity.com> <4159000000.1067644546@aslan.btc.adaptec.com> <1067644902.1782.20.camel@mulgrave> <1067645285.3112.538.camel@compaq.xsintricity.com> <4168130000.1067645818@aslan.btc.adaptec.com> <20031101012231.GA2346@beaverton.ibm.com> <1067654044.2464.29.camel@mulgrave> <20031103181051.GA21012@beaverton.ibm.com> <20031104071001.A10128@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:13999 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S263462AbTKFJBP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2003 04:01:15 -0500
Content-Disposition: inline
In-Reply-To: <20031104071001.A10128@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

Christoph Hellwig [hch@infradead.org] wrote:
> Umm, the code implementing ->slave_destroy may no more exist when the
> scsi_device reference count hits zero..

Ok here is an update. This should address both issues of not calling
slave_destroy on scan'd but not configured devices and also calling
slave_destroy on host removal prior to the return of scsi_remove_host.

I added a piece of two test runs. A more complete log is available.

Ex 1. Configured device mounted with unexpected disconnect followed by
unmount.

chk_scsi_ref: Remove adapter

kobject ./<NULL>: cleaning up
kobject scsi_device/2:0:0:0: cleaning up
kobject ./<NULL>: cleaning up
kobject queue/iosched: cleaning up
kobject sdd/queue: cleaning up
scsi_debug: slave_destroy <2 0 0 0>
kobject scsi_host/host2: cleaning up

chk_scsi_ref: umount sdd

Buffer I/O error on device sdd, logical block 1
lost page write due to I/O error on sdd
kobject host2/2:0:0:0: cleaning up
kobject adapter1/host2: cleaning up
kobject pseudo_0/adapter1: cleaning up
kobject ./<NULL>: cleaning up
kobject block/sdd: cleaning up

Ex 2. Scanning a device that was not configured.

scsi_debug: slave_alloc <9 0 1 0>
scsi_debug: cmd 12 00 00 00 24 00
scsi_debug: ... <9 0 1 0> non-zero result=0x10000
scsi_debug: slave_destroy <9 0 1 0>
kobject ./<NULL>: cleaning up

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This patch splits the scsi device struct device register into init and
add. It also addresses memory leak issues of not calling slave_destroy on
scsi_devices that are not configured in.

Details:
* Make scsi_device_dev_release extern for scsi_scan to use in
alloc_sdev.
* Move scsi_free_sdev code to scsi_device_dev_release. Have
scsi_free_sdev call slave_destroy plus put_device.
* Changed name of scsi_device_register to scsi_sysfs_add_sdev to
match host call and align with split struct device init.
* Move sdev_gendev device and class init to scsi_alloc_sdev.

Thu Nov  6 07:43:56 UTC 2003
EDESC


 drivers/scsi/scsi_priv.h  |    3 +-
 drivers/scsi/scsi_scan.c  |   42 ++++++++++++++++++----------------
 drivers/scsi/scsi_sysfs.c |   56 +++++++++++++++++++++++-----------------------
 3 files changed, 54 insertions(+), 47 deletions(-)

diff -puN drivers/scsi/scsi_priv.h~sdev_ldm_reg drivers/scsi/scsi_priv.h
--- scsi-bugfixes-2.6/drivers/scsi/scsi_priv.h~sdev_ldm_reg	Tue Nov  4 23:17:24 2003
+++ scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_priv.h	Tue Nov  4 23:17:24 2003
@@ -143,7 +143,8 @@ extern void scsi_exit_sysctl(void);
 #endif /* CONFIG_SYSCTL */
 
 /* scsi_sysfs.c */
-extern int scsi_device_register(struct scsi_device *);
+extern void scsi_device_dev_release(struct device *);
+extern int scsi_sysfs_add_sdev(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);
diff -puN drivers/scsi/scsi_scan.c~sdev_ldm_reg drivers/scsi/scsi_scan.c
--- scsi-bugfixes-2.6/drivers/scsi/scsi_scan.c~sdev_ldm_reg	Tue Nov  4 23:17:24 2003
+++ scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_scan.c	Tue Nov  4 23:17:24 2003
@@ -236,6 +236,25 @@ static struct scsi_device *scsi_alloc_sd
 			goto out_free_queue;
 	}
 
+	if (get_device(&sdev->host->shost_gendev)) {
+
+		device_initialize(&sdev->sdev_gendev);
+		sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
+		sdev->sdev_gendev.bus = &scsi_bus_type;
+		sdev->sdev_gendev.release = scsi_device_dev_release;
+		sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
+			sdev->host->host_no, sdev->channel, sdev->id,
+			sdev->lun);
+
+		class_device_initialize(&sdev->sdev_classdev);
+		sdev->sdev_classdev.dev = &sdev->sdev_gendev;
+		sdev->sdev_classdev.class = &sdev_class;
+		snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
+			 "%d:%d:%d:%d", sdev->host->host_no,
+			 sdev->channel, sdev->id, sdev->lun);
+	} else
+		goto out_free_queue;
+
 	/*
 	 * If there are any same target siblings, add this to the
 	 * sibling list
@@ -282,24 +301,9 @@ out:
  **/
 void scsi_free_sdev(struct scsi_device *sdev)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->siblings);
-	list_del(&sdev->same_target_siblings);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
-
-	if (sdev->request_queue)
-		scsi_free_queue(sdev->request_queue);
-
-	spin_lock_irqsave(sdev->host->host_lock, flags);
-	list_del(&sdev->starved_entry);
-	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
-		kfree(sdev->sdev_target);
-	spin_unlock_irqrestore(sdev->host->host_lock, flags);
-
-	kfree(sdev->inquiry);
-	kfree(sdev);
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+	put_device(&sdev->sdev_gendev);
 }
 
 /**
@@ -642,7 +646,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	scsi_device_register(sdev);
+	scsi_sysfs_add_sdev(sdev);
 
 	return SCSI_SCAN_LUN_PRESENT;
 }
diff -puN drivers/scsi/scsi_sysfs.c~sdev_ldm_reg drivers/scsi/scsi_sysfs.c
--- scsi-bugfixes-2.6/drivers/scsi/scsi_sysfs.c~sdev_ldm_reg	Tue Nov  4 23:17:24 2003
+++ scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_sysfs.c	Tue Nov  4 23:17:24 2003
@@ -115,14 +115,29 @@ static void scsi_device_cls_release(stru
 	put_device(&sdev->sdev_gendev);
 }
 
-static void scsi_device_dev_release(struct device *dev)
+void scsi_device_dev_release(struct device *dev)
 {
 	struct scsi_device *sdev;
 	struct device *parent;
+	unsigned long flags;
 
 	parent = dev->parent;
 	sdev = to_scsi_device(dev);
-	scsi_free_sdev(sdev);
+
+	spin_lock_irqsave(sdev->host->host_lock, flags);
+	list_del(&sdev->siblings);
+	list_del(&sdev->same_target_siblings);
+	list_del(&sdev->starved_entry);
+	if (sdev->single_lun && --sdev->sdev_target->starget_refcnt == 0)
+		kfree(sdev->sdev_target);
+	spin_unlock_irqrestore(sdev->host->host_lock, flags);
+
+	if (sdev->request_queue)
+		scsi_free_queue(sdev->request_queue);
+
+	kfree(sdev->inquiry);
+	kfree(sdev);
+
 	put_device(parent);
 }
 
@@ -321,29 +336,18 @@ static int attr_add(struct device *dev, 
 }
 
 /**
- * scsi_device_register - register a scsi device with the scsi bus
- * @sdev:	scsi_device to register
+ * scsi_sysfs_add_sdev - add scsi device to sysfs
+ * @sdev:	scsi_device to add
  *
  * Return value:
  * 	0 on Success / non-zero on Failure
  **/
-int scsi_device_register(struct scsi_device *sdev)
+int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 {
-	int error = 0, i;
+	int error = -EINVAL, i;
 
-	set_bit(SDEV_ADD, &sdev->sdev_state);
-	device_initialize(&sdev->sdev_gendev);
-	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
-	sdev->sdev_gendev.parent = &sdev->host->shost_gendev;
-	sdev->sdev_gendev.bus = &scsi_bus_type;
-	sdev->sdev_gendev.release = scsi_device_dev_release;
-
-	class_device_initialize(&sdev->sdev_classdev);
-	sdev->sdev_classdev.dev = &sdev->sdev_gendev;
-	sdev->sdev_classdev.class = &sdev_class;
-	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE, "%d:%d:%d:%d",
-		sdev->host->host_no, sdev->channel, sdev->id, sdev->lun);
+	if (test_and_set_bit(SDEV_ADD, &sdev->sdev_state))
+		return error;
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
@@ -351,8 +355,6 @@ int scsi_device_register(struct scsi_dev
 		return error;
 	}
 
-	get_device(sdev->sdev_gendev.parent);
-
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
@@ -396,12 +398,12 @@ clean_device:
  **/
 void scsi_remove_device(struct scsi_device *sdev)
 {
-	set_bit(SDEV_DEL, &sdev->sdev_state);
-	class_device_unregister(&sdev->sdev_classdev);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
-	device_del(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_gendev);
+	if (test_and_clear_bit(SDEV_ADD, &sdev->sdev_state)) {
+		set_bit(SDEV_DEL, &sdev->sdev_state);
+		class_device_unregister(&sdev->sdev_classdev);
+		device_del(&sdev->sdev_gendev);
+		scsi_free_sdev(sdev);
+	}
 }
 
 int scsi_register_driver(struct device_driver *drv)

_
