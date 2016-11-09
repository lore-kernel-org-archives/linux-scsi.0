From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a deadlock
Date: Tue, 08 Nov 2016 19:22:10 -0600
Message-ID: <87shr1phvh.fsf@xmission.com>
References: <7d35e3f1-6c58-26bc-297b-73993aa90f0b@sandisk.com>
        <1478618887.2824.2.camel@linux.vnet.ibm.com>
        <eecdade1-2b35-b877-cb66-6d9c1dc02ddf@sandisk.com>
        <1478628101.2824.27.camel@linux.vnet.ibm.com>
        <87oa1pvl8f.fsf@xmission.com>
        <0129858f-382b-0903-7157-40e5ec8a9e6a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out02.mta.xmission.com ([166.70.13.232]:41800 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750927AbcKIBYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 20:24:40 -0500
In-Reply-To: <0129858f-382b-0903-7157-40e5ec8a9e6a@sandisk.com> (Bart Van
        Assche's message of "Tue, 8 Nov 2016 15:33:33 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <greg@kroah.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Bart Van Assche <bart.vanassche@sandisk.com> writes:

> On 11/08/2016 11:15 AM, Eric W. Biederman wrote:
>> James Bottomley <jejb@linux.vnet.ibm.com> writes:
>>
>>> On Tue, 2016-11-08 at 08:52 -0800, Bart Van Assche wrote:
>>>> On 11/08/2016 07:28 AM, James Bottomley wrote:
>>>>> On Mon, 2016-11-07 at 16:32 -0800, Bart Van Assche wrote:
>>>>>> diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
>>>>>> index cf4c636..44ec536 100644
>>>>>> --- a/fs/kernfs/dir.c
>>>>>> +++ b/fs/kernfs/dir.c
>>>>>> @@ -1410,7 +1410,7 @@ int kernfs_remove_by_name_ns(struct
>>>>>> kernfs_node
>>>>>> *parent, const char *name,
>>>>>>  	mutex_lock(&kernfs_mutex);
>>>>>>
>>>>>>  	kn = kernfs_find_ns(parent, name, ns);
>>>>>> -	if (kn)
>>>>>> +	if (kn && !(kn->flags & KERNFS_SUICIDED))
>>>>>
>>>>> Actually, wrong flag, you need KERNFS_SUICIDAL.  The reason is that
>>>>> kernfs_mutex is actually dropped half way through __kernfs_remove,
>>>>> so KERNFS_SUICIDED is not set atomically with this mutex.
>>>>
>>>> Hello James,
>>>>
>>>> Sorry but what you wrote is not correct.
>>>
>>> I think you agree it is dropped.  I don't need to add the bit about the
>>> reacquisition because the race is mediated by the first acquisition not
>>> the second one, if you mediate on KERNFS_SUICIDAL, you only need to
>>> worry about this because the mediation is in the first acquisition.  If
>>> you mediate on KERNFS_SUICIDED, you need to explain that the final
>>> thing that means the race can't happen is the unbreak in the sysfs
>>> delete path re-acquiring s_active ... the explanation of what's going
>>> on and why gets about 2x more complex.
>>
>> Is it really the dropping of the lock that is causing this?
>> I don't see that when I read those traces.
>>
>> I am going to put my vote in for doing all of the self removal
>> sem-asynchronously by using task_work_add, and killing
>> device_remove_self, sysfs_remove_self, kernfs_remove_self.  Using
>> task_work_add remains synchronous with userspace so userspace should not
>> care, and we get the benefit of not having two different variants of the
>> same code racing with each other.
>>
>> It might take a little more work but will leave code that is much more
>> maintainable in the long run.
>
> Hello Eric,
>
> I'm completely in favor of keeping code maintainable. But what's not clear to me
> is whether asynchronous I/O can be submitted to a sysfs attribute? If so, on
> what context will task work queued through task_work_add() be executed if an aio
> write is used to write into a sysfs attribute?

I don't believe so.  I believe the filesystem has to opt into aio.  In
either case I don't believe we have to worry about aio because either it
won't be supported or it will be a synchronous write to sysfs.

> Additionally, can a process enter the exiting state after writing into the sysfs
> delete attribute started and before task_work_add() has been called? I'm asking
> this because in that case task_work_add() will fail.

Not before task_work_add has been called because task_work_add is what
will be called synchronously from the write function of the delete
attribute.

Furthermore task_work_run is guaranteed to be called before you return
to userspace.  It is remotely possible that someone sends the process a
SIGKILL while the delete attribute is being written.  In that case
task_work_run should run before the task gets too deep into the exiting
state.

But the SIGKILL will not be processed until the write syscall finishes
and the kernel returns to the edge of userspace.

So I can't imagine anything that would make task_work_add be a poor
choice in these circumstances.

And basically that fix for just the scsi bits I think is as simple as:

 drivers/scsi/scsi_sysfs.c  | 20 +++++++++++++++++---
 include/scsi/scsi_device.h |  1 +
 2 files changed, 18 insertions(+), 3 deletions(-)
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 07349270535d..fee88cde7c12 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
+#include <linux/task_work.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -705,13 +706,26 @@ store_rescan_field (struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR(rescan, S_IWUSR, NULL, store_rescan_field);
 
+static void sdev_remove_self(struct callback_head *cb)
+{
+	struct scsi_device *sdev =
+		container_of(cb, struct scsi_device, delete_work);
+
+	scsi_remove_device(sdev);
+}
+
 static ssize_t
 sdev_store_delete(struct device *dev, struct device_attribute *attr,
 		  const char *buf, size_t count)
 {
-	if (device_remove_file_self(dev, attr))
-		scsi_remove_device(to_scsi_device(dev));
-	return count;
+	struct scsi_device *sdev = to_scsi_device(dev);
+	ssize_t err;
+
+	init_task_work(&sdev->delete_work, sdev_remove_self);
+	err = task_work_add(current, &sdev->delete_work, false);
+	if (!err)
+		err = count;
+	return err;
 };
 static DEVICE_ATTR(delete, S_IWUSR, NULL, sdev_store_delete);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8a9563144890..e82a151c8543 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -206,6 +206,7 @@ struct scsi_device {
 	struct scsi_device_handler *handler;
 	void			*handler_data;
 
+	struct callback_head	delete_work;
 	unsigned char		access_state;
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];

Eric

