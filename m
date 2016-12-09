From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH v2] scsi: avoid a permanent stop of the scsi device's request queue
Date: Fri, 9 Dec 2016 17:35:38 +0800
Message-ID: <1481276138-570-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:49848 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932173AbcLIJeb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2016 04:34:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, bart.vanassche@sandisk.com, emilne@redhat.com, Wei Fang <fangwei1@huawei.com>

A scan work can run simultaneously with fc_remote_port_delete().
If a scsi device is added to the ->__devices list in the scan work,
it can be touched and will be blocked in scsi_target_block(), which
will be called in fc_remote_port_delete(), and QUEUE_FLAG_STOPPED
flag will be setted to the scsi device's request queue.

The scsi device is being setted to the SDEV_RUNNING state in
scsi_sysfs_add_sdev() at the end of the scan work. When the remote
port reappears, scsi_target_unblock() will be called, but the
QUEUE_FLAG_STOPPED flag will not be cleared, since
scsi_internal_device_unblock() ignores SCSI devices in SDEV_RUNNING
state. It results in a permanent stop of the scsi device's request
queue. Every requests sended to it will be blocked.

Since the scsi device shouldn't be unblocked in this case, fix
it by removing scsi_device_set_state() in scsi_sysfs_add_sdev().

Reported-and-tested-by: Zengxi Chen <chenzengxi@huawei.com>
Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
Changes v1->v2:
- don't modify scsi_internal_device_unblock(), just remove changing
  state to SDEV_RUNNING in scsi_sysfs_add_sdev(), suggested by
  James Bottomley and Ewan D. Milne.

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
index 8990e58..5c53cf5 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -31,7 +31,7 @@ struct scsi_mode_data {
 enum scsi_device_state {
 	SDEV_CREATED = 1,	/* device created but not added to sysfs
 				 * Only internal commands allowed (for inq) */
-	SDEV_RUNNING,		/* device properly configured
+	SDEV_RUNNING,		/* device properly initialized
 				 * All commands allowed */
 	SDEV_CANCEL,		/* beginning to delete device
 				 * Only error handler commands allowed */
-- 
2.4.11

