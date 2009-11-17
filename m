From: akpm@linux-foundation.org
Subject: [patch for 2.6.32? 3/3] scsi: fix another crash at disconnect of usb strorage
Date: Tue, 17 Nov 2009 14:10:13 -0800
Message-ID: <200911172210.nAHMADAW014298@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbZKQWLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:11:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru, alan@lxorguk.ukuu.org.uk, den@openvz.org, stern@rowland.harvard.edu

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>

Asynchronous scan (scsi_add_lun()) sets state to SDEV_RUNNING, but the
device is not registered in sysfs.  Before async scan it was OK, because
before releasing scan_mutex old code called either scsi_sysfs_add_sdev()
or scsi_destroy_sdev() and, therefore, completed the work or discarded it.

With async scan the invariant is broken and scsi crashes in
__scsi_remove_device() when trying to unregister not registered devices.

The fix could be introducing new state(s), which is equivalent to
SDEV_RUNNING, except for one thing, we know that scsi_sysfs_add_sdev() has
not been called yet.  Or a separate flag, because the state can be
SDEV_BLOCK or even something else.

Simpler way is just to check that the device is regstered in sysfs before
unregistering.  Another operations in __scsi_remove_device() seem to be
idempotent or even required, because scsi_add_lun() makes some part of
work duplicated in scsi_sysfs_add_sdev().

Signed-off-by: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Denis V. Lunev <den@openvz.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_sysfs.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/scsi_sysfs.c~scsi-fix-another-crash-at-disconnect-of-usb-strorage drivers/scsi/scsi_sysfs.c
--- a/drivers/scsi/scsi_sysfs.c~scsi-fix-another-crash-at-disconnect-of-usb-strorage
+++ a/drivers/scsi/scsi_sysfs.c
@@ -965,9 +965,17 @@ void __scsi_remove_device(struct scsi_de
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
_
