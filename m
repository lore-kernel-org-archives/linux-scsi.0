From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] sym53c8xx PPR negotiation fix
Date: Mon, 3 Nov 2003 10:10:51 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031103181051.GA21012@beaverton.ibm.com>
References: <20031029175045.GC25237@parcelfarce.linux.theplanet.co.uk> <1067450547.3112.363.camel@compaq.xsintricity.com> <20031029183159.GE25237@parcelfarce.linux.theplanet.co.uk> <1067453148.3112.369.camel@compaq.xsintricity.com> <4159000000.1067644546@aslan.btc.adaptec.com> <1067644902.1782.20.camel@mulgrave> <1067645285.3112.538.camel@compaq.xsintricity.com> <4168130000.1067645818@aslan.btc.adaptec.com> <20031101012231.GA2346@beaverton.ibm.com> <1067654044.2464.29.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:751 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S262181AbTKCSHq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Nov 2003 13:07:46 -0500
Content-Disposition: inline
In-Reply-To: <1067654044.2464.29.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Doug Ledford <dledford@redhat.com>, Matthew Wilcox <willy@debian.org>, Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

James Bottomley [James.Bottomley@steeleye.com] wrote:
> On Fri, 2003-10-31 at 19:22, Mike Anderson wrote:
> > It is called from scsi_remove_device.
> 
> But that's only called for configured devices.  The original intent was
> to call slave_destroy for all slave_alloc'd devices (whether configured
> or not).
> 
> It originally was in scsi_free_sdev, but was moved with
> 
> ChangeSet 1.1046.597.3 2003/08/02 12:17:19 andmike@us.ibm.com
>   [PATCH] scsi host / scsi device ref counting take 2 [3/3]
> 
> The changelog isn't very explicit about why this was done, what was the
> particular reason?
> 

While it was changed to call slave_destroy prior to returning from
scsi_remove_host.

In the thread below there is a little more info, but the slides from OLS
are outdated.

http://marc.theaimsgroup.com/?l=linux-scsi&m=105976937705999&w=2

But..

As this thread has indicated this leaks memory for devices not
configured. Since the slave_destroy function is only releasing resources
and we have a reference to the host structure calling this from the scsi
device release function should be ok in unexpected disconnect cases.

I have attached a patch which calls slave_destroy from scsi device
release which now covers the case for all previous callers of
slave_alloc (configured or not). The patch also aligns scsi device
struct device init with how scsi host structures are done. This was
previously discussed in the thread pointed to below.

http://marc.theaimsgroup.com/?t=106737767300003&r=1&w=2 

I have ran the patch with scsi_debug and aic7xxx. I am still doing more
testing once a get a few more devices on the test system.

-andmike
--
Michael Anderson
andmike@us.ibm.com


DESC
This patch splits the scsi device struct device register into init and
add. It also addresses memory leak issues of not calling slave_destroy on
scsi_devices that are not configured in.

Details:
- Make scsi_device_dev_release extern for scsi_scan to use in
alloc_sdev.
- Move scsi_free_sdev code to scsi_device_dev_release.
- Changed name of scsi_device_register to scsi_sysfs_add_sdev to
match host call and align with split struct device init.
- Move sdev_gendev device and class init to scsi_alloc_sdev.
- Moved call to slave_destroy to scsi_device_dev_release.
- Removed scsi_free_sdev. Two callers now do put_device.
EDESC


 drivers/scsi/scsi_priv.h  |    4 +--
 drivers/scsi/scsi_scan.c  |   55 ++++++++++++++++++----------------------------
 drivers/scsi/scsi_sysfs.c |   44 +++++++++++++++++++-----------------
 3 files changed, 47 insertions(+), 56 deletions(-)

diff -puN drivers/scsi/scsi_sysfs.c~sdev_ldm_reg drivers/scsi/scsi_sysfs.c
--- patched-scsi-bugfixes-2.6/drivers/scsi/scsi_sysfs.c~sdev_ldm_reg	Fri Oct 31 09:07:07 2003
+++ patched-scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_sysfs.c	Sun Nov  2 22:20:15 2003
@@ -115,14 +115,32 @@ static void scsi_device_cls_release(stru
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
+	if (sdev->host->hostt->slave_destroy)
+		sdev->host->hostt->slave_destroy(sdev);
+
+	kfree(sdev->inquiry);
+	kfree(sdev);
+
 	put_device(parent);
 }
 
@@ -321,29 +339,17 @@ static int attr_add(struct device *dev, 
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
 	int error = 0, i;
 
 	set_bit(SDEV_ADD, &sdev->sdev_state);
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
 
 	error = device_add(&sdev->sdev_gendev);
 	if (error) {
@@ -351,8 +357,6 @@ int scsi_device_register(struct scsi_dev
 		return error;
 	}
 
-	get_device(sdev->sdev_gendev.parent);
-
 	error = class_device_add(&sdev->sdev_classdev);
 	if (error) {
 		printk(KERN_INFO "error 2\n");
@@ -398,8 +402,6 @@ void scsi_remove_device(struct scsi_devi
 {
 	set_bit(SDEV_DEL, &sdev->sdev_state);
 	class_device_unregister(&sdev->sdev_classdev);
-	if (sdev->host->hostt->slave_destroy)
-		sdev->host->hostt->slave_destroy(sdev);
 	device_del(&sdev->sdev_gendev);
 	put_device(&sdev->sdev_gendev);
 }
diff -puN drivers/scsi/scsi_scan.c~sdev_ldm_reg drivers/scsi/scsi_scan.c
--- patched-scsi-bugfixes-2.6/drivers/scsi/scsi_scan.c~sdev_ldm_reg	Sat Nov  1 12:25:12 2003
+++ patched-scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_scan.c	Sun Nov  2 12:50:52 2003
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
@@ -273,36 +292,6 @@ out:
 }
 
 /**
- * scsi_free_sdev - cleanup and free a scsi_device
- * @sdev:	cleanup and free this scsi_device
- *
- * Description:
- *     Undo the actions in scsi_alloc_sdev, including removing @sdev from
- *     the list, and freeing @sdev.
- **/
-void scsi_free_sdev(struct scsi_device *sdev)
-{
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
-}
-
-/**
  * scsi_probe_lun - probe a single LUN using a SCSI INQUIRY
  * @sreq:	used to send the INQUIRY
  * @inq_result:	area to store the INQUIRY result
@@ -642,7 +631,7 @@ static int scsi_add_lun(struct scsi_devi
 	 * register it and tell the rest of the kernel
 	 * about it.
 	 */
-	scsi_device_register(sdev);
+	scsi_sysfs_add_sdev(sdev);
 
 	return SCSI_SCAN_LUN_PRESENT;
 }
@@ -749,7 +738,7 @@ static int scsi_probe_and_add_lun(struct
 		if (sdevp)
 			*sdevp = sdev;
 	} else
-		scsi_free_sdev(sdev);
+		put_device(&sdev->sdev_gendev);
  out:
 	return res;
 }
@@ -1301,5 +1290,5 @@ struct scsi_device *scsi_get_host_dev(st
 void scsi_free_host_dev(struct scsi_device *sdev)
 {
 	BUG_ON(sdev->id != sdev->host->this_id);
-	scsi_free_sdev(sdev);
+	put_device(&sdev->sdev_gendev);
 }
diff -puN drivers/scsi/scsi_priv.h~sdev_ldm_reg drivers/scsi/scsi_priv.h
--- patched-scsi-bugfixes-2.6/drivers/scsi/scsi_priv.h~sdev_ldm_reg	Sat Nov  1 12:42:59 2003
+++ patched-scsi-bugfixes-2.6-andmike/drivers/scsi/scsi_priv.h	Sun Nov  2 18:26:09 2003
@@ -130,7 +130,6 @@ extern void scsi_exit_procfs(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, unsigned int, int);
 extern void scsi_forget_host(struct Scsi_Host *);
-extern void scsi_free_sdev(struct scsi_device *);
 extern void scsi_rescan_device(struct device *);
 
 /* scsi_sysctl.c */
@@ -143,7 +142,8 @@ extern void scsi_exit_sysctl(void);
 #endif /* CONFIG_SYSCTL */
 
 /* scsi_sysfs.c */
-extern int scsi_device_register(struct scsi_device *);
+extern void scsi_device_dev_release(struct device *);
+extern int scsi_sysfs_add_sdev(struct scsi_device *);
 extern int scsi_sysfs_add_host(struct Scsi_Host *);
 extern int scsi_sysfs_register(void);
 extern void scsi_sysfs_unregister(void);

_
