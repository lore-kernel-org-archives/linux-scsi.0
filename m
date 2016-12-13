From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH v4] scsi: avoid a permanent stop of the scsi device's request queue
Date: Tue, 13 Dec 2016 09:25:21 +0800
Message-ID: <1481592321-10796-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:27077 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932475AbcLMBWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 20:22:55 -0500
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
Reviewed-by: Ewan D. Milne <emilne@redhat.com>
---
Changes v1->v2:
- don't modify scsi_internal_device_unblock(), just remove changing
  state to SDEV_RUNNING in scsi_sysfs_add_sdev(), suggested by
  James Bottomley and Ewan D. Milne.
Changes v2->v3
- Use a clearer description of this problem
Changes v3->v4
- Remove useless change of comment about SDEV_RUNNING

 drivers/scsi/scsi_sysfs.c | 4 ----
 1 file changed, 4 deletions(-)

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
-- 
2.4.11

