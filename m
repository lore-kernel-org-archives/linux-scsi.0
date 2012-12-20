From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Thu, 20 Dec 2012 14:07:25 +0800
Message-ID: <50D2AB1D.9050602@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <35648985.61QNrr0Knq@vostro.rjw.lan> <1353906191.2523.25.camel@dabdike> <21511277.LLinyDpbAK@vostro.rjw.lan> <20121128013928.GB15971@htj.dyndns.org> <1354092969.2276.49.camel@dabdike> <20121203081321.GA9990@mint-spring.sh.intel.com> <1354523143.2307.2.camel@dabdike.int.hansenpartnership.com> <20121203162323.GB19802@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20121203162323.GB19802@htj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

On 12/04/2012 12:23 AM, Tejun Heo wrote:
> Hello, James.
> 
> On Mon, Dec 03, 2012 at 08:25:43AM +0000, James Bottomley wrote:
>>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>>> index e65c62e..1756151 100644
>>> --- a/include/scsi/scsi_device.h
>>> +++ b/include/scsi/scsi_device.h
>>> @@ -160,6 +160,7 @@ struct scsi_device {
>>>  	unsigned can_power_off:1; /* Device supports runtime power off */
>>>  	unsigned wce_default_on:1;	/* Cache is ON by default */
>>>  	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
>>> +	unsigned event_driven:1; /* No need to poll the device */
>>>  
>>>  	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */
>>>  	struct list_head event_list;	/* asserted events */
>>
>> Yes, but if we can get away with doing that, it should be in genhd
>> because it's completely generic.
>>
>> I was imagining we'd have to fake the reply to the test unit ready or
>> some other commands, which is why it would need to be in sr.c
>>
>> The check events code is Tejun's baby, if he's OK with it then just do
>> it in genhd.c
> 
> The problem here is there's no easy to reach genhd from libata (or the
> other way around) without going through sr.  I think we're gonna have
> to have something in sr one way or the other.

Do you think we can do something like the following to get the gendisk
pointer in libata? - We have ata_dev->sdev->sdev_gendev, and the
gendisk->part0.__dev is a child of it, so we can loop scan sdev_gendev's
children to see which one is of block_class and disk_type. Assuming one
device will alloc only one disk(correct?), we can get the gendisk from
libata layer. Code like this:

diff --git a/block/genhd.c b/block/genhd.c
index 9a289d7..448b201 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1619,6 +1619,38 @@ static void disk_events_workfn(struct work_struct *work)
 		kobject_uevent_env(&disk_to_dev(disk)->kobj, KOBJ_CHANGE, envp);
 }
 
+static int is_gendisk_part0(struct device *dev, void *data)
+{
+	struct device **child = data;
+
+	if (dev->class == &block_class && dev->type == &disk_type) {
+		*child = dev;
+		return 1;
+	} else
+		return 0;
+}
+
+/**
+ * disk_from_device - Get the gendisk pointer for this device.
+ * @dev: the device this gendisk is created for, i.e. gendisk->driverfs_dev
+ *
+ * LLD sometimes need to play with the gendisk without HLD's aware,
+ * this routine gives LLD the required access to gendisk.
+ *
+ * CONTEXT:
+ * Don't care.
+ */
+struct gendisk *disk_from_device(struct device *dev)
+{
+	struct device *child;
+
+	if (device_for_each_child(dev, &child, is_gendisk_part0))
+		return dev_to_disk(child);
+	else
+		return NULL;
+}
+EXPORT_SYMBOL(disk_from_device);
+
 /*
  * A disk events enabled device has the following sysfs nodes under
  * its /sys/block/X/ directory.
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 79b8bba..e8002c0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -427,6 +427,7 @@ extern void disk_block_events(struct gendisk *disk);
 extern void disk_unblock_events(struct gendisk *disk);
 extern void disk_flush_events(struct gendisk *disk, unsigned int mask);
 extern unsigned int disk_clear_events(struct gendisk *disk, unsigned int mask);
+extern struct gendisk *disk_from_device(struct device *dev);
 
 /* drivers/char/random.c */
 extern void add_disk_randomness(struct gendisk *disk);


Then together with disk_try_block_events and disk_unblock_events, we can
avoid touching SCSI layer to let ODD stay in zero power state.

So what do you think?

Thanks,
Aaron

