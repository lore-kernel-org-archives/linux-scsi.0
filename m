From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/5] zfcp: Fix lockdep warning when offlining device with offline chpid
Date: Thu, 24 Sep 2009 10:23:24 +0200
Message-ID: <20090924082603.174495000@de.ibm.com>
References: <20090924082320.374328000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:41385 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZIXI0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 04:26:00 -0400
Content-Disposition: inline; filename=703-zfcp-lockdep-offline.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.31-39.x.20090917-s390xdefault #1
-------------------------------------------------------
kslowcrw/83 is trying to acquire lock:
 (&adapter->scan_work){+.+.+.}, at: [<0000000000169c5c>] __cancel_work_timer+0x64/0x3d4

but task is already holding lock:
 (&zfcp_data.config_mutex){+.+.+.}, at: [<00000000004671ea>] zfcp_ccw_remove+0x66/0x384

which lock already depends on the new lock.

the existing dependency chain (in reverse order) is:

-> #1 (&zfcp_data.config_mutex){+.+.+.}:
       [<0000000000189962>] __lock_acquire+0xe26/0x1834
       [<000000000018a4b6>] lock_acquire+0x146/0x178
       [<000000000058cb5a>] mutex_lock_nested+0x82/0x3ec
       [<0000000000477170>] zfcp_fc_scan_ports+0x3ec/0x728
       [<0000000000168e34>] worker_thread+0x278/0x3a8
       [<000000000016ff08>] kthread+0x9c/0xa4
       [<0000000000109ebe>] kernel_thread_starter+0x6/0xc
       [<0000000000109eb8>] kernel_thread_starter+0x0/0xc

-> #0 (&adapter->scan_work){+.+.+.}:
       [<0000000000189e60>] __lock_acquire+0x1324/0x1834
       [<000000000018a4b6>] lock_acquire+0x146/0x178
       [<0000000000169c9a>] __cancel_work_timer+0xa2/0x3d4
       [<0000000000465cb2>] zfcp_adapter_dequeue+0x32/0x14c
       [<00000000004673e4>] zfcp_ccw_remove+0x260/0x384
       [<00000000004250f6>] ccw_device_remove+0x42/0x1ac
       [<00000000003cb6be>] __device_release_driver+0x9a/0x10c
       [<00000000003cb856>] device_release_driver+0x3a/0x4c
       [<00000000003ca94c>] bus_remove_device+0xcc/0x114
       [<00000000003c8506>] device_del+0x162/0x21c
       [<0000000000425ff2>] ccw_device_unregister+0x5e/0x7c
       [<000000000042607e>] io_subchannel_remove+0x6e/0x9c
       [<000000000041ff9a>] css_remove+0x3e/0x7c
       [<00000000003cb6be>] __device_release_driver+0x9a/0x10c
       [<00000000003cb856>] device_release_driver+0x3a/0x4c
       [<00000000003ca94c>] bus_remove_device+0xcc/0x114
       [<00000000003c8506>] device_del+0x162/0x21c
       [<00000000003c85e8>] device_unregister+0x28/0x38
       [<0000000000420152>] css_sch_device_unregister+0x46/0x58
       [<00000000004276a6>] io_subchannel_sch_event+0x28e/0x794
       [<0000000000420442>] css_evaluate_known_subchannel+0x46/0xd0
       [<0000000000420ebc>] slow_eval_known_fn+0x88/0xa0
       [<00000000003caffa>] bus_for_each_dev+0x7e/0xd0
       [<000000000042188c>] for_each_subchannel_staged+0x6c/0xd4
       [<0000000000421a00>] css_slow_path_func+0x54/0xd8
       [<0000000000168e34>] worker_thread+0x278/0x3a8
       [<000000000016ff08>] kthread+0x9c/0xa4
       [<0000000000109ebe>] kernel_thread_starter+0x6/0xc
       [<0000000000109eb8>] kernel_thread_starter+0x0/0xc

cancel_work_sync is called while holding the config_mutex. But the
work that is being cancelled or flushed also uses the config_mutex.
Fix the resulting deadlock possibility by calling cancel_work_sync
earlier without holding the mutex. The best place to do is is after
offlining the device.  No new port scan work will be scheduled for the
offline device, so this is a safe place to call cancel_work_sync.

Reviewed-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    1 -
 drivers/s390/scsi/zfcp_ccw.c |    4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-09-23 10:13:18.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-09-23 10:13:18.000000000 +0200
@@ -602,7 +602,6 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	int retval = 0;
 	unsigned long flags;
 
-	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
 	zfcp_adapter_scsi_unregister(adapter);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:13:18.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:13:18.000000000 +0200
@@ -102,7 +102,11 @@ static void zfcp_ccw_remove(struct ccw_d
 	adapter = dev_get_drvdata(&ccw_device->dev);
 	if (!adapter)
 		goto out;
+	mutex_unlock(&zfcp_data.config_mutex);
+
+	cancel_work_sync(&adapter->scan_work);
 
+	mutex_lock(&zfcp_data.config_mutex);
 	write_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list_head, list) {
 		list_for_each_entry_safe(unit, u, &port->unit_list_head, list) {

