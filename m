From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH v3] scsi: avoid a permanent stop of the scsi device's request queue
Date: Mon, 12 Dec 2016 10:20:17 +0800
Message-ID: <1481509217-23567-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:35652 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751646AbcLLCSA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2016 21:18:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, emilne@redhat.com, chenzengxi@huawei.com, Wei Fang <fangwei1@huawei.com>

A race between scanning and fc_remote_port_delete() may result in a
permanent stop if the device gets blocked before scsi_sysfs_add_sdev()
and unblocked after.  The reason is that blocking a device sets both
the SDEV_BLOCKED state and the QUEUE_FLAG_STOPPED.  However,
scsi_sysfs_add_sdev() unconditionally sets SDEV_RUNNING which causes
the device to be ignored by scsi_target_unblock() and thus never have
its QUEUE_FLAG_STOPPED cleared leading to a device which is apparently
running but has a stopped queue.

We actually have two places where SDEV_RUNNING is set: once in
scsi_add_lun() which respects the blocked flag and once in
scsi_sysfs_add_sdev() which doesn't.  Since the second set is entirely
spurious, simply remove it to fix the problem.

Reported-by: Zengxi Chen <chenzengxi@huawei.com>
Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
Changes v1->v2:
- don't modify scsi_internal_device_unblock(), just remove changing
  state to SDEV_RUNNING in scsi_sysfs_add_sdev(), suggested by
  James Bottomley and Ewan D. Milne.
Changes v2->v3
- Use a clearer description of this problem

 drivers/scsi/scsi_sysfs.c  | 4 ----
 include/scsi/scsi_device.h | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0734927..82dfe07 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1204,10 +1204,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	struct request_queue *rq = sdev->request_queue;
 	struct scsi_target *starget = sdev->sdev_target;
 
-	error = scsi_device_set_state(sdev, SDEV_RUNNING);
-	if (error)
-		return error;
-
 	error = scsi_target_add(starget);
 	if (error)
 		return error;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 8990e58..8bfb37f 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -31,7 +31,7 @@ struct scsi_mode_data {
 enum scsi_device_state {
 	SDEV_CREATED = 1,	/* device created but not added to sysfs
 				 * Only internal commands allowed (for inq) */
-	SDEV_RUNNING,		/* device properly configured
+	SDEV_RUNNING,		/* device properly configured and not blocked
 				 * All commands allowed */
 	SDEV_CANCEL,		/* beginning to delete device
 				 * Only error handler commands allowed */
-- 
2.4.11

