From: Paul Mackerras <paulus@ozlabs.org>
Subject: Bugs in multipath scsi in 4.3-rc2
Date: Fri, 25 Sep 2015 22:16:36 +1000
Message-ID: <20150925121636.GC12540@fergus.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:41772 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619AbbIYMQm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Sep 2015 08:16:42 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

I recently tried v4.3-rc2 on a test machine I have which is a POWER8
server with multipath SCSI disks.  It failed to boot because it didn't
find its disks.  Two things were evident in the logs: first, we're
hitting a WARN_ON_ONCE in the module code:

[    1.953020] WARNING: at /home/paulus/kernel/kvm/kernel/kmod.c:140
[    1.953080] Modules linked in: radeon(+) i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt
[    1.953529]  fb_sys_fops ttm tg3(+) ptp drm pps_core ipr cxgb3 i2c_core mdio dm_multipath
[    1.953842] CPU: 14 PID: 939 Comm: kworker/u321:2 Not tainted 4.3.0-rc2-kvm #69
[    1.953980] Workqueue: events_unbound async_run_entry_fn
[    1.954092] task: c000000fe4a00000 ti: c000000fe4a80000 task.ti: c000000fe4a80000
...
[    1.956634] NIP [c0000000000d390c] __request_module+0x21c/0x380
[    1.956748] LR [c0000000000d38f4] __request_module+0x204/0x380
[    1.956861] Call Trace:
[    1.956908] [c000000fe4a83920] [c0000000000d38f4] __request_module+0x204/0x380 (unreliable)
[    1.957090] [c000000fe4a839e0] [c0000000006368fc] scsi_dh_lookup+0x5c/0x80
[    1.957226] [c000000fe4a83a50] [c000000000636fcc] scsi_dh_add_device+0x13c/0x170
[    1.957387] [c000000fe4a83aa0] [c000000000630ea4] scsi_sysfs_add_sdev+0x114/0x380
[    1.957545] [c000000fe4a83b30] [c00000000062e040] do_scan_async+0xf0/0x240
[    1.957650] [c000000fe4a83bc0] [c0000000000e6bc0] async_run_entry_fn+0xa0/0x200
[    1.957731] [c000000fe4a83c50] [c0000000000d9750] process_one_work+0x1a0/0x4b0
[    1.957812] [c000000fe4a83ce0] [c0000000000d9bf0] worker_thread+0x190/0x5f0
[    1.957881] [c000000fe4a83d80] [c0000000000e21b0] kthread+0x110/0x130
[    1.957952] [c000000fe4a83e30] [c0000000000095b0] ret_from_kernel_thread+0x5c/0xac

The statement in question is:

	/*
	 * We don't allow synchronous module loading from async.  Module
	 * init may invoke async_synchronize_full() which will end up
	 * waiting for this task which already is waiting for the module
	 * loading to complete, leading to a deadlock.
	 */
	WARN_ON_ONCE(wait && current_is_async());

Evidently scsi_dh_add_device() is being called in async context, where
you can't wait for a module to be loaded.

The second thing is that I see lots of these errors:

[    3.018700] device-mapper: table: 253:0: multipath: error attaching hardware handler
[    3.018828] device-mapper: ioctl: error adding target to table

and ultimately the system doesn't find any of its disks and fails to
boot.  The userspace in question is Fedora 21.

I bisected the problem down to commit 566079c849cf, "dm-mpath,
scsi_dh: request scsi_dh modules in scsi_dh, not dm-mpath".  It turns
out that the second set of errors are caused by the scsi_dh_alua
module not getting loaded, and that is because scsi_dh_lookup() is
requesting a module called "alua" rather than "scsi_dh_alua".  Those
errors can be fixed by changing the request_module() call in
scsi_dh_lookup() as in this patch:

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index edb044a..86a3063 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -111,7 +111,7 @@ static struct scsi_device_handler *scsi_dh_lookup(const char *name)
 
 	dh = __scsi_dh_lookup(name);
 	if (!dh) {
-		request_module(name);
+		request_module("scsi_dh_%s", name);
 		dh = __scsi_dh_lookup(name);
 	}

and with that patch the system boots, though still with the warning
splat, which I don't know how to fix.

Paul.
