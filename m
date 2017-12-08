From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] sd: Increase SCSI disk probing concurrency
Date: Fri,  8 Dec 2017 09:21:24 -0800
Message-ID: <20171208172124.32685-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:54174 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750865AbdLHRVZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Dec 2017 12:21:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

The scsi_sd_probe_domain allows to wait until all disk-probing
activity has finished system-wide. This slows down SCSI host removal
that occurs concurrently with SCSI disk probing because sd_remove()
waits on scsi_sd_probe_domain. Additionally, since each function that
waits on scsi_sd_probe_domain specifies for which disk to wait until
probing has finished, replace waiting on scsi_sd_probe_domain by
waiting until probing for a specific disk has finished. Introduce a
.sync() function pointer in struct scsi_driver to make it possible
for the SCSI power management code to wait until probing of a
specific disk has finished.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi.c        |  5 -----
 drivers/scsi/scsi_pm.c     |  6 ++++--
 drivers/scsi/scsi_priv.h   |  1 -
 drivers/scsi/sd.c          | 26 +++++++++++++++++++++-----
 drivers/scsi/sd.h          |  1 +
 include/scsi/scsi_driver.h |  1 +
 6 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a7e4fba724b7..e6d69e647f6a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -85,10 +85,6 @@ unsigned int scsi_logging_level;
 EXPORT_SYMBOL(scsi_logging_level);
 #endif
 
-/* sd, scsi core and power management need to coordinate flushing async actions */
-ASYNC_DOMAIN(scsi_sd_probe_domain);
-EXPORT_SYMBOL(scsi_sd_probe_domain);
-
 /*
  * Separate domain (from scsi_sd_probe_domain) to maximize the benefit of
  * asynchronous system resume operations.  It is marked 'exclusive' to avoid
@@ -839,7 +835,6 @@ static void __exit exit_scsi(void)
 	scsi_exit_devinfo();
 	scsi_exit_procfs();
 	scsi_exit_queue();
-	async_unregister_domain(&scsi_sd_probe_domain);
 }
 
 subsys_initcall(init_scsi);
diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index b44c1bb687a2..d8e43c2f4d40 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -171,9 +171,11 @@ static int scsi_bus_resume_common(struct device *dev,
 static int scsi_bus_prepare(struct device *dev)
 {
 	if (scsi_is_sdev_device(dev)) {
-		/* sd probing uses async_schedule.  Wait until it finishes. */
-		async_synchronize_full_domain(&scsi_sd_probe_domain);
+		struct scsi_driver *drv = to_scsi_driver(dev->driver);
 
+		/* sd probing happens asynchronously. Wait until it finishes. */
+		if (drv->sync)
+			drv->sync(dev);
 	} else if (scsi_is_host_device(dev)) {
 		/* Wait until async scanning is finished */
 		scsi_complete_async_scans();
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 99f1db5e467e..0d88f6b85f5b 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -176,7 +176,6 @@ static inline void scsi_autopm_put_host(struct Scsi_Host *h) {}
 #endif /* CONFIG_PM */
 
 extern struct async_domain scsi_sd_pm_domain;
-extern struct async_domain scsi_sd_probe_domain;
 
 /* scsi_dh.c */
 #ifdef CONFIG_SCSI_DH
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab75ebd518a7..53ec383e10d1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -112,6 +112,7 @@ static void sd_shutdown(struct device *);
 static int sd_suspend_system(struct device *);
 static int sd_suspend_runtime(struct device *);
 static int sd_resume(struct device *);
+static void sd_sync_probe_domain(struct device *dev);
 static void sd_rescan(struct device *);
 static int sd_init_command(struct scsi_cmnd *SCpnt);
 static void sd_uninit_command(struct scsi_cmnd *SCpnt);
@@ -564,6 +565,7 @@ static struct scsi_driver sd_template = {
 		.shutdown	= sd_shutdown,
 		.pm		= &sd_pm_ops,
 	},
+	.sync			= sd_sync_probe_domain,
 	.rescan			= sd_rescan,
 	.init_command		= sd_init_command,
 	.uninit_command		= sd_uninit_command,
@@ -3254,9 +3256,9 @@ static int sd_format_disk_name(char *prefix, int index, char *buf, int buflen)
 /*
  * The asynchronous part of sd_probe
  */
-static void sd_probe_async(void *data, async_cookie_t cookie)
+static void sd_probe_async(struct work_struct *work)
 {
-	struct scsi_disk *sdkp = data;
+	struct scsi_disk *sdkp = container_of(work, typeof(*sdkp), probe_work);
 	struct scsi_device *sdp;
 	struct gendisk *gd;
 	u32 index;
@@ -3359,6 +3361,8 @@ static int sd_probe(struct device *dev)
 	if (!sdkp)
 		goto out;
 
+	INIT_WORK(&sdkp->probe_work, sd_probe_async);
+
 	gd = alloc_disk(SD_MINORS);
 	if (!gd)
 		goto out_free;
@@ -3410,8 +3414,8 @@ static int sd_probe(struct device *dev)
 	get_device(dev);
 	dev_set_drvdata(dev, sdkp);
 
-	get_device(&sdkp->dev);	/* prevent release before async_schedule */
-	async_schedule_domain(sd_probe_async, sdkp, &scsi_sd_probe_domain);
+	get_device(&sdkp->dev);	/* prevent release before sd_probe_async() */
+	WARN_ON_ONCE(!queue_work(system_unbound_wq, &sdkp->probe_work));
 
 	return 0;
 
@@ -3428,6 +3432,18 @@ static int sd_probe(struct device *dev)
 	return error;
 }
 
+static void sd_wait_for_probing(struct scsi_disk *sdkp)
+{
+	flush_work(&sdkp->probe_work);
+}
+
+static void sd_sync_probe_domain(struct device *dev)
+{
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+
+	sd_wait_for_probing(sdkp);
+}
+
 /**
  *	sd_remove - called whenever a scsi disk (previously recognized by
  *	sd_probe) is detached from the system. It is called (potentially
@@ -3449,7 +3465,7 @@ static int sd_remove(struct device *dev)
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_pm_domain);
-	async_synchronize_full_domain(&scsi_sd_probe_domain);
+	sd_wait_for_probing(sdkp);
 	device_del(&sdkp->dev);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 320de758323e..215abf374b7f 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -82,6 +82,7 @@ struct scsi_disk {
 	unsigned int	zones_optimal_nonseq;
 	unsigned int	zones_max_open;
 #endif
+	struct work_struct probe_work;
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
 	u32		max_xfer_blocks;
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index fae8b465233e..78173b6d305a 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -12,6 +12,7 @@ struct scsi_device;
 struct scsi_driver {
 	struct device_driver	gendrv;
 
+	void (*sync)(struct device *);
 	void (*rescan)(struct device *);
 	int (*init_command)(struct scsi_cmnd *);
 	void (*uninit_command)(struct scsi_cmnd *);
-- 
2.15.1
