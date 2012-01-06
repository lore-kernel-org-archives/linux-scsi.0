From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 14/14] isci: remove IDEV_EH hack to disable
 "discovery-time" ata resets
Date: Thu, 05 Jan 2012 17:00:12 -0800
Message-ID: <20120106010012.11464.84924.stgit@localhost6.localdomain6>
References: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:35545 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030239Ab2AFBAO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jan 2012 20:00:14 -0500
In-Reply-To: <20120106005634.11464.64030.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

Prior to commit 61aaff49 "isci: filter broadcast change notifications
during SMP phy resets" we borrowed the MVS_DEV_EH approach from the
mvsas driver for preventing ->lldd_I_T_nexus_reset() events during ata
discovery.  This hack was protecting against the old ->phy_reset() in
ata_bus_probe(), but since the conversion to the new error handling this
hack is preventing resets from reaching ata devices.

Cc: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/isci/remote_device.c |    1 -
 drivers/scsi/isci/remote_device.h |    7 +++----
 drivers/scsi/isci/task.c          |    9 ++++-----
 3 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index 967394d..f83be32 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -1304,7 +1304,6 @@ void isci_remote_device_release(struct kref *kref)
 	clear_bit(IDEV_STOP_PENDING, &idev->flags);
 	clear_bit(IDEV_IO_READY, &idev->flags);
 	clear_bit(IDEV_GONE, &idev->flags);
-	clear_bit(IDEV_EH, &idev->flags);
 	smp_mb__before_clear_bit();
 	clear_bit(IDEV_ALLOCATED, &idev->flags);
 	wake_up(&ihost->eventq);
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 483ee50..98c2801 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -82,10 +82,9 @@ struct isci_remote_device {
 	#define IDEV_START_PENDING 0
 	#define IDEV_STOP_PENDING 1
 	#define IDEV_ALLOCATED 2
-	#define IDEV_EH 3
-	#define IDEV_GONE 4
-	#define IDEV_IO_READY 5
-	#define IDEV_IO_NCQERROR 6
+	#define IDEV_GONE 3
+	#define IDEV_IO_READY 4
+	#define IDEV_IO_NCQERROR 5
 	unsigned long flags;
 	struct kref kref;
 	struct isci_port *isci_port;
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index edaba78..fd9f67c 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -846,7 +846,6 @@ int isci_task_lu_reset(struct domain_device *dev, u8 *lun)
 		ret = TMF_RESP_FUNC_COMPLETE;
 		goto out;
 	}
-	set_bit(IDEV_EH, &isci_device->flags);
 
 	/* Send the task management part of the reset. */
 	if (dev_is_sata(dev)) {
@@ -981,9 +980,6 @@ int isci_task_abort_task(struct sas_task *task)
 		"%s: dev = %p, task = %p, old_request == %p\n",
 		__func__, isci_device, task, old_request);
 
-	if (isci_device)
-		set_bit(IDEV_EH, &isci_device->flags);
-
 	/* Device reset conditions signalled in task_state_flags are the
 	 * responsbility of libsas to observe at the start of the error
 	 * handler thread.
@@ -1312,7 +1308,10 @@ int isci_task_I_T_nexus_reset(struct domain_device *dev)
 	idev = isci_lookup_device(dev);
 	spin_unlock_irqrestore(&ihost->scic_lock, flags);
 
-	if (!idev || !test_bit(IDEV_EH, &idev->flags)) {
+	if (!idev) {
+		/* XXX: need to cleanup any ireqs targeting this
+		 * domain_device
+		 */
 		ret = TMF_RESP_FUNC_COMPLETE;
 		goto out;
 	}

