From: "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 2/2] Another crash in linux kernel at diconnect of usb strorage
Date: Tue, 3 Nov 2009 12:36:36 +0300
Message-ID: <1257240996-23118-2-git-send-email-den@openvz.org>
References: <1257240996-23118-1-git-send-email-den@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:34151 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755853AbZKCJwh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 04:52:37 -0500
In-Reply-To: <1257240996-23118-1-git-send-email-den@openvz.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "Denis V. Lunev" <den@openvz.org>

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

Asynchronous scan (scsi_add_lun()) sets state to SDEV_RUNNING,
but the device is not registered in sysfs.
Before async scan it was OK, because before releasing scan_mutex
old code called either scsi_sysfs_add_sdev() or scsi_destroy_sdev()
and, therefore, completed the work or discarded it.

With async scan the invariant is broken and scsi crashes
in __scsi_remove_device() when trying to unregister not registered
devices.

The fix could be introducing new state(s), which is equivalent
to SDEV_RUNNING, except for one thing, we know that scsi_sysfs_add_sdev()
has not been called yet. Or a separate flag, because the state
can be SDEV_BLOCK or even something else.

Simpler way is just to check that the device is regstered in sysfs
before unregistering. Another operations in __scsi_remove_device()
seem to be idempotent or even required, because  scsi_add_lun()
makes some part of work duplicated in scsi_sysfs_add_sdev().

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
CC: James E.J. Bottomley <James.Bottomley@suse.de>
Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 drivers/scsi/scsi_sysfs.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 5c7eb63..ea02e9b 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -927,9 +927,17 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		return;
 
 	bsg_unregister_queue(sdev->request_queue);
-	device_unregister(&sdev->sdev_dev);
+	/* Asynchronous scan violates invariant that SDEV_RUNNING
+	 * implies that device is registered in sysfs.
+	 * We could introduce new state flag or extend set of state,
+	 * but just plain checking that device is registered already
+	 * before trying to unregister it is enough.
+	 */
+	if (sdev->sdev_dev.kobj.parent)
+		device_unregister(&sdev->sdev_dev);
 	transport_remove_device(dev);
-	device_del(dev);
+	if (dev->kobj.parent)
+		device_del(dev);
 	scsi_device_set_state(sdev, SDEV_DEL);
 	if (sdev->host->hostt->slave_destroy)
 		sdev->host->hostt->slave_destroy(sdev);
-- 
1.6.4.4

