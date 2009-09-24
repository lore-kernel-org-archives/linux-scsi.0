From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/5] zfcp: Fix hang when offlining device with offline chpid
Date: Thu, 24 Sep 2009 10:23:25 +0200
Message-ID: <20090924082603.304472000@de.ibm.com>
References: <20090924082320.374328000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:44081 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbZIXI0B (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 04:26:01 -0400
Content-Disposition: inline; filename=704-zfcp-hang-offline-chpid.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Running chchp --vary 0 and chccwdev -d on a FCP device with scsi
devices attached can lead to this thread hanging:

================================================================
STACK TRACE FOR TASK: 0x2fbfcc00 (kslowcrw)

 STACK:
 0 schedule+1136 [0x45f99c]
 1 schedule_timeout+534 [0x46054e]
 2 wait_for_common+374 [0x45f442]
 3 blk_execute_rq+160 [0x217a2c]
 4 scsi_execute+278 [0x26daf2]
 5 scsi_execute_req+150 [0x26dc86]
 6 sd_sync_cache+138 [0x28460a]
 7 sd_shutdown+130 [0x28486a]
 8 sd_remove+104 [0x284c84]
 9 __device_release_driver+152 [0x257430]
10 device_release_driver+56 [0x2575c8]
11 bus_remove_device+214 [0x25672a]
12 device_del+352 [0x25456c]
13 __scsi_remove_device+108 [0x272630]
14 scsi_remove_device+66 [0x2726ba]
15 zfcp_ccw_remove+824 [0x335558]
16 ccw_device_remove+62 [0x2b3f2a]
17 __device_release_driver+152 [0x257430]
18 device_release_driver+56 [0x2575c8]
19 bus_remove_device+214 [0x25672a]
20 device_del+352 [0x25456c]
21 ccw_device_unregister+92 [0x2b48c4]
22 io_subchannel_remove+108 [0x2b4950]
23 css_remove+62 [0x2af7ee]
24 __device_release_driver+152 [0x257430]
25 device_release_driver+56 [0x2575c8]
26 bus_remove_device+214 [0x25672a]
27 device_del+352 [0x25456c]
28 device_unregister+38 [0x25464a]
29 css_sch_device_unregister+68 [0x2af97c]
30 ccw_device_call_sch_unregister+78 [0x2b581e]
31 worker_thread+604 [0x69eb0]
32 kthread+154 [0x6ff42]
33 kernel_thread_starter+6 [0x1c952]
================================================================

The problem is that the chchp --vary 0 leads to zfcp first calling
fc_remote_port_delete which blocks all scsi devices on the remote
port. Calling scsi_remove_device later lets the sd driver issue a
SYNCHRONIZE_CACHE command. This command stays on the "stopped" request
requeue because the SCSI device is blocked. Fix this by first removing
the scsi and fc hosts which removes all scsi devices and do not use
scsi_remove_device.

Reviewed-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    1 -
 drivers/s390/scsi/zfcp_ccw.c |    9 +++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-09-23 10:13:19.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-09-23 10:13:19.000000000 +0200
@@ -604,7 +604,6 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 
 	cancel_work_sync(&adapter->stat_work);
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
-	zfcp_adapter_scsi_unregister(adapter);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:13:19.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:13:19.000000000 +0200
@@ -107,6 +107,10 @@ static void zfcp_ccw_remove(struct ccw_d
 	cancel_work_sync(&adapter->scan_work);
 
 	mutex_lock(&zfcp_data.config_mutex);
+
+	/* this also removes the scsi devices, so call it first */
+	zfcp_adapter_scsi_unregister(adapter);
+
 	write_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list_head, list) {
 		list_for_each_entry_safe(unit, u, &port->unit_list_head, list) {
@@ -121,11 +125,8 @@ static void zfcp_ccw_remove(struct ccw_d
 	write_unlock_irq(&zfcp_data.config_lock);
 
 	list_for_each_entry_safe(port, p, &port_remove_lh, list) {
-		list_for_each_entry_safe(unit, u, &unit_remove_lh, list) {
-			if (unit->device)
-				scsi_remove_device(unit->device);
+		list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
 			zfcp_unit_dequeue(unit);
-		}
 		zfcp_port_dequeue(port);
 	}
 	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);

