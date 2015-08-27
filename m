From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 15/23] scsi_dh_alua: simplify sense code handling
Date: Thu, 27 Aug 2015 14:41:13 +0200
Message-ID: <1440679281-13234-16-git-send-email-hare@suse.de>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbbH0Ml3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 08:41:29 -0400
In-Reply-To: <1440679281-13234-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Most sense code is already handled in the generic
code, so we shouldn't be adding special cases here.
However, when doing so we need to check for
unit attention whenever we're sending an internal
command.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 50 +++++++-----------------------
 1 file changed, 11 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4157fe2..dbe9ff2 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -91,7 +91,6 @@ struct alua_dh_data {
 #define ALUA_POLICY_SWITCH_ALL		1
 
 static char print_alua_state(int);
-static int alua_check_sense(struct scsi_device *, struct scsi_sense_hdr *);
 
 static void release_port_group(struct kref *kref)
 {
@@ -323,28 +322,6 @@ static int alua_check_sense(struct scsi_device *sdev,
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
@@ -359,7 +336,7 @@ static int alua_check_sense(struct scsi_device *sdev,
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
 			/*
-			 * Mode Parameters Changed
+			 * Mode Parameter Changed
 			 */
 			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06)
@@ -372,18 +349,6 @@ static int alua_check_sense(struct scsi_device *sdev,
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
 
@@ -448,9 +413,16 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg, int w
 			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
 			goto retry;
 		}
-
-		err = alua_check_sense(sdev, &sense_hdr);
-		if (err == ADD_TO_MLQUEUE && time_before(jiffies, expiry)) {
+		/*
+		 * Retry on ALUA state transition or if any
+		 * UNIT ATTENTION occurred.
+		 */
+		if (sense_hdr.sense_key == NOT_READY &&
+		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
+			err = SCSI_DH_RETRY;
+		else if (sense_hdr.sense_key == UNIT_ATTENTION)
+			err = SCSI_DH_RETRY;
+		if (err == SCSI_DH_RETRY && time_before(jiffies, expiry)) {
 			sdev_printk(KERN_ERR, sdev, "%s: rtpg retry\n",
 				    ALUA_DH_NAME);
 			scsi_print_sense_hdr(sdev, ALUA_DH_NAME, &sense_hdr);
-- 
1.8.5.6

