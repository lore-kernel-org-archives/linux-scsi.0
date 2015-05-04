From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/17] scsi_dh_alua: simplify sense code handling
Date: Mon,  4 May 2015 14:42:17 +0200
Message-ID: <1430743343-47174-12-git-send-email-hare@suse.de>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47365 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbbEDMml (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 May 2015 08:42:41 -0400
In-Reply-To: <1430743343-47174-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Most sense code is already handled in the generic
code, so we shouldn't be adding special cases here.
However, when doing so we need to check for
unit attention whenever we're sending an internal
command.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 38 +++---------------------------
 1 file changed, 3 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 492b721..98d4a22 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -349,28 +349,6 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * LUN Not Accessible - ALUA state transition
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0b)
-			/*
-			 * LUN Not Accessible -- Target port in standby state
-			 */
-			return SUCCESS;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0c)
-			/*
-			 * LUN Not Accessible -- Target port in unavailable state
-			 */
-			return SUCCESS;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x12)
-			/*
-			 * LUN Not Ready -- Offline
-			 */
-			return SUCCESS;
-		if (sdev->allow_restart &&
-		    sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x02)
-			/*
-			 * if the device is not started, we need to wake
-			 * the error handler to start the motor
-			 */
-			return FAILED;
 		break;
 	case UNIT_ATTENTION:
 		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
@@ -385,7 +363,7 @@ static int alua_check_sense(struct scsi_device *sdev,
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
 			/*
-			 * Mode Parameters Changed
+			 * Mode parameter changed
 			 */
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
@@ -398,18 +376,6 @@ static int alua_check_sense(struct scsi_device *sdev,
 			 * Implicit ALUA state transition failed
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
-			/*
-			 * Inquiry data has changed
-			 */
-			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
-			/*
-			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
-			 * when switching controllers on targets like
-			 * Intel Multi-Flex. We can just retry.
-			 */
-			return ADD_TO_MLQUEUE;
 		break;
 	}
 
@@ -474,6 +440,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 		}
 
 		err = alua_check_sense(sdev, &sense_hdr);
+		if (sense_hdr.sense_key == UNIT_ATTENTION)
+			err = ADD_TO_MLQUEUE;
 		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
-- 
1.8.5.2

