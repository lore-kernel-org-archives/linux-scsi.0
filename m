From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/2] don't wait on disk to start on resume
Date: Sun, 03 Feb 2013 14:23:22 +0800
Message-ID: <510E025A.9000103@intel.com>
References: <Pine.LNX.4.44L0.1302021003390.25931-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1302021003390.25931-100000@netrider.rowland.org>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Derek Basehore <dbasehore@chromium.org>, James Bottomley <JBottomley@Parallels.com>, Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 02/02/2013 11:09 PM, Alan Stern wrote:
> On Sat, 2 Feb 2013, Aaron Lu wrote:
> 
>>>> An alternative way of possibly solving this problem from PM's point of
>>>> view might be:
>>>> 1 Set both ata port and scsi device's runtime status to RPM_SUSPENDED
>>>>   in their system suspend callback;
> 
> By the way, what reason is there for doing this to the ATA port?  Does 
> the port take a long time to resume, in the same way that a disk can 
> take a few seconds to spin back up?

For SATA controllers that is in AHCI programming interface, the hard
drive will be spined up when the link is put to active state, so the
most time consuming part is in ata, not in scsi, as the below data
showed on my computer(hard disk is a HDD attached to a sata controller
in AHCI mode):
The ata port resume callback takes several seconds(2s-5s) to finish,
while sd_resume takes only 17ms...

I'm not sure about other programming interfaces.

> 
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 497adea..38000fc 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -5355,10 +5355,19 @@ static int ata_port_suspend_common(struct device *dev, pm_message_t mesg)
>>  
>>  static int ata_port_suspend(struct device *dev)
>>  {
>> +	int ret;
>> +
>>  	if (pm_runtime_suspended(dev))
>>  		return 0;
>>  
>> -	return ata_port_suspend_common(dev, PMSG_SUSPEND);
>> +	ret = ata_port_suspend_common(dev, PMSG_SUSPEND);
>> +	if (!ret) {
>> +		__pm_runtime_disable(dev, false);
> 
> Don't you mean pm_runtime_disable(dev)?

I don't think it is necessary to check_resume here, no?

> 
>> +		pm_runtime_set_suspended(dev);
>> +		pm_runtime_enable(dev);
>> +	}
>> +
>> +	return ret;
>>  }
>>  
>>  static int ata_port_do_freeze(struct device *dev)
>> @@ -5393,16 +5402,7 @@ static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
>>  
>>  static int ata_port_resume(struct device *dev)
>>  {
>> -	int rc;
>> -
>> -	rc = ata_port_resume_common(dev, PMSG_RESUME);
>> -	if (!rc) {
>> -		pm_runtime_disable(dev);
>> -		pm_runtime_set_active(dev);
>> -		pm_runtime_enable(dev);
>> -	}
>> -
>> -	return rc;
>> +	return 0;
>>  }
>>  
>>  /*
>> diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
>> index d9956b6..d0b6997 100644
>> --- a/drivers/scsi/scsi_pm.c
>> +++ b/drivers/scsi/scsi_pm.c
>> @@ -127,13 +127,21 @@ static int scsi_bus_prepare(struct device *dev)
>>  static int scsi_bus_suspend(struct device *dev)
>>  {
>>  	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>> -	return scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
>> +	int ret;
>> +
>> +	ret = scsi_bus_suspend_common(dev, pm ? pm->suspend : NULL);
>> +	if (!ret) {
>> +		__pm_runtime_disable(dev, false);
>> +		pm_runtime_set_suspended(dev);
>> +		pm_runtime_enable(dev);
>> +	}
>> +
>> +	return ret;
>>  }
>>  
>>  static int scsi_bus_resume(struct device *dev)
>>  {
>> -	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>> -	return scsi_bus_resume_common(dev, pm ? pm->resume : NULL);
>> +	return 0;
>>  }
> 
> This doesn't look like it would work very well with something like a CD 
> drive, which doesn't use block-layer runtime PM.

No problem, we have the in-kernel-event-poll to resume the CD.
And actually, during resume, some udisk program will also open the block
device to find something out, which will also resume the CD.

> Is that what you meant when you talked about modifying the SCSI PM
> callbacks?

No, the modification is actually for disk.
With v8 of block layer runtime PM, it is no longer the case runtime
suspend is the same as system suspend for hard disk that utilize block
layer runtime PM: we quiesce the device and run its suspend callback for
the device during system suspend but we didn't touch the queue's
rpm_status as we do in runtime_suspend callback. So I did some
modifications to scsi_pm.c to make runtime suspend and system suspend do
exactly the same thing for disk type scsi device, no matter if they are
using block layer runtime PM or not.

Probably I had better post code here, this is a replacement for the
patch 4 of v8 block layer runtime PM patchset(I omit the sd part, since
it is irrevelant), please kindly review, see if you like it :-)

diff --git a/drivers/scsi/scsi_pm.c b/drivers/scsi/scsi_pm.c
index 8f6b12c..d9956b6 100644
--- a/drivers/scsi/scsi_pm.c
+++ b/drivers/scsi/scsi_pm.c
@@ -16,17 +16,44 @@
 
 #include "scsi_priv.h"
 
+static int sdev_blk_suspend(struct scsi_device *sdev)
+{
+	int err;
+
+	err = blk_pre_runtime_suspend(sdev->request_queue);
+	if (err)
+		return err;
+	err = pm_generic_runtime_suspend(&sdev->sdev_gendev);
+	blk_post_runtime_suspend(sdev->request_queue, err);
+
+	return err;
+}
+
+static int sdev_blk_resume(struct scsi_device *sdev)
+{
+	int err;
+
+	blk_pre_runtime_resume(sdev->request_queue);
+	err = pm_generic_runtime_resume(&sdev->sdev_gendev);
+	blk_post_runtime_resume(sdev->request_queue, err);
+
+	return err;
+}
+
 static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
 	int err;
 
-	err = scsi_device_quiesce(to_scsi_device(dev));
+	err = scsi_device_quiesce(sdev);
 	if (err == 0) {
-		if (cb) {
+		if (sdev->request_queue->dev)
+			err = sdev_blk_suspend(sdev);
+		else if (cb)
 			err = cb(dev);
-			if (err)
-				scsi_device_resume(to_scsi_device(dev));
-		}
+
+		if (err)
+			scsi_device_resume(sdev);
 	}
 	dev_dbg(dev, "scsi suspend: %d\n", err);
 	return err;
@@ -34,11 +61,14 @@ static int scsi_dev_type_suspend(struct device *dev, int (*cb)(struct device *))
 
 static int scsi_dev_type_resume(struct device *dev, int (*cb)(struct device *))
 {
+	struct scsi_device *sdev = to_scsi_device(dev);
 	int err = 0;
 
-	if (cb)
+	if (sdev->request_queue->dev)
+		err = sdev_blk_resume(sdev);
+	else if (cb)
 		err = cb(dev);
-	scsi_device_resume(to_scsi_device(dev));
+	scsi_device_resume(sdev);
 	dev_dbg(dev, "scsi resume: %d\n", err);
 	return err;
 }
@@ -185,10 +215,18 @@ static int scsi_runtime_idle(struct device *dev)
 
 	/* Insert hooks here for targets, hosts, and transport classes */
 
-	if (scsi_is_sdev_device(dev))
-		err = pm_schedule_suspend(dev, 100);
-	else
+	if (scsi_is_sdev_device(dev)) {
+		struct scsi_device *sdev = to_scsi_device(dev);
+
+		if (sdev->request_queue->dev) {
+			pm_runtime_mark_last_busy(dev);
+			err = pm_runtime_autosuspend(dev);
+		} else {
+			err = pm_schedule_suspend(dev, 100);
+		}
+	} else {
 		err = pm_runtime_suspend(dev);
+	}
 	return err;
 }
 
-- 
1.8.1

With this patch, the runtime suspend and system suspend for the device
is identical, so that we can safely return in system's suspend callback
when we found the device is already runtime suspended.

Thanks,
Aaron

