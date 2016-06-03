From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Fix a bdi reregistration race, v3
Date: Fri, 3 Jun 2016 16:25:20 -0700
Message-ID: <949afe8e-99cf-b46f-1191-45132c835423@sandisk.com>
References: <56F9A22F.7020002@sandisk.com> <572BA5EF.6000702@sandisk.com>
 <572BAFB0.2020305@stratus.com> <57309597.1040903@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:46933
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751147AbcFCXZf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jun 2016 19:25:35 -0400
In-Reply-To: <57309597.1040903@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 05/09/2016 06:50 AM, Joe Lawrence wrote:
> On 05/05/2016 04:40 PM, Joe Lawrence wrote:
>> On 05/05/2016 03:58 PM, Bart Van Assche wrote:
>>> On 03/28/2016 02:29 PM, Bart Van Assche wrote:
>>>> Avoid that the sd driver registers a BDI device with a name that
>>>> is still in use. This patch avoids that the following warning gets
>>>> triggered:
>>>>
>>>> [ ... ]
>>>
>>> (replying to my own e-mail)
>>>
>>> If anyone could review this patch that would be very welcome.
>>
>> I *think* I may be hitting this same problem running some tests here at Stratus
>> ... snip...
> 
> Good news = With your v3 patch, I didn't see the "sysfs: cannot create
> duplicate filename '/devices/virtual/bdi/65:0'" warning during my
> weekend testing (573 surprise disk HBA removals).
> 
> Bad news = I still crashed in add_disk > sysfs_create_link >
> sysfs_do_create_link_sd on a NULL target_kobj->sd ... unfortunately I
> don't have kdump working, so all I have is a serial console output to
> work with for now.

(replying to an e-mail of one month ago)

Hello Joe,

Earlier today I discovered a subtle bug in v3 of this patch. It would
be appreciated if you could give v4 a try. The only substantial 
difference between v3 and v4 is that a "if (dev->class != &sdev_class)"
test has been added.

Thanks,

Bart.


[PATCH] Fix a bdi reregistration race, v4

Avoid that the sd driver registers a BDI device with a name that
is still in use. This patch avoids that the following warning gets
triggered:

WARNING: CPU: 7 PID: 203 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x68/0x80()
sysfs: cannot create duplicate filename '/devices/virtual/bdi/8:32'
Workqueue: events_unbound async_run_entry_fn
Call Trace:
[<ffffffff814ff5a4>] dump_stack+0x4c/0x65
[<ffffffff810746ba>] warn_slowpath_common+0x8a/0xc0
[<ffffffff81074736>] warn_slowpath_fmt+0x46/0x50
[<ffffffff81237ca8>] sysfs_warn_dup+0x68/0x80
[<ffffffff81237d8e>] sysfs_create_dir_ns+0x7e/0x90
[<ffffffff81291f58>] kobject_add_internal+0xa8/0x320
[<ffffffff812923a0>] kobject_add+0x60/0xb0
[<ffffffff8138c937>] device_add+0x107/0x5e0
[<ffffffff8138d018>] device_create_groups_vargs+0xd8/0x100
[<ffffffff8138d05c>] device_create_vargs+0x1c/0x20
[<ffffffff8117f233>] bdi_register+0x63/0x2a0
[<ffffffff8117f497>] bdi_register_dev+0x27/0x30
[<ffffffff81281549>] add_disk+0x1a9/0x4e0
[<ffffffffa00c5739>] sd_probe_async+0x119/0x1d0 [sd_mod]
[<ffffffff8109a81a>] async_run_entry_fn+0x4a/0x140
[<ffffffff81091078>] process_one_work+0x1d8/0x7c0
[<ffffffff81091774>] worker_thread+0x114/0x460
[<ffffffff81097878>] kthread+0xf8/0x110
[<ffffffff8150801f>] ret_from_fork+0x3f/0x70

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/scsi_sysfs.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0734927..ac10f0c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1273,9 +1273,35 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	return error;
 }
 
+/**
+ * scsi_filter_sd - Look up the device structure embedded in a disk structure
+ * @dev: A sdev_gendev device
+ * @data: A struct device pointer
+ *
+ * sdev_gendev devices have two children - the sdev_dev device and for SCSI
+ * disks, the device embedded in a scsi_disk.
+ */
+static int scsi_filter_sd(struct device *dev, void *data)
+{
+	struct device **childp = data;
+
+	if (dev->class != &sdev_class)
+		*childp = dev;
+	return 0;
+}
+
+/* Caller must call put_device() if this function does not return NULL. */
+static struct device *scsi_get_sd(struct device *dev)
+{
+	struct device *child = NULL;
+
+	device_for_each_child(dev, &child, scsi_filter_sd);
+	return get_device(child);
+}
+
 void __scsi_remove_device(struct scsi_device *sdev)
 {
-	struct device *dev = &sdev->sdev_gendev;
+	struct device *dev = &sdev->sdev_gendev, *sdp = NULL;
 
 	/*
 	 * This cleanup path is not reentrant and while it is impossible
@@ -1290,6 +1316,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 			return;
 
 		bsg_unregister_queue(sdev->request_queue);
+		sdp = scsi_get_sd(dev);
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		scsi_dh_remove_device(sdev);
@@ -1306,6 +1333,16 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	blk_cleanup_queue(sdev->request_queue);
 	cancel_work_sync(&sdev->requeue_work);
 
+	/*
+	 * blk_cleanup_queue() unregisters the BDI device. The name of the
+	 * BDI device is derived from the dev_t of the /dev/sd<n> device.
+	 * Keep a reference to the /dev/sd<n> device until the BDI device
+	 * has been unregistered to avoid that a BDI device with the same
+	 * name gets registered before blk_cleanup_queue() has finished.
+	 */
+	if (sdp)
+		put_device(sdp);
+
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
-- 
2.8.3

