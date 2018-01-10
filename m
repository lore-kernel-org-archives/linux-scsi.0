From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Change type of third __scsi_queue_insert() argument from int into bool
Date: Wed, 10 Jan 2018 14:41:45 -0800
Message-ID: <20180110224145.25986-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:12399 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbeAJWlq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jan 2018 17:41:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>

This patch does not change any functionality but makes the SCSI core
source code slightly easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1c4d885a1d9e..dad450ccd57b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -164,7 +164,7 @@ static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
  * for a requeue after completion, which should only occur in this
  * file.
  */
-static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
+static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
 {
 	struct scsi_device *device = cmd->device;
 	struct request_queue *q = device->request_queue;
@@ -220,7 +220,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
  */
 void scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
-	__scsi_queue_insert(cmd, reason, 1);
+	__scsi_queue_insert(cmd, reason, true);
 }
 
 
@@ -1015,11 +1015,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		break;
 	case ACTION_RETRY:
 		/* Retry the same command immediately */
-		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, 0);
+		__scsi_queue_insert(cmd, SCSI_MLQUEUE_EH_RETRY, false);
 		break;
 	case ACTION_DELAYED_RETRY:
 		/* Retry the same command after a delay */
-		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, 0);
+		__scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY, false);
 		break;
 	}
 }
-- 
2.15.1
