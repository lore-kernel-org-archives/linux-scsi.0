From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi_dh_emc: fix mode select request setup
Date: Wed,  2 Dec 2009 14:28:48 -0600
Message-ID: <1259785728-20419-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbZLBU2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Dec 2009 15:28:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch fixes the request setup code for mode selects. I got the fixes from
Hannes Reinecke while trying to hunt down some problems and merged it
into one patch. I am sending it because Hannes is busy with other things.

The patch fixes:
- setting of the length for mode selects.
- setting of the data direction for mode select 10.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index 6196675..63032ec 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -272,7 +272,7 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 	int len = 0;
 
 	rq = blk_get_request(sdev->request_queue,
-			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
+			(cmd != INQUIRY) ? WRITE : READ, GFP_NOIO);
 	if (!rq) {
 		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
 		return NULL;
@@ -286,14 +286,17 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 		len = sizeof(short_trespass);
 		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
+		rq->cmd[4] = len;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
 		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
+		rq->cmd[8] = len;
 		break;
 	case INQUIRY:
 		len = CLARIION_BUFFER_SIZE;
+		rq->cmd[4] = len;
 		memset(buffer, 0, len);
 		break;
 	default:
@@ -301,7 +304,6 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 		break;
 	}
 
-	rq->cmd[4] = len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			 REQ_FAILFAST_DRIVER;
-- 
1.5.2.1

