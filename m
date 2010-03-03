From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Tue, 2 Mar 2010 16:47:01 -0800
Message-ID: <233671224A0FED4688218FFDBED26E1A517AC38638@IRVEXCHCCR01.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3470 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758157Ab0CCArM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Mar 2010 19:47:12 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

The system may fail to boot when the kernel's devices_kset->list gets
written by another thread while device_shutdown() is traversing the
list.  Though not common, this is fairly reproducible for some SCSI
Fibre Channel topologies; particularly so with FCoE configurations.

The reboot thread calls device_shutdown() as part of system shutdown.
device_shutdown() loops through devices_kset->list, shutting down each
system device.  But devices_kset->list isn't protected from other
writers while device_shutdown() traverses the list.

One such secondary writer is the SCI Fibre Channel workqueue.  When
fc_wq_N removes a device that device_shutdown() holds in it's "devn"
(list traversal iterator) variable, device_shutdown() stalls, chasing
what is essentially a broken link.

This is not a common occurrence.  But FC SCSI devices associated with a
link that has gone down cause a race between device_shutdown() running
in reboot's process and scsi_remove_target() running in a SCSI FC
workqueue (fc_wq_N).

Network attached FC devices are particularly vulnerable because SysV
init scripts shut network interfaces down before proceeding with the
reboot request.  So by the time reboot is called, the link to the FC
devices is already down.

When the link is down device_shutdown() stalls (in sd_shutdown() --
which issues cache flush CDBs to what are, by that time, inaccessible
devices).  The stall ends when the fc rport timer expires.  But the
timer expiration also initiates fc_starget_delete() in the fc workqueue,
causing the race with device_shutdown().

The attached patch detects and attempts to recover from the
corruption.  But this can hardly be considered a fix, as it does not
address the race between device_shutdown() and scsi_remove_target().

Perhaps converting the list_for_each_entry_safe_reverse() to something
like.

        while (!list_empty(&devices_kset->list)) {
                dev = list_last_entry(...);
                ...
        }

might be appropriate.  But I have no idea if any devices don't fully
remove themselves from the list when shutdown.

Does anyone have any guidance for what would make a more appropriate
fix?

Thanks,
Hugh

>From ff59be003a016ed1f638f89658bcbb17d69b2983 Mon Sep 17 00:00:00 2001
From: Hugh Daschbach <hdasch@broadcom.com>
Date: Mon, 1 Mar 2010 17:01:48 -0800
Subject: [PATCH] Fix Cont00045892: bnx2fc 0.2.3: Cannot shutdown a system

Detect and attempt recovery from devices_kset->list corruption.

The list gets corrupted during reboot by a race between
device_shutdown() and scsi_remove_target().

Signed-off-by: Hugh Daschbach <hdasch@broadcom.com>
---
 drivers/base/core.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2820257..07851e9 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1733,6 +1733,7 @@ void device_shutdown(void)
 {
 	struct device *dev, *devn;

+retry:
 	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
 				kobj.entry) {
 		if (dev->bus && dev->bus->shutdown) {
@@ -1742,6 +1743,9 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+		if (devn->kobj.entry.next == devn->kobj.entry.prev &&
+		    devn->kobj.entry.next != &devices_kset->list)
+			goto retry;
 	}
 	async_synchronize_full();
 }
-- 
1.7.0.rc0.48.gdace5


