From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] sd: implement stop_on_shutdown
Date: Sat, 20 Jan 2007 02:01:22 +0900
Message-ID: <20070119170122.GS10987@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, hmh@hmh.eng.br
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

sd doesn't stop (unload head) on shutdown.  This behavior is necessary
for multi initiator cases.  Unloading head by powering off stresses
the drive and sometimes produces distinct clunking noise which
apparently disturbs users considering multiple reports on different
distributions.  halt(8) usually puts the drives to sleep prior to
shutdown but the implementation is fragile and it doesn't work with
sleep-to-disk.

This patch implements sd attribute stop_on_shutdown.  If set to 1, sd
stops the drive on non-restarting shutdown.  stop_on_shutdown is
initialized from sd parameter stop_on_shutdown_default which defaults
to 0.  So, this patch does not change the default behavior.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 978bfc1..f21e5fe 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -90,6 +90,12 @@ MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK13_MAJOR);
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK14_MAJOR);
 MODULE_ALIAS_BLOCKDEV_MAJOR(SCSI_DISK15_MAJOR);
 
+static int sd_stop_on_shutdown_dfl = 0;
+module_param_named(stop_on_shutdown_default, sd_stop_on_shutdown_dfl,
+		   bool, 0644);
+MODULE_PARM_DESC(stop_on_shutdown_default, "Default setting for stopping "
+		 "disk on shutdown (0=disable, 1=enable)");
+
 /*
  * This is limited by the naming scheme enforced in sd_probe,
  * add another character to it if you really need more disks.
@@ -126,6 +132,7 @@ struct scsi_disk {
 	unsigned	WCE : 1;	/* state of disk WCE bit */
 	unsigned	RCD : 1;	/* state of disk RCD bit, unused */
 	unsigned	DPOFUA : 1;	/* state of disk DPOFUA bit */
+	unsigned	stop_on_shutdown : 1; /* stop on device shutdown */
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,cdev)
 
@@ -207,6 +214,19 @@ static ssize_t sd_store_cache_type(struct class_device *cdev, const char *buf,
 	return count;
 }
 
+static ssize_t sd_store_stop_on_shutdown(struct class_device *cdev,
+					 const char *buf, size_t count)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	sdkp->stop_on_shutdown = simple_strtoul(buf, NULL, 10);
+
+	return count;
+}
+
 static ssize_t sd_store_allow_restart(struct class_device *cdev, const char *buf,
 				      size_t count)
 {
@@ -239,6 +259,13 @@ static ssize_t sd_show_fua(struct class_device *cdev, char *buf)
 	return snprintf(buf, 20, "%u\n", sdkp->DPOFUA);
 }
 
+static ssize_t sd_show_stop_on_shutdown(struct class_device *cdev, char *buf)
+{
+	struct scsi_disk *sdkp = to_scsi_disk(cdev);
+
+	return snprintf(buf, 20, "%u\n", sdkp->stop_on_shutdown);
+}
+
 static ssize_t sd_show_allow_restart(struct class_device *cdev, char *buf)
 {
 	struct scsi_disk *sdkp = to_scsi_disk(cdev);
@@ -252,6 +279,8 @@ static struct class_device_attribute sd_disk_attrs[] = {
 	__ATTR(FUA, S_IRUGO, sd_show_fua, NULL),
 	__ATTR(allow_restart, S_IRUGO|S_IWUSR, sd_show_allow_restart,
 	       sd_store_allow_restart),
+	__ATTR(stop_on_shutdown, S_IRUGO|S_IWUSR, sd_show_stop_on_shutdown,
+	       sd_store_stop_on_shutdown),
 	__ATTR_NULL,
 };
 
@@ -1662,6 +1691,7 @@ static int sd_probe(struct device *dev)
 	sdkp->disk = gd;
 	sdkp->index = index;
 	sdkp->openers = 0;
+	sdkp->stop_on_shutdown = sd_stop_on_shutdown_dfl;
 
 	if (!sdp->timeout) {
 		if (sdp->type != TYPE_MOD)
@@ -1766,6 +1796,29 @@ static void scsi_disk_release(struct class_device *cdev)
 	kfree(sdkp);
 }
 
+static int sd_stop_device(struct scsi_device *sdp)
+{
+	unsigned char cmd[6] = { START_STOP }; /* START_VALID and START == 0 */
+	struct scsi_sense_hdr sshdr;
+	int res;
+
+	if (!scsi_device_online(sdp))
+		return -ENODEV;
+
+	res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+			       SD_TIMEOUT, SD_MAX_RETRIES);
+	if (res) {
+		printk(KERN_WARNING "FAILED\n  status = %x, message = %02x, "
+		       "host = %d, driver = %02x\n  ",
+		       status_byte(res), msg_byte(res),
+		       host_byte(res), driver_byte(res));
+		if (driver_byte(res) & DRIVER_SENSE)
+			scsi_print_sense_hdr("sd", &sshdr);
+	}
+
+	return res;
+}
+
 /*
  * Send a SYNCHRONIZE CACHE instruction down to the device through
  * the normal SCSI command structure.  Wait for the command to
@@ -1784,6 +1837,13 @@ static void sd_shutdown(struct device *dev)
 				sdkp->disk->disk_name);
 		sd_sync_cache(sdp);
 	}
+
+	if (system_state != SYSTEM_RESTART && sdkp->stop_on_shutdown) {
+ 		printk(KERN_NOTICE "Stopping disk %s: \n",
+		       sdkp->disk->disk_name);
+		sd_stop_device(sdp);
+	}
+
 	scsi_disk_put(sdkp);
 }
 
