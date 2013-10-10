From: scameron@beardog.cce.hp.com
Subject: Re: [PATCH 07/10] hpsa: hide logical drives with format in progress from linux
Date: Thu, 10 Oct 2013 11:25:56 -0500
Message-ID: <20131010162556.GJ5097@beardog.cce.hp.com>
References: <20130923183128.19995.7669.stgit@beardog.cce.hp.com> <20130923183401.19995.99662.stgit@beardog.cce.hp.com> <5245868B.4080900@redhat.com> <20130927133451.GY31476@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:46280 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3JJQ0B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Oct 2013 12:26:01 -0400
Content-Disposition: inline
In-Reply-To: <20130927133451.GY31476@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: james.bottomley@hansenpartnership.com, stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, linux-scsi@vger.kernel.org, scott.teel@hp.com, scameron@beardog.cce.hp.com

On Fri, Sep 27, 2013 at 08:34:51AM -0500, scameron@beardog.cce.hp.com wrote:
> On Fri, Sep 27, 2013 at 03:22:19PM +0200, Tomas Henzl wrote:
> > On 09/23/2013 08:34 PM, Stephen M. Cameron wrote:
> > > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > >
> > > SCSI mid layer doesn't seem to handle logical drives undergoing format
> > > very well.  scsi_add_device on such devices seems to result in hitting
> > > those devices with a TUR at a rate of 3Hz for awhile, transitioning
> > > to hitting them with a READ(10) at a much higher rate indefinitely,
> > > and at boot time, this prevents the system from coming up.  If we
> > > do not expose such devices to the kernel, it isn't bothered by them.
> > 
> > Is the result of this patch that the drive is no more visible for the user
> > and he can't follow the formatting progress? 
> 
> Yes (subsequent patch monitors the progress and brings the drive
> online when it's ready).
> 
> > I think a better option is to fix the kernel to handle formatting devices better
> 
> Yeah, you're probably right. (This is what comes of writing code for all
> the distros then forward porting to kernel.org code.  Grumble-grumble-management
> grumble-grumble real-world problems.)

[...]

So I took a stab at modifying sd (below) which I am now thinking may not
be the right approach.  Empirically, it seems to work, but there are a 
couple of things not quite right.

The gist of the patch is, when sd_spinup_device encounters a scsi disk which
is NOT READY/FORMAT IN PROGRESS, it adds it to a list, and starts up a
thread to monitor the list (if one isn't already running).  The thread
periodically polls the disks until they become ready, and revalidates them
and removes them from the list when they become ready.  When the list is
empty the thread exits.  There are a lot of complicated locking and
get_device/put_device reference counting to make sure various rugs don't
get ripped out from under the thread.

One problematic area is on rmmod of sd.  It's using kthread_stop() to stop
the thread, but what if the thread's already gone?  I didn't figure out
how to get around that, and came to the conclusion that having the thread
sometimes decide when to exit on it's own, and having it sometimes be told
to exit on rmmod of sd probably can't work (although that is exactly what
I would like to do.)  So, hmm, not satisfactory.

But then I started thinking that maybe I'm approaching it all wrong.  Maybe
this should be done (mostly) from userspace.  Maybe some small change to sd
just to keep it from waiting around too long for disks that are in 
NOT READY/FORMAT IN PROGRESS state, and some change to udevd(?) or udev
rules... or something udev-ey? so that it can notice when a device that is
in this state has been added to the system and launch a userspace daemon to
poll the device with TURs via SG_IO and when it becomes ready, trigger the
revalidation from userspace.  That would probably be better than what I've
done below.

But, I'm not really sure where to start to get something like that rolling,
presuming doing something like that would be a better approach.

-- steve


commit 6b4265426c8aff03e4c28372409a3f1c2c760c28
Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date:   Wed Oct 9 19:03:46 2013 -0500

    scsi: improve probing of disks that are temporarily offline
    
    The current handling of disks which are NOT READY/FORMAT
    IN PROGRESS is not ideal.  Instead of waiting for a period of time
    for the disk to become ready and then giving up in sd_spinup_disk(),
    we can create a thread to wait for a list of disks which are
    expected to eventually become ready which periodically polls such
    disks and revalidates them when they become ready.  When the list
    of not-ready disks becomes empty, the thread will exit.  This allows
    other things to proceed, for example, allowing the system to boot
    without a the usual delay that is mostly futile since the odds
    are good that a format in progress won't finish during the time
    that sd_spinup_disk would have waited.
    

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e62d17d..3158780 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -51,6 +51,7 @@
 #include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/kthread.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 
@@ -126,6 +127,19 @@ static DEFINE_MUTEX(sd_ref_mutex);
 static struct kmem_cache *sd_cdb_cache;
 static mempool_t *sd_cdb_pool;
 
+static DEFINE_SPINLOCK(sd_revalidation_lock);
+struct sd_deferred_disk_list_entry {
+	struct scsi_disk *sdkp;
+	struct list_head deferred_list;
+};
+static struct list_head sd_deferred_disk_list =
+		LIST_HEAD_INIT(sd_deferred_disk_list);
+#define REVALIDATION_THREAD_STOPPED 0
+#define REVALIDATION_THREAD_RUNNING 1
+#define REVALIDATION_THREAD_STOPPING 2
+static int sd_revalidation_thread_state;
+static struct task_struct *sd_revalidation_thread;
+
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
@@ -1733,8 +1747,11 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 
 /*
  * spinup disk - called only in sd_revalidate_disk()
+ * Returns 1 if disk is not ready and revalidation
+ * should be deferred due to e.g., format in progress,
+ * 0 otherwise.
  */
-static void
+static int
 sd_spinup_disk(struct scsi_disk *sdkp)
 {
 	unsigned char cmd[10];
@@ -1743,6 +1760,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	unsigned int the_result;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
+	int defer_revalidation = 0;
 
 	spintime = 0;
 
@@ -1766,7 +1784,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			 * with any more polling.
 			 */
 			if (media_not_present(sdkp, &sshdr))
-				return;
+				return 0;
 
 			if (the_result)
 				sense_valid = scsi_sense_valid(&sshdr);
@@ -1799,6 +1817,13 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				break;	/* standby */
 			if (sshdr.asc == 4 && sshdr.ascq == 0xc)
 				break;	/* unavailable */
+			if (sshdr.asc == 4 && sshdr.ascq == 4) {
+				/* Format in progress.  This may take a long
+				 * time.  Defer revalidation until later.
+				 */
+				defer_revalidation = 1;
+				break;
+			}
 			/*
 			 * Issue command to spin up drive when not ready
 			 */
@@ -1853,6 +1878,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 		else
 			printk("not responding...\n");
 	}
+	return defer_revalidation;
 }
 
 
@@ -2668,6 +2694,144 @@ static int sd_try_extended_inquiry(struct scsi_device *sdp)
 	return 0;
 }
 
+static int sd_device_temporarily_offline(struct scsi_disk *sdkp)
+{
+	unsigned char cmd[10];
+	unsigned int the_result;
+	struct scsi_sense_hdr sshdr;
+
+	cmd[0] = TEST_UNIT_READY;
+	memset((void *) &cmd[1], 0, 9);
+
+	the_result = scsi_execute_req(sdkp->device, cmd,
+				      DMA_NONE, NULL, 0,
+				      &sshdr, SD_TIMEOUT,
+				      SD_MAX_RETRIES, NULL);
+	if (media_not_present(sdkp, &sshdr))
+		return 0;
+	return (the_result && scsi_sense_valid(&sshdr) &&
+		sshdr.sense_key == NOT_READY &&
+		sshdr.asc == 4 && sshdr.ascq == 4);
+}
+
+#define SD_OFFLINE_DEVICE_POLL_TIME (100 * HZ)
+static int sd_deferred_revalidation_thread(void *v)
+{
+	struct sd_deferred_disk_list_entry *d;
+	unsigned long flags;
+	struct list_head revalidate_list, *this, *tmp;
+	int temp_offline;
+
+	INIT_LIST_HEAD(&revalidate_list);
+	spin_lock_irqsave(&sd_revalidation_lock, flags);
+	while (!list_empty(&sd_deferred_disk_list) && !kthread_should_stop()) {
+		/* Check if any of the offline devices have become ready */
+		list_for_each_safe(this, tmp, &sd_deferred_disk_list) {
+			d = list_entry(this, struct sd_deferred_disk_list_entry,
+					deferred_list);
+			get_device(&d->sdkp->dev);
+			spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+			temp_offline = sd_device_temporarily_offline(d->sdkp);
+			spin_lock_irqsave(&sd_revalidation_lock, flags);
+			if (!temp_offline) {
+				list_del(this);
+				list_add(&d->deferred_list, &revalidate_list);
+			} else {
+				put_device(&d->sdkp->dev);
+			}
+		}
+		spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+		list_for_each_safe(this, tmp, &revalidate_list) {
+			d = list_entry(this, struct sd_deferred_disk_list_entry,
+					deferred_list);
+			list_del(this);
+			revalidate_disk(d->sdkp->disk);
+			put_device(&d->sdkp->dev);
+			kfree(d);
+		}
+		schedule_timeout_uninterruptible(SD_OFFLINE_DEVICE_POLL_TIME);
+		spin_lock_irqsave(&sd_revalidation_lock, flags);
+	}
+	sd_revalidation_thread_state = REVALIDATION_THREAD_STOPPED;
+	spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+	return 0;
+}
+
+static void sd_stop_deferred_revalidation_thread(void)
+{
+	unsigned long flags;
+	int stop_thread;
+
+	spin_lock_irqsave(&sd_revalidation_lock, flags);
+	stop_thread = (sd_revalidation_thread_state ==
+				REVALIDATION_THREAD_RUNNING);
+	if (stop_thread)
+		/* STOPPING state prevents new thread from starting. */
+		sd_revalidation_thread_state = REVALIDATION_THREAD_STOPPING;
+	spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+	if (stop_thread)
+		kthread_stop(sd_revalidation_thread);
+}
+
+static void sd_remove_deferred_revalidation(struct scsi_disk *sdkp)
+{
+	struct list_head *this, *tmp;
+	struct sd_deferred_disk_list_entry *d = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sd_revalidation_lock, flags);
+	list_for_each_safe(this, tmp, &sd_deferred_disk_list) {
+		d = list_entry(this, struct sd_deferred_disk_list_entry,
+					deferred_list);
+		if (d->sdkp == sdkp) {
+			list_del(this);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+	kfree(d);
+}
+
+static void sd_schedule_revalidation(struct scsi_disk *sdkp)
+{
+	struct sd_deferred_disk_list_entry *d, *entry;
+	unsigned long flags;
+
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d) {
+		sd_printk(KERN_WARNING, sdkp,
+			"sd_schedule_revalidation: Memory allocation failure.\n");
+		return;
+	}
+	d->sdkp = sdkp;
+	spin_lock_irqsave(&sd_revalidation_lock, flags);
+
+	/* Only add the device if it is not already in the list */
+	list_for_each_entry(entry, &sd_deferred_disk_list, deferred_list) {
+		if (entry->sdkp == sdkp) {
+			spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+			kfree(d);
+			return;
+		}
+	}
+
+	list_add(&d->deferred_list, &sd_deferred_disk_list);
+	if (sd_revalidation_thread_state == REVALIDATION_THREAD_STOPPED) {
+		sd_revalidation_thread_state = REVALIDATION_THREAD_RUNNING;
+		spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+		sd_revalidation_thread =
+			kthread_run(sd_deferred_revalidation_thread, NULL,
+					"sd-deferred-revalidation");
+		spin_lock_irqsave(&sd_revalidation_lock, flags);
+	}
+	if (!sd_revalidation_thread) {
+		sd_revalidation_thread_state = REVALIDATION_THREAD_STOPPED;
+		sd_printk(KERN_WARNING, sdkp,
+			"sd_schedule_revalidation: Failed to start deferred revalidation thread\n");
+	}
+	spin_unlock_irqrestore(&sd_revalidation_lock, flags);
+}
+
 /**
  *	sd_revalidate_disk - called the first time a new disk is seen,
  *	performs disk spin up, read_capacity, etc.
@@ -2679,6 +2843,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	struct scsi_device *sdp = sdkp->device;
 	unsigned char *buffer;
 	unsigned flush = 0;
+	int defer_revalidation;
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
 				      "sd_revalidate_disk\n"));
@@ -2697,13 +2862,13 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		goto out;
 	}
 
-	sd_spinup_disk(sdkp);
+	defer_revalidation = sd_spinup_disk(sdkp);
 
 	/*
 	 * Without media there is no reason to ask; moreover, some devices
 	 * react badly if we do.
 	 */
-	if (sdkp->media_present) {
+	if (sdkp->media_present && !defer_revalidation) {
 		sd_read_capacity(sdkp, buffer);
 
 		if (sd_try_extended_inquiry(sdp)) {
@@ -2718,7 +2883,8 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_write_same(sdkp, buffer);
 	}
 
-	sdkp->first_scan = 0;
+	if (!defer_revalidation)
+		sdkp->first_scan = 0;
 
 	/*
 	 * We now have all cache related info, determine how we deal
@@ -2736,6 +2902,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	sd_config_write_same(sdkp);
 	kfree(buffer);
 
+	if (defer_revalidation)
+		sd_schedule_revalidation(sdkp);
+
  out:
 	return 0;
 }
@@ -2990,6 +3159,7 @@ static int sd_remove(struct device *dev)
 
 	sdkp = dev_get_drvdata(dev);
 	devt = disk_devt(sdkp->disk);
+	sd_remove_deferred_revalidation(sdkp);
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_probe_domain);
@@ -3204,6 +3374,7 @@ static void __exit exit_sd(void)
 
 	SCSI_LOG_HLQUEUE(3, printk("exit_sd: exiting sd driver\n"));
 
+	sd_stop_deferred_revalidation_thread();
 	scsi_unregister_driver(&sd_template.gendrv);
 	mempool_destroy(sd_cdb_pool);
 	kmem_cache_destroy(sd_cdb_cache);

