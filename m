From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Driver 'sd' needs updating
Date: Thu, 18 Jun 2009 09:57:18 +0200
Message-ID: <20090618075718.A768ED381D@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54278 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756080AbZFRH5R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 03:57:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


If a SCSI ULD driver sets blk_queue_prep_rq(), it should clean it
up itself on remove(), and not from the bus callbacks. This
removes the need to hook into bus->remove(), which should not
be used at the same time as driver->remove().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/scsi/scsi_lib.c    |    1 +
 drivers/scsi/scsi_priv.h   |    1 -
 drivers/scsi/scsi_sysfs.c  |   17 -----------------
 drivers/scsi/sd.c          |    1 +
 drivers/scsi/sr.c          |    1 +
 include/scsi/scsi_driver.h |    1 +
 6 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 30f3275..f3c4089 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1207,6 +1207,7 @@ int scsi_prep_fn(struct request_queue *q, struct request *req)
 		ret = scsi_setup_blk_pc_cmnd(sdev, req);
 	return scsi_prep_return(q, req, ret);
 }
+EXPORT_SYMBOL(scsi_prep_fn);
 
 /*
  * scsi_dev_queue_ready: if we can send requests to sdev, return 1 else
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index fbc83be..1ade801 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -71,7 +71,6 @@ extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
 struct request_queue;
 struct request;
-extern int scsi_prep_fn(struct request_queue *, struct request *);
 extern struct kmem_cache *scsi_sdb_cache;
 
 /* scsi_proc.c */
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index fa4711d..91482f2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -420,29 +420,12 @@ static int scsi_bus_resume(struct device * dev)
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
 EXPORT_SYMBOL_GPL(scsi_bus_type);
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 878b17a..93c4bed 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2053,6 +2053,7 @@ static int sd_remove(struct device *dev)
 	struct scsi_disk *sdkp;
 
 	async_synchronize_full();
+	blk_queue_prep_rq(sdkp->device->request_queue, scsi_prep_fn);
 	sdkp = dev_get_drvdata(dev);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index cd350df..cce0fe4 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -881,6 +881,7 @@ static int sr_remove(struct device *dev)
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
-- 
1.5.3.2

