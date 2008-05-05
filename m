From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [Bug 9872] Driver 'sd' needs updating - please use bus_type
	methods
Date: Mon, 05 May 2008 18:22:50 +0200
Message-ID: <1210004570.2865.17.camel@linux.site>
References: <20080504002244.D924910805F@picon.linux-foundation.org>
	 <1209911661.16283.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charybdis-ext.suse.de ([195.135.221.2]:58395 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754182AbYEEQXf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 12:23:35 -0400
In-Reply-To: <1209911661.16283.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Hannes Reinecke <hare@suse.de>

On Sun, 2008-05-04 at 09:34 -0500, James Bottomley wrote:
> On Sat, 2008-05-03 at 17:22 -0700, bugme-daemon@bugzilla.kernel.org
> wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=9872
> 
> This isn't a bug.  There have been numerous discussions about fixing it.

It is a kind of a "bug". The core does not call driver functions, if
bus_type is provided. So the warning is fine according to the current
logic of the core, telling you it will ignore things a driver asked for.

> The warning comes out of here in drivers/base/driver.c:
> 
> 	if ((drv->bus->probe && drv->probe) ||
> 	    (drv->bus->remove && drv->remove) ||
> 	    (drv->bus->shutdown && drv->shutdown))
> 		printk(KERN_WARNING "Driver '%s' needs updating - please use "
> 			"bus_type methods\n", drv->name);
> 
> The problem is that SCSI drivers have both: SCSI uses the bus methods to
> trigger the probe and remove (as it must having a bus method) but it
> also uses the individual struct driver probe and remove methods to
> rethrow the events to the ULDs.

Looks like it does not use probe() on the bus. Now lets get rid of
remove(). :)

> According to Kay and Greg, this is a legitimate way of operating, and
> they're not going to remove the driver methods (otherwise we'd just take
> them into struct scsi_driver), so we're stuck trying to find a way to
> prevent the base warning about this.

Right, I guess, they are not going away, but you still should only use
one of them, and not both at the same time.

How about the following patch? Which does not use driver core pointers,
which are ignored by the core, to do private SCSI stuff.

Thanks,
Kay 



From: Hannes Reinecke <hare@suse.de>
Subject: SCSI: do not use bus_type->remove() and driver->remove() at the same time

If a driver sets blk_queue_prep_rq(), it should clean it up itself, and
not from the bus callbacks. This removes the need to hook into bus->remove(),
which should not be used at the same time as driver->remove().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

 drivers/scsi/scsi_lib.c    |    1 +
 drivers/scsi/scsi_priv.h   |    1 -
 drivers/scsi/scsi_sysfs.c  |   17 -----------------
 drivers/scsi/sd.c          |    2 ++
 drivers/scsi/sr.c          |    1 +
 include/scsi/scsi_driver.h |    1 +
 6 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a82d2fe..16d21d2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1267,6 +1267,7 @@ int scsi_prep_fn(struct request_queue *q, struct request *req)
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
 	return scsi_prep_return(q, req, ret);
 }
+EXPORT_SYMBOL(scsi_prep_fn);
 
 /*
  * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index b33e725..8dd1e3b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -76,7 +76,6 @@ extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
 struct request_queue;
 struct request;
-extern int scsi_prep_fn(struct request_queue *, struct request *);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 049103f..ad0b88b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -410,29 +410,12 @@ static int scsi_bus_resume(struct device * dev)
 	return err;
 }
 
-static int scsi_bus_remove(struct device *dev)
-{
-	struct device_driver *drv = dev->driver;
-	struct scsi_device *sdev = to_scsi_device(dev);
-	int err = 0;
-
-	/* reset the prep_fn back to the default since the
-	 * driver may have altered it and it's being removed */
-	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
-
-	if (drv && drv->remove)
-		err = drv->remove(dev);
-
-	return 0;
-}
-
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
 	.suspend	= scsi_bus_suspend,
 	.resume		= scsi_bus_resume,
-	.remove		= scsi_bus_remove,
 };
 
 int scsi_sysfs_register(void)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 01cefbb..672a17a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1743,6 +1743,8 @@ static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
+	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
+
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..5860dc7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -901,6 +901,7 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	blk_queue_prep_rq(cd->device->request_queue, scsi_prep_fn);
 	del_gendisk(cd->disk);
 
 	mutex_lock(&sr_ref_mutex);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 1f5ca7f..9fd6702 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -32,5 +32,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req);
 int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req);
 int scsi_prep_state_check(struct scsi_device *sdev, struct request *req);
 int scsi_prep_return(struct request_queue *q, struct request *req, int ret);
+int scsi_prep_fn(struct request_queue *, struct request *);
 
 #endif /* _SCSI_SCSI_DRIVER_H */


