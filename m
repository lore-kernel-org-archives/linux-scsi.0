From: Wei Fang <fangwei1@huawei.com>
Subject: [PATCH] scsi: avoid a permanent stop of the scsi device's request queue
Date: Tue, 6 Dec 2016 17:12:27 +0800
Message-ID: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:5488 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751610AbcLFJLy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 04:11:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, tyasui@redhat.com, Wei Fang <fangwei1@huawei.com>

A scan work can run simultaneously with fc_remote_port_delete().
If a scsi device is added to the ->__devices list in the scan work,
it can be touched and will be blocked in scsi_target_block(), which
will be called in fc_remote_port_delete(), and QUEUE_FLAG_STOPPED
flag will be setted to the scsi device's request queue.

The scsi device is being setted to the SDEV_RUNNING state at the end of
the scan work. When the remote port reappears, scsi_target_unblock()
will be called, but the QUEUE_FLAG_STOPPED flag will not be cleared,
since scsi_internal_device_unblock() ignores SCSI devices in SDEV_RUNNING
state. It results in a permanent stop of the scsi device's request
queue. Every requests sended to it will be blocked.

It looks like it's a regression caused by:
commit 5c10e63c943b
("[SCSI] limit state transitions in scsi_internal_device_unblock")

Fix this by restarting the device queue if the state is SDEV_RUNNING.

Reported-by: Zengxi Chen <chenzengxi@huawei.com>
Signed-off-by: Wei Fang <fangwei1@huawei.com>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ca1f17..253ee74 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2942,7 +2942,8 @@ scsi_internal_device_unblock(struct scsi_device *sdev,
 		else
 			sdev->sdev_state = SDEV_CREATED;
 	} else if (sdev->sdev_state != SDEV_CANCEL &&
-		 sdev->sdev_state != SDEV_OFFLINE)
+		 sdev->sdev_state != SDEV_OFFLINE &&
+		 sdev->sdev_state != SDEV_RUNNING)
 		return -EINVAL;
 
 	if (q->mq_ops) {
-- 
2.4.11

