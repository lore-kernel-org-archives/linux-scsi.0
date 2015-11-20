From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [BISECTED] v4.4-rc1 SCSI disk init crash
Date: Thu, 19 Nov 2015 17:45:00 -0800
Message-ID: <564E7B1C.10509@sandisk.com>
References: <20151119192135.GD18138@blackmetal.musicnaut.iki.fi>
 <564E28DE.6010200@sandisk.com>
 <1447963712.2234.31.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0087.outbound.protection.outlook.com ([157.56.110.87]:40864
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934401AbbKTBpI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Nov 2015 20:45:08 -0500
In-Reply-To: <1447963712.2234.31.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, linux-scsi <linux-scsi@vger.kernel.org>

On 11/19/2015 12:08 PM, James Bottomley wrote:
> On Thu, 2015-11-19 at 11:54 -0800, Bart Van Assche wrote:
>> On 11/19/2015 11:22 AM, Aaro Koskinen wrote:
>>> I get the below crash when cold booting OCTEON router with USB disk as
>>> rootfs. Bisected to:
>>>
>>> 	commit bf2cf3baa20b0a6cd2d08707ef05dc0e992a8aa0
>>> 	Author: Bart Van Assche <bart.vanassche@sandisk.com>
>>> 	Date:   Fri Sep 18 17:23:42 2015 -0700
>>>
>>> 	    scsi: Fix a bdi reregistration race
>>>
>>> Reverting the patch makes the board boot fine again.
>>>
>>> A.
>>>
>>> Waiting for rootfs media to appear... Press ENTER to interrupt.
>>> [    1.540522] usb 1-1: new high-speed USB device number 2 using ehci-platform
>>> [    1.699752] usb-storage 1-1:1.0: USB Mass Storage device detected
>>> [    1.706054] scsi host0: usb-storage 1-1:1.0
>>> [    2.702105] scsi 0:0:0:0: Direct-Access     Ext Hard  Disk                 PQ: 0 ANSI: 5
>>> [    2.714214] sd 0:0:0:0: [sda] Spinning up disk...
>>> [    3.720503] ...
>>> [    6.674040] usb 1-1: USB disconnect, device number 2
>>> [    6.750508] .ready
>>> [    6.752558] sd 0:0:0:0: [sda] Read Capacity(10) failed: Result: hostbyte=0x00 driverbyte=0x04
>>> [    6.761112] sd 0:0:0:0: [sda] Sense not available.
>>> [    6.765918] sd 0:0:0:0: [sda] Write Protect is off
>>> [    6.770741] sd 0:0:0:0: [sda] Asking for cache data failed
>>> [    6.776236] sd 0:0:0:0: [sda] Assuming drive cache: write through
>>> [    6.782745] ------------[ cut here ]------------
>>> [    6.787383] WARNING: CPU: 1 PID: 15 at /home/aaro/git/linux/block/genhd.c:626 add_disk+0x41c/0x478()
>>> [    6.796549] Modules linked in:
>>> [    6.799624] CPU: 1 PID: 15 Comm: kworker/u4:1 Not tainted 4.4.0-rc1-octeon-los_73f9f-00002-gd81c963 #1
>>> [    6.808959] Workqueue: events_unbound async_run_entry_fn
>>> [    6.814296] Stack : 0000000000000001 0000000000000004 ffffffff81760000 0000000000000000
>>> 	  0000000000000001 0000000000000000 0000000000000000 0000000000000000
>>> 	  ffffffff81f3abc8 ffffffff811893f8 0000000000000000 ffffffff81f3a758
>>> 	  0000000000000000 0000000000000002 0000000000000001 ffffffff81f40000
>>> 	  ffffffff816b78f8 80000000330e9000 0000000000000272 0000000000000009
>>> 	  ffffffff813471cc 0000000000000000 80000000330086a0 8000000033008400
>>> 	  80000000330e9000 ffffffff811cea44 800000003314bb68 8000000033008400
>>> 	  80000000330e9000 800000003314ba70 800000003314bb88 ffffffff8135331c
>>> 	  000000000000015f ffffffff813c0900 000000000000006e 0000000000000000
>>> 	  735f756e626f756e ffffffff81124190 0000000000000000 0000000000000000
>>> 	  ...
>>> [    6.879950] Call Trace:
>>> [    6.882414] [<ffffffff81124190>] show_stack+0x88/0xa8
>>> [    6.887475] [<ffffffff8135331c>] dump_stack+0x6c/0x90
>>> [    6.892549] [<ffffffff81141cb4>] warn_slowpath_common+0x94/0xd8
>>> [    6.898481] [<ffffffff813471cc>] add_disk+0x41c/0x478
>>> [    6.903552] [<ffffffff81400794>] sd_probe_async+0xfc/0x218
>>> [    6.909047] [<ffffffff8116373c>] async_run_entry_fn+0x4c/0x120
>>> [    6.914898] [<ffffffff8115a83c>] process_one_work+0x17c/0x438
>>> [    6.920663] [<ffffffff8115ac60>] worker_thread+0x168/0x5e0
>>> [    6.926159] [<ffffffff81160dc4>] kthread+0xd4/0xf0
>>> [    6.930968] [<ffffffff8111e9d8>] ret_from_kernel_thread+0x14/0x1c
>>> [    6.937069]
>>
>> Hello Aaro,
>>
>> The patch you mentioned changes the device removal code. The above
>> output shows a warning triggered by the device probing code. That makes
>> it unlikely that the above warning is caused by my patch. Please double
>> check your bisect results.
> 
> It's obviously caused by your patch ... look at the event sequence: it's
> a disconnect triggering removal on an in-process probe.
> 
> The question is how to fix it.  The original problem is that we have a
> set of three bound names that die at slightly different times.  The
> solution: to extend the sd and bdi name beyond the queue one worked for
> your use case, but caused this.  Ideally, we'd probably just like for
> the scanning code to wait until all the names are gone before trying to
> reacquire them, but that looks problematic too.

Hello James and Aaro,

How about reverting commit bf2cf3baa20b0a6cd2d08707ef05dc0e992a8aa0 and
replacing it by something like the (very lightly tested so far) patch below ?

Thanks,

Bart.

---
 drivers/scsi/scsi_sysfs.c        |  2 ++
 include/linux/backing-dev-defs.h |  1 +
 include/linux/backing-dev.h      |  1 +
 mm/backing-dev.c                 | 28 ++++++++++++++++++++++++++--
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index f5ace2b..8d64518 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -12,6 +12,7 @@
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
+#include <linux/backing-dev.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -1110,6 +1111,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		device_unregister(&sdev->sdev_dev);
 		transport_remove_device(dev);
 		scsi_dh_remove_device(sdev);
+		bdi_sysfs_del(&sdev->request_queue->backing_dev_info);
 		device_del(dev);
 	} else
 		put_device(&sdev->sdev_dev);
diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index 1b4d69f..1a42ecb 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -135,6 +135,7 @@ struct bdi_writeback {
 
 struct backing_dev_info {
 	struct list_head bdi_list;
+	bool is_visible;
 	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
 	unsigned int capabilities; /* Device capabilities */
 	congested_fn *congested_fn; /* Function pointer if device is md/dm */
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index c82794f..9004d90 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -24,6 +24,7 @@ __printf(3, 4)
 int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		const char *fmt, ...);
 int bdi_register_dev(struct backing_dev_info *bdi, dev_t dev);
+void bdi_sysfs_del(struct backing_dev_info *bdi);
 void bdi_unregister(struct backing_dev_info *bdi);
 
 int __must_check bdi_setup_and_register(struct backing_dev_info *, char *);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8ed2ffd..b56971f 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -774,6 +774,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	int ret;
 
 	bdi->dev = NULL;
+	bdi->is_visible = false;
 
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100;
@@ -806,6 +807,7 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 		return PTR_ERR(dev);
 
 	bdi->dev = dev;
+	bdi->is_visible = true;
 
 	bdi_debug_register(bdi, dev_name(dev));
 	set_bit(WB_registered, &bdi->wb.state);
@@ -837,6 +839,28 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 	synchronize_rcu_expedited();
 }
 
+/**
+ * bdi_sysfs_del - remove a BDI device from sysfs
+ * @bdi: BDI device pointer.
+ *
+ * It is safe to call this function more than once.
+ */
+void bdi_sysfs_del(struct backing_dev_info *bdi)
+{
+	bool is_visible = false;
+
+	spin_lock_bh(&bdi_lock);
+	swap(bdi->is_visible, is_visible);
+	spin_unlock_bh(&bdi_lock);
+
+	if (!is_visible)
+		return;
+
+	bdi_debug_unregister(bdi);
+	device_del(bdi->dev);
+}
+EXPORT_SYMBOL(bdi_sysfs_del);
+
 void bdi_unregister(struct backing_dev_info *bdi)
 {
 	/* make sure nobody finds us on the bdi_list anymore */
@@ -845,8 +869,8 @@ void bdi_unregister(struct backing_dev_info *bdi)
 	cgwb_bdi_destroy(bdi);
 
 	if (bdi->dev) {
-		bdi_debug_unregister(bdi);
-		device_unregister(bdi->dev);
+		bdi_sysfs_del(bdi);
+		put_device(bdi->dev);
 		bdi->dev = NULL;
 	}
 }
-- 
2.1.4


