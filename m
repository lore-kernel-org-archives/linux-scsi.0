From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Subject: [PATCH/RFC] SCSI mid-layer suspend/resume
Date: Mon, 24 Oct 2005 16:05:31 -0700
Message-ID: <20051024160531.7d879a7c.randy_d_dunlap@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, axboe@suse.de, jgarzik@pobox.com, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

RFC.

Although Jens's SATA suspend/resume patch works, it seems that the
SCSI maintainer(s) want something different, e.g., Nathan Bryant's
2004 patch[1] with some changes:


Jeff's comments[2]:
- Use START STOP UNIT on suspend & resume (done);
- Issue hardware or software reset on suspend (not done).

Christoph's comments[3][4]:
- some functions should be renamed (done, maybe :);
- some (same) functions should be in scsi_sysfs.c (done);
- drop the CONFIG_PM ifdefs (done);
- way to avoid spinning down (or generically: suspending) external
  disks, such as a sysfs-controllable flag (done at device level);


TBD:
James Smart's comment about limiting number of drive spin-ups[5];
Stefan Richter's comment about which driver decides to support or
  implement suspend/resume[6];
Mark Lord:  where is the GFP_KERNEL usage that you were concerned
  about on resume? [7]

BTW, what does this comment in scsi_sysfs.c refer to when I am
adding an attribute to it?
/* Default template for device attributes.  May NOT be modified */
static struct device_attribute *scsi_sysfs_sdev_attrs[] = {


---
[1] http://lwn.net/Articles/97453/
[2] http://marc.theaimsgroup.com/?l=linux-scsi&m=112797130926411&w=2
[3] http://marc.theaimsgroup.com/?l=linux-scsi&m=112797930421645&w=2
[4] http://marc.theaimsgroup.com/?l=linux-scsi&m=112798153124878&w=2
[5] http://marc.theaimsgroup.com/?l=linux-scsi&m=112800404305403&w=2
[6] http://marc.theaimsgroup.com/?l=linux-scsi&m=112800966123767&w=2
[7] http://marc.theaimsgroup.com/?l=linux-scsi&m=112819108407925&w=2
---


From: Randy Dunlap <randy_d_dunlap@linux.intel.com>

Update Nathan Bryant's SCSI midlayer suspend/resume patch per
email suggestions from Jeff Garzik and Christoph Hellwig.
"suspend" is a device-level flag that controls whether a
device should participate in suspend operations.  Then it's
up to each device driver to determine what that means for
a device.

Signed-off-by: Randy Dunlap <randy_d_dunlap@linux.intel.com>
---
 drivers/scsi/scsi_priv.h   |    2
 drivers/scsi/scsi_sysfs.c  |   63 +++++++++++++++++++++++++-
 drivers/scsi/sd.c          |   82 ++++++++++++++++++++++++++++++++++-
 include/scsi/scsi_device.h |    1
 include/scsi/scsi_driver.h |    2
 5 files changed, 146 insertions(+), 4 deletions(-)

diff -Naurp -X /home/rddunlap/doc/dontdiff linux-2614-rc4-pv/drivers/scsi/scsi_priv.h linux-2614-rc4-scsi/drivers/scsi/scsi_priv.h
--- linux-2614-rc4-pv/drivers/scsi/scsi_priv.h	2005-10-14 09:40:15.000000000 -0700
+++ linux-2614-rc4-scsi/drivers/scsi/scsi_priv.h	2005-10-14 09:38:33.000000000 -0700
@@ -55,6 +55,8 @@ static inline void scsi_log_send(struct 
 static inline void scsi_log_completion(struct scsi_cmnd *cmd, int disposition)
 	{ };
 #endif
+extern int scsi_device_suspend(struct device *dev, pm_message_t state);
+extern int scsi_device_wakeup(struct device *dev);
 
 /* scsi_devinfo.c */
 extern int scsi_get_device_flags(struct scsi_device *sdev,
diff -Naurp -X /home/rddunlap/doc/dontdiff linux-2614-rc4-pv/drivers/scsi/scsi_sysfs.c linux-2614-rc4-scsi/drivers/scsi/scsi_sysfs.c
--- linux-2614-rc4-pv/drivers/scsi/scsi_sysfs.c	2005-10-14 09:40:15.000000000 -0700
+++ linux-2614-rc4-scsi/drivers/scsi/scsi_sysfs.c	2005-10-19 16:59:10.000000000 -0700
@@ -14,6 +14,7 @@
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_driver.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport.h>
@@ -264,8 +265,10 @@ static int scsi_bus_match(struct device 
 }
 
 struct bus_type scsi_bus_type = {
-        .name		= "scsi",
-        .match		= scsi_bus_match,
+	.name		= "scsi",
+	.match		= scsi_bus_match,
+	.suspend	= scsi_device_suspend,
+	.resume		= scsi_device_wakeup,
 };
 
 int scsi_sysfs_register(void)
@@ -401,6 +404,28 @@ sdev_store_timeout (struct device *dev, 
 static DEVICE_ATTR(timeout, S_IRUGO | S_IWUSR, sdev_show_timeout, sdev_store_timeout);
 
 static ssize_t
+sdev_show_suspend(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	return snprintf (buf, 5, "%d\n", sdev->suspend);
+}
+
+static ssize_t
+sdev_store_suspend(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	unsigned char suspend;
+
+	sscanf(buf, "%hhd\n", &suspend);
+	sdev->suspend = !!suspend;
+	return count;
+}
+static DEVICE_ATTR(suspend, S_IRUGO | S_IWUSR,
+	sdev_show_suspend, sdev_store_suspend);
+
+static ssize_t
 store_rescan_field (struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	scsi_rescan_device(dev);
@@ -506,6 +531,7 @@ static struct device_attribute *scsi_sys
 	&dev_attr_delete,
 	&dev_attr_state,
 	&dev_attr_timeout,
+	&dev_attr_suspend,
 	&dev_attr_iocounterbits,
 	&dev_attr_iorequest_cnt,
 	&dev_attr_iodone_cnt,
@@ -584,7 +610,6 @@ static struct device_attribute *attr_cha
 	return attr;
 }
 
-
 static struct device_attribute *attr_overridden(
 		struct device_attribute **attrs,
 		struct device_attribute *attr)
@@ -770,6 +795,38 @@ void scsi_remove_target(struct device *d
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
+int scsi_device_suspend(struct device *dev, pm_message_t state)
+{
+	int err;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+	err = scsi_device_quiesce(sdev);
+	if (err)
+		return err;
+
+	if (drv->suspend)
+		return drv->suspend(dev, state);
+
+	return 0;
+}
+
+int scsi_device_wakeup(struct device *dev)
+{
+	int err;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_driver *drv = to_scsi_driver(dev->driver);
+
+	if (drv->resume) {
+		err = drv->resume(dev);
+		if (err)
+			return err;
+	}
+
+	scsi_device_resume(sdev);
+	return 0;
+}
+
 int scsi_register_driver(struct device_driver *drv)
 {
 	drv->bus = &scsi_bus_type;
diff -Naurp -X /home/rddunlap/doc/dontdiff linux-2614-rc4-pv/drivers/scsi/sd.c linux-2614-rc4-scsi/drivers/scsi/sd.c
--- linux-2614-rc4-pv/drivers/scsi/sd.c	2005-10-14 09:40:15.000000000 -0700
+++ linux-2614-rc4-scsi/drivers/scsi/sd.c	2005-10-14 09:38:33.000000000 -0700
@@ -117,6 +117,8 @@ static void sd_rw_intr(struct scsi_cmnd 
 
 static int sd_probe(struct device *);
 static int sd_remove(struct device *);
+static int sd_suspend(struct device *, pm_message_t);
+static int sd_resume(struct device *);
 static void sd_shutdown(struct device *dev);
 static void sd_rescan(struct device *);
 static int sd_init_command(struct scsi_cmnd *);
@@ -136,6 +138,8 @@ static struct scsi_driver sd_template = 
 	},
 	.rescan			= sd_rescan,
 	.init_command		= sd_init_command,
+	.suspend		= sd_suspend,
+	.resume			= sd_resume,
 	.issue_flush		= sd_issue_flush,
 	.prepare_flush		= sd_prepare_flush,
 	.end_flush		= sd_end_flush,
@@ -1691,7 +1695,83 @@ static void sd_shutdown(struct device *d
 	printk(KERN_NOTICE "Synchronizing SCSI cache for disk %s: \n",
 			sdkp->disk->disk_name);
 	sd_sync_cache(sdp);
-}	
+}
+
+static int sd_suspend(struct device *dev, pm_message_t state)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	int retries, res;
+	struct scsi_sense_hdr sshdr;
+	unsigned char cmd[10] = { 0 };
+
+	sd_shutdown(dev);
+
+	/* stop the drive */
+	for (retries = 3; retries > 0; --retries) {
+		cmd[0] = START_STOP;
+		cmd[4] = 0;
+		res = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
+				       SD_TIMEOUT, SD_MAX_RETRIES);
+		if (res == 0)
+			break;
+	}
+
+	if (res) {
+		printk(KERN_WARNING "STOP UNIT FAILED\n"
+				    "  status = %x, message = %02x, "
+				    "host = %d, driver = %02x\n  ",
+				    status_byte(res), msg_byte(res),
+				    host_byte(res), driver_byte(res));
+		if (driver_byte(res) & DRIVER_SENSE)
+			scsi_print_sense_hdr("sd", &sshdr);
+		else
+			printk("%s: sense not available.\n",
+				sdkp->disk->disk_name);
+		/* TBD: is this a suspend error? */
+	}
+
+	/* TBD: do hardware or software reset on suspend */
+
+	return 0;
+}
+
+static int sd_resume(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	struct scsi_disk *sdkp = dev_get_drvdata(dev);
+	int retries, res;
+	struct scsi_sense_hdr sshdr;
+	unsigned char cmd[10] = { 0 };
+
+	sd_rescan(dev);
+
+	/* start the drive */
+	for (retries = 3; retries > 0; --retries) {
+		cmd[0] = START_STOP;
+		cmd[4] = 1;
+		res = scsi_execute_req(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
+				       SD_TIMEOUT, SD_MAX_RETRIES);
+		if (res == 0)
+			break;
+	}
+
+	if (res) {
+		printk(KERN_WARNING "START UNIT FAILED\n"
+				    "  status = %x, message = %02x, "
+				    "host = %d, driver = %02x\n  ",
+				    status_byte(res), msg_byte(res),
+				    host_byte(res), driver_byte(res));
+		if (driver_byte(res) & DRIVER_SENSE)
+			scsi_print_sense_hdr("sd", &sshdr);
+		else
+			printk("%s: sense not available.\n",
+				sdkp->disk->disk_name);
+		/* TBD: is this a resume error? */
+	}
+
+	return 0;
+}
 
 /**
  *	init_sd - entry point for this driver (both when built in or when
diff -Naurp -X /home/rddunlap/doc/dontdiff linux-2614-rc4-pv/include/scsi/scsi_device.h linux-2614-rc4-scsi/include/scsi/scsi_device.h
--- linux-2614-rc4-pv/include/scsi/scsi_device.h	2005-10-14 09:40:16.000000000 -0700
+++ linux-2614-rc4-scsi/include/scsi/scsi_device.h	2005-10-19 16:24:57.000000000 -0700
@@ -83,6 +83,7 @@ struct scsi_device {
 	char * model;		/* ... after scan; point to static string */
 	char * rev;		/* ... "nullnullnullnull" before scan */
 	unsigned char current_tag;	/* current tag */
+	unsigned char suspend;	/* ok to participate in suspend/resume */
 	struct scsi_target      *sdev_target;   /* used only for single_lun */
 
 	unsigned int	sdev_bflags; /* black/white flags as also found in
diff -Naurp -X /home/rddunlap/doc/dontdiff linux-2614-rc4-pv/include/scsi/scsi_driver.h linux-2614-rc4-scsi/include/scsi/scsi_driver.h
--- linux-2614-rc4-pv/include/scsi/scsi_driver.h	2005-08-28 16:41:01.000000000 -0700
+++ linux-2614-rc4-scsi/include/scsi/scsi_driver.h	2005-10-14 09:38:33.000000000 -0700
@@ -13,6 +13,8 @@ struct scsi_driver {
 
 	int (*init_command)(struct scsi_cmnd *);
 	void (*rescan)(struct device *);
+	int (*suspend)(struct device *dev, pm_message_t state);
+	int (*resume)(struct device *dev);
 	int (*issue_flush)(struct device *, sector_t *);
 	int (*prepare_flush)(struct request_queue *, struct request *);
 	void (*end_flush)(struct request_queue *, struct request *);

