From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Fri, 23 Jan 2015 10:42:47 -0800
Message-ID: <1422038567.2126.14.camel@HansenPartnership.com>
References: <1421600146.2080.8.camel@HansenPartnership.com>
	 <54BC93C3.7010808@hitachi.com> <878ugzco8c.fsf@rustcorp.com.au>
	 <1421683701.2080.25.camel@HansenPartnership.com>
	 <871tmqcmau.fsf@rustcorp.com.au>
	 <1421774615.2080.88.camel@HansenPartnership.com>
	 <20150122165018.GA27377@infradead.org>
	 <1421946175.2093.1.camel@HansenPartnership.com>
	 <87iofyurzc.fsf@rustcorp.com.au> <20150123131758.GC8045@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150123131758.GC8045@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2015-01-23 at 05:17 -0800, Christoph Hellwig wrote:
> On Fri, Jan 23, 2015 at 01:24:15PM +1030, Rusty Russell wrote:
> > The correct fix is to turn try_module_get() into __module_get(), and
> > always do the module_put().
> 
> Is this really safe?  __module_get sais it needs a non-zero refcount
> to start with, but scsi_device_get is the only thing every incrementing
> the refcount on the module pointer in the scsi host template, so
> exactly that case can happen easily.  There's not assert actually
> hardcoding the assumption, so I'm not sure if requirement the comment
> really just is nice to have or a strong requirement.

The comment was just documenting the old status quo: the
try_module_get() was expected to fail if called within the host module
remove path.  If you look at the flow, we use the refcounts on the
actual scsi device to measure.  If they fail we know we have a problem.
The module stuff is really only slaved to our master refcount on the
device.  It's purpose is to prevent an inopportune rmmod.  Our default
operating state is zero references on everything, so the user can just
do rmmod ... obviously if the device is open or mounted then we hold
both the device and the module.

To that point, Rusty's patch just keeps the status quo in the new
module_refcount() environment, so it's the quick bandaid.

I think the use case you're worrying about is what happens if someone
tries to use a device after module removal begins executing but before
the device has been deleted (say by opening it)?  We'll exit the device
removal routines and then kill the module, because after the module code
gets to ->exit(), nothing re-checks the module refcount, so the host
module will get free'd while we're still using the device.

The fix for this seems to be to differentiate between special uses of
scsi_get_device, which are allowed to get the device in the module exit
routines and ordinary uses which aren't.  Something like this? (the
patch isn't complete, but you get the idea).

James

---

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 08c90a7..31ba254 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -965,6 +965,15 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 }
 EXPORT_SYMBOL(scsi_report_opcode);
 
+static int __scsi_device_get_common(struct scsi_device *sdev)
+{
+	if (sdev->sdev_state == SDEV_DEL)
+		return -ENXIO;
+	if (!get_device(&sdev->sdev_gendev))
+		return -ENXIO;
+	return 0;
+}
+
 /**
  * scsi_device_get  -  get an additional reference to a scsi_device
  * @sdev:	device to get a reference to
@@ -975,19 +984,45 @@ EXPORT_SYMBOL(scsi_report_opcode);
  */
 int scsi_device_get(struct scsi_device *sdev)
 {
-	if (sdev->sdev_state == SDEV_DEL)
-		return -ENXIO;
-	if (!get_device(&sdev->sdev_gendev))
-		return -ENXIO;
-	/* We can fail this if we're doing SCSI operations
-	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	int ret;
 
-	return 0;
+	ret = __scsi_device_get_common(sdev);
+	if (ret)
+		return ret;
+
+	ret = try_module_get(sdev->host->hostt->module);
+
+	if (ret)
+		put_device(&sdev->sdev_gendev);
+
+	return ret;
 }
 EXPORT_SYMBOL(scsi_device_get);
 
 /**
+ * scsi_device_get_in_module_exit() - get an additional reference to a scsi_device
+ * @sdev:	device to get a reference to
+ *
+ * Functions identically to scsi_device_get() except that it unconditionally
+ * gets the module reference.  This allows it to be called from module exit
+ * routines where scsi_device_get() will fail.  This routine is still paired
+ * with scsi_device_put().
+ */
+int scsi_device_get_in_module_exit(struct scsi_device *sdev)
+{
+	int ret;
+
+	ret = __scsi_device_get_common(sdev);
+	if (ret)
+		return ret;
+
+	__module_get(sdev->host->hostt->module);
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_device_get_in_module_exit);
+
+/**
  * scsi_device_put  -  release a reference to a scsi_device
  * @sdev:	device to release a reference on.
  *
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ebf35cb6..057604e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -564,16 +564,22 @@ static int sd_major(int major_idx)
 	}
 }
 
-static struct scsi_disk *__scsi_disk_get(struct gendisk *disk)
+static struct scsi_disk *__scsi_disk_get(struct gendisk *disk, int in_exit)
 {
 	struct scsi_disk *sdkp = NULL;
 
 	if (disk->private_data) {
+		int ret;
+
 		sdkp = scsi_disk(disk);
-		if (scsi_device_get(sdkp->device) == 0)
-			get_device(&sdkp->dev);
+		if (in_exit)
+			ret = scsi_device_get_in_module_exit(sdkp->device);
 		else
+			ret = scsi_device_get(sdkp->device);
+		if (unlikely(ret))
 			sdkp = NULL;
+		else
+			get_device(&sdkp->dev);
 	}
 	return sdkp;
 }
@@ -583,19 +589,19 @@ static struct scsi_disk *scsi_disk_get(struct gendisk *disk)
 	struct scsi_disk *sdkp;
 
 	mutex_lock(&sd_ref_mutex);
-	sdkp = __scsi_disk_get(disk);
+	sdkp = __scsi_disk_get(disk, 0);
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
 
-static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev)
+static struct scsi_disk *scsi_disk_get_from_dev(struct device *dev, int in_exit)
 {
 	struct scsi_disk *sdkp;
 
 	mutex_lock(&sd_ref_mutex);
 	sdkp = dev_get_drvdata(dev);
 	if (sdkp)
-		sdkp = __scsi_disk_get(sdkp->disk);
+		sdkp = __scsi_disk_get(sdkp->disk, in_exit);
 	mutex_unlock(&sd_ref_mutex);
 	return sdkp;
 }
@@ -1525,7 +1531,7 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 
 static void sd_rescan(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
 
 	if (sdkp) {
 		revalidate_disk(sdkp->disk);
@@ -3147,7 +3153,7 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
  */
 static void sd_shutdown(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 1);
 
 	if (!sdkp)
 		return;         /* this can happen */
@@ -3171,7 +3177,7 @@ exit:
 
 static int sd_suspend_common(struct device *dev, bool ignore_stop_errors)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
 	int ret = 0;
 
 	if (!sdkp)
@@ -3213,7 +3219,7 @@ static int sd_suspend_runtime(struct device *dev)
 
 static int sd_resume(struct device *dev)
 {
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
+	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev, 0);
 	int ret = 0;
 
 	if (!sdkp->device->manage_start_stop)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 2e0281e..0bad37c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -327,6 +327,7 @@ extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
 void scsi_attach_vpd(struct scsi_device *sdev);
 
 extern int scsi_device_get(struct scsi_device *);
+extern int scsi_device_get_in_module_exit(struct scsi_device *);
 extern void scsi_device_put(struct scsi_device *);
 extern struct scsi_device *scsi_device_lookup(struct Scsi_Host *,
 					      uint, uint, u64);
